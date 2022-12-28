CREATE TABLE OPEOWN.TB_OR_FH_NVL
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    REP_RKI_ID      VARCHAR2(8) NOT NULL,
    REP_KRI_NVL     NUMBER(18,3),
    INPMN_ENO       VARCHAR2(10),
    INPDT           CHAR(8),
    DCZ_SQNO        NUMBER(7),
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

ALTER TABLE OPEOWN.TB_OR_FH_NVL
ADD CONSTRAINT PK_OR_FH_NVL PRIMARY KEY (GRP_ORG_C,BAS_YM,REP_RKI_ID);

GRANT DELETE ON OPEOWN.TB_OR_FH_NVL TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_FH_NVL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_FH_NVL TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_FH_NVL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_FH_NVL TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.BAS_YM IS '���س��';
COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.DCZ_SQNO IS '�����Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.INPDT IS '�Է�����';
COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.INPMN_ENO IS '�Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.REP_KRI_NVL IS '�ٽɸ���ũ��ǥ��ġ';
COMMENT ON COLUMN OPEOWN.TB_OR_FH_NVL.REP_RKI_ID IS '���Ǹ���ũ��ǥID';
COMMENT ON TABLE OPEOWN.TB_OR_FH_NVL IS '����_������';
