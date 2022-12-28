DROP TABLE OPEOWN.TB_OPE_KRI_�ݵ�����14;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ݵ�����14
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,AGE                                     NUMBER(3)
  ,NW_DT                                   VARCHAR2(8)
  ,EXPI_DT                                 VARCHAR2(8)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,TR_AMT                                  NUMBER(18,2)  -- �ŷ��ݾ�
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_�ݵ�����14                 IS 'OPE_KRI_�ݵ�����14';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����14.STD_DT          IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����14.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����14.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����14.ACNO            IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����14.CUST_NO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����14.AGE             IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����14.NW_DT           IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����14.EXPI_DT         IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����14.PRD_KR_NM       IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����14.TR_AMT          IS '�ŷ��ݾ�';

GRANT SELECT ON TB_OPE_KRI_�ݵ�����14 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ݵ�����14 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ݵ�����14 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ݵ�����14 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ݵ�����14 TO RL_OPE_SEL;

EXIT
