DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀17;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀17
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,LDGR_RMD                                NUMBER(20,2)  -- 원장잔액
  ,EXPI_DT                                 VARCHAR2(8)
  ,ACCR_DCNT                               NUMBER(10)   -- 경과일수
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀17               IS 'OPE_KRI_수신제도지원팀17';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀17.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀17.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀17.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀17.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀17.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀17.LDGR_RMD     IS '원장잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀17.EXPI_DT      IS '만기일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀17.ACCR_DCNT    IS '경과일자';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀17 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀17 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀17 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀17 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀17 TO RL_OPE_SEL;

EXIT
