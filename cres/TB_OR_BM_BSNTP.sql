CREATE TABLE OPEOWN.TB_OR_BM_BSNTP
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BCP_BSN_TPC     CHAR(2) NOT NULL,
    BCP_BSN_TPNM    VARCHAR2(200),
    BCP_BSN_TP_CNTN VARCHAR2(2000),
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

ALTER TABLE OPEOWN.TB_OR_BM_BSNTP
ADD CONSTRAINT PK_OR_BM_BSNTP PRIMARY KEY (GRP_ORG_C,BCP_BSN_TPC);

GRANT DELETE ON OPEOWN.TB_OR_BM_BSNTP TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BM_BSNTP TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BM_BSNTP TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BM_BSNTP TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BM_BSNTP TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BM_BSNTP.BCP_BSN_TPC IS 'BCP업무유형코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BSNTP.BCP_BSN_TPNM IS 'BCP업무유형명';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BSNTP.BCP_BSN_TP_CNTN IS 'BCP업무유형내용';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BSNTP.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BSNTP.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BSNTP.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BSNTP.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BSNTP.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON TABLE OPEOWN.TB_OR_BM_BSNTP IS 'BCP_업무유형기본';

