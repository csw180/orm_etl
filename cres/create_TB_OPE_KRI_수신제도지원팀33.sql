DROP TABLE OPEOWN.TB_OPE_KRI_��������������33;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������33
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)  --  ���¹�ȣ
  ,TR_DT                                   VARCHAR2(8)  --  �ŷ�����
  ,USR_NO                                  VARCHAR2(10)   -- �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������33               IS 'OPE_KRI_��������������33';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������33.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������33.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������33.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������33.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������33.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������33.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������33 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������33 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������33 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������33 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������33 TO RL_OPE_SEL;

EXIT
