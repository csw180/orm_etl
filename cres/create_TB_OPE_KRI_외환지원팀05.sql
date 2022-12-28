DROP TABLE OPEOWN.TB_OPE_KRI_외환지원팀05;

CREATE TABLE OPEOWN.TB_OPE_KRI_외환지원팀05
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
  ,CLN_EXE_NO                              NUMBER(10)
  ,LN_EXE_AMT                              NUMBER(18, 2)
  ,LN_DT                                   VARCHAR2(8)    -- 대출일자
  ,CHKG_YN                                 VARCHAR2(1)    -- 사후점검여부
  ,CHKG_TMLM_DT                            VARCHAR2(8)    -- 점검기한일자
  ,CHKG_DT                                 VARCHAR2(8)    -- 점검완료일
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_외환지원팀05               IS 'OPE_KRI_외환지원팀05';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.BRNO            IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.BR_NM           IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.CUST_NO         IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.CUST_DSCD       IS '고객구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.ACN_DCMT_NO     IS '계좌식별번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.PRD_KR_NM       IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.CRCD            IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.APRV_AMT        IS '승인금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.CLN_EXE_NO      IS '여신실행번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.LN_EXE_AMT      IS '여신실행금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.LN_DT           IS '대출일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.CHKG_YN         IS '점검여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.CHKG_TMLM_DT    IS '점검기한일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀05.CHKG_DT         IS '점검일자';

GRANT SELECT ON TB_OPE_KRI_외환지원팀05 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_외환지원팀05 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_외환지원팀05 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_외환지원팀05 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_외환지원팀05 TO RL_OPE_SEL;

EXIT
