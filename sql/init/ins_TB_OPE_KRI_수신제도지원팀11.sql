/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀11
  타켓테이블 : TB_OPE_KRI_수신제도지원팀11
  KRI 지표명 : 업무시간 외 중도해지 건수
  협      조 : 이대호과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-11 업무시간외 중도해지건수
       A: 전월중 거래시간 08:30 이전및 17:00 이후 발생한 건당 해지금액 5백만원 이상 중도해지건수
          - 08:30 이전, 17:00 이후 중도해지계좌
          - 만기의 개념이 있는 모든 수신계좌
          - 은행계정만 해당
          - 원금 + 이자
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
  FROM   DWZOWN.OM_DWA_DT_BC
  WHERE   STD_DT = '&1';
  
  IF P_EOTM_DT = P_BASEDAY  THEN

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀11
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀11
    SELECT  /*+ FULL(A) FULL(B) FULL(D) FULL(J1) FULL(E)   */
             P_BASEDAY
            ,B.TR_BRNO
            ,J1.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,A.DPS_DP_DSCD
            ,A.NW_DT
            ,A.EXPI_DT
            ,B.TR_DT
            ,B.TR_TM
            ,B.CRCD
            ,E.LDGR_RMD
            ,(D.TR_PCPL + D.BSC_INT) AS 출금금액
            ,B.TR_USR_NO

    FROM     TB_SOR_DEP_DPAC_BC A   -- SOR_DEP_수신계좌기본

    JOIN     TB_SOR_DEP_TR_TR   B   -- SOR_DEP_거래내역
             ON  A.ACNO = B.ACNO
             AND B.TR_DT BETWEEN P_SOTM_DT  AND  P_EOTM_DT
             AND ( B.TR_TM < '083000'  OR  B.TR_TM > '170000' )
             AND B.CHNL_TPCD = 'TTML'
             AND B.DPS_TSK_CD = '0401'  -- 0401:해지

    JOIN     TB_SOR_DEP_TR_DL D  -- SOR_DEP_거래상세
             ON   B.ACNO   = D.ACNO
             AND  B.TR_DT  = D.TR_DT
             AND  B.TR_SNO = D.TR_SNO
             AND  D.TR_PCPL + D.BSC_INT >= 5000000

    JOIN     TB_SOR_DEP_DPAC_CUR_BC E  -- SOR_DEP_수신계좌통화기본
             ON   A.ACNO   = E.ACNO

    JOIN     TB_SOR_CMI_BR_BC  J1   -- SOR_CMI_점기본
             ON  B.TR_BRNO = J1.BRNO
             AND J1.BR_DSCD  = '1'

    WHERE    1=1
    AND      ( A.DPS_ACN_STCD = '33' OR  B.SPLT_CNCN_YN = 'Y' )
    AND      A.DPS_DP_DSCD = '2'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀11',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








