/*
  프로그램명 : ins_TB_OPE_KRI_자금세탁방지팀08
  타켓테이블 : TB_OPE_KRI_자금세탁방지팀08
  KRI 지표명 : 지점의 비영리법인 KYC이행고객수
  협      조 : 최은영대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 자금세탁방지팀-08 지점의 비영리법인 KYC이행고객수
      A: 전월 중 고위험 영업점/지점의 비영리법인 KYC 이행 고객 수 확인
         기준월 중 영업점/지점의 비영리법인 KYC 이행 고객수(고위험)
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

    DELETE OPEOWN.TB_OPE_KRI_자금세탁방지팀08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_자금세탁방지팀08
    SELECT   P_BASEDAY
            ,A.BLNT_BRNO      -- 점번호
            ,J.BR_NM          -- 점명
            ,A.CUST_NO        -- 고객번호
            ,'비영리'         -- 고객구분
            ,TO_CHAR(A.VRF_ENR_DTTM,'YYYYMMDD') --  KYC이행일
            ,A.KYC_SNO        -- KYC일련번호
    FROM     TB_SOR_CUS_KYC_TR A   -- SOR_CUS_KYC내역
    JOIN     TB_SOR_CUS_MAS_BC B   -- SOR_CUS_고객기본
             ON    A.CUST_NO = B.CUST_NO
             AND   B.CUST_INF_STCD = '1'
             AND   B.CUST_AVL_CD   = '1'
             AND   B.CUST_DSCD     = '02'
             AND   B.PSNL_CD      IN ('2101', '2201', '3204',
                                      '3212', '3213', '3215',
                                      '4101', '4102', '4103',
                                      '4111', '4112', '4201',
                                      '4211', '4221', '4301',
                                      '4401', '4501', '5201',
                                      '5211')

    JOIN     TB_SOR_CMI_BR_BC    J   -- SOR_CMI_점기본
             ON    A.ENR_BRNO   = J.BRNO
             AND   J.BR_DSCD = '1'
        --     AND  (CLBR_DT IS NULL OR CLBR_DT >= '20220430')
        --     AND  (CLBR_DT IS NULL OR CLBR_DT >= P_BASEDAY)
    WHERE    1=1
    AND      TO_CHAR(VRF_ENR_DTTM,'YYYYMMDD') BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND      A.CUST_CNFM_LBL_CMPL_YN = 'Y'
    AND      A.TR_BR_DSCD    = '1'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_자금세탁방지팀08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








