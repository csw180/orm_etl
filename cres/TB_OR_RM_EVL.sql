CREATE TABLE OPEOWN.TB_OR_RM_EVL
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    BAS_YM              CHAR(6) NOT NULL,
    OPRK_RKP_ID         VARCHAR2(10) NOT NULL,
    BRC                 VARCHAR2(20) NOT NULL,
    EVL_OBJ_YN          CHAR(1),
    FRQ_EVL_C           CHAR(1),
    IFN_EVL_C           CHAR(1),
    NIFN_EVL_C          CHAR(1),
    RK_EVL_GRD_C        CHAR(1),
    RBF_FRQ_EVL_C       CHAR(1),
    RBF_IFN_EVL_C       CHAR(1),
    RBF_NIFN_EVL_C      CHAR(1),
    RBF_RK_EVL_GRD_C    CHAR(1),
    CTL_DSG_EVL_C       CHAR(1),
    CTL_MNGM_EVL_C      CHAR(1),
    CTEV_GRD_C          CHAR(1),
    RMN_RSK_GRD_C       CHAR(1),
    RBF_RMN_RSK_GRD_C   CHAR(1),
    EVL_DT              CHAR(8),
    VLR_ENO             VARCHAR2(10),
    ETC_EVL_CNTN        VARCHAR2(2000),
    REEVL_YN            CHAR(1),
    KRK_YN              CHAR(1) DEFAULT 'Y',
    IPTK_OBJ_YN         CHAR(1),
    EVL_CPL_YN          CHAR(1),
    FNA_NFNA_DSC        CHAR(1),
    DCZ_SQNO            NUMBER(7),
    FIR_INP_DTM         DATE,
    FIR_INPMN_ENO       VARCHAR2(10),
    LSCHG_DTM           DATE,
    LS_WKR_ENO          VARCHAR2(10),
    RBF_CTEV_GRD_C      CHAR(1)
)
TABLESPACE TS_OPE_DT001_08K
STORAGE
(
    INITIAL 4M
    NEXT 4M
);

ALTER TABLE OPEOWN.TB_OR_RM_EVL
ADD CONSTRAINT PK_OR_RM_EVL PRIMARY KEY (GRP_ORG_C,BAS_YM,OPRK_RKP_ID,BRC);

GRANT DELETE ON OPEOWN.TB_OR_RM_EVL TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_RM_EVL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RM_EVL TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_RM_EVL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RM_EVL TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.BRC IS '사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.CTEV_GRD_C IS '통제평가등급코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.CTL_DSG_EVL_C IS '통제설계평가코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.CTL_MNGM_EVL_C IS '통제운영평가코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.DCZ_SQNO IS '결재일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.ETC_EVL_CNTN IS '기타평가내용';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.EVL_CPL_YN IS '평가완료여부';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.EVL_DT IS '평가일자';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.EVL_OBJ_YN IS '평가대상여부';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.FNA_NFNA_DSC IS '재무비재무구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.FRQ_EVL_C IS '빈도평가코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.IFN_EVL_C IS '영향평가코드(재무)';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.IPTK_OBJ_YN IS '개선과제대상여부';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.KRK_YN IS '핵심리스크여부';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.NIFN_EVL_C IS '영향평가코드(비재무)';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.OPRK_RKP_ID IS '운영리스크리스크풀ID';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.RBF_CTEV_GRD_C IS '직전회차통제등급';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.RBF_FRQ_EVL_C IS '직전빈도평가코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.RBF_IFN_EVL_C IS '직전영향평가코드(재무)';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.RBF_NIFN_EVL_C IS '직전영향평가코드(비재무)';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.RBF_RK_EVL_GRD_C IS '직전리스크평가등급코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.RBF_RMN_RSK_GRD_C IS '직전잔여위험등급코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.REEVL_YN IS '재평가여부';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.RK_EVL_GRD_C IS '리스크평가등급코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.RMN_RSK_GRD_C IS '잔여위험등급코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RM_EVL.VLR_ENO IS '평가자개인번호';
COMMENT ON TABLE OPEOWN.TB_OR_RM_EVL IS 'RCSA_리스크평가기본';

