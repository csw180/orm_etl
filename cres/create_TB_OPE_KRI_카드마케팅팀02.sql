DROP TABLE OPEOWN.TB_OPE_KRI_ī�帶������02;

CREATE TABLE OPEOWN.TB_OPE_KRI_ī�帶������02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  --,CRD_NO                                  VARCHAR2(16)
  ,CRD_PRD_DSCD                            VARCHAR2(2)   -- ī�屸��
  --,CRD_PRD_DSCD_NM                         VARCHAR2(40)   -- ī�屸�и�
  ,ISN_DT                                  VARCHAR2(8)   -- ī��߱�����
  ,SHPP_RQS_DT                             VARCHAR2(8)    -- ��ۿ�û����
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ī�帶������02              IS 'OPE_KRI_ī�帶������02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������02.CRD_PRD_DSCD IS 'ī���ǰ�����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������02.ISN_DT       IS '�߱�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������02.SHPP_RQS_DT  IS '��ۿ�û����';

GRANT SELECT ON TB_OPE_KRI_ī�帶������02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ī�帶������02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ī�帶������02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ī�帶������02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ī�帶������02 TO RL_OPE_SEL;

EXIT
