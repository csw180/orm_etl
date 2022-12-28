/*
  프로그램명 : ins_TB_OPE_KRI_펀드사업팀10
  타켓테이블 : TB_OPE_KRI_펀드사업팀10
  KRI 지표명 : 질권설정된 펀드 환매 신청 건수
  협      조 : 김지현대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 펀드사업팀-10: 질권설정된 펀드 환매 신청 건수
       A: 질권설정된 펀드 환매 신청 건수
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

    DELETE OPEOWN.TB_OPE_KRI_펀드사업팀10
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_펀드사업팀10
    SELECT   P_BASEDAY
            ,T1.ADM_BRNO
            ,J1.BR_NM
            ,T1.ACNO
            ,T1.CUST_NO
            ,'Y'    -- 질권설정여부
            ,T2.STLM_DT

    FROM     TB_SOR_BCM_BNAC_BC    T1     -- SOR_BCM_수익증권계좌기본

    JOIN     TB_SOR_BCM_RPCH_APC_TR    T2  -- SOR_BCM_환매신청내역
             ON   T1.ACNO   = T2.ACNO
             AND  T2.STLM_DT   BETWEEN  P_SOTM_DT AND P_EOTM_DT
             AND  T2.CNCL_YN =  'N'

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
             ON    T1.ADM_BRNO  =  J1.BRNO


    JOIN     TB_SOR_BCM_ROP_BC    T3    --SOR_BCM_질권설정기본
             ON   T1.ACNO   = T3.ACNO
             AND  T3.CNCL_YN =  'N'

    WHERE    1=1
    AND      T2.STLM_DT   BETWEEN  T3.ENR_DT AND NVL(T3.RLS_DT,'99991231')
             -- 환매대금지급일자가 질권등록일자와 해제일자사이에 있는지 확인

    UNION ALL

    SELECT   P_BASEDAY
            ,T1.ADM_BRNO
            ,J1.BR_NM
            ,T1.ACNO
            ,T1.CUST_NO
            ,'Y'    -- 질권설정여부
            ,T2.TR_DT

    FROM     TB_SOR_BCM_BNAC_BC    T1     -- SOR_BCM_수익증권계좌기본

    JOIN     TB_SOR_BCM_DRW_TR    T2       -- SOR_BCM_출금내역
             ON   T1.ACNO   =   T2.ACNO
             AND  T2.TR_DT  BETWEEN  P_SOTM_DT AND P_EOTM_DT
             AND  T2.CNCL_YN  =  'N'

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
             ON    T1.ADM_BRNO  =  J1.BRNO

    JOIN     TB_SOR_BCM_ROP_BC    T3    --SOR_BCM_질권설정기본
             ON   T2.ACNO   = T3.ACNO
             AND  T3.CNCL_YN =  'N'

    JOIN     TB_SOR_PDF_FND_BC     PD1  -- SOR_PDF_펀드기본
             ON   T1.PDCD  =  PD1.PDCD
             AND  P_BASEDAY  BETWEEN PD1.APL_ST_DT  AND PD1.APL_END_DT
             AND  PD1.INVM_TGT_DSCD  =  '01'
             AND  PD1.APL_STCD  = '10'  -- 적용상태코드: 활동(10)

    WHERE    1=1
    AND      T2.TR_DT   BETWEEN  T3.ENR_DT AND NVL(T3.RLS_DT,'99991231')
             -- 환매대금지급일자가 질권등록일자와 해제일자사이에 있는지 확인

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_펀드사업팀10',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT





