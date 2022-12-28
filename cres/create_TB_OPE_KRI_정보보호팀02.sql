DROP TABLE OPEOWN.TB_OPE_KRI_������ȣ��02;

CREATE TABLE OPEOWN.TB_OPE_KRI_������ȣ��02
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,VDCT_DT                                  VARCHAR2(8)     -- �Ҹ���
  ,LCLS                                     VARCHAR2(100)   -- ��з�
  ,SCLS                                     VARCHAR2(100)   -- �Һз�
  ,SNRO_NM                                  VARCHAR2(100)   -- �ó�������
  ,USR_ID                                   VARCHAR2(10)    -- �����ID
  ,USR_NM                                   VARCHAR2(100)   -- ����ڸ�
  ,BR_NM                                    VARCHAR2(100)   -- �μ���
  ,CNF_STS                                  VARCHAR2(100)  -- ��������
  ,VDCT_RQS_DT                              VARCHAR2(8)    -- �Ҹ��û��
  ,OCC_DT                                   VARCHAR2(8)    -- �߻��Ϸ���
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_������ȣ��02              IS 'OPE_KRI_������ȣ��02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.VDCT_DT      IS '�Ҹ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.LCLS         IS '��з�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.SCLS         IS '�Һз�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.SNRO_NM      IS '�ó�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.USR_ID       IS '�����ID';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.USR_NM       IS '����ڸ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.CNF_STS      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.VDCT_RQS_DT  IS '�Ҹ��û����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��02.OCC_DT       IS '�߻�����';

GRANT SELECT ON TB_OPE_KRI_������ȣ��02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_������ȣ��02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_������ȣ��02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_������ȣ��02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_������ȣ��02 TO RL_OPE_SEL;

EXIT
