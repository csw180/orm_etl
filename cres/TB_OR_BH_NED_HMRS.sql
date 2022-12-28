CREATE TABLE OPEOWN.TB_OR_BH_NED_HMRS
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    DSQNO           NUMBER(5) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    BRC             VARCHAR2(20) NOT NULL,
    RCVR_HMRS_DSC   CHAR(2),
    EMPNM           VARCHAR2(10),
    PZCNM           VARCHAR2(10),
    CHRG_BSNNM      VARCHAR2(50),
    MPNO            VARCHAR2(14),
    EMAIL_ADR       VARCHAR2(60),
    OHSE_ADR        VARCHAR2(200),
    OHSE_TELNO      VARCHAR2(14),
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

ALTER TABLE OPEOWN.TB_OR_BH_NED_HMRS
ADD CONSTRAINT PK_OR_BH_NED_HMRS PRIMARY KEY (GRP_ORG_C,BAS_YM,DSQNO,BSN_PRSS_C,BRC);

GRANT DELETE ON OPEOWN.TB_OR_BH_NED_HMRS TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BH_NED_HMRS TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_NED_HMRS TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BH_NED_HMRS TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_NED_HMRS TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.BRC IS '사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.BSN_PRSS_C IS '업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.CHRG_BSNNM IS '담당업무명';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.DSQNO IS '상세일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.EMAIL_ADR IS '이메일주소';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.EMPNM IS '성명';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.MPNO IS '휴대전화번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.OHSE_ADR IS '자택주소';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.OHSE_TELNO IS '자택전화번호';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.PZCNM IS '직급명';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_NED_HMRS.RCVR_HMRS_DSC IS '복구인력구분코드';
COMMENT ON TABLE OPEOWN.TB_OR_BH_NED_HMRS IS 'BCP_필요요구인력내역';

