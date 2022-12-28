DROP TABLE OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01;

CREATE TABLE OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,SYS_ERLR_JDGM_GDCD                      VARCHAR2(2)  -- �ý�������溸��������ڵ�
  ,TGT_ABST_DT                             VARCHAR2(8)  -- �����������
--  ,ERLR_JDGM_RSN                           VARCHAR2(4000)  --  ����溸��������
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01                 IS 'OPE_KRI_���ڱ����ɻ���01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01.STD_DT          IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01.CUST_NO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01.SYS_ERLR_JDGM_GDCD    IS '�ý�������溸��������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01.TGT_ABST_DT     IS '�����������';

GRANT SELECT ON TB_OPE_KRI_���ڱ����ɻ���01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_���ڱ����ɻ���01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_���ڱ����ɻ���01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_���ڱ����ɻ���01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_���ڱ����ɻ���01 TO RL_OPE_SEL;

EXIT
