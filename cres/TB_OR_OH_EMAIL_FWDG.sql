CREATE TABLE OPEOWN.TB_OR_OH_EMAIL_FWDG
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    EMAIL_SQNO      NUMBER(13) NOT NULL,
    EMAIL_DSC       CHAR(4),
    SNDMN_ENO       VARCHAR2(10),
    EMAIL_TINM      VARCHAR2(200),
    ETR_EMAIL_CNTN  VARCHAR2(4000),
    FWDG_DTM        CHAR(14),
    FWDG_YN         CHAR(1),
    BTWK_RZT_C      CHAR(1),
    WK_ST_DTM       CHAR(14),
    WK_ED_DTM       CHAR(14),
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

ALTER TABLE OPEOWN.TB_OR_OH_EMAIL_FWDG
ADD CONSTRAINT PK_OR_OH_EMAIL_FWDG PRIMARY KEY (GRP_ORG_C,EMAIL_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_OH_EMAIL_FWDG TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OH_EMAIL_FWDG TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OH_EMAIL_FWDG TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OH_EMAIL_FWDG TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OH_EMAIL_FWDG TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.BTWK_RZT_C IS '��ġ�۾�����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.EMAIL_DSC IS '�̸��ϱ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.EMAIL_SQNO IS '�̸����Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.EMAIL_TINM IS '�̸��������';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.ETR_EMAIL_CNTN IS '��Ź�̸��ϳ���';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.FWDG_DTM IS '�߼��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.FWDG_YN IS '�߼ۿ���';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.SNDMN_ENO IS '�߼��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.WK_ED_DTM IS '�۾������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_EMAIL_FWDG.WK_ST_DTM IS '�۾������Ͻ�';
COMMENT ON TABLE OPEOWN.TB_OR_OH_EMAIL_FWDG IS '����_�̸��Ϲ߼۳���';
