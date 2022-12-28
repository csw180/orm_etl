DROP TABLE OPEOWN.TB_OPE_KRI_카드기획팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_카드기획팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CRD_PRD_DSCD                            VARCHAR2(2)   -- 카드상품구분코드
  --,CRD_PRD_DSCD_NM                         VARCHAR2(100)   -- 카드상품구분코드명
  ,ISN_DT                                  VARCHAR2(8)     -- 발급일자
  ,MBR_NW_DT                               VARCHAR2(8)   -- 카드입회일자
  ,OVD_ST_DT                               VARCHAR2(8)   -- 연체시작일
  ,OVD_AMT                                 NUMBER(18,2)  -- 연체금액
  ,PREN_DSCD                               VARCHAR2(1)   -- 개인기업구분코드
  --,PREN_DSCD_NM                            VARCHAR2(10)   -- 개인기업구분코드명
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_카드기획팀02              IS 'OPE_KRI_카드기획팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀02.CRD_PRD_DSCD IS '카드상품구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀02.ISN_DT       IS '발급일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀02.MBR_NW_DT    IS '회원신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀02.OVD_ST_DT    IS '연체시작일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀02.OVD_AMT      IS '연체금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_카드기획팀02.PREN_DSCD    IS '개인기업구분코드';

GRANT SELECT ON TB_OPE_KRI_카드기획팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_카드기획팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_카드기획팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_카드기획팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_카드기획팀02 TO RL_OPE_SEL;

EXIT
