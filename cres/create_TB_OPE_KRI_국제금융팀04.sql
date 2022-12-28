DROP TABLE OPEOWN.TB_OPE_KRI_국제금융팀04;

CREATE TABLE OPEOWN.TB_OPE_KRI_국제금융팀04
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
--  ,SUMMIT_TR_ID                            VARCHAR2(10)   --  SUMMIT거래ID
  ,ITF_TR_DSCD                             VARCHAR2(6)    --  국제금융거래구분코드
--  ,PCSL_DSCD                               VARCHAR2(1)  -- 매입매도구분코드
  ,TR_DT                                   VARCHAR2(8)    --  거래일자
  ,PCH_AMT                                 NUMBER(18,2)   --  매입금액
  ,PCH_CRCD                                VARCHAR2(3)    --  매입통화
  ,USR_NO                                  VARCHAR2(10)   -- 사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_국제금융팀04               IS 'OPE_KRI_국제금융팀04';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀04.STD_DT        IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀04.BRNO          IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀04.BR_NM         IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀04.ITF_TR_DSCD   IS '국제금융거래구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀04.TR_DT         IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀04.PCH_AMT       IS '매입금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀04.PCH_CRCD      IS '매입통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀04.USR_NO        IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_국제금융팀04 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_국제금융팀04 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_국제금융팀04 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_국제금융팀04 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_국제금융팀04 TO RL_OPE_SEL;

EXIT
