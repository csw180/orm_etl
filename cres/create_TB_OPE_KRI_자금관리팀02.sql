DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����02;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,OCC_DT                                  VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)
  ,OCC_AMT                                 NUMBER(18,2)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����02               IS 'OPE_KRI_�ڱݰ�����02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����02.OCC_DT       IS '�߻�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����02.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����02.OCC_AMT      IS '�߻��ݾ�';

GRANT SELECT ON TB_OPE_KRI_�ڱݰ�����02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݰ�����02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݰ�����02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݰ�����02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݰ�����02 TO RL_OPE_SEL;

EXIT
