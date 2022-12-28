/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀31
  타켓테이블 : TB_OPE_KRI_수신제도지원팀31
  KRI 지표명 : 보관어음 기일도래 건수
  협      조 : 김자연
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀31 : 보관어음 기일도래 건수
       A: 전월기준 계정계 보관어음원장중 지급기일 도래하여 출고된 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀31
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀31
    SELECT   /*+ FULL(T1) FULL(T2) FULL(T3) */
             P_BASEDAY          --
            ,T1.HDL_BRNO         -- 점번호
            ,T3.BR_NM            -- 점명
            ,T1.CSNT_ACNO        -- 보관어음계좌번호
            ,T1.TKCT_DT          -- 수탁일자
            ,T1.DFRY_DT          -- 지급일자
            ,T1.DLVY_DT          -- 출고일자
            ,CASE WHEN T2.CC_NML_PCS_YN = '1' THEN 'Y' ELSE 'N' END  -- 결제계좌정상입금여부

    FROM     TB_SOR_CTD_CSNT_TR_TR                       T1 -- SOR_CTD_보관어음거래내역

    JOIN     TB_SOR_CTD_CSNT_BC                          T2 -- SOR_CTD_보관어음기본
             ON  T1.NT_NO = T2.NT_NO
             AND T1.NT_SNO = T2.NT_SNO
             AND T1.CSNT_ACNO = T2.CSNT_ACNO

    JOIN     TB_SOR_CMI_BR_BC                            T3 -- SOR_CMI_점기본
             ON  T1.HDL_BRNO = T3.BRNO
             AND T3.BR_DSCD        = '1'
             AND T3.BR_KDCD  IN ('10','20','30')
             AND T3.FSC_DSCD       = '1'

    WHERE    1=1
    AND      T1.CSNT_TR_DSCD = '30'  -- 보관어음거래구분코드(30 : 출고)
    AND      T1.CSNT_STCD = '20'  -- 보관어음상태코드(20 : 출고)
    AND      T1.DFRY_DT BETWEEN P_SOTM_DT AND P_EOTM_DT  -- 지급기일
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀31',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
