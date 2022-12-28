/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀14
  타켓테이블 : TB_OPE_KRI_수신제도지원팀14
  KRI 지표명 : 보호예수 기한 경과한 비율
  협      조 : 김혜원과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-14 보호예수 기한 경과한 비율
       A: 전월 말 기준 보호예수 기간 만기일이 1일 경과한 건수
       B: 전월 말 기준 보호예수 활동좌건수<보호예수 미해지 건수>
     - 수신제도지원팀-15 보호예수 기한 경과한 건수
       A: 전월 말 기준 보호예수 기간 만기일이 1일 경과한 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀14
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀14
    SELECT    P_BASEDAY
             ,A.BRNO
             ,J.BR_NM
             ,A.BRNO||A.SFDP_YY||LPAD(A.SFDP_SNO,10,'0')   -- 보호예수고유일련번호
             ,A.SFDP_PRD_NM     -- 보호예수내용
             ,A.DNC_AMT         -- 보호예수금액
             ,A.NW_DT           -- 보호예수시작일자
             ,A.EXPI_DT         -- 보호예수만기일자
             ,TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(A.EXPI_DT,'YYYYMMDD')    -- 만기경과일수
             ,SUBSTR(A.LAST_CHNG_MN_USID,1,10)    -- 조작자사용자번호
             
    FROM      TB_SOR_PTD_SFDP_BC   A   -- SOR_PTD_보호예수기본
    
    JOIN      TB_SOR_CMI_BR_BC     J   -- SOR_CMI_점기본
              ON   A.BRNO      =   J.BRNO
              AND  J.BR_DSCD   =  '1'
              
    WHERE     1=1
    AND       ( A.CNCL_DT IS NULL OR CNCL_DT > P_BASEDAY )
    AND       ( (A.SFDP_STCD  = '1' AND A.RSTR_DT IS NULL ) OR ( A.RSTR_DT > P_BASEDAY ) )
    -- 보호예수상태코드 1(신규상태) OR 반환일자가 없거나 미래날짜인것
    -- 보호예수상태코드(SFDP_STCD) 1:신규,2:반환,3:신규취소
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀14',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








