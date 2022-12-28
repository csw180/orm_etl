DROP TABLE OPEOWN.TB_OPE_KRI_����������02;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  --,SUMMIT_TR_ID                            VARCHAR2(10)   --  SUMMIT�ŷ�ID
  ,ITF_TR_DSCD                             VARCHAR2(6)    --  ���������ŷ������ڵ�
  ,PCSL_DSCD                               VARCHAR2(1)  -- ���Ըŵ������ڵ�
  ,TR_DT                                   VARCHAR2(8)    --  �ŷ�����
  ,TR_AMT                                  NUMBER(18,2)   --  �ŷ��ݾ�
  ,CRCD                                    VARCHAR2(3)    --  ��ȭ�ڵ�
  ,USR_NO                                  VARCHAR2(10)   -- ����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������02                    IS 'OPE_KRI_����������02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.STD_DT             IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.BRNO               IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.BR_NM              IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.ITF_TR_DSCD        IS '���������ŷ������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.PCSL_DSCD          IS '���Ըŵ������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.TR_DT              IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.TR_AMT             IS '�ŷ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.CRCD               IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������02.USR_NO             IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_����������02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������02 TO RL_OPE_SEL;

EXIT
