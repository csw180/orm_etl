CREATE TABLE OPEOWN.TB_OR_BH_SSPIFN_WVAL
(
    GRP_ORG_C               CHAR(2) NOT NULL,
    BAS_YM                  CHAR(6) NOT NULL,
    BCP_IFN_DSC             CHAR(2) NOT NULL,
    BSN_SSP_IFN_WVAL_RTO    NUMBER(5,3),
    FIR_INP_DTM             DATE,
    FIR_INPMN_ENO           VARCHAR2(10),
    LSCHG_DTM               DATE,
    LS_WKR_ENO              VARCHAR2(10)
)
TABLESPACE TS_OPE_DT001_08K
STORAGE
(
    INITIAL 4M
    NEXT 4M
);

ALTER TABLE OPEOWN.TB_OR_BH_SSPIFN_WVAL
ADD CONSTRAINT PK_OR_BH_SSPIFN_WVAL PRIMARY KEY (GRP_ORG_C,BAS_YM,BCP_IFN_DSC);

GRANT DELETE ON OPEOWN.TB_OR_BH_SSPIFN_WVAL TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BH_SSPIFN_WVAL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_SSPIFN_WVAL TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BH_SSPIFN_WVAL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_SSPIFN_WVAL TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_WVAL.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_WVAL.BCP_IFN_DSC IS 'BCP영향구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_WVAL.BSN_SSP_IFN_WVAL_RTO IS '업무중단영향가중치비율';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_WVAL.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_WVAL.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_WVAL.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_WVAL.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_WVAL.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON TABLE OPEOWN.TB_OR_BH_SSPIFN_WVAL IS 'BCP_업무중단영향가중치내역';

