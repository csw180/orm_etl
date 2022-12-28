DROP TABLE OPEOWN.TB_OPE_KRI_외환지원팀07;

CREATE TABLE OPEOWN.TB_OPE_KRI_외환지원팀07
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NM                                 VARCHAR2(100)
  ,REF_NO                                  VARCHAR2(20)
  ,CRCD                                    VARCHAR2(3)    --통화코드
  ,PCH_AMT                                 NUMBER(18,2)  -- 어음액면가
  ,ANT_EXPI_DT                             VARCHAR2(8)   -- 어음예정만기일
  ,LST_EXPI_DT                             VARCHAR2(8)   -- 어음확정만기일
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_외환지원팀07               IS 'OPE_KRI_외환지원팀07';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀07.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀07.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀07.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀07.CUST_NM      IS '고객명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀07.REF_NO       IS 'REF번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀07.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀07.PCH_AMT      IS '매입금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀07.ANT_EXPI_DT  IS '예상만기일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀07.LST_EXPI_DT  IS '최종만기일자';

GRANT SELECT ON TB_OPE_KRI_외환지원팀07 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_외환지원팀07 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_외환지원팀07 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_외환지원팀07 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_외환지원팀07 TO RL_OPE_SEL;

EXIT
