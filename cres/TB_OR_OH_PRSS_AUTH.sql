CREATE TABLE OPEOWN.TB_OR_OH_PRSS_AUTH
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    AUTH_GRP_ID     VARCHAR2(3) NOT NULL,
    PGID            VARCHAR2(20) NOT NULL,
    PRSS_KDC        CHAR(2) NOT NULL,
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

ALTER TABLE OPEOWN.TB_OR_OH_PRSS_AUTH
ADD CONSTRAINT PK_OR_OH_PRSS_AUTH PRIMARY KEY (GRP_ORG_C,AUTH_GRP_ID,PGID,PRSS_KDC);

GRANT DELETE ON OPEOWN.TB_OR_OH_PRSS_AUTH TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OH_PRSS_AUTH TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OH_PRSS_AUTH TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OH_PRSS_AUTH TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OH_PRSS_AUTH TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_AUTH.AUTH_GRP_ID IS '권한그룹ID';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_AUTH.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_AUTH.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_AUTH.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_AUTH.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_AUTH.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_AUTH.PGID IS '프로그램ID';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_AUTH.PRSS_KDC IS '프로세스종류코드';
COMMENT ON TABLE OPEOWN.TB_OR_OH_PRSS_AUTH IS '공통_프로세스별권한내역';

