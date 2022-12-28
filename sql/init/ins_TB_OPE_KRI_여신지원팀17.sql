/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀17
  타켓테이블 : TB_OPE_KRI_여신지원팀17
  KRI 지표명 : 기업/소호여신 신규 전 CRM업종 변경 건수
  협      조 : 이상민과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-17 : 기업/소호여신 신규 전 CRM업종 변경 건수
       A: 전일중 취급일 당일포함 10영업일이내 crm업종변경 후 5천만원 이상
          기업/소호여신 대출 신규건수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀17
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀17
    SELECT   P_BASEDAY
            ,AA.CSLT_BRNO
            ,AA.BR_NM
            ,AA.CUST_NO
            ,AA.CUST_DSCD
            ,BB.CHB_DAT_CTS
            ,BB.CHA_DAT_CTS
            ,TO_CHAR(BB.ENR_DTTM,'YYYYMMDD') ENR_DT
            ,AA.CSLT_DT
            ,AA.PRD_KR_NM
            ,AA.CRCD
            ,AA.APRV_AMT
            ,BB.ENR_USR_NO
    FROM
             (
              SELECT   B.CLN_APC_RPST_NO
                      ,B.CSLT_BRNO
                      ,J.BR_NM
                      ,B.CUST_NO
                      ,CASE WHEN B.CRDT_EVL_MODL_DSCD = '34' THEN '소호'
                            ELSE '기업'
                       END  CUST_DSCD
                      ,TO_CHAR(A.LST_AMN_TS,'YYYYMMDD')  AS CSLT_DT  -- 최종수정타임스탬프
                      ,PD.PRD_KR_NM
                      ,C.CRCD
                      ,F.APRV_AMT
                      ,CASE WHEN B.PREN_CLN_DSCD = '2' THEN  E.RNNO
                            ELSE E.BRN
                       END BRN

              FROM     TB_SOR_CLI_APC_PGRS_ADM_TR   A   -- SOR_CLI_신청진행관리내역

              JOIN     TB_SOR_CLI_CLN_APC_RPST_BC   B   -- SOR_CLI_여신신청대표기본
                       ON     A.CLN_APC_RPST_NO = B.CLN_APC_RPST_NO
                       AND    B.NFFC_UNN_DSCD = '1'
                       AND    B.CSLT_BRNO NOT IN ('0005','0288')
                       AND    B.APC_LDGR_STCD <> '99'
                       AND    B.PREN_CLN_DSCD IN ('2','3')

              JOIN     TB_SOR_CLI_CLN_APC_BC C    --  SOR_CLI_여신신청기본
                       ON     B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO
                       AND    C.APC_LDGR_STCD <> '99'  -- 신청원장상태코드(01:작성중,02:결재중,10:완료,99:취소)
                       AND    C.CLN_APC_DSCD = '01'    -- 여신신청구분코드(01:신규, 02:대환 ...)
                       AND    C.APC_WNA >= 50000000  -- 5천만원이상 대출건

              JOIN     TB_SOR_CUS_MAS_BC D         -- SOR_CUS_고객기본
                       ON     B.CUST_NO = D.CUST_NO

              JOIN     TB_SOR_CLI_APC_CUST_SMR_BC E    -- SOR_CLI_신청고객요약기본
                       ON     A.CLN_APC_RPST_NO = E.CLN_APC_RPST_NO

              JOIN     TB_SOR_CMI_BR_BC   J   -- SOR_CMI_점기본
                       ON      B.CSLT_BRNO  = J.BRNO

              JOIN     TB_SOR_PDF_PRD_BC  PD   -- SOR_PDF_상품기본
                       ON      C.PDCD  =  PD.PDCD
                       AND     PD.APL_STCD = '10'

              LEFT OUTER JOIN
                       TB_SOR_CLI_CLN_APRV_BC   F   -- SOR_CLI_여신승인기본
                       ON      C.CLN_APRV_NO  =  F.CLN_APRV_NO
                       AND     F.CLN_APRV_LDGR_STCD IN ('10','20')

              WHERE    1=1
              AND      TO_CHAR(A.LST_AMN_TS,'YYYYMMDD')   BETWEEN  P_SOTM_DT  AND P_EOTM_DT
              AND      A.CLN_APC_PGRS_STP_LCCD = '170'
              AND      A.CLN_APC_PGRS_STP_MCCD = '01'
             )  AA
    JOIN
             (
              SELECT   A.CUST_RNNO
                      ,B.*
              FROM     TB_SOR_CUS_MAS_BC A   -- SOR_CUS_고객기본
              JOIN     TB_SOR_CUS_CHG_TR B   -- SOR_CUS_고객변경내역
                       ON    A.CUST_NO = B.CUST_NO
                       AND   B.CUST_INF_CHG_DSCD = '0026'  -- 표준산업분류코드
             ) BB
             ON     AA.BRN = BB.CUST_RNNO
             AND    TO_CHAR(BB.ENR_DTTM,'YYYYMMDD') >= (SELECT D10_BF_SLS_DT FROM  OM_DWA_DT_BC WHERE STD_DT = AA.CSLT_DT)
             AND    TO_CHAR(BB.ENR_DTTM,'YYYYMMDD') <= AA.CSLT_DT
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀17',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


