CREATE TABLE OPEOWN.TB_OR_OM_SSO_INF
(
    SSO_ENO         VARCHAR2(64) NOT NULL,
    SSO_PWIZE_PW    VARCHAR2(64),
    SSO_USRNM       VARCHAR2(64),
    SSO_BRC         VARCHAR2(20),
    ACCESS_YN       CHAR(1),
    FIR_INP_DTM     DATE,
    FIR_INPMN_ENO   VARCHAR2(10),
    LSCHG_DTM       DATE,
    LS_WKR_ENO      VARCHAR2(10)
)
TABLESPACE TS_OPE_DT001_08K
STORAGE
(
    INITIAL 4M
    NEXT 4M
);

ALTER TABLE OPEOWN.TB_OR_OM_SSO_INF
ADD CONSTRAINT PK_OR_OM_SSO_INF PRIMARY KEY (SSO_ENO);

GRANT DELETE ON OPEOWN.TB_OR_OM_SSO_INF TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OM_SSO_INF TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_SSO_INF TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OM_SSO_INF TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_SSO_INF TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.ACCESS_YN IS '접속허용유무';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.SSO_BRC IS '통합로그인사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.SSO_ENO IS '통합로그인사번';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.SSO_PWIZE_PW IS '통합로그인비밀번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.SSO_USRNM IS '통합로그인사용자명';
COMMENT ON TABLE OPEOWN.TB_OR_OM_SSO_INF IS '공통_통합로그인정보기본';

