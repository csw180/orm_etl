DROP TABLE OPEOWN.TB_OPE_KRI_�����а�����03;

CREATE TABLE OPEOWN.TB_OPE_KRI_�����а�����03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,OCC_DT                                  VARCHAR2(8)
  ,OCC_AMT                                 NUMBER(18,2)   -- �߻��ݾ�
  ,NARN_RMD                                NUMBER(20,2)   -- �������ܾ�
  ,ARN_DT                                  VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�����а�����03               IS 'OPE_KRI_�����а�����03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����03.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����03.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����03.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����03.OCC_DT       IS '�߻�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����03.OCC_AMT      IS '�߻��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����03.NARN_RMD     IS '�������ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����03.ARN_DT       IS '��������';

GRANT SELECT ON TB_OPE_KRI_�����а�����03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�����а�����03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�����а�����03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�����а�����03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�����а�����03 TO RL_OPE_SEL;

EXIT
