DROP TABLE OPEOWN.TB_OPE_KRI_��������������07;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������07
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)   --  ���¹�ȣ
  ,CUST_NO                                 NUMBER(9)
  ,TR_AMT                                  NUMBER(18,2)  -- �ŷ��ݾ�
  ,DPS_TR_STCD                             VARCHAR2(1)   -- 2:'����' 3:'���'
  ,OGTR_DT                                 VARCHAR2(8)   -- �Աݰŷ�����
  ,TR_DT                                   VARCHAR2(8)   -- ��Ұŷ�����
  ,USR_NO                                  VARCHAR2(10)  -- �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������07               IS 'OPE_KRI_��������������07';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������07.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������07.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������07.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������07.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������07.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������07.TR_AMT       IS '�ŷ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������07.DPS_TR_STCD  IS '���Űŷ������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������07.OGTR_DT      IS '���ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������07.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������07.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������07 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������07 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������07 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������07 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������07 TO RL_OPE_SEL;

EXIT
