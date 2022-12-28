/*
  프로그램명 : ins_TB_OPE_KRI_국제금융팀02
  타켓테이블 : TB_OPE_KRI_국제금융팀02
  KRI 지표명 : 파생상품 거래 명목금액
  협      조 : 박민규과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 국제금융팀-02 파생상품 거래 명목금액
       A: 전월말 기준 본점 부서에서 보유중인 파생상품 거래 명목금액
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

    DELETE OPEOWN.TB_OPE_KRI_국제금융팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_국제금융팀02
    SELECT   P_BASEDAY
            ,A.BRNO
            ,J1.BR_NM
            --,A.SUMMIT_TR_ID
            ,A.ITF_TR_DSCD  -- 상품유형
            ,A.PCSL_DSCD    -- 거래유형코드
            ,A.TR_DT        -- 거래일자
            ,TRUNC( CASE WHEN  A.PCSL_DSCD = 'B' THEN PCH_AMT  ELSE SLL_AMT END * B.DLN_STD_EXRT /
                    CASE WHEN  B.CRCD IN ('JPY','IDR') THEN 100 ELSE 1 END
                  )     -- 거래금액
            ,CASE WHEN  A.PCSL_DSCD = 'B' THEN PCH_CRCD  ELSE SLL_CRCD END  -- 통화코드
            ,A.USR_NO   -- 직원번호

    FROM     TB_SOR_ITF_TRADE_MAST_BC A    -- SOR_ITF_국제금융거래기본
    JOIN     TB_SOR_FEC_EXRT_BC         B  -- SOR_FEC_환율기본
             ON    CASE WHEN  A.PCSL_DSCD = 'B' THEN PCH_CRCD  ELSE SLL_CRCD END  =  B.CRCD
             AND   A.TR_DT   = B.STD_DT
             AND   B.EXRT_TO = 1

    JOIN     TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_점기본
             ON   A.BRNO  =  J1.BRNO

    WHERE    1=1
    AND      A.ITF_TR_DSCD  IN  ('FXFWD','FXSWAP')
    AND      A.TR_DT  BETWEEN P_SOTM_DT  AND  P_EOTM_DT
    AND      A.ITF_CUST_DSCD IN  ('1','2')
    AND      A.ITF_PGRS_STCD  =  '2'
    AND      A.FX_SWP_DSCD  IN  ('0','2')
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_국제금융팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT



