DROP TABLE OPEOWN.TB_OPE_KRI_��ȯ������10;

CREATE TABLE OPEOWN.TB_OPE_KRI_��ȯ������10
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,REF_NO                                  VARCHAR2(20)   --REFNO
  ,LDGR_ENR_DT                             VARCHAR2(8)
  ,TR_DT                                   VARCHAR2(8)
  ,ARN_DT                                  VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)    --��ȭ�ڵ�
  ,FCA                                     NUMBER(18,2)
  ,ACCR_DCNT                               NUMBER(10)     --����ϼ�
  ,ARN_CMPL_YN                             VARCHAR2(1)    --�����ϷῩ��
  ,USR_NO                                  VARCHAR2(10)   --�ڷ���ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��ȯ������10               IS 'OPE_KRI_��ȯ������10';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.REF_NO       IS 'REF��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.LDGR_ENR_DT  IS '����������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.ARN_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.FCA          IS '��ȭ�ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.ACCR_DCNT    IS '����ϼ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.ARN_CMPL_YN  IS '�����ϷῩ��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������10.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��ȯ������10 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��ȯ������10 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��ȯ������10 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��ȯ������10 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��ȯ������10 TO RL_OPE_SEL;

EXIT
