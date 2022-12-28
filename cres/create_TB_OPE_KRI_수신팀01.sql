DROP TABLE OPEOWN.TB_OPE_KRI_������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_������01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)   --  ���¹�ȣ
  ,DPS_TSK_CD                              VARCHAR2(4)  -- ���ž����ڵ�
  ,CRC_DT                                  VARCHAR2(8)  -- �����ŷ�����
  ,CNCL_DT                                 VARCHAR2(8)  -- ��Ұŷ�����
  ,DPS_TR_RCD_CTS                          VARCHAR2(100)  -- ���Űŷ���ϳ���
  ,USR_NO                                  VARCHAR2(10)  -- �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_������01               IS 'OPE_KRI_������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.DPS_TSK_CD       IS '���ž����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.CRC_DT           IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.CNCL_DT          IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.DPS_TR_RCD_CTS   IS '���Űŷ���ϳ���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_������01.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_������01 TO RL_OPE_SEL;

EXIT
