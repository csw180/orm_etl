/*
  프로그램명 : ins_TB_OPE_KRI_펀드사업팀05
  타켓테이블 : TB_OPE_KRI_펀드사업팀05
  KRI 지표명 : 펀드운용보고서 '수령안함' 선택 후 신규금액
  협      조 : 김지현대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 펀드사업팀-05 : 펀드운용보고서 '수령안함' 선택 후 신규금액
       A: 자산운용보고서를 '수령안함' 선택한 신규 펀드 계좌 잔액의 함
     - 펀드사업팀-06 : 펀드운용보고서 '수령안함' 선택 후 신규계좌 수
       A: 전월 영업점/지점에서 신규된 펀드 계좌중 자산운용보고서 '수령안함' 선택한 계좌수
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

    DELETE OPEOWN.TB_OPE_KRI_펀드사업팀05
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_펀드사업팀05
    SELECT   P_BASEDAY
            ,T1.ADM_BRNO
            ,J1.BR_NM
            ,T1.NW_DT
            ,T1.ACNO
            ,T1.CUST_NO
            ,CASE WHEN  T1.UTL_REPT_DPC_DSCD  = '0' THEN 'Y'  -- 0:원하지않은,1:자택,2:직장,4:이메일
                  ELSE  'N'
             END              -- 자산운용보고서수령안함선택여부
            ,T2.TR_AMT

    FROM     TB_SOR_BCM_BNAC_BC    T1     -- SOR_BCM_수익증권계좌기본
    JOIN     (
              SELECT   ACNO
                      ,SUM(TR_AMT)  TR_AMT
              FROM     TB_SOR_BCM_TR_TR   -- SOR_BCM_거래내역
              WHERE    1=1
              AND      TR_SNO =  '1'
              AND      CNCL_YN =  'N'
              GROUP BY ACNO
             )   T2
             ON    T1.ACNO  =  T2.ACNO

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
             ON    T1.ADM_BRNO  =  J1.BRNO

    WHERE    1=1
    AND      T1.DPS_ACN_STCD  NOT IN ('98','99') -- 신규정정, 신규취소 제외
    AND      T1.NW_DT  BETWEEN P_SOTM_DT  AND   P_EOTM_DT
    AND      T1.RTPN_DSCD  =  '00'
    AND      T1.UTL_REPT_DPC_DSCD = '0'
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_펀드사업팀05',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT



