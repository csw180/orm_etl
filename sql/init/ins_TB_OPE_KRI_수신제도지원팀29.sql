/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀29
  타켓테이블 : TB_OPE_KRI_수신제도지원팀29
  KRI 지표명 : 보관어음 수탁 정정/취소 및 반환 건수
  협      조 : 김자연
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀29 : 보관어음 수탁 정정/취소 및 반환 건수
       A: 보고기간 중 영업점의 보관어음 수탁정정/취소 및 반환된 거래 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀29
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀29
    SELECT   /*+ FULL(T1) FULL(T2) */
             P_BASEDAY
            ,T1.HDL_BRNO       -- 점번호
            ,TRIM(T2.BR_NM)    -- 점명
            ,T1.CSNT_ACNO      -- 보관어음계좌번호
            ,CASE WHEN (T1.CSNT_TR_DSCD = '25' AND T1.CSNT_STCD = '15') THEN '수탁취소'
                  WHEN (T1.CSNT_TR_DSCD = '29' AND T1.CSNT_STCD = '19') THEN '수탁정정'
                  WHEN (T1.CSNT_TR_DSCD = '40' AND T1.CSNT_STCD = '21') THEN '반환'
             END                         -- 수탁어음정정취소구분
            ,CASE WHEN (T1.CSNT_TR_DSCD = '40' AND T1.CSNT_STCD = '21') THEN T1.TR_DT END --반환일자
            ,T1.ENR_USR_NO               -- 조작자직원번호

    FROM     TB_SOR_CTD_CSNT_TR_TR                     T1 -- SOR_CTD_보관어음거래내역

    JOIN     TB_SOR_CMI_BR_BC                          T2 -- SOR_CMI_점기본
             ON  T1.HDL_BRNO = T2.BRNO
             AND T2.BR_DSCD        = '1'
             AND T2.BR_KDCD  IN ('10','20','30')
             AND T2.FSC_DSCD       = '1'

    WHERE    1=1
    AND      T1.TR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      T1.CSNT_TR_DSCD IN ('25', '29', '40')  -- 보관어음거래구분코드 (25 : 수탁취소, 29 : 수탁정정, 40 : 반환)
    AND      T1.CSNT_STCD IN ('15', '19', '21') -- 보관어음상태코드 (15 : 수탁취소, 19 : 수탁정정, 21 : 반환)
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀29',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








