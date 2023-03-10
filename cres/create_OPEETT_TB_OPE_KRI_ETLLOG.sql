-- OPEETT 계정으로 테이블 생성
DROP TABLE TB_OPE_KRI_ETLLOG;

CREATE TABLE TB_OPE_KRI_ETLLOG
(
    TABLE_NAME                             VARCHAR2(128)
   ,STD_DT                                 VARCHAR2(8)
   ,LD_CNT                                 NUMBER(10)
   ,TSK_DESC                               VARCHAR2(40)
   ,LST_CHG_DTTM                           DATE NOT NULL  
) NOLOGGING;

GRANT SELECT ON TB_OPE_KRI_ETLLOG TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ETLLOG TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ETLLOG TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ETLLOG TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ETLLOG TO RL_OPE_SEL;

EXIT
