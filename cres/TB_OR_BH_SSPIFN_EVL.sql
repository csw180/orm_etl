CREATE TABLE OPEOWN.TB_OR_BH_SSPIFN_EVL
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    BRC             VARCHAR2(20) NOT NULL,
    BCP_IFN_DSC     CHAR(2) NOT NULL,
    COIC_YN         CHAR(1),
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

ALTER TABLE OPEOWN.TB_OR_BH_SSPIFN_EVL
ADD CONSTRAINT PK_OR_BH_SSPIFN_EVL PRIMARY KEY (GRP_ORG_C,BAS_YM,BSN_PRSS_C,BRC,BCP_IFN_DSC);

GRANT DELETE ON OPEOWN.TB_OR_BH_SSPIFN_EVL TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BH_SSPIFN_EVL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_SSPIFN_EVL TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BH_SSPIFN_EVL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_SSPIFN_EVL TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.BCP_IFN_DSC IS 'BCP영향구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.BRC IS '사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.BSN_PRSS_C IS '업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.COIC_YN IS '선택여부';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON TABLE OPEOWN.TB_OR_BH_SSPIFN_EVL IS 'BCP_업무중단영향평가내역';

