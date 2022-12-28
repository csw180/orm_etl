DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀33;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀33
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)  --  계좌번호
  ,TR_DT                                   VARCHAR2(8)  --  거래일자
  ,USR_NO                                  VARCHAR2(10)   -- 거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀33               IS 'OPE_KRI_수신제도지원팀33';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀33.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀33.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀33.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀33.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀33.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀33.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀33 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀33 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀33 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀33 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀33 TO RL_OPE_SEL;

EXIT
