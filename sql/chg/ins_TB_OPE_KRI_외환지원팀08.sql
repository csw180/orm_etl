/*
  프로그램명 : ins_TB_OPE_KRI_외환지원팀08
  타켓테이블 : TB_OPE_KRI_외환지원팀08
  KRI 지표명 : 수출신용장 장기 미교부 건수
  협      조 : 남호준차장
  최초작성자 : 최상원
  KRI 지표명 :
     - 외환지원팀-08 수출신용장 장기 미교부 건수
       A: 전월말 기준 서류접수일로부터 1개월 경과하였으나 영업점/지점 갑류점 통지내역에
          남아있는 수출신용장 건수
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

    DELETE OPEOWN.TB_OPE_KRI_외환지원팀08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_외환지원팀08
    SELECT   P_BASEDAY
            ,A.ADC_BRNO
            ,B.BR_NM
            ,A.LC_NO
            ,A.ACP_DT
            ,A.LC_ADC_PGRS_STCD
            ,SUBSTR(A.LAST_CHNG_MN_USID,1,10)
    FROM     TB_SOR_EXP_ADC_BC A   -- SOR_EXP_수출신용장통지기본
    JOIN     TB_SOR_CMI_BR_BC  B   -- SOR_CMI_점기본
             ON   A.ADC_BRNO = B.BRNO

    WHERE    1=1
    AND      A.LC_ADC_PGRS_STCD < 2 -- 신용장통지진행상태코드 0:원장구축,1:통지작성,2:통지실행및승인,9:원장취소
    AND      A.ACP_DT < TO_CHAR(ADD_MONTHS( TO_DATE(P_BASEDAY,'YYYYMMDD') , -1),'YYYYMMDD')
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_외환지원팀08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

