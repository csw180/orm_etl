/*
  프로그램명 : ins_TB_OPE_KRI_펀드사업팀12
  타켓테이블 : TB_OPE_KRI_펀드사업팀12
  KRI 지표명 : 원금손실 구간 진입 계좌 잔액(elf)
  협      조 : 김지현대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 펀드사업팀-12: 원금손실 구간 진입 계좌 잔액(elf)
       A: ELF중 낙인베이러를 초과하는 기초자잔이 내재된 상품의 총 계좌 잔액
     - 펀드사업팀-13: 원금손실 구간 진입 계좌 수(elf)
       A: 전월중 신규된 만 65세 이상 고객의 신탁  또는 펀드 상품 신규 가입 건수
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

    DELETE OPEOWN.TB_OPE_KRI_펀드사업팀12
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_펀드사업팀12
    SELECT   P_BASEDAY 기준일자
            ,T1.ADM_BRNO 관리점번호
            ,T2.BR_NM 관리점명
            ,T1.ACNO 계좌번호
            ,T1.CUST_NO 고객번호
            ,T1.BLN_PCPL 계좌잔액
            ,T4.PRD_KR_NM 상품명
            ,T5.BLN_PCPL 낙인금액
            ,T3.KI_OCC_DT 낙인발생일자

    FROM     TB_SOR_BCM_BNAC_BC T1   -- SOR_BCM_수익증권계좌기본
    JOIN     TB_SOR_CMI_BR_BC   T2   -- SOR_CMI_점기본
             ON   T1.ADM_BRNO  = T2.BRNO

    JOIN     TB_SOR_PDF_FND_BC T3    -- SOR_PDF_펀드기본
             ON   T1.PDCD = T3.PDCD
             AND  T3.APL_ST_DT <= P_BASEDAY
             AND  T3.APL_END_DT >= P_BASEDAY
             AND  T3.APL_STCD = '10'

    JOIN     TB_SOR_PDF_PRD_BC T4    --  SOR_PDF_상품기본
             ON    T1.PDCD = T4.PDCD
             AND   T4.APL_STCD = '10'
             AND   T4.PRD_DSCD = '01'

    JOIN     TB_SOR_BCM_PACN_DD_BLN_TR T5   -- SOR_BCM_계좌별일일잔고내역
             ON    T1.ACNO      = T5.ACNO
             AND   T3.KI_OCC_DT = T5.STD_DT -- 낙인발생일자
             AND   T3.PDCD      = T5.PDCD

    WHERE    1=1
    AND      T1.ACY_DSCD = '1'
    AND      T3.KI_OCC_DT BETWEEN P_SOTM_DT AND P_EOTM_DT --해당월에 발생한 낙인
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_펀드사업팀12',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
