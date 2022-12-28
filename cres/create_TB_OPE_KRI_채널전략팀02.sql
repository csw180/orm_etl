DROP TABLE OPEOWN.TB_OPE_KRI_채널전략팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_채널전략팀02
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,CNTT_DTT_CD                              VARCHAR2(4)  -- 계약구분코드
  ,CNTT_NO                                  VARCHAR2(25)
  ,CNTT_NM                                  VARCHAR2(200)
  ,CNTT_DT                                  VARCHAR2(8)
  ,CNTT_AMT                                 NUMBER(22)
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_채널전략팀02              IS 'OPE_KRI_채널전략팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_채널전략팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_채널전략팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_채널전략팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_채널전략팀02.CNTT_DTT_CD  IS '계약구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_채널전략팀02.CNTT_NO      IS '계약번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_채널전략팀02.CNTT_NM      IS '계약명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_채널전략팀02.CNTT_DT      IS '계약일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_채널전략팀02.CNTT_AMT     IS '계약금액';

GRANT SELECT ON TB_OPE_KRI_채널전략팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_채널전략팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_채널전략팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_채널전략팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_채널전략팀02 TO RL_OPE_SEL;

EXIT
