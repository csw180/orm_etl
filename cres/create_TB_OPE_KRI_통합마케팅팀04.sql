DROP TABLE OPEOWN.TB_OPE_KRI_���ո�������04;

CREATE TABLE OPEOWN.TB_OPE_KRI_���ո�������04
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CRM_GD                                  VARCHAR2(2)
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_���ո�������04                 IS 'OPE_KRI_���ո�������04';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������04.STD_DT          IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������04.BRNO            IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������04.BR_NM           IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������04.CUST_NO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_���ո�������04.CRM_GD          IS 'CRM���';

GRANT SELECT ON TB_OPE_KRI_���ո�������04 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_���ո�������04 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_���ո�������04 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_���ո�������04 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_���ո�������04 TO RL_OPE_SEL;

EXIT
