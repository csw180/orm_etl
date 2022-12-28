CREATE TABLE OPEOWN.TB_OR_GA_LCDET
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    RGO_IN_DSC      CHAR(1) NOT NULL,
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

ALTER TABLE OPEOWN.TB_OR_GA_LCDET
ADD CONSTRAINT PK_OR_GA_LCDET PRIMARY KEY (GRP_ORG_C,BAS_YM,RGO_IN_DSC,SBDR_C,LSHP_AMNNO,LSSAM_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_GA_LCDET TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GA_LCDET TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_LCDET TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GA_LCDET TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_LCDET TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.ACC_DSC IS '���������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.ACG_PRC_DT IS 'ȸ��ó������';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.BAS_YM IS '���س��';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.LSHP_AMNNO IS '�սǻ�ǰ�����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.LSOC_AM IS '�սǹ߻��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.LSSAM_SQNO IS '�սǱݾ��Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.LSS_ACG_ACCC IS '�ս�ȸ������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.RGO_IN_DSC IS '�������α����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.RVPY_DSC IS '�Ա����ޱ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_LCDET.SBDR_C IS '��ȸ���ڵ�';
COMMENT ON TABLE OPEOWN.TB_OR_GA_LCDET IS '����_LC����սǳ�����';
