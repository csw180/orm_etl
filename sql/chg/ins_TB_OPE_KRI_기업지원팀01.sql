/*
  프로그램명 : ins_TB_OPE_KRI_기업지원팀01
  타켓테이블 : TB_OPE_KRI_기업지원팀01
  KRI 지표명 : 전체 TCB평가 의뢰건중 예외승인 기업수
  협      조 : 이상민과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 기업지원팀-01 전체 TCB평가 의뢰건중 예외승인 기업수
       A: 전체 TCB평가 의뢰건 중 예외승인 기업수
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

    DELETE OPEOWN.TB_OPE_KRI_기업지원팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_기업지원팀01
    SELECT   P_BASEDAY
            ,TRIM(A.TCH_EVL_APCT_BR_CD_NM)      -- 기술평가신청자점코드명
            ,TRIM(A.TCH_EVL_APC_BR_NM)          -- 기술평가신청점명
            ,A.TCH_EVL_BRN                      -- 기술평가사업자등록번호
            ,A.STDD_INDS_CLCD                   -- 표준산업분류코드
            ,A.TCH_EVL_APC_DT                   -- 기술평가신청일자
            ,'Y'                                -- 예외여부
            ,C.TCH_EVL_EXCP_ENR_RSCD            -- 기술평가예외등록사유코드

    FROM     TB_SOR_CCR_TCB_EVL_APC_TR   A -- SOR_CCR_TCB평가신청내역

    JOIN     TB_SOR_CCR_TCB_EVL_TR       B -- SOR_CCR_TCB평가내역
             ON   A.TCH_EVL_RQST_ISTT_ADM_NO  = B.TCH_EVL_RQST_ISTT_ADM_NO
             AND  B.TCH_EVL_PGRS_STS_CD  <> '03'   -- 기술평가진행상태코드

    JOIN     TB_SOR_CCR_TCB_EVL_RQS_TR   C -- SOR_CCR_TCB평가요청내역
             ON   B.TCH_EVL_RQST_ISTT_ADM_NO  = C.TCH_EVL_RQST_ISTT_ADM_NO

    WHERE    1=1
    AND      A.TCH_EVL_APC_DT  BETWEEN P_SOTM_DT AND P_EOTM_DT
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_기업지원팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
