/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀28
  타켓테이블 : TB_OPE_KRI_수신제도지원팀28
  KRI 지표명 : 보관어음잔액확인서 발급 건수
  협      조 : 김자연
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀28 : 보관어음잔액확인서 발급 건수
       A: 보고기간 중 영업점의 보관어음계좌 잔액확인서 발급 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀28
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀28
    SELECT      /*+ FULL(T1) FULL(T2) */
                P_BASEDAY
               ,T1.HDL_BRNO                      --점번호
               ,T2.BR_NM                         --점명
               ,T1.INP_INTG_ACNO                 --보관어음잔액확인서계좌번호
               ,T1.ONL_DT                        --보관어음잔액확인서발급일자
               ,T1.USR_NO                        --조작자직원번호

    FROM        TB_CBC_CMP_TSK_LOG_SMR_TR                 T1  -- CBC_CMP_통합업무로그요약내역

    JOIN        TB_SOR_CMI_BR_BC                          T2  -- SOR_CMI_점기본
                ON  T1.HDL_BRNO = T2.BRNO
                AND T2.BR_DSCD        = '1'
                AND T2.BR_KDCD  IN ('10','20','30')
                AND T2.FSC_DSCD       = '1'

    WHERE       1=1
    AND         T1.ONL_DT BETWEEN P_SOTM_DT AND P_EOTM_DT  -- 온라인일자
    AND         T1.INP_SCRN_ID IN ('6520SC00')  -- 입력화면ID
    AND         T1.INP_TLG_ID = 'CTD168001'    -- 입력전문ID  -
    AND         T1.SBCD = '440'  -- 과목코드(440:보관어음)
    AND         T1.CHNL_TPCD IN ( 'TTML')  -- 채널유형코드(TTML:단말)
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀28',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








