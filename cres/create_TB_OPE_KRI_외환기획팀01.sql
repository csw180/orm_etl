DROP TABLE OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01;

CREATE TABLE OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,OW_REF_NO                               VARCHAR2(20)   --REFNO
  ,OW_PCS_DT                               VARCHAR2(8)    --ó������
  ,OW_CRCD                                 VARCHAR2(3)    --��ȭ�ڵ�
  ,OW_DFRY_AMT                             NUMBER(18,2)   --���ޱݾ�
  ,OW_TLR_NO                               VARCHAR2(10)   --�ڷ���ȣ
  ,OW_ACCR_DCNT                            NUMBER(10)     --����ϼ�
  ,IW_REF_NO                               VARCHAR2(20)   --REFNO
  ,IW_PCS_DT                               VARCHAR2(8)    --ó������
  ,IW_CRCD                                 VARCHAR2(3)    --��ȭ�ڵ�
  ,IW_DFRY_AMT                             NUMBER(18,2)   --���ޱݾ�
  ,IW_TLR_NO                               VARCHAR2(10)   --�ڷ���ȣ
  ,IW_ACCR_DCNT                            NUMBER(10)     --����ϼ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01               IS 'OPE_KRI_��ȯ��ȹ��01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.BRNO              IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.BR_NM             IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.OW_REF_NO         IS '���REF��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.OW_PCS_DT         IS '���ó������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.OW_CRCD           IS '�����ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.OW_DFRY_AMT       IS '������ޱݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.OW_TLR_NO         IS '����ڷ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.OW_ACCR_DCNT      IS '��߰���ϼ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.IW_REF_NO         IS 'Ÿ��REF��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.IW_PCS_DT         IS 'Ÿ��ó������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.IW_CRCD           IS 'Ÿ����ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.IW_DFRY_AMT       IS 'Ÿ�����ޱݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.IW_TLR_NO         IS 'Ÿ���ڷ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01.IW_ACCR_DCNT      IS 'Ÿ�߰���ϼ�';

GRANT SELECT ON TB_OPE_KRI_��ȯ��ȹ��01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��ȯ��ȹ��01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��ȯ��ȹ��01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��ȯ��ȹ��01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��ȯ��ȹ��01 TO RL_OPE_SEL;

EXIT
