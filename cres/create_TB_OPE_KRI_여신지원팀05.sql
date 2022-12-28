DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀05;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀05
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,PDCD                                    VARCHAR2(14)
  ,PRD_KR_NM                               VARCHAR2(100)  -- 상품한글명
  ,CRCD                                    VARCHAR2(3)
  ,MIMO_AMT                                NUMBER(18,2)   -- 전입전출금액
  ,MVT_BRNO                                VARCHAR2(4)    -- 이관점번호
  ,MVT_BR_NM                               VARCHAR2(100)  -- 이관점명
  ,MVT_TR_USR_NO                           VARCHAR2(10)   -- 이관조작자직원번호
  ,MVN_BRNO                                VARCHAR2(4)    -- 수관점번호
  ,MVN_BR_NM                               VARCHAR2(100)  -- 수관점명
  ,MVN_TR_USR_NO                           VARCHAR2(10)   -- 수관조작자직원번호
  ,TR_DT                                   VARCHAR2(8)    -- 이수관조작일자
  ,APRV_TGT_YN                             VARCHAR2(1)    -- 승인대상여부
  ,APRV_BRNO                               VARCHAR2(4)    -- 승인점번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀05               IS 'OPE_KRI_여신지원팀05';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.CLN_ACNO     IS '여신계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.PDCD         IS '상품코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.MIMO_AMT     IS '전입전출금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.MVT_BRNO     IS '전출점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.MVT_BR_NM        IS '전출점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.MVT_TR_USR_NO    IS '전출거래사용자번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.MVN_BRNO         IS '전입점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.MVN_BR_NM        IS '전입점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.MVN_TR_USR_NO    IS '전입거래사용자번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.TR_DT            IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.APRV_TGT_YN      IS '승인대상여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀05.APRV_BRNO        IS '승인점번호';

GRANT SELECT ON TB_OPE_KRI_여신지원팀05 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀05 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀05 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀05 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀05 TO RL_OPE_SEL;

EXIT
