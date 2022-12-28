DROP TABLE OPEOWN.TB_OPE_KRI_����������02;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,INTG_ACNO                               VARCHAR2(35)
  ,CUST_NO                                 NUMBER(9)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,CRCD                                    VARCHAR2(3)
  ,AVB_LN_AMT                              NUMBER(18,2)  -- ���뿩�űݾ�
  ,STUP_AMT                                NUMBER(18,2)  -- �����ݾ�
  ,STUP_NO                                 VARCHAR2(12)   -- ������ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������02               IS 'OPE_KRI_����������02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.INTG_ACNO    IS '���հ��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.AVB_LN_AMT   IS '���뿩�űݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.STUP_AMT     IS '�����ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.STUP_NO      IS '������ȣ';

GRANT SELECT ON TB_OPE_KRI_����������02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������02 TO RL_OPE_SEL;

EXIT
