CREATE TABLE OPEOWN.TB_OR_BC_NARKHD
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    NATV_RSK_HDNG_C CHAR(2) NOT NULL,
    NATV_RSK_DSC    CHAR(2),
    NATV_RSK_HDNGNM VARCHAR2(20),
    WVAL_RTO        NUMBER(5,3),
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

ALTER TABLE OPEOWN.TB_OR_BC_NARKHD
ADD CONSTRAINT PK_OR_BC_NARKHD PRIMARY KEY (GRP_ORG_C,NATV_RSK_HDNG_C);

GRANT DELETE ON OPEOWN.TB_OR_BC_NARKHD TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BC_NARKHD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BC_NARKHD TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BC_NARKHD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BC_NARKHD TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BC_NARKHD.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BC_NARKHD.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BC_NARKHD.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BC_NARKHD.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BC_NARKHD.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BC_NARKHD.NATV_RSK_DSC IS '고유위험구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BC_NARKHD.NATV_RSK_HDNGNM IS '고유위험항목명';
COMMENT ON COLUMN OPEOWN.TB_OR_BC_NARKHD.NATV_RSK_HDNG_C IS '고유위험항목코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BC_NARKHD.WVAL_RTO IS '가중치비율';
COMMENT ON TABLE OPEOWN.TB_OR_BC_NARKHD IS 'BCP_고유위험항목코드';

