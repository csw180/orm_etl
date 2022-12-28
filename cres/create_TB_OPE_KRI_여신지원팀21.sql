DROP TABLE OPEOWN.TB_OPE_KRI_����������21;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������21
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)      -- ����ȣ
  ,CUST_INF_CHG_SNO                        NUMBER(10)     -- �����������Ϸù�ȣ
  ,INTG_ACNO                               VARCHAR2(35)   -- ���հ��¹�ȣ
  ,PDCD                                    VARCHAR2(14)   --  ��ǰ�ڵ�
  ,PRD_KR_NM                               VARCHAR2(100)  -- ��ǰ�ѱ۸�
  ,CRCD                                    VARCHAR2(3)    -- ��ȭ�ڵ�
  ,LN_RMD                                  NUMBER(20, 2)  -- �����ܾ�
  ,TL_RCV_DEN_YN                           VARCHAR2(1)    -- ��ȭ��ȭ�źο���
  ,TL_RCV_ENR_DT                           VARCHAR2(8)    -- ��ȭ��ȭ�źε���Ͻ�
  ,SMS_RCV_DEN_YN                          VARCHAR2(1)    -- SMS���Űźο���
  ,SMS_RCV_ENR_DT                          VARCHAR2(8)    -- SMS���Űźε���Ͻ�
  ,USR_NO                                  VARCHAR2(10)   -- ��ϻ���ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������21               IS 'OPE_KRI_����������21';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.BRNO               IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.BR_NM              IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.CUST_NO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.CUST_INF_CHG_SNO   IS '�����������Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.INTG_ACNO          IS '���հ��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.PDCD               IS '��ǰ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.PRD_KR_NM          IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.CRCD               IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.LN_RMD             IS '�����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.TL_RCV_DEN_YN      IS '��ȭ���Űźο���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.TL_RCV_ENR_DT      IS '��ȭ���ŵ������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.SMS_RCV_DEN_YN     IS 'SMS���Űźο���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.SMS_RCV_ENR_DT     IS 'SMS���ŵ������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������21.USR_NO             IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_����������21 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������21 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������21 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������21 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������21 TO RL_OPE_SEL;

EXIT
