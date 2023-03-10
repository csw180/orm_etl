DROP TABLE OPEOWN.TB_OPE_KRI_스마트채널팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_스마트채널팀01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,OBS_TP_CD                                VARCHAR2(10)   -- 장애유형코드
  ,OBS_ACP_DT                               VARCHAR2(8)    -- 장애접수일자
  ,CHNL_NM                                  VARCHAR2(30)   -- 채널명
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_스마트채널팀01               IS 'OPE_KRI_스마트채널팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_스마트채널팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_스마트채널팀01.OBS_TP_CD    IS '장애유형코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_스마트채널팀01.OBS_ACP_DT   IS '장애접수일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_스마트채널팀01.CHNL_NM      IS '채널명';

GRANT SELECT ON TB_OPE_KRI_스마트채널팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_스마트채널팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_스마트채널팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_스마트채널팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_스마트채널팀01 TO RL_OPE_SEL;

EXIT
