DROP TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀07;

CREATE TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀07
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,TR_AMT                                   NUMBER(20,4)  -- 무기명상품서비스거래금액
  ,RLT_ACNO                                 VARCHAR2(20)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀07               IS 'OPE_KRI_자금세탁방지팀07';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀07.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀07.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀07.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀07.TR_AMT       IS '거래금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀07.RLT_ACNO     IS '관련계좌번호';

GRANT SELECT ON TB_OPE_KRI_자금세탁방지팀07 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_자금세탁방지팀07 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_자금세탁방지팀07 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_자금세탁방지팀07 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_자금세탁방지팀07 TO RL_OPE_SEL;

EXIT
