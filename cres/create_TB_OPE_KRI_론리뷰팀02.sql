DROP TABLE OPEOWN.TB_OPE_KRI_�и�����02;

CREATE TABLE OPEOWN.TB_OPE_KRI_�и�����02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACN_DCMT_NO                             VARCHAR2(20)   -- ���½ĺ���ȣ
  ,CUST_NO                                 NUMBER(9)
  ,CUST_DSCD                               VARCHAR2(2)     -- �������ڵ�
  ,APCL_DSCD                               VARCHAR2(10)     -- ���ο��ű����ڵ�
  ,PRD_KR_NM                               VARCHAR2(100)
  ,CRCD                                    VARCHAR2(3)     -- ��ȭ�ڵ�
  ,APRV_AMT                                NUMBER(18,2)    -- ���αݾ�
  ,TOT_CLN_RMD                             NUMBER(20,2)    -- �ѿ����ܾ�
  ,CLN_APRV_DT                             VARCHAR2(8)     -- ���Ž�������
  ,EXPI_DT                                 VARCHAR2(8)     -- ��������
  ,LNRV_JDGM_DTT_NM                        VARCHAR2(10)    -- �и����������и�
  ,JDGM_DT                                 VARCHAR2(8)     -- ��������
--  ,LNRV_PTO_ITM_CD                         VARCHAR2(2)
--  ,HDQ_JDGM_OPNN_CTS                       VARCHAR2(4000)
--  ,ACTN_FLF_END_DT                         VARCHAR2(8)
  ,FLF_YN                                  VARCHAR2(1)     -- ���࿩�α����ڵ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�и�����02               IS 'OPE_KRI_�и�����02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.ACN_DCMT_NO  IS '���½ĺ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.CUST_DSCD    IS '�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.APCL_DSCD    IS '���ο��ű����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.APRV_AMT     IS '���αݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.TOT_CLN_RMD  IS '�ѿ����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.CLN_APRV_DT  IS '���Ž�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.EXPI_DT             IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.LNRV_JDGM_DTT_NM    IS '�и����������и�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.JDGM_DT             IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�и�����02.FLF_YN              IS '���࿩��';

GRANT SELECT ON TB_OPE_KRI_�и�����02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�и�����02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�и�����02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�и�����02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�и�����02 TO RL_OPE_SEL;

EXIT
