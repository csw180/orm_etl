DROP TABLE OPEOWN.TB_OPE_KRI_����������03;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,CLN_EXE_NO                              NUMBER(10)
  ,CLN_TR_NO                               NUMBER(10)
  ,CRCD                                    VARCHAR2(3)
  ,WN_TNSL_INT                             NUMBER(18,2)  -- ���ڻ�ȯ�ݾ�
  ,INT_RCFM_DT                             VARCHAR2(8) -- ���ڱ������
  ,RCFM_DT                                 VARCHAR2(8) -- �������
  ,TR_DT                                   VARCHAR2(8) -- �ŷ�����
  ,USR_NO                                  VARCHAR2(10) -- �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������03               IS 'OPE_KRI_����������03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.CLN_ACNO     IS '���Ű��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.CLN_EXE_NO   IS '���Ž����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.CLN_TR_NO    IS '���Űŷ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.WN_TNSL_INT  IS '��ȭȯ������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.INT_RCFM_DT  IS '���ڱ������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.RCFM_DT      IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������03.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_����������03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������03 TO RL_OPE_SEL;

EXIT
