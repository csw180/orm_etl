DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,CNVC_DSCD                               VARCHAR2(20)
  ,TR_DT                                   VARCHAR2(8)
  ,TR_AMT                                  NUMBER(18, 2)
  ,RLS_YN                                  VARCHAR2(1)
  ,RLS_DT                                  VARCHAR2(8)
  ,NARN_ACCR_DCNT                          NUMBER(10)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀02               IS 'OPE_KRI_수신제도지원팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.CNVC_DSCD    IS '편의구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.TR_AMT       IS '거래금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.RLS_YN       IS '해제여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.RLS_DT       IS '해제일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀02.NARN_ACCR_DCNT  IS '미정리경과일수';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀02 TO RL_OPE_SEL;

EXIT
