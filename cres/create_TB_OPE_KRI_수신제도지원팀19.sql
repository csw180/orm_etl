DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀19;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀19
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,NW_DT                                   VARCHAR2(8)
  ,TR_DT                                   VARCHAR2(8)
  ,RCFM_DT                                 VARCHAR2(8)
  ,USR_NO                                  VARCHAR2(10)  -- 거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀19               IS 'OPE_KRI_수신제도지원팀19';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀19.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀19.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀19.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀19.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀19.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀19.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀19.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀19.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀19.RCFM_DT      IS '기산일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀19.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀19 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀19 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀19 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀19 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀19 TO RL_OPE_SEL;

EXIT
