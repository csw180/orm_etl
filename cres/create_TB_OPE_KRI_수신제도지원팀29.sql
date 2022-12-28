DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀29;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀29
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CSNT_ACNO                               VARCHAR2(12)   -- 보관어음계좌번호
  ,TR_DSCD_NM                              VARCHAR2(8)    -- 거래구분명
  ,TR_DT                                   VARCHAR2(8)    -- 반환일자
  ,USR_NO                                  VARCHAR2(10)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀29               IS 'OPE_KRI_수신제도지원팀29';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀29.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀29.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀29.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀29.CSNT_ACNO    IS '보관어음계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀29.TR_DSCD_NM   IS '거래구분코드명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀29.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀29.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀29 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀29 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀29 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀29 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀29 TO RL_OPE_SEL;

EXIT
