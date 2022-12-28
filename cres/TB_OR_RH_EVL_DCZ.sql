CREATE TABLE OPEOWN.TB_OR_RH_EVL_DCZ
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    OPRK_RKP_ID     VARCHAR2(10) NOT NULL,
    BRC             VARCHAR2(20) NOT NULL,
    DCZ_SQNO        NUMBER(7) NOT NULL,
    DCZ_DT          CHAR(8),
    DCZMN_ENO       VARCHAR2(10),
    RK_EVL_DCZ_STSC CHAR(2),
    RTN_CNTN        VARCHAR2(500),
    DCZ_OBJR_ENO    VARCHAR2(10),
    DCZ_RMK_C       CHAR(2),
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

ALTER TABLE OPEOWN.TB_OR_RH_EVL_DCZ
ADD CONSTRAINT PK_OR_RH_EVL_DCZ PRIMARY KEY (GRP_ORG_C,BAS_YM,OPRK_RKP_ID,BRC,DCZ_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_RH_EVL_DCZ TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_RH_EVL_DCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RH_EVL_DCZ TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_RH_EVL_DCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_RH_EVL_DCZ TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.BAS_YM IS '���س��';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.BRC IS '�繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.DCZMN_ENO IS '���簳�ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.DCZ_DT IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.DCZ_OBJR_ENO IS '�������ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.DCZ_RMK_C IS '�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.DCZ_SQNO IS '�����Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.OPRK_RKP_ID IS '�����ũ����ũǮID';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.RK_EVL_DCZ_STSC IS '����ũ�򰡰�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_RH_EVL_DCZ.RTN_CNTN IS '�ݷ�����';
COMMENT ON TABLE OPEOWN.TB_OR_RH_EVL_DCZ IS 'RCSA_����ũ�򰡰��系��';
