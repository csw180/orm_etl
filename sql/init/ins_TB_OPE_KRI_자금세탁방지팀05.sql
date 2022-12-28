/*
  프로그램명 : ins_TB_OPE_KRI_자금세탁방지팀05
  타켓테이블 : TB_OPE_KRI_자금세탁방지팀05
  KRI 지표명 : 지점의 개인고객 중 EDD 고객 수
  협      조 : 최은영대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 자금세탁방지팀-05 지점의 개인고객 중 EDD 고객 수
       A: 전월 중 개인고객 EDD 해당 건수 고위험 영업점/지점들의 지표 총계
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

    DELETE OPEOWN.TB_OPE_KRI_자금세탁방지팀05
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_자금세탁방지팀05
    SELECT   P_BASEDAY
            ,BLNT_BRNO  -- 점번호
            ,B.BR_NM
            ,A.CUST_NO  -- 고객번호
            ,A.KYC_SNO  -- KYC일련번호
    FROM     TB_SOR_CUS_KYC_TR   A   -- SOR_CUS_KYC내역
    JOIN     TB_SOR_CMI_BR_BC    B   -- SOR_CMI_점기본
             ON    A.ENR_BRNO   = B.BRNO
             AND   B.BR_DSCD = '1'
--             AND  (B.CLBR_DT IS NULL OR B.CLBR_DT >= '20220401')
--             AND  (CLBR_DT IS NULL OR CLBR_DT >= P_BASEDAY)
    JOIN     TB_SOR_CUS_MAS_BC   C   -- SOR_CUS_고객기본
             ON    A.CUST_NO  =  C.CUST_NO
             AND   (
                     C.CUST_DSCD = '01'   OR
                     ( C.CUST_DSCD = '02' AND (C.PSNL_CD ='1101' OR C.PSNL_CD ='1102') ) OR
                     C.CUST_DSCD = '03'   OR
                     ( C.CUST_DSCD = '07' AND (C.PSNL_CD ='1101' OR C.PSNL_CD ='1102' OR C.PSNL_CD IS NULL) )
                   )
    WHERE    1=1
    AND      TO_CHAR(VRF_ENR_DTTM,'YYYYMMDD') BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND      A.CUST_CNFM_LBL_CMPL_YN = 'Y'   -- 고객확인의무완료여부
    AND      A.TR_BR_DSCD = '1'  -- 거래점구분코드
    AND      A.KYC_TGT_RSCD NOT IN ('01','02')    --고객알기제도대상사유코드, IN이면 CDD / NOT IN 이면 EDD
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_자금세탁방지팀05',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








