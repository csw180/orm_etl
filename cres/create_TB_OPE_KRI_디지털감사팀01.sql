DROP TABLE OPEOWN.TB_OPE_KRI_�����а�����01;

CREATE TABLE OPEOWN.TB_OPE_KRI_�����а�����01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,CHKG_DTT                                 VARCHAR2(1)   -- ���˱���
--  ,CHKG_DTT_NM                              VARCHAR2(10)   -- ���˱��и�
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,ONL_DT                                   VARCHAR2(8)    -- �¶�������
  ,ADT_HDN                                  VARCHAR2(13)   -- �����׸�
  ,ADT_HDN_NM                               VARCHAR2(100)  -- �����׸��
  ,CHKG_RSLT                                VARCHAR2(1)    -- ���˰��
  ,CHKG_RSLT_NM                             VARCHAR2(10)   -- ���˰����
  ,CNT                                      NUMBER(4)      -- �Ǽ�
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_�����а�����01               IS 'OPE_KRI_�����а�����01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����01.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����01.CHKG_DTT     IS '���˱���';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����01.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����01.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����01.ONL_DT       IS '�¶�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����01.ADT_HDN      IS '�����׸�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����01.ADT_HDN_NM   IS '�����׸��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����01.CHKG_RSLT      IS '���˰��';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����01.CHKG_RSLT_NM   IS '���˰����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_�����а�����01.CNT            IS '�Ǽ�';

GRANT SELECT ON TB_OPE_KRI_�����а�����01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_�����а�����01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_�����а�����01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_�����а�����01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_�����а�����01 TO RL_OPE_SEL;

EXIT
