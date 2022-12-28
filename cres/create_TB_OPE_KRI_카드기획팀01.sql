DROP TABLE OPEOWN.TB_OPE_KRI_ī���ȹ��01;

CREATE TABLE OPEOWN.TB_OPE_KRI_ī���ȹ��01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CRD_MBR_DSCD                            VARCHAR2(1)   -- ī��ȸ�������ڵ�
  ,PREN_DSCD                               VARCHAR2(1)   -- ���α�������ڵ�
  ,CUST_SPCL_LMT_AMT                       NUMBER(18,2)  -- ��Ư���ѵ��ݾ�
  ,SPCL_LMT_APC_RSN                        VARCHAR2(100)  -- Ư���ѵ���û����
  ,USR_NO                                   VARCHAR2(10)   -- �ѵ��������ڹ�ȣ
  ,LMT_CHG_DT                                VARCHAR2(8)    -- �ѵ���������
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ī���ȹ��01              IS 'OPE_KRI_ī���ȹ��01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��01.BRNO               IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��01.BR_NM              IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��01.CRD_MBR_DSCD       IS 'ī��ȸ�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��01.PREN_DSCD          IS '���α�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��01.CUST_SPCL_LMT_AMT  IS '��Ư���ѵ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��01.SPCL_LMT_APC_RSN   IS 'Ư���ѵ���û����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��01.USR_NO             IS '����ڹ�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��01.LMT_CHG_DT         IS '�ѵ���������';

GRANT SELECT ON TB_OPE_KRI_ī���ȹ��01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ī���ȹ��01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ī���ȹ��01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ī���ȹ��01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ī���ȹ��01 TO RL_OPE_SEL;

EXIT
