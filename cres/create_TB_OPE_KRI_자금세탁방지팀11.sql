DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������11;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������11
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,STR_NO                                   VARCHAR2(50)
  ,STR_DT                                   VARCHAR2(8)
  ,TNDN_DT                                  VARCHAR2(8)   -- �ݷ�����
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������11               IS 'OPE_KRI_�ڱݼ�Ź������11';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������11.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������11.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������11.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������11.STR_NO       IS '���ǰŷ������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������11.STR_DT       IS '���ǰŷ���������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������11.TNDN_DT      IS '�ݷ�����';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������11 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������11 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������11 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������11 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������11 TO RL_OPE_SEL;

EXIT
