DROP TABLE OPEOWN.TB_OPE_KRI_����������06;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������06
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CUST_DSCD                               VARCHAR2(2)
  ,ACN_DCMT_NO                             VARCHAR2(20)   -- ���½ĺ���ȣ
  ,PRD_KR_NM                               VARCHAR2(100)  -- ��ǰ�ѱ۸�
  ,CRCD                                    VARCHAR2(3)
  ,APRV_AMT                                NUMBER(18,2)   -- ���αݾ�
  ,TOT_CLN_RMD                             NUMBER(20,2)   -- �ѿ����ܾ�
  ,AGR_DT                                  VARCHAR2(8)    -- ��������
  ,EXPI_DT                                 VARCHAR2(8)    -- ��������
  ,ACK_TGT_YN                              VARCHAR2(1)    -- �������˴�󿩺�
  ,CHKG_YN                                 VARCHAR2(1)    -- �������˿���
  ,CHKG_TMLM_DT                            VARCHAR2(8)    -- ���˱�������
  ,CHKG_DT                                 VARCHAR2(8)    -- ���˿Ϸ���
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������06               IS 'OPE_KRI_����������06';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.CUST_DSCD    IS '�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.ACN_DCMT_NO  IS '���½ĺ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.APRV_AMT     IS '���αݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.TOT_CLN_RMD  IS '�ѿ����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.AGR_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.EXPI_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.ACK_TGT_YN   IS '�������˴�󿩺�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.CHKG_YN      IS '���˿���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.CHKG_TMLM_DT IS '���˱�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������06.CHKG_DT      IS '��������';

GRANT SELECT ON TB_OPE_KRI_����������06 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������06 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������06 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������06 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������06 TO RL_OPE_SEL;

EXIT
