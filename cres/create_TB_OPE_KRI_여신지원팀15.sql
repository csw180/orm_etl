DROP TABLE OPEOWN.TB_OPE_KRI_����������15;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������15
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,CLN_EXE_NO                              NUMBER(10)
  ,CLN_TR_NO                               NUMBER(10)
  ,CRCD                                    VARCHAR2(3)
  ,WN_TNSL_PCPL                            NUMBER(18,2)  -- �ŷ�����
  ,CNCL_YN                                 VARCHAR2(1)   -- ��ҿ���
  ,USR_NO                                  VARCHAR2(10) -- �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������15               IS 'OPE_KRI_����������15';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.CLN_ACNO     IS '���Ű��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.CLN_EXE_NO   IS '���Ž����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.CLN_TR_NO    IS '���Űŷ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.WN_TNSL_PCPL IS '��ȭȯ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.CNCL_YN      IS '��ҿ���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������15.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_����������15 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������15 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������15 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������15 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������15 TO RL_OPE_SEL;

EXIT
