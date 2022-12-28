/*
  프로그램명 : ins_TB_OPE_KRI_카드마케팅팀03
  타켓테이블 : TB_OPE_KRI_카드마케팅팀03
  협      조 : 박은경대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 카드마케팅팀-03 : 지점 보관 중 신용카드 수(전체)
       A: 영업점/지점 보관등록일로부터 5영업일 초과된 신용카드 및 체크카드 수
*/
DECLARE
  P_BASEDAY  VARCHAR2(8);  -- 기준일자
  P_SOTM_DT  VARCHAR2(8);  -- 당월초일
  P_EOTM_DT  VARCHAR2(8);  -- 당월말일
  P_D5_BF_SLS_DT  VARCHAR2(8);  -- 5일전영업일자
  P_LD_CN    NUMBER;  -- 로딩건수

BEGIN
  SELECT  STD_DT,EOTM_DT,SUBSTR(EOTM_DT,1,6) || '01',D5_BF_SLS_DT
  INTO    P_BASEDAY
         ,P_EOTM_DT
         ,P_SOTM_DT
         ,P_D5_BF_SLS_DT
  FROM   DWZOWN.OM_DWA_DT_BC
  WHERE   STD_DT = '&1';
  
  IF P_EOTM_DT = P_BASEDAY  THEN

    DELETE OPEOWN.TB_OPE_KRI_카드마케팅팀03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_카드마케팅팀03
    SELECT
            P_BASEDAY
           ,T.HGOV_BRNO
           ,Y.BR_NM
           ,T.CRD_PRD_DSCD
/*
           ,CASE WHEN T.CRD_PRD_DSCD = '01' THEN '신용카드'
                 WHEN T.CRD_PRD_DSCD = '02' THEN '파트너체크카드'
                 WHEN T.CRD_PRD_DSCD = '03' THEN '프라임체크카드'
                 WHEN T.CRD_PRD_DSCD = '04' THEN '정부구매카드'
                 WHEN T.CRD_PRD_DSCD = '05' THEN '면세유카드'
                 WHEN T.CRD_PRD_DSCD = '06' THEN '주류구매전용카드'
                 WHEN T.CRD_PRD_DSCD = '07' THEN '연구비카드'
                 WHEN T.CRD_PRD_DSCD = '08' THEN '선불카드'
                 WHEN T.CRD_PRD_DSCD = '09' THEN '현금IC카드'
                 WHEN T.CRD_PRD_DSCD = '10' THEN '직불카드'
                 WHEN T.CRD_PRD_DSCD = '11' THEN '후불하이패스카드'
                 WHEN T.CRD_PRD_DSCD = '12' THEN '모바일뱅킹IC카드'
                 WHEN T.CRD_PRD_DSCD = '13' THEN '유비터치/모바일현금카드'
                 WHEN T.CRD_PRD_DSCD = '14' THEN '전자공무원증'
                 WHEN T.CRD_PRD_DSCD = '15' THEN '뱅크머니'
                 WHEN T.CRD_PRD_DSCD = '80' THEN '장기카드대출(카드론)'
                 WHEN T.CRD_PRD_DSCD = '91' THEN '타사신용카드'
                 WHEN T.CRD_PRD_DSCD = '92' THEN '타사체크카드'
                 ELSE '해당없음' END AS 카드상품구분    --카드상품구분코드
*/                 
        --   ,T.CRD_NO            AS 카드번호
           ,T.ISN_DT            -- 카드발급일자
           ,T.SHPP_ENVL_DT      -- 카드배송일자
           ,T.BR_ACP_DT         AS 점접수일자
          -- ,CASE WHEN T.CRD_ACP_TPCD = '1' THEN '일반특송접수'
          --       WHEN T.CRD_ACP_TPCD = '2' THEN '반송분접수'
          --       WHEN T.CRD_ACP_TPCD = '3' THEN '타영업점이관접수'
          --       WHEN T.CRD_ACP_TPCD = '4' THEN '퀵배송접수'
          --6  ELSE '해당없음' END  AS 카드접수유형코드
    FROM  (
            SELECT
                   A.SHPP_ENVL_DT         /*배송봉투일자             */
                  ,A.SHPP_ENVL_NO         /*배송봉투번호             */
                  ,A.CRD_NO               /*카드번호                 */
                  ,A.HGOV_BRNO            /*교부점번호               */
                  ,C.CRD_PRD_DSCD         --카드상품구분코드
                  ,A.BR_ACP_DT            /*점접수일자               */
                  ,A.CRD_ACP_TPCD         /*카드접수유형코드         1 일반특송접수  2 반송분접수 3 타영업점이관접수 4 퀵배송접수 */
                  ,A.HLDG_CRD_PCS_DSCD    /*보유카드처리구분코드     10 접수 20 이관 30 교부 40 발송 50 폐기 */
                  ,A.SNDG_DT              /*발송일자                 */
                  ,C.ISN_DT
                  ,DECODE(C.PSSR_DSCD,'4', C.PSSR_CUST_NO, C.CUST_NO) AS CUST_NO /*고객번호 */
                  ,' ' AS BC_SNDG_NO      /*비씨발송번호             */
                  ,B.CRD_RCPL_DSCD        /*카드수령지구분코드       */
            FROM
                   TB_SOR_ISU_CRD_HGOV_TR  A    --SOR_ISU_카드교부내역
                  ,TB_SOR_ISU_CRD_SNDG_TR  B    --SOR_ISU_카드발송내역
                  ,TB_SOR_CLT_CRD_BC       C    --SOR_CLT_카드기본

            WHERE
                   A.SHPP_ENVL_DT            = B.SHPP_ENVL_DT   --배송봉투일자
              AND  A.SHPP_ENVL_NO            = B.SHPP_ENVL_NO   --배송봉투번호
              AND  A.CRD_NO                  = B.CRD_NO
              AND  B.CRD_NO                  = C.CRD_NO
              AND  A.BR_ACP_DT               < P_D5_BF_SLS_DT

            union ALL

    /* BC제휴 쿼리수정*/
            SELECT
                   A.SNDG_DT AS SHPP_ENVL_DT  /*발송일자                 */
                  ,' ' AS SHPP_ENVL_NO        /*배송봉투번호             */
                  ,A.CRD_NO                 /*카드번호                 */
                  ,A.HGOV_BRNO              /*교부점번호               */
                  ,C.CRD_PRD_DSCD         --카드상품구분코드
                  ,A.BR_ACP_DT              /*점접수일자               */
                  ,A.CRD_ACP_TPCD           /*카드접수유형코드         */
                  ,A.HLDG_CRD_PCS_DSCD      /*보유카드처리구분코드     */
                  ,A.SNDG_DT                /*발송일자                     */
                  ,C.ISN_DT
                  ,DECODE(C.PSSR_DSCD,'4', C.PSSR_CUST_NO, C.CUST_NO) AS CUST_NO /*고객번호 */
                  ,A.BC_SNDG_NO             /*비씨발송번호             */
                  ,B.CRD_RCPL_DSCD          /*카드수령지구분코드       */
            FROM
                   TB_SOR_ISU_BC_HGOV_TR   A,   -- SOR_ISU_비씨카드교부내역
                   TB_SOR_ISU_BC_SHPP_TR   B,   -- SOR_ISU_비씨카드배송내역
                   TB_SOR_CLT_CRD_BC       C    -- SOR_CLT_카드기본
            WHERE  A.CRD_NO = B.CRD_NO
              AND  A.BC_SNDG_NO =B.BC_SNDG_NO
              AND  A.CRD_NO                  = C.CRD_NO
              AND  A.BR_ACP_DT               < P_D5_BF_SLS_DT
        ) T
       , OT_DWA_DD_BR_BC  Y   -- DWA_일점기본
    WHERE 1=1
    AND T.HGOV_BRNO = Y.BRNO
    AND Y.STD_DT = P_BASEDAY
    AND HLDG_CRD_PCS_DSCD = '10'

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_카드마케팅팀03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
