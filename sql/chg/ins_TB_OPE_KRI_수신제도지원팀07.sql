/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀07
  타켓테이블 : TB_OPE_KRI_수신제도지원팀07
  KRI 지표명 : 입금 취소 건수
  협      조 : 장사권차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-07 입금 취소 건수
       A: 전월 중 고객의 100만원 초과 무통장거래 입금 정정/취소 발생 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀07
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀07
    SELECT P_BASEDAY
          ,A.TR_BRNO
          ,B.BR_NM
          ,A.ACNO
          ,C.CUST_NO
          ,A.TR_AMT
          ,A.DPS_TR_STCD
          --,CASE WHEN A.DPS_TR_STCD = '2' THEN '정정'
          --      WHEN A.DPS_TR_STCD = '3' THEN '취소'
          --      ELSE A.DPS_TR_STCD
          -- END          -- 수신거래상태코드
          ,A.OGTR_DT    -- 입금거래일자
          ,A.TR_DT      -- 취소거래일자
          ,A.TR_USR_NO  -- 조작자직원번호

    FROM   TB_SOR_DEP_TR_TR   A    --  SOR_DEP_거래내역
    JOIN   TB_SOR_CMI_BR_BC      B   -- SOR_CMI_점기본
           ON  A.TR_BRNO   =   B.BRNO
           AND B.BR_DSCD   =   '1'  -- 은행
    JOIN   TB_SOR_DEP_DPAC_BC  C   -- SOR_DEP_수신계좌기본
           ON  A.ACNO      =  C.ACNO
    WHERE  1=1
    AND    A.TR_DT   BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND    A.DPS_TSK_CD   =  '0201'  -- 수신업무코드 입금:0201
    AND    A.DPS_TR_STCD   IN  ('2','3')  -- 수신거래상태코드 2:정정, 3:취소
    AND    A.WOBK_YN  = 'Y'      -- 무통장여부
    AND    A.TR_AMT > 1000000    -- 무통장 100만원이상거래
    AND    A.CHNL_TPCD =  'TTML'  -- 채널유형코드 단말거래:TTML
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀07',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT





