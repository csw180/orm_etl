DROP TABLE OPEOWN.TB_OPE_KRI_��������������20;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������20
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,DPS_ACN_STCD                            VARCHAR2(2)
--  ,NW_DT                                   VARCHAR2(8)
  ,LST_TR_DT                               VARCHAR2(8)
  ,LDGR_RMD                                NUMBER(20,2)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������20               IS 'OPE_KRI_��������������20';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������20.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������20.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������20.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������20.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������20.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������20.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������20.DPS_ACN_STCD IS '���Ű��»����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������20.LST_TR_DT    IS '�����ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������20.LDGR_RMD     IS '�����ܾ�';

GRANT SELECT ON TB_OPE_KRI_��������������20 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������20 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������20 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������20 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������20 TO RL_OPE_SEL;

EXIT
