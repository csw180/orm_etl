/*
  프로그램명 : ins_TB_OPE_KRI_자금세탁방지팀01
  타켓테이블 : TB_OPE_KRI_자금세탁방지팀01
  KRI 지표명 : 고액현금거래(CTR) 건수
  협      조 : 최은영대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 자금세탁방지팀-01 고액현금거래(CTR) 건수
       A: 전월 중 당행에서 동일인이 1거래일 동안 지급하거나 영수한 금액을 각각 합산한 결과 지급,
          영수 금액이 각각 현금 10백만원 이상인 거래 건수
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

  DELETE FROM OPEOWN.TB_OPE_KRI_자금세탁방지팀01
  WHERE  STD_DT  IN  ( SELECT DISTINCT STD_DT FROM  TEMP_OPE_KRI_자금세탁방지팀01 );

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');
  
  COMMIT;

  INSERT INTO OPEOWN.TB_OPE_KRI_자금세탁방지팀01
  SELECT *
  FROM   TEMP_OPE_KRI_자금세탁방지팀01;

  P_LD_CN := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

  COMMIT;

  SELECT  NVL(MAX(STD_DT),P_BASEDAY)
  INTO    P_BASEDAY
  FROM    TEMP_OPE_KRI_자금세탁방지팀01;
  
  SP_INS_ETLLOG('TB_OPE_KRI_자금세탁방지팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');

END
;
/
EXEC SP_DROP_TABLE('TEMP_OPE_KRI_자금세탁방지팀01');

EXIT
