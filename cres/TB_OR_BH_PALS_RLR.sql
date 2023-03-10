CREATE TABLE OPEOWN.TB_OR_BH_PALS_RLR
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    DSQNO           NUMBER(5) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    BRC             VARCHAR2(20) NOT NULL,
    CONM            VARCHAR2(50),
    DEPTNM          VARCHAR2(60),
    CHRG_EMPNM      VARCHAR2(50),
    PZCNM           VARCHAR2(50),
    CHRG_BSNNM      VARCHAR2(50),
    EMAIL_ADR       VARCHAR2(60),
    MPNO            VARCHAR2(14),
    OFFC_TELNO      VARCHAR2(14),
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

ALTER TABLE OPEOWN.TB_OR_BH_PALS_RLR
ADD CONSTRAINT PK_OR_BH_PALS_RLR PRIMARY KEY (GRP_ORG_C,BAS_YM,DSQNO,BSN_PRSS_C,BRC);

GRANT DELETE ON OPEOWN.TB_OR_BH_PALS_RLR TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BH_PALS_RLR TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_PALS_RLR TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BH_PALS_RLR TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_PALS_RLR TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.BRC IS '사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.BSN_PRSS_C IS '업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.CHRG_BSNNM IS '담당업무명';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.CHRG_EMPNM IS '담당직원명';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.CONM IS '업체명';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.DEPTNM IS '부서명';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.DSQNO IS '상세일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.EMAIL_ADR IS '이메일주소';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.MPNO IS '휴대전화번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.OFFC_TELNO IS '사무실전화번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PALS_RLR.PZCNM IS '직급명';
COMMENT ON TABLE OPEOWN.TB_OR_BH_PALS_RLR IS 'BCP_이해관계자내역';

