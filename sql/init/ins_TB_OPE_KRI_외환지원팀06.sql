/*
  프로그램명 : ins_TB_OPE_KRI_외환지원팀06
  타켓테이블 : TB_OPE_KRI_외환지원팀06
  KRI 지표명 : 외화대출 불완전판매 모니터링 미실시 건수
  협      조 : 강병서대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 외환지원팀-06  외화대출 불완전판매 모니터링 미실시 건수
       A: 부점발생외화대출건 중 발생일로부터 3영업일 초과하였으나 보완 미정리 상태인 건수
          전송받은 데이터는 대출일과 해피콜완료일자간 3영업일 경과여부를 체크하지 않고 보내오는
          데이터 이므로 지표값을 구할때 로직을 넣어서 사용해야 함
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

  DELETE FROM OPEOWN.TB_OPE_KRI_외환지원팀06
  WHERE  STD_DT  IN  ( SELECT DISTINCT STD_DT FROM  TEMP_OPE_KRI_외환지원팀06 );

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

  COMMIT;

  INSERT INTO OPEOWN.TB_OPE_KRI_외환지원팀06
  SELECT *
  FROM   TEMP_OPE_KRI_외환지원팀06;

  P_LD_CN := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

  COMMIT;

  SELECT  NVL(MAX(STD_DT),P_BASEDAY)
  INTO    P_BASEDAY
  FROM    TEMP_OPE_KRI_외환지원팀06;
  
  SP_INS_ETLLOG('TB_OPE_KRI_외환지원팀06',P_BASEDAY,P_LD_CN,'KRI_ETL');

END
;
/
EXEC SP_DROP_TABLE('TEMP_OPE_KRI_외환지원팀06');

EXIT
