DROP TABLE OPEOWN.TB_OPE_KRI_��������������17;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������17
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,LDGR_RMD                                NUMBER(20,2)  -- �����ܾ�
  ,EXPI_DT                                 VARCHAR2(8)
  ,ACCR_DCNT                               NUMBER(10)   -- ����ϼ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������17               IS 'OPE_KRI_��������������17';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������17.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������17.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������17.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������17.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������17.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������17.LDGR_RMD     IS '�����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������17.EXPI_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������17.ACCR_DCNT    IS '�������';

GRANT SELECT ON TB_OPE_KRI_��������������17 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������17 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������17 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������17 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������17 TO RL_OPE_SEL;

EXIT
