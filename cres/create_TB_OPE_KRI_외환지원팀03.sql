DROP TABLE OPEOWN.TB_OPE_KRI_��ȯ������03;

CREATE TABLE OPEOWN.TB_OPE_KRI_��ȯ������03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,REF_NO                                  VARCHAR2(20)
  ,CRCD                                    VARCHAR2(3)    --��ȭ�ڵ�
  ,OPN_AMT                                 NUMBER(18,2)  -- �����ݾ�
  ,OPN_DT                                  VARCHAR2(8)   -- ��������
  ,AVL_DT                                  VARCHAR2(8)   -- ��ȿ����
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��ȯ������03               IS 'OPE_KRI_��ȯ������03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������03.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������03.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������03.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������03.REF_NO       IS 'REF��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������03.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������03.OPN_AMT      IS '�����ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������03.OPN_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������03.AVL_DT       IS '��ȿ����';

GRANT SELECT ON TB_OPE_KRI_��ȯ������03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��ȯ������03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��ȯ������03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��ȯ������03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��ȯ������03 TO RL_OPE_SEL;

EXIT
