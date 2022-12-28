CREATE TABLE OPEOWN.TB_OR_OH_MENU_PRSS
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    MENU_ID         VARCHAR2(20) NOT NULL,
    PGID            VARCHAR2(20) NOT NULL,
    PRSS_KDC        CHAR(2) NOT NULL,
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

ALTER TABLE OPEOWN.TB_OR_OH_MENU_PRSS
ADD CONSTRAINT PK_OR_OH_MENU_PRSS PRIMARY KEY (GRP_ORG_C,MENU_ID,PGID,PRSS_KDC);

GRANT DELETE ON OPEOWN.TB_OR_OH_MENU_PRSS TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OH_MENU_PRSS TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OH_MENU_PRSS TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OH_MENU_PRSS TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OH_MENU_PRSS TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OH_MENU_PRSS.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_MENU_PRSS.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_MENU_PRSS.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_MENU_PRSS.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_MENU_PRSS.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_MENU_PRSS.MENU_ID IS '�޴�ID';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_MENU_PRSS.PGID IS '���α׷�ID';
COMMENT ON COLUMN OPEOWN.TB_OR_OH_MENU_PRSS.PRSS_KDC IS '���μ��������ڵ�';
