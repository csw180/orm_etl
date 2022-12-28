DROP TABLE OPEOWN.TB_OPE_KRI_IB�������03;

CREATE TABLE OPEOWN.TB_OPE_KRI_IB�������03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,INTG_ACNO                               VARCHAR2(35)
  ,CLN_EXE_NO                              NUMBER(10)
  ,PDCD                                    VARCHAR2(14)
  ,PRD_KR_NM                               VARCHAR2(100)  -- ��ǰ�ѱ۸�
  ,CRCD                                    VARCHAR2(3)
  ,LN_EXE_AMT                              NUMBER(18,2)  -- �������ݾ�
  ,LN_RMD                                  NUMBER(20,2)
  ,FC_RMD                                  NUMBER(20,2)  -- ��ȭ�ܾ�
  ,APC_DTT                                 VARCHAR2(10)   -- ��û����
  ,AGR_DT                                  VARCHAR2(8)
  ,OVD_YN                                  VARCHAR2(1)
  ,CLN_OVD_DSCD                            VARCHAR2(1)    -- ��ü�����ڵ�
  ,CLN_OVD_DSCD_NM                         VARCHAR2(200)  -- ��ü�����ڵ��
  ,OVD_AMT                                 NUMBER(18,2)   -- ��ü�ݾ�
  ,OVD_OCC_DT                              VARCHAR2(8)    -- ��ü�߻�����
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_IB�������03                       IS 'OPE_KRI_IB�������03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.STD_DT                IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.BRNO                  IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.BR_NM                 IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.CUST_NO               IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.INTG_ACNO             IS '���հ��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.CLN_EXE_NO            IS '���Ž����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.PDCD                  IS '��ǰ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.PRD_KR_NM             IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.CRCD                  IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.LN_EXE_AMT            IS '�������ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.LN_RMD                IS '�����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.FC_RMD                IS '��ȭ�ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.APC_DTT               IS '��û����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.AGR_DT                IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.OVD_YN                IS '��ü����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.CLN_OVD_DSCD          IS '���ſ�ü�����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.CLN_OVD_DSCD_NM       IS '���ſ�ü�����ڵ��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.OVD_AMT               IS '��ü�ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB�������03.OVD_OCC_DT            IS '��ü�߻�����';

GRANT SELECT ON TB_OPE_KRI_IB�������03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_IB�������03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_IB�������03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_IB�������03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_IB�������03 TO RL_OPE_SEL;

EXIT
