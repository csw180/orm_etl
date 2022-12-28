DROP TABLE OPEOWN.TB_OPE_KRI_��ȯ������08;

CREATE TABLE OPEOWN.TB_OPE_KRI_��ȯ������08
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,REF_NO                                  VARCHAR2(20)
  ,ACP_DT                                  VARCHAR2(8)
  ,LC_ADC_PGRS_STCD                        VARCHAR2(1)
  ,USR_NO                                  VARCHAR2(10)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��ȯ������08               IS 'OPE_KRI_��ȯ������08';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������08.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������08.BRNO              IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������08.BR_NM             IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������08.REF_NO            IS 'REF��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������08.ACP_DT            IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������08.LC_ADC_PGRS_STCD  IS '�ſ���������������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������08.USR_NO            IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��ȯ������08 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��ȯ������08 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��ȯ������08 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��ȯ������08 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��ȯ������08 TO RL_OPE_SEL;

EXIT
