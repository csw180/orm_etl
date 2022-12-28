/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀12
  타켓테이블 : TB_OPE_KRI_수신제도지원팀12
  KRI 지표명 : 양도성예금증서 발행 명세
  협      조 : 이효정
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀12 : 양도성예금증서 발행 명세
       A: 1억원 이상의 양도성예금증서(실물)의 발행 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀12
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀12
    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,C.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,'실물'         -- 양도성예금증서구분
            ,B.IMCW_NO      -- 양도성예금증서번호
            ,A.PRPR_AMT     -- 양도성예금증서_액면금액
            ,A.LDGR_RMD     -- 매출금액
            ,A.NW_DT        -- 양도서예금증서발행일
            ,D.TR_USR_NO    -- 조작자직원번호

    FROM     OT_DWA_INTG_DPS_BC  A    -- DWA_통합수신기본

    JOIN     TB_SOR_DEP_DPAC_BC  B    -- SOR_DEP_수신계좌기본
             ON   A.ACNO  =   B.ACNO

    JOIN     TB_SOR_CMI_BR_BC C      -- SOR_CMI_점기본
             ON   A.ADM_BRNO = C.BRNO

    LEFT OUTER JOIN
             TB_SOR_DEP_TR_TR  D    -- SOR_DEP_거래내역
             ON   A.ACNO   =  D.ACNO
             AND  A.NW_DT  =  D.RCFM_DT
             AND  D.DPS_TSK_CD = '0101'  -- '0101':신규
             AND  D.DPS_TR_STCD  =  '1'

    WHERE    1=1
    AND      A.STD_DT  = P_BASEDAY
    AND      A.PDCD = '10121002800011' -- 양도성예금증서(실물발행)
    AND      A.DPS_ACN_STCD  =  '01'   -- 수신계좌상태코드 (01:활동)
    AND      A.NW_DT  BETWEEN  P_SOTM_DT  AND  P_EOTM_DT
    AND      A.PRPR_AMT  >= 100000000
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀12',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


