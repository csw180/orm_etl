/*
  프로그램명 : ins_TB_OPE_KRI_론리뷰팀01
  타켓테이블 : TB_OPE_KRI_론리뷰팀01
  KRI 지표명 : 전결여신 '부적정' 판정 등급 부여 차주 건수
  협      조 : 선민국차장
  최조작성자 : 최상원
  KRI 지표명 :
   - 론리뷰팀-01 전결여신 '부적정' 판정 등급 부여 차주 건수
     A: 전월말 기준 여신감리역 감리결과 제규정 및 여신업무취급세칙 등의 위반사항 등
        관리계획 수립이 필요한 의견(보완,부적정)을 부여한 건수
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

    DELETE OPEOWN.TB_OPE_KRI_론리뷰팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_론리뷰팀01
    SELECT   P_BASEDAY
            ,B.BRNO
            ,D.BR_NM
            ,C.ACN_DCMT_NO
            ,B.CUST_NO
            ,B.CUST_DSCD
            ,B.APCL_DSCD
            ,C.LN_SBCD
            ,B.CRCD
            ,B.APRV_AMT
            ,B.TOT_CLN_RMD
            ,B.CLN_APRV_DT
            ,C.APRV_LN_EXPI_DT
            ,DECODE(A.LNRV_JDGM_DSCD,'03','보안','04','부적정') AS LNRV_JDGM_DSCD
            ,A.HDQ_JDGM_OPNN_CTS
            ,A.JDGM_DT

    FROM     TB_SOR_EWL_LN_XCLN_JDGM_TR A   -- SOR_EWL_론리뷰전결여신판정내역

    JOIN     TB_SOR_EWL_LN_XCDC_CLN_BC  B   -- SOR_EWL_론리뷰전결여신기본
             ON   A.TGT_ABST_DT = B.TGT_ABST_DT
             AND  A.CLN_APC_NO  = B.CLN_APC_NO

    JOIN     TB_SOR_CLI_CLN_APRV_BC C       -- SOR_CLI_여신승인기본
             ON   A.CLN_APC_NO = C.CLN_APC_NO

    JOIN     TB_SOR_CMI_BR_BC D     -- SOR_CMI_점기본
             ON   B.BRNO = D.BRNO
             AND  D.BR_DSCD = '1'   -- 1.중앙회, 2.조합             

    WHERE    1=1
    AND      A.TGT_ABST_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      A.LNRV_JDGM_DSCD IN ('03','04')  -- 론리뷰판정구분코드(03:보완,04:부적정)
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_론리뷰팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

