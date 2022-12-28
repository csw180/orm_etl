DROP TABLE OPEOWN.TB_OPE_KRI_외환기획팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_외환기획팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,OW_REF_NO                               VARCHAR2(20)   --REFNO
  ,OW_PCS_DT                               VARCHAR2(8)    --처리일자
  ,OW_CRCD                                 VARCHAR2(3)    --통화코드
  ,OW_DFRY_AMT                             NUMBER(18,2)   --지급금액
  ,OW_TLR_NO                               VARCHAR2(10)   --텔러번호
  ,OW_ACCR_DCNT                            NUMBER(10)     --경과일수
  ,IW_REF_NO                               VARCHAR2(20)   --REFNO
  ,IW_PCS_DT                               VARCHAR2(8)    --처리일자
  ,IW_CRCD                                 VARCHAR2(3)    --통화코드
  ,IW_DFRY_AMT                             NUMBER(18,2)   --지급금액
  ,IW_TLR_NO                               VARCHAR2(10)   --텔러번호
  ,IW_ACCR_DCNT                            NUMBER(10)     --경과일수
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_외환기획팀01               IS 'OPE_KRI_외환기획팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.BRNO              IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.BR_NM             IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.OW_REF_NO         IS '당발REF번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.OW_PCS_DT         IS '당발처리일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.OW_CRCD           IS '당발통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.OW_DFRY_AMT       IS '당발지급금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.OW_TLR_NO         IS '당발텔러번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.OW_ACCR_DCNT      IS '당발경과일수';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.IW_REF_NO         IS '타발REF번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.IW_PCS_DT         IS '타발처리일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.IW_CRCD           IS '타발통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.IW_DFRY_AMT       IS '타발지급금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.IW_TLR_NO         IS '타발텔러번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환기획팀01.IW_ACCR_DCNT      IS '타발경과일수';

GRANT SELECT ON TB_OPE_KRI_외환기획팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_외환기획팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_외환기획팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_외환기획팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_외환기획팀01 TO RL_OPE_SEL;

EXIT
