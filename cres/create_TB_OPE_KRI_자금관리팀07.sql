DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����07;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����07
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,OCC_DT                                  VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)
  ,TR_AMT                                  NUMBER(18,2)
  ,FSC_DT                                  VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����07               IS 'OPE_KRI_�ڱݰ�����07';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����07.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����07.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����07.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����07.OCC_DT       IS '�߻�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����07.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����07.TR_AMT       IS '�ŷ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����07.FSC_DT       IS 'ȸ������';

GRANT SELECT ON TB_OPE_KRI_�ڱݰ�����07 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݰ�����07 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݰ�����07 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݰ�����07 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݰ�����07 TO RL_OPE_SEL;

EXIT
