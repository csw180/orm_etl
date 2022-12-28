DROP TABLE OPEOWN.TB_OPE_KRI_론리뷰팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_론리뷰팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACN_DCMT_NO                             VARCHAR2(20)   -- 계좌식별번호
  ,CUST_NO                                 NUMBER(9)
  ,CUST_DSCD                               VARCHAR2(2)     -- 고객구분코드
  ,APCL_DSCD                               VARCHAR2(1)     -- 승인여신구분코드
  ,LN_SBCD                                 VARCHAR2(3)     -- 대출과목코드
  ,CRCD                                    VARCHAR2(3)     -- 통화코드
  ,APRV_AMT                                NUMBER(18,2)    -- 승인금액
  ,TOT_CLN_RMD                             NUMBER(20,2)    -- 총여신잔액
  ,CLN_APRV_DT                             VARCHAR2(8)     -- 여신승인일자
  ,APRV_LN_EXPI_DT                         VARCHAR2(8)     -- 승인대출만기일자
  ,LNRV_JDGM_DTT_NM                        VARCHAR2(10)    -- 론리뷰판정구분명
  ,HDQ_JDGM_OPNN_CTS                       VARCHAR2(4000)   -- 본부판정의견내용
  ,JDGM_DT                                 VARCHAR2(8)     -- 판정일자
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_론리뷰팀01               IS 'OPE_KRI_론리뷰팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.ACN_DCMT_NO  IS '계좌식별번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.CUST_DSCD    IS '고객구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.APCL_DSCD    IS '승인여신구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.LN_SBCD      IS '대출과목코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.APRV_AMT              IS '승인금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.TOT_CLN_RMD           IS '총여신잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.CLN_APRV_DT           IS '여신승인일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.APRV_LN_EXPI_DT       IS '승인대출만기일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.LNRV_JDGM_DTT_NM      IS '론리뷰판정구분명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.HDQ_JDGM_OPNN_CTS     IS '본부판정의견내용';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀01.JDGM_DT               IS '판정일자';

GRANT SELECT ON TB_OPE_KRI_론리뷰팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_론리뷰팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_론리뷰팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_론리뷰팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_론리뷰팀01 TO RL_OPE_SEL;

EXIT 
