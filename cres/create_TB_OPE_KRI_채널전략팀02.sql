DROP TABLE OPEOWN.TB_OPE_KRI_ä��������02;

CREATE TABLE OPEOWN.TB_OPE_KRI_ä��������02
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,CNTT_DTT_CD                              VARCHAR2(4)  -- ��౸���ڵ�
  ,CNTT_NO                                  VARCHAR2(25)
  ,CNTT_NM                                  VARCHAR2(200)
  ,CNTT_DT                                  VARCHAR2(8)
  ,CNTT_AMT                                 NUMBER(22)
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ä��������02              IS 'OPE_KRI_ä��������02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ä��������02.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ä��������02.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ä��������02.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ä��������02.CNTT_DTT_CD  IS '��౸���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ä��������02.CNTT_NO      IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ä��������02.CNTT_NM      IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ä��������02.CNTT_DT      IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ä��������02.CNTT_AMT     IS '���ݾ�';

GRANT SELECT ON TB_OPE_KRI_ä��������02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ä��������02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ä��������02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ä��������02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ä��������02 TO RL_OPE_SEL;

EXIT
