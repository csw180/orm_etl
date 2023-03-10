CREATE TABLE OPEOWN.TB_OR_OM_SCHD_PLAN
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    BAS_YM              CHAR(6) NOT NULL,
    RK_EVL_TGT_YN       CHAR(1),
    RK_EVL_ST_DT        CHAR(8),
    RK_EVL_ED_DT        CHAR(8),
    RK_EVL_PRG_STSC     CHAR(2),
    RK_ACT_ST_DT        CHAR(8),
    RK_ACT_ED_DT        CHAR(8),
    RKI_EVL_TGT_YN      CHAR(1),
    RKI_ST_DT           CHAR(8),
    RKI_ED_DT           CHAR(8),
    RKI_PRG_STSC        CHAR(2),
    RKI_ACT_ST_DT       CHAR(8),
    RKI_ACT_ED_DT       CHAR(8),
    REP_EVL_TGT_YN      CHAR(1),
    REP_RKI_ST_DT       CHAR(8),
    REP_RKI_ED_DT       CHAR(8),
    REP_RKI_PRG_STSC    CHAR(2),
    BIA_EVL_TGT_YN      CHAR(1),
    BIA_YY              CHAR(4),
    BIA_EVL_ST_DT       CHAR(8),
    BIA_EVL_ED_DT       CHAR(8),
    BIA_EVL_PRG_STSC    CHAR(2),
    RA_EVL_TGT_YN       CHAR(1),
    RA_YY               CHAR(4),
    RA_EVL_ST_DT        CHAR(8),
    RA_EVL_ED_DT        CHAR(8),
    RA_EVL_PRG_STSC     CHAR(2),
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

ALTER TABLE OPEOWN.TB_OR_OM_SCHD_PLAN
ADD PRIMARY KEY (GRP_ORG_C,BAS_YM);

GRANT DELETE ON OPEOWN.TB_OR_OM_SCHD_PLAN TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OM_SCHD_PLAN TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_SCHD_PLAN TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OM_SCHD_PLAN TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_SCHD_PLAN TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.BIA_EVL_TGT_YN IS '평판평가대상여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RA_EVL_TGT_YN IS '평판평가대상여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.REP_EVL_TGT_YN IS '평판평가대상여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.REP_RKI_ED_DT IS '평판수행종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.REP_RKI_PRG_STSC IS '평판지표진행상태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.REP_RKI_ST_DT IS '평판수행시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RKI_ACT_ED_DT IS 'KRI대응방안수립마감기한';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RKI_ACT_ST_DT IS 'KRI대응방안수립시작일';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RKI_ED_DT IS 'KRI수행종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RKI_EVL_TGT_YN IS 'KRI평가대상여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RKI_PRG_STSC IS '리스크지표진행상태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RKI_ST_DT IS 'KRI수행시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RK_ACT_ED_DT IS 'RCSA대응방안수립마감기한';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RK_ACT_ST_DT IS 'RCSA대응방안수립시작일';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RK_EVL_ED_DT IS 'RCSA수행종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RK_EVL_PRG_STSC IS '리스크평가진행상태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RK_EVL_ST_DT IS 'RCSA수행시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SCHD_PLAN.RK_EVL_TGT_YN IS 'RCSA평가대상여부';
COMMENT ON TABLE OPEOWN.TB_OR_OM_SCHD_PLAN IS '공통_평가일정관리계획';

