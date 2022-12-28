DROP TABLE OPEOWN.TB_OPE_KRI_�ع�������02;

CREATE TABLE OPEOWN.TB_OPE_KRI_�ع�������02
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,LWS_NO                                   VARCHAR2(20)    -- �Ҽ۹�ȣ
  --,LWS_DTT                                  VARCHAR2(4)     -- �Ҽ۱���(����, �ǰ�)
  ,LWS_NM                                   VARCHAR2(1000)  -- �Ҽ۳���
  ,LWS_AMT                                  NUMBER(18,2)    -- �Ҽ۱ݾ�
  ,ACP_DT                                   VARCHAR2(8)   -- ��������
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_�ع�������02              IS 'OPE_KRI_�ع�������02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������02.LWS_NO       IS '�Ҽ۹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������02.LWS_NM       IS '�Ҽ۸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������02.LWS_AMT      IS '�Ҽ۱ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�ع�������02.ACP_DT       IS '��������';

GRANT SELECT ON TB_OPE_KRI_�ع�������02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�ع�������02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�ع�������02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�ع�������02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�ع�������02 TO RL_OPE_SEL;

EXIT
