DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀25;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀25
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,LDGR_RMD                                NUMBER(20, 2)
  ,NW_DT                                   VARCHAR2(8)
  ,TR_DT                                   VARCHAR2(8)
  ,USR_NO                                  VARCHAR2(10)  -- 거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀25               IS 'OPE_KRI_수신제도지원팀25';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀25.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀25.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀25.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀25.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀25.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀25.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀25.LDGR_RMD     IS '원장잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀25.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀25.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀25.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀25 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀25 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀25 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀25 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀25 TO RL_OPE_SEL;

EXIT
