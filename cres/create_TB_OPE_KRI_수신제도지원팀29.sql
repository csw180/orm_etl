DROP TABLE OPEOWN.TB_OPE_KRI_��������������29;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������29
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CSNT_ACNO                               VARCHAR2(12)   -- �����������¹�ȣ
  ,TR_DSCD_NM                              VARCHAR2(8)    -- �ŷ����и�
  ,TR_DT                                   VARCHAR2(8)    -- ��ȯ����
  ,USR_NO                                  VARCHAR2(10)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������29               IS 'OPE_KRI_��������������29';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������29.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������29.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������29.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������29.CSNT_ACNO    IS '�����������¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������29.TR_DSCD_NM   IS '�ŷ������ڵ��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������29.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������29.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������29 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������29 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������29 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������29 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������29 TO RL_OPE_SEL;

EXIT
