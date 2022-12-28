DROP TABLE OPEOWN.TB_OPE_KRI_����������09;

CREATE TABLE OPEOWN.TB_OPE_KRI_����������09
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,MRT_NO                                  VARCHAR2(12)  --  �㺸��ȣ
--  ,MRT_TPCD                                VARCHAR2(1)   --  �㺸�����ڵ�
  ,MRT_CD                                  VARCHAR2(3)   --  �㺸�ڵ�
  ,OWNR_CUST_NO                            NUMBER(9)     --  �����ڰ���ȣ
  ,DBR_CUST_NO                             NUMBER(9)     --  ä���ڰ���ȣ
  ,DPS_ACNO                                VARCHAR2(12)  --  ���Ű��¹�ȣ
  ,ENR_DT                                  VARCHAR2(8)   --  �㺸�������
  ,NW_DT                                   VARCHAR2(8)   --  ���ݽű���
  ,USR_NO                                  VARCHAR2(10)  -- ������������ȣ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_����������09               IS 'OPE_KRI_����������09';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.STD_DT       IS '��������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.BRNO         IS '����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.BR_NM        IS '����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.MRT_NO       IS '�㺸��ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.MRT_CD       IS '�㺸�ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.OWNR_CUST_NO IS '�����ڰ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.DBR_CUST_NO  IS 'ä���ڰ���ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.DPS_ACNO     IS '���Ű��¹�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.ENR_DT       IS '�������';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.NW_DT        IS '�ű�����';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_����������09.USR_NO       IS '����ڹ�ȣ';

GRANT SELECT ON TB_OPE_KRI_����������09 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_����������09 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_����������09 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_����������09 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_����������09 TO RL_OPE_SEL;

EXIT
