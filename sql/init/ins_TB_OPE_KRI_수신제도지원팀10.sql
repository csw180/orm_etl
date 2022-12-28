/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀10
  타켓테이블 : TB_OPE_KRI_수신제도지원팀10
  KRI 지표명 : 예금 신규당일에 잔액증명서 발급한 계좌건수
  협      조 : 김다은주임
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-10 예금 신규당일에 잔액증명서 발급한 계좌건수
       A: 전월 수신계좌중 신규일 당일 예외기록부원장에 잔액증명발급으로 등록된 점별 계좌건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀10
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀10
    SELECT   P_BASEDAY
            ,B.ISN_BRNO  -- 발급점번호
            ,J.BR_NM
            ,A.ACNO      -- 계좌번호
            ,A.CUST_NO   -- 고객번호
            ,A.NW_DT     -- 신규일자
            ,'Y'
            ,B.ISN_DT    -- 발급일자
            --,B.ISN_STD_DT -- 발급기준일자
    FROM     TB_SOR_DEP_DPAC_BC A   -- SOR_DEP_수신계좌기본
    JOIN     TB_SOR_DEP_CFWR_ISN_TR B  -- SOR_DEP_증명서발급내역
             ON    A.ACNO  = B.ACNO
             AND   A.NW_DT = B.ISN_DT
             AND   B.CFWR_ISN_KDCD IN ('001', '002') -- 증명서발급종류코드 001: 잔액증명서(국문), 002: 잔액증명서(영문)
             AND   B.RMD_PRF_TGT_TSK_DSCD = '1' -- 수신계좌
             AND   B.LDGR_STCD = '1'
    JOIN     TB_SOR_CMI_BR_BC   J     --  SOR_CMI_점기본
             ON    B.ISN_BRNO = J.BRNO
    WHERE    1=1
    AND      A.NW_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT -- 신규일자
    AND      A.ACNO < '200000000000' -- 은행계좌
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀10',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT





