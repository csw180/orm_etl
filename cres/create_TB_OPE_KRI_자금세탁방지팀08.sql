DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,NPFT_YN_NM                              VARCHAR2(20)   -- �񿵸����θ�
  ,VRF_ENR_DT                              VARCHAR2(8)   --���������(KYC������)
  ,KYC_SNO                                 NUMBER(10)  -- ���˱������Ϸù�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08               IS 'OPE_KRI_�ڱݼ�Ź������08';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08.NPFT_YN_NM   IS '�񿵸����θ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08.VRF_ENR_DT   IS '�����������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08.KYC_SNO      IS '���˱������Ϸù�ȣ';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������08 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������08 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������08 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������08 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������08 TO RL_OPE_SEL;

EXIT
