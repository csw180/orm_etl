DROP TABLE OPEOWN.TB_OPE_KRI_카드마케팅팀04;

CREATE TABLE OPEOWN.TB_OPE_KRI_카드마케팅팀04
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ISN_DT                                  VARCHAR2(8)   -- 카드발급일자
  ,SHPP_RQS_DT                             VARCHAR2(8)   -- 카드발송일자
  ,SNBK_DT                                 VARCHAR2(8)   -- 반송일자
  ,SPXP_SNBK_RSCD                          VARCHAR2(2)   -- 특송반송사유코드
--  ,SPXP_SNBK_RS_NM                         VARCHAR2(100)   -- 특송반송사유명
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_카드마케팅팀04              IS 'OPE_KRI_카드마케팅팀04';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀04.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀04.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀04.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀04.ISN_DT       IS '발급일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀04.SHPP_RQS_DT  IS '배송요청일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀04.SNBK_DT      IS '반송일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀04.SPXP_SNBK_RSCD IS '특송반송사유코드';

GRANT SELECT ON TB_OPE_KRI_카드마케팅팀04 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_카드마케팅팀04 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_카드마케팅팀04 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_카드마케팅팀04 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_카드마케팅팀04 TO RL_OPE_SEL;

EXIT
