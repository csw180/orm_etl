DROP TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀08;

CREATE TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀08
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,NPFT_YN_NM                              VARCHAR2(20)   -- 비영리여부명
  ,VRF_ENR_DT                              VARCHAR2(8)   --검증등록일(KYC이행일)
  ,KYC_SNO                                 NUMBER(10)  -- 고객알기제도일련번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_자금세탁방지팀08               IS 'OPE_KRI_자금세탁방지팀08';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀08.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀08.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀08.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀08.CUST_NO      IS '고객반호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀08.NPFT_YN_NM   IS '비영리여부명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀08.VRF_ENR_DT   IS '검증등록일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금세탁방지팀08.KYC_SNO      IS '고객알기제도일련번호';

GRANT SELECT ON TB_OPE_KRI_자금세탁방지팀08 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_자금세탁방지팀08 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_자금세탁방지팀08 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_자금세탁방지팀08 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_자금세탁방지팀08 TO RL_OPE_SEL;

EXIT
