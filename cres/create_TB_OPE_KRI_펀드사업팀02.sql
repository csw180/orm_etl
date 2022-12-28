DROP TABLE OPEOWN.TB_OPE_KRI_�ݵ�����02;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ݵ�����02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,NW_DT                                   VARCHAR2(8)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,RCV_DEN_YN                              VARCHAR2(1)   -- ���Űźο���
  ,RCV_DEN_DT                              VARCHAR2(8)   -- ���Űźε����
  ,TR_AMT                                  NUMBER(18,2)  -- �ŷ��ݾ�
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_�ݵ�����02                 IS 'OPE_KRI_�ݵ�����02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����02.STD_DT          IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����02.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����02.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����02.NW_DT           IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����02.ACNO            IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����02.CUST_NO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����02.RCV_DEN_YN      IS '���Űźο���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����02.RCV_DEN_DT      IS '���Űź�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����02.TR_AMT          IS '�ŷ��ݾ�';

GRANT SELECT ON TB_OPE_KRI_�ݵ�����02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ݵ�����02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ݵ�����02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ݵ�����02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ݵ�����02 TO RL_OPE_SEL;

EXIT
