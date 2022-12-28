DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀18;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀18
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CLN_ACNO                                VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,CUST_DSCD                               VARCHAR2(1)   -- 고객구분 1:기업여신, 2:공공여신
  ,PDCD                                    VARCHAR2(14)
  ,PRD_KR_NM                               VARCHAR2(100)  -- 상품한글명
  ,CRCD                                    VARCHAR2(3)
  ,APRV_AMT                                NUMBER(18,2)
  ,CLN_EXE_NO                              NUMBER(10)
  ,TR_PCPL                                 NUMBER(18,2)   -- 실행금액
  ,TR_DT                                   VARCHAR2(8)    -- 실행일자
  ,RCFM_DT                                 VARCHAR2(8)    -- 기산일자
  ,LKG_YN                                  VARCHAR2(1)   -- 연동입금여부
  ,LKG_FCNO                                VARCHAR2(20)  -- 연동입금계좌번호
  ,USR_NO                                  VARCHAR2(10)  -- 조작자직원번호
  ,CLN_TR_DTL_KDCD                         VARCHAR2(4)   -- 여신거래상세종류코드
  ,TR_STCD                                 VARCHAR2(1)   -- 거래상태코드
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀18               IS 'OPE_KRI_여신지원팀18';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.CLN_ACNO     IS '여신계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.CUST_DSCD    IS '고객구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.PDCD         IS '상품코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.APRV_AMT     IS '승인금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.CLN_EXE_NO   IS '여신실행번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.TR_PCPL      IS '거래원금';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.RCFM_DT      IS '기산일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.LKG_YN       IS '연동여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.LKG_FCNO     IS '연동금융기관계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.USR_NO       IS '사용자번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.CLN_TR_DTL_KDCD    IS '여신거래상세종류코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀18.TR_STCD      IS '거래상태코드';

GRANT SELECT ON TB_OPE_KRI_여신지원팀18 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀18 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀18 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀18 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀18 TO RL_OPE_SEL;

EXIT
