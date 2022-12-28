CREATE TABLE OPEOWN.TB_OR_GA_FNASTM_DTL
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BAS_YM          CHAR(6) NOT NULL,
    UPLOAD_SQNO     NUMBER(5) NOT NULL,
    ACC_SBJ_CNM     VARCHAR2(50) NOT NULL,
    SACCT_SQNO      NUMBER(10) NOT NULL,
    ACC_TPC         CHAR(2),
    ACC_SBJNM       VARCHAR2(100),
    LVL_NO          NUMBER(2),
    UP_ACC_SBJ_CNM  VARCHAR2(50),
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

ALTER TABLE OPEOWN.TB_OR_GA_FNASTM_DTL
ADD CONSTRAINT PK_OR_GA_FNASTM_DTL PRIMARY KEY (GRP_ORG_C,BAS_YM,UPLOAD_SQNO,ACC_SBJ_CNM);

GRANT DELETE ON OPEOWN.TB_OR_GA_FNASTM_DTL TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_GA_FNASTM_DTL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_FNASTM_DTL TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_GA_FNASTM_DTL TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_GA_FNASTM_DTL TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.ACC_SBJNM IS '���������';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.ACC_SBJ_CNM IS '���������ڵ��';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.ACC_TPC IS '���������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.BAS_YM IS '���س��';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.LVL_NO IS '������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.SACCT_SQNO IS '�������Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.UPLOAD_SQNO IS '���ε��Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_GA_FNASTM_DTL.UP_ACC_SBJ_CNM IS '�������������ڵ��';
COMMENT ON TABLE OPEOWN.TB_OR_GA_FNASTM_DTL IS '����_�繫��ǥ��';
