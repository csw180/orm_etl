DROP TABLE OPEOWN.TB_OPE_KRI_��������������31;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������31
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CSNT_ACNO                               VARCHAR2(12)   -- �����������¹�ȣ
  ,TKCT_DT                                 VARCHAR2(8)    -- ��Ź����
  ,DFRY_DT                                 VARCHAR2(8)    -- ��������
  ,DLVY_DT                                 VARCHAR2(8)    -- �������
  ,NML_PCS_YN                              VARCHAR2(1)    -- ����ó������
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������31               IS 'OPE_KRI_��������������31';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������31.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������31.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������31.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������31.CSNT_ACNO    IS '�����������¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������31.TKCT_DT      IS '��Ź����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������31.DFRY_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������31.DLVY_DT      IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������31.NML_PCS_YN   IS '����ó������';

GRANT SELECT ON TB_OPE_KRI_��������������31 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������31 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������31 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������31 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������31 TO RL_OPE_SEL;

EXIT
