CREATE TABLE OPEOWN.TB_OR_GA_MSRELM
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    RGO_IN_DSC      CHAR(1) NOT NULL,
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

ALTER TABLE OPEOWN.TB_OR_GA_MSRELM
ADD CONSTRAINT PK_OR_GA_MSRELM PRIMARY KEY (GRP_ORG_C,BAS_YM,RGO_IN_DSC,SBDR_C,MSR_ELM_DSCD);

GRANT DELETE ON OPEOWN.TB_OR_GA_MSRELM TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GA_MSRELM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_MSRELM TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GA_MSRELM TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_MSRELM TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GA_MSRELM.BAS_YM IS '���س��';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_MSRELM.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_MSRELM.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_MSRELM.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_MSRELM.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_MSRELM.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_MSRELM.MSR_AM IS '����ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_MSRELM.MSR_ELM_DSCD IS '���ⱸ������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_MSRELM.RGO_IN_DSC IS '�������α����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_MSRELM.SBDR_C IS '��ȸ���ڵ�';
COMMENT ON TABLE OPEOWN.TB_OR_GA_MSRELM IS '����_������Һ�����';
