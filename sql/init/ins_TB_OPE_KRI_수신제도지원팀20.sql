/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀20
  타켓테이블 : TB_OPE_KRI_수신제도지원팀20
  협      조 : 이효정과장
  최조작성자 : 최상원  
  KRI 지표명 :
     - 수신제도지원팀20 : 고액예금 정정거래 건수
       A: 전월 발생한 원화 정기성예금 50백만원 이상 신규 입금정정/취소거래 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀20
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀20

    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.ACNO
            ,A.CUST_NO
            ,PD.PRD_KR_NM
            ,A.DPS_ACN_STCD
--            ,A.NW_DT
            ,A.LST_TR_DT
            ,A.LDGR_RMD

    FROM     OT_DWA_INTG_DPS_BC  A    -- DWA_통합수신기본

    JOIN     TB_SOR_CMI_BR_BC J       -- SOR_CMI_점기본
             ON   A.ADM_BRNO = J.BRNO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC  PD   -- SOR_PDF_상품기본
             ON   A.PDCD   = PD.PDCD
             AND  PD.APL_STCD  =  '10'

    WHERE    1=1
    AND      A.STD_DT  = P_BASEDAY
    AND      A.SBCD  =   '120'                -- 원화정기예금
    AND      A.LDGR_RMD  >= 50000000          -- 50백만원이상
    AND      A.DPS_ACN_STCD  IN   ('98','99') -- 수신계좌상태코드 98:신규정정,99:신규취소
    AND      A.LST_TR_DT BETWEEN P_SOTM_DT  AND  P_EOTM_DT
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀20',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


