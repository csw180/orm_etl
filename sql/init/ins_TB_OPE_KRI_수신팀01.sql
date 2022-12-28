/*
  프로그램명 : ins_TB_OPE_KRI_수신팀01
  타켓테이블 : TB_OPE_KRI_수신팀01
  KRI 지표명 : 수신거래내역 정정/취소거래 건수
  협      조 : 장사권 과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신팀-01 수신거래내역 정정/취소거래 건수
       A: 전월말 기준 수신거래내역에서 거래상태코드가 정정/취소인 거래건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신팀01
    SELECT   /*+ FULL(A) FULL(B)  FULL(C) */
             P_BASEDAY
            ,A.TR_BRNO
            ,B.BR_NM
            ,A.ACNO
            ,A.DPS_TSK_CD   -- 거래구분코드
            ,DECODE(A.DPS_TR_STCD,'2',A.TR_DT,NULL)  -- 정정거래일자
            ,DECODE(A.DPS_TR_STCD,'3',A.TR_DT,NULL)  -- 취소거래일자
    --        ,A.OGTR_DT    -- 입금거래일자
            ,A.DPS_TR_RCD_CTS  -- 정정취소사유
            ,A.TR_USR_NO   -- 조작자직원번호
    from     TB_SOR_DEP_TR_TR   A  -- SOR_DEP_거래내역
    JOIN     TB_SOR_CMI_BR_BC   B  -- SOR_CMI_점기본
             ON  A.TR_BRNO   =   B.BRNO
             AND B.BR_DSCD  =  '1'
    JOIN     TB_SOR_DEP_DPAC_BC  C  -- SOR_DEP_수신계좌기본
             ON  A.ACNO      =   C.ACNO
    WHERE    1=1
    AND      A.TR_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND      A.DPS_TR_STCD IN ('2','3')  -- 수신거래상태코드 2:정정, 3:취소
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
