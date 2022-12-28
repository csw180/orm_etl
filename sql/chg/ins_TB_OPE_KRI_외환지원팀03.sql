/*
  프로그램명 : ins_TB_OPE_KRI_외환지원팀03
  타켓테이블 : TB_OPE_KRI_외환지원팀03
  KRI 지표명 : 유효기일 경과 수입(내국)신용장 계좌 수
  협      조 : 남호준차장
  최초작성자 : 최상원
  KRI 지표명 :
     - 외환지원팀-03 유효기일 경과 수입(내국)신용장 계좌 수
       A: 전월말 기준 영업점/지점 관리중인 수입(내국)신용장 계좌 중 일괄취소일 기준 전월 중 유효기일 1개월 경과된 계좌 수
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

    DELETE OPEOWN.TB_OPE_KRI_외환지원팀03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_외환지원팀03
    SELECT   P_BASEDAY
            ,B.ADM_SLS_BRNO
            ,J.BR_NM
            ,B.REF_NO
            ,A.CRCD
            ,A.OPN_AMT
            ,A.OPN_DT
            ,A.AVL_DT
    FROM     TB_SOR_FEC_FRXC_BC        B  -- SOR_FEC_외환기본

    JOIN     TB_SOR_IMP_IMP_OPN_BC     A  -- SOR_IMP_수입개설기본
             ON  B.REF_NO = A.REF_NO
             AND A.AVL_DT <= TO_CHAR(ADD_MONTHS( TO_DATE(P_BASEDAY,'YYYYMMDD') , -1),'YYYYMMDD')

    JOIN     TB_SOR_CUS_MAS_BC         L  -- SOR_CUS_고객기본
             ON   B.CUST_NO = L.CUST_NO

    JOIN     TB_SOR_CMI_BR_BC        J    -- SOR_CMI_점기본
             ON   B.ADM_SLS_BRNO = J.BRNO

    WHERE    1=1
    AND      B.FRXC_LDGR_STCD = '1'  /* 외환원장상태코드 1정상 */
    AND      B.SBCD IN ('504','505')
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_외환지원팀03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

