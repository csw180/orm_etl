DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀22;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀22
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,CLN_EXE_NO                              NUMBER(10)
  ,CLN_TR_NO                               NUMBER(10)
  ,PDCD                                    VARCHAR2(14)
  ,PRD_KR_NM                               VARCHAR2(100)  -- 상품한글명
  ,WN_TNSL_PCPL                            NUMBER(18,2)  -- 정정원금
  ,RDM_WN_TNSL_PCPL                        NUMBER(18,2)  -- 정정후상환원금
  ,CNCL_YN                                 VARCHAR2(1)   -- 취소여부
  ,TR_DT                                   VARCHAR2(8)   -- 정정거래일자
  ,TR_TM                                   VARCHAR2(6)   -- 정정거래시간
  ,USR_NO                                  VARCHAR2(10)  -- 정정거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀22               IS 'OPE_KRI_여신지원팀22';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.BRNO               IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.BR_NM              IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.CUST_NO            IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.CLN_ACNO           IS '여신계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.CLN_EXE_NO         IS '여신실행번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.CLN_TR_NO          IS '여신거래번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.PDCD               IS '상품코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.PRD_KR_NM          IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.WN_TNSL_PCPL       IS '원화환산원금';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.RDM_WN_TNSL_PCPL   IS '상환원화환산원금';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.CNCL_YN            IS '취소여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.TR_DT              IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.TR_TM              IS '거래일시';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀22.USR_NO             IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_여신지원팀22 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀22 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀22 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀22 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀22 TO RL_OPE_SEL;

EXIT
