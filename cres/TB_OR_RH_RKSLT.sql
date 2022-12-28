CREATE TABLE OPEOWN.TB_OR_RH_RKSLT
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    OPRK_RKP_ID     VARCHAR2(10) NOT NULL,
    EVL_OBJ_YN      CHAR(1),
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

ALTER TABLE OPEOWN.TB_OR_RH_RKSLT
ADD CONSTRAINT PK_OR_RH_RKSLT PRIMARY KEY (GRP_ORG_C,BAS_YM,OPRK_RKP_ID);

GRANT DELETE ON OPEOWN.TB_OR_RH_RKSLT TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_RH_RKSLT TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RH_RKSLT TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_RH_RKSLT TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RH_RKSLT TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_RH_RKSLT.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_RKSLT.EVL_OBJ_YN IS '평가대상여부';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_RKSLT.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_RKSLT.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_RKSLT.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_RKSLT.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_RKSLT.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_RKSLT.OPRK_RKP_ID IS '운영리스크리스크풀ID';
COMMENT ON TABLE OPEOWN.TB_OR_RH_RKSLT IS 'RCSA_리스크평가대상선정내역';

