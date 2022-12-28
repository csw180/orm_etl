DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀03;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,CLN_EXE_NO                              NUMBER(10)
  ,CLN_TR_NO                               NUMBER(10)
  ,CRCD                                    VARCHAR2(3)
  ,WN_TNSL_INT                             NUMBER(18,2)  -- 이자상환금액
  ,INT_RCFM_DT                             VARCHAR2(8) -- 이자기산일자
  ,RCFM_DT                                 VARCHAR2(8) -- 기산일자
  ,TR_DT                                   VARCHAR2(8) -- 거래일자
  ,USR_NO                                  VARCHAR2(10) -- 거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀03               IS 'OPE_KRI_여신지원팀03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.CLN_ACNO     IS '여신계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.CLN_EXE_NO   IS '여신실행번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.CLN_TR_NO    IS '여신거래번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.WN_TNSL_INT  IS '원화환산이자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.INT_RCFM_DT  IS '이자기산일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.RCFM_DT      IS '기산일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀03.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_여신지원팀03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀03 TO RL_OPE_SEL;

EXIT
