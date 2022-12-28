DROP TABLE OPEOWN.TB_OPE_KRI_����������20;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������20
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CHNL_TPCD                               VARCHAR2(4)  -- ä�������ڵ�
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,PRD_KR_NM                               VARCHAR2(100)  -- ��ǰ�ѱ۸�
  ,CRCD                                    VARCHAR2(3)
  ,CLN_APC_AMT                             NUMBER(18,2)  -- ���Ž�û�ݾ�
  ,APC_DT                                  VARCHAR2(8)  -- ���Ž�û����
  ,CHG_YN                                  VARCHAR2(1)  -- �޴���ȭ���濩��
  ,CHG_ENR_DT                              VARCHAR2(8)  -- ��������
  ,DEN_YN                                  VARCHAR2(1)  -- ��ȭ���ڰźο���
  ,DEN_ENR_DT                              VARCHAR2(8)  -- �źε����
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������20               IS 'OPE_KRI_����������20';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.CHNL_TPCD    IS 'ä�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.CLN_ACNO     IS '���Ű��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.CLN_APC_AMT  IS '���Ž�û�ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.APC_DT       IS '��û����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.CHG_YN       IS '���濩��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.CHG_ENR_DT   IS '����������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.DEN_YN       IS '�źο���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������20.DEN_ENR_DT   IS '�źε������';

GRANT SELECT ON TB_OPE_KRI_����������20 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������20 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������20 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������20 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������20 TO RL_OPE_SEL;

EXIT
