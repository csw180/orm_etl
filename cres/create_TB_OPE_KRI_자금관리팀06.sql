DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����06;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����06
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,OCC_DT                                  VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)
  ,NARN_RMD                                NUMBER(18,2)
  ,ARN_DT                                  VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����06               IS 'OPE_KRI_�ڱݰ�����06';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����06.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����06.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����06.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����06.OCC_DT       IS '�߻�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����06.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����06.NARN_RMD     IS '�������ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����06.ARN_DT       IS '��������';

GRANT SELECT ON TB_OPE_KRI_�ڱݰ�����06 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݰ�����06 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݰ�����06 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݰ�����06 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݰ�����06 TO RL_OPE_SEL;

EXIT
