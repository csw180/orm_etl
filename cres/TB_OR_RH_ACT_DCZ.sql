CREATE TABLE OPEOWN.TB_OR_RH_ACT_DCZ
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    BAS_YM              CHAR(6) NOT NULL,
    BSN_PRSS_C          VARCHAR2(12) NOT NULL,
    BRC                 VARCHAR2(20) NOT NULL,
    DCZ_SQNO            NUMBER(7) NOT NULL,
    DCZMN_ENO           VARCHAR2(10),
    DCZ_DT              CHAR(8),
    RCSA_ACT_DCZ_STSC   CHAR(2),
    RTN_CNTN            VARCHAR2(500),
    DCZ_OBJR_ENO        VARCHAR2(10),
    DCZ_RMK_C           CHAR(2),
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

ALTER TABLE OPEOWN.TB_OR_RH_ACT_DCZ
ADD CONSTRAINT PK_OR_RH_ACT_DCZ PRIMARY KEY (GRP_ORG_C,BAS_YM,BSN_PRSS_C,BRC,DCZ_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_RH_ACT_DCZ TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_RH_ACT_DCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RH_ACT_DCZ TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_RH_ACT_DCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RH_ACT_DCZ TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.BAS_YM IS '기준년월';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.BRC IS '사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.BSN_PRSS_C IS '업무프로세스코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.DCZMN_ENO IS '결재자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.DCZ_DT IS '결재일자';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.DCZ_SQNO IS '결재일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.RCSA_ACT_DCZ_STSC IS '대응방안상태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_ACT_DCZ.RTN_CNTN IS '반려내용';
COMMENT ON TABLE OPEOWN.TB_OR_RH_ACT_DCZ IS 'RCSA_대응방안결재';

