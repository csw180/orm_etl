DROP TABLE OPEOWN.TB_OPE_KRI_디지털감사팀03;

CREATE TABLE OPEOWN.TB_OPE_KRI_디지털감사팀03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,OCC_DT                                  VARCHAR2(8)
  ,OCC_AMT                                 NUMBER(18,2)   -- 발생금액
  ,NARN_RMD                                NUMBER(20,2)   -- 미정리잔액
  ,ARN_DT                                  VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_디지털감사팀03               IS 'OPE_KRI_디지털감사팀03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀03.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀03.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀03.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀03.OCC_DT       IS '발생일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀03.OCC_AMT      IS '발생금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀03.NARN_RMD     IS '미정리잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀03.ARN_DT       IS '정리일자';

GRANT SELECT ON TB_OPE_KRI_디지털감사팀03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_디지털감사팀03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_디지털감사팀03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_디지털감사팀03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_디지털감사팀03 TO RL_OPE_SEL;

EXIT
