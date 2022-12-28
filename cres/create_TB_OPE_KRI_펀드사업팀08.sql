DROP TABLE OPEOWN.TB_OPE_KRI_펀드사업팀08;

CREATE TABLE OPEOWN.TB_OPE_KRI_펀드사업팀08
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,ASP_TXIM_KDCD                           VARCHAR2(2)   -- 별단세목종류코드
  ,ASP_DFRY_PSB_RMD                        NUMBER(18,2)  -- 별단지급가능잔액
  ,TR_RCFM_DT                              VARCHAR2(8)   -- 거래기산일자
  ,USR_NO                                  VARCHAR2(10)  -- 등록사용자번호
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_펀드사업팀08                 IS 'OPE_KRI_펀드사업팀08';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_펀드사업팀08.STD_DT          IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_펀드사업팀08.BRNO               IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_펀드사업팀08.BR_NM              IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_펀드사업팀08.ACNO               IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_펀드사업팀08.ASP_TXIM_KDCD      IS '별단세목종류코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_펀드사업팀08.ASP_DFRY_PSB_RMD   IS '별단지급가능잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_펀드사업팀08.TR_RCFM_DT         IS '거래기산일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_펀드사업팀08.USR_NO             IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_펀드사업팀08 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_펀드사업팀08 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_펀드사업팀08 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_펀드사업팀08 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_펀드사업팀08 TO RL_OPE_SEL;

EXIT
