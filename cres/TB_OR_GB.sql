CREATE TABLE OPEOWN.TB_OR_GB_ACCAM
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    UPLOAD_SQNO     NUMBER(5) NOT NULL,
    ACC_SBJ_CNM     VARCHAR2(50) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    ACC_AM          NUMBER(21),
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

ALTER TABLE OPEOWN.TB_OR_GB_ACCAM
ADD CONSTRAINT PK_OR_GB_ACCAM PRIMARY KEY (GRP_ORG_C,BAS_YM,UPLOAD_SQNO,ACC_SBJ_CNM,SBDR_C);

GRANT DELETE ON OPEOWN.TB_OR_GB_ACCAM TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_ACCAM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_ACCAM TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_ACCAM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_ACCAM TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_ACCAM.ACC_AM IS '계정금액';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_ACCAM.ACC_SBJ_CNM IS '계정과목코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_ACCAM.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_ACCAM.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_ACCAM.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_ACCAM.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_ACCAM.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_ACCAM.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_ACCAM.SBDR_C IS '자회사코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_ACCAM.UPLOAD_SQNO IS '업로드일련번호';
COMMENT ON TABLE OPEOWN.TB_OR_GB_ACCAM IS '측정월_계정금액';

CREATE TABLE OPEOWN.TB_OR_GB_BIC
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    LV1_BIZ_IX_C    CHAR(2) NOT NULL,
    CASE_DSC        CHAR(2) NOT NULL,
    MSR_AM          NUMBER(21),
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

ALTER TABLE OPEOWN.TB_OR_GB_BIC
ADD CONSTRAINT PK_OR_GB_BIC PRIMARY KEY (GRP_ORG_C,BAS_YM,SBDR_C,LV1_BIZ_IX_C,CASE_DSC);

GRANT DELETE ON OPEOWN.TB_OR_GB_BIC TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_BIC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_BIC TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_BIC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_BIC TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_BIC.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BIC.CASE_DSC IS '케이스구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BIC.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BIC.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BIC.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BIC.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BIC.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BIC.LV1_BIZ_IX_C IS '1레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BIC.MSR_AM IS '산출금액';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BIC.SBDR_C IS '자회사코드';
COMMENT ON TABLE OPEOWN.TB_OR_GB_BIC IS '측정월_영업지수요소산출';

CREATE TABLE OPEOWN.TB_OR_GB_BICACC
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    LV1_BIZ_IX_C    CHAR(2) NOT NULL,
    LV2_BIZ_IX_C    CHAR(4) NOT NULL,
    MSR_YY          CHAR(4) NOT NULL,
    ACC_SBJ_CNM     VARCHAR2(50) NOT NULL,
    CASE_DSC        CHAR(2) NOT NULL,
    MSR_AM          NUMBER(21),
    FIR_INP_DTM     DATE,
    FIR_INPMN_ENO   VARCHAR2(10),
    LSCHG_DTM       DATE,
    LS_WKR_ENO      VARCHAR2(10)
)
TABLESPACE TS_OPE_DT001_08K
STORAGE
(
    INITIAL 8M
    NEXT 4M
);

ALTER TABLE OPEOWN.TB_OR_GB_BICACC
ADD CONSTRAINT PK_OR_GB_BICACC PRIMARY KEY (GRP_ORG_C,BAS_YM,SBDR_C,LV1_BIZ_IX_C,LV2_BIZ_IX_C,MSR_YY,ACC_SBJ_CNM,CASE_DSC);

GRANT DELETE ON OPEOWN.TB_OR_GB_BICACC TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_BICACC TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_BICACC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_BICACC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_BICACC TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.ACC_SBJ_CNM IS '계정과목코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.CASE_DSC IS '케이스구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.LV1_BIZ_IX_C IS '1레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.LV2_BIZ_IX_C IS '2레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.MSR_AM IS '산출금액';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.MSR_YY IS '산출년';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICACC.SBDR_C IS '자회사코드';
COMMENT ON TABLE OPEOWN.TB_OR_GB_BICACC IS '측정월_영업지수요소산출계정별';

CREATE TABLE OPEOWN.TB_OR_GB_BICDET
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    LV1_BIZ_IX_C    CHAR(2) NOT NULL,
    LV2_BIZ_IX_C    CHAR(4) NOT NULL,
    MSR_YY          CHAR(4) NOT NULL,
    CASE_DSC        CHAR(2) NOT NULL,
    MSR_AM          NUMBER(21),
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

ALTER TABLE OPEOWN.TB_OR_GB_BICDET
ADD CONSTRAINT PK_OR_GB_BICDET PRIMARY KEY (GRP_ORG_C,BAS_YM,SBDR_C,LV1_BIZ_IX_C,LV2_BIZ_IX_C,MSR_YY,CASE_DSC);

GRANT INSERT ON OPEOWN.TB_OR_GB_BICDET TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_BICDET TO RL_OPE_ALL;
GRANT DELETE ON OPEOWN.TB_OR_GB_BICDET TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_BICDET TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_BICDET TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.CASE_DSC IS '케이스구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.LV1_BIZ_IX_C IS '1레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.LV2_BIZ_IX_C IS '2레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.MSR_AM IS '산출금액';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.MSR_YY IS '산출년';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_BICDET.SBDR_C IS '자회사코드';
COMMENT ON TABLE OPEOWN.TB_OR_GB_BICDET IS '측정월_영업지수요소산출상세';

CREATE TABLE OPEOWN.TB_OR_GB_FNASTM_DTL
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    UPLOAD_SQNO     NUMBER(5) NOT NULL,
    ACC_SBJ_CNM     VARCHAR2(50) NOT NULL,
    SACCT_SQNO      NUMBER(10) NOT NULL,
    ACC_TPC         CHAR(2),
    ACC_SBJNM       VARCHAR2(100),
    LVL_NO          NUMBER(2),
    UP_ACC_SBJ_CNM  VARCHAR2(50),
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

ALTER TABLE OPEOWN.TB_OR_GB_FNASTM_DTL
ADD CONSTRAINT PK_OR_GB_FNASTM_DTL PRIMARY KEY (GRP_ORG_C,BAS_YM,UPLOAD_SQNO,ACC_SBJ_CNM);

GRANT DELETE ON OPEOWN.TB_OR_GB_FNASTM_DTL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_FNASTM_DTL TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_FNASTM_DTL TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_FNASTM_DTL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_FNASTM_DTL TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.ACC_SBJNM IS '계정과목명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.ACC_SBJ_CNM IS '계정과목코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.ACC_TPC IS '계정유형코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.LVL_NO IS '레벨번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.SACCT_SQNO IS '가계정일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.UPLOAD_SQNO IS '업로드일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_DTL.UP_ACC_SBJ_CNM IS '상위계정과목코드명';
COMMENT ON TABLE OPEOWN.TB_OR_GB_FNASTM_DTL IS '측정월_재무제표상세';

CREATE TABLE OPEOWN.TB_OR_GB_FNASTM_UPDTL
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    BAS_YM              CHAR(6) NOT NULL,
    UPLOAD_SQNO         NUMBER(5) NOT NULL,
    SACCT_SQNO          NUMBER(10) NOT NULL,
    HD_INP_DSC          CHAR(2),
    ACC_TPC             CHAR(2),
    ULD_ACC_CNM         VARCHAR2(50),
    ULD_ACC_NM          VARCHAR2(100),
    LVL_NO              NUMBER(2),
    FILL_YN_DSC         CHAR(2),
    UP_ULD_ACC_CNM      VARCHAR2(50),
    UP_ULD_ACC_NM       VARCHAR2(100),
    C1_BIZ_IX_LV1_NM    VARCHAR2(30),
    C1_BIZ_IX_LV2_NM    VARCHAR2(30),
    C2_BIZ_IX_LV1_NM    VARCHAR2(30),
    C2_BIZ_IX_LV2_NM    VARCHAR2(30),
    MPP_EXP_RSN_DSC     CHAR(2),
    HD_MNG_TGT_YN       CHAR(1),
    NOTE_CNTN           VARCHAR2(4000),
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

ALTER TABLE OPEOWN.TB_OR_GB_FNASTM_UPDTL
ADD CONSTRAINT PK_OR_GB_FNASTM_UPDTL PRIMARY KEY (GRP_ORG_C,BAS_YM,UPLOAD_SQNO,SACCT_SQNO);

GRANT INSERT ON OPEOWN.TB_OR_GB_FNASTM_UPDTL TO RL_OPE_ALL;
GRANT DELETE ON OPEOWN.TB_OR_GB_FNASTM_UPDTL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_FNASTM_UPDTL TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_FNASTM_UPDTL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_FNASTM_UPDTL TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.ACC_TPC IS '계정유형코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.C1_BIZ_IX_LV1_NM IS '케이스1영업지수매핑1레벨명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.C1_BIZ_IX_LV2_NM IS '케이스1영업지수매핑2레벨명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.C2_BIZ_IX_LV1_NM IS '케이스2영업지수매핑1레벨명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.C2_BIZ_IX_LV2_NM IS '케이스2영업지수매핑2레벨명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.FILL_YN_DSC IS '기표여부구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.HD_INP_DSC IS '수기입력구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.HD_MNG_TGT_YN IS '수기관리대상여부';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.LVL_NO IS '레벨번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.MPP_EXP_RSN_DSC IS '매핑제외사유구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.NOTE_CNTN IS '비고';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.SACCT_SQNO IS '가계정일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.ULD_ACC_CNM IS '계정과목코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.ULD_ACC_NM IS '계정과목명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.UPLOAD_SQNO IS '업로드일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.UP_ULD_ACC_CNM IS '상위업로드계정코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPDTL.UP_ULD_ACC_NM IS '상위업로드계정명';
COMMENT ON TABLE OPEOWN.TB_OR_GB_FNASTM_UPDTL IS '측정월_재무제표업로드상세';

CREATE TABLE OPEOWN.TB_OR_GB_FNASTM_UPLOAD
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    UPLOAD_SQNO     NUMBER(5) NOT NULL,
    APFLNM          VARCHAR2(100),
    RG_DT           CHAR(8),
    RG_ENO          VARCHAR2(10),
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

ALTER TABLE OPEOWN.TB_OR_GB_FNASTM_UPLOAD
ADD CONSTRAINT PK_OR_GB_FNASTM_UPLOAD PRIMARY KEY (GRP_ORG_C,BAS_YM,UPLOAD_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_GB_FNASTM_UPLOAD TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_FNASTM_UPLOAD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_FNASTM_UPLOAD TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_FNASTM_UPLOAD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_FNASTM_UPLOAD TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.APFLNM IS '첨부파일명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.RG_DT IS '등록일자';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.RG_ENO IS '등록개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.UPLOAD_SQNO IS '업로드일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.VLD_ED_DT IS '유효종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.VLD_ST_DT IS '유효시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_FNASTM_UPLOAD.VLD_YN IS '유효여부';
COMMENT ON TABLE OPEOWN.TB_OR_GB_FNASTM_UPLOAD IS '측정월_재무제표업로드';

CREATE TABLE OPEOWN.TB_OR_GB_LCDET
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    LSHP_AMNNO      NUMBER(9) NOT NULL,
    LSSAM_SQNO      NUMBER(5) NOT NULL,
    ACC_DSC         CHAR(1),
    LSOC_AM         NUMBER(18),
    LSS_ACG_ACCC    VARCHAR2(20),
    RVPY_DSC        CHAR(1),
    ACG_PRC_DT      CHAR(8) NOT NULL,
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

ALTER TABLE OPEOWN.TB_OR_GB_LCDET
ADD CONSTRAINT PK_OR_GB_LCDET PRIMARY KEY (GRP_ORG_C,BAS_YM,SBDR_C,LSHP_AMNNO,LSSAM_SQNO);

GRANT INSERT ON OPEOWN.TB_OR_GB_LCDET TO RL_OPE_ALL;
GRANT DELETE ON OPEOWN.TB_OR_GB_LCDET TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_LCDET TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_LCDET TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_LCDET TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.ACC_DSC IS '계정구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.ACG_PRC_DT IS '회계처리일자';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.LSHP_AMNNO IS '손실사건관리번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.LSOC_AM IS '손실발생금액';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.LSSAM_SQNO IS '손실금액일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.LSS_ACG_ACCC IS '손실회계계정코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.RVPY_DSC IS '입금지급구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCDET.SBDR_C IS '자회사코드';
COMMENT ON TABLE OPEOWN.TB_OR_GB_LCDET IS '측정월_LC산출손실내역상세';

CREATE TABLE OPEOWN.TB_OR_GB_LCSUMM
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    LSHP_AMNNO      NUMBER(9) NOT NULL,
    OCU_BRC         VARCHAR2(20),
    LSHP_STSC       CHAR(2),
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

ALTER TABLE OPEOWN.TB_OR_GB_LCSUMM
ADD CONSTRAINT PK_OR_GB_LCSUMM PRIMARY KEY (GRP_ORG_C,BAS_YM,SBDR_C,LSHP_AMNNO);

GRANT DELETE ON OPEOWN.TB_OR_GB_LCSUMM TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_LCSUMM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_LCSUMM TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_LCSUMM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_LCSUMM TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCSUMM.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCSUMM.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCSUMM.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCSUMM.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCSUMM.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCSUMM.LSHP_AMNNO IS '손실사건관리번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCSUMM.LSHP_STSC IS '손실사건상태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCSUMM.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCSUMM.OCU_BRC IS '발생사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_LCSUMM.SBDR_C IS '자회사코드';
COMMENT ON TABLE OPEOWN.TB_OR_GB_LCSUMM IS '측정월_LC산출손실내역요약';

CREATE TABLE OPEOWN.TB_OR_GB_MSRACC
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    ACC_SBJ_CNM     VARCHAR2(50) NOT NULL,
    ACC_SBJNM       VARCHAR2(100),
    ACC_TPC         CHAR(2),
    UP_ACC_SBJ_CNM  VARCHAR2(50),
    LVL_NO          NUMBER(2),
    C1_LV2_BIZ_IX_C CHAR(4),
    C2_LV2_BIZ_IX_C CHAR(4),
    FILL_YN_DSC     CHAR(2),
    MPP_BAS_CNTN    VARCHAR2(4000),
    REV_OPN_CNTN    VARCHAR2(4000),
    NOTE_CNTN       VARCHAR2(4000),
    SORT_SQ         NUMBER(5),
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

ALTER TABLE OPEOWN.TB_OR_GB_MSRACC
ADD CONSTRAINT PK_OR_GB_MSRACC PRIMARY KEY (GRP_ORG_C,ACC_SBJ_CNM);

GRANT DELETE ON OPEOWN.TB_OR_GB_MSRACC TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_MSRACC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRACC TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_MSRACC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRACC TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.ACC_SBJNM IS '계정과목명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.ACC_SBJ_CNM IS '계정과목코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.ACC_TPC IS '계정유형코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.C1_LV2_BIZ_IX_C IS '케이스1_2레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.C2_LV2_BIZ_IX_C IS '케이스2_2레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.FILL_YN_DSC IS '기표여부구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.LVL_NO IS '레벨번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.MPP_BAS_CNTN IS '매핑근거';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.NOTE_CNTN IS '비고';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.REV_OPN_CNTN IS '검토의견';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.SORT_SQ IS '정렬순서';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.UP_ACC_SBJ_CNM IS '상위계정과목코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.VLD_ED_DT IS '유효종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.VLD_ST_DT IS '유효시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC.VLD_YN IS '유효여부';
COMMENT ON TABLE OPEOWN.TB_OR_GB_MSRACC IS '측정월_측정계정기본';

CREATE TABLE OPEOWN.TB_OR_GB_MSRACC_HIST
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    ACC_SBJ_CNM     VARCHAR2(50) NOT NULL,
    HIST_SQNO       NUMBER(7) NOT NULL,
    ACC_SBJNM       VARCHAR2(100),
    ACC_TPC         CHAR(2),
    UP_ACC_SBJ_CNM  VARCHAR2(50),
    LVL_NO          NUMBER(2),
    C1_LV2_BIZ_IX_C CHAR(4),
    C2_LV2_BIZ_IX_C CHAR(4),
    FILL_YN_DSC     CHAR(2),
    MPP_BAS_CNTN    VARCHAR2(4000),
    REV_OPN_CNTN    VARCHAR2(4000),
    NOTE_CNTN       VARCHAR2(4000),
    SORT_SQ         NUMBER(5),
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

ALTER TABLE OPEOWN.TB_OR_GB_MSRACC_HIST
ADD CONSTRAINT PK_OR_GB_MSRACC_HIST PRIMARY KEY (GRP_ORG_C,ACC_SBJ_CNM,HIST_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_GB_MSRACC_HIST TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_MSRACC_HIST TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRACC_HIST TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_MSRACC_HIST TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRACC_HIST TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.ACC_SBJNM IS '계정과목명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.ACC_SBJ_CNM IS '계정과목코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.ACC_TPC IS '계정유형코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.C1_LV2_BIZ_IX_C IS '케이스1_2레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.C2_LV2_BIZ_IX_C IS '케이스2_2레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.FILL_YN_DSC IS '기표여부구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.HIST_SQNO IS '이력일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.LVL_NO IS '레벨번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.MPP_BAS_CNTN IS '매핑근거';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.NOTE_CNTN IS '비고';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.REV_OPN_CNTN IS '검토의견';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.SORT_SQ IS '정렬순서';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.UP_ACC_SBJ_CNM IS '상위계정과목코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.VLD_ED_DT IS '유효종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.VLD_ST_DT IS '유효시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_HIST.VLD_YN IS '유효여부';
COMMENT ON TABLE OPEOWN.TB_OR_GB_MSRACC_HIST IS '측정월_측정계정변경이력';

CREATE TABLE OPEOWN.TB_OR_GB_MSRACC_TMP
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    ACC_SBJ_CNM     VARCHAR2(50) NOT NULL,
    ACC_SBJNM       VARCHAR2(100),
    ACC_TPC         CHAR(2),
    UP_ACC_SBJ_CNM  VARCHAR2(50),
    LVL_NO          NUMBER(2),
    C1_LV2_BIZ_IX_C CHAR(4),
    C2_LV2_BIZ_IX_C CHAR(4),
    FILL_YN_DSC     CHAR(2),
    MPP_BAS_CNTN    VARCHAR2(4000),
    REV_OPN_CNTN    VARCHAR2(4000),
    NOTE_CNTN       VARCHAR2(4000),
    SORT_SQ         NUMBER(5),
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

ALTER TABLE OPEOWN.TB_OR_GB_MSRACC_TMP
ADD CONSTRAINT PK_OR_GB_MSRACC_TMP PRIMARY KEY (GRP_ORG_C,ACC_SBJ_CNM);

GRANT INSERT ON OPEOWN.TB_OR_GB_MSRACC_TMP TO RL_OPE_ALL;
GRANT DELETE ON OPEOWN.TB_OR_GB_MSRACC_TMP TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRACC_TMP TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_MSRACC_TMP TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRACC_TMP TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.ACC_SBJNM IS '계정과목명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.ACC_SBJ_CNM IS '계정과목코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.ACC_TPC IS '계정유형코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.C1_LV2_BIZ_IX_C IS '케이스1_2레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.C2_LV2_BIZ_IX_C IS '케이스2_2레벨영업지수코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.FILL_YN_DSC IS '기표여부구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.LVL_NO IS '레벨번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.MPP_BAS_CNTN IS '매핑근거';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.NOTE_CNTN IS '비고';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.REV_OPN_CNTN IS '검토의견';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.SORT_SQ IS '정렬순서';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.UP_ACC_SBJ_CNM IS '상위계정과목코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.VLD_ED_DT IS '유효종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.VLD_ST_DT IS '유효시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRACC_TMP.VLD_YN IS '유효여부';
COMMENT ON TABLE OPEOWN.TB_OR_GB_MSRACC_TMP IS '측정월_측정계정임시';

CREATE TABLE OPEOWN.TB_OR_GB_MSRELM
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    MSR_ELM_DSCD    CHAR(4) NOT NULL,
    MSR_AM          NUMBER(29,13),
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

ALTER TABLE OPEOWN.TB_OR_GB_MSRELM
ADD CONSTRAINT PK_OR_GB_MSRELM PRIMARY KEY (GRP_ORG_C,BAS_YM,SBDR_C,MSR_ELM_DSCD);

GRANT DELETE ON OPEOWN.TB_OR_GB_MSRELM TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_MSRELM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRELM TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_MSRELM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRELM TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRELM.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRELM.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRELM.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRELM.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRELM.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRELM.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRELM.MSR_AM IS '산출금액';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRELM.MSR_ELM_DSCD IS '산출구성요소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRELM.SBDR_C IS '자회사코드';
COMMENT ON TABLE OPEOWN.TB_OR_GB_MSRELM IS '측정월_구성요소별산출';

CREATE TABLE OPEOWN.TB_OR_GB_MSRRZT
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    UPLOAD_SQNO     NUMBER(5),
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

ALTER TABLE OPEOWN.TB_OR_GB_MSRRZT
ADD CONSTRAINT PK_OR_GB_MSRRZT PRIMARY KEY (GRP_ORG_C,BAS_YM);

GRANT INSERT ON OPEOWN.TB_OR_GB_MSRRZT TO RL_OPE_ALL;
GRANT DELETE ON OPEOWN.TB_OR_GB_MSRRZT TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRRZT TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_MSRRZT TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRRZT TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT.UPLOAD_SQNO IS '업로드일련번호';
COMMENT ON TABLE OPEOWN.TB_OR_GB_MSRRZT IS '측정월_측정결과';

CREATE TABLE OPEOWN.TB_OR_GB_MSRRZT_SUB
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
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

ALTER TABLE OPEOWN.TB_OR_GB_MSRRZT_SUB
ADD CONSTRAINT PK_OR_GB_MSRRZT_SUB PRIMARY KEY (GRP_ORG_C,BAS_YM,SBDR_C);

GRANT DELETE ON OPEOWN.TB_OR_GB_MSRRZT_SUB TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_MSRRZT_SUB TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRRZT_SUB TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_MSRRZT_SUB TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_MSRRZT_SUB TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT_SUB.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT_SUB.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT_SUB.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT_SUB.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT_SUB.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT_SUB.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_MSRRZT_SUB.SBDR_C IS '자회사코드';
COMMENT ON TABLE OPEOWN.TB_OR_GB_MSRRZT_SUB IS '측정월_측정결과개별';

CREATE TABLE OPEOWN.TB_OR_GB_TMP_ACC
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    ULD_ACC_CNM     VARCHAR2(50) NOT NULL,
    ULD_ACC_NM      VARCHAR2(100) NOT NULL,
    UP_ULD_ACC_CNM  VARCHAR2(50) NOT NULL,
    UP_ULD_ACC_NM   VARCHAR2(100) NOT NULL,
    TMP_ACC_SQNO    NUMBER(13),
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

ALTER TABLE OPEOWN.TB_OR_GB_TMP_ACC
ADD CONSTRAINT PK_OR_GB_TMP_ACC PRIMARY KEY (GRP_ORG_C,ULD_ACC_CNM,ULD_ACC_NM,UP_ULD_ACC_CNM,UP_ULD_ACC_NM);

GRANT DELETE ON OPEOWN.TB_OR_GB_TMP_ACC TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_TMP_ACC TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_TMP_ACC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_TMP_ACC TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_TMP_ACC TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_TMP_ACC.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_TMP_ACC.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_TMP_ACC.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_TMP_ACC.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_TMP_ACC.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_TMP_ACC.TMP_ACC_SQNO IS '임시계정일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_TMP_ACC.ULD_ACC_CNM IS '업로드계정코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_TMP_ACC.ULD_ACC_NM IS '업로드계정명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_TMP_ACC.UP_ULD_ACC_CNM IS '상위업로드계정코드명';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_TMP_ACC.UP_ULD_ACC_NM IS '상위업로드계정명';
COMMENT ON TABLE OPEOWN.TB_OR_GB_TMP_ACC IS '측정월_임시계정';

CREATE TABLE OPEOWN.TB_OR_GB_UP_ACCAM
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    UPLOAD_SQNO     NUMBER(5) NOT NULL,
    SACCT_SQNO      NUMBER(10) NOT NULL,
    SBDR_C          CHAR(2) NOT NULL,
    ACC_AM          NUMBER(21),
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

ALTER TABLE OPEOWN.TB_OR_GB_UP_ACCAM
ADD CONSTRAINT PK_OR_GB_UP_ACCAM PRIMARY KEY (GRP_ORG_C,BAS_YM,UPLOAD_SQNO,SACCT_SQNO,SBDR_C);

GRANT DELETE ON OPEOWN.TB_OR_GB_UP_ACCAM TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GB_UP_ACCAM TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GB_UP_ACCAM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_UP_ACCAM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GB_UP_ACCAM TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GB_UP_ACCAM.ACC_AM IS '계정금액';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_UP_ACCAM.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_UP_ACCAM.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_UP_ACCAM.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_UP_ACCAM.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_UP_ACCAM.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_UP_ACCAM.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_UP_ACCAM.SACCT_SQNO IS '가계정일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_UP_ACCAM.SBDR_C IS '자회사코드';
COMMENT ON COLUMN OPEOWN.TB_OR_GB_UP_ACCAM.UPLOAD_SQNO IS '업로드일련번호';
COMMENT ON TABLE OPEOWN.TB_OR_GB_UP_ACCAM IS '측정월_업로드계정금액';

