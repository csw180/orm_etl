DROP TABLE OPEOWN.TB_OPE_KRI_����������05;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������05
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,PDCD                                    VARCHAR2(14)
  ,PRD_KR_NM                               VARCHAR2(100)  -- ��ǰ�ѱ۸�
  ,CRCD                                    VARCHAR2(3)
  ,MIMO_AMT                                NUMBER(18,2)   -- ��������ݾ�
  ,MVT_BRNO                                VARCHAR2(4)    -- �̰�����ȣ
  ,MVT_BR_NM                               VARCHAR2(100)  -- �̰�����
  ,MVT_TR_USR_NO                           VARCHAR2(10)   -- �̰�������������ȣ
  ,MVN_BRNO                                VARCHAR2(4)    -- ��������ȣ
  ,MVN_BR_NM                               VARCHAR2(100)  -- ��������
  ,MVN_TR_USR_NO                           VARCHAR2(10)   -- ����������������ȣ
  ,TR_DT                                   VARCHAR2(8)    -- �̼�����������
  ,APRV_TGT_YN                             VARCHAR2(1)    -- ���δ�󿩺�
  ,APRV_BRNO                               VARCHAR2(4)    -- ��������ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������05               IS 'OPE_KRI_����������05';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.CLN_ACNO     IS '���Ű��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.PDCD         IS '��ǰ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.MIMO_AMT     IS '��������ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.MVT_BRNO     IS '��������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.MVT_BR_NM        IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.MVT_TR_USR_NO    IS '����ŷ�����ڹ�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.MVN_BRNO         IS '��������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.MVN_BR_NM        IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.MVN_TR_USR_NO    IS '���԰ŷ�����ڹ�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.TR_DT            IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.APRV_TGT_YN      IS '���δ�󿩺�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������05.APRV_BRNO        IS '��������ȣ';

GRANT SELECT ON TB_OPE_KRI_����������05 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������05 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������05 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������05 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������05 TO RL_OPE_SEL;

EXIT
