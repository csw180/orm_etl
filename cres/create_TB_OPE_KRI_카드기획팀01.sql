DROP TABLE OPEOWN.TB_OPE_KRI_카드기획팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_카드기획팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CRD_MBR_DSCD                            VARCHAR2(1)   -- 카드회원구분코드
  ,PREN_DSCD                               VARCHAR2(1)   -- 개인기업구분코드
  ,CUST_SPCL_LMT_AMT                       NUMBER(18,2)  -- 고객특별한도금액
  ,SPCL_LMT_APC_RSN                        VARCHAR2(100)  -- 특별한도신청사유
  ,USR_NO                                   VARCHAR2(10)   -- 한도변경사용자번호
  ,LMT_CHG_DT                                VARCHAR2(8)    -- 한도변경일자
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_카드기획팀01              IS 'OPE_KRI_카드기획팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀01.BRNO               IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀01.BR_NM              IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀01.CRD_MBR_DSCD       IS '카드회원구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀01.PREN_DSCD          IS '개인기업구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀01.CUST_SPCL_LMT_AMT  IS '고객특별한도금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀01.SPCL_LMT_APC_RSN   IS '특별한도신청사유';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀01.USR_NO             IS '사용자번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀01.LMT_CHG_DT         IS '한도변경일자';

GRANT SELECT ON TB_OPE_KRI_카드기획팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_카드기획팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_카드기획팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_카드기획팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_카드기획팀01 TO RL_OPE_SEL;

EXIT
