DROP TABLE OPEOWN.TB_OPE_KRI_����Ʈä����01;

CREATE TABLE OPEOWN.TB_OPE_KRI_����Ʈä����01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,OBS_TP_CD                                VARCHAR2(10)   -- ��������ڵ�
  ,OBS_ACP_DT                               VARCHAR2(8)    -- �����������
  ,CHNL_NM                                  VARCHAR2(30)   -- ä�θ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����Ʈä����01               IS 'OPE_KRI_����Ʈä����01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����Ʈä����01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����Ʈä����01.OBS_TP_CD    IS '��������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����Ʈä����01.OBS_ACP_DT   IS '�����������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����Ʈä����01.CHNL_NM      IS 'ä�θ�';

GRANT SELECT ON TB_OPE_KRI_����Ʈä����01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����Ʈä����01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����Ʈä����01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����Ʈä����01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����Ʈä����01 TO RL_OPE_SEL;

EXIT
