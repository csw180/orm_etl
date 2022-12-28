DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������07;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������07
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,TR_AMT                                   NUMBER(20,4)  -- ������ǰ���񽺰ŷ��ݾ�
  ,RLT_ACNO                                 VARCHAR2(20)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������07               IS 'OPE_KRI_�ڱݼ�Ź������07';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������07.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������07.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������07.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������07.TR_AMT       IS '�ŷ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������07.RLT_ACNO     IS '���ð��¹�ȣ';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������07 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������07 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������07 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������07 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������07 TO RL_OPE_SEL;

EXIT
