/*
  프로그램명 : ins_TB_OPE_KRI_카드기획팀01
  타켓테이블 : TB_OPE_KRI_카드기획팀01
  KRI 지표명 : 신용카드(개인) 특별한도 승인건수
  협      조 : 장선미차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 카드기획팀-01 신용카드(개인) 특별한도 승인건수
       A: 영업점/지점에서 신용카드 개인회원에 대해 특별한도를 승인한 건수
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

    DELETE OPEOWN.TB_OPE_KRI_카드기획팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_카드기획팀01

    SELECT   A.STD_DT
            ,A.CRD_MBR_ADM_BRNO
            ,J1.BR_NM
            ,A.CRD_MBR_DSCD
            ,A.PREN_DSCD
            ,B.CUST_SPCL_LMT_AMT
            ,B.SPCL_LMT_APC_RSN            -- 특별한도신청사유
         --   ,B.SPCL_LMT_EVD_PPR_CTS        --특별한도증빙서류내용
            ,B.LMT_CHG_USR_NO
            ,B.LMT_CHG_DT                --한도변경일자
    FROM     (
              SELECT   STD_DT
                      ,CRD_MBR_ADM_BRNO
                      ,CUST_NO
                      ,CRD_MBR_NO
                      ,CRD_MBR_DSCD
                      ,PREN_DSCD
              FROM     OT_DWA_INTG_CRD_BC    A   -- DWA_통합카드기본
              WHERE    1=1
              AND      A.STD_DT  =  P_BASEDAY
              AND      A.PREN_DSCD     =  '1'  -- 개인
              AND      A.CRD_MBR_DSCD  =  '1'  -- 카드회원구분 (1:신용)
              GROUP BY STD_DT
                      ,CRD_MBR_ADM_BRNO
                      ,CUST_NO
                      ,CRD_MBR_NO
                      ,CRD_MBR_DSCD
                      ,PREN_DSCD
             )  A
    JOIN     TB_SOR_MBR_LMT_CHG_HT  B    --SOR_MBR_카드고객한도변경이력
             ON   A.CRD_MBR_NO    =  B.CRD_MBR_NO
             AND  B.LMT_CHG_HDCD  =  '14'  -- 한도변경항목코드(14:국내특별한도)
             AND  B.CUST_SPCL_LMT_AMT  > 0  --   고객특별한도금액, 특별한도를 줄인경우는 제외
             AND  B.LMT_CHG_DT  BETWEEN  P_SOTM_DT  AND   P_EOTM_DT

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
             ON  A.CRD_MBR_ADM_BRNO  =  J1.BRNO

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_카드기획팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
