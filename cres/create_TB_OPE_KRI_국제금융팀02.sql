DROP TABLE OPEOWN.TB_OPE_KRI_국제금융팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_국제금융팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  --,SUMMIT_TR_ID                            VARCHAR2(10)   --  SUMMIT거래ID
  ,ITF_TR_DSCD                             VARCHAR2(6)    --  국제금융거래구분코드
  ,PCSL_DSCD                               VARCHAR2(1)  -- 매입매도구분코드
  ,TR_DT                                   VARCHAR2(8)    --  거래일자
  ,TR_AMT                                  NUMBER(18,2)   --  거래금액
  ,CRCD                                    VARCHAR2(3)    --  통화코드
  ,USR_NO                                  VARCHAR2(10)   -- 사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_국제금융팀02                    IS 'OPE_KRI_국제금융팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀02.STD_DT             IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀02.BRNO               IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀02.BR_NM              IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀02.ITF_TR_DSCD        IS '국제금융거래구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀02.PCSL_DSCD          IS '매입매도구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀02.TR_DT              IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀02.TR_AMT             IS '거래금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀02.CRCD               IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_국제금융팀02.USR_NO             IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_국제금융팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_국제금융팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_국제금융팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_국제금융팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_국제금융팀02 TO RL_OPE_SEL;

EXIT
