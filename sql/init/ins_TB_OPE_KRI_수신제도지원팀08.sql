/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀08
  타켓테이블 : TB_OPE_KRI_수신제도지원팀08
  KRI 지표명 : 예금잔액증명서 발급취소건수
  협      조 : 김다은주임
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-08 예금잔액증명서 발급취소건수
       A: 조회일 발생한 예금잔액증명서(신탁,중금채, 외화예금 포함) 발급취소건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀08
    SELECT   P_BASEDAY
            ,A.ISN_CNCL_BRNO  -- 발급취소점번호
            ,B.BR_NM
            ,A.ACNO           -- 계좌번호
            ,A.CUST_NO        -- 고객번호
            ,'1'
            ,A.CFWR_ISN_NO    -- 증명서발급번호
            ,A.ISN_DT         -- 발급일자
            ,A.LDGR_STCD      -- 원장상태코드 ( 3:취소)
--            ,A.ISN_STD_DT     -- 발급기준일자
            ,A.ISN_CNCL_DT    -- 발급취소일자
    FROM     TB_SOR_DEP_CFWR_ISN_TR A  -- SOR_DEP_증명서발급내역
    JOIN     TB_SOR_CMI_BR_BC       B  -- SOR_CMI_점기본
             ON   A.ISN_CNCL_BRNO = B.BRNO
    WHERE    1=1
    AND      A.CFWR_ISN_KDCD IN ('001', '002') -- 증명서발급종류코드 001: 잔액증명서(국문), 002: 잔액증명서(영문)
    AND      A.RMD_PRF_TGT_TSK_DSCD = '1' -- 수신계좌
    AND      A.ISN_CNCL_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT  -- 발급취소일자
    AND      A.LDGR_STCD = '3' -- 해제(취소)
    AND      A.ACNO < '200000000000' -- 은행계좌
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT





