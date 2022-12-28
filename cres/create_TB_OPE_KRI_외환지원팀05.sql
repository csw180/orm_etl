DROP TABLE OPEOWN.TB_OPE_KRI_��ȯ������05;

CREATE TABLE OPEOWN.TB_OPE_KRI_��ȯ������05
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
  ,CLN_EXE_NO                              NUMBER(10)
  ,LN_EXE_AMT                              NUMBER(18, 2)
  ,LN_DT                                   VARCHAR2(8)    -- ��������
  ,CHKG_YN                                 VARCHAR2(1)    -- �������˿���
  ,CHKG_TMLM_DT                            VARCHAR2(8)    -- ���˱�������
  ,CHKG_DT                                 VARCHAR2(8)    -- ���˿Ϸ���
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��ȯ������05               IS 'OPE_KRI_��ȯ������05';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.CUST_NO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.CUST_DSCD       IS '�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.ACN_DCMT_NO     IS '���½ĺ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.PRD_KR_NM       IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.CRCD            IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.APRV_AMT        IS '���αݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.CLN_EXE_NO      IS '���Ž����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.LN_EXE_AMT      IS '���Ž���ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.LN_DT           IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.CHKG_YN         IS '���˿���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.CHKG_TMLM_DT    IS '���˱�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������05.CHKG_DT         IS '��������';

GRANT SELECT ON TB_OPE_KRI_��ȯ������05 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��ȯ������05 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��ȯ������05 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��ȯ������05 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��ȯ������05 TO RL_OPE_SEL;

EXIT
