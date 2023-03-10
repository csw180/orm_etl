CREATE TABLE OPEOWN.TB_OR_RN_CTL_SCFMM
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    OPRK_RKP_ID     VARCHAR2(10) NOT NULL,
    RK_CP_ID        VARCHAR2(10) NOT NULL,
    RK_CTL_SQNO     NUMBER(5) NOT NULL,
    RK_CTL_TPC      VARCHAR2(8),
    RK_CP_CNTN      VARCHAR2(800),
    ENG_RK_CP_CNTN  VARCHAR2(800),
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

ALTER TABLE OPEOWN.TB_OR_RN_CTL_SCFMM
ADD CONSTRAINT PK_OR_RN_CTL_SCFMM PRIMARY KEY (GRP_ORG_C,BAS_YM,OPRK_RKP_ID,RK_CP_ID,RK_CTL_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_RN_CTL_SCFMM TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_RN_CTL_SCFMM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RN_CTL_SCFMM TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_RN_CTL_SCFMM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RN_CTL_SCFMM TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.ENG_RK_CP_CNTN IS '영문통제내용_리스크풀';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.OPRK_RKP_ID IS '운영리스크리스크풀ID';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.RK_CP_CNTN IS '통제내용_리스크풀';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.RK_CP_ID IS '리스크풀 통제ID';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.RK_CTL_SQNO IS '리스크통제일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RN_CTL_SCFMM.RK_CTL_TPC IS '리스크통제유형코드';
COMMENT ON TABLE OPEOWN.TB_OR_RN_CTL_SCFMM IS 'RCSA_리스크풀통제유혁내역';

