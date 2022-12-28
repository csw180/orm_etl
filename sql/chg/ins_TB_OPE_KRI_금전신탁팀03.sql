/*
  프로그램명 : ins_TB_OPE_KRI_금전신탁팀03
  타켓테이블 : TB_OPE_KRI_금전신탁팀03
  KRI 지표명 : 만65세 이상 신규 신탁금액
  협      조 : 추유정과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 금전신탁팀-03 만65세 신규 신탁 금액
       A: 전월 신규된 만 65세 이상 고객의 신탁 계좌 금액의 합
     - 금전신탁팀-04 만65세 신규 신탁 건수
       A: 전월 신규된 만 65세 이상 고객의 신탁 상품 신규 가입 건수
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

    DELETE OPEOWN.TB_OPE_KRI_금전신탁팀03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_금전신탁팀03
    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.CUST_NO
            ,CASE WHEN LENGTH(TRIM(A.CUST_RNNO)) = 13 THEN
                      CASE WHEN SUBSTR(A.CUST_RNNO, 3, 4) > SUBSTR(A.NW_DT, 5, 4) THEN
                               CASE WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '3', '4', '7', '8' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('20'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                    WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '9', '0' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('18'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                    ELSE CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('19'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                               END
                           ELSE
                               CASE WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '3', '4', '7', '8' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('20'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                    WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '9', '0' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('18'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                    ELSE CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('19'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                               END
                      END
                  ELSE 999
             END    AS  AGE   -- 만나이
            ,A.ACNO           -- 계좌번호
            ,B.DTL_CND_DESC   -- 상품위험등급코드
            ,PD.PRD_KR_NM     -- 상품명
            ,'KRW'            -- 통화코드
            ,C.TR_AMT         -- 가입금액
            ,A.NW_DT          -- 계좌신규일자
            ,A.EXPI_DT        -- 계좌만기일자
    FROM     OT_DWA_INTG_DPS_BC A    -- DWA_통합수신기본
    JOIN     (
              SELECT B.PDCD
                    ,C.DTL_CND_DESC
              FROM   TB_SOR_PDF_CND_TP_CMPS_BC A  -- SOR_PDF_조건유형구성기본
              JOIN   TB_SOR_PDF_CND_TP_RLT_DL  B  -- SOR_PDF_상품조건유형관계상세
                     ON   A.CND_TP_ADM_NO = B.CND_TP_ADM_NO
                     AND  B.APL_STCD = '10'
              JOIN   TB_SOR_PDF_DTL_CND_TP_BC C   -- SOR_PDF_상세조건유형기본
                     ON   A.MN_DTL_CND_ADM_NO = C.DTL_CND_ADM_NO
                     AND  C.APL_STCD = '10'
              WHERE  1=1
              AND    A.MN_DTL_CND_ADM_NO like 'C192%'
              AND    A.APL_STCD = '10'
             ) B
             ON    A.PDCD = B.PDCD

    JOIN     TB_SOR_CMI_BR_BC    J   -- SOR_CMI_점기본
             ON    A.ADM_BRNO   = J.BRNO
             AND   J.BR_DSCD    = '1'   -- 1.중앙회, 2.조합
             
    JOIN     TB_SOR_DEP_TR_TR   C   -- SOR_DEP_거래내역
             ON    A.ACNO   = C.ACNO
             AND   A.NW_DT  = C.TR_DT
             AND   C.DPS_TSK_CD = '0101'

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD   -- SOR_PDF_상품기본
             ON     A.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE    1=1
    AND      A.STD_DT = P_BASEDAY
    AND      A.DPS_DP_DSCD = '5'
    AND      A.ACNO  NOT LIKE '176%'
    AND      A.DPS_ACN_STCD NOT IN ('99', '98')
    AND      CASE WHEN LENGTH(TRIM(A.CUST_RNNO)) = 13 THEN
                      CASE WHEN SUBSTR(A.CUST_RNNO, 3, 4) > SUBSTR(A.NW_DT, 5, 4) THEN
                               CASE WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '3', '4', '7', '8' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('20'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                    WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '9', '0' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('18'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                    ELSE CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('19'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                               END
                           ELSE
                               CASE WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '3', '4', '7', '8' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('20'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                    WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '9', '0' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('18'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                    ELSE CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('19'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                               END
                      END
                  ELSE 999
             END  BETWEEN 65  AND  900
    AND      A.NW_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT
		;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_금전신탁팀03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


