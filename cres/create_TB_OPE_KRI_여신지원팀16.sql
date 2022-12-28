DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀16;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀16
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACN_DCMT_NO                             VARCHAR2(20)   -- 계좌식별번호
  ,CUST_NO                                 NUMBER(9)
  ,PREN_CLN_DSCD                           VARCHAR2(1)    -- 개인기업여신구분코드
  ,PRD_KR_NM                               VARCHAR2(100)  -- 상품한글명
  ,APC_AMT                                 NUMBER(18,2)   -- 신청금액
  ,ALR_LN_RMD                              NUMBER(20, 2)  -- 기대출잔액
  ,AGR_DT                                  VARCHAR2(8)    -- 약정일자
  ,PRX_EXPI_DT                             VARCHAR2(8)    -- 기존만기일자
  ,CSLT_DT                                 VARCHAR2(8)   -- 품의일자
  ,USR_NO                                  VARCHAR2(10)   -- 작성사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀16               IS 'OPE_KRI_여신지원팀16';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.ACN_DCMT_NO  IS '계좌식별번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.PREN_CLN_DSCD IS '거래전개인기업여신구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.APC_AMT      IS '신청금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.ALR_LN_RMD   IS '기대출잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.AGR_DT       IS '약정일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.PRX_EXPI_DT  IS '기존만기일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.CSLT_DT      IS '품의일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀16.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_여신지원팀16 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀16 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀16 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀16 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀16 TO RL_OPE_SEL;

EXIT
