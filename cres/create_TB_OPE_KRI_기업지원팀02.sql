DROP TABLE OPEOWN.TB_OPE_KRI_���������02;

CREATE TABLE OPEOWN.TB_OPE_KRI_���������02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,RBCI_ISN_NO                             VARCHAR2(14)  -- ������ȸ���߱޹�ȣ
  ,RBCI_ISN_CD                             VARCHAR2(1)    --������ȸ���߱��ڵ�(1:�߱�, 2:��ȸ)
  ,ISN_DT                                  VARCHAR2(8)   -- �߱�����
  ,CHPR_NM                                 VARCHAR2(100) -- ����ڸ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_���������02               IS 'OPE_KRI_���������02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������02.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������02.RBCI_ISN_NO  IS '������ȸ���߱޹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������02.RBCI_ISN_CD  IS '������ȸ���߱��ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������02.ISN_DT       IS '�߱�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������02.CHPR_NM      IS '�����û��ü����ڸ�';

GRANT SELECT ON TB_OPE_KRI_���������02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_���������02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_���������02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_���������02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_���������02 TO RL_OPE_SEL;

EXIT
