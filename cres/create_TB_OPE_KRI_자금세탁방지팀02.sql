DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������02;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������02
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,CUST_NO                                 NUMBER(9)
  ,CUST_NTNT                               VARCHAR2(2)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������02               IS 'OPE_KRI_�ڱݼ�Ź������02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������02.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������02.CUST_NTNT    IS '������';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������02 TO RL_OPE_SEL;

EXIT
