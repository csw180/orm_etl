DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀06;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀06
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CUST_DSCD                               VARCHAR2(2)
  ,ACN_DCMT_NO                             VARCHAR2(20)   -- 계좌식별번호
  ,PRD_KR_NM                               VARCHAR2(100)  -- 상품한글명
  ,CRCD                                    VARCHAR2(3)
  ,APRV_AMT                                NUMBER(18,2)   -- 승인금액
  ,TOT_CLN_RMD                             NUMBER(20,2)   -- 총여신잔액
  ,AGR_DT                                  VARCHAR2(8)    -- 약정일자
  ,EXPI_DT                                 VARCHAR2(8)    -- 만기일자
  ,ACK_TGT_YN                              VARCHAR2(1)    -- 사후점검대상여부
  ,CHKG_YN                                 VARCHAR2(1)    -- 사후점검여부
  ,CHKG_TMLM_DT                            VARCHAR2(8)    -- 점검기한일자
  ,CHKG_DT                                 VARCHAR2(8)    -- 점검완료일
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀06               IS 'OPE_KRI_여신지원팀06';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.CUST_DSCD    IS '고객구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.ACN_DCMT_NO  IS '계좌식별번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.APRV_AMT     IS '승인금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.TOT_CLN_RMD  IS '총여신잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.AGR_DT       IS '약정일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.EXPI_DT      IS '만기일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.ACK_TGT_YN   IS '사후점검대상여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.CHKG_YN      IS '점검여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.CHKG_TMLM_DT IS '점검기한일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀06.CHKG_DT      IS '점검일자';

GRANT SELECT ON TB_OPE_KRI_여신지원팀06 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀06 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀06 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀06 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀06 TO RL_OPE_SEL;

EXIT
