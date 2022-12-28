DROP TABLE OPEOWN.TB_OPE_KRI_IB사업본부03;

CREATE TABLE OPEOWN.TB_OPE_KRI_IB사업본부03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,INTG_ACNO                               VARCHAR2(35)
  ,CLN_EXE_NO                              NUMBER(10)
  ,PDCD                                    VARCHAR2(14)
  ,PRD_KR_NM                               VARCHAR2(100)  -- 상품한글명
  ,CRCD                                    VARCHAR2(3)
  ,LN_EXE_AMT                              NUMBER(18,2)  -- 대출실행금액
  ,LN_RMD                                  NUMBER(20,2)
  ,FC_RMD                                  NUMBER(20,2)  -- 외화잔액
  ,APC_DTT                                 VARCHAR2(10)   -- 신청구분
  ,AGR_DT                                  VARCHAR2(8)
  ,OVD_YN                                  VARCHAR2(1)
  ,CLN_OVD_DSCD                            VARCHAR2(1)    -- 연체구분코드
  ,CLN_OVD_DSCD_NM                         VARCHAR2(200)  -- 연체구분코드명
  ,OVD_AMT                                 NUMBER(18,2)   -- 연체금액
  ,OVD_OCC_DT                              VARCHAR2(8)    -- 연체발생일자
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_IB사업본부03                       IS 'OPE_KRI_IB사업본부03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.STD_DT                IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.BRNO                  IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.BR_NM                 IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.CUST_NO               IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.INTG_ACNO             IS '통합계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.CLN_EXE_NO            IS '여신실행번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.PDCD                  IS '상품코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.PRD_KR_NM             IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.CRCD                  IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.LN_EXE_AMT            IS '대출실행금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.LN_RMD                IS '대출잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.FC_RMD                IS '외화잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.APC_DTT               IS '신청구분';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.AGR_DT                IS '약정일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.OVD_YN                IS '연체여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.CLN_OVD_DSCD          IS '여신연체구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.CLN_OVD_DSCD_NM       IS '여신연체구분코드명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.OVD_AMT               IS '연체금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_IB사업본부03.OVD_OCC_DT            IS '연체발생일자';

GRANT SELECT ON TB_OPE_KRI_IB사업본부03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_IB사업본부03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_IB사업본부03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_IB사업본부03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_IB사업본부03 TO RL_OPE_SEL;

EXIT
