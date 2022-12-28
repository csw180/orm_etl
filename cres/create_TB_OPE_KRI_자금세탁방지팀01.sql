DROP TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CTR_NO                                  VARCHAR2(13)
  ,CTR_DT                                  VARCHAR2(8)
  ,CUST_NO                                 NUMBER(9)
  ,CTR_AMT                                 NUMBER(20,4)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀01               IS 'OPE_KRI_자금세탁방지팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀01.CTR_NO       IS '고액현금보고번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀01.CTR_DT       IS '고액현금보고일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀01.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀01.CTR_AMT      IS '고액현금보고금액';

GRANT SELECT ON TB_OPE_KRI_자금세탁방지팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_자금세탁방지팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_자금세탁방지팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_자금세탁방지팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_자금세탁방지팀01 TO RL_OPE_SEL;

EXIT
