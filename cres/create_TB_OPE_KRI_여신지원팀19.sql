DROP TABLE OPEOWN.TB_OPE_KRI_����������19;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������19
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,MRT_NO                                  VARCHAR2(12)  --  �㺸��ȣ
  ,MRT_TPCD                                VARCHAR2(1)   --  �㺸�����ڵ�
  ,MRT_CD                                  VARCHAR2(3)   --  �㺸�ڵ�
  ,PDCD                                    VARCHAR2(14)  --  ��ǰ�ڵ�
  ,DPS_ACNO                                VARCHAR2(12)  --  ���Ű��¹�ȣ
  ,ACN_DCMT_NO                             VARCHAR2(20)  --  ���½ĺ���ȣ
  ,OWNR_CUST_NO                            NUMBER(9)     --  �����ڰ���ȣ
  ,DBR_CUST_NO                             NUMBER(9)     --  ä���ڰ���ȣ
  ,STUP_STCD                               VARCHAR2(2)   -- ���������ڵ�
  ,STUP_DT                                 VARCHAR2(8)   -- ��������
  ,LST_CHG_DT                              VARCHAR2(8)   -- ������������(������������)
  ,MBTL_NO_CHG_YN                          VARCHAR2(1)   -- �޴���ȭ��ȣ ���濩��
  ,MBTL_NO_CHG_DT                          VARCHAR2(8)   -- �޴���ȭ��ȣ ������
  ,RCV_DEN_YN                              VARCHAR2(1)   -- ��ȭ���ڼ��Űźο���
  ,RCV_DEN_ENR_DT                          VARCHAR2(8)   -- ��ȭ���ڼ��Űźε����
  ,USR_NO                                  VARCHAR2(10)  -- ������������ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������19               IS 'OPE_KRI_����������19';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.MRT_NO          IS '�㺸��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.MRT_TPCD        IS '�㺸�����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.MRT_CD          IS '�㺸�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.PDCD            IS '��ǰ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.DPS_ACNO        IS '���Ű��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.ACN_DCMT_NO     IS '���½ĺ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.OWNR_CUST_NO    IS '�����ڰ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.DBR_CUST_NO     IS 'ä���ڰ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.STUP_STCD       IS '���������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.STUP_DT         IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.LST_CHG_DT      IS '������������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.MBTL_NO_CHG_YN  IS '�޴���ȭ��ȣ���濩��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.MBTL_NO_CHG_DT  IS '�޴���ȭ��ȣ��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.RCV_DEN_YN      IS '���Űźο���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.RCV_DEN_ENR_DT  IS '���Űźε������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������19.USR_NO          IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_����������19 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������19 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������19 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������19 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������19 TO RL_OPE_SEL;

EXIT
