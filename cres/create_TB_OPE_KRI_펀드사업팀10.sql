DROP TABLE OPEOWN.TB_OPE_KRI_�ݵ�����10;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ݵ�����10
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,ROP_YN                                  VARCHAR2(1)     --���ǿ���
  ,TR_DT                                   VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_�ݵ�����10                 IS 'OPE_KRI_�ݵ�����10';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����10.STD_DT          IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����10.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����10.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����10.ACNO            IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����10.CUST_NO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����10.ROP_YN          IS '���ǿ���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����10.TR_DT           IS '�ŷ�����';

GRANT SELECT ON TB_OPE_KRI_�ݵ�����10 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ݵ�����10 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ݵ�����10 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ݵ�����10 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ݵ�����10 TO RL_OPE_SEL;

EXIT
