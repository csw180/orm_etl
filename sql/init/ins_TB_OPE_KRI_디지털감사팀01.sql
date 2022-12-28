/*
  프로그램명 : ins_TB_OPE_KRI_디지털감사팀01
  타켓테이블 : TB_OPE_KRI_디지털감사팀01
  KRI 지표명 : 상시미점검건수
  협      조 : 이희경대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 디지털감사팀-01  상시미점검건수
       A: 전월말 기준 상시감사 항목중 미점검 건수
       B: 전월말 기준 상시감사 항목중 보류 건수
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
  
  DELETE FROM OPEOWN.TB_OPE_KRI_디지털감사팀01
  WHERE  STD_DT  IN  ( SELECT DISTINCT STD_DT FROM  TEMP_OPE_KRI_디지털감사팀01 );

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

  COMMIT;

  INSERT INTO OPEOWN.TB_OPE_KRI_디지털감사팀01
  SELECT STD_DT
        ,CHKG_DTT   -- 상시감사 구분코드(1: 즉시/2: 월간/3: 일간/4: 본부)
        ,BRNO
        ,BR_NM
        ,ONL_DT
        ,ADT_HDN
        ,ADT_HDN_NM
        ,CHKG_RSLT
        ,CASE WHEN CHKG_RSLT = '0'  THEN '미점검'
              WHEN CHKG_RSLT = '1'  THEN '점검'
              WHEN CHKG_RSLT = '9'  THEN '보류'
              ELSE '기타'
         END         CHKG_RSLT_NM
        ,CNT
  FROM   TEMP_OPE_KRI_디지털감사팀01;

  P_LD_CN := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

  COMMIT;

  SELECT  NVL(MAX(STD_DT),P_BASEDAY)
  INTO    P_BASEDAY
  FROM    TEMP_OPE_KRI_디지털감사팀01;
  
  SP_INS_ETLLOG('TB_OPE_KRI_디지털감사팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');

END
;
/
EXEC SP_DROP_TABLE('TEMP_OPE_KRI_디지털감사팀01');

EXIT


