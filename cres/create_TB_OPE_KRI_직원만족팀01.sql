DROP TABLE OPEOWN.TB_OPE_KRI_����������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,DCM_DTT                                  VARCHAR2(1)
  ,DCM_NO                                   VARCHAR2(100)
  ,DCM_TLT                                  VARCHAR2(100)
  ,DCD_RQST_DT                              VARCHAR2(8)
  ,DCD_RQMR_NM                              VARCHAR2(100)
  ,DCDR_NM                                  VARCHAR2(100)
  ,DCD_ARV_DT                               VARCHAR2(8)
  ,DCD_TMNT_DT                              VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������01               IS 'OPE_KRI_����������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.BR_NM         IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.DCM_DTT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.DCM_NO        IS '������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.DCM_TLT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.DCD_RQST_DT   IS '�����Ƿ�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.DCD_RQMR_NM   IS '�����û�ڸ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.DCDR_NM       IS '�����ڸ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.DCD_ARV_DT    IS '���絵������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������01.DCD_TMNT_DT   IS '������������';

GRANT SELECT ON TB_OPE_KRI_����������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������01 TO RL_OPE_SEL;

EXIT
