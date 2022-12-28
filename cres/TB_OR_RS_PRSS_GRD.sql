CREATE TABLE OPEOWN.TB_OR_RS_PRSS_GRD
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    BRC             VARCHAR2(20) NOT NULL,
    RK_EVL_GRD_C    CHAR(1),
    CTEV_GRD_C      CHAR(1),
    REM_RK_GRD_C    CHAR(1),
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

ALTER TABLE OPEOWN.TB_OR_RS_PRSS_GRD
ADD CONSTRAINT PK_OR_RS_PRSS_GRD PRIMARY KEY (GRP_ORG_C,BAS_YM,BSN_PRSS_C,BRC);

GRANT DELETE ON OPEOWN.TB_OR_RS_PRSS_GRD TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_RS_PRSS_GRD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RS_PRSS_GRD TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_RS_PRSS_GRD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RS_PRSS_GRD TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.BAS_YM IS '���س��';
COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.BRC IS '�繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.BSN_PRSS_C IS '�������μ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.CTEV_GRD_C IS '�����򰡵���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.REM_RK_GRD_C IS '�ܿ��������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RS_PRSS_GRD.RK_EVL_GRD_C IS '����ũ�򰡵���ڵ�';
