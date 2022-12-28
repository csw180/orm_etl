DROP TABLE OPEOWN.TB_OPE_KRI_���������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_���������01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
--  ,CUST_NO                                 NUMBER(9)
  ,TCH_EVL_BRN                             NUMBER(10)     -- ����򰡻���ڵ�Ϲ�ȣ
--  ,CUST_DSCD                               VARCHAR2(2)
  ,STDD_INDS_CLCD                          VARCHAR2(5)    -- ǥ�ػ���з��ڵ�
  ,TCH_EVL_APC_DT                          VARCHAR2(8)    -- ����򰡽�û����
--  ,TCH_YN                                  VARCHAR2(1)
  ,EXCP_YN                                 VARCHAR2(1)    -- ���ܿ���
  ,TCH_EVL_EXCP_ENR_RSCD                   VARCHAR2(2)    -- ����򰡿��ܵ�ϻ����ڵ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_���������01               IS 'OPE_KRI_���������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������01.BRNO          IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������01.BR_NM         IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������01.TCH_EVL_BRN   IS '����򰡻���ڵ�Ϲ�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������01.STDD_INDS_CLCD    IS 'ǥ�ػ���з��ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������01.TCH_EVL_APC_DT    IS '����򰡽�û����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������01.EXCP_YN           IS '���ܿ���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���������01.TCH_EVL_EXCP_ENR_RSCD    IS '����򰡿��ܵ�ϻ����ڵ�';

GRANT SELECT ON TB_OPE_KRI_���������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_���������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_���������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_���������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_���������01 TO RL_OPE_SEL;

EXIT
