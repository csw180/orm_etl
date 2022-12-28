/*
  프로그램명 : ins_TB_OPE_KRI_자금세탁방지팀04
  타켓테이블 : TB_OPE_KRI_자금세탁방지팀04
  KRI 지표명 : 지점의 STR(최근 추출 급증) 고객 수(고위험)
  협      조 : 최은영대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 자금세탁방지팀-04 지점의 STR(최근 추출 급증) 고객 수(고위험)
       A: 기준월중 금융정보분석원응로 보고한 자금세탁혐의거래보고 건수 고위험 영업점/지점의 지표 총계
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

  DELETE FROM OPEOWN.TB_OPE_KRI_자금세탁방지팀04
  WHERE  STD_DT  IN  ( SELECT DISTINCT STD_DT FROM  TEMP_OPE_KRI_자금세탁방지팀04 );

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

  COMMIT;

  INSERT INTO OPEOWN.TB_OPE_KRI_자금세탁방지팀04
  SELECT *
  FROM   TEMP_OPE_KRI_자금세탁방지팀04;

  P_LD_CN := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

  COMMIT;

  SELECT  NVL(MAX(STD_DT),P_BASEDAY)
  INTO    P_BASEDAY
  FROM    TEMP_OPE_KRI_자금세탁방지팀04;
  
  SP_INS_ETLLOG('TB_OPE_KRI_자금세탁방지팀04',P_BASEDAY,P_LD_CN,'KRI_ETL');

END
;
/
EXEC SP_DROP_TABLE('TEMP_OPE_KRI_자금세탁방지팀04');

EXIT
