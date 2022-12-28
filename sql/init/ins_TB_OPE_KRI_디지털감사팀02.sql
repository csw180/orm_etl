/*
  프로그램명 : ins_TB_OPE_KRI_디지털감사팀02
  타켓테이블 : TB_OPE_KRI_디지털감사팀02
  KRI 지표명 : 가수금의 현금 또는 대체 지급건수
  협      조 : 박아란과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 디지털감사팀-02 가수금의 현금 또는 대체 지급건수
       A: 현금지급건수
       B: 대체지급건수
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

    DELETE OPEOWN.TB_OPE_KRI_디지털감사팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_디지털감사팀02
    SELECT   P_BASEDAY
            ,A.ADM_BRNO   -- 점번호
            ,C.BR_NM
            --,A.TMAC_ACNO
            ,A.ACSB_CD
            ,A.OCC_DT     -- 발생일자
            ,A.NARN_RMD   -- 미정리잔액
            --,A.ARN_DT     -- 정리일자
            ,CASE WHEN B.RMDF_DSCD = '2' THEN B.CUR_AMT ELSE 0 END -- 현금지급액
            ,CASE WHEN B.RMDF_DSCD = '2' THEN B.ALT_AMT ELSE 0 END -- 대체지급액

    FROM     DWZOWN.TB_SOR_APW_TMAC_TR_BC   A -- SOR_APW_가계정거래기본

    JOIN     DWZOWN.TB_SOR_APW_TMAC_TR_TR   B -- SOR_APW_가계정거래내역
             ON  A.TMAC_ACNO =   B.TMAC_ACNO

    JOIN     DWZOWN.TB_SOR_CMI_BR_BC  C  -- SOR_CMI_점기본
             ON  A.ADM_BRNO = C.BRNO
             AND C.BR_DSCD = '1'   -- 1.중앙회, 2.조합

    WHERE    1=1
    AND      A.ACSB_CD = '26008711'  -- 기타가수금
    AND      A.OCC_DT   BETWEEN  P_SOTM_DT AND P_EOTM_DT

    ;
    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_디지털감사팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
