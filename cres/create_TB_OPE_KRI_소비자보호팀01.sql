DROP TABLE OPEOWN.TB_OPE_KRI_소비자보호팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_소비자보호팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12) -- 계좌번호
  ,CUST_NO                                 NUMBER(9)    -- 고객번호
  ,TR_DT                                   VARCHAR2(8)  -- 거래일자
  ,BFTR_CMM_ACD_DCL_DSCD                   VARCHAR2(2)  -- 전기통신사고신고구분코드
  ,FNN_DCP_TPCD                            VARCHAR2(1)  -- 금융사기유형코드
  ,ENR_USR_NO                              VARCHAR2(10) -- 등록사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_소비자보호팀01               IS 'OPE_KRI_소비자보호팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀01.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀01.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀01.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀01.BFTR_CMM_ACD_DCL_DSCD     IS '전기통신사고신고구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀01.FNN_DCP_TPCD    IS '금융사기유형코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀01.ENR_USR_NO      IS '등록사용자번호';
  
GRANT SELECT ON TB_OPE_KRI_소비자보호팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_소비자보호팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_소비자보호팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_소비자보호팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_소비자보호팀01 TO RL_OPE_SEL;

EXIT
