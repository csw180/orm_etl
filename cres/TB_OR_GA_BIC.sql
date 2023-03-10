CREATE TABLE OPEOWN.TB_OR_GA_BIC
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    RGO_IN_DSC      CHAR(1) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    LV1_BIZ_IX_C    CHAR(2) NOT NULL,
    MSR_AM          NUMBER(21),
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

ALTER TABLE OPEOWN.TB_OR_GA_BIC
ADD CONSTRAINT PK_OR_GA_BIC PRIMARY KEY (GRP_ORG_C,BAS_YM,RGO_IN_DSC,SBDR_C,LV1_BIZ_IX_C);

GRANT DELETE ON OPEOWN.TB_OR_GA_BIC TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GA_BIC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_BIC TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GA_BIC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_BIC TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GA_BIC.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BIC.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BIC.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BIC.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BIC.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BIC.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BIC.LV1_BIZ_IX_C IS '1레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BIC.MSR_AM IS '산출금액';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BIC.RGO_IN_DSC IS '규제내부구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BIC.SBDR_C IS '자회사코드';
COMMENT ON TABLE OPEOWN.TB_OR_GA_BIC IS '측정_영업지수요소산출';

