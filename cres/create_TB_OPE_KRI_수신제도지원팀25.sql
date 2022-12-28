DROP TABLE OPEOWN.TB_OPE_KRI_��������������25;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������25
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,LDGR_RMD                                NUMBER(20, 2)
  ,NW_DT                                   VARCHAR2(8)
  ,TR_DT                                   VARCHAR2(8)
  ,USR_NO                                  VARCHAR2(10)  -- �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������25               IS 'OPE_KRI_��������������25';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������25.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������25.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������25.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������25.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������25.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������25.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������25.LDGR_RMD     IS '�����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������25.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������25.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������25.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������25 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������25 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������25 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������25 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������25 TO RL_OPE_SEL;

EXIT
