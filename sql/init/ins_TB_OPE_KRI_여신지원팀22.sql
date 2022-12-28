/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀22
  타켓테이블 : TB_OPE_KRI_여신지원팀22
  KRI 지표명 : 2천만원이상 여신상환취소 후 미상환 건수
  협      조 : 이천수과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-22 2천만원이상 여신상환취소 후 미상환 건수
       A: 여신 상환 정정/취소 후 30분 내 재상환되지 않은 명세(20백만원 이상) 건수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀22
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀22
    WITH TB_TEMP_여신지원팀_22 AS
    (
    SELECT      P_BASEDAY                        AS 기준일자
               ,'정정거래 =>'                    AS 구분1
               ,A.*
               ,'=> 이 정정거래의 30분내 정상 거래(1:N) =>' AS 구분2
               ,B.CLN_ACNO                      AS 계좌번호_정정30분내거래
               ,B.CLN_EXE_NO                    AS 실행번호_정정30분내거래
               ,B.CLN_TR_NO                     AS 거래번호_정정30분내거래
               ,B.TR_DT                         AS 거래일자_정정30분내거래
               ,B.TR_TM                         AS 거래시각_정정30분내거래
               ,B.TR_STCD                       AS 거래상태코드_정정30분내거래
               ,B.CLN_TR_KDCD                   AS 여신거래종류코드_정정30분내거래
               ,B.RCFM_DT                       AS 기산일자_정정30분내거래
               ,B.WN_TNSL_PCPL                  AS 거래원금_정정30분내거래
               ,B.WN_TNSL_INT                   AS 거래이자_정정30분내거래
               ,TO_TIMESTAMP(B.TR_DT || B.TR_TM, 'YYYYMMDDHH24MISS')                      AS 거래TIMESTAMP_정정30분내거래  -- 30분 이내 거래건의 TIMESTAMP
               ,TO_TIMESTAMP(A.거래일자_정정건 || A.거래시각_정정건, 'YYYYMMDDHH24MISS')     AS 거래TIMESTAMP_정정건         -- 2천만원 이상 원금상환 정정된 건의 TIMESTAMP
               ,TO_TIMESTAMP(B.TR_DT || B.TR_TM, 'YYYYMMDDHH24MISS') - TO_TIMESTAMP(A.거래일자_정정건 || A.거래시각_정정건, 'YYYYMMDDHH24MISS') AS 시간차 -- 30분 이내인지 검증
    FROM       (-- 2천만원 이상 원금상환 당일 정정된 건
                SELECT      A.CLN_ACNO         AS 계좌번호_정정건
                           ,A.CLN_EXE_NO       AS 실행번호_정정건
                           ,A.CLN_TR_NO        AS 거래번호_정정건
                           ,A.TR_DT            AS 거래일자_정정건
                           ,A.TR_TM            AS 거래시각_정정건
                           ,A.TR_STCD          AS 거래상태코드_정정건
                           ,A.CLN_TR_KDCD      AS 여신거래종류코드_정정건
                           ,A.RCFM_DT          AS 기산일자_정정건
                           ,B.NEXT_INT_IMP_DT  AS 거래전다음이자수입일자_정정건
                           ,A.WN_TNSL_PCPL     AS 거래원금_정정건
                           ,A.WN_TNSL_INT      AS 거래이자_정정건
                           ,A.TR_BRNO          AS 거래점_정정건
                           ,CU.CUST_NO         AS 고객번호_정정건
                           ,BR.BRNO            AS 점번호_정정건
                           ,TRIM(BR.BR_NM)     AS 점명_정정건
                           ,PD.PDCD            AS 상품코드_정정건
                           ,TRIM(PD.PRD_KR_NM) AS 상품명_정정건
                           ,A.TR_USR_NO        AS 거래사용자번호_정정건
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
                LEFT OUTER
                JOIN        OT_DWA_CLN_PRD_STRC_BC    PD
                            ON     AC.PDCD          = PD.PDCD
                            AND    PD.STD_DT        = P_BASEDAY
                WHERE       1 = 1
                AND         A.WN_TNSL_PCPL >= 20000000 -- 2천만원 이상 상환
                AND         A.TR_STCD <> '1' -- 거래상태코드(1:정상 이외 정정,취소)
                AND         A.TR_DT BETWEEN  P_SOTM_DT AND P_EOTM_DT
                AND         A.CLN_TR_KDCD  IN ('300','310','320','360')  --여신거래종류코드(300:대출상환,310:대출이자수입,320:예외이자수입,360:대출상환-CC부분수납)
                )   A
    LEFT OUTER JOIN
                TB_SOR_LOA_TR_TR   B -- SOR_LOA_거래내역 [정정 30분내 발생한 거래]
                ON     A.계좌번호_정정건      = B.CLN_ACNO
                AND    A.실행번호_정정건      = B.CLN_EXE_NO
                AND    A.거래번호_정정건      < B.CLN_TR_NO  -- 정정된 이후의 거래
                AND    A.거래일자_정정건      = B.TR_DT      -- 정정된 날의 거래로 한정 (일자가 변경되는 시점에는 상환거래가 없다고 가정)
                -- AND    B.WN_TNSL_PCPL > 0                    -- 이자상환 거래를 제외하려면 이조건 필요함
                AND    ( TO_TIMESTAMP(A.거래일자_정정건 || A.거래시각_정정건, 'YYYYMMDDHH24MISS') + (INTERVAL '30' MINUTE)  ) >  TO_TIMESTAMP(B.TR_DT || B.TR_TM,'YYYYMMDDHH24MISS')
                --AND    EXTRACT ( HOUR   FROM TO_TIMESTAMP(B.TR_DT || B.TR_TM) - TO_TIMESTAMP(A.거래일자_정정건 || A.거래시각_정정건) ) = 0  -- 같은 날인 경우 30분 이내 거래된 건을 찾아 조인
                --AND    EXTRACT ( MINUTE FROM TO_TIMESTAMP(B.TR_DT || B.TR_TM) - TO_TIMESTAMP(A.거래일자_정정건 || A.거래시각_정정건) ) < 30 -- 같은 날인 경우 30분 이내 거래된 건을 찾아 조인
                AND    B.CLN_TR_KDCD  IN ('300','310','320','360')  --여신거래종류코드(300:대출상환,310:대출이자수입,320:예외이자수입,360:대출상환-CC부분수납)
                AND    B.TR_STCD       = '1' -- 거래상태코드(1:정상)
    )

    -- 정정된 거래내역으로 GROUP BY (계좌번호 and 실행번호 and 거래번호가 KEY)
    SELECT      기준일자
               ,점번호_정정건
               ,점명_정정건
               ,고객번호_정정건
               ,계좌번호_정정건
               ,실행번호_정정건
               ,거래번호_정정건
               ,상품코드_정정건
               ,상품명_정정건
               ,거래원금_정정건
               ,NVL( SUM(거래원금_정정30분내거래), 0 ) AS 거래원금계_정정30분내거래
               ,CASE WHEN SUM( NVL(거래원금_정정30분내거래,0) ) < 거래원금_정정건 THEN 'Y' -- [정정 후 30분내 거래 원금계]가 [정정된 거래의 원금] 보다 적다면 취소로 보고 'Y'로 찍어줌. 요청자 확인 필요
                     ELSE 'N'
                END                                  AS 취소거래여부
               ,거래일자_정정건
               ,거래시각_정정건
               ,거래사용자번호_정정건
    FROM        TB_TEMP_여신지원팀_22
    GROUP BY    기준일자
               ,점번호_정정건
               ,점명_정정건
               ,고객번호_정정건
               ,계좌번호_정정건
               ,실행번호_정정건
               ,거래번호_정정건
               ,상품코드_정정건
               ,상품명_정정건
               ,거래원금_정정건
               ,거래일자_정정건
               ,거래시각_정정건
               ,거래사용자번호_정정건
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀22',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
