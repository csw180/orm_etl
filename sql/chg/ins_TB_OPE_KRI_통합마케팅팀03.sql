/*
  프로그램명 : ins_TB_OPE_KRI_통합마케팅팀03
  타켓테이블 : TB_OPE_KRI_통합마케팅팀03
  KRI 지표명 : 파트너 고객 특례 인정 건수
  협      조 : 김정은
  최조작성자 : 최상원
  KRI 지표명 :
     - 통합마케팅팀-03: 파트너 고객 특례 인정 건수
       A: 영업점에서 신청한 특례인정 건수
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

    DELETE OPEOWN.TB_OPE_KRI_통합마케팅팀03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_통합마케팅팀03

    SELECT   P_BASEDAY
            ,A.ENR_BRNO 등록점번호
            ,J1.BR_NM
            ,A.CUST_NO 고객번호
            ,B.CUST_DSCD 고객구분코드
            ,A.ENR_DTTM  특례신청일
            ,A.CUST_APRV_STCD   AS 고객승인상태코드
            ,A.APC_RSN 신청사유
            ,A.APRV_USR_NO 승인사용자번호
            ,A.APRV_BRNO 승인점번호
            ,A.ENR_USR_NO 등록사용자번호

    FROM     TB_SOR_CUS_BR_SCS_BC A  --SOR_CUS_지점특례신청기본

    JOIN     TB_SOR_CUS_MAS_BC B    --SOR_CUS_고객기본
             ON     A.CUST_NO = B.CUST_NO

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
             ON    A.ENR_BRNO  =  J1.BRNO

    WHERE    1 = 1
    AND      TO_CHAR(A.ENR_DTTM,'YYYYMMDD') BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      A.NFFC_UNN_DSCD = '1' --은행
    AND      A.CUST_APRV_STCD  = '1'   -- 고객승인상태코드(1:승인,2:반려,5:신청,6:부분승인)

    UNION ALL

    SELECT   P_BASEDAY
            ,A.ENR_BRNO 등록점번호
            ,J1.BR_NM
            ,A.RLT_CUST_NO 고객번호
            ,B.CUST_DSCD 고객구분코드
            ,A.ENR_DTTM   특례신청일
            ,'1' AS 고객승인상태코드
            ,' 'AS 신청사유
            ,A.CHG_USR_NO 승인사용자번호
            ,A.CHG_BRNO 승인점번호
            ,A.CHG_USR_NO 등록사용자번호

    FROM     TB_SOR_CUS_RLT_SCS_BC A  --SOR_CUS_관계특례신청기본
    JOIN     TB_SOR_CUS_MAS_BC B     --SOR_CUS_고객기본
             ON     A.RLT_CUST_NO = B.CUST_NO

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
             ON    A.ENR_BRNO  =  J1.BRNO

    WHERE    1 = 1
    AND      TO_CHAR(A.ENR_DTTM,'YYYYMMDD') BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      A.APRV_CUST_GDCD IS NOT NULL
    AND      A.NFFC_UNN_DSCD = '1' --은행
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_통합마케팅팀03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


