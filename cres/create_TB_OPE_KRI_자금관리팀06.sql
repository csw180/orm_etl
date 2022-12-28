DROP TABLE OPEOWN.TB_OPE_KRI_자금관리팀06;

CREATE TABLE OPEOWN.TB_OPE_KRI_자금관리팀06
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,OCC_DT                                  VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)
  ,NARN_RMD                                NUMBER(18,2)
  ,ARN_DT                                  VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_자금관리팀06               IS 'OPE_KRI_자금관리팀06';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀06.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀06.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀06.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀06.OCC_DT       IS '발생일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀06.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀06.NARN_RMD     IS '미정리잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀06.ARN_DT       IS '정리일자';

GRANT SELECT ON TB_OPE_KRI_자금관리팀06 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_자금관리팀06 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_자금관리팀06 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_자금관리팀06 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_자금관리팀06 TO RL_OPE_SEL;

EXIT
