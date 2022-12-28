DROP TABLE OPEOWN.TB_OPE_KRI_��������������13;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������13
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)  --  ���¹�ȣ
  ,CUST_NO                                 NUMBER(9)     -- ����ȣ
  ,DPS_DP_DSCD                             VARCHAR2(1)  --  ���ſ��ݱ����ڵ�
  ,NW_DT                                   VARCHAR2(8)  --  �ű�����
  ,CNCN_DT                                 VARCHAR2(8)  --  ��������
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������13               IS 'OPE_KRI_��������������13';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������13.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������13.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������13.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������13.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������13.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������13.DPS_DP_DSCD  IS '���ſ��ݱ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������13.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������13.CNCN_DT      IS '��������';

GRANT SELECT ON TB_OPE_KRI_��������������13 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������13 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������13 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������13 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������13 TO RL_OPE_SEL;

EXIT
