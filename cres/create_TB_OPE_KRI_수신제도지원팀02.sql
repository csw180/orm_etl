DROP TABLE OPEOWN.TB_OPE_KRI_��������������02;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,CNVC_DSCD                               VARCHAR2(20)
  ,TR_DT                                   VARCHAR2(8)
  ,TR_AMT                                  NUMBER(18, 2)
  ,RLS_YN                                  VARCHAR2(1)
  ,RLS_DT                                  VARCHAR2(8)
  ,NARN_ACCR_DCNT                          NUMBER(10)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������02               IS 'OPE_KRI_��������������02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.CNVC_DSCD    IS '���Ǳ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.TR_AMT       IS '�ŷ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.RLS_YN       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.RLS_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������02.NARN_ACCR_DCNT  IS '����������ϼ�';

GRANT SELECT ON TB_OPE_KRI_��������������02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������02 TO RL_OPE_SEL;

EXIT
