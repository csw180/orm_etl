CREATE TABLE OPEOWN.TB_OR_OC_HPN
(
    GRP_ORG_C       CHAR(2) DEFAULT NULL NOT NULL,
    HPN_TPC         VARCHAR2(8) NOT NULL,
    HPN_TPNM        VARCHAR2(200),
    ENG_HPN_TPNM    VARCHAR2(200),
    LVL_NO          NUMBER(2),
    UP_HPN_TPC      VARCHAR2(8),
    HPN_TP_CNTN     VARCHAR2(800),
    ENG_HPN_TP_CNTN VARCHAR2(800),
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

ALTER TABLE OPEOWN.TB_OR_OC_HPN
ADD CONSTRAINT PK_OR_OC_HPN PRIMARY KEY (GRP_ORG_C,HPN_TPC);

GRANT DELETE ON OPEOWN.TB_OR_OC_HPN TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OC_HPN TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OC_HPN TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OC_HPN TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OC_HPN TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.ENG_HPN_TPNM IS '영문사건유형명';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.ENG_HPN_TP_CNTN IS '영문사건유형내용';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.HPN_TPC IS '사건유형코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.HPN_TPNM IS '사건유형명';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.HPN_TP_CNTN IS '사건유형내용';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.LVL_NO IS '레벨번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.UP_HPN_TPC IS '상위사건유형코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.VLD_ED_DT IS '유효종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.VLD_ST_DT IS '유효시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OC_HPN.VLD_YN IS '유효여부';
COMMENT ON TABLE OPEOWN.TB_OR_OC_HPN IS '공통_사건유형코드';

