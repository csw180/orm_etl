DROP TABLE OPEOWN.TB_OPE_KRI_�����а�����02;

CREATE TABLE OPEOWN.TB_OPE_KRI_�����а�����02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACSB_CD                                 VARCHAR2(8)   -- ���������ڵ�
  ,OCC_DT                                  VARCHAR2(8)
  ,NARN_RMD                                NUMBER(20,2)   -- �������ܾ�
  ,CUR_AMT                                 NUMBER(18,2)   -- ��ȭ�ݾ�
  ,ALT_AMT                                 NUMBER(18,2)   -- ��ü�ݾ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�����а�����02               IS 'OPE_KRI_�����а�����02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����02.ACSB_CD      IS '���������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����02.OCC_DT       IS '�߻�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����02.NARN_RMD     IS '�������ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����02.CUR_AMT      IS '��ȭ�ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����02.ALT_AMT      IS '��ü�ݾ�';

GRANT SELECT ON TB_OPE_KRI_�����а�����02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�����а�����02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�����а�����02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�����а�����02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�����а�����02 TO RL_OPE_SEL;

EXIT
