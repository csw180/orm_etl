DROP TABLE OPEOWN.TB_OPE_KRI_�ݵ�����12;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ݵ�����12
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,BLN_PCPL                                NUMBER(15)    -- �ܰ����
  ,PRD_KR_NM                               VARCHAR2(100)  -- ��ǰ�ѱ۸�
  ,KI_AMT                                  NUMBER(15)    -- ���αݾ�
  ,KI_OCC_DT                               VARCHAR2(8)   -- ���ι߻�����
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_�ݵ�����12                 IS 'OPE_KRI_�ݵ�����12';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����12.STD_DT          IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����12.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����12.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����12.ACNO            IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����12.CUST_NO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����12.BLN_PCPL        IS '�ܰ����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����12.PRD_KR_NM       IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����12.KI_AMT          IS '���αݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ݵ�����12.KI_OCC_DT       IS '���ι߻�����';

GRANT SELECT ON TB_OPE_KRI_�ݵ�����12 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ݵ�����12 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ݵ�����12 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ݵ�����12 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ݵ�����12 TO RL_OPE_SEL;

EXIT
