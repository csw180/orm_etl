/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀03
  타켓테이블 : TB_OPE_KRI_여신지원팀03
  KRI 지표명 : 대출이자 기산일 거래건수
  협      조 : 이천수과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-03 대출이자 기산일 거래건수
       A: 전월 중 대출이자 회수기일 경과 후 기산일 상환 발생 건수
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
  FROM    OPEOWN.TB_OPE_DT_BC
  WHERE   STD_DT_YN  = 'Y';

  IF P_EOTM_DT = P_BASEDAY  THEN

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀03
    SELECT      /*+ FULL(A) FULL(B) FULL(BR) FULL(AC) FULL(CU)  */
                P_BASEDAY                                                         AS 기준일자
               ,BR.BRNO                                                           AS 점번호
               ,TRIM(BR.BR_NM)                                                    AS 점명
               ,CU.CUST_NO                                                        AS 고객번호
               ,A.CLN_ACNO                                                        AS 계좌번호
               ,A.CLN_EXE_NO                                                      AS 실행번호
               ,A.CLN_TR_NO                                                       AS 거래번호
               ,A.CRCD                                                            AS 통화코드
               ,A.WN_TNSL_INT                                                     AS 거래이자
               ,TO_CHAR(TO_DATE(B.NEXT_INT_IMP_DT, 'YYYYMMDD') + 1, 'YYYYMMDD')   AS 이자기산일 -- 거래 전의 최종이수일 + 1 일
               ,A.RCFM_DT                                                         AS 기산일자
               ,A.TR_DT                                                           AS 거래일자
               ,A.TR_USR_NO                                                       AS 거래사용자번호

                -- 참고용 컬럼 (데이터 전송시 미사용)
            --    ,A.TR_STCD
            --    ,A.CLN_TR_KDCD
            --    ,A.TR_PCPL
            --    ,B.NEXT_INT_IMP_DT -- 거래 전의 최종이수일
    FROM        TB_SOR_LOA_TR_TR          A -- SOR_LOA_거래내역

    JOIN        TB_SOR_LOA_TR_BF_LDGR_TR  B -- SOR_LOA_거래전원장내역
                ON     A.CLN_ACNO           = B.CLN_ACNO
                AND    A.CLN_EXE_NO         = B.CLN_EXE_NO
                AND    A.CLN_TR_NO          = B.CLN_TR_NO

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
    AND         A.WN_TNSL_INT > 0
    AND         A.TR_DT     BETWEEN  P_SOTM_DT AND P_EOTM_DT
    AND         B.NEXT_INT_IMP_DT  < A.TR_DT                  -- 다음 이수일이 지난 후 거래하고
    AND         A.RCFM_DT          <= B.NEXT_INT_IMP_DT       -- 다음이수일 이전으로 기산일거래 한 데이터
    AND         A.CLN_TR_KDCD  IN ('300','310','320','360')  --여신거래종류코드(300:대출상환,310:대출이자수입,320:예외이자수입,360:대출상환-CC부분수납)
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
