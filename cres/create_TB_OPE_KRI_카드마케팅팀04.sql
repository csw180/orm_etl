DROP TABLE OPEOWN.TB_OPE_KRI_ī�帶������04;

CREATE TABLE OPEOWN.TB_OPE_KRI_ī�帶������04
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ISN_DT                                  VARCHAR2(8)   -- ī��߱�����
  ,SHPP_RQS_DT                             VARCHAR2(8)   -- ī��߼�����
  ,SNBK_DT                                 VARCHAR2(8)   -- �ݼ�����
  ,SPXP_SNBK_RSCD                          VARCHAR2(2)   -- Ư�۹ݼۻ����ڵ�
--  ,SPXP_SNBK_RS_NM                         VARCHAR2(100)   -- Ư�۹ݼۻ�����
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ī�帶������04              IS 'OPE_KRI_ī�帶������04';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������04.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������04.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������04.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������04.ISN_DT       IS '�߱�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������04.SHPP_RQS_DT  IS '��ۿ�û����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������04.SNBK_DT      IS '�ݼ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������04.SPXP_SNBK_RSCD IS 'Ư�۹ݼۻ����ڵ�';

GRANT SELECT ON TB_OPE_KRI_ī�帶������04 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ī�帶������04 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ī�帶������04 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ī�帶������04 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ī�帶������04 TO RL_OPE_SEL;

EXIT
