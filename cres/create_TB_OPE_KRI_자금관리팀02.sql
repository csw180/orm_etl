DROP TABLE OPEOWN.TB_OPE_KRI_자금관리팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_자금관리팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,OCC_DT                                  VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)
  ,OCC_AMT                                 NUMBER(18,2)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_자금관리팀02               IS 'OPE_KRI_자금관리팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀02.OCC_DT       IS '발생일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀02.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀02.OCC_AMT      IS '발생금액';

GRANT SELECT ON TB_OPE_KRI_자금관리팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_자금관리팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_자금관리팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_자금관리팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_자금관리팀02 TO RL_OPE_SEL;

EXIT
