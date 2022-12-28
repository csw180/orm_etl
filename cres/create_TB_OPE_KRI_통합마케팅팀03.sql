DROP TABLE OPEOWN.TB_OPE_KRI_���ո�������03;

CREATE TABLE OPEOWN.TB_OPE_KRI_���ո�������03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CUST_DSCD                               VARCHAR2(2)    -- �������ڵ�
  ,ENR_DTTM                                DATE
  ,CUST_APRV_STCD                          VARCHAR2(1)    -- �����λ����ڵ�
  ,APC_RSN                                 VARCHAR2(200)  -- ��û����
  ,APRV_USR_NO                             VARCHAR2(10)   -- ���λ���ڹ�ȣ
  ,APRV_BRNO                               VARCHAR2(4)    -- ��������ȣ
  ,ENR_USR_NO                              VARCHAR2(10)   -- ��ϻ���ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_���ո�������03                 IS 'OPE_KRI_���ո�������03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.STD_DT          IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.CUST_NO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.CUST_DSCD       IS '�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.ENR_DTTM        IS '����Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.CUST_APRV_STCD  IS '�����λ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.APC_RSN         IS '��û����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.APRV_USR_NO     IS '���λ���ڹ�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.APRV_BRNO       IS '��������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������03.ENR_USR_NO      IS '��ϻ���ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_���ո�������03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_���ո�������03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_���ո�������03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_���ո�������03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_���ո�������03 TO RL_OPE_SEL;

EXIT
