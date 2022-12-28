/*
  프로그램명 : ins_TB_OPE_KRI_여신팀02
  타켓테이블 : TB_OPE_KRI_여신팀02
  KRI 지표명 : 미사용 가상계좌 보유수
  협      조 : 이천수과장
  최조작성자 : 최상원
  KRI 지표명 :
   - 여신팀-02 미사용 가상계좌 보유수
     A: 누적 미사용 가상계좌 수
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

    DELETE OPEOWN.TB_OPE_KRI_여신팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신팀02
    SELECT      P_BASEDAY              AS 기준일자
               ,A.VACN_NO              AS 가상계좌번호
               ,A.VACN_NO_US_CMPL_YN   AS 가상계좌번호사용완료여부

    FROM        TB_SOR_LOA_VACN_ACN_INF_BC  A -- SOR_LOA_가상계좌계좌정보기본

    WHERE       1 = 1
    AND         A.MO_ACNO      = '101011327368' -- 가상계좌의 모계좌가 은행 계좌인 것만 (은행은 단일 계좌를 모계좌로 한다.)
    AND         TO_CHAR(A.FST_ENR_DTTM,'YYYYMMDD') <=  P_BASEDAY     -- 1. 작업기준일자 이전에 원장에 등록된 가상계좌만 추출
    AND        (
                  A.VACN_NO_US_CMPL_YN    = 'N'  OR      -- 2-1. 현재기준 미사용인 건
                  (     A.VACN_NO_US_CMPL_YN  = 'Y' 
                    AND A.APL_DT          >  P_BASEDAY
                  ) -- 2-2. 원장조회일자 기준, 사용중으로 세팅된 건이나 작업기준일자가 사용일자보다 빠른 건
               )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
