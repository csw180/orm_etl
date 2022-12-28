/*
  프로그램명 : ins_TB_OPE_KRI_펀드사업팀02
  타켓테이블 : TB_OPE_KRI_펀드사업팀02
  KRI 지표명 : 해피콜서비스'수신거부' 선택후 신규가입금액(펀드)
  협      조 : 김지현대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 펀드사업팀-02 : 해피콜 서비스 '수신거부' 선택 후 신규가입금액
       A: 해피콜 서비스를 '수신거부' 선택한 신규 펀드 계좌금액
     - 펀드사업팀-03 : 영업점/지점에서 신규된 신탁 계좌 중 
       A: 해피콜 서비스를 '수신거부' 선택한 신탁 계좌 수
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

    DELETE OPEOWN.TB_OPE_KRI_펀드사업팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_펀드사업팀02
		SELECT   P_BASEDAY
		        ,T1.ADM_BRNO
		        ,J1.BR_NM
		        ,T1.NW_DT
		        ,T1.ACNO
		        ,T1.CUST_NO
		        ,CASE WHEN  T1.PDSL_MNTG_MTH_DSCD  = '8' THEN 'Y'
		              ELSE  'N'
		         END              -- 수신거부선택여부
		        ,T1.NW_DT
		        ,T2.TR_AMT
		        
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
		         
		WHERE    1=1
		AND      T1.DPS_ACN_STCD  NOT IN ('98','99') -- 신규정정, 신규취소 제외
		AND      T1.NW_DT  BETWEEN P_SOTM_DT  AND   P_EOTM_DT
		AND      T1.RTPN_DSCD  =  '00'
		AND      T1.PDSL_MNTG_MTH_DSCD  = '8'
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_펀드사업팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT



