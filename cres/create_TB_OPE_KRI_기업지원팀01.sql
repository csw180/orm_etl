DROP TABLE OPEOWN.TB_OPE_KRI_기업지원팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_기업지원팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
--  ,CUST_NO                                 NUMBER(9)
  ,TCH_EVL_BRN                             NUMBER(10)     -- 기술평가사업자등록번호
--  ,CUST_DSCD                               VARCHAR2(2)
  ,STDD_INDS_CLCD                          VARCHAR2(5)    -- 표준산업분류코드
  ,TCH_EVL_APC_DT                          VARCHAR2(8)    -- 기술평가신청일자
--  ,TCH_YN                                  VARCHAR2(1)
  ,EXCP_YN                                 VARCHAR2(1)    -- 예외여부
  ,TCH_EVL_EXCP_ENR_RSCD                   VARCHAR2(2)    -- 기술평가예외등록사유코드
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_기업지원팀01               IS 'OPE_KRI_기업지원팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀01.BRNO          IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀01.BR_NM         IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀01.TCH_EVL_BRN   IS '기술평가사업자등록번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀01.STDD_INDS_CLCD    IS '표준산업분류코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀01.TCH_EVL_APC_DT    IS '기술평가신청일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀01.EXCP_YN           IS '예외여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀01.TCH_EVL_EXCP_ENR_RSCD    IS '기술평가예외등록사유코드';

GRANT SELECT ON TB_OPE_KRI_기업지원팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_기업지원팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_기업지원팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_기업지원팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_기업지원팀01 TO RL_OPE_SEL;

EXIT
