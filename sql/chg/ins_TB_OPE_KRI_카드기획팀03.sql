/*
  프로그램명 : ins_TB_OPE_KRI_카드기획팀03
  타켓테이블 : TB_OPE_KRI_카드기획팀03
  KRI 지표명 : 카드신규/한도상향 후 연체 발생 회원수(개인)
  협      조 : 양미나차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 카드기획팀-02 카드신규/한도상향 후 연체 발생 회원수(개인)
       A: 카드 신규 발급 후 6개월 이내인 회원 중 1개월 이상 연체중인 개인고객수
       B: 카드 한도상향 후 6개월 이내인 회원중 1개월 이상 연체중인 개인 고객수
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

    DELETE OPEOWN.TB_OPE_KRI_카드기획팀03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_카드기획팀03
    SELECT   A.STD_DT           AS 기준일자
            ,B.CRD_MBR_ADM_BRNO AS 점번호
            ,D.BR_NM            AS 점명
            ,B.CRD_MBR_DSCD     AS 카드회원구분코드
            --,CD1.CMN_CD_NM      AS 카드회원구분명
            ,A.TOT_OVD_PCPL     AS 연체금액
            ,NULL               AS 한도변경사유코드
            ,NULL               AS 한도변경일자
            ,C.ISN_DT           AS 카드발급일자
            ,B.MBR_NW_DT        AS 회원신규일자
            ,A.OVD_ST_DT        AS 연체시작일자
            ,B.PREN_DSCD        AS 개인기업구분코드
            --,TRIM(CD2.CMN_CD_NM)     -- 개인기업구분코드명

    FROM     (
              SELECT  STD_DT
                     ,CRD_MBR_NO
                     ,SUM(TOT_OVD_PCPL) AS TOT_OVD_PCPL
                     ,MIN(OVD_ST_DT)    AS OVD_ST_DT
              FROM    OT_DWA_CRD_CLN_BC X   /* DWA_카드여신기본 */
              WHERE   STD_DT  =  P_BASEDAY
              AND     EXISTS (
                              SELECT 1
                              FROM OT_DWA_CRD_CLN_BC
                              WHERE STD_DT     = X.STD_DT
                              AND CRD_MBR_NO = X.CRD_MBR_NO
                              AND TOT_OVD_PCPL > 0
                              AND MONTHS_BETWEEN(TO_DATE(SUBSTR(STD_DT,1,6),'YYYYMM'), TO_DATE(SUBSTR(OVD_ST_DT,1,6),'YYYYMM')) >= 1
                             )  -- 1개월 이상 연체중
              GROUP BY STD_DT, CRD_MBR_NO
             ) A

    JOIN     TB_SOR_CLT_MBR_BC B    /* SOR_CLT_회원기본 */
             ON  A.CRD_MBR_NO = B.CRD_MBR_NO
             AND B.PREN_DSCD  = '1'  -- 개인기업구분코드 : 1-개인

    JOIN     TB_SOR_CLT_CRD_BC C    /* SOR_CLT_카드기본 */
             ON  A.CRD_MBR_NO   =  C.CRD_MBR_NO
             AND C.ISN_DT    >= TO_CHAR(ADD_MONTHS(TO_DATE(A.STD_DT,'YYYYMMDD'), -6), 'YYYYMMDD')  -- 발급일자 6개월 이내

    JOIN     TB_SOR_CMI_BR_BC  D    /* SOR_CMI_점기본 */
             ON  B.CRD_MBR_ADM_BRNO = D.BRNO

    JOIN     TB_SOR_CUS_MAS_BC E    /* SOR_CUS_고객기본 */
             ON  B.CUST_NO = E.CUST_NO
/*
    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_공통코드기본
               WHERE   TPCD_NO_EN_NM = 'CRD_MBR_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD1
             ON    B.CRD_MBR_DSCD = CD1.CMN_CD

    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC
               WHERE   TPCD_NO_EN_NM = 'PREN_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD2
             ON    B.PREN_DSCD = CD2.CMN_CD
*/

    UNION ALL

    SELECT   A.STD_DT           AS 기준일자
            ,B.CRD_MBR_ADM_BRNO AS 점번호
            ,D.BR_NM            AS 점명
    --        ,B.CUST_NO          AS 고객번호
    --        ,E.CUST_NM          AS 고객명
    --        ,A.CRD_MBR_NO       AS 카드회원번호
            ,B.CRD_MBR_DSCD     AS 카드회원구분코드
            --,CD1.CMN_CD_NM      AS 카드회원구분명
            ,A.TOT_OVD_PCPL     AS 연체금액
            ,F.LMT_CHG_RSCD     AS 한도변경사유코드
            --,CD3.CMN_CD_NM      AS 한도변경사유
            ,F.LMT_CHG_DT       AS 한도변경일자
            ,NULL               AS 발급일자
            ,B.MBR_NW_DT        AS 회원신규일자
            ,A.OVD_ST_DT        AS 연체시작일자
            ,B.PREN_DSCD        AS 개인기업구분코드
            --,TRIM(CD2.CMN_CD_NM)     -- 개인기업구분코드명

    FROM     (
              SELECT  STD_DT
                     ,CRD_MBR_NO
                     ,SUM(TOT_OVD_PCPL) AS TOT_OVD_PCPL
                     ,MIN(OVD_ST_DT)    AS OVD_ST_DT
              FROM    OT_DWA_CRD_CLN_BC X   /* DWA_카드여신기본 */
              WHERE   STD_DT  =  P_BASEDAY
              AND     EXISTS (
                              SELECT 1
                              FROM OT_DWA_CRD_CLN_BC
                              WHERE STD_DT     = X.STD_DT
                              AND CRD_MBR_NO = X.CRD_MBR_NO
                              AND TOT_OVD_PCPL > 0
                              AND MONTHS_BETWEEN(TO_DATE(SUBSTR(STD_DT,1,6),'YYYYMM'), TO_DATE(SUBSTR(OVD_ST_DT,1,6),'YYYYMM')) >= 1
                             )  -- 1개월 이상 연체중
              GROUP BY STD_DT, CRD_MBR_NO
             ) A

    JOIN     TB_SOR_CLT_MBR_BC B    /* SOR_CLT_회원기본 */
             ON  A.CRD_MBR_NO  =  B.CRD_MBR_NO
             AND B.PREN_DSCD  = '1'  -- 개인기업구분코드 : 1-개인

    JOIN     TB_SOR_CMI_BR_BC  D    /* SOR_CMI_점기본 */
             ON  B.CRD_MBR_ADM_BRNO =  D.BRNO

    JOIN     TB_SOR_CUS_MAS_BC E    /* SOR_CUS_고객기본 */
             ON  B.CUST_NO = E.CUST_NO

    JOIN     TB_SOR_MBR_LMT_CHG_HT F  /* SOR_MBR_카드고객한도변경이력 */
             ON A.CRD_MBR_NO     = F.CRD_MBR_NO
             AND F.LMT_CHG_HDCD  = '11'             -- 한도변경항목코드(14:국내특별한도)
             AND SUBSTR(F.LMT_CHG_RSCD, 1, 1) IN ('2', '6', '8')  -- 한도변경사유코드(증액)
             AND F.LMT_CHG_DT  >= TO_CHAR(ADD_MONTHS(TO_DATE(A.STD_DT,'YYYYMMDD'), -6), 'YYYYMMDD')  -- 한도변경일자 6개월 이내
/*
    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_공통코드기본
               WHERE   TPCD_NO_EN_NM = 'CRD_MBR_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD1
             ON    B.CRD_MBR_DSCD = CD1.CMN_CD

    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC
               WHERE   TPCD_NO_EN_NM = 'PREN_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD2
             ON    B.PREN_DSCD = CD2.CMN_CD

    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_공통코드기본
               WHERE   TPCD_NO_EN_NM = 'LMT_CHG_RSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD3
             ON    F.LMT_CHG_RSCD = CD3.CMN_CD
*/
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_카드기획팀03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

