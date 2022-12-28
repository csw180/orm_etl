/*
  프로그램명 : ins_TB_OPE_KRI_자금세탁방지팀03
  타켓테이블 : TB_OPE_KRI_자금세탁방지팀03
  KRI 지표명 : 지점의 AML 취약국가와의 거래금액(고위험)
  협      조 : 최은영대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 자금세탁방지팀-03  지점의 AML 취약국가와의 거래금액(고위험)
       A: 고위험 등급 영업점/지점들의 'FATF비협조 국가 등 금융제도 및 자금세탁방지제도가 취약한 국가'
           대상 금융거래 금액합계
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

  DELETE FROM OPEOWN.TB_OPE_KRI_자금세탁방지팀03
  WHERE  STD_DT  IN  ( SELECT DISTINCT STD_DT FROM  TEMP_OPE_KRI_자금세탁방지팀03 );

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

  COMMIT;

  INSERT INTO OPEOWN.TB_OPE_KRI_자금세탁방지팀03
  SELECT *
  FROM   TEMP_OPE_KRI_자금세탁방지팀03;

  P_LD_CN := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

  COMMIT;

  SELECT  NVL(MAX(STD_DT),P_BASEDAY)
  INTO    P_BASEDAY
  FROM    TEMP_OPE_KRI_자금세탁방지팀03;
  
  SP_INS_ETLLOG('TB_OPE_KRI_자금세탁방지팀03',P_BASEDAY,P_LD_CN,'KRI_ETL');

END
;
/
EXEC SP_DROP_TABLE('TEMP_OPE_KRI_자금세탁방지팀03');

EXIT
