DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀06;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀06
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,IMCW_SBCD                               VARCHAR2(3)   -- 중요증서과목코드
  ,BNKB_ISN_RSCD                           VARCHAR2(1)   -- 통장발급사유코드
  ,ENR_DT                                  VARCHAR2(8)   -- 등록일자
  ,USR_NO                                  VARCHAR2(10)  -- 사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀06               IS 'OPE_KRI_수신제도지원팀06';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀06.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀06.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀06.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀06.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀06.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀06.IMCW_SBCD    IS '중요증서과목코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀06.BNKB_ISN_RSCD    IS '통장발급사유코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀06.ENR_DT       IS '등록일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀06.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀06 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀06 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀06 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀06 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀06 TO RL_OPE_SEL;

EXIT
