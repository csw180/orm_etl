DROP TABLE OPEOWN.TB_OPE_KRI_�ݵ�����07;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ݵ�����07
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,NW_DT                                   VARCHAR2(8)
  ,ACNO                                    VARCHAR2(12)
  ,PRD_KR_NM                               VARCHAR2(100)  -- ��ǰ�ѱ۸�
  ,CUST_NO                                 NUMBER(9)
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_�ݵ�����07                 IS 'OPE_KRI_�ݵ�����07';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����07.STD_DT          IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����07.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����07.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����07.NW_DT           IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����07.ACNO            IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����07.PRD_KR_NM       IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����07.CUST_NO         IS '����ȣ';

GRANT SELECT ON TB_OPE_KRI_�ݵ�����07 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ݵ�����07 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ݵ�����07 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ݵ�����07 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ݵ�����07 TO RL_OPE_SEL;

EXIT
