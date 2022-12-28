DROP TABLE OPEOWN.TB_OPE_KRI_��������������26;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������26
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ASP_ACNO                                VARCHAR2(12)  -- ���ܰ��¹�ȣ
  ,ASP_TXIM_KDCD                           VARCHAR2(2)   -- ���ܼ��������ڵ�
  ,ROM_DT                                  VARCHAR2(8)   -- �Ա�����
  ,DFRY_DT                                 VARCHAR2(8)   -- ��������
  ,DFRY_AMT                                NUMBER(18,2)  -- ���ޱݾ�
  ,USR_NO                                  VARCHAR2(10)  -- ����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������26               IS 'OPE_KRI_��������������26';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������26.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������26.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������26.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������26.ASP_ACNO     IS '���ܰ��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������26.ASP_TXIM_KDCD  IS '���ܼ��������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������26.ROM_DT       IS '�Ա�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������26.DFRY_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������26.DFRY_AMT     IS '���ޱݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������26.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������26 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������26 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������26 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������26 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������26 TO RL_OPE_SEL;

EXIT
