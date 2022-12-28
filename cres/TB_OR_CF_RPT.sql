CREATE TABLE OPEOWN.TB_OR_CF_RPT
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    BAS_YM              VARCHAR2(6) NOT NULL,
    RPT_TIT             VARCHAR2(500),
    RSLT_MNM_CPT_AMT    VARCHAR2(100),
    RSLT_SLF_CPT_RT     VARCHAR2(100),
    RSLT_IRRT_HGLM      CHAR(1),
    RSLT_LN_LMT         CHAR(1),
    RGLT_MNM_CPT_AMT    VARCHAR2(200),
    RGLT_SLF_CPT_RT     VARCHAR2(200),
    RGLT_IRRT_HGLM      VARCHAR2(200),
    RGLT_LN_LMT_AMT     VARCHAR2(200),
    LSS_OCC_CNT         VARCHAR2(50),
    LSS_OCC_AM          NUMBER(21,4),
    RCSA_PRSS_CNT       VARCHAR2(200),
    RCSA_RKP_CNT        NUMBER(7),
    RCSA_EVL_CNT        NUMBER(7),
    KRI_RED_CNT         NUMBER(7),
    KRI_YELLOW_CNT      NUMBER(7),
    KRI_GREEN_CNT       NUMBER(7),
    BCP_CNTN            VARCHAR2(2000),
    SNR_CNTN            VARCHAR2(2000),
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
)
NOLOGGING;

ALTER TABLE OPEOWN.TB_OR_CF_RPT
ADD CONSTRAINT PK_OR_CF_ADM_RPT PRIMARY KEY (GRP_ORG_C,BAS_YM);

GRANT DELETE ON OPEOWN.TB_OR_CF_RPT TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_CF_RPT TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_CF_RPT TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_CF_RPT TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_CF_RPT TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.BAS_YM IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.BCP_CNTN IS 'BCP���ó���';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.KRI_GREEN_CNT IS 'KRI_GREEN�Ǽ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.KRI_RED_CNT IS 'KRI_RED�Ǽ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.KRI_YELLOW_CNT IS 'KRI_YELLOW�Ǽ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.LSS_OCC_AM IS '�սǻ��_�߻��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.LSS_OCC_CNT IS '�սǻ��_�߻��Ǽ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RCSA_EVL_CNT IS 'RCSA_�򰡰Ǽ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RCSA_PRSS_CNT IS 'RCSA_��ü���μ�����';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RCSA_RKP_CNT IS 'RCSA_��ü ��';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RGLT_IRRT_HGLM IS '��������_����������';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RGLT_LN_LMT_AMT IS '��������_1�δ�����ѵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RGLT_MNM_CPT_AMT IS '��������_�ּ��ں���';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RGLT_SLF_CPT_RT IS '��������_�ڱ��ں�����';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RPT_TIT IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RSLT_IRRT_HGLM IS '���˰��_����������';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RSLT_LN_LMT IS '���˰��_1�δ�����ѵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RSLT_MNM_CPT_AMT IS '���˰��_�ּ��ں���';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.RSLT_SLF_CPT_RT IS '���˰��_�ڱ��ں�����';
COMMENT ON COLUMN OPEOWN.TB_OR_CF_RPT.SNR_CNTN IS '�ó������ױ�Ÿ���׳���';
COMMENT ON TABLE OPEOWN.TB_OR_CF_RPT IS '�ؿܹ���_�����ũ ������';
