/*
  프로그램명 : ins_TB_OPE_KRI_펀드사업팀07
  타켓테이블 : TB_OPE_KRI_펀드사업팀07
  KRI 지표명 : 펀드수익률통보 미등록 계좌 건수
  협      조 : 김지현대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 펀드사업팀-07 : 펀드수익률통보 미등록 계좌 건수
       A: 전월중 개설한 신규계좌 중 펀드수익률통보서비스, 목표수익률, 위험수익률,
          실질투자수익률 알림서비스 전부 등록하지 않은 계좌건수
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

    DELETE OPEOWN.TB_OPE_KRI_펀드사업팀07
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_펀드사업팀07
		SELECT   P_BASEDAY
		        ,T1.ADM_BRNO
		        ,J1.BR_NM
		        ,T1.NW_DT
		        ,T1.ACNO
		        ,PD2.PRD_KR_NM
		        ,T1.CUST_NO
		--        ,ROUND(T1.BLN_ACNT * T2.STD_PRC / 1000, 0)  -- 평가금액
		--        ,GL_ERN_RT
		--        ,RSK_ERN_RT
		--        ,FUND_BLN_DPC_DSCD
		
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
		
		JOIN     TB_SOR_PDF_FND_BC     PD1  -- SOR_PDF_펀드기본
		         ON   T1.PDCD  =  PD1.PDCD
		         AND  PD1.ELF_FUND_YN  =  'N'
		         AND  PD1.INVM_TGT_DSCD  NOT IN ('01')
		         AND  PD1.APL_STCD  = '10'  -- 적용상태코드: 활동(10)
		
		LEFT OUTER JOIN
		         TB_SOR_PDF_PRD_BC    PD2   -- SOR_PDF_상품기본
		         ON   T1.PDCD  =  PD2.PDCD
		         AND  PD2.APL_STCD  = '10'  -- 적용상태코드: 활동(10)
		         AND  PD2.PRD_DSCD  = '01'  -- 상품구분코드 : 펀드기본(01)
		
		JOIN     TB_SOR_BCM_STD_PRC_TR   T2  -- SOR_BCM_펀드기준가격내역
		         ON   T1.PDCD  =  T2.PDCD
		         AND  T2.STD_DT = ( SELECT MAX(STD_DT) FROM TB_SOR_BCM_STD_PRC_TR WHERE STD_DT <= P_BASEDAY )
		                -- STD_DT에 모든날짜가 있지 않아서 최근일로 반영함
		
		WHERE    1=1
		AND      T1.DPS_ACN_STCD  NOT IN ('98','99') -- 신규정정, 신규취소 제외
		AND      T1.NW_DT  BETWEEN P_SOTM_DT  AND   P_EOTM_DT
		AND      T1.RTPN_DSCD  =  '00'
		AND      T1.FUND_BLN_DPC_DSCD = '0'  -- 0:원하지 않음, 4:이메일, 5:문자
		AND      T1.GL_ERN_RT =  0
		AND      T1.RSK_ERN_RT = 0
		AND      T1.SVN_TPCD  NOT IN ('12')
		AND      ROUND(T1.BLN_ACNT * T2.STD_PRC / 1000, 0) > 100000
		;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_펀드사업팀07',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT





