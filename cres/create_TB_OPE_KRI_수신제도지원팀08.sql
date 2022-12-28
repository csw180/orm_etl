DROP TABLE OPEOWN.TB_OPE_KRI_��������������08;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������08
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)   --  ���¹�ȣ
  ,CUST_NO                                 NUMBER(9)
  ,TSK_DSCD                                VARCHAR2(1)    --  ���������ڵ�
  ,CFWR_ISN_NO                             NUMBER(15)  -- �����߱޹�ȣ
  ,ISN_DT                                  VARCHAR2(8)  -- �߱�����
  ,LDGR_STCD                               VARCHAR2(1)  -- ��������ڵ� ( 3:���)
  ,ISN_CNCL_DT                             VARCHAR2(8)  -- �߱��������
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������08               IS 'OPE_KRI_��������������08';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������08.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������08.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������08.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������08.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������08.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������08.TSK_DSCD     IS '���������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������08.CFWR_ISN_NO   IS '�����߱޹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������08.ISN_DT       IS '�߱�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������08.LDGR_STCD    IS '��������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������08.ISN_CNCL_DT  IS '�߱��������';

GRANT SELECT ON TB_OPE_KRI_��������������08 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������08 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������08 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������08 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������08 TO RL_OPE_SEL;

EXIT
