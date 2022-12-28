/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀02
  타켓테이블 : TB_OPE_KRI_여신지원팀02
  KRI 지표명 : 담보설정금액 미달 담보여신 건수
  협      조 : 김희선과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-02 담보설정금액 미달 담보여신 건수
       A: 전월말 기준 담보여신 중 담보설정금액이 현재잔액+인출가능금액 대비 미달한 여신계좌수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀02

    WITH   TEMP1   AS  (
      SELECT ACN_DCMT_NO,SUM(STUP_AMT) STUP_AMT
      FROM     (
                SELECT
                     SUM(AA.STUP_AMT)/ COUNT(*) STUP_AMT
                    ,MAX(AA.ACN_DCMT_NO) ACN_DCMT_NO

                FROM   (
                        SELECT DISTINCT B.MRT_NO
                                    , B.STUP_NO
                                    , B.STUP_AMT
                                    , A.ACN_DCMT_NO
                        FROM    TB_SOR_CLM_CLN_LNK_TR A    -- SOR_CLM_여신연결내역
                               ,TB_SOR_CLM_STUP_BC B       -- SOR_CLM_설정기본
                        WHERE   A.STUP_NO = B.STUP_NO
                        AND     A.CLN_LNK_STCD IN ('02','03')
                       ) AA
                GROUP BY AA.STUP_NO,AA.ACN_DCMT_NO
               )
      GROUP BY ACN_DCMT_NO
    ),
    TEMP2 AS  (
      SELECT   AA.ACN_DCMT_NO , MAX(AA.STUP_NO)  STUP_NO
      FROM    (
               SELECT DISTINCT B.MRT_NO
                           , B.STUP_NO
                           , B.STUP_AMT
                           , A.ACN_DCMT_NO
               FROM   TB_SOR_CLM_CLN_LNK_TR A    -- SOR_CLM_여신연결내역
                     ,TB_SOR_CLM_STUP_BC B       -- SOR_CLM_설정기본
               WHERE  A.STUP_NO = B.STUP_NO
               AND    A.CLN_LNK_STCD IN ('02','03')
              ) AA

      WHERE    1=1
      GROUP BY AA.ACN_DCMT_NO
    )

    SELECT   T1.STD_DT
            ,T1.BRNO
            ,T2.BR_NM
            ,T1.INTG_ACNO
            ,T1.CUST_NO
    --        ,T1.CUST_NM
            ,PD.PRD_KR_NM
            ,T1.CRCD
    --        ,( SELECT PRD_KR_NM FROM  TB_SOR_PDF_PRD_BC  WHERE PDCD =T3.PDCD AND APL_STCD ='10' AND ROWNUM =1 ) PRD_KR_NM
    --        ,T1.AGR_AMT
    --        ,T1.LN_EXE_AMT
    --        ,T1.LN_RMD
            ,T1.E_LON_AMT
            ,T1.STUP_AMT
            ,T4.STUP_NO
    FROM     (
               SELECT   TA.STD_DT
                       ,TA.BRNO
                       ,TA.INTG_ACNO
                       ,TA.CUST_NO
                       ,TA.CUST_NM
                       ,TA.AGR_DT
                       ,TA.AGR_AMT
                       ,TA.MRT_CD
                       ,TA.CLN_TSK_DSCD
                       ,TA.CRCD
                       ,TA.INDV_LMT_LN_DSCD
                       ,TA.LN_EXE_AMT
                       ,TA.LN_RMD
                       ,CASE WHEN TA.INDV_LMT_LN_DSCD ='1' THEN  TA.AGR_AMT - TA.LN_EXE_AMT + TA.LN_RMD ELSE TA.AGR_AMT END  E_LON_AMT
                       ,TB.ACN_DCMT_NO
                       ,TB.STUP_AMT
               FROM     (
                         SELECT   A.STD_DT
                                 ,A.BRNO
                                 ,A.INTG_ACNO
                                 ,A.CUST_NO
                                 ,A.CUST_NM
                                 ,A.AGR_DT
                                 ,A.AGR_AMT
                                 ,A.MRT_CD
                                 ,A.INDV_LMT_LN_DSCD
                                 ,A.CLN_TSK_DSCD
                                 ,A.CRCD
                                 ,SUM(A.LN_EXE_AMT) LN_EXE_AMT
                                 ,SUM(A.LN_RMD) LN_RMD

                         FROM     OT_DWA_INTG_CLN_BC   A    -- DWA_통합여신기본

                         JOIN     OT_DWA_DD_ACSB_TR    B    -- DWA_일계정과목내역
                                  ON   A.BS_ACSB_CD  = B.ACSB_CD
                                  AND  B.STD_DT      = P_BASEDAY
                                  AND  B.ACSB_CD4    = '13000801'   --원화대출금계정
                                  AND  B.FSC_SNCD    IN ('K', 'C')

                         WHERE    1=1
                         AND      A.STD_DT = P_BASEDAY
                         AND      A.CLN_ACN_STCD =  '1'   -- 정상
                         AND      A.LN_RMD   >   0
                         AND      A.CLN_TSK_DSCD !='15'

                         GROUP BY A.STD_DT
                                 ,A.BRNO
                                 ,A.INTG_ACNO
                                 ,A.CUST_NO
                                 ,A.CUST_NM
                                 ,A.AGR_DT
                                 ,A.AGR_AMT
                                 ,A.MRT_CD
                                 ,A.INDV_LMT_LN_DSCD
                                 ,A.CLN_TSK_DSCD
                                 ,A.CRCD
                        )TA
               JOIN     TEMP1 TB
                        ON   TA.INTG_ACNO =TB.ACN_DCMT_NO

              )  T1

              JOIN    TB_SOR_CMI_BR_BC T2         --  SOR_CMI_점기본
                      ON   T1.BRNO =T2.BRNO

              JOIN    TB_SOR_LOA_ACN_BC T3        -- SOR_LOA_계좌기본
                      ON   T1.INTG_ACNO=T3.CLN_ACNO
                      AND  T3.NFFC_UNN_DSCD = '1'

              JOIN    TEMP2     T4
                      ON T1.INTG_ACNO =T4.ACN_DCMT_NO

              LEFT OUTER JOIN
                      TB_SOR_PDF_PRD_BC  PD
                      ON  T3.PDCD   = PD.PDCD
                      AND PD.APL_STCD ='10'

    WHERE    1=1
    AND      T1.E_LON_AMT >  T1.STUP_AMT  --가용여신금액이 설정금액보다큰경우
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
