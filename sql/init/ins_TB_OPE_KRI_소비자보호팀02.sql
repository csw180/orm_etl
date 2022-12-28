/*
  프로그램명 : ins_TB_OPE_KRI_소비자보호팀02
  타켓테이블 : TB_OPE_KRI_소비자보호팀02
  KRI 지표명 : 민원접수증감율
  협      조 : 이희경
  최조작성자 : 최상원
  KRI 지표명 :
     - 소비자보호팀-02 민원접수증감율
       A: 전월 금감원 또는 행태 민원 제기 건수
       B: 전전월 금감원 또는 행태 민원 제기 건수
     - 소비자보호팀-03 민원 및 고객불만 외부채널 접수 건수
       A: 전월 중 대외경로(EX:금감원, 소보원 등)를 통하여 접수된 불만민원접수
     - 소비자보호팀-04 민원 및 고객불만 내부채널 접수 건수
       A: 전월 중 민원관리시스템 내 부점별 고객 불만 및 민원 접수 건수
     - 소비자보호팀-05 민원 규정처리 기한내 미완료 건수
       A: "민원처리완료일 >= 민원규정처리기한" 인 민원건수
       B: "기준일 >= 민원규정처리기한 AND 민원처리미완료" 인 민원건수
     - 방카슈랑스팀-01 방카슈랑스 불완전판매(민원발생) 건수
       A: 종합감사정보시스템에 집계된 민원 중 방카슈랑스 팀에 이관된 민원의 건수
*/

DECLARE
  P_BASEDAY  VARCHAR2(8);  -- 기준일자
  P_SOTM_DT  VARCHAR2(8);  -- 당월초일
  P_EOTM_DT  VARCHAR2(8);  -- 당월말일
  P_LD_CN    NUMBER;       -- 로딩건수

BEGIN
  SELECT  STD_DT,EOTM_DT,SUBSTR(EOTM_DT,1,6) || '01'
  INTO    P_BASEDAY
         ,P_EOTM_DT
         ,P_SOTM_DT
  FROM    OPEOWN.TB_OPE_DT_BC
  WHERE   STD_DT_YN  = 'Y';

  DELETE FROM OPEOWN.TB_OPE_KRI_소비자보호팀02
  WHERE  STD_DT  IN  ( SELECT DISTINCT STD_DT FROM  TEMP_OPE_KRI_소비자보호팀02 );

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

  COMMIT;

  INSERT INTO OPEOWN.TB_OPE_KRI_소비자보호팀02
  SELECT *
  FROM   TEMP_OPE_KRI_소비자보호팀02;

  P_LD_CN := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

  COMMIT;

  SELECT  NVL(MAX(STD_DT),P_BASEDAY)
  INTO    P_BASEDAY
  FROM    TEMP_OPE_KRI_소비자보호팀02;
  
  SP_INS_ETLLOG('TB_OPE_KRI_소비자보호팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');

END
;
/
EXEC SP_DROP_TABLE('TEMP_OPE_KRI_소비자보호팀02');

EXIT
