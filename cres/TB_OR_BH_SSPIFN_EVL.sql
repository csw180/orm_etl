CREATE TABLE OPEOWN.TB_OR_BH_SSPIFN_EVL
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    BSN_PRSS_C      VARCHAR2(12) NOT NULL,
    BRC             VARCHAR2(20) NOT NULL,
    BCP_IFN_DSC     CHAR(2) NOT NULL,
    COIC_YN         CHAR(1),
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

ALTER TABLE OPEOWN.TB_OR_BH_SSPIFN_EVL
ADD CONSTRAINT PK_OR_BH_SSPIFN_EVL PRIMARY KEY (GRP_ORG_C,BAS_YM,BSN_PRSS_C,BRC,BCP_IFN_DSC);

GRANT DELETE ON OPEOWN.TB_OR_BH_SSPIFN_EVL TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BH_SSPIFN_EVL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_SSPIFN_EVL TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BH_SSPIFN_EVL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_SSPIFN_EVL TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.BAS_YM IS '���س��';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.BCP_IFN_DSC IS 'BCP���ⱸ���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.BRC IS '�繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.BSN_PRSS_C IS '�������μ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.COIC_YN IS '���ÿ���';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_SSPIFN_EVL.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON TABLE OPEOWN.TB_OR_BH_SSPIFN_EVL IS 'BCP_�����ߴܿ����򰡳���';
