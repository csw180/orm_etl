/*
  프로그램명 : ins_TB_OPE_KRI_국제금융팀04
  타켓테이블 : TB_OPE_KRI_국제금융팀04
  KRI 지표명 : 이자율 파생상품 거래 금액
  협      조 : 박민규과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 국제금융팀-04 이자율 파생상품 거래 금액
       A: 전월말 기준 본점 부서에서 보유하고 있는 이자율 파생 상품(스왑)의 명목거래 금액 합계
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

    DELETE OPEOWN.TB_OPE_KRI_국제금융팀04
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_국제금융팀04

    SELECT   P_BASEDAY
            ,A.BRNO
            ,J1.BR_NM
--            ,A.SUMMIT_TR_ID
            ,A.ITF_TR_DSCD
--            ,A.PCSL_DSCD     -- 거래유형
            ,A.TR_DT
            ,A.PCH_AMT
            ,A.PCH_CRCD
            ,A.USR_NO

    FROM     TB_SOR_ITF_TRADE_MAST_BC A    -- SOR_ITF_국제금융거래기본

    JOIN     TB_SOR_ITF_SP_MAST_BC B       -- SOR_ITF_스왑기본
             ON    A.REF_NO = B.REF_NO
             AND   B.SUMMIT_SWP_KDCD IN ( 'IRS','IRS_CO' )

    JOIN     TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_점기본
             ON   A.BRNO  =  J1.BRNO
             AND  J1.BR_DSCD = '1'   -- 1.중앙회, 2.조합

    WHERE    1=1
    AND      A.ITF_TR_DSCD IN ('SWAP')
    AND      A.TR_DT BETWEEN P_SOTM_DT and P_EOTM_DT
    AND      A.ITF_CUST_DSCD IN ( '1','2')
    AND      A.ITF_PGRS_STCD = '2'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_국제금융팀04',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
