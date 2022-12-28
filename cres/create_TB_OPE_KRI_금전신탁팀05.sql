DROP TABLE OPEOWN.TB_OPE_KRI_������Ź��05;

CREATE TABLE OPEOWN.TB_OPE_KRI_������Ź��05
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,ACNO                                    VARCHAR2(12)
  ,NW_DT                                   VARCHAR2(8)
  ,EXPI_DT                                 VARCHAR2(8)
  ,PRD_KR_NM                               VARCHAR2(100)   -- ��ǰ��  
  ,PAR_AMT                                 NUMBER(18,2)    -- �׸�ݾ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_������Ź��05               IS 'OPE_KRI_������Ź��05';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��05.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��05.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��05.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��05.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��05.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��05.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��05.EXPI_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��05.PRD_KR_NM    IS '��ǰ�ѱ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������Ź��05.PAR_AMT      IS '�׸�ݾ�';

GRANT SELECT ON TB_OPE_KRI_������Ź��05 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_������Ź��05 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_������Ź��05 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_������Ź��05 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_������Ź��05 TO RL_OPE_SEL;

EXIT
