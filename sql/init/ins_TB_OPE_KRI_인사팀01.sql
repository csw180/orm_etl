/*
  프로그램명 : ins_TB_OPE_KRI_인사팀01
  타켓테이블 : TB_OPE_KRI_인사팀01
  KRI 지표명 : 정규직원의 퇴직수
  협      조 :
  최조작성자 : 최상원
  KRI 지표명 :
     - 인사팀-01 정규직원의 퇴직수
       A: 전월 중 정규 직원 퇴직 건수
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

    DELETE OPEOWN.TB_OPE_KRI_인사팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_인사팀01
    SELECT
             작성기준일
            ,점번호
            ,점명
            ,직원구분코드
            ,직원구분명
            ,사번
            ,퇴직일
            ,퇴직여부
    --        ,회계코드명
    FROM     TB_MDWT중앙회인사
    WHERE    작성기준일 = P_BASEDAY
    AND      퇴직일   BETWEEN  P_SOTM_DT AND P_EOTM_DT
    AND      점구분명   = '수협은행'
    AND      직원구분명 = '정규직'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_인사팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT