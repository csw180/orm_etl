DROP TABLE OPEOWN.TB_OPE_KRI_외환지원팀11;

CREATE TABLE OPEOWN.TB_OPE_KRI_외환지원팀11
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,REF_NO                                  VARCHAR2(20)   --REFNO
  ,TR_DT                                   VARCHAR2(8)
  ,ARN_DT                                  VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)    --통화코드
  ,FCA                                     NUMBER(18,2)
  ,ACCR_DCNT                               NUMBER(10)     --경과일수
  ,ARN_CMPL_YN                             VARCHAR2(1)    --정리완료여부
  ,TLR_NO                                  VARCHAR2(10)   --텔러번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_외환지원팀11               IS 'OPE_KRI_외환지원팀11';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.REF_NO       IS 'REF번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.ARN_DT       IS '정리일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.FCA          IS '외화금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.ACCR_DCNT    IS '경과일수';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.ARN_CMPL_YN  IS '정리완료여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀11.TLR_NO       IS '텔러번호';

GRANT SELECT ON TB_OPE_KRI_외환지원팀11 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_외환지원팀11 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_외환지원팀11 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_외환지원팀11 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_외환지원팀11 TO RL_OPE_SEL;

EXIT
