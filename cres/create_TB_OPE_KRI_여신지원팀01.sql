DROP TABLE OPEOWN.TB_OPE_KRI_����������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,INTG_ACNO                               VARCHAR2(35)   --  ���հ��¹�ȣ
  ,CUST_NO                                 NUMBER(9)
  ,APRV_AMT                                NUMBER(18, 2)  -- ���αݾ�
  ,LN_RMD                                  NUMBER(20, 2)  -- �����ܾ�
  ,AGR_DT                                  VARCHAR2(8)  -- ��������
  ,ENTP_CREV_GD                            VARCHAR2(3)  -- ����ſ��򰡵��
  ,EVL_AVL_DT                              VARCHAR2(8)  -- ����ȿ����
--  ,SDNS_GDCD                               VARCHAR2(1)  -- ����������ڵ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������01               IS 'OPE_KRI_����������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.INTG_ACNO    IS '���հ��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.APRV_AMT     IS '���αݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.LN_RMD       IS '�����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.AGR_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.ENTP_CREV_GD IS '����ſ��򰡵��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.EVL_AVL_DT   IS '����ȿ����';

GRANT SELECT ON TB_OPE_KRI_����������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������01 TO RL_OPE_SEL;

EXIT
