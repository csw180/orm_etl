DROP TABLE OPEOWN.TB_OPE_KRI_��������������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)     -- ����ȣ
  ,ACNO                                    VARCHAR2(12)  --  ���¹�ȣ
  ,DRM_YN                                  VARCHAR2(1)   --  �޸鿩��
  ,OPRF_PCS_DT                             VARCHAR2(8)   --  �����ó������
  ,CRCD                                    VARCHAR2(3)   --  ��ȭ�ڵ�
  ,TR_PCPL                                 NUMBER(18,2)  --  �ŷ�����
  ,TR_DT                                   VARCHAR2(8)   --  �ŷ�����
  ,DPS_ACN_STCD                            VARCHAR2(2)   --  ���»����ڵ�
  ,USR_NO                                  VARCHAR2(10)  --  �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������01               IS 'OPE_KRI_��������������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.CUST_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.ACNO         IS '���¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.DRM_YN       IS '�޸鿩��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.OPRF_PCS_DT  IS '�����ó������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.TR_PCPL      IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.TR_DT        IS '�ŷ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.DPS_ACN_STCD IS '���Ű��»����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������01.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������01 TO RL_OPE_SEL;

EXIT
