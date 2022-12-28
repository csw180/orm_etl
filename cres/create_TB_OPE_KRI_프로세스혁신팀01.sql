DROP TABLE OPEOWN.TB_OPE_KRI_���μ���������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_���μ���������01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,TR_DT                                   VARCHAR2(8)
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,WND_DTT                                 VARCHAR2(20)    -- â������
  ,TR_DTT                                  VARCHAR2(10)    -- �ŷ�����
  ,USER_NO                                 VARCHAR2(10)     --����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_���μ���������01                 IS 'OPE_KRI_���μ���������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���μ���������01.STD_DT          IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���μ���������01.TR_DT           IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���μ���������01.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���μ���������01.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���μ���������01.WND_DTT         IS 'â������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���μ���������01.TR_DTT          IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���μ���������01.USER_NO         IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_���μ���������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_���μ���������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_���μ���������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_���μ���������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_���μ���������01 TO RL_OPE_SEL;

EXIT
