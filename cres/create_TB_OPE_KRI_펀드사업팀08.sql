DROP TABLE OPEOWN.TB_OPE_KRI_�ݵ�����08;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ݵ�����08
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,ASP_TXIM_KDCD                           VARCHAR2(2)   -- ���ܼ��������ڵ�
  ,ASP_DFRY_PSB_RMD                        NUMBER(18,2)  -- �������ް����ܾ�
  ,TR_RCFM_DT                              VARCHAR2(8)   -- �ŷ��������
  ,USR_NO                                  VARCHAR2(10)  -- ��ϻ���ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_�ݵ�����08                 IS 'OPE_KRI_�ݵ�����08';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����08.STD_DT          IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����08.BRNO               IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����08.BR_NM              IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����08.ACNO               IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����08.ASP_TXIM_KDCD      IS '���ܼ��������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����08.ASP_DFRY_PSB_RMD   IS '�������ް����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����08.TR_RCFM_DT         IS '�ŷ��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����08.USR_NO             IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_�ݵ�����08 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ݵ�����08 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ݵ�����08 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ݵ�����08 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ݵ�����08 TO RL_OPE_SEL;

EXIT
