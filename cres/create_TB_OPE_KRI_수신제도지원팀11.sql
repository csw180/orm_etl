DROP TABLE OPEOWN.TB_OPE_KRI_��������������11;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������11
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)     -- ����ȣ
  ,ACNO                                    VARCHAR2(12)  --  ���¹�ȣ
  ,DPS_DP_DSCD                             VARCHAR2(1)  --  ���ſ��ݱ����ڵ�
  ,NW_DT                                   VARCHAR2(8)  --  �ű�����
  ,EXPI_DT                                 VARCHAR2(8)  --  ��������
  ,TR_DT                                   VARCHAR2(8)  --  �ŷ�����
  ,TR_TM                                   VARCHAR2(6)  --  �ŷ��ð�
  ,CRCD                                    VARCHAR2(3)   --  ��ȭ�ڵ�
  ,LDGR_RMD                                NUMBER(20,2)  --  �����ܾ�
  ,TR_PCPL                                 NUMBER(18,2)  --  �ŷ�����
  ,USR_NO                                  VARCHAR2(10)  --  �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������11               IS 'OPE_KRI_��������������11';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.DPS_DP_DSCD  IS '���ſ��ݱ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.EXPI_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.TR_TM        IS '�ŷ��ð�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.LDGR_RMD     IS '�����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.TR_PCPL      IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������11.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������11 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������11 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������11 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������11 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������11 TO RL_OPE_SEL;

EXIT
