CREATE TABLE OPEOWN.TB_OR_BH_NED_BZDE
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    BRC             VARCHAR2(20) NOT NULL,
    DSQNO           NUMBER(5) NOT NULL,
    BZS_DEVCNM      VARCHAR2(100),
    QT              NUMBER(5),
    UG_UZ_EXPL      VARCHAR2(200),
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

ALTER TABLE OPEOWN.TB_OR_BH_NED_BZDE
ADD CONSTRAINT PK_OR_BH_NED_BZDE PRIMARY KEY (GRP_ORG_C,BAS_YM,BSN_PRSS_C,BRC,DSQNO);

GRANT DELETE ON OPEOWN.TB_OR_BH_NED_BZDE TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BH_NED_BZDE TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_NED_BZDE TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BH_NED_BZDE TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_NED_BZDE TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.BRC IS '사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.BSN_PRSS_C IS '업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.BZS_DEVCNM IS '사무기기명';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.DSQNO IS '상세일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.QT IS '수량';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_BZDE.UG_UZ_EXPL IS '사용용도설명';
COMMENT ON TABLE OPEOWN.TB_OR_BH_NED_BZDE IS 'BCP_필요사무기기내역';

