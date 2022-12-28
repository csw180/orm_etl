DROP TABLE OPEOWN.TB_OPE_KRI_�λ���01;

CREATE TABLE OPEOWN.TB_OPE_KRI_�λ���01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,EMP_DTT                                 VARCHAR2(8)  -- ���������ڵ�
  ,EMP_DTT_NM                              VARCHAR2(20)  -- �������и�
  ,EMP_NO                                  VARCHAR2(10)  -- ���
  ,RTRM_DT                                 VARCHAR2(8)  -- �����
  ,RTRM_YN                                 VARCHAR2(1)  -- ��������
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�λ���01               IS 'OPE_KRI_�λ���01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�λ���01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�λ���01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�λ���01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�λ���01.EMP_DTT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�λ���01.EMP_DTT_NM   IS '�������и�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�λ���01.EMP_NO       IS '������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�λ���01.RTRM_DT      IS '������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�λ���01.RTRM_YN      IS '��������';

GRANT SELECT ON TB_OPE_KRI_�λ���01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�λ���01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�λ���01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�λ���01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�λ���01 TO RL_OPE_SEL;

EXIT
