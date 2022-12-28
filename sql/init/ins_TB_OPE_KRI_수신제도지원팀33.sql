/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀33
  타켓테이블 : TB_OPE_KRI_수신제도지원팀33
  KRI 지표명 : 타점권 교환결제전 지급건수
  협      조 : 이대호과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-33 타점권 교환결제전 지급건수
       A: 타점권 교환결제전 지급 승인 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀33
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀33
    SELECT   P_BASEDAY
            ,B.TR_BRNO
            ,C.BR_NM
            ,A.ACNO
            ,B.TR_DT
            ,B.TR_USR_NO

    FROM     TB_SOR_DEP_DPAC_BC A  -- SOR_DEP_수신계좌기본

    JOIN     TB_SOR_DEP_TR_TR B   -- SOR_DEP_거래내역
             ON  A.ACNO = B.ACNO
             AND  B.TR_DT BETWEEN  P_SOTM_DT AND P_EOTM_DT
             AND  B.CHNL_TPCD = 'TTML'
             AND  B.DPS_TSK_CD = '0301'  -- 수신업무코드( '0301':지급 )
             AND  B.DPS_TSK_DTL_CD = '162'
             AND  B.DPS_TR_STCD = '1'

    JOIN     TB_SOR_CMI_BR_BC C    -- SOR_CMI_점기본
             ON   B.TR_BRNO = C.BRNO
             AND  C.BR_DSCD  = '1'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀33',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
