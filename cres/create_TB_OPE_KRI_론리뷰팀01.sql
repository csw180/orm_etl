DROP TABLE OPEOWN.TB_OPE_KRI_�и�����01;

CREATE TABLE OPEOWN.TB_OPE_KRI_�и�����01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACN_DCMT_NO                             VARCHAR2(20)   -- ���½ĺ���ȣ
  ,CUST_NO                                 NUMBER(9)
  ,CUST_DSCD                               VARCHAR2(2)     -- �������ڵ�
  ,APCL_DSCD                               VARCHAR2(1)     -- ���ο��ű����ڵ�
  ,LN_SBCD                                 VARCHAR2(3)     -- ��������ڵ�
  ,CRCD                                    VARCHAR2(3)     -- ��ȭ�ڵ�
  ,APRV_AMT                                NUMBER(18,2)    -- ���αݾ�
  ,TOT_CLN_RMD                             NUMBER(20,2)    -- �ѿ����ܾ�
  ,CLN_APRV_DT                             VARCHAR2(8)     -- ���Ž�������
  ,APRV_LN_EXPI_DT                         VARCHAR2(8)     -- ���δ��⸸������
  ,LNRV_JDGM_DTT_NM                        VARCHAR2(10)    -- �и����������и�
  ,HDQ_JDGM_OPNN_CTS                       VARCHAR2(4000)   -- ���������ǰ߳���
  ,JDGM_DT                                 VARCHAR2(8)     -- ��������
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�и�����01               IS 'OPE_KRI_�и�����01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.ACN_DCMT_NO  IS '���½ĺ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.CUST_DSCD    IS '�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.APCL_DSCD    IS '���ο��ű����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.LN_SBCD      IS '��������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.APRV_AMT              IS '���αݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.TOT_CLN_RMD           IS '�ѿ����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.CLN_APRV_DT           IS '���Ž�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.APRV_LN_EXPI_DT       IS '���δ��⸸������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.LNRV_JDGM_DTT_NM      IS '�и����������и�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.HDQ_JDGM_OPNN_CTS     IS '���������ǰ߳���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����01.JDGM_DT               IS '��������';

GRANT SELECT ON TB_OPE_KRI_�и�����01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�и�����01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�и�����01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�и�����01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�и�����01 TO RL_OPE_SEL;

EXIT 
