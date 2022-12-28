DROP TABLE OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02;

CREATE TABLE OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,CHNL_CD                                  VARCHAR2(30)
  ,CVPL_NO                                  VARCHAR2(20)  -- �ο���ȣ
  ,CVPL_SNO                                 VARCHAR2(2)   -- �ο��Ϸù�ȣ
  ,CVPL_CTS                                 VARCHAR2(200)  --  �ο�����
  ,ACP_DT                                   VARCHAR2(8)   -- �ο���������
  ,TRNT_DPT                                 VARCHAR2(100)   -- ��ø�μ�
  ,CVPL_DTT                                 VARCHAR2(10)   -- �ο�����
  ,PCS_TMLM_DT                              VARCHAR2(8)   --  ó������
  ,PCS_CMPL_DT                              VARCHAR2(8)   -- ó���Ϸ�����
  ,PCS_EMNM                                 VARCHAR2(100)  -- �ο�ó��������ȣ
  ,PRD_DTT                                  VARCHAR2(100)   --  ��ǰ����
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02               IS 'OPE_KRI_�Һ��ں�ȣ��02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.CHNL_CD      IS 'ä���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.CVPL_NO      IS '�ο���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.CVPL_SNO     IS '�ο��Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.CVPL_CTS     IS '�ο�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.ACP_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.TRNT_DPT     IS '��ø�μ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.CVPL_DTT     IS '�ο�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.PCS_TMLM_DT  IS 'ó����������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.PCS_CMPL_DT  IS 'ó���Ϸ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.PCS_EMNM     IS 'ó��������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02.PRD_DTT      IS '��ǰ����';

GRANT SELECT ON TB_OPE_KRI_�Һ��ں�ȣ��02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�Һ��ں�ȣ��02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�Һ��ں�ȣ��02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�Һ��ں�ȣ��02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�Һ��ں�ȣ��02 TO RL_OPE_SEL;

EXIT
