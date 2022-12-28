DROP TABLE OPEOWN.TB_OPE_KRI_��������������16;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������16
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,LDGR_RMD                                NUMBER(20,2)  -- �����ܾ�
  ,NW_DT                                   VARCHAR2(8)
  ,EXPI_DT                                 VARCHAR2(8)
  ,ACCR_DCNT                               NUMBER(10)   -- ����ϼ�
  ,CNCN_DT                                 VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������16               IS 'OPE_KRI_��������������16';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������16.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������16.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������16.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������16.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������16.LDGR_RMD     IS '�����ܾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������16.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������16.EXPI_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������16.ACCR_DCNT    IS '����ϼ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������16.CNCN_DT      IS '��������';

GRANT SELECT ON TB_OPE_KRI_��������������16 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������16 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������16 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������16 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������16 TO RL_OPE_SEL;

EXIT
