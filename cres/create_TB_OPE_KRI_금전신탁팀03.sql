DROP TABLE OPEOWN.TB_OPE_KRI_������Ź��03;

CREATE TABLE OPEOWN.TB_OPE_KRI_������Ź��03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,AGE                                     NUMBER(3)
  ,ACNO                                    VARCHAR2(12)
  ,DTL_CND_DESC                            VARCHAR2(400)  -- �����Ǽ���
  ,PRD_KR_NM                               VARCHAR2(100)   -- ��ǰ��
  ,CRCD                                    VARCHAR2(3)    -- ��ȭ�ڵ�
  ,TR_AMT                                  NUMBER(20,2)   -- �����ܾ�
  ,NW_DT                                   VARCHAR2(8)
  ,EXPI_DT                                 VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_������Ź��03               IS 'OPE_KRI_������Ź��03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.AGE          IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.DTL_CND_DESC IS '�����Ǽ���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.TR_AMT       IS '�ŷ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��03.EXPI_DT      IS '��������';

GRANT SELECT ON TB_OPE_KRI_������Ź��03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_������Ź��03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_������Ź��03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_������Ź��03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_������Ź��03 TO RL_OPE_SEL;

EXIT
