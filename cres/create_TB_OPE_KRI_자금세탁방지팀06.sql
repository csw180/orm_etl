DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������06;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������06
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)           -- �߰�
  ,BR_NM                                   VARCHAR2(100)         -- �߰�
  ,CUST_NO                                 NUMBER(9)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������06               IS 'OPE_KRI_�ڱݼ�Ź������06';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������06.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������06.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������06.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������06.CUST_NO      IS '����ȣ';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������06 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������06 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������06 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������06 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������06 TO RL_OPE_SEL;
