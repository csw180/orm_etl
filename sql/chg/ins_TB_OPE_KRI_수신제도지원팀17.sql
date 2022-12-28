/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀17
  타켓테이블 : TB_OPE_KRI_수신제도지원팀17
  협      조 : 전영우
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀17 : 만기경과 예금계좌 비율
       A: 전월말 기준 1천만원 이상 예적금 계좌 중 만기후 1개월 이상 경과된 건수
       B: 전월말 기준 1천만원 이상 예적금 계좌수
     - 수신제도지원팀18 : 만기경과 예금계좌 건수
       A: 전월말 기준 만기후 1개월 이상 경과된 1천만원 이상 예금계좌 건수 - 수신제도지원팀17-A 와 동일
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀17
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀17
    SELECT   T1.STD_DT                 AS 기준일자
            ,T1.ADM_BRNO               AS 점번호
            ,T2.BR_NM                  AS 점명
            ,T1.ACNO                   AS 계좌번호
            ,T1.CUST_NO                AS 고객번호
            ,T1.LDGR_RMD               AS 예금해지금액
            ,T1.EXPI_DT                AS 예금만기일자
            ,TO_DATE(T1.STD_DT,'YYYYMMDD') - TO_DATE(T1.EXPI_DT,'YYYYMMDD') + 1  AS 만기경과일수

    FROM     OT_DWA_INTG_DPS_BC T1      -- DWA_통합수신기본

    JOIN     TB_SOR_CMI_BR_BC T2        -- SOR_CMI_점기본
             ON   T1.ADM_BRNO = T2.BRNO

    WHERE    1=1
    AND      T1.STD_DT =  P_BASEDAY
    AND      T1.LDGR_RMD >= 10000000                 -- 잔액1천만원이상
    AND      T1.DPS_DP_DSCD = '2'                    -- 원화저축성(예/적금)
    AND      T1.DPS_ACN_STCD = '01'                  -- 활동계좌
    AND      T1.ACNO < '200000000000'                -- 은행계좌(조합계좌제외)
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀17',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
