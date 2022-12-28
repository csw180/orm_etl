/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀06
  타켓테이블 : TB_OPE_KRI_여신지원팀06
  KRI 지표명 : 자금용도 외 유용 사후점검 기한경과 건수
  협      조 : 선민국차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-06 :  자금용도 외 유용 사후점검 기한경과 건수
       A: 전월말 기준 자금용도 사후점검대상 대출 중 대출 취급 후 3개월 이내 대출금 사용내역표 미징구
          및 방문하여 대출금 사용내역 미점검한 건수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀06
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀06
    WITH  TEMP AS
    (
     SELECT   P_BASEDAY  AS  STD_DT
             ,A.BRNO
             ,J1.BR_NM
             ,A.CUST_NO
             ,A.CUST_DSCD
             ,A.ACN_DCMT_NO
             ,PD.PRD_KR_NM
             ,A.CRCD
             ,A.APRV_AMT
             ,A.TOT_CLN_RMD
             ,A.AGR_DT
             ,A.EXPI_DT
             ,A.ACK_TGT_YN   -- 용도사후점검대상여부
             ,TO_CHAR(ADD_MONTHS(TO_DATE(A.AGR_DT,'YYYYMMDD'),3),'YYYYMMDD') AS 사후점검기한
             ,CHKG_DT        -- 사후점검완료일
             ,ROW_NUMBER() OVER(PARTITION BY ACN_DCMT_NO ORDER BY TGT_ABST_DT DESC,CLN_APC_NO DESC) AS 순서
              -- 동일계좌번호가 실행번호별로 여러건 나오는 현상있음
              -- 계좌수를 확인하기 용이하게 계좌번호별로 최근꺼 하나만 가져오기 위함
     FROM     TB_SOR_EWL_LN_USMU_CHK_BC A   -- SOR_EWL_론리뷰용도유용점검기본

     JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
              ON    A.BRNO  =  J1.BRNO

     JOIN     TB_SOR_LOA_ACN_BC   B   -- SOR_LOA_계좌기본
              ON    A.ACN_DCMT_NO  =  B.CLN_ACNO

     LEFT OUTER JOIN
              TB_SOR_PDF_PRD_BC    PD    -- SOR_PDF_상품기본
              ON     B.PDCD  =   PD.PDCD
              AND    PD.APL_STCD  =  '10'

     WHERE    TGT_ABST_DT <  TO_CHAR(ADD_MONTHS(LAST_DAY(ADD_MONTHS(TO_DATE(P_BASEDAY,'YYYYMMDD') ,-1)),-3) ,'YYYYMMDD') 
           -- 전월말 기준 3개월 지났는데 미점검 대상
     AND      ACK_TGT_YN = 'Y'     -- 용도사후점검대상여부
     AND      CHKG_DT IS NULL      -- 용도사후점검완료일
    )
    SELECT    STD_DT
             ,BRNO
             ,BR_NM
             ,CUST_NO
             ,CUST_DSCD
             ,ACN_DCMT_NO
             ,PRD_KR_NM
             ,CRCD
             ,APRV_AMT
             ,TOT_CLN_RMD
             ,AGR_DT
             ,EXPI_DT
             ,ACK_TGT_YN
             ,DECODE(CHKG_DT,NULL,'N','Y')   -- 사후점검여부
             ,사후점검기한
             ,CHKG_DT
    FROM      TEMP
    WHERE     1=1
    AND       순서 = 1
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀06',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

