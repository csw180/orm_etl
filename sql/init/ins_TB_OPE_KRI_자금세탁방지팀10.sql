/*
  프로그램명 : ins_TB_OPE_KRI_자금세탁방지팀10
  타켓테이블 : TB_OPE_KRI_자금세탁방지팀10
  KRI 지표명 : 지점의 특정비금융사업자 고객수
  협      조 : 최은영대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 자금세탁방지팀-10 지점의 특정비금융사업자 고객수
      A: 전월 중 고위험 영업점/지점의 특정비금융사업자 고객수 확인
         기준월 중 영업점/지점의 특정비금융사업자 고객수
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

    DELETE OPEOWN.TB_OPE_KRI_자금세탁방지팀10
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_자금세탁방지팀10
    SELECT   P_BASEDAY
            ,A.BLNT_BRNO
            ,J.BR_NM
            ,A.CUST_NO
            ,'DNFBPs'
            ,TO_CHAR(A.VRF_ENR_DTTM,'YYYYMMDD')
            ,A.KYC_SNO
    FROM     TB_SOR_CUS_KYC_TR A    -- SOR_CUS_KYC내역
    JOIN     TB_SOR_CUS_MAS_BC B    -- SOR_CUS_고객기본
             ON  A.CUST_NO = B.CUST_NO
    JOIN     TB_SOR_CUS_PRV_DL C    -- SOR_CUS_개인고객상세
             ON  A.CUST_NO = C.CUST_NO
             AND C.JB_CD IN ( SELECT DISTINCT CD_CTS
                              FROM TB_SOR_CUS_KYC_RSK_BC    --  SOR_CUS_KYC위험우선적용기본
                              WHERE KYC_RSK_PFRD_APL_DSCD = '08'
                             )  -- 특정비금융사업자(당연EDD대상 직업코드)
    JOIN     TB_SOR_CMI_BR_BC    J   -- SOR_CMI_점기본
             ON    A.ENR_BRNO   = J.BRNO
             AND   J.BR_DSCD = '1'
        --     AND  (CLBR_DT IS NULL OR CLBR_DT >= '20220430')
        --         AND  (CLBR_DT IS NULL OR CLBR_DT > P_BASEDAY)
    WHERE    1=1
    AND      TO_CHAR(A.VRF_ENR_DTTM,'YYYYMMDD') BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND      A.CUST_CNFM_LBL_CMPL_YN = 'Y'
    AND      A.TR_BR_DSCD    = '1'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_자금세탁방지팀10',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








