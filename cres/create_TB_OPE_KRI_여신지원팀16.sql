DROP TABLE OPEOWN.TB_OPE_KRI_����������16;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������16
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACN_DCMT_NO                             VARCHAR2(20)   -- ���½ĺ���ȣ
  ,CUST_NO                                 NUMBER(9)
  ,PREN_CLN_DSCD                           VARCHAR2(1)    -- ���α�����ű����ڵ�
  ,PRD_KR_NM                               VARCHAR2(100)  -- ��ǰ�ѱ۸�
  ,APC_AMT                                 NUMBER(18,2)   -- ��û�ݾ�
  ,ALR_LN_RMD                              NUMBER(20, 2)  -- ������ܾ�
  ,AGR_DT                                  VARCHAR2(8)    -- ��������
  ,PRX_EXPI_DT                             VARCHAR2(8)    -- ������������
  ,CSLT_DT                                 VARCHAR2(8)   -- ǰ������
  ,USR_NO                                  VARCHAR2(10)   -- �ۼ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������16               IS 'OPE_KRI_����������16';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.ACN_DCMT_NO  IS '���½ĺ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.PREN_CLN_DSCD IS '�ŷ������α�����ű����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.APC_AMT      IS '��û�ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.ALR_LN_RMD   IS '������ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.AGR_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.PRX_EXPI_DT  IS '������������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.CSLT_DT      IS 'ǰ������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������16.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_����������16 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������16 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������16 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������16 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������16 TO RL_OPE_SEL;

EXIT
