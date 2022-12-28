CREATE TABLE OPEOWN.TB_OR_BH_PRCD_BSN
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    PRCD_BRC        VARCHAR2(20) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    BRC             VARCHAR2(20) NOT NULL,
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

ALTER TABLE OPEOWN.TB_OR_BH_PRCD_BSN
ADD CONSTRAINT PK_OR_BH_PRCD_BSN PRIMARY KEY (GRP_ORG_C,BAS_YM,PRCD_BRC,BSN_PRSS_C,BRC);

GRANT DELETE ON OPEOWN.TB_OR_BH_PRCD_BSN TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BH_PRCD_BSN TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_PRCD_BSN TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BH_PRCD_BSN TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_PRCD_BSN TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BH_PRCD_BSN.BAS_YM IS '���س��';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PRCD_BSN.BRC IS '�繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PRCD_BSN.BSN_PRSS_C IS '�������μ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PRCD_BSN.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PRCD_BSN.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PRCD_BSN.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PRCD_BSN.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PRCD_BSN.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_PRCD_BSN.PRCD_BRC IS '����繫���ڵ�';
COMMENT ON TABLE OPEOWN.TB_OR_BH_PRCD_BSN IS 'BCP_�����������';
