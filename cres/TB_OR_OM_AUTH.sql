CREATE TABLE OPEOWN.TB_OR_OM_AUTH
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    AUTH_GRP_ID     VARCHAR2(3) NOT NULL,
    AUTH_GRPNM      VARCHAR2(100),
    AUTH_GRP_EXPL   VARCHAR2(255),
    AUTH_C          VARCHAR2(1),
    VLD_YN          CHAR(1),
    VLD_ST_DT       CHAR(8),
    VLD_ED_DT       CHAR(8),
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

ALTER TABLE OPEOWN.TB_OR_OM_AUTH
ADD CONSTRAINT PK_OR_OM_AUTH PRIMARY KEY (GRP_ORG_C,AUTH_GRP_ID);

GRANT DELETE ON OPEOWN.TB_OR_OM_AUTH TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OM_AUTH TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_AUTH TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OM_AUTH TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_AUTH TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.AUTH_C IS '권한코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.AUTH_GRPNM IS '권한그룹명';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.AUTH_GRP_EXPL IS '권한그룹설명';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.AUTH_GRP_ID IS '권한그룹ID';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.VLD_ED_DT IS '유효종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.VLD_ST_DT IS '유효시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_AUTH.VLD_YN IS '유효여부';
COMMENT ON TABLE OPEOWN.TB_OR_OM_AUTH IS '공통_권한기본';

