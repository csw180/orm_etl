DROP TABLE OPEOWN.TB_OPE_KRI_������ȣ��01;

CREATE TABLE OPEOWN.TB_OPE_KRI_������ȣ��01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BR_NM                                    VARCHAR2(100)
  ,USR_NM                                   VARCHAR2(100)
  ,USR_ID                                   VARCHAR2(10)
  ,FL_CNT                                   NUMBER(10)
  ,PTR_CNT                                  NUMBER(10)
  ,ADTG_TP                                  VARCHAR2(1)  -- �˻�����
  ,ADTG_DT                                  VARCHAR2(8)   -- �˻�Ϸ���
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_������ȣ��01              IS 'OPE_KRI_������ȣ��01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��01.USR_NM       IS '����ڸ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��01.USR_ID       IS '�����ID';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��01.FL_CNT       IS '���ϼ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��01.PTR_CNT      IS '���ϼ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��01.ADTG_TP      IS '�˻�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������ȣ��01.ADTG_DT      IS '�˻�����';

GRANT SELECT ON TB_OPE_KRI_������ȣ��01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_������ȣ��01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_������ȣ��01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_������ȣ��01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_������ȣ��01 TO RL_OPE_SEL;

EXIT
