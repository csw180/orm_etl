DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������04;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������04
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,STR_NO                                   VARCHAR2(50)
  ,STR_DT                                   VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������04               IS 'OPE_KRI_�ڱݼ�Ź������04';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������04.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������04.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������04.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������04.STR_NO       IS '���ǰŷ������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������04.STR_DT       IS '���ǰŷ���������';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������04 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������04 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������04 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������04 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������04 TO RL_OPE_SEL;

EXIT
