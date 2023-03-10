CREATE TABLE OPEOWN.TB_OR_KM_RKI
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    OPRK_RKI_ID     VARCHAR2(20) NOT NULL,
    OPRK_RKINM      VARCHAR2(200),
    RKI_ATTR_C      CHAR(2),
    RKI_LVL_C       CHAR(2),
    RKI_OBV_CNTN    VARCHAR2(2000),
    RKI_DEF_CNTN    VARCHAR2(1000),
    IDX_FML_CNTN    VARCHAR2(1000),
    RKI_UNT_C       CHAR(2),
    RPT_FQ_DSC      VARCHAR2(2),
    KRI_LMT_DSC     CHAR(2),
    LMT_CHG_CNTN    VARCHAR2(2000),
    COM_COL_PSB_YN  CHAR(1),
    KRI_YN          CHAR(1),
    GU_DRTN_RER_DSC CHAR(1),
    PSN_KRI_YN      CHAR(1),
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

ALTER TABLE OPEOWN.TB_OR_KM_RKI
ADD CONSTRAINT PK_OR_KM_RKI PRIMARY KEY (GRP_ORG_C,OPRK_RKI_ID);

GRANT DELETE ON OPEOWN.TB_OR_KM_RKI TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_KM_RKI TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_KM_RKI TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_KM_RKI TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_KM_RKI TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.COM_COL_PSB_YN IS '전산수집가능여부';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.GU_DRTN_RER_DSC IS '순방향역방향구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.IDX_FML_CNTN IS '지표산식내용';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.KRI_LMT_DSC IS '핵심리스크지표한도구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.KRI_YN IS '핵심리스크지표여부';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.LMT_CHG_CNTN IS '한도변경내용상세';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.OPRK_RKINM IS '운영리스크리스크지표명';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.OPRK_RKI_ID IS '운영리스크리스크지표ID';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.PSN_KRI_YN IS '개인화KRI여부';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.RKI_ATTR_C IS '리스크지표속성코드';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.RKI_DEF_CNTN IS '리스크지표정의내용';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.RKI_LVL_C IS '리스크지표수준코드';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.RKI_OBV_CNTN IS '리스크지표목적내용';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.RKI_UNT_C IS '리스크지표단위코드';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.RPT_FQ_DSC IS '보고주기구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.VLD_ED_DT IS '유효종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.VLD_ST_DT IS '유효시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_KM_RKI.VLD_YN IS '유효여부';
COMMENT ON TABLE OPEOWN.TB_OR_KM_RKI IS 'KRI_RI풀기본';

