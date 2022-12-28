DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CTR_NO                                  VARCHAR2(13)
  ,CTR_DT                                  VARCHAR2(8)
  ,CUST_NO                                 NUMBER(9)
  ,CTR_AMT                                 NUMBER(20,4)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������01               IS 'OPE_KRI_�ڱݼ�Ź������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������01.CTR_NO       IS '������ݺ����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������01.CTR_DT       IS '������ݺ�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������01.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������01.CTR_AMT      IS '������ݺ���ݾ�';

GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݼ�Ź������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݼ�Ź������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݼ�Ź������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݼ�Ź������01 TO RL_OPE_SEL;

EXIT
