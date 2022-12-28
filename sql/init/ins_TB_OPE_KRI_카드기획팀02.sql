/*
  프로그램명 : ins_TB_OPE_KRI_카드기획팀02
  타켓테이블 : TB_OPE_KRI_카드기획팀02
  KRI 지표명 : 신규 후 3개월 이내 신용카드 연체회원 비율
  협      조 : 양미나차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 카드기획팀-02 신규 후 3개월 이내 신용카드 연체회원 비율
       A: 전월말 시점 3개월 이전에 입회한 개인고객 및 기업고객(갱신입회포함)중 월말시점에
          15일 이상 연체중인 회원수
       B: 전월 말 시점 3개월 이전에 입회한 개인고객 및 기업고객 수
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

    DELETE OPEOWN.TB_OPE_KRI_카드기획팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_카드기획팀02

    SELECT   A.STD_DT
            ,B.CRD_MBR_ADM_BRNO
            ,J1.BR_NM
            --,A.CRD_MBR_NO
            ,C.CRD_PRD_DSCD         -- 카드상품구분코드
            --,CD1.CMN_CD_NM         -- 카드상품구분코드명
            ,C.ISN_DT             -- 발급일자
            --,B.CRD_MBR_DSCD
            ,B.MBR_NW_DT
            ,A.OVD_ST_DT
            ,A.OVD_AMT
            ,B.PREN_DSCD             -- 개인기업구분코드
            --,TRIM(CD2.CMN_CD_NM)     -- 개인기업구분코드명

    FROM     (
              SELECT   A.STD_DT
                      ,A.CRD_MBR_NO
                      ,SUM(A.TOT_OVD_PCPL)     AS  OVD_AMT   -- 원금연체금액
                      ,MIN(A.OVD_ST_DT)        AS  OVD_ST_DT -- 원금연체시작일자
              FROM     OT_DWA_CRD_CLN_BC   A   -- DWA_카드여신기본
              WHERE    1=1
              AND      A.STD_DT  =  P_BASEDAY
              GROUP BY A.STD_DT
                      ,A.CRD_MBR_NO
             )   A

    JOIN     TB_SOR_CLT_MBR_BC     B   -- SOR_CLT_회원기본
             ON   A.CRD_MBR_NO  =   B.CRD_MBR_NO

    JOIN     TB_SOR_CLT_CRD_BC     C   -- SOR_CLT_카드기본
             ON   A.CRD_MBR_NO  =   C.CRD_MBR_NO
             AND  C.ISN_DT >=  TO_CHAR(ADD_MONTHS(TO_DATE(P_BASEDAY, 'YYYYMMDD'), -3), 'YYYYMMDD') -- 발급일자 3개월 이내

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
             ON  B.CRD_MBR_ADM_BRNO   =  J1.BRNO
--           AND J1.BR_DSCD = '1'      -- 은행

/*
    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_공통코드기본
               WHERE   TPCD_NO_EN_NM = 'CRD_PRD_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD1
             ON    C.CRD_PRD_DSCD = CD1.CMN_CD

    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC
               WHERE   TPCD_NO_EN_NM = 'PREN_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD2
             ON    B.PREN_DSCD = CD2.CMN_CD
*/
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_카드기획팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
