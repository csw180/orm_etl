CREATE TABLE OPEOWN.TB_OR_GA_TMP_ACC
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    ULD_ACC_CNM     VARCHAR2(50) NOT NULL,
    ULD_ACC_NM      VARCHAR2(100) NOT NULL,
    UP_ULD_ACC_CNM  VARCHAR2(50) NOT NULL,
    UP_ULD_ACC_NM   VARCHAR2(100) NOT NULL,
    TMP_ACC_SQNO    NUMBER(13),
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

ALTER TABLE OPEOWN.TB_OR_GA_TMP_ACC
ADD CONSTRAINT PK_OR_GA_TMP_ACC PRIMARY KEY (GRP_ORG_C,ULD_ACC_CNM,ULD_ACC_NM,UP_ULD_ACC_CNM,UP_ULD_ACC_NM);

GRANT DELETE ON OPEOWN.TB_OR_GA_TMP_ACC TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GA_TMP_ACC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_TMP_ACC TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GA_TMP_ACC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_TMP_ACC TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GA_TMP_ACC.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_TMP_ACC.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_TMP_ACC.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_TMP_ACC.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_TMP_ACC.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_TMP_ACC.TMP_ACC_SQNO IS '임시계정일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_TMP_ACC.ULD_ACC_CNM IS '업로드계정코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_TMP_ACC.ULD_ACC_NM IS '업로드계정명';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_TMP_ACC.UP_ULD_ACC_CNM IS '상위업로드계정코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_TMP_ACC.UP_ULD_ACC_NM IS '상위업로드계정명';
COMMENT ON TABLE OPEOWN.TB_OR_GA_TMP_ACC IS '측정_임시계정';

