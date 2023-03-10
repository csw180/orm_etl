DROP TABLE OPEOWN.TB_OPE_KRI_자금관리팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_자금관리팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,DMD_AMT                                 NUMBER(18,2)
  ,DMD_DT                                  VARCHAR2(8)  -- 청구일자
  ,TR_DT                                   VARCHAR2(8)  -- 처리일자
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_자금관리팀01               IS 'OPE_KRI_자금관리팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀01.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀01.DMD_AMT      IS '청구금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀01.DMD_DT       IS '청구일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금관리팀01.TR_DT        IS '거래일자';

GRANT SELECT ON TB_OPE_KRI_자금관리팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_자금관리팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_자금관리팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_자금관리팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_자금관리팀01 TO RL_OPE_SEL;

EXIT
