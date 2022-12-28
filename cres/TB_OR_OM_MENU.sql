CREATE TABLE OPEOWN.TB_OR_OM_MENU
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    MENU_ID         VARCHAR2(20) NOT NULL,
    PAGE_MNNM       VARCHAR2(100),
    UP_MENU_ID      VARCHAR2(20),
    MENU_EXPL_CNTN  VARCHAR2(255),
    DTL_MENU_URLNM  VARCHAR2(500),
    SORT_SQ_VAL     NUMBER(2),
    HPS_URLNM       VARCHAR2(500),
    BSC_MENU_YN     CHAR(1),
    HOFC_DEPT_YN    CHAR(1),
    BIZ_HOFC_YN     CHAR(1),
    BIZO_YN         CHAR(1),
    FR_DEPT_YN      CHAR(1),
    OPRK_DEPT_YN    CHAR(1),
    BCP_DEPT_YN     CHAR(1),
    VLD_YN          CHAR(1),
    VLD_ST_DT       CHAR(8),
    VLD_ED_DT       CHAR(8),
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

ALTER TABLE OPEOWN.TB_OR_OM_MENU
ADD CONSTRAINT PK_OR_OM_MENU PRIMARY KEY (GRP_ORG_C,MENU_ID);

GRANT DELETE ON OPEOWN.TB_OR_OM_MENU TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OM_MENU TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_MENU TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OM_MENU TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_MENU TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.BCP_DEPT_YN IS 'BCP�μ�����';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.BIZO_YN IS '����������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.BIZ_HOFC_YN IS '�������ο���';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.BSC_MENU_YN IS '�⺻�޴�����';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.DTL_MENU_URLNM IS '�󼼸޴�URL��';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.FR_DEPT_YN IS '�ؿܺμ�����';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.HOFC_DEPT_YN IS '���κμ�����';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.HPS_URLNM IS '����URL��';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.MENU_EXPL_CNTN IS '�޴���������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.MENU_ID IS '�޴�ID';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.OPRK_DEPT_YN IS '�����ũ�μ�����';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.PAGE_MNNM IS '�������޴���';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.SORT_SQ_VAL IS '���ļ�����';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.UP_MENU_ID IS '�����޴�ID';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.VLD_ED_DT IS '��ȿ��������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.VLD_ST_DT IS '��ȿ��������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_MENU.VLD_YN IS '��ȿ����';
COMMENT ON TABLE OPEOWN.TB_OR_OM_MENU IS '����_�޴��⺻';
