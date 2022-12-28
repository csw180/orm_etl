DROP TABLE OPEOWN.TB_OPE_KRI_ī�帶������01;

CREATE TABLE OPEOWN.TB_OPE_KRI_ī�帶������01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CRD_MBR_NO                              VARCHAR2(9)   -- ī��ȸ����ȣ
  ,CRD_PRD_DSCD                            VARCHAR2(2)   -- ī���ǰ�����ڵ�
--  ,CRD_PRD_DSCD_NM                         VARCHAR2(100)   -- ī���ǰ�����ڵ��
  ,ACD_CMPN_ACP_DT                         VARCHAR2(8)   -- �������������
  ,ACD_TMNT_DT                             VARCHAR2(8)   -- �����������, ��å�����Ϸ�����
  ,RVN_WNA                                 NUMBER(15)    -- �����ȭ�ݾ�
  ,ACD_CMPN_TSK_CD                         VARCHAR2(2)   -- ���������ڵ�
--  ,ACD_CMPN_TSK_CD_NM                      VARCHAR2(100)   -- ���������ڵ��
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ī�帶������01              IS 'OPE_KRI_ī�帶������01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������01.BRNO               IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������01.BR_NM              IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������01.CRD_MBR_NO         IS 'ī��ȸ����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������01.CRD_PRD_DSCD       IS 'ī���ǰ�����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������01.ACD_CMPN_ACP_DT    IS '�������������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������01.ACD_TMNT_DT        IS '�����������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������01.RVN_WNA            IS '�����ȭ�ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ī�帶������01.ACD_CMPN_TSK_CD    IS '���������ڵ�';

GRANT SELECT ON TB_OPE_KRI_ī�帶������01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ī�帶������01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ī�帶������01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ī�帶������01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ī�帶������01 TO RL_OPE_SEL;

EXIT
