/*
  프로그램명 : ins_TB_OPE_KRI_론리뷰팀02
  타켓테이블 : TB_OPE_KRI_론리뷰팀02
  KRI 지표명 : 감리등급 이행사항 미등록 기업 수
  협      조 : 선민국차장
  최조작성자 : 최상원
  KRI 지표명 :
   - 론리뷰팀-02 감리등급 이행사항 미등록 기업 수
     A: 감리등급 부여 후 해당 분기말까지 영업점/지점에서 이행사항을 등록하지 않은 기업 수
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

    DELETE OPEOWN.TB_OPE_KRI_론리뷰팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_론리뷰팀02
    SELECT   P_BASEDAY
            ,A.BRNO
            ,D.BR_NM
            ,A.ACN_DCMT_NO
            ,A.CUST_NO
            ,A.PREN_DSCD AS 개인기업구분
            ,'전결여신' AS DSCD
            ,PD.PRD_KR_NM
            ,A.CRCD
            ,A.APRV_AMT
            ,A.TOT_CLN_RMD
            ,A.CLN_APRV_DT
            ,C.APRV_LN_EXPI_DT
            ,B.LNRV_JDGM_DSCD   -- 론리뷰판정구분코드(01:적정,02:조건부적정,03:보완,04:부적정,05:판정없음)
            ,B.JDGM_DT          -- 판정일자
            ,'N'                -- 이행여부구분코드

    FROM     TB_SOR_EWL_LN_XCDC_CLN_BC A  --  SOR_EWL_론리뷰전결여신기본

    JOIN     TB_SOR_EWL_LN_XCLN_JDGM_TR    B  -- SOR_EWL_론리뷰전결여신판정내역
             ON    A.TGT_ABST_DT = B.TGT_ABST_DT  -- 대상추출일자
             AND   A.CLN_APC_NO  = B.CLN_APC_NO
             AND   B.LNRV_JDGM_DSCD IN ('02','03','04')

    JOIN     TB_SOR_CLI_CLN_APRV_BC C    -- SOR_CLI_여신승인기본
             ON    A.CLN_APC_NO  = C.CLN_APC_NO

    JOIN     TB_SOR_CMI_BR_BC D      -- SOR_CMI_점기본
             ON    A.BRNO = D.BRNO
             
    LEFT OUTER JOIN
            TB_SOR_PDF_PRD_BC  PD
            ON  C.PDCD   = PD.PDCD
            AND PD.APL_STCD ='10'
                      
    WHERE    1=1
    AND      A.NFFC_UNN_DSCD = '1'
    AND      A.DEL_YN = 'N'
    AND      A.EXC_TGT_YN = 'N'
    AND      A.XCDC_CLN_PGRS_STCD in ('03','04','05','06','07')
    AND      A.TGT_ABST_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      NOT(
                 (A.XCDC_CLN_PGRS_STCD = '05' AND A.LNRV_STS_DSCD = '02') OR
                 (A.XCDC_CLN_PGRS_STCD = '07' AND A.LNRV_STS_DSCD = '02')
                )                
--## XCDC_CLN_PGRS_STCD (전결여신진행상태코드)
--01:미진행,02:재심사,03:지적여신,04:조치사항이행등록
--05:조치사항점검,06:이의신청,07:재판정
--## LNRV_STS_DSCD (론리뷰상태구분코드)
--01:진행중,02:완료,03:완결,04:결재중
                
    AND      NOT EXISTS
                (
                  SELECT 1
                  FROM   TB_SOR_EWL_AFM_EXG_TR X   -- SOR_EWL_론리뷰제외대상내역
                  WHERE  TGT_ABST_DT = A.TGT_ABST_DT
                  AND    CUST_NO= A.CUST_NO
                )

    UNION  ALL

    SELECT   P_BASEDAY
            ,A.SLS_BRNO AS BRNO
            ,D.BR_NM
            ,C.ACN_DCMT_NO
            ,A.CUST_NO
            ,'' AS 개인기업구분
            ,'승인여신' AS DSCD
            ,PD.PRD_KR_NM
            ,C.CRCD
            ,C.APRV_AMT
            ,0 --A.TOT_CLN_RMD --
            ,C.APRV_DT
            ,C.APRV_LN_EXPI_DT
            ,''
            ,B.DPC_DT
            ,'N'                -- 이행여부구분코드

    FROM     TB_SOR_EWL_LN_APCL_BC A         --  SOR_EWL_론리뷰승인여신기본

    JOIN     TB_SOR_EWL_LN_APCL_ACTN_DL B    --  SOR_EWL_론리뷰승인여신조치상세(DW 적재필요)
             ON    A.TGT_ABST_DT = B.TGT_ABST_DT
             AND   A.CUST_NO     = B.CUST_NO
             AND   A.JUD_APRV_NO = B.JUD_APRV_NO
             AND   LENGTH(B.ACTN_ITM_ESTM_CTS) > 5

    JOIN     TB_SOR_CLI_CLN_APRV_BC C        --  SOR_CLI_여신승인기본
             ON    A.JUD_APRV_NO = C.CLN_APRV_NO

    JOIN     TB_SOR_CMI_BR_BC D        -- SOR_CMI_점기본
             ON    A.SLS_BRNO = D.BRNO

    LEFT OUTER JOIN
            TB_SOR_PDF_PRD_BC  PD
            ON  C.PDCD   = PD.PDCD
            AND PD.APL_STCD ='10'

    WHERE    1=1
    AND      A.NFFC_UNN_DSCD = '1'
    AND      A.DEL_YN        = 'N'
    AND      A.EXC_TGT_YN    = 'N'
    AND      A.APCL_PGRS_STCD IN ('13','14','15')
    AND      A.TGT_ABST_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      NOT (A.APCL_PGRS_STCD = '15' AND A.LNRV_STS_DSCD = '02')
--## APCL_PGRS_STCD(승인여신진행상태코드)
--11:미진행,12:재심사/조치사항수립(본부),13:승인여신통보(본부),14:조치사항이행(점)
--15:조치사항점검(본부)    
--## LNRV_STS_DSCD(론리뷰상태구분코드)
--01:진행중,02:완료,03:완결,04:결재중
    AND      NOT EXISTS
                (
                  SELECT 1
                  FROM   TB_SOR_EWL_AFM_EXG_TR X   -- SOR_EWL_론리뷰제외대상내역
                  WHERE  TGT_ABST_DT = A.TGT_ABST_DT
                  AND    CUST_NO= A.CUST_NO
                )
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_론리뷰팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT