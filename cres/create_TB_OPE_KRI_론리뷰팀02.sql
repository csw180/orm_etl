DROP TABLE OPEOWN.TB_OPE_KRI_론리뷰팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_론리뷰팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACN_DCMT_NO                             VARCHAR2(20)   -- 계좌식별번호
  ,CUST_NO                                 NUMBER(9)
  ,CUST_DSCD                               VARCHAR2(2)     -- 고객구분코드
  ,APCL_DSCD                               VARCHAR2(10)     -- 승인여신구분코드
  ,PRD_KR_NM                               VARCHAR2(100)
  ,CRCD                                    VARCHAR2(3)     -- 통화코드
  ,APRV_AMT                                NUMBER(18,2)    -- 승인금액
  ,TOT_CLN_RMD                             NUMBER(20,2)    -- 총여신잔액
  ,CLN_APRV_DT                             VARCHAR2(8)     -- 여신승인일자
  ,EXPI_DT                                 VARCHAR2(8)     -- 만기일자
  ,LNRV_JDGM_DTT_NM                        VARCHAR2(10)    -- 론리뷰판정구분명
  ,JDGM_DT                                 VARCHAR2(8)     -- 판정일자
--  ,LNRV_PTO_ITM_CD                         VARCHAR2(2)
--  ,HDQ_JDGM_OPNN_CTS                       VARCHAR2(4000)
--  ,ACTN_FLF_END_DT                         VARCHAR2(8)
  ,FLF_YN                                  VARCHAR2(1)     -- 이행여부구분코드
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_론리뷰팀02               IS 'OPE_KRI_론리뷰팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.ACN_DCMT_NO  IS '계좌식별번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.CUST_DSCD    IS '고객구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.APCL_DSCD    IS '승인여신구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.APRV_AMT     IS '승인금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.TOT_CLN_RMD  IS '총여신잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.CLN_APRV_DT  IS '여신승인일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.EXPI_DT             IS '만기일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.LNRV_JDGM_DTT_NM    IS '론리뷰판정구분명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.JDGM_DT             IS '판정일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_론리뷰팀02.FLF_YN              IS '이행여부';

GRANT SELECT ON TB_OPE_KRI_론리뷰팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_론리뷰팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_론리뷰팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_론리뷰팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_론리뷰팀02 TO RL_OPE_SEL;

EXIT
