CREATE TABLE OPEOWN.TB_OR_GA_LCSUMM
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    RGO_IN_DSC      CHAR(1) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    LSHP_AMNNO      NUMBER(9) NOT NULL,
    OCU_BRC         VARCHAR2(20),
    LSHP_STSC       CHAR(2),
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

ALTER TABLE OPEOWN.TB_OR_GA_LCSUMM
ADD CONSTRAINT PK_OR_GA_LCSUMM PRIMARY KEY (GRP_ORG_C,BAS_YM,RGO_IN_DSC,SBDR_C,LSHP_AMNNO);

GRANT DELETE ON OPEOWN.TB_OR_GA_LCSUMM TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GA_LCSUMM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_LCSUMM TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GA_LCSUMM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_LCSUMM TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.LSHP_AMNNO IS '손실사건관리번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.LSHP_STSC IS '손실사건상태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.OCU_BRC IS '발생사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.RGO_IN_DSC IS '규제내부구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCSUMM.SBDR_C IS '자회사코드';
COMMENT ON TABLE OPEOWN.TB_OR_GA_LCSUMM IS '측정_LC산출손실내역요약';

