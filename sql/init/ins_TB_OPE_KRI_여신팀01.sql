/*
  프로그램명 : ins_TB_OPE_KRI_여신팀01
  타켓테이블 : TB_OPE_KRI_여신팀01
  KRI 지표명 : 여신 관련 취소 거래 건수
  협      조 : 이천수과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 여신팀-01 여신 관련 취소 거래 건수
       A: 여신관련 기산일 거래내역 중 취소 건수
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

    DELETE OPEOWN.TB_OPE_KRI_여신팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신팀01
    SELECT      P_BASEDAY                                              AS 기준일자
               ,BR.BRNO                                                AS 점번호
               ,TRIM(BR.BR_NM)                                         AS 점명
               ,CU.CUST_NO                                             AS 고객번호
               ,A.CLN_ACNO                                             AS 계좌번호
               ,A.CLN_EXE_NO                                           AS 실행번호
               ,A.CLN_TR_NO                                            AS 거래번호
               ,A.CLN_TR_KDCD                                          AS 거래구분코드
               ,A.TR_DT                                                AS 거래일자
               ,C.TR_DT                                                AS 취소일자
               ,A.RCFM_DT                                              AS 기산일
               ,A.TR_USR_NO                                            AS 거래사용자번호

    FROM        TB_SOR_LOA_TR_TR          A -- SOR_LOA_거래내역

    JOIN        TB_SOR_LOA_TR_BF_LDGR_TR  B -- SOR_LOA_거래전원장내역
                ON     A.CLN_ACNO           = B.CLN_ACNO
                AND    A.CLN_EXE_NO         = B.CLN_EXE_NO
                AND    A.CLN_TR_NO          = B.CLN_TR_NO

    JOIN        TB_SOR_LOA_TR_TR          C -- SOR_LOA_거래내역 [거래를 취소하고 나서 생기는 거래(TR_STCD = 2)]
                ON     A.CLN_ACNO           = C.CLN_ACNO
                AND    A.CLN_EXE_NO         = C.CLN_EXE_NO
                AND    A.CLN_TR_NO          = C.CNCL_OGTR_SNO
                AND    C.TR_DT        BETWEEN  P_SOTM_DT AND P_EOTM_DT -- 전월 중 취소한 건

    JOIN        OT_DWA_DD_BR_BC           BR  -- DWA_일점기본
                ON     A.TR_BRNO        = BR.BRNO
                AND    BR.STD_DT        = P_BASEDAY
                AND    BR.BR_DSCD       = '1'
                AND    BR.FSC_DSCD      = '1'         -- 은행
                AND    BR.BR_KDCD       < '40'        -- 10:본부부서, 20:영업점, 30:관리점

    JOIN        TB_SOR_LOA_ACN_BC         AC  -- SOR_LOA_계좌기본
                ON     A.CLN_ACNO       = AC.CLN_ACNO
                AND    AC.NFFC_UNN_DSCD = '1'

    JOIN        OM_DWA_INTG_CUST_BC       CU
                ON     AC.CUST_NO       = CU.CUST_NO

    WHERE       1 = 1
    AND         A.TR_STCD <> '1' -- 거래상태코드(1:정상 이외 정정,취소)
    AND         A.CLN_TR_KDCD  IN ('300','310','320','360')  --여신거래종류코드(300:대출상환,310:대출이자수입,320:예외이자수입,360:대출상환-CC부분수납)
    AND         A.TR_DT <> A.RCFM_DT -- 취소 대상 거래가 기산일 거래
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT