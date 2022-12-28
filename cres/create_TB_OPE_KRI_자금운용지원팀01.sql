DROP TABLE OPEOWN.TB_OPE_KRI_�ڱݿ��������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ڱݿ��������01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
--  ,TR_DT                                    VARCHAR2(8)   -- �ŷ�����
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,DLN_STLM_NO                              NUMBER(9)     -- �ŸŰ�����ȣ
  ,EXPI_DT                                  VARCHAR2(8)   -- ��������
  ,STLM_DT                                  VARCHAR2(8)   -- ��������
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�ڱݿ��������01               IS 'OPE_KRI_�ڱݿ��������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݿ��������01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݿ��������01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݿ��������01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݿ��������01.DLN_STLM_NO  IS '�ŸŰ�����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݿ��������01.EXPI_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ڱݿ��������01.STLM_DT      IS '��������';

GRANT SELECT ON TB_OPE_KRI_�ڱݿ��������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ڱݿ��������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ڱݿ��������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ڱݿ��������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ڱݿ��������01 TO RL_OPE_SEL;

EXIT
