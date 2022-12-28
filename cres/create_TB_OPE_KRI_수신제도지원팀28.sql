DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀28;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀28
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,INTG_ACNO                               VARCHAR2(35)  -- 통합계좌번호
  ,ONL_DT                                  VARCHAR2(8)   -- 발급일자
  ,USR_NO                                  VARCHAR2(10)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀28               IS 'OPE_KRI_수신제도지원팀28';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀28.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀28.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀28.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀28.INTG_ACNO    IS '통합계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀28.ONL_DT       IS '온라인일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀28.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀28 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀28 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀28 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀28 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀28 TO RL_OPE_SEL;

EXIT
