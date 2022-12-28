DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀16;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀16
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,LDGR_RMD                                NUMBER(20,2)  -- 원장잔액
  ,NW_DT                                   VARCHAR2(8)
  ,EXPI_DT                                 VARCHAR2(8)
  ,ACCR_DCNT                               NUMBER(10)   -- 경과일수
  ,CNCN_DT                                 VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀16               IS 'OPE_KRI_수신제도지원팀16';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀16.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀16.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀16.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀16.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀16.LDGR_RMD     IS '원장잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀16.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀16.EXPI_DT      IS '만기일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀16.ACCR_DCNT    IS '경과일수';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀16.CNCN_DT      IS '해지일자';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀16 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀16 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀16 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀16 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀16 TO RL_OPE_SEL;

EXIT
