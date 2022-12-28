/*
  프로그램명 : ins_TB_OPE_KRI_외환지원팀05
  타켓테이블 : TB_OPE_KRI_외환지원팀05
  KRI 지표명 : 외화대출사용내역 확인등록 누락 건수
  협      조 : 선민국차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 외환지원팀-05 :  외화대출사용내역 확인등록 누락 건수
       A: 외화대출 취급 후 1개월 초과한 건중 외화대출 사용내역 확인등록이 미실시된 건수
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

    DELETE OPEOWN.TB_OPE_KRI_외환지원팀05
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_외환지원팀05

    SELECT   P_BASEDAY
            ,A.BRNO
            ,J1.BR_NM
            ,A.CUST_NO
            ,A.CUST_DSCD
            ,A.ACN_DCMT_NO
            ,PD.PRD_KR_NM
            ,A.CRCD
            ,A.APRV_AMT
            ,A.CLN_EXE_NO
            ,B.LN_EXE_AMT
            ,A.LN_EXE_DT
            ,'N' AS  사후점검완료여부
            ,TO_CHAR(ADD_MONTHS(TO_DATE(A.AGR_DT,'YYYYMMDD'),1),'YYYYMMDD') AS 사후점검기한
            ,CHKG_DT

    FROM     TB_SOR_EWL_LN_USMU_CHK_BC A  -- SOR_EWL_론리뷰용도유용점검기본

    JOIN     TB_SOR_LOA_EXE_BC B          -- SOR_LOA_실행기본
             ON    A.ACN_DCMT_NO = B.CLN_ACNO
             AND   A.CLN_EXE_NO  = B.CLN_EXE_NO

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
             ON    A.BRNO  =  J1.BRNO
             AND   J1.BR_DSCD = '1'   -- 1.중앙회, 2.조합
             
    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD    -- SOR_PDF_상품기본
             ON     B.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE    1=1
    AND      A.TGT_ABST_DT <  TO_CHAR(ADD_MONTHS(LAST_DAY(ADD_MONTHS(TO_DATE(P_BASEDAY,'YYYYMMDD') ,-1)),-1) ,'YYYYMMDD')
             /* 전월말 기준 1개월 지났는데 미점검 대상*/
    AND      A.ACK_TGT_YN = 'Y'
    AND      A.CRCD !='KRW'
    AND      A.CHKG_DT IS NULL
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_외환지원팀05',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
