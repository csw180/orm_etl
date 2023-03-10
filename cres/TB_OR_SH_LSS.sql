CREATE TABLE OPEOWN.TB_OR_SH_LSS
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    SNRO_SC         NUMBER(6) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    LSHP_AMNNO      NUMBER(9) NOT NULL,
    LSS_TINM        VARCHAR2(500),
    TTLS_AM         NUMBER(18,3),
    GULS_AM         NUMBER(18,3),
    OCU_DT          CHAR(8),
    REG_DT          CHAR(8),
    FIR_INP_DTM     DATE,
    FIR_INPMN_ENO   VARCHAR2(10),
    LSCHG_DTM       DATE,
    LS_WKR_ENO      VARCHAR2(10),
    AMN_BRC         VARCHAR2(20)
)
TABLESPACE TS_OPE_DT001_08K
STORAGE
(
    INITIAL 4M
    NEXT 4M
);

ALTER TABLE OPEOWN.TB_OR_SH_LSS
ADD CONSTRAINT PK_OR_SH_LSS PRIMARY KEY (GRP_ORG_C,SNRO_SC,BSN_PRSS_C,LSHP_AMNNO);

GRANT DELETE ON OPEOWN.TB_OR_SH_LSS TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_SH_LSS TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_SH_LSS TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_SH_LSS TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_SH_LSS TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.AMN_BRC IS '사건관리부';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.BSN_PRSS_C IS '업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.GULS_AM IS '순손실금액';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.LSHP_AMNNO IS '손실사건관리번호';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.LSS_TINM IS '손실제목명';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.OCU_DT IS '발생일자';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.REG_DT IS '등록일자';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.SNRO_SC IS '시나리오회차';
COMMENT ON COLUMN OPEOWN.TB_OR_SH_LSS.TTLS_AM IS '총손실금액';
COMMENT ON TABLE OPEOWN.TB_OR_SH_LSS IS '시나리오_최근발생손실내역';

