/*
  프로그램명 : ins_TB_OPE_KRI_자금관리팀08
  타켓테이블 : TB_OPE_KRI_자금관리팀08
  KRI 지표명 : H-KRI-058 잡수익편입 원화출납 과잉금 건수(창구)
  협      조 : 박아란과장
  최조작성자 : 최상원
  KRI 지표명 :
   - 자금관리팀-08 잡수익편입 원화출납 과잉금 건수(창구)
     A: [원화] 발생일로부터 3개월 경과된 창구출납과잉금 건수
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

    DELETE OPEOWN.TB_OPE_KRI_자금관리팀08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_자금관리팀08
    SELECT   P_BASEDAY
            ,A.ADM_BRNO   -- 점번호
            ,C.BR_NM
            ,A.OCC_DT     -- 발생일자
            ,A.CRCD       -- 통화코드
            ,B.TR_AMT     -- 잡수익금액
            ,B.FSC_DT     -- 잡수익편입일자
    FROM     DWZOWN.TB_SOR_APW_TMAC_TR_BC   A -- SOR_APW_가계정거래기본
    
    JOIN     DWZOWN.TB_SOR_APW_TMAC_TR_TR   B -- SOR_APW_가계정거래내역
             ON  A.TMAC_ACNO =   B.TMAC_ACNO
             AND B.OPRF_PCS_AMT  > 0   --   잡수익처리금액
             AND B.TR_DT  BETWEEN  P_SOTM_DT AND P_EOTM_DT
             
    JOIN     DWZOWN.TB_SOR_CMI_BR_BC  C  -- SOR_CMI_점기본
             ON  A.ADM_BRNO = C.BRNO
             AND C.BR_DSCD = '1'   -- 1.중앙회, 2.조합
             
    WHERE    1=1
    AND      A.ACSB_CD = '26008111'  -- 창구과잉출납금
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_자금관리팀08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
