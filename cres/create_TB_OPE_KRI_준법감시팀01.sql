DROP TABLE OPEOWN.TB_OPE_KRI_준법감시팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_준법감시팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,DPS_DP_DSCD                             VARCHAR2(1)    -- 수신예금구분코드
  ,NW_DT                                   VARCHAR2(8)
  ,LDGR_RMD                                NUMBER(20, 2)
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_준법감시팀01              IS 'OPE_KRI_준법감시팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀01.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀01.DPS_DP_DSCD  IS '수신예금구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀01.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀01.LDGR_RMD     IS '원장잔액';

GRANT SELECT ON TB_OPE_KRI_준법감시팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_준법감시팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_준법감시팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_준법감시팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_준법감시팀01 TO RL_OPE_SEL;

EXIT
