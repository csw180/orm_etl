/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀21
  타켓테이블 : TB_OPE_KRI_여신지원팀21
  KRI 지표명 : SMS 및 전화 수신거부 등록 고객수
  협      조 : 김현민
  최조작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-21 SMS 및 전화 수신거부 등록 고객수
       A: '전화통화거부' 등록 고객수
       B: 'SMS수신거부' 등록 소객수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀21
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀21

    SELECT   A.STD_DT                                                 AS 기준일자
            ,A.BRNO                                                   AS 점번호
            ,A.BR_NM                                                  AS 점명
            ,A.CUST_NO                                                AS 고객번호
            ,E.CUST_INF_CHG_SNO                                       AS 고객정보변경일련번호
            ,A.INTG_ACNO                                              AS 계좌번호
            ,A.PDCD                                                   AS 상품코드
            ,A.PRD_KR_NM                                              AS 상품명
            ,A.CRCD                                                   AS 통화코드
            ,A.SUM_LN_RMD                                             AS 대출잔액
            ,NVL(E.TL_RCV_DEN_YN,'N')                                 AS 전화통화거부여부
            ,E.TL_RCV_ENR_DT                                          AS 전화통화거부등록일시
            ,NVL(E.SMS_RCV_DEN_YN,'N')                                AS SMS수신거부여부
            ,E.SMS_RCV_ENR_DT                                         AS SMS수신거부등록일시
            ,E.ENR_USR_NO                                             AS 등록사용자번호
    FROM     (
              SELECT   /*+ FULL(A) FULL(AA) FULL(A_1) FULL(B) FULL(B_1) FULL(C) */
                       A.STD_DT
                      ,A.CUST_NO
                      ,A.INTG_ACNO
                      ,B_1.BRNO
                      ,TRIM(B_1.BR_NM)        AS BR_NM
                      ,A.PDCD
                      ,TRIM(A_1.PRD_KR_NM)    AS PRD_KR_NM
                      ,A.CRCD
                      ,SUM(A.LN_RMD)          AS SUM_LN_RMD

              FROM     OT_DWA_INTG_CLN_BC     A   -- DWA_통합여신기본

              JOIN     TB_SOR_LOA_ACN_BC      AA  -- SOR_LOA_계좌기본
                       ON     A.INTG_ACNO            = AA.CLN_ACNO
                       AND    AA.CLN_ACN_STCD      <> '3'

              LEFT OUTER JOIN
                       OT_DWA_CLN_PRD_STRC_BC A_1 -- DWA_여신상품구조기본
                       ON     A.PDCD           = A_1.PDCD
                       AND    A.STD_DT         = A_1.STD_DT

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

              WHERE    A.STD_DT = P_BASEDAY
              AND      A.BR_DSCD      = '1'
              AND      A.CLN_ACN_STCD <> '3'
              GROUP BY A.STD_DT
                      ,A.CUST_NO
                      ,A.INTG_ACNO
                      ,B_1.BRNO
                      ,TRIM(B_1.BR_NM)
                      ,A.CUST_NO
                      ,A.PDCD
                      ,TRIM(A_1.PRD_KR_NM)
                      ,A.CRCD
             )   A
    JOIN     (
              SELECT   /*+ FULL(A) */
                       CUST_NO
                      ,CUST_INF_CHG_SNO
                      ,TO_CHAR(ENR_DTTM,'YYYYMMDD') ENR_DT
                      ,ENR_USR_NO
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0039' THEN 'Y' ELSE NULL END  TL_RCV_DEN_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0039' THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS TL_RCV_ENR_DT
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0040' THEN 'Y' ELSE NULL END  SMS_RCV_DEN_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0040' THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS SMS_RCV_ENR_DT
              FROM     TB_SOR_CUS_CHG_TR A   --고객정보변경이력
              WHERE    1 = 1
              AND      (
                        (A.CUST_INF_CHG_DSCD = '0039' AND A.CHA_DAT_CTS NOT IN ('  ','00  ')  )    OR  --전화수신거부유형코드
                        (A.CUST_INF_CHG_DSCD = '0040' AND A.CHA_DAT_CTS = 'Y  ' )                      --SMS수신거부여부(공백없애면안됨)
                       )
              AND      TO_CHAR(A.ENR_DTTM,'YYYYMMDD') BETWEEN P_SOTM_DT AND P_EOTM_DT
             ) E
             ON   A.CUST_NO = E.CUST_NO
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀21',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


