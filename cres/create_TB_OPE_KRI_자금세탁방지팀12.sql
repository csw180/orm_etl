DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������12;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������12
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,OCC_DT                                   VARCHAR2(8)
  ,STR_NO                                   VARCHAR2(50)
  ,TR_AMT                                   NUMBER(20,4)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������12               IS 'OPE_KRI_�ڱݼ�Ź������12';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������12.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������12.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������12.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������12.OCC_DT       IS '�߻�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������12.STR_NO       IS '���ǰŷ������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������12.TR_AMT       IS '�ŷ��ݾ�';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������12 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������12 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������12 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������12 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������12 TO RL_OPE_SEL;

EXIT
