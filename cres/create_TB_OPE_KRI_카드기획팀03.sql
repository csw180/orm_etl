DROP TABLE OPEOWN.TB_OPE_KRI_ī���ȹ��03;

CREATE TABLE OPEOWN.TB_OPE_KRI_ī���ȹ��03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CRD_MBR_DSCD                            VARCHAR2(1)   -- ī��ȸ�������ڵ�
  --,CRD_MBR_DSCD_NM                         VARCHAR2(10)   -- ī��ȸ�������ڵ��
  ,OVD_AMT                                 NUMBER(18,2)  -- ��ü�ݾ�
  ,LMT_CHG_RSCD                            VARCHAR2(2)   -- �ѵ���������ڵ�
  --,LMT_CHG_RSCD_NM                         VARCHAR2(100)   -- �ѵ���������ڵ��
  ,LMT_CHG_DT                              VARCHAR2(8)   -- �ѵ�������
  ,ISN_DT                                  VARCHAR2(8)   -- �߱�����
  ,MBR_NW_DT                               VARCHAR2(8)   -- ī����ȸ����
  ,OVD_ST_DT                               VARCHAR2(8)   -- ��ü������
  ,PREN_DSCD                               VARCHAR2(1)   -- ���α�������ڵ�
  --,PREN_DSCD_NM                            VARCHAR2(10)   -- ���α�������ڵ��
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ī���ȹ��03              IS 'OPE_KRI_ī���ȹ��03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.CRD_MBR_DSCD IS 'ī��ȸ�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.OVD_AMT      IS '��ü�ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.LMT_CHG_RSCD IS '�ѵ���������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.LMT_CHG_DT   IS '�ѵ���������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.ISN_DT       IS '�߱�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.MBR_NW_DT    IS 'ȸ���ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.OVD_ST_DT    IS '��ü��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��03.PREN_DSCD    IS '���α�������ڵ�';

GRANT SELECT ON TB_OPE_KRI_ī���ȹ��03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ī���ȹ��03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ī���ȹ��03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ī���ȹ��03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ī���ȹ��03 TO RL_OPE_SEL;

EXIT
