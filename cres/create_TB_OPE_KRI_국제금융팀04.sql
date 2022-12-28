DROP TABLE OPEOWN.TB_OPE_KRI_����������04;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������04
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
--  ,SUMMIT_TR_ID                            VARCHAR2(10)   --  SUMMIT�ŷ�ID
  ,ITF_TR_DSCD                             VARCHAR2(6)    --  ���������ŷ������ڵ�
--  ,PCSL_DSCD                               VARCHAR2(1)  -- ���Ըŵ������ڵ�
  ,TR_DT                                   VARCHAR2(8)    --  �ŷ�����
  ,PCH_AMT                                 NUMBER(18,2)   --  ���Աݾ�
  ,PCH_CRCD                                VARCHAR2(3)    --  ������ȭ
  ,USR_NO                                  VARCHAR2(10)   -- ����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������04               IS 'OPE_KRI_����������04';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������04.STD_DT        IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������04.BRNO          IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������04.BR_NM         IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������04.ITF_TR_DSCD   IS '���������ŷ������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������04.TR_DT         IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������04.PCH_AMT       IS '���Աݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������04.PCH_CRCD      IS '������ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������04.USR_NO        IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_����������04 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������04 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������04 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������04 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������04 TO RL_OPE_SEL;

EXIT
