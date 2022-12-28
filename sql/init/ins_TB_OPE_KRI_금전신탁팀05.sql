/*
  프로그램명 : ins_TB_OPE_KRI_금전신탁팀05
  타켓테이블 : TB_OPE_KRI_금전신탁팀05
  KRI 지표명 : 개인종합자산관리계좌(ISA) 미운용자산 보유건수
  협      조 : 추유정과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 금전신탁팀-05 개인종합자산관리계좌(ISA) 미운용자산 보유건수
       A: 전월말 기준 5만원 이상 미운용자산을 보유한 isa 계좌 건수
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

    DELETE OPEOWN.TB_OPE_KRI_금전신탁팀05
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_금전신탁팀05
    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,A.NW_DT
            ,A.EXPI_DT
            ,PD.PRD_KR_NM              -- 상품구분코드            
            ,B.PAR_AMT                 -- 미운용자산금액

    FROM     OT_DWA_INTG_DPS_BC   A     -- DWA_통합수신기본

    JOIN     TB_SOR_ISA_BNK_CST_EVL_TR B -- SOR_ISA_은행대금평가내역
             ON   A.ACNO   = B.DPS_ACNO
             AND  A.STD_DT = B.STD_DT

    JOIN     TB_SOR_CMI_BR_BC    J   -- SOR_CMI_점기본
             ON    A.ADM_BRNO   = J.BRNO

    JOIN     TB_SOR_PDF_PRD_BC  PD   -- SOR_PDF_상품기본
             ON    A.PDCD  = PD.PDCD
             AND   PD.APL_STCD = '10'

    WHERE    1=1
    AND      A.STD_DT = P_BASEDAY
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_금전신탁팀05',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT