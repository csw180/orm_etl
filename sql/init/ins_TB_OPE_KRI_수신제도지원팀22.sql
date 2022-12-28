/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀22
  타켓테이블 : TB_OPE_KRI_수신제도지원팀22
  KRI 지표명 : 고액예금 계좌 중도해지 명세
  협      조 : 이대호과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-22 고액예금 계좌 중도해지 명세
       A: 1억원 이상의 고액예금 중 중도해지된 계좌 수
     - 수신제도지원팀-24 3천만원 이상 예금 중도해지 건수
       A: 3천만원 이상의 예금계좌 중도해지 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀22
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀22
    SELECT  /*+ FULL(A) FULL(B) FULL(C) FULL(D)   */
             P_BASEDAY
            ,B.TR_BRNO
            ,C.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,A.DPS_DP_DSCD
            ,B.CRCD
            ,D.TR_PCPL + D.BSC_INT AS 거래금액
            ,A.NW_DT
            ,A.EXPI_DT
            ,A.CNCN_DT

    FROM     TB_SOR_DEP_DPAC_BC A   -- SOR_DEP_수신계좌기본

    JOIN     TB_SOR_DEP_TR_TR B    -- SOR_DEP_거래내역
             ON   A.ACNO = B.ACNO
             AND  B.TR_DT  BETWEEN  P_SOTM_DT AND P_EOTM_DT
             AND  B.CHNL_TPCD = 'TTML'
             AND  B.DPS_TSK_CD = '0401'  -- 해지거래
             AND  B.DPS_TR_STCD = '1'

    JOIN     TB_SOR_CMI_BR_BC C    -- SOR_CMI_점기본
             ON   B.TR_BRNO = C.BRNO
             AND  C.BR_DSCD  = '1'

    JOIN     TB_SOR_DEP_TR_DL D    -- SOR_DEP_거래상세
             ON   B.ACNO   = D.ACNO
             AND  B.TR_DT  = D.TR_DT
             AND  B.TR_SNO = D.TR_SNO
             AND  D.TR_PCPL + D.BSC_INT >= 30000000  -- 원금+이자 3천만원이상

    WHERE    1=1
    AND      A.DPS_DP_DSCD = '2'     
    AND      A.DPS_ACN_STCD = '33'   -- 33:중도해지
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀22',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT



