/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀01
  타켓테이블 : TB_OPE_KRI_수신제도지원팀01
  KRI 지표명 : 휴면계좌 출금 건수
  협      조 : 이대호과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-01 휴먼계좌 출금건수
       A: 영업점/지점 관리중인 휴면계좌에서 10만원이상 출금 거래가 발생한 건수
*/
DECLARE
  P_BASEDAY  VARCHAR2(8);  -- 기준일자
  P_SOTM_DT  VARCHAR2(8);  -- 당월초일
  P_EOTM_DT  VARCHAR2(8);  -- 당월말일
  P_LD_CN    NUMBER;  -- 로딩건수

BEGIN
  SELECT  STD_DT,EOTM_DT,SUBSTR(EOTM_DT,1,6) || '01'
  INTO    P_BASEDAY
         ,P_EOTM_DT
         ,P_SOTM_DT
  FROM    OPEOWN.TB_OPE_DT_BC
  WHERE   STD_DT_YN  = 'Y';

  IF P_EOTM_DT = P_BASEDAY  THEN

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀01
    SELECT  /*+ FULL(A) FULL(B) FULL(C) FULL(J1) FULL(D)   */
             P_BASEDAY
            ,B.TR_BRNO
            ,J1.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,'Y'
            ,C.OPRF_PCS_DT
            ,B.CRCD
            ,(D.TR_PCPL + D.BSC_INT) AS 출금금액
            ,D.TR_DT
            ,A.DPS_ACN_STCD
            ,B.TR_USR_NO

    FROM     TB_SOR_DEP_DPAC_BC A   -- SOR_DEP_수신계좌기본

    JOIN     TB_SOR_DEP_TR_TR   B   -- SOR_DEP_거래내역
             ON  A.ACNO = B.ACNO
             AND B.TR_DT BETWEEN P_SOTM_DT  AND  P_EOTM_DT
             AND B.DPS_TSK_CD = '0401'  -- 0401:해지

    JOIN     TB_SOR_DEP_OPRF_TR C   -- SOR_DEP_잡수익내역
             ON  A.ACNO = C.ACNO

    JOIN     TB_SOR_CMI_BR_BC  J1   -- SOR_CMI_점기본
             ON  B.TR_BRNO = J1.BRNO
             AND J1.BR_DSCD  = '1'

    JOIN     TB_SOR_DEP_TR_DL D  -- SOR_DEP_거래상세
             ON   B.ACNO   = D.ACNO
             AND  B.TR_DT  = D.TR_DT
             AND  B.TR_SNO = D.TR_SNO
             AND  D.TR_PCPL + D.BSC_INT >= 100000

    WHERE    1=1
    AND      A.DPS_ACN_STCD IN ('14','15','18')
            -- 수신계좌상태코드(DPS_ACN_STCD):14:잡수익창구환급해지,15:잡수익자행일괄환급해지,18:관리재단지급신청
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
