DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,INTG_ACNO                               VARCHAR2(35)   --  통합계좌번호
  ,CUST_NO                                 NUMBER(9)
  ,APRV_AMT                                NUMBER(18, 2)  -- 승인금액
  ,LN_RMD                                  NUMBER(20, 2)  -- 대출잔액
  ,AGR_DT                                  VARCHAR2(8)  -- 약정일자
  ,ENTP_CREV_GD                            VARCHAR2(3)  -- 기업신용평가등급
  ,EVL_AVL_DT                              VARCHAR2(8)  -- 평가유효일자
--  ,SDNS_GDCD                               VARCHAR2(1)  -- 건전성등급코드
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀01               IS 'OPE_KRI_여신지원팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀01.INTG_ACNO    IS '통합계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀01.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀01.APRV_AMT     IS '승인금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀01.LN_RMD       IS '여신잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀01.AGR_DT       IS '약정일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀01.ENTP_CREV_GD IS '기업신용평가등급';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀01.EVL_AVL_DT   IS '평가유효일자';

GRANT SELECT ON TB_OPE_KRI_여신지원팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀01 TO RL_OPE_SEL;

EXIT
