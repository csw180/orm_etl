DROP TABLE OPEOWN.TB_OPE_KRI_��������������27;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������27
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ASP_ACNO                                VARCHAR2(12)  -- ���ܰ��¹�ȣ
  ,ASP_TXIM_KDCD                           VARCHAR2(2)   -- ���ܼ��������ڵ�
  ,ROM_DT                                  VARCHAR2(8)   -- �Ա�����
  ,DFRY_DT                                 VARCHAR2(8)   -- ��������
  ,USR_NO                                  VARCHAR2(10)  -- ��ϻ���ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������27               IS 'OPE_KRI_��������������27';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������27.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������27.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������27.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������27.ASP_ACNO     IS '���ܰ��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������27.ASP_TXIM_KDCD   IS '���ܼ��������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������27.ROM_DT       IS '�Ա�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������27.DFRY_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������27.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������27 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������27 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������27 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������27 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������27 TO RL_OPE_SEL;

EXIT
