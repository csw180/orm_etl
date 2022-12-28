CREATE TABLE OPEOWN.TB_OR_ON_PRSSMM
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          NUMBER(6) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    BSN_PRSNM       VARCHAR2(200),
    ENG_BSN_PRSNM   VARCHAR2(200),
    LVL_NO          NUMBER(2),
    UP_BSN_PRSS_C   VARCHAR2(12),
    VLD_ST_DT       CHAR(8),
    VLD_ED_DT       CHAR(8),
    VLD_YN          CHAR(1),
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

ALTER TABLE OPEOWN.TB_OR_ON_PRSSMM
ADD CONSTRAINT PK_OR_ON_PRSMM PRIMARY KEY (GRP_ORG_C,BAS_YM,BSN_PRSS_C);

GRANT DELETE ON OPEOWN.TB_OR_ON_PRSSMM TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_ON_PRSSMM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_ON_PRSSMM TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_ON_PRSSMM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_ON_PRSSMM TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.BAS_YM IS '리스크평가회차';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.BSN_PRSNM IS '업무프로세스명';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.BSN_PRSS_C IS '업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.ENG_BSN_PRSNM IS '영문업무프로세스명';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.LVL_NO IS '레벨번호';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.UP_BSN_PRSS_C IS '상위업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.VLD_ED_DT IS '유효종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.VLD_ST_DT IS '유효시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_ON_PRSSMM.VLD_YN IS '유효여부';
COMMENT ON TABLE OPEOWN.TB_OR_ON_PRSSMM IS '공통_업무프로세스월말';

