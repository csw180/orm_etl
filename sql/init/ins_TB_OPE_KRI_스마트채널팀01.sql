/*
  프로그램명 : ins_TB_OPE_KRI_스마트채널팀01
  타켓테이블 : TB_OPE_KRI_스마트채널팀01
  KRI 지표명 : 비대면 서비스 시스템 장애건수
  협      조 : 이수정차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 스마트채널팀-01  비대면 서비스 시스템 장애건수
       A: 전월말 발생한 비대면 서비스 시스템장애 건수(월 합산)
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

  DELETE FROM OPEOWN.TB_OPE_KRI_스마트채널팀01
  WHERE  STD_DT  IN  ( SELECT DISTINCT STD_DT FROM  TEMP_OPE_KRI_스마트채널팀01 );

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');
  
  COMMIT;

  INSERT INTO OPEOWN.TB_OPE_KRI_스마트채널팀01
  SELECT *
  FROM   TEMP_OPE_KRI_스마트채널팀01;

  P_LD_CN := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

  COMMIT;

  SELECT  NVL(MAX(STD_DT),P_BASEDAY)
  INTO    P_BASEDAY
  FROM    TEMP_OPE_KRI_스마트채널팀01;
  
  SP_INS_ETLLOG('TB_OPE_KRI_스마트채널팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');

END
;
/
EXEC SP_DROP_TABLE('TEMP_OPE_KRI_스마트채널팀01');

EXIT
