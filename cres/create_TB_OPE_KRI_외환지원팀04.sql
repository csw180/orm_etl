DROP TABLE OPEOWN.TB_OPE_KRI_외환지원팀04;

CREATE TABLE OPEOWN.TB_OPE_KRI_외환지원팀04
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,TR_DT                                   VARCHAR2(8)
  ,ARN_DT                                  VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)    --통화코드
  ,FCA                                     NUMBER(18,2)
  ,REF_NO                                  VARCHAR2(20)   --REFNO
  ,ACCR_DCNT                               NUMBER(10)     --경과일수
  ,TLR_NO                                  VARCHAR2(10)   --텔러번호
  ,ARN_CMPL_YN                             VARCHAR2(1)    --정리완료여부
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_외환지원팀04               IS 'OPE_KRI_외환지원팀04';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.ARN_DT       IS '정리일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.FCA          IS '외화금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.REF_NO       IS 'REF번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.ACCR_DCNT    IS '경과일수';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.TLR_NO       IS '텔러번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀04.ARN_CMPL_YN  IS '정리완료여부';

GRANT SELECT ON TB_OPE_KRI_외환지원팀04 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_외환지원팀04 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_외환지원팀04 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_외환지원팀04 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_외환지원팀04 TO RL_OPE_SEL;

EXIT
