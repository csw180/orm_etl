DROP TABLE OPEOWN.TB_OPE_KRI_��������������14;

CREATE TABLE OPEOWN.TB_OPE_KRI_��������������14
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,SFDP_SNO                                VARCHAR2(18)   -- ����ȣ(4)+��ȣ�����⵵(4)_��ȣ�����Ϸù�ȣ(10)
  ,SFDP_PRD_NM                             VARCHAR2(100)  -- ��ȣ������ǰ��
  ,DNC_AMT                                 NUMBER(18,2)   -- ��ȣ�����ݾ�
  ,NW_DT                                   VARCHAR2(8)    -- ��ȣ������������
  ,EXPI_DT                                 VARCHAR2(8)    -- ��ȣ������������
  ,ACCR_DCNT                               NUMBER(10)     -- ����ϼ�
  ,USR_NO                                  VARCHAR2(10)   -- �ŷ�����ڹ�ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_��������������14               IS 'OPE_KRI_��������������14';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������14.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������14.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������14.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������14.SFDP_SNO     IS '��ȣ�����Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������14.SFDP_PRD_NM  IS '��ȣ������ǰ��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������14.DNC_AMT      IS '�����ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������14.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������14.EXPI_DT      IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������14.ACCR_DCNT    IS '����ϼ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_��������������14.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_��������������14 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_��������������14 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_��������������14 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_��������������14 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_��������������14 TO RL_OPE_SEL;

EXIT
