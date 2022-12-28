DROP TABLE OPEOWN.TB_OPE_KRI_�����ȹ��01;

CREATE TABLE OPEOWN.TB_OPE_KRI_�����ȹ��01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,EXE_NO                                   VARCHAR2(14)   -- ����ǽù�ȣ
  ,PTO_SNO                                  NUMBER(4)      -- �����Ϸù�ȣ
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,PTO_NO                                   VARCHAR2(14)   -- ������ȣ
  ,PTO_DTT_CD_NM                            VARCHAR2(256)  -- ���������ڵ��  
  ,OCC_DT                                   VARCHAR2(8)    -- �߻�����
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�����ȹ��01                       IS 'OPE_KRI_�����ȹ��01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����ȹ��01.STD_DT                IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����ȹ��01.EXE_NO                IS '�����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����ȹ��01.PTO_SNO               IS '�����Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����ȹ��01.BRNO                  IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����ȹ��01.BR_NM                 IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����ȹ��01.PTO_NO                IS '������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����ȹ��01.PTO_DTT_CD_NM         IS '���������ڵ��';  
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����ȹ��01.OCC_DT                IS '�߻�����';  

GRANT SELECT ON TB_OPE_KRI_�����ȹ��01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�����ȹ��01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�����ȹ��01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�����ȹ��01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�����ȹ��01 TO RL_OPE_SEL;

EXIT
