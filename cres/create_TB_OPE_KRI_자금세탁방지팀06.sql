DROP TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀06;

CREATE TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀06
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)           -- 추가
  ,BR_NM                                   VARCHAR2(100)         -- 추가
  ,CUST_NO                                 NUMBER(9)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀06               IS 'OPE_KRI_자금세탁방지팀06';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀06.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀06.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀06.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀06.CUST_NO      IS '고객번호';

GRANT SELECT ON TB_OPE_KRI_자금세탁방지팀06 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_자금세탁방지팀06 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_자금세탁방지팀06 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_자금세탁방지팀06 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_자금세탁방지팀06 TO RL_OPE_SEL;
