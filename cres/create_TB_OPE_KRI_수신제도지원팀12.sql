DROP TABLE OPEOWN.TB_OPE_KRI_��������������12;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������12
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,ACNO                                    VARCHAR2(12)
  ,CRWR_DESC                               VARCHAR2(10)  -- ��������('�ǹ�')
  ,IMCW_NO                                 NUMBER(12)    -- �߿�������ȣ
  ,PRPR_AMT                                NUMBER(18,2)   -- �׸鰡�ݾ�
  ,LDGR_RMD                                NUMBER(20,2)  -- �����ܾ�
  ,NW_DT                                   VARCHAR2(8)
  ,USR_NO                                  VARCHAR2(10)  -- �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������12               IS 'OPE_KRI_��������������12';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.CRWR_DESC    IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.IMCW_NO      IS '�߿�������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.PRPR_AMT     IS '�׸鰡�ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.LDGR_RMD     IS '�����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������12.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������12 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������12 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������12 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������12 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������12 TO RL_OPE_SEL;

EXIT
