CREATE TABLE OPEOWN.TB_OR_OM_BLBD
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BLBD_DSC        CHAR(1) NOT NULL,
    BLBD_SQNO       NUMBER(10) NOT NULL,
    BLBD_TINM       VARCHAR2(255),
    BLBD_CNTN       VARCHAR2(4000),
    BLBD_INQ_CN     NUMBER(7),
    BBRD_RGMN_ENO   VARCHAR2(10),
    BLBD_RG_BRC     VARCHAR2(20),
    BBRD_RG_DT      CHAR(8),
    BLTN_ST_DT      CHAR(8),
    BLTN_ED_DT      CHAR(8),
    PUP_YN          CHAR(1),
    PRY_BLTN_YN     CHAR(1),
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

ALTER TABLE OPEOWN.TB_OR_OM_BLBD
ADD CONSTRAINT PK_OR_OM_BLBD PRIMARY KEY (GRP_ORG_C,BLBD_DSC,BLBD_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_OM_BLBD TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OM_BLBD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_BLBD TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OM_BLBD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_BLBD TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BBRD_RGMN_ENO IS '�Խù�����ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BBRD_RG_DT IS '�Խù��������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_CNTN IS '�Խ��ǳ���';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_DSC IS '�Խ��Ǳ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_INQ_CN IS '�Խ�����ȸ�Ǽ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_RG_BRC IS '�Խ��ǵ�ϻ繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_SQNO IS '�Խ����Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_TINM IS '�Խ��������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLTN_ED_DT IS '�Խ���������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLTN_ST_DT IS '�Խý�������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.PRY_BLTN_YN IS '�켱�Խÿ���';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.PUP_YN IS '�˾�����';
COMMENT ON TABLE OPEOWN.TB_OR_OM_BLBD IS '����_�Խ��Ǳ⺻';
