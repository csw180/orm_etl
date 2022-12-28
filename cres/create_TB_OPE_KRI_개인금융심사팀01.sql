DROP TABLE OPEOWN.TB_OPE_KRI_���α����ɻ���01;

CREATE TABLE OPEOWN.TB_OPE_KRI_���α����ɻ���01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_DSCD                               VARCHAR2(2)     -- �������ڵ�
  ,CUST_NO                                 NUMBER(9)
  ,CLN_JUD_RPST_NO                         VARCHAR2(14)    -- ���Žɻ��ǥ��ȣ
  ,APRV_CND_EXE_BNF_DSCD                   VARCHAR2(1)     -- �������ǽ������ı����ڵ�
  ,APRV_CND_FLF_FRQ_DSCD                   VARCHAR2(2)     -- �������������ֱⱸ���ڵ�
  ,JUD_APRV_CND_CTS                        VARCHAR2(1000)  -- �ɻ�������ǳ���
  ,APRV_CND_NEXT_FLF_PARN_DT               VARCHAR2(8)     -- �������Ǵ������࿹������
  ,RSBL_XMRL_USR_NO                        VARCHAR2(10)    -- ���ɻ翪����ڹ�ȣ
  ,JDGR_NM                                 VARCHAR2(100)   -- �ɻ�ݸ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_���α����ɻ���01                       IS 'OPE_KRI_���α����ɻ���01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.STD_DT                IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.BRNO                  IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.BR_NM                 IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.CUST_DSCD             IS '�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.CUST_NO               IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.CLN_JUD_RPST_NO       IS '�ɻ��ǥ��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.APRV_CND_EXE_BNF_DSCD IS '�������ǽ������ı����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.APRV_CND_FLF_FRQ_DSCD IS '�������������ֱⱸ���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.JUD_APRV_CND_CTS      IS '�ɻ�������ǳ���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.APRV_CND_NEXT_FLF_PARN_DT   IS '�������Ǵ������࿹������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.RSBL_XMRL_USR_NO      IS '���ɻ翪����ڹ�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���α����ɻ���01.JDGR_NM               IS '�ɻ�ݸ�';

GRANT SELECT ON TB_OPE_KRI_���α����ɻ���01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_���α����ɻ���01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_���α����ɻ���01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_���α����ɻ���01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_���α����ɻ���01 TO RL_OPE_SEL;

EXIT
