DROP TABLE OPEOWN.TB_OPE_KRI_��������������06;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������06
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,IMCW_SBCD                               VARCHAR2(3)   -- �߿����������ڵ�
  ,BNKB_ISN_RSCD                           VARCHAR2(1)   -- ����߱޻����ڵ�
  ,ENR_DT                                  VARCHAR2(8)   -- �������
  ,USR_NO                                  VARCHAR2(10)  -- ����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������06               IS 'OPE_KRI_��������������06';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������06.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������06.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������06.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������06.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������06.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������06.IMCW_SBCD    IS '�߿����������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������06.BNKB_ISN_RSCD    IS '����߱޻����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������06.ENR_DT       IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������06.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������06 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������06 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������06 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������06 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������06 TO RL_OPE_SEL;

EXIT
