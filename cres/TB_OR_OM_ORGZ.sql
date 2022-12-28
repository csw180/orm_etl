CREATE TABLE OPEOWN.TB_OR_OM_ORGZ
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    BRC                 VARCHAR2(20) NOT NULL,
    BRNM                VARCHAR2(100),
    LVL_NO              NUMBER(2),
    UP_BRC              VARCHAR2(20),
    BR_LKO_YN           CHAR(1),
    RGN_C               VARCHAR2(4),
    HURSAL_BR_FORM_C    VARCHAR2(2),
    HOFC_BIZO_DSC       CHAR(2),
    ORGZ_CFC            VARCHAR2(5),
    UYN                 CHAR(1),
    LWST_ORGZ_YN        CHAR(1),
    RCSA_ORGZ_YN        CHAR(1),
    KRI_ORGZ_YN         CHAR(1),
    LSS_ORGZ_YN         CHAR(1),
    ANW_YN              CHAR(1),
    TEMGR_DCZ_YN        CHAR(1),
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

ALTER TABLE OPEOWN.TB_OR_OM_ORGZ
ADD CONSTRAINT PK_OR_OM_ORGZ PRIMARY KEY (GRP_ORG_C,BRC);

GRANT DELETE ON OPEOWN.TB_OR_OM_ORGZ TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OM_ORGZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_ORGZ TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OM_ORGZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_ORGZ TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.ANW_YN IS '�űԿ���';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.BRC IS '�繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.BRNM IS '�繫�Ҹ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.BR_LKO_YN IS '�繫����⿩��';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.HOFC_BIZO_DSC IS '���ο����������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.HURSAL_BR_FORM_C IS '�λ�޿��繫�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.KRI_ORGZ_YN IS '�ٽɸ���ũ��ǥ��������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.LSS_ORGZ_YN IS '�ս���������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.LVL_NO IS '������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.LWST_ORGZ_YN IS '��������������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.ORGZ_CFC IS '�����з��ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.RCSA_ORGZ_YN IS 'RCSA��������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.RGN_C IS '�����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.TEMGR_DCZ_YN IS '������翩��';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.UP_BRC IS '�����繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_ORGZ.UYN IS '��뿩��';
COMMENT ON TABLE OPEOWN.TB_OR_OM_ORGZ IS '����_�����⺻';
