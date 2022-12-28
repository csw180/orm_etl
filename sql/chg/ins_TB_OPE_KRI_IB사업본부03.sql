/*
  프로그램명 : ins_TB_OPE_KRI_IB사업본부03
  타켓테이블 : TB_OPE_KRI_IB사업본부03
  KRI 지표명 : 신규 후 6개월 이내 연체 발생한 여신 비율 (기업)(IB사업본부)
  협      조 : 이천수차장
  최초작성자 : 최상원
  KRI 지표명 :
     - IB사업본부-03 신규 후 6개월 이내 연체 발생한 여신 비율 (기업)(IB사업본부)
       A: 전월 말 기준 연체대출금 중 신규/재약정 일자와 연체발생의 차이가 6개월 이내인,
          5천만원 이상인 기업여신
       B: 전월 말 기준 대출금 중 신규/재약정 일자가 6개월 이내, 5천만원이상인 기업여신
          사용예)
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

    DELETE OPEOWN.TB_OPE_KRI_IB사업본부03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_IB사업본부03
    SELECT   A.STD_DT           AS 전월말일자
            ,B_1.BRNO           AS 점번호
            ,TRIM(B_1.BR_NM)    AS 점명
            ,A.CUST_NO          AS 고객번호
            ,A.INTG_ACNO        AS 계좌번호
            ,A.CLN_EXE_NO       AS 실행번호
            ,A.PDCD             AS 상품코드
            ,TRIM(PD.PRD_KR_NM) AS 상품명
            ,A.CRCD             AS 통화코드
            ,A.LN_EXE_AMT       AS 실행금액
            ,A.LN_RMD           AS 대출잔액
            ,A.FC_RMD           AS 외화잔액
            ,CASE WHEN NVL(AG.AGR_CNT, 0) IN (0, 1) THEN '신규' -- 데이터가 없는 경우에도 신규로
                  ELSE '재약정' -- 신규약정이 2번 이상이면 재약정으로
             END                AS 여신신청구분
            ,A.AGR_DT           AS 약정일자
            ,CASE WHEN A.OVD_AMT > 0 THEN 'Y'
                  ELSE 'N'
             END                AS 연체여부
            ,A.CLN_OVD_DSCD     AS 연체구분코드
            ,TRIM(CD.CMN_CD_NM) AS 연체구분코드명

            ,A.OVD_AMT          AS 연체대상금액
            ,A.OVD_OCC_DT       AS 연체발생일자

    FROM     OT_DWA_INTG_CLN_BC     A  -- DWA_통합여신기본
    JOIN     OT_DWA_DD_BR_BC        B  -- DWA_일점기본
             ON     A.BRNO           = B.BRNO
             AND    A.STD_DT         = B.STD_DT
             AND    B.BR_DSCD        = '1'
             AND    B.FSC_DSCD       = '1'         -- 은행
             AND    B.BR_KDCD        < '40'        -- 10:본부부서, 20:영업점, 30:관리점
    JOIN     OT_DWA_DD_BR_BC        B_1  -- DWA_일점기본
             ON     B.LST_MVN_BRNO   = B_1.BRNO
             AND    B.STD_DT         = B_1.STD_DT
             AND    B_1.BR_DSCD      = '1'
             AND    B_1.FSC_DSCD     = '1'         -- 은행
             AND    B_1.BR_KDCD      < '40'        -- 10:본부부서, 20:영업점, 30:관리점
    JOIN     OT_DWA_DD_ACSB_TR      C  -- DWA_일계정과목내역
             ON     A.BS_ACSB_CD     = C.ACSB_CD
             AND    A.STD_DT         = C.STD_DT
             AND    C.FSC_SNCD      IN ('K','C')
             AND    C.ACSB_CD3       = '12000401' -- 대출채권
             AND    C.ACSB_CD5      <> '14002501' -- 가계자금대출금은 제외 (기업여신만)
                          
    LEFT OUTER JOIN
             OT_DWA_CLN_PRD_STRC_BC    PD   -- DWA_여신상품구조기본
             ON     A.PDCD          = PD.PDCD
             AND    A.STD_DT        = PD.STD_DT
             
    LEFT OUTER JOIN
             (-- 신규약정을 여러 번 한 경우 재약정으로 보는 것으로 우선 추출..
              SELECT      CLN_ACNO
                         ,COUNT(*)  AS AGR_CNT
              FROM        TB_SOR_LOA_AGR_HT  -- SOR_LOA_약정이력
              WHERE       TR_STCD = '1'
              AND         CLN_APC_DSCD < '10'                     -- 여신신청구분코드(<10:신규)
              AND         ENR_DT <= P_BASEDAY
              GROUP BY    CLN_ACNO
             )   AG
             ON     A.INTG_ACNO = AG.CLN_ACNO
             
    LEFT OUTER JOIN
             OM_DWA_CMN_CD_BC CD -- DWA_공통코드기본
             ON     A.CLN_OVD_DSCD = CD.CMN_CD
             AND    CD.CMN_CD_US_YN = 'Y'
             AND    CD.TPCD_NO_EN_NM = 'CLN_OVD_DSCD'
             
    WHERE    1 = 1
    AND      A.STD_DT          =  P_BASEDAY
    AND      A.CLN_ACN_STCD    = '1'
    AND      A.BRNO            = '0328' -- 점번호(0328:IB사업본부)
    AND      MONTHS_BETWEEN( TO_DATE(A.STD_DT,'YYYYMMDD'), TO_DATE(A.AGR_DT,'YYYYMMDD') )  <= 6  -- 약정일자가 6개월이내
--    AND      (
--               ABS( MONTHS_BETWEEN( A.OVD_OCC_DT, A.AGR_DT ) ) <= 6  OR   -- 계좌의 연체시작일과 약정일자의 차이가 6개월 이내인 건
--               ABS( MONTHS_BETWEEN( A.STD_DT, A.AGR_DT ) ) <= 6      -- 전월말일자와 약정일자의 차이가 6개월 이내인 건
--              )
    AND      A.LN_RMD        >= 50000000         -- 동시에 대출잔액[실행금액, 약정금액인지 불분명 - 협의 필요]이 5천만원 이상인 건
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_IB사업본부03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
