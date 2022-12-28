CREATE TABLE OPEOWN.TB_OR_BH_RA
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    BAS_YM              CHAR(6) NOT NULL,
    RSK_C               CHAR(6) NOT NULL,
    BZPL_ACS_IMP_YN     CHAR(1),
    HMRS_LSS_YN         CHAR(1),
    IPT_RESC_IPMT_YN    CHAR(1),
    SYS_UG_IMP_YN       CHAR(1),
    DOFE_SPT_SSP_YN     CHAR(1),
    BCP_AMN_OBJ_YN      CHAR(1),
    RA_X_RSNC           CHAR(2),
    X_RSNCTT            VARCHAR2(2000),
    NATV_RSK_EVL_SCR    NUMBER(5,3),
    RSK_CTL_SUV_CNTN    VARCHAR2(2000),
    RM_RSK_EVL_SCR      NUMBER(5,3),
    RM_RSK_GRD_C        CHAR(2),
    RSK_MTG_ACT_CNTN    VARCHAR2(2000),
    BRC                 VARCHAR2(20),
    VLR_ENO             VARCHAR2(10),
    DCZ_SQNO            NUMBER(7),
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

ALTER TABLE OPEOWN.TB_OR_BH_RA
ADD PRIMARY KEY (GRP_ORG_C,BAS_YM,RSK_C);

GRANT DELETE ON OPEOWN.TB_OR_BH_RA TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BH_RA TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_RA TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BH_RA TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_RA TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.BCP_AMN_OBJ_YN IS 'BCP관리대상여부';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.BZPL_ACS_IMP_YN IS '사업장접근불가여부';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.DCZ_SQNO IS '결재일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.DOFE_SPT_SSP_YN IS '대내외지원중단여부';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.HMRS_LSS_YN IS '인력손실여부';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.IPT_RESC_IPMT_YN IS '중요자원손상여부';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.NATV_RSK_EVL_SCR IS '고유위험평가점수';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.RA_X_RSNC IS 'RA제외사유코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.RM_RSK_EVL_SCR IS '잔여위험평가점수';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.RM_RSK_GRD_C IS '잔여위험등급코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.RSK_C IS '위험코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.RSK_CTL_SUV_CNTN IS '위험통제조사내용';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.RSK_MTG_ACT_CNTN IS '위험경감조치내용';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.SYS_UG_IMP_YN IS '시스템사용불가여부';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.VLR_ENO IS '평가자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RA.X_RSNCTT IS '제외사유내용';
COMMENT ON TABLE OPEOWN.TB_OR_BH_RA IS 'BCP_RA내역';

