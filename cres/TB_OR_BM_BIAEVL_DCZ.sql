CREATE TABLE OPEOWN.TB_OR_BM_BIAEVL_DCZ
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    DCZ_SQNO        NUMBER(7) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    BRC             VARCHAR2(20) NOT NULL,
    DCZ_DT          CHAR(8),
    DCZMN_ENO       VARCHAR2(10),
    BIA_DCZ_STSC    CHAR(2),
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

ALTER TABLE OPEOWN.TB_OR_BM_BIAEVL_DCZ
ADD CONSTRAINT PK_OR_BM_BIAEVL_DCZ PRIMARY KEY (GRP_ORG_C,BAS_YM,DCZ_SQNO,BSN_PRSS_C,BRC);

GRANT DELETE ON OPEOWN.TB_OR_BM_BIAEVL_DCZ TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BM_BIAEVL_DCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BM_BIAEVL_DCZ TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BM_BIAEVL_DCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BM_BIAEVL_DCZ TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.BIA_DCZ_STSC IS 'BIA결재상태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.BRC IS '사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.BSN_PRSS_C IS '업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.DCZMN_ENO IS '결재개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.DCZ_DT IS '결재일자';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.DCZ_OBJR_ENO IS '결재대상자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.DCZ_RMK_C IS '결재비고코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.DCZ_SQNO IS '결재일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BM_BIAEVL_DCZ.RTN_CNTN IS '반려내용';
COMMENT ON TABLE OPEOWN.TB_OR_BM_BIAEVL_DCZ IS 'BCP_BIA평가기본결재내역';

