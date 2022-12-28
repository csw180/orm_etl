DROP TABLE OPEOWN.TB_OPE_KRI_����������22;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������22
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,CLN_EXE_NO                              NUMBER(10)
  ,CLN_TR_NO                               NUMBER(10)
  ,PDCD                                    VARCHAR2(14)
  ,PRD_KR_NM                               VARCHAR2(100)  -- ��ǰ�ѱ۸�
  ,WN_TNSL_PCPL                            NUMBER(18,2)  -- ��������
  ,RDM_WN_TNSL_PCPL                        NUMBER(18,2)  -- �����Ļ�ȯ����
  ,CNCL_YN                                 VARCHAR2(1)   -- ��ҿ���
  ,TR_DT                                   VARCHAR2(8)   -- �����ŷ�����
  ,TR_TM                                   VARCHAR2(6)   -- �����ŷ��ð�
  ,USR_NO                                  VARCHAR2(10)  -- �����ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������22               IS 'OPE_KRI_����������22';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.BRNO               IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.BR_NM              IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.CUST_NO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.CLN_ACNO           IS '���Ű��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.CLN_EXE_NO         IS '���Ž����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.CLN_TR_NO          IS '���Űŷ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.PDCD               IS '��ǰ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.PRD_KR_NM          IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.WN_TNSL_PCPL       IS '��ȭȯ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.RDM_WN_TNSL_PCPL   IS '��ȯ��ȭȯ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.CNCL_YN            IS '��ҿ���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.TR_DT              IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.TR_TM              IS '�ŷ��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������22.USR_NO             IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_����������22 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������22 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������22 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������22 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������22 TO RL_OPE_SEL;

EXIT
