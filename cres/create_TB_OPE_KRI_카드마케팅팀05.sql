DROP TABLE OPEOWN.TB_OPE_KRI_ī�帶������05;

CREATE TABLE OPEOWN.TB_OPE_KRI_ī�帶������05
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ISN_DT                                  VARCHAR2(8)   -- ī��߱�����
  ,SNDG_DT                                 VARCHAR2(8)   -- ī��߼�����
  ,BR_ACP_DT                               VARCHAR2(8)   -- ����������
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ī�帶������05              IS 'OPE_KRI_ī�帶������05';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������05.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������05.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������05.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������05.ISN_DT       IS '�߱�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������05.SNDG_DT      IS '�߼�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������05.BR_ACP_DT    IS '����������';

GRANT SELECT ON TB_OPE_KRI_ī�帶������05 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ī�帶������05 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ī�帶������05 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ī�帶������05 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ī�帶������05 TO RL_OPE_SEL;

EXIT
