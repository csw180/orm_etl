CREATE TABLE OPEOWN.TB_OR_OC_CTL
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    RK_CTL_TPC          VARCHAR2(8) NOT NULL,
    CTL_TPNM            VARCHAR2(200),
    ENG_CTL_TPNM        VARCHAR2(200),
    LVL_NO              NUMBER(2),
    UP_RK_CTL_TPC       VARCHAR2(8),
    CTL_EXPL_CNTN       VARCHAR2(2000),
    ENG_CTL_EXPL_CNTN   VARCHAR2(2000),
    VLD_ST_DT           CHAR(8),
    VLD_ED_DT           CHAR(8),
    VLD_YN              CHAR(1),
    FIR_INP_DTM         DATE,
    FIR_INPMN_ENO       VARCHAR2(10),
    LSCHG_DTM           DATE,
    LS_WKR_ENO          VARCHAR2(10)
)
TABLESPACE TS_OPE_DT001_08K
STORAGE
(
    INITIAL 4M
    NEXT 4M
);

ALTER TABLE OPEOWN.TB_OR_OC_CTL
ADD CONSTRAINT PK_OR_OC_CTL PRIMARY KEY (GRP_ORG_C,RK_CTL_TPC);

GRANT DELETE ON OPEOWN.TB_OR_OC_CTL TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OC_CTL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OC_CTL TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OC_CTL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OC_CTL TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.CTL_EXPL_CNTN IS '통제설명내용';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.CTL_TPNM IS '통제유형명';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.ENG_CTL_EXPL_CNTN IS '영문통제설명내용';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.ENG_CTL_TPNM IS '영문통제유형명';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.LVL_NO IS '레벨번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.RK_CTL_TPC IS '리스크통제유형코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.UP_RK_CTL_TPC IS '상위리스크통제유형코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.VLD_ED_DT IS '유효종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.VLD_ST_DT IS '유효시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_CTL.VLD_YN IS '유효여부';
COMMENT ON TABLE OPEOWN.TB_OR_OC_CTL IS '공통_통제유형코드';

