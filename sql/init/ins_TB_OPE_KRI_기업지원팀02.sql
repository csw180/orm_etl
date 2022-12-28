/*
  프로그램명 : ins_TB_OPE_KRI_기업지원팀02
  타켓테이블 : TB_OPE_KRI_기업지원팀02
  KRI 지표명 : 은행조회서 수기 발급 건수
  협      조 : 김찬수 대리
  최조작성자 : 최상원

  KRI 지표명 :
     - 기업지원팀-02 은행조회서 수기 발급 건수
       A: 전월중 은행조회서 수기발급 건수(전산 자동발급분 제외)
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

    DELETE OPEOWN.TB_OPE_KRI_기업지원팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_기업지원팀02
    SELECT   P_BASEDAY              --결산기준일자
            ,ISN_BRNO               --발급점번호
            ,RSBL_SLS_BR_NM         --담당영업점명
            ,CUST_NO                --고객번호
            ,RBCI_ISN_NO            --은행조회서발급번호
            ,RBCI_ISN_CD            --은행조회서발급코드 (1:발급,2:조회)
            ,ISN_DT                 --발급일자
            ,CHPR_NM                --담당자명
    FROM     TB_SOR_CIS_RBCI_ISN_TR A   --SOR_CIS_은행조회서발급내역
    WHERE    1=1
    AND      NFFC_UNN_DSCD     =  '1'   --중앙회조합구분코드(1:중앙회)
    AND      ISN_DT   BETWEEN  P_SOTM_DT AND P_EOTM_DT
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_기업지원팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

