DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,DNFBP_YN_NM                             VARCHAR2(10)   -- �񿵸����θ�
  ,VRF_ENR_DT                              VARCHAR2(8)   --���������(KYC������)
  ,KYC_SNO                                 NUMBER(10)  -- ���˱������Ϸù�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10               IS 'OPE_KRI_�ڱݼ�Ź������10';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10.DNFBP_YN_NM  IS 'Ư�����������ڿ��θ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10.VRF_ENR_DT   IS '���������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10.KYC_SNO      IS '���˱������Ϸù�ȣ';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������10 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������10 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������10 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������10 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������10 TO RL_OPE_SEL;

EXIT
