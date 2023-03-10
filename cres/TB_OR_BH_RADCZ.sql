CREATE TABLE OPEOWN.TB_OR_BH_RADCZ
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    RSK_C           CHAR(6) NOT NULL,
    DCZ_SQNO        NUMBER(7) NOT NULL,
    DCZ_DT          CHAR(8),
    DCZMN_ENO       VARCHAR2(10),
    RA_DCZ_STSC     CHAR(2),
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

ALTER TABLE OPEOWN.TB_OR_BH_RADCZ
ADD CONSTRAINT PK_OR_BH_RADCZ PRIMARY KEY (GRP_ORG_C,BAS_YM,RSK_C,DCZ_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_BH_RADCZ TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BH_RADCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_RADCZ TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BH_RADCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_RADCZ TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.DCZMN_ENO IS '결재개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.DCZ_DT IS '결재일자';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.DCZ_OBJR_ENO IS '결재대상자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.DCZ_RMK_C IS '결재비고코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.DCZ_SQNO IS '결재일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.RA_DCZ_STSC IS 'RA결재상태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.RSK_C IS '위험코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.RTN_CNTN IS '반려내용';
COMMENT ON TABLE OPEOWN.TB_OR_BH_RADCZ IS 'BCP_RA결재내역';

