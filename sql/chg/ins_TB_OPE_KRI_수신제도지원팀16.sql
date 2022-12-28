/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀16
  타켓테이블 : TB_OPE_KRI_수신제도지원팀16
  KRI 지표명 : 만기 후 1개월 이상 경과한 2천만원이상 예금 해지 건수(비대면 해지 제외)
  협      조 : 전영우
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-16 만기 후 1개월 이상 경과한 2천만원이상 예금 해지 건수(비대면 해지 제외)
       A: 만기가 1개월 이상 경과된 20백만원이상 예금의 해지(단 비대면 해지 제외)
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀16
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀16
    SELECT   T1.STD_DT
            ,T2.TR_BRNO                AS 점번호
            ,T3.BR_NM                  AS 점명
            ,T1.ACNO                   AS 계좌번호
            ,T1.LDGR_RMD               AS 예금해지금액
            ,T1.NW_DT                  AS 예금신규일자
            ,T1.EXPI_DT                AS 예금만기일자
            ,TO_DATE(T1.CNCN_DT,'YYYYMMDD') - TO_DATE(T1.EXPI_DT,'YYYYMMDD') +1  AS 만기경과일수
            ,T1.CNCN_DT                AS 예금해지일자

    FROM     OT_DWA_INTG_DPS_BC T1      -- DWA_통합수신기본

    JOIN     TB_SOR_DEP_TR_TR T2        -- SOR_DEP_거래내역
             ON  T1.ACNO = T2.ACNO
             AND T1.CNCN_DT = T2.TR_DT
             AND T2.DPS_TR_STCD = '1'
             AND T2.CHNL_TPCD = 'TTML'              -- 단말거래

    JOIN     TB_SOR_CMI_BR_BC T3        -- SOR_CMI_점기본
             ON T2.TR_BRNO = T3.BRNO

    WHERE    1=1
    AND      T1.STD_DT = P_BASEDAY
    AND      T1.LDGR_RMD >= 20000000          -- 잔액2천만원이상
    AND      T1.DPS_DP_DSCD = '2'                    -- 원화저축성
    AND      T1.DPS_RSVG_TPCD = '2'                  -- 거치식예금
    AND      T1.CNCN_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      T1.DPS_ACN_STCD != '01'                 -- 해지계좌
    AND      T1.ACNO < '200000000000'                -- 은행계좌(조합계좌제외)
    AND      TO_CHAR(ADD_MONTHS(TO_DATE(T1.CNCN_DT,'YYYYMMDD'), -1), 'YYYYMMDD') >= T1.EXPI_DT -- 만기일경과 1개월이상
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀16',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
