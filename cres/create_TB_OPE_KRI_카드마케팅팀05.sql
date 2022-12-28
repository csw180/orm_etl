DROP TABLE OPEOWN.TB_OPE_KRI_카드마케팅팀05;

CREATE TABLE OPEOWN.TB_OPE_KRI_카드마케팅팀05
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ISN_DT                                  VARCHAR2(8)   -- 카드발급일자
  ,SNDG_DT                                 VARCHAR2(8)   -- 카드발송일자
  ,BR_ACP_DT                               VARCHAR2(8)   -- 점접수일자
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_카드마케팅팀05              IS 'OPE_KRI_카드마케팅팀05';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀05.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀05.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀05.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀05.ISN_DT       IS '발급일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀05.SNDG_DT      IS '발송일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀05.BR_ACP_DT    IS '점접수일자';

GRANT SELECT ON TB_OPE_KRI_카드마케팅팀05 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_카드마케팅팀05 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_카드마케팅팀05 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_카드마케팅팀05 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_카드마케팅팀05 TO RL_OPE_SEL;

EXIT
