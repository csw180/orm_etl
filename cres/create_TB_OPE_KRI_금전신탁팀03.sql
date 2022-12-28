DROP TABLE OPEOWN.TB_OPE_KRI_금전신탁팀03;

CREATE TABLE OPEOWN.TB_OPE_KRI_금전신탁팀03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,AGE                                     NUMBER(3)
  ,ACNO                                    VARCHAR2(12)
  ,DTL_CND_DESC                            VARCHAR2(400)  -- 상세조건설명
  ,PRD_KR_NM                               VARCHAR2(100)   -- 상품명
  ,CRCD                                    VARCHAR2(3)    -- 통화코드
  ,TR_AMT                                  NUMBER(20,2)   -- 원장잔액
  ,NW_DT                                   VARCHAR2(8)
  ,EXPI_DT                                 VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_금전신탁팀03               IS 'OPE_KRI_금전신탁팀03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.AGE          IS '연령';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.DTL_CND_DESC IS '상세조건설명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.TR_AMT       IS '거래금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_금전신탁팀03.EXPI_DT      IS '만기일자';

GRANT SELECT ON TB_OPE_KRI_금전신탁팀03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_금전신탁팀03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_금전신탁팀03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_금전신탁팀03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_금전신탁팀03 TO RL_OPE_SEL;

EXIT
