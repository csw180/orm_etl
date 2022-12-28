DROP TABLE OPEOWN.TB_OPE_KRI_����������17;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������17
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)  
  ,CUST_DSCD_NM                            VARCHAR2(10)
  ,CHB_DAT_CTS                             VARCHAR2(1000)
  ,CHA_DAT_CTS                             VARCHAR2(1000)
  ,ENR_DT                                  VARCHAR2(8)
  ,CSLT_DT                                 VARCHAR2(8)  -- ��û����(ǰ������)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,CRCD                                    VARCHAR2(3)
  ,APRV_AMT	                               NUMBER(18,2)  -- ���αݾ�
  ,USR_NO                                  VARCHAR2(10)  
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������17               IS 'OPE_KRI_����������17';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.CUST_DSCD_NM IS '�������ڵ��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.CHB_DAT_CTS  IS '�����������ͳ���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.CHA_DAT_CTS  IS '�����ĵ����ͳ���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.ENR_DT       IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.CSLT_DT      IS 'ǰ������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.APRV_AMT	    IS '���αݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������17.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_����������17 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������17 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������17 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������17 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������17 TO RL_OPE_SEL;

EXIT
