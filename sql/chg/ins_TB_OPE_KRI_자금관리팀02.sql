/*
  프로그램명 : ins_TB_OPE_KRI_자금관리팀02
  타켓테이블 : TB_OPE_KRI_자금관리팀02
  KRI 지표명 : 창구 및 ATM 출납부족 발생건수
  협      조 : 박아란과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 자금관리팀-02 창구 및 ATM 출납부족 발생건수
       A: 전월 중 창구출납 원화 부족금 발생 건수
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

    DELETE OPEOWN.TB_OPE_KRI_자금관리팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_자금관리팀02
    SELECT   P_BASEDAY
            ,A.ADM_BRNO   -- 점번호
            ,B.BR_NM
            ,A.OCC_DT     -- 발생일자
            ,A.CRCD       -- 통화코드
            ,A.OCC_AMT    -- 발생금액

    FROM     DWZOWN.TB_SOR_APW_TMAC_TR_BC   A -- SOR_APW_가계정거래기본
    JOIN
             DWZOWN.TB_SOR_CMI_BR_BC  B  -- SOR_CMI_점기본
             ON  A.ADM_BRNO = B.BRNO
             AND B.BR_DSCD = '1'   -- 1.중앙회, 2.조합

    WHERE    1=1
    AND      A.OCC_DT BETWEEN P_SOTM_DT AND P_EOTM_DT  -- 전월중 발생건
    AND      A.ACSB_CD = '15011511'  -- 출납부족금
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_자금관리팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
