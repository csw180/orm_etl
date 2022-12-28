DROP TABLE OPEOWN.TB_OPE_KRI_����������18;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������18
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CLN_ACNO                                VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,CUST_DSCD                               VARCHAR2(1)   -- ������ 1:�������, 2:��������
  ,PDCD                                    VARCHAR2(14)
  ,PRD_KR_NM                               VARCHAR2(100)  -- ��ǰ�ѱ۸�
  ,CRCD                                    VARCHAR2(3)
  ,APRV_AMT                                NUMBER(18,2)
  ,CLN_EXE_NO                              NUMBER(10)
  ,TR_PCPL                                 NUMBER(18,2)   -- ����ݾ�
  ,TR_DT                                   VARCHAR2(8)    -- ��������
  ,RCFM_DT                                 VARCHAR2(8)    -- �������
  ,LKG_YN                                  VARCHAR2(1)   -- �����Աݿ���
  ,LKG_FCNO                                VARCHAR2(20)  -- �����Աݰ��¹�ȣ
  ,USR_NO                                  VARCHAR2(10)  -- ������������ȣ
  ,CLN_TR_DTL_KDCD                         VARCHAR2(4)   -- ���Űŷ��������ڵ�
  ,TR_STCD                                 VARCHAR2(1)   -- �ŷ������ڵ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������18               IS 'OPE_KRI_����������18';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.CLN_ACNO     IS '���Ű��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.CUST_DSCD    IS '�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.PDCD         IS '��ǰ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.APRV_AMT     IS '���αݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.CLN_EXE_NO   IS '���Ž����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.TR_PCPL      IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.RCFM_DT      IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.LKG_YN       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.LKG_FCNO     IS '��������������¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.USR_NO       IS '����ڹ�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.CLN_TR_DTL_KDCD    IS '���Űŷ��������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������18.TR_STCD      IS '�ŷ������ڵ�';

GRANT SELECT ON TB_OPE_KRI_����������18 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������18 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������18 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������18 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������18 TO RL_OPE_SEL;

EXIT
