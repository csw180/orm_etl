/*
  프로그램명 : ins_TB_OPE_KRI_카드마케팅팀04
  타켓테이블 : TB_OPE_KRI_카드마케팅팀04
  협      조 : 박은경대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 카드마케팅팀-04 : 반송카드 수
       A: 기간 중 배송오류 등으로 반송된 카드 건수
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

    DELETE OPEOWN.TB_OPE_KRI_카드마케팅팀04
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_카드마케팅팀04
    SELECT
            P_BASEDAY
           ,Z.BRNO
           ,Y.BR_NM
           ,Z.ISN_DT                 -- 발급일자
           ,Z.SHPP_RQS_DT            -- 배송요청일자
           ,Z.SNBK_DT                -- 반송일자
           ,Z.SPXP_SNBK_RSCD         -- 반송사유
           --,CD.CMN_CD_NM

    FROM (
                SELECT  A.SNBK_DT
                       ,A.SPXP_SNBK_RSCD     -- 특송반송사유코드
                       ,A.SHPP_ENVL_NO
                       ,A.CRD_NO
                       ,A.SHPP_CRD_CNT
                       ,C.SHPP_CRD_THPR_CUST_NM
                       ,C.SHPP_CRD_THPR_RRNO
                       ,A.SHPP_MHCD
                       ,C.SHPP_RQS_DT
                       ,DECODE(B.PSSR_DSCD,'4', B.PSSR_CUST_NO, B.CUST_NO) AS CUST_NO
                       ,B.ISN_PGRS_STCD
                       ,' ' AS BC_SNDG_NO
                       ,A.CRD_RCPL_DSCD
                       ,C.CRD_ADM_BRNO AS BRNO
                       ,B.ISN_DT
                       ,B.CRD_PRD_DSCD
                  FROM
                        TB_SOR_ISU_CRD_SNDG_TR      A   --SOR_ISU_카드발송내역
                       ,TB_SOR_CLT_CRD_BC           B   --SOR_CLT_카드기본
                       ,TB_SOR_ISU_CRD_SHPP_RQS_TR  C   --SOR_ISU_카드배송요청내역

                 WHERE
                        A.CRD_NO             = B.CRD_NO
                   AND  A.CRD_SHPP_NO        = C.CRD_SHPP_NO      --카드배송번호
                   AND  A.SHPP_ENVL_DT     BETWEEN P_SOTM_DT  AND  P_EOTM_DT  --배송봉투일자
                   AND  C.SHPP_CRD_RCPL_DSCD <> '5'                  --배송카드수령지구분코드
                   AND (C.CRD_ADM_BRNO       in (SELECT BRNO
                                                 FROM TB_SOR_CMI_BR_BC
                                                 WHERE INTG_BRNO = A.HGOV_BRNO   --통합점번호
                                                 AND CLBR_DT <> ' ')      --폐점일자
                        OR C.CRD_ADM_BRNO    = A.HGOV_BRNO)
                   AND  B.ISN_PGRS_STCD      = '770'   --발급진행상태코드 : 770 발송완료(배송시작)
                   AND  A.SNBK_DT          BETWEEN P_SOTM_DT  AND P_EOTM_DT  -- 반송일자
                   AND  NOT (A.SHPP_ENVL_DT  = ' ' AND A.CRD_NO < ' ' )

                UNION  ALL

                SELECT  A.SNBK_DT
                       ,A.SPXP_SNBK_RSCD     -- 특송반송사유코드
                       ,A.SHPP_ENVL_NO
                       ,A.CRD_NO
                       ,A.SHPP_CRD_CNT
                       ,C.SHPP_CRD_THPR_CUST_NM
                       ,C.SHPP_CRD_THPR_RRNO
                       ,A.SHPP_MHCD
                       ,C.SHPP_RQS_DT
                       ,DECODE(B.PSSR_DSCD,'4', B.PSSR_CUST_NO, B.CUST_NO) AS CUST_NO
                       ,B.ISN_PGRS_STCD
                       ,' ' AS BC_SNDG_NO
                       ,A.CRD_RCPL_DSCD
                       ,D.HGOV_BRNO AS BRNO
                       ,B.ISN_DT
                       ,B.CRD_PRD_DSCD
                  FROM
                        TB_SOR_ISU_CRD_SNDG_TR      A   --SOR_ISU_카드발송내역
                       ,TB_SOR_CLT_CRD_BC           B   --SOR_CLT_카드기본
                       ,TB_SOR_ISU_CRD_SHPP_RQS_TR  C   --SOR_ISU_카드배송요청내역
                       ,TB_SOR_ISU_CRD_HGOV_TR      D   --SOR_ISU_카드교부내역
                 WHERE
                        A.CRD_NO             = B.CRD_NO
                   AND  A.CRD_SHPP_NO        = C.CRD_SHPP_NO
                   AND  A.SHPP_ENVL_DT       = D.SHPP_ENVL_DT
                   AND  A.SHPP_ENVL_NO       = D.SHPP_ENVL_NO
                   AND  A.CRD_NO             = D.CRD_NO
                   AND  A.SHPP_ENVL_DT     BETWEEN P_SOTM_DT  AND  P_EOTM_DT  --배송봉투일자
                   AND  C.SHPP_CRD_RCPL_DSCD <> '5'
                   AND  B.ISN_PGRS_STCD      = '920'    --발급진행상태코드 : 920 영업점이관
                   AND  D.HLDG_CRD_PCS_DSCD  = '20'     --보유카드처리구분코드 : 20 이관
                   AND  A.SNBK_DT          BETWEEN P_SOTM_DT  AND P_EOTM_DT
                   AND  NOT (A.SHPP_ENVL_DT  = ' ' AND A.CRD_NO < ' ' )

                UNION  ALL

                SELECT  A.SNBK_DT
                       ,A.SPXP_SNBK_RSCD     -- 특송반송사유코드
                       ,A.SHPP_ENVL_NO
                       ,A.CRD_NO
                       ,A.SHPP_CRD_CNT
                       ,' ' AS SHPP_CRD_THPR_CUST_NM
                       ,' ' AS SHPP_CRD_THPR_RRNO
                       ,A.SHPP_MHCD
                       ,C.PCS_DT
                       ,DECODE(B.PSSR_DSCD,'4', B.PSSR_CUST_NO, B.CUST_NO) AS CUST_NO
                       ,C.ISN_PGRS_STCD
                       ,' ' AS BC_SNDG_NO
                       ,A.CRD_RCPL_DSCD
                       ,B.CRD_RECV_BRNO AS BRNO
                       ,B.ISN_DT
                       ,B.CRD_PRD_DSCD
                 FROM
                       (
                         SELECT CRD_NO
                               ,SHPP_ENVL_DT
                               ,SHPP_ENVL_NO
                               ,SHPP_CRD_CNT
                               ,SHPP_MHCD
                               ,CRD_RCPL_DSCD
                               ,SNBK_DT
                               ,SPXP_SNBK_RSCD
                               ,ROW_NUMBER() OVER (PARTITION BY CRD_NO ORDER BY SHPP_ENVL_DT DESC, SHPP_ENVL_NO DESC) AS 순서
                         FROM   TB_SOR_ISU_CRD_SNDG_TR  A  --SOR_ISU_카드발송내역
                         WHERE  SHPP_ENVL_DT   BETWEEN P_SOTM_DT  AND  P_EOTM_DT
                        )  A
                       ,TB_SOR_CLT_CRD_BC           B       --SOR_CLT_카드기본
                       ,(
                         SELECT CRD_NO
                               ,PGRS_SNO
                               ,ISN_PGRS_STCD
                               ,PCS_DT
                               ,PCS_TM
                               ,ISN_PGRS_DTL_CTS
                               ,ROW_NUMBER() OVER (PARTITION BY CRD_NO ORDER BY PGRS_SNO DESC) AS 순서
                         FROM   TB_SOR_ISU_CRD_ISN_PGRS_TR  --SOR_ISU_카드발급진행내역
                         WHERE  ISN_PGRS_STCD     IN ('772','773', '775') --발급진행상태코드 : 772 카드사업팀 등기발송 / 773 카드사업팀 직접배송 / 775 BC발급대행 직접배송
                       ) C

                 WHERE  1=1
                   AND  A.순서 = 1
                   AND  C.순서 = 1
                   AND  A.CRD_NO             = B.CRD_NO
                   AND  B.CRD_RCPL_DSCD      <> '5'
                   AND  B.ISN_PGRS_STCD      = '770'
                   AND  A.CRD_NO             = C.CRD_NO
                   AND  A.SNBK_DT  BETWEEN P_SOTM_DT  AND P_EOTM_DT
                   AND  NOT (A.SHPP_ENVL_DT  = ' ' AND A.CRD_NO <' ' )

                UNION  ALL

                /*그린은련 추가로 인한 추가*/
                SELECT  D.SNBK_DT
                       ,D.SPXP_SNBK_RSCD     -- 특송반송사유코드
                       ,' ' AS SHPP_ENVL_NO
                       ,D.CRD_NO
                       ,D.SHPP_CRD_CNT
                       ,'' AS SHPP_CRD_THPR_CUST_NM
                       ,'' AS CUST_RNNO
                       ,D.SHPP_MHCD
                       ,D.SNDG_DT
                       ,DECODE(B.PSSR_DSCD,'4', B.PSSR_CUST_NO, B.CUST_NO) AS CUST_NO
                       ,B.ISN_PGRS_STCD
                       ,D.BC_SNDG_NO
                       ,D.CRD_RCPL_DSCD
                       ,D.HGOV_BRNO AS BRNO
                       ,B.ISN_DT
                       ,B.CRD_PRD_DSCD
                  FROM
                        TB_SOR_ISU_BC_SHPP_TR      D   --SOR_ISU_비씨카드배송내역
                       ,TB_SOR_CLT_CRD_BC          B   --SOR_CLT_카드기본

                 WHERE  D.CRD_NO             = B.CRD_NO
                   AND  D.SNDG_DT   BETWEEN P_SOTM_DT  AND  P_EOTM_DT
                   AND  D.CRD_RCPL_DSCD     <> '5'
                   AND  D.HGOV_BRNO       in (SELECT BRNO
                                              FROM TB_SOR_CMI_BR_BC
                                              WHERE INTG_BRNO = D.HGOV_BRNO
                                              AND CLBR_DT <> ' ')
    --                    OR D.HGOV_BRNO    = A.HGOV_BRNO)
                   AND  B.ISN_PGRS_STCD      = '770'   --발급진행상태코드 : 770 발송완료(배송시작)
                   AND  D.SNBK_DT  BETWEEN P_SOTM_DT  AND P_EOTM_DT
                   AND  NOT (D.SNDG_DT  = ' ' AND D.CRD_NO < ' ' )


                UNION ALL

                SELECT  D.SNBK_DT
                       ,D.SPXP_SNBK_RSCD     -- 특송반송사유코드
                       ,' ' AS SHPP_ENVL_NO
                       ,D.CRD_NO
                       ,D.SHPP_CRD_CNT
                       ,'' AS SHPP_CRD_THPR_CUST_NM
                       ,'' AS CUST_RNNO
                       ,D.SHPP_MHCD
                       ,D.SNDG_DT
                       ,DECODE(B.PSSR_DSCD,'4', B.PSSR_CUST_NO, B.CUST_NO) AS CUST_NO
                       ,B.ISN_PGRS_STCD
                       ,D.BC_SNDG_NO
                       ,D.CRD_RCPL_DSCD
                       ,F.HGOV_BRNO AS BRNO
                       ,B.ISN_DT
                       ,B.CRD_PRD_DSCD
                  FROM
                        TB_SOR_ISU_BC_SHPP_TR       D    -- SOR_ISU_비씨카드배송내역
                       ,TB_SOR_CLT_CRD_BC           B    -- SOR_CLT_카드기본
                       ,TB_SOR_ISU_BC_HGOV_TR       F    -- SOR_ISU_비씨카드교부내역

                 WHERE
                        D.CRD_NO             = B.CRD_NO
                   AND  D.CRD_NO             = F.CRD_NO
                   AND  D.SNDG_DT   BETWEEN P_SOTM_DT  AND  P_EOTM_DT
                   AND  D.CRD_RCPL_DSCD     <> '5'
                   AND  B.ISN_PGRS_STCD      = '920'
                   AND  F.HLDG_CRD_PCS_DSCD  = '20'
                   AND  D.SNBK_DT  BETWEEN P_SOTM_DT  AND P_EOTM_DT
                   AND  NOT (D.SNDG_DT  = ' ' AND D.CRD_NO < ' ' )
         ) Z
        , OT_DWA_DD_BR_BC  Y
        /*
        , (
             select CMN_CD,CMN_CD_NM
             from  OM_DWA_CMN_CD_BC  -- DWA_공통코드기본
             where TPCD_NO_EN_NM = 'CRD_RCPL_DSCD'    -- 고객정보변경구분코드
             and   CMN_CD_US_YN = 'Y'  -- 공통코드사용여부
           ) CD
           */
    WHERE 1=1
    AND   Z.BRNO = Y.BRNO
    AND   Y.STD_DT = P_BASEDAY
    --AND   Z.SPXP_SNBK_RSCD = CD.CMN_CD

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_카드마케팅팀04',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
