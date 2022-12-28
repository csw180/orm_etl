DROP TABLE OPEOWN.TB_OPE_KRI_카드마케팅팀03;

CREATE TABLE OPEOWN.TB_OPE_KRI_카드마케팅팀03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CRD_PRD_DSCD                            VARCHAR2(2)   -- 카드구분
--  ,CRD_PRD_DSCD_NM                         VARCHAR2(40)   -- 카드구분명
  ,ISN_DT                                  VARCHAR2(8)   -- 카드발급일자
  ,SNDG_DT                                 VARCHAR2(8)   -- 카드발송일자
  ,BR_ACP_DT                               VARCHAR2(8)    -- 영업점보관개시일자
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_카드마케팅팀03              IS 'OPE_KRI_카드마케팅팀03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀03.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀03.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀03.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀03.CRD_PRD_DSCD IS '카드상품구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀03.ISN_DT       IS '발급일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀03.SNDG_DT      IS '발송일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀03.BR_ACP_DT    IS '점접수일자';

GRANT SELECT ON TB_OPE_KRI_카드마케팅팀03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_카드마케팅팀03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_카드마케팅팀03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_카드마케팅팀03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_카드마케팅팀03 TO RL_OPE_SEL;

EXIT
