/*
  프로그램명 : ins_TB_OPE_KRI_금전신탁팀01
  타켓테이블 : TB_OPE_KRI_금전신탁팀01
  KRI 지표명 : 위험등급 3등급 이상 신탁 금액 비중
  협      조 : 추유정과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 금전신탁팀-01 위험등급 3등급 이상 신탁 금액 비중
       A: 부점에서 판매한 위험등급 3등급 이상 신탁상품금액
       B: 부점에서 판매한 신탁상품금액
     - 금전신탁팀-02 위험등급 3등급 이상 신탁 계좌 수 비중
       A: 부점에서 판매한 위험등급 3등급 이상 신탁상품 계좌수
       B: 부점에서 판매한 신탁상품금액
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

    DELETE OPEOWN.TB_OPE_KRI_금전신탁팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_금전신탁팀01
    /*ISA제외 신탁 신규내역*/
    SELECT
             A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,TRIM(B.DTL_CND_DESC)   -- 상품위험등급코드
            ,NULL             -- 상품가입번호
            ,PD.PRD_KR_NM     -- 상품명
            ,'KRW'            -- 통화코드
            ,A.LDGR_RMD       -- 가입금액
            ,A.NW_DT          -- 계좌신규일자
            ,A.EXPI_DT        -- 계좌만기일자
    FROM     OT_DWA_INTG_DPS_BC A   -- DWA_통합수신기본
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

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD   -- SOR_PDF_상품기본
             ON     A.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE    1=1
    AND      STD_DT = P_BASEDAY
    AND      A.DPS_DP_DSCD = '5'
    AND      A.ACNO NOT LIKE '176%'
    AND      A.ACNO NOT LIKE '169%'
    AND      A.DPS_ACN_STCD = '01'
    AND      A.NW_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT

    UNION ALL
       /*ISA신규내역*/
    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.CUST_NO
            ,A.ACNO                            -- 계좌번호
            ,TRIM(CD.CMN_CD) || '-' || TRIM(CD.CMN_CD_NM)  -- 상품위험등급코드
            ,C.ISA_PRD_ACNO                    -- 상품가입번호
            ,B.AST_ADM_PRD_NO_NM               -- 상품구분코드
            ,'KRW'                             -- 통화코드
            ,C.ACBK_PRC                        -- 가입금액
            ,C.NW_DT                           -- 계좌신규일자
            ,C.EXPI_DT                         -- 계좌만기일자
    FROM     OT_DWA_INTG_DPS_BC A    -- DWA_통합수신기본
    JOIN     (
              SELECT STD_DT
                    ,DPS_ACNO
                    ,AST_ADM_PRD_NO
                    ,ISA_PRD_ACNO
                    ,NW_DT
                    ,EVL_AMT
                    ,'' as EXPI_DT
                    ,ACBK_PRC
              FROM   TB_SOR_ISA_BNFC_BLN_LDGR_TR   -- SOR_ISA_수익증권잔고원장내역
              WHERE  1=1
              AND    STD_DT = P_BASEDAY

              UNION ALL

              SELECT STD_DT
                    ,DPS_ACNO
                    ,AST_ADM_PRD_NO
                    ,ISA_PRD_ACNO
                    ,NW_DT
                    ,EVL_AMT
                    ,EXPI_DT
                    ,ACBK_PRC
              FROM   TB_SOR_ISA_DP_BLN_LDGR_TR   -- SOR_ISA_예금잔고원장내역
              WHERE  1=1
              AND    STD_DT = P_BASEDAY
             ) C
             ON    A.ACNO = C.DPS_ACNO
             AND   C.NW_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT

    JOIN     TB_SOR_ISA_PRD_INF_BC B  -- SOR_ISA_상품정보기본
             ON    C.AST_ADM_PRD_NO = B.AST_ADM_PRD_NO

    JOIN     TB_SOR_CMI_BR_BC    J   -- SOR_CMI_점기본
             ON    A.ADM_BRNO   = J.BRNO

    JOIN     TB_SOR_CMI_CMN_CD_BC  CD -- SOR_CMI_공통코드기본
             ON    B.AST_GRP_CLCD = CD.CMN_CD
             AND   CD.TPCD_NO = '4600824422'

    WHERE    1=1
    AND      A.DPS_ACN_STCD = '01'
    AND      A.STD_DT = P_BASEDAY
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_금전신탁팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
