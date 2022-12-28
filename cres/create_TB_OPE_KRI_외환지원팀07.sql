DROP TABLE OPEOWN.TB_OPE_KRI_��ȯ������07;

CREATE TABLE OPEOWN.TB_OPE_KRI_��ȯ������07
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NM                                 VARCHAR2(100)
  ,REF_NO                                  VARCHAR2(20)
  ,CRCD                                    VARCHAR2(3)    --��ȭ�ڵ�
  ,PCH_AMT                                 NUMBER(18,2)  -- �����׸鰡
  ,ANT_EXPI_DT                             VARCHAR2(8)   -- ��������������
  ,LST_EXPI_DT                             VARCHAR2(8)   -- ����Ȯ��������
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��ȯ������07               IS 'OPE_KRI_��ȯ������07';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������07.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������07.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������07.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������07.CUST_NM      IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������07.REF_NO       IS 'REF��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������07.CRCD         IS '��ȭ�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������07.PCH_AMT      IS '���Աݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������07.ANT_EXPI_DT  IS '���󸸱�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��ȯ������07.LST_EXPI_DT  IS '������������';

GRANT SELECT ON TB_OPE_KRI_��ȯ������07 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��ȯ������07 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��ȯ������07 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��ȯ������07 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��ȯ������07 TO RL_OPE_SEL;

EXIT
