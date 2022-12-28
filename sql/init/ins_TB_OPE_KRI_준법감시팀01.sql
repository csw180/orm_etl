/*
  프로그램명 : ins_TB_OPE_KRI_준법감시팀01
  타켓테이블 : TB_OPE_KRI_준법감시팀01
  협      조 : 이효정과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 준법감시팀01 : 지점명의 통장 계좌수
       A: 해당부점 사업자번호로 개설된 요구불식 활동계좌 수
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

    DELETE OPEOWN.TB_OPE_KRI_준법감시팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_준법감시팀01

    SELECT   B.STD_DT
            ,A.BRNO
            ,A.BR_NM
            ,B.ACNO
            ,B.DPS_DP_DSCD
            ,B.NW_DT
            ,B.LDGR_RMD
    FROM     (
              SELECT   S2.BRNO
                      ,S2.BR_NM
                      ,S2.BRN
              FROM     (
                          SELECT   DISTINCT  DECODE(BR_STCD,'02',INTG_BRNO,BRNO)  BR_NO
                          FROM     OT_DWA_DD_BR_BC  -- DWA_일점기본
                          WHERE    STD_DT  = P_BASEDAY
                          AND      BR_DSCD = '1'  -- 은행
                          AND      BR_KDCD = '20'   -- 점종류(20:영업점)
                          AND      BR_STCD  IN  ('01','02')  -- 점상태코드 01:정상영업, 02:전출
                       )   S1
              JOIN     OT_DWA_DD_BR_BC  S2   -- DWA_일점기본
                       ON   S1.BR_NO  =  S2.BRNO
                       AND  S2.STD_DT =  P_BASEDAY
             )  A
    JOIN     OT_DWA_INTG_DPS_BC  B    -- DWA_통합수신기본
             ON  A.BRN    =  B.CUST_RNNO
             AND A.BRNO   =  B.ADM_BRNO
             AND B.STD_DT =  P_BASEDAY
             AND B.DPS_DP_DSCD   =  '1'   --원화요구불
             AND B.DPS_ACN_STCD  =  '01'  -- 수신계좌상태코드 01:활동
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_준법감시팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
