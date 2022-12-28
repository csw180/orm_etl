DROP TABLE OPEOWN.TB_OPE_KRI_카드마케팅팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_카드마케팅팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CRD_MBR_NO                              VARCHAR2(9)   -- 카드회원번호
  ,CRD_PRD_DSCD                            VARCHAR2(2)   -- 카드상품구분코드
--  ,CRD_PRD_DSCD_NM                         VARCHAR2(100)   -- 카드상품구분코드명
  ,ACD_CMPN_ACP_DT                         VARCHAR2(8)   -- 사고보상접수일자
  ,ACD_TMNT_DT                             VARCHAR2(8)   -- 사고종결일자, 귀책판정완료일자
  ,RVN_WNA                                 NUMBER(15)    -- 매출원화금액
  ,ACD_CMPN_TSK_CD                         VARCHAR2(2)   -- 사고보상업무코드
--  ,ACD_CMPN_TSK_CD_NM                      VARCHAR2(100)   -- 사고보상업무코드명
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_카드마케팅팀01              IS 'OPE_KRI_카드마케팅팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀01.BRNO               IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀01.BR_NM              IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀01.CRD_MBR_NO         IS '카드회원번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀01.CRD_PRD_DSCD       IS '카드상품구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀01.ACD_CMPN_ACP_DT    IS '사고보상접수일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀01.ACD_TMNT_DT        IS '사고종결일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀01.RVN_WNA            IS '매출원화금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드마케팅팀01.ACD_CMPN_TSK_CD    IS '사고보상업무코드';

GRANT SELECT ON TB_OPE_KRI_카드마케팅팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_카드마케팅팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_카드마케팅팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_카드마케팅팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_카드마케팅팀01 TO RL_OPE_SEL;

EXIT
