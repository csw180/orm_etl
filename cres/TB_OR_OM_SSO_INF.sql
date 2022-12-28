CREATE TABLE OPEOWN.TB_OR_OM_SSO_INF
(
    SSO_ENO         VARCHAR2(64) NOT NULL,
    SSO_PWIZE_PW    VARCHAR2(64),
    SSO_USRNM       VARCHAR2(64),
    SSO_BRC         VARCHAR2(20),
    ACCESS_YN       CHAR(1),
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

ALTER TABLE OPEOWN.TB_OR_OM_SSO_INF
ADD CONSTRAINT PK_OR_OM_SSO_INF PRIMARY KEY (SSO_ENO);

GRANT DELETE ON OPEOWN.TB_OR_OM_SSO_INF TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OM_SSO_INF TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_SSO_INF TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OM_SSO_INF TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_SSO_INF TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.ACCESS_YN IS '�����������';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.SSO_BRC IS '���շα��λ繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.SSO_ENO IS '���շα��λ��';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.SSO_PWIZE_PW IS '���շα��κ�й�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_SSO_INF.SSO_USRNM IS '���շα��λ���ڸ�';
COMMENT ON TABLE OPEOWN.TB_OR_OM_SSO_INF IS '����_���շα��������⺻';
