DROP TABLE OPEOWN.TB_OPE_KRI_�ع�������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ع�������01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,DPS_DP_DSCD                             VARCHAR2(1)    -- ���ſ��ݱ����ڵ�
  ,NW_DT                                   VARCHAR2(8)
  ,LDGR_RMD                                NUMBER(20, 2)
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_�ع�������01              IS 'OPE_KRI_�ع�������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������01.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������01.DPS_DP_DSCD  IS '���ſ��ݱ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������01.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������01.LDGR_RMD     IS '�����ܾ�';

GRANT SELECT ON TB_OPE_KRI_�ع�������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ع�������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ع�������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ع�������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ع�������01 TO RL_OPE_SEL;

EXIT
