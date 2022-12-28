DROP TABLE OPEOWN.TB_OPE_KRI_��ȯ������06;

CREATE TABLE OPEOWN.TB_OPE_KRI_��ȯ������06
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,ACNO                                     VARCHAR2(12)
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,CUST_NO                                  NUMBER(9)
  ,CUST_NAME                                VARCHAR2(100)
  ,CRCD                                     VARCHAR2(3)
  ,LN_AMT                                   NUMBER(18,2)  -- ����ݾ�
  ,LN_DT                                    VARCHAR2(8)   -- ��������
  ,CMPL_DT                                  VARCHAR2(8)   -- �����ݿϷ�����
  ,USR_NO                                   VARCHAR2(10)   -- ó�������(���)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��ȯ������06               IS 'OPE_KRI_��ȯ������06';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.CUST_NAME    IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.LN_AMT       IS '����ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.LN_DT        IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.CMPL_DT      IS '�Ϸ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������06.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��ȯ������06 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��ȯ������06 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��ȯ������06 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��ȯ������06 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��ȯ������06 TO RL_OPE_SEL;

EXIT
