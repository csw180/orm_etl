CREATE TABLE OPEOWN.TB_OR_OH_PRSS_UGBR
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    BRC             VARCHAR2(20) NOT NULL,
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

ALTER TABLE OPEOWN.TB_OR_OH_PRSS_UGBR
ADD CONSTRAINT PK_OR_OH_PRSS_UGBR PRIMARY KEY (GRP_ORG_C,BSN_PRSS_C,BRC);

GRANT DELETE ON OPEOWN.TB_OR_OH_PRSS_UGBR TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OH_PRSS_UGBR TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OH_PRSS_UGBR TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OH_PRSS_UGBR TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OH_PRSS_UGBR TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_UGBR.BRC IS '사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_UGBR.BSN_PRSS_C IS '업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_UGBR.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_UGBR.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_UGBR.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_UGBR.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_PRSS_UGBR.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON TABLE OPEOWN.TB_OR_OH_PRSS_UGBR IS '공통_업무프로세스사용부서내역';

