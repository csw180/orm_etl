/*
  프로그램명 : ins_TB_OPE_KRI_자금관리팀01
  타켓테이블 : TB_OPE_KRI_자금관리팀01
  KRI 지표명 : 착오송금 반환청구 자동반환거부 건수
  협      조 : 이은숙과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 자금관리팀-01 착오송금 반환청구 자동반환거부 건수
       A: 타행청구분 30일 경과 미처리에 따른 반환거부 건수
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

    DELETE OPEOWN.TB_OPE_KRI_자금관리팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_자금관리팀01
    SELECT   P_BASEDAY
            ,A.RSTR_BRNO  --반환점번호
            ,B.BR_NM      --반환점명
            ,A.CUST_NO    --고객번호
            ,A.DMD_AMT    --청구금액
            ,A.DMD_DT     --청구일자
            ,A.TR_DT      --처리일자
            
    FROM     DWZOWN.TB_SOR_FTN_RTM_DMD_RSTR_TR  A  -- SOR_FTN_실시간청구반환내역
    
    JOIN     DWZOWN.TB_SOR_CMI_BR_BC  B  -- SOR_CMI_점기본
             ON  A.RSTR_BRNO = B.BRNO
             AND B.BR_DSCD = '1'   -- 1.중앙회, 2.조합
             
    WHERE    1=1
    AND      A.TR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT  -- 전월중 거부처리된일자
    AND      A.HDL_OPN_DSCD = '1'  -- 수협반환처리건
    AND      A.RQS_USR_NO = 'BFTN001000'  -- 자동거부

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_자금관리팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

