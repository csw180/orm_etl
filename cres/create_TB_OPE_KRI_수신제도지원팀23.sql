DROP TABLE OPEOWN.TB_OPE_KRI_��������������23;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������23
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)           -- �߰�
  ,BR_NM                                   VARCHAR2(100)         -- �߰�
  ,CHNL_TPCD                               VARCHAR2(4)   -- ä�������ڵ�
  ,CUST_NO                                 NUMBER(9)     -- ����ȣ
  ,ACNO                                    VARCHAR2(12)  -- ���¹�ȣ
  ,PRD_KR_NM                               VARCHAR2(100) -- ��ǰ�ѱ۸�
  ,CRCD                                    VARCHAR2(3)   -- ��ȭ�ڵ�
  ,TR_AMT                                  NUMBER(18,2)  -- �ŷ��ݾ�
  ,TR_DT                                   VARCHAR2(8)   -- �ŷ�����
  ,MBTL_NO_CHG_YN                          VARCHAR2(1)   -- �޴���ȭ��ȣ ���濩��
  ,MBTL_NO_CHG_DTTM                        VARCHAR2(8)   -- �޴���ȭ��ȣ ������
  ,RCV_DEN_YN                              VARCHAR2(1)   -- ��ȭ���ڼ��Űźο���
  ,RCV_DEN_ENR_DTTM                        VARCHAR2(8)   -- ��ȭ���ڼ��Űźε����
  ,USR_NO                                  VARCHAR2(10)   -- �ŷ�����ڹ�ȣ  �߰�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������23               IS 'OPE_KRI_��������������23';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.CHNL_TPCD         IS 'ä�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.CUST_NO           IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.ACNO              IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.PRD_KR_NM         IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.CRCD              IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.TR_AMT            IS '�ŷ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.TR_DT             IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.MBTL_NO_CHG_YN    IS '�޴���ȭ��ȣ���濩��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.MBTL_NO_CHG_DTTM  IS '�޴���ȭ��ȣ�����Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.RCV_DEN_YN        IS '���Űźο���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.RCV_DEN_ENR_DTTM  IS '���Űźε���Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������23.USR_NO            IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������23 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������23 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������23 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������23 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������23 TO RL_OPE_SEL;
