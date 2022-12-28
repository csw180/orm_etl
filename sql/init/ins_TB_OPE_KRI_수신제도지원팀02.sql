/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀02
  타켓테이블 : TB_OPE_KRI_수신제도지원팀02
  KRI 지표명 : 편의취급 거래 미정리 비율
  협      조 : 임현선과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-02 편의취급 거래 미정리 비율
       전월 중 편의 취급건을 15일 초과하여 정리하거나 미정리한 비율
       A: 전월 중 15일 초과하여 미정리 중인 편의 취급거래건수
       B: 전월 중 발생한 편의취급 거래 건수
     - 수신제도지원팀-03 편의취급 거래 미정리 건수
       전월 중 편의 취급건을 15일 초과하여 정리하거나 미정리한 건수
       A: 전월 중 15일 초과하여 정리한 편의취급 거래 건수
       B: 전월 말 기준 15일 초과하여 미정리 중인 편의취급거래 건수
     - 수신제도지원팀-04 편의취급 거래건수
       A: 편의취급 거래 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀02
    SELECT   P_BASEDAY
            ,A.TR_BRNO
            ,B.BR_NM
            ,A.ACNO
            ,C.CUST_NO
            ,A.CNVC_DSCD
            ,A.TR_DT
            ,A.TR_AMT
            ,CASE WHEN A.LDGR_STCD = '1'  THEN  'N' ELSE  'Y'  END CNVC_HDL_ARN_YN
            ,A.RLS_DT
            ,A.NARN_ACCR_DCNT

    FROM     (
              SELECT    A.ACNO            -- 계좌번호
                       ,A.TR_DT           -- 거래일자
                       ,A.TR_SNO          -- 거래일련번호
                       ,A.TR_AMT          -- 거래금액
                      ,CASE WHEN  A.CNVC_HDL_DSCD = '1' THEN  '무통장지급'
                            WHEN  A.CNVC_HDL_DSCD = '2' THEN  '무인감지급'
                            WHEN  A.CNVC_HDL_DSCD = '3' THEN  '무통장+무인감지급'
                       END         CNVC_DSCD  -- 편의취급구분코드
                      ,TR_BRNO            -- 거래점번호
                      ,TO_CHAR( TO_DATE(A.TR_DT,'YYYYMMDD') + 15,'YYYYMMDD')  AF15_DT
                      ,B.DP_ACD_KDCD      -- 예금사고종류코드
                      ,B.LDGR_STCD        -- 원장상태코드
                      ,B.ENR_DT           -- 등록일자
                      ,B.RLS_DT           -- 해제일자
                      ,CASE WHEN B.LDGR_STCD = '3' THEN TO_DATE(B.RLS_DT,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD') END ACCR_DCNT
                      ,CASE WHEN B.LDGR_STCD = '1' THEN TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD') END NARN_ACCR_DCNT
              FROM     TB_SOR_DEP_TR_TR    A  -- SOR_DEP_거래내역
              JOIN     TB_SOR_DEP_ACD_TR   B  -- SOR_DEP_사고내역
                       ON   A.ACNO   = B.ACNO
                       AND  A.TR_DT  = B.ENR_DT
                       AND  A.TR_AMT = B.ACD_AMT

              WHERE    1=1
              AND      A.ACNO  LIKE  '1%'
              AND      A.TR_DT  BETWEEN  P_SOTM_DT AND  P_EOTM_DT
              AND      A.CNVC_HDL_DSCD  IN  ('1','2','3')
             )  A
    JOIN     TB_SOR_CMI_BR_BC     B    -- SOR_CMI_점기본
             ON    A.TR_BRNO  =  B.BRNO

    JOIN     TB_SOR_DEP_DPAC_BC     C   -- SOR_DEP_수신계좌기본
             ON    A.ACNO     =  C.ACNO

    --WHERE    1=1
    --AND      A.LDGR_STCD  =  '1'
    --AND      A.NARN_ACCR_DCNT >  15
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


