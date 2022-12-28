DROP TABLE OPEOWN.TB_OPE_KRI_여신팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,CLN_EXE_NO                              NUMBER(10)
  ,CLN_TR_NO                               NUMBER(10)
  ,CLN_TR_KDCD                             VARCHAR2(3)   -- 여신거래종류코드
  ,TR_DT                                   VARCHAR2(8)   -- 거래일자
  ,CNCL_DT                                 VARCHAR2(8)   -- 취소일자
  ,RCFM_DT                                 VARCHAR2(8)   -- 기산일자
  ,USR_NO                                  VARCHAR2(10)  -- 거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신팀01               IS 'OPE_KRI_여신팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.CLN_ACNO     IS '여신게좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.CLN_EXE_NO   IS '여신실행번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.CLN_TR_NO    IS '여신거래번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.CLN_TR_KDCD  IS '여신거래종류코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.CNCL_DT      IS '취소일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.RCFM_DT      IS '기산일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신팀01.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_여신팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신팀01 TO RL_OPE_SEL;

EXIT
