/*
  프로그램명 : ins_TB_OPE_KRI_개인금융심사팀01
  타켓테이블 : TB_OPE_KRI_개인금융심사팀01
  KRI 지표명 : 여신 승인조건 미이행 건수(개인사업자)
  협      조 : 이상민과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 개인금융심사팀-01  여신 승인조건 미이행 건수(개인사업자)
       A: 이행기일이 경과하였으나 가계 여신 승인조건 이행등록이 미완료 상태인 건수
     - 기업금융심사팀-01  여신 승인조건 미이행 건수(기업금융)
       A: 이행기일이 경과하였으나 가계 여신 승인조건 이행등록이 미완료 상태인 건수
     - 수산금융심사팀-01  여신 승인조건 미이행 건수(수산금융)
       A: 이행기일이 경과하였으나 가계 여신 승인조건 이행등록이 미완료 상태인 건수
     - 투자금융심사팀-02  여신 승인조건 미이행 건수(투자금융)
       A: 이행기일이 경과하였으나 가계 여신 승인조건 이행등록이 미완료 상태인 건수
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

    DELETE OPEOWN.TB_OPE_KRI_개인금융심사팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_개인금융심사팀01
    SELECT P_BASEDAY
          ,B.CSLT_BRNO
          ,J1.BR_NM
          ,F.CUST_DSCD
          ,B.CUST_NO
          ,B.CLN_JUD_RPST_NO
          ,C.APRV_CND_EXE_BNF_DSCD
          ,C.APRV_CND_FLF_FRQ_DSCD
          ,C.JUD_APRV_CND_CTS
          ,C.APRV_CND_NEXT_FLF_PARN_DT
          ,B.RSBL_XMRL_USR_NO
          ,G.JDGR_NM

    FROM   TB_SOR_CLI_JUD_APRV_CND_TR A       -- SOR_CLI_대표심사승인조건내역

    JOIN   TB_SOR_CLI_RPST_JUD_BC B           -- SOR_CLI_대표심사기본
           ON    A.CLN_JUD_RPST_NO = B.CLN_JUD_RPST_NO
           AND   B.CLN_JUD_PGRS_STCD = '20'   -- 여신심사진행상태코드(20:승인장통지)
           AND   B.DPT_CD = '0627'

    JOIN   TB_SOR_CLI_APRV_CND_BC C        -- SOR_CLI_승인조건기본
           ON    A.JUD_APRV_CND_ADM_NO = C.JUD_APRV_CND_ADM_NO
           AND   C.CLN_APRV_CND_STCD NOT IN ('2','9')  -- 여신승인조건상태코드(1:이행중,2:승인조건완료,9:취소)

    LEFT OUTER JOIN
           TB_SOR_CLI_APRV_CND_FLF_TR D   -- SOR_CLI_승인조건이행내역
           ON    A.JUD_APRV_CND_ADM_NO = D.JUD_APRV_CND_ADM_NO

    LEFT OUTER JOIN
           TB_SOR_CUS_MAS_BC  F   -- SOR_CUS_고객기본
           ON    B.CUST_NO   = F.CUST_NO

    LEFT OUTER JOIN
           TB_SOR_CLI_JUD_TEAM_OGZ_BC    G -- SOR_CLI_심사팀조직기본
           ON    B.JUD_TEAM_CD = G.JUD_TEAM_CD
           AND   G.JDGR_CD = '0000'

    JOIN   TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_점기본
           ON   B.CSLT_BRNO  =  J1.BRNO
           AND  J1.BR_DSCD = '1'   -- 1.중앙회, 2.조합
           
    WHERE  1=1
    AND    A.JUD_APRV_CNCD = '98'   -- 심사승인조건코드
    AND    A.LDGR_STCD <> '9'
    AND    ( D.APRV_CND_FLF_STCD IS NULL OR D.APRV_CND_FLF_STCD NOT IN ('2','9') )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_개인금융심사팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


