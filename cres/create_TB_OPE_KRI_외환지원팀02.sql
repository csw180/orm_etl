DROP TABLE OPEOWN.TB_OPE_KRI_��ȯ������02;

CREATE TABLE OPEOWN.TB_OPE_KRI_��ȯ������02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ADRE_EN_NM                              VARCHAR2(35)   -- �����θ�
  ,ADRE_FRNW_ACNO                          VARCHAR2(35)   -- �����ΰ��¹�ȣ
  ,REF_NO                                  VARCHAR2(20)   --REFNO
  ,TR_DT                                   VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)    --��ȭ�ڵ�
  ,OWMN_AMT                                NUMBER(18,2)   --��߼۱ݱݾ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��ȯ������02               IS 'OPE_KRI_��ȯ������02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������02.BRNO             IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������02.BR_NM            IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������02.ADRE_EN_NM       IS '�����ο�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������02.ADRE_FRNW_ACNO   IS '�����οܽŰ��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������02.REF_NO           IS 'REF��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������02.TR_DT            IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������02.CRCD             IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������02.OWMN_AMT         IS '��߼۱ݱݾ�';

GRANT SELECT ON TB_OPE_KRI_��ȯ������02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��ȯ������02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��ȯ������02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��ȯ������02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��ȯ������02 TO RL_OPE_SEL;

EXIT
