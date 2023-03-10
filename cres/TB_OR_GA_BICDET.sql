CREATE TABLE OPEOWN.TB_OR_GA_BICDET
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    RGO_IN_DSC      CHAR(1) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    LV1_BIZ_IX_C    CHAR(2) NOT NULL,
    LV2_BIZ_IX_C    CHAR(4) NOT NULL,
    MSR_YY          CHAR(4) NOT NULL,
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

ALTER TABLE OPEOWN.TB_OR_GA_BICDET
ADD CONSTRAINT PK_OR_GA_BICDET PRIMARY KEY (GRP_ORG_C,BAS_YM,RGO_IN_DSC,SBDR_C,LV1_BIZ_IX_C,LV2_BIZ_IX_C,MSR_YY);

GRANT DELETE ON OPEOWN.TB_OR_GA_BICDET TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GA_BICDET TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_BICDET TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GA_BICDET TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_BICDET TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.LV1_BIZ_IX_C IS '1레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.LV2_BIZ_IX_C IS '2레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.MSR_AM IS '산출금액';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.MSR_YY IS '산출년';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.RGO_IN_DSC IS '규제내부구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_BICDET.SBDR_C IS '자회사코드';
COMMENT ON TABLE OPEOWN.TB_OR_GA_BICDET IS '측정_영업지수요소산출상세';

