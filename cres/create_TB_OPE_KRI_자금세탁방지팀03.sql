DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������03;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������03
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,CUST_NTNT                                VARCHAR2(2)
  ,TR_AMT                                   NUMBER(20,4)  -- �ŷ��ݾ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������03               IS 'OPE_KRI_�ڱݼ�Ź������03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������03.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������03.CUST_NTNT    IS '������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������03.TR_AMT       IS '�ŷ��ݾ�';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������03 TO RL_OPE_SEL;

EXIT
