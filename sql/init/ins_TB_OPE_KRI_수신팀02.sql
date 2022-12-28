/*
  프로그램명 : ins_TB_OPE_KRI_수신팀02
  타켓테이블 : TB_OPE_KRI_수신팀02
  협      조 : 임현선과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신팀02 : 비밀번호생략 지급거래 건수
       A: 전월말 기준 수신거래내역에서 수신업무거래코드가 비밀번호 생략 지급거래인 거래건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신팀02

    SELECT   /*+ FULL(A) FULL(B) */
             P_BASEDAY
            ,A.TR_BRNO
            ,B.BR_NM
            ,A.ACNO
            ,A.TR_DT
            ,A.DPS_TSK_TR_CD
            ,A.CRCD
            ,A.TR_AMT
            ,A.TR_USR_NO
    FROM     TB_SOR_DEP_TR_TR   A   -- SOR_DEP_거래내역
    JOIN     TB_SOR_CMI_BR_BC   B   -- SOR_CMI_점기본
             ON  A.TR_BRNO   = B.BRNO
    WHERE    1=1
    AND      A.ACNO  LIKE '1%'
    AND      A.TR_DT  BETWEEN  P_SOTM_DT AND P_EOTM_DT
    AND      A.DPS_TSK_TR_CD  =  '0301036'  -- 수신업무거래코드 ( '0301036':기타대체지급 )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
