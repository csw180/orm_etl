DROP TABLE OPEOWN.TB_OPE_KRI_������Ź��01;

CREATE TABLE OPEOWN.TB_OPE_KRI_������Ź��01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,ACNO                                    VARCHAR2(12)
  ,DTL_CND_DESC                            VARCHAR2(400)  -- �����Ǽ���
  ,ISA_PRD_ACNO                            VARCHAR2(20)   -- ISA��ǰ���¹�ȣ
  ,PRD_KR_NM                               VARCHAR2(100)   -- ��ǰ��
  ,CRCD                                    VARCHAR2(3)    -- ��ȭ�ڵ�
  ,TR_AMT                                  NUMBER(20,2)   -- �����ܾ�
  ,NW_DT                                   VARCHAR2(8)
  ,EXPI_DT                                 VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_������Ź��01               IS 'OPE_KRI_������Ź��01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.DTL_CND_DESC IS '�����Ǽ���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.ISA_PRD_ACNO IS 'ISA��ǰ���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.TR_AMT       IS '�ŷ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��01.EXPI_DT      IS '��������';

GRANT SELECT ON TB_OPE_KRI_������Ź��01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_������Ź��01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_������Ź��01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_������Ź��01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_������Ź��01 TO RL_OPE_SEL;

EXIT
