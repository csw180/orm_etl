DROP TABLE OPEOWN.TB_OPE_KRI_외환지원팀03;

CREATE TABLE OPEOWN.TB_OPE_KRI_외환지원팀03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,REF_NO                                  VARCHAR2(20)
  ,CRCD                                    VARCHAR2(3)    --통화코드
  ,OPN_AMT                                 NUMBER(18,2)  -- 개설금액
  ,OPN_DT                                  VARCHAR2(8)   -- 개설일자
  ,AVL_DT                                  VARCHAR2(8)   -- 유효일자
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_외환지원팀03               IS 'OPE_KRI_외환지원팀03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀03.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀03.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀03.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀03.REF_NO       IS 'REF번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀03.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀03.OPN_AMT      IS '개설금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀03.OPN_DT       IS '개설일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀03.AVL_DT       IS '유효일자';

GRANT SELECT ON TB_OPE_KRI_외환지원팀03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_외환지원팀03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_외환지원팀03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_외환지원팀03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_외환지원팀03 TO RL_OPE_SEL;

EXIT
