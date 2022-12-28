DROP TABLE OPEOWN.TB_OPE_KRI_금전신탁팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_금전신탁팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,ACNO                                    VARCHAR2(12)
  ,DTL_CND_DESC                            VARCHAR2(400)  -- 상세조건설명
  ,ISA_PRD_ACNO                            VARCHAR2(20)   -- ISA상품계좌번호
  ,PRD_KR_NM                               VARCHAR2(100)   -- 상품명
  ,CRCD                                    VARCHAR2(3)    -- 통화코드
  ,TR_AMT                                  NUMBER(20,2)   -- 원장잔액
  ,NW_DT                                   VARCHAR2(8)
  ,EXPI_DT                                 VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_금전신탁팀01               IS 'OPE_KRI_금전신탁팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.DTL_CND_DESC IS '상세조건설명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.ISA_PRD_ACNO IS 'ISA상품계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.TR_AMT       IS '거래금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀01.EXPI_DT      IS '만기일자';

GRANT SELECT ON TB_OPE_KRI_금전신탁팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_금전신탁팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_금전신탁팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_금전신탁팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_금전신탁팀01 TO RL_OPE_SEL;

EXIT
