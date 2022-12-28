DROP TABLE OPEOWN.TB_OPE_KRI_��ȯ������04;

CREATE TABLE OPEOWN.TB_OPE_KRI_��ȯ������04
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,TR_DT                                   VARCHAR2(8)
  ,ARN_DT                                  VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)    --��ȭ�ڵ�
  ,FCA                                     NUMBER(18,2)
  ,REF_NO                                  VARCHAR2(20)   --REFNO
  ,ACCR_DCNT                               NUMBER(10)     --����ϼ�
  ,TLR_NO                                  VARCHAR2(10)   --�ڷ���ȣ
  ,ARN_CMPL_YN                             VARCHAR2(1)    --�����ϷῩ��
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��ȯ������04               IS 'OPE_KRI_��ȯ������04';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.ARN_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.FCA          IS '��ȭ�ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.REF_NO       IS 'REF��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.ACCR_DCNT    IS '����ϼ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.TLR_NO       IS '�ڷ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������04.ARN_CMPL_YN  IS '�����ϷῩ��';

GRANT SELECT ON TB_OPE_KRI_��ȯ������04 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��ȯ������04 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��ȯ������04 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��ȯ������04 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��ȯ������04 TO RL_OPE_SEL;

EXIT
