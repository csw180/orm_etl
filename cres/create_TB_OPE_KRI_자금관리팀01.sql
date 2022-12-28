DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����01;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,DMD_AMT                                 NUMBER(18,2)
  ,DMD_DT                                  VARCHAR2(8)  -- û������
  ,TR_DT                                   VARCHAR2(8)  -- ó������
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݰ�����01               IS 'OPE_KRI_�ڱݰ�����01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����01.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����01.DMD_AMT      IS 'û���ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����01.DMD_DT       IS 'û������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݰ�����01.TR_DT        IS '�ŷ�����';

GRANT SELECT ON TB_OPE_KRI_�ڱݰ�����01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݰ�����01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݰ�����01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݰ�����01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݰ�����01 TO RL_OPE_SEL;

EXIT
