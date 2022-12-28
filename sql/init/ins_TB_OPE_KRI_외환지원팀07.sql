/*
  프로그램명 : ins_TB_OPE_KRI_외환지원팀07
  타켓테이블 : TB_OPE_KRI_외환지원팀07
  KRI 지표명 : 수출환어음 추심전 매입후 미입금 건수
  협      조 : 남호준차장
  최초작성자 : 최상원
  KRI 지표명 :
     - 외환지원팀-07 수출환어음 추심전 매입후 미입금 건수
       A: 전월말 기준 수출환어음 매입 건 중 입금 예정일이 경과한 건수
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

    DELETE OPEOWN.TB_OPE_KRI_외환지원팀07
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_외환지원팀07
    SELECT   P_BASEDAY
            ,B.ADM_SLS_BRNO      --관리영업점번호
            ,D.BR_NM             --점명
            ,C.CUST_NM           --고객명
            ,A.REF_NO            --REF번호
            ,A.CRCD              --통화코드
            ,A.PCH_AMT           --매입금액
            ,A.ANT_EXPI_DT       --예상만기일자
            ,A.LST_EXPI_DT       --확정만기일자
            
    FROM     TB_SOR_EXP_EXP_BC A -- SOR_EXP_수출기본

    JOIN     TB_SOR_FEC_FRXC_BC B  -- SOR_FEC_외환기본
             ON   A.REF_NO =  B.REF_NO
             AND  B.FRXC_LDGR_STCD = '1'

    JOIN     TB_SOR_CUS_MAS_BC C    -- SOR_CUS_고객기본
             ON   B.CUST_NO  = C.CUST_NO

    JOIN     TB_SOR_CMI_BR_BC D    --  SOR_CMI_점기본
             ON   B.ADM_SLS_BRNO  =  D.BRNO
             AND  D.BR_DSCD = '1'   -- 1.중앙회, 2.조합

    WHERE    1=1
    AND      A.PCH_CLCT_DSCD = '1'           -- 매입추심구분코드
    AND      A.DSH_AF_OVS_ROM_SMTL_AMT = 0   -- 부도후해외입금합계금액
    AND      A.DSH_SMTL_AMT = 0              -- 부도합계금액
    AND      A.PCH_RMD > 0                   -- 매입잔액
    AND      A.SNDG_DT IS NOT NULL           -- 발송일자
    AND      NVL(A.DSH_PPM_END_DT,A.LST_EXPI_DT) < P_BASEDAY
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_외환지원팀07',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

