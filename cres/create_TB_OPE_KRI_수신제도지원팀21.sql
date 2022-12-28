DROP TABLE OPEOWN.TB_OPE_KRI_��������������21;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������21
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)     -- ����ȣ
  ,ACNO                                    VARCHAR2(12)  --  ���¹�ȣ
  ,DPS_DP_DSCD                             VARCHAR2(1)  --  ���ſ��ݱ����ڵ�
  ,CRCD                                    VARCHAR2(3)
  ,TR_PCPL                                 NUMBER(18,2)  --  �ŷ�����
  ,NW_DT                                   VARCHAR2(8)  --  �ű�����
  ,EXPI_DT                                 VARCHAR2(8)  --  ��������
  ,CNCN_DT                                 VARCHAR2(8)  --  ��������
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������21               IS 'OPE_KRI_��������������21';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.DPS_DP_DSCD  IS '���ſ��ݱ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.TR_PCPL      IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.EXPI_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������21.CNCN_DT      IS '��������';

GRANT SELECT ON TB_OPE_KRI_��������������21 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������21 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������21 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������21 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������21 TO RL_OPE_SEL;

EXIT
