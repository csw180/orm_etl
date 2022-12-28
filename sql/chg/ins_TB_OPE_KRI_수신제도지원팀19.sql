/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀19
  타켓테이블 : TB_OPE_KRI_수신제도지원팀19
  협      조 : 이효정과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀19 : 기한부예금 신규 취소 건수
       A: 월중 영업점 발생 기한부예금 신규건중 당일 신규 취소 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀19
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀19
    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.ACNO
            ,A.CUST_NO
            ,PD.PRD_KR_NM
            ,A.NW_DT
            ,C.TR_DT
            ,C.RCFM_DT
            ,C.TR_USR_NO

    FROM     OT_DWA_INTG_DPS_BC  A    -- DWA_통합수신기본

    JOIN     TB_SOR_CMI_BR_BC J       -- SOR_CMI_점기본
             ON   A.ADM_BRNO = J.BRNO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC  PD   -- SOR_PDF_상품기본
             ON   A.PDCD   = PD.PDCD
             AND  PD.APL_STCD  =  '10'

    LEFT OUTER JOIN
             TB_SOR_DEP_TR_TR  C    -- SOR_DEP_거래내역
             ON   A.ACNO   =  C.ACNO
             AND  A.NW_DT  =  C.RCFM_DT
             AND  C.DPS_TSK_CD = '0101'
             AND  C.DPS_TR_STCD  =  '2'  -- 수신거래상태코드(2:정정)

    WHERE    1=1
    AND      A.STD_DT  = P_BASEDAY
    AND      A.ACNO  <  '20000000000'   -- 은행상품
    AND      A.DPS_DP_DSCD  IN  ('2','4')  -- 기한부예금(2:원화저축성, 4:외화저축성)
    AND      A.DPS_ACN_STCD  =  '98'     -- 수신계좌상태코드 98:신규정정
    AND      A.NW_DT  BETWEEN  P_SOTM_DT  AND  P_EOTM_DT

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀19',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


