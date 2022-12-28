DROP TABLE OPEOWN.TB_OPE_KRI_외환지원팀06;

CREATE TABLE OPEOWN.TB_OPE_KRI_외환지원팀06
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,ACNO                                     VARCHAR2(12)
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,CUST_NO                                  NUMBER(9)
  ,CUST_NAME                                VARCHAR2(100)
  ,CRCD                                     VARCHAR2(3)
  ,LN_AMT                                   NUMBER(18,2)  -- 대출금액
  ,LN_DT                                    VARCHAR2(8)   -- 대출일자
  ,CMPL_DT                                  VARCHAR2(8)   -- 해피콜완료일자
  ,USR_NO                                   VARCHAR2(10)   -- 처리담당자(사번)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_외환지원팀06               IS 'OPE_KRI_외환지원팀06';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.CUST_NAME    IS '고객명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.LN_AMT       IS '대출금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.LN_DT        IS '대출일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.CMPL_DT      IS '완료일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀06.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_외환지원팀06 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_외환지원팀06 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_외환지원팀06 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_외환지원팀06 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_외환지원팀06 TO RL_OPE_SEL;

EXIT
