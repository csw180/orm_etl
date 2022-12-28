DROP TABLE OPEOWN.TB_OPE_KRI_������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_������01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,CLN_EXE_NO                              NUMBER(10)
  ,CLN_TR_NO                               NUMBER(10)
  ,CLN_TR_KDCD                             VARCHAR2(3)   -- ���Űŷ������ڵ�
  ,TR_DT                                   VARCHAR2(8)   -- �ŷ�����
  ,CNCL_DT                                 VARCHAR2(8)   -- �������
  ,RCFM_DT                                 VARCHAR2(8)   -- �������
  ,USR_NO                                  VARCHAR2(10)  -- �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_������01               IS 'OPE_KRI_������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.CLN_ACNO     IS '���Ű��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.CLN_EXE_NO   IS '���Ž����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.CLN_TR_NO    IS '���Űŷ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.CLN_TR_KDCD  IS '���Űŷ������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.CNCL_DT      IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.RCFM_DT      IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_������01 TO RL_OPE_SEL;

EXIT
