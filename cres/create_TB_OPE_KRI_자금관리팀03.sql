DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����03;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,OCC_DT                                  VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)
  ,OCC_AMT                                 NUMBER(18,2)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����03               IS 'OPE_KRI_�ڱݰ�����03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����03.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����03.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����03.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����03.OCC_DT       IS '�߻�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����03.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����03.OCC_AMT      IS '�߻��ݾ�';

GRANT SELECT ON TB_OPE_KRI_�ڱݰ�����03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݰ�����03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݰ�����03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݰ�����03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݰ�����03 TO RL_OPE_SEL;

EXIT
