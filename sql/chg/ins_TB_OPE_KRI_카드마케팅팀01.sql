/*
  프로그램명 : ins_TB_OPE_KRI_카드마케팅팀01
  타켓테이블 : TB_OPE_KRI_카드마케팅팀01
  KRI 지표명 : 신용카드 부정사용 보상 종결 건수
  협      조 : 양미나차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 카드마케팅팀-01 신용카드 부정사용 보상 종결 건수
       A: 전월 중 신용카드 부정사용 보상 종결 건수 확인
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

    DELETE OPEOWN.TB_OPE_KRI_카드마케팅팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_카드마케팅팀01

    SELECT   P_BASEDAY
            ,C.CRD_MBR_ADM_BRNO
            ,J1.BR_NM
            ,C.CRD_MBR_NO       -- 카드회원번호
--            ,C.CRD_MBR_DSCD     -- 카드회원구분
            ,B.CRD_PRD_DSCD    -- 카드상품구분코드
--            ,CD1.CMN_CD_NM      -- 카드상품구분코드명
            ,A.ACD_CMPN_ACP_DT  -- 사고보상접수일자
            ,A.ACD_TMNT_DT      -- 사고종결일자
            ,A.RVN_WNA          -- 매출원화금액
            ,A.ACD_CMPN_TSK_CD  -- 사고보상업무코드
--            ,CD2.CMN_CD_NM      -- 사고보상업무코드명
    FROM
    (
     SELECT   A.CRD_NO
             ,A.ACD_CMPN_TSK_CD
             ,A.ACD_CMPN_ACP_DT
             ,A.ACD_TMNT_DT
             ,B.ACD_RVN_SNO
             ,B.RVN_WNA
     FROM     TB_SOR_CAM_ACD_CMPN_ACP_TR   A   -- SOR_CAM_사고보상접수내역
     JOIN     TB_SOR_CAM_ACD_CMPN_RVN_TR   B   -- SOR_CAM_사고보상매출내역
              ON    A.CRD_NO          =  B.CRD_NO
              AND   A.ACD_CMPN_TSK_CD =  B.ACD_CMPN_TSK_CD  -- 사고보상업무코드
              AND   A.ACD_CMPN_ACP_DT =  B.ACD_CMPN_ACP_DT  -- 사고보상접수일자
              AND   B.IPTT_JDGM_CMPL_YN   = 'Y'             -- 귀책판정완료여부

     WHERE    1=1
     AND      A.ACD_TMNT_DT  BETWEEN P_SOTM_DT AND P_EOTM_DT   -- 사고종결일자
    )   A

    JOIN     TB_SOR_CLT_CRD_BC     B     -- SOR_CLT_카드기본
             ON  A.CRD_NO   =  B.CRD_NO

    JOIN     TB_SOR_CLT_MBR_BC     C    -- SOR_CLT_회원기본
             ON  B.CRD_MBR_NO   =  C.CRD_MBR_NO

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
             ON  C.CRD_MBR_ADM_BRNO  =  J1.BRNO
             AND J1.BR_DSCD = '1'   -- 1.중앙회, 2.조합
             
/*
    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_공통코드기본
               WHERE   TPCD_NO_EN_NM = 'CRD_PRD_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD1
             ON    B.CRD_PRD_DSCD = CD1.CMN_CD

    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_공통코드기본
               WHERE   TPCD_NO_EN_NM = 'ACD_CMPN_TSK_CD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD2
             ON    A.ACD_CMPN_TSK_CD = CD2.CMN_CD
*/
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_카드마케팅팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
