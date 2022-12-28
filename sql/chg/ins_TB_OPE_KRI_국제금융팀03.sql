/*
  프로그램명 : ins_TB_OPE_KRI_국제금융팀03
  타켓테이블 : TB_OPE_KRI_국제금융팀03
  KRI 지표명 : 통화 파생상품 매입거래 금액
  협      조 : 박민규과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 국제금융팀-03 통화 파생상품 매입거래 금액
       A: 전월말 기준 본점 부서에서 보유하고 있는 통화 파생상품(선도)의 매입 명목거래 금액합계
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

    DELETE OPEOWN.TB_OPE_KRI_국제금융팀03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_국제금융팀03

    SELECT   P_BASEDAY
            ,A.BRNO
            ,J1.BR_NM
            --,A.SUMMIT_TR_ID
            ,A.ITF_TR_DSCD   -- 상품유형
            ,A.PCSL_DSCD     -- 거래유형
            ,A.TR_DT         -- 거래일자
            ,A.PCH_AMT       -- 거래금액
            ,A.PCH_CRCD      -- 통화코드
            ,A.USR_NO        -- 직원번호
            
    FROM     TB_SOR_ITF_TRADE_MAST_BC A   -- SOR_ITF_국제금융거래기본

    JOIN     TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_점기본
             ON   A.BRNO  =  J1.BRNO

    WHERE    1=1
    AND      A.ITF_TR_DSCD IN ('FXFWD','FXSWAP')
    AND      A.TR_DT BETWEEN P_SOTM_DT and P_EOTM_DT
    AND      A.ITF_CUST_DSCD IN ( '1','2')
    AND      A.ITF_PGRS_STCD = '2'
    AND      A.PCSL_DSCD = 'B'
    AND      A.FX_SWP_DSCD IN ( '0','2')
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_국제금융팀03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT




