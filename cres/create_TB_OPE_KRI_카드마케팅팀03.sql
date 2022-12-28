DROP TABLE OPEOWN.TB_OPE_KRI_ī�帶������03;

CREATE TABLE OPEOWN.TB_OPE_KRI_ī�帶������03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CRD_PRD_DSCD                            VARCHAR2(2)   -- ī�屸��
--  ,CRD_PRD_DSCD_NM                         VARCHAR2(40)   -- ī�屸�и�
  ,ISN_DT                                  VARCHAR2(8)   -- ī��߱�����
  ,SNDG_DT                                 VARCHAR2(8)   -- ī��߼�����
  ,BR_ACP_DT                               VARCHAR2(8)    -- ������������������
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ī�帶������03              IS 'OPE_KRI_ī�帶������03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������03.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������03.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������03.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������03.CRD_PRD_DSCD IS 'ī���ǰ�����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������03.ISN_DT       IS '�߱�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������03.SNDG_DT      IS '�߼�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������03.BR_ACP_DT    IS '����������';

GRANT SELECT ON TB_OPE_KRI_ī�帶������03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ī�帶������03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ī�帶������03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ī�帶������03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ī�帶������03 TO RL_OPE_SEL;

EXIT
