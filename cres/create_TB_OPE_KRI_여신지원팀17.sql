DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀17;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀17
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)  
  ,CUST_DSCD_NM                            VARCHAR2(10)
  ,CHB_DAT_CTS                             VARCHAR2(1000)
  ,CHA_DAT_CTS                             VARCHAR2(1000)
  ,ENR_DT                                  VARCHAR2(8)
  ,CSLT_DT                                 VARCHAR2(8)  -- 신청일자(품의일자)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,CRCD                                    VARCHAR2(3)
  ,APRV_AMT	                               NUMBER(18,2)  -- 승인금액
  ,USR_NO                                  VARCHAR2(10)  
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀17               IS 'OPE_KRI_여신지원팀17';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.CUST_DSCD_NM IS '고객구분코드명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.CHB_DAT_CTS  IS '변경전데이터내용';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.CHA_DAT_CTS  IS '변경후데이터내용';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.ENR_DT       IS '등록일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.CSLT_DT      IS '품의일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.APRV_AMT	    IS '승인금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀17.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_여신지원팀17 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀17 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀17 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀17 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀17 TO RL_OPE_SEL;

EXIT
