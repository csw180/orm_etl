DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������09;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������09
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,CUST_NO                                  NUMBER(9)
  ,CUST_DTT                                 VARCHAR2(20)  -- ������(1:70���̻�,2:�̼�����,3:�ſ�ҷ���)
  ,TR_AMT                                   NUMBER(20,4)  --  �ŷ��ݾ�(�䱸��+���༺)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������09               IS 'OPE_KRI_�ڱݼ�Ź������09';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������09.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������09.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������09.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������09.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������09.CUST_DTT     IS '������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������09.TR_AMT       IS '�ŷ��ݾ�';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������09 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������09 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������09 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������09 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������09 TO RL_OPE_SEL;

EXIT
