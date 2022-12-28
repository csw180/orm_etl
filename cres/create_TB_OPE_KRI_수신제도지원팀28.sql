DROP TABLE OPEOWN.TB_OPE_KRI_��������������28;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������28
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,INTG_ACNO                               VARCHAR2(35)  -- ���հ��¹�ȣ
  ,ONL_DT                                  VARCHAR2(8)   -- �߱�����
  ,USR_NO                                  VARCHAR2(10)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������28               IS 'OPE_KRI_��������������28';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������28.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������28.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������28.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������28.INTG_ACNO    IS '���հ��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������28.ONL_DT       IS '�¶�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������28.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������28 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������28 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������28 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������28 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������28 TO RL_OPE_SEL;

EXIT
