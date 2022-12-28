DROP TABLE OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01;

CREATE TABLE OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12) -- ���¹�ȣ
  ,CUST_NO                                 NUMBER(9)    -- ����ȣ
  ,TR_DT                                   VARCHAR2(8)  -- �ŷ�����
  ,BFTR_CMM_ACD_DCL_DSCD                   VARCHAR2(2)  -- ������Ż��Ű����ڵ�
  ,FNN_DCP_TPCD                            VARCHAR2(1)  -- ������������ڵ�
  ,ENR_USR_NO                              VARCHAR2(10) -- ��ϻ���ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01               IS 'OPE_KRI_�Һ��ں�ȣ��01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01.BFTR_CMM_ACD_DCL_DSCD     IS '������Ż��Ű����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01.FNN_DCP_TPCD    IS '������������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01.ENR_USR_NO      IS '��ϻ���ڹ�ȣ';
  
GRANT SELECT ON TB_OPE_KRI_�Һ��ں�ȣ��01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�Һ��ں�ȣ��01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�Һ��ں�ȣ��01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�Һ��ں�ȣ��01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�Һ��ں�ȣ��01 TO RL_OPE_SEL;

EXIT
