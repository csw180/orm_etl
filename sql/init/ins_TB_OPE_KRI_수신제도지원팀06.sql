/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀06
  타켓테이블 : TB_OPE_KRI_수신제도지원팀06
  KRI 지표명 : 제(사고)신고 후 증서 재발급 건수
  협      조 : 전영우
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-06 제(사고)신고 후 증서 재발급 건수
       A: 전월 중 예외거래원장중 해당월 제(사고)신고 증서재발급 점별건수
          (인감분실재발행, 통장분실재발행, 인감변경재발행, 인감훼손(오손)재발행)
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀06
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀06
    SELECT   P_BASEDAY
            ,T1.ENR_BRNO          AS 점번호
            ,T2.BR_NM             AS 점명
            ,T1.ACNO              AS 계좌번호
            ,T3.CUST_NO           AS 고객번호
            ,T1.IMCW_SBCD         AS 중요증서구분코드
            ,T1.BNKB_ISN_RSCD     AS 재발급사유코드
            ,T1.ENR_DT            AS 재발급일자
            ,T1.ENR_USR_NO        AS 조작자직원번호

    FROM     TB_SOR_DEP_BNKB_ADM_TR T1  -- SOR_DEP_통장관리내역

    JOIN     TB_SOR_CMI_BR_BC T2        -- SOR_CMI_점기본
             ON T1.ENR_BRNO = T2.BRNO

    JOIN     TB_SOR_DEP_DPAC_BC T3          -- SOR_DEP_수신계좌기본
             ON  T1.ACNO = T3.ACNO
             AND T3.ACNO < '200000000000'    -- 은행계좌(조합계좌제외)

    WHERE    1=1
    AND      T1.ENR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      T1.LDGR_STCD = '1'                            -- 상태코드 : 1 - 정상
    AND      T1.DPS_BNKB_ADM_KDCD = '022'                  -- 통장관리종류코드 : 022-재발급
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀06',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
