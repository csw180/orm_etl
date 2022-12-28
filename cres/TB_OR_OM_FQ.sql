CREATE TABLE OPEOWN.TB_OR_OM_FQ
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    AMN_MM          CHAR(2) NOT NULL,
    RPT_FQ_DSC      VARCHAR2(2) NOT NULL,
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

ALTER TABLE OPEOWN.TB_OR_OM_FQ
ADD CONSTRAINT PK_OR_OM_FQ PRIMARY KEY (GRP_ORG_C,AMN_MM,RPT_FQ_DSC);

GRANT DELETE ON OPEOWN.TB_OR_OM_FQ TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OM_FQ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_FQ TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OM_FQ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_FQ TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OM_FQ.AMN_MM IS '관리월';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_FQ.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_FQ.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_FQ.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_FQ.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_FQ.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_FQ.RPT_FQ_DSC IS '보고주기구분코드';
COMMENT ON TABLE OPEOWN.TB_OR_OM_FQ IS 'KRI_리스크지표보고주기기본';

