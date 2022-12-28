DROP TABLE OPEOWN.TB_OPE_KRI_ī���ȹ��02;

CREATE TABLE OPEOWN.TB_OPE_KRI_ī���ȹ��02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CRD_PRD_DSCD                            VARCHAR2(2)   -- ī���ǰ�����ڵ�
  --,CRD_PRD_DSCD_NM                         VARCHAR2(100)   -- ī���ǰ�����ڵ��
  ,ISN_DT                                  VARCHAR2(8)     -- �߱�����
  ,MBR_NW_DT                               VARCHAR2(8)   -- ī����ȸ����
  ,OVD_ST_DT                               VARCHAR2(8)   -- ��ü������
  ,OVD_AMT                                 NUMBER(18,2)  -- ��ü�ݾ�
  ,PREN_DSCD                               VARCHAR2(1)   -- ���α�������ڵ�
  --,PREN_DSCD_NM                            VARCHAR2(10)   -- ���α�������ڵ��
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ī���ȹ��02              IS 'OPE_KRI_ī���ȹ��02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��02.CRD_PRD_DSCD IS 'ī���ǰ�����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��02.ISN_DT       IS '�߱�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��02.MBR_NW_DT    IS 'ȸ���ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��02.OVD_ST_DT    IS '��ü��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��02.OVD_AMT      IS '��ü�ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī���ȹ��02.PREN_DSCD    IS '���α�������ڵ�';

GRANT SELECT ON TB_OPE_KRI_ī���ȹ��02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ī���ȹ��02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ī���ȹ��02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ī���ȹ��02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ī���ȹ��02 TO RL_OPE_SEL;

EXIT
