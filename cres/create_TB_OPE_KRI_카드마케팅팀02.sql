DROP TABLE OPEOWN.TB_OPE_KRI_카드마케팅팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_카드마케팅팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  --,CRD_NO                                  VARCHAR2(16)
  ,CRD_PRD_DSCD                            VARCHAR2(2)   -- 카드구분
  --,CRD_PRD_DSCD_NM                         VARCHAR2(40)   -- 카드구분명
  ,ISN_DT                                  VARCHAR2(8)   -- 카드발급일자
  ,SHPP_RQS_DT                             VARCHAR2(8)    -- 배송요청일자
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_카드마케팅팀02              IS 'OPE_KRI_카드마케팅팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀02.CRD_PRD_DSCD IS '카드상품구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀02.ISN_DT       IS '발급일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀02.SHPP_RQS_DT  IS '배송요청일자';

GRANT SELECT ON TB_OPE_KRI_카드마케팅팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_카드마케팅팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_카드마케팅팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_카드마케팅팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_카드마케팅팀02 TO RL_OPE_SEL;

EXIT
