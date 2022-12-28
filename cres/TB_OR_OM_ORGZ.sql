CREATE TABLE OPEOWN.TB_OR_OM_ORGZ
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    BRC                 VARCHAR2(20) NOT NULL,
    BRNM                VARCHAR2(100),
    LVL_NO              NUMBER(2),
    UP_BRC              VARCHAR2(20),
    BR_LKO_YN           CHAR(1),
    RGN_C               VARCHAR2(4),
    HURSAL_BR_FORM_C    VARCHAR2(2),
    HOFC_BIZO_DSC       CHAR(2),
    ORGZ_CFC            VARCHAR2(5),
    UYN                 CHAR(1),
    LWST_ORGZ_YN        CHAR(1),
    RCSA_ORGZ_YN        CHAR(1),
    KRI_ORGZ_YN         CHAR(1),
    LSS_ORGZ_YN         CHAR(1),
    ANW_YN              CHAR(1),
    TEMGR_DCZ_YN        CHAR(1),
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

ALTER TABLE OPEOWN.TB_OR_OM_ORGZ
ADD CONSTRAINT PK_OR_OM_ORGZ PRIMARY KEY (GRP_ORG_C,BRC);

GRANT DELETE ON OPEOWN.TB_OR_OM_ORGZ TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OM_ORGZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_ORGZ TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OM_ORGZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_ORGZ TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.ANW_YN IS '신규여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.BRC IS '사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.BRNM IS '사무소명';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.BR_LKO_YN IS '사무소폐쇄여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.HOFC_BIZO_DSC IS '본부영업점구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.HURSAL_BR_FORM_C IS '인사급여사무소형태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.KRI_ORGZ_YN IS '핵심리스크지표조직여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.LSS_ORGZ_YN IS '손실조직여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.LVL_NO IS '레벨번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.LWST_ORGZ_YN IS '최하위조직여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.ORGZ_CFC IS '조직분류코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.RCSA_ORGZ_YN IS 'RCSA조직여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.RGN_C IS '지역코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.TEMGR_DCZ_YN IS '팀장결재여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.UP_BRC IS '상위사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.UYN IS '사용여부';
COMMENT ON TABLE OPEOWN.TB_OR_OM_ORGZ IS '공통_조직기본';

