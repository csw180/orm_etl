CREATE TABLE OPEOWN.TB_OR_SH_RPTG_DCZ
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    SNRO_SC         NUMBER(6) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    DCZ_SQNO        NUMBER(7) NOT NULL,
    DCZ_DT          CHAR(8),
    DCZMN_ENO       VARCHAR2(10),
    SNRO_DCZ_STSC   CHAR(2),
    RTN_CNTN        VARCHAR2(500),
    DCZ_OBJR_ENO    VARCHAR2(10),
    DCZ_RMK_C       CHAR(2),
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

ALTER TABLE OPEOWN.TB_OR_SH_RPTG_DCZ
ADD CONSTRAINT PK_OR_SH_RPTG_DCZ PRIMARY KEY (GRP_ORG_C,SNRO_SC,BSN_PRSS_C,DCZ_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_SH_RPTG_DCZ TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_SH_RPTG_DCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_SH_RPTG_DCZ TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_SH_RPTG_DCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_SH_RPTG_DCZ TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.BSN_PRSS_C IS '업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.DCZMN_ENO IS '결재개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.DCZ_DT IS '결재일자';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.DCZ_OBJR_ENO IS '결재대상자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.DCZ_RMK_C IS '결재비고코드';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.DCZ_SQNO IS '결재일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.RTN_CNTN IS '반려내용';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.SNRO_DCZ_STSC IS '시나리오결재상태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_RPTG_DCZ.SNRO_SC IS '시나리오회차';
COMMENT ON TABLE OPEOWN.TB_OR_SH_RPTG_DCZ IS '시나리오_보고서결재내역';

