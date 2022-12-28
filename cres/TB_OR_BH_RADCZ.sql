CREATE TABLE OPEOWN.TB_OR_BH_RADCZ
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    RSK_C           CHAR(6) NOT NULL,
    DCZ_SQNO        NUMBER(7) NOT NULL,
    DCZ_DT          CHAR(8),
    DCZMN_ENO       VARCHAR2(10),
    RA_DCZ_STSC     CHAR(2),
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

ALTER TABLE OPEOWN.TB_OR_BH_RADCZ
ADD CONSTRAINT PK_OR_BH_RADCZ PRIMARY KEY (GRP_ORG_C,BAS_YM,RSK_C,DCZ_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_BH_RADCZ TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_BH_RADCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_RADCZ TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_BH_RADCZ TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_BH_RADCZ TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.BAS_YM IS '���س��';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.DCZMN_ENO IS '���簳�ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.DCZ_DT IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.DCZ_OBJR_ENO IS '�������ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.DCZ_RMK_C IS '�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.DCZ_SQNO IS '�����Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.RA_DCZ_STSC IS 'RA��������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.RSK_C IS '�����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_BH_RADCZ.RTN_CNTN IS '�ݷ�����';
COMMENT ON TABLE OPEOWN.TB_OR_BH_RADCZ IS 'BCP_RA���系��';
