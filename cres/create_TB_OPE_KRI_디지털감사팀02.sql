DROP TABLE OPEOWN.TB_OPE_KRI_디지털감사팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_디지털감사팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACSB_CD                                 VARCHAR2(8)   -- 계정과목코드
  ,OCC_DT                                  VARCHAR2(8)
  ,NARN_RMD                                NUMBER(20,2)   -- 미정리잔액
  ,CUR_AMT                                 NUMBER(18,2)   -- 통화금액
  ,ALT_AMT                                 NUMBER(18,2)   -- 대체금액
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_디지털감사팀02               IS 'OPE_KRI_디지털감사팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀02.ACSB_CD      IS '계정과목코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀02.OCC_DT       IS '발생일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀02.NARN_RMD     IS '미정리잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀02.CUR_AMT      IS '통화금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_디지털감사팀02.ALT_AMT      IS '대체금액';

GRANT SELECT ON TB_OPE_KRI_디지털감사팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_디지털감사팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_디지털감사팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_디지털감사팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_디지털감사팀02 TO RL_OPE_SEL;

EXIT
