DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀08;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀08
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)   --  계좌번호
  ,CUST_NO                                 NUMBER(9)
  ,TSK_DSCD                                VARCHAR2(1)    --  업무구분코드
  ,CFWR_ISN_NO                             NUMBER(15)  -- 증명서발급번호
  ,ISN_DT                                  VARCHAR2(8)  -- 발급일자
  ,LDGR_STCD                               VARCHAR2(1)  -- 원장상태코드 ( 3:취소)
  ,ISN_CNCL_DT                             VARCHAR2(8)  -- 발급취소일자
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀08               IS 'OPE_KRI_수신제도지원팀08';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀08.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀08.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀08.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀08.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀08.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀08.TSK_DSCD     IS '업무구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀08.CFWR_ISN_NO   IS '증명서발급번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀08.ISN_DT       IS '발급일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀08.LDGR_STCD    IS '원장상태코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀08.ISN_CNCL_DT  IS '발급취소일자';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀08 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀08 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀08 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀08 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀08 TO RL_OPE_SEL;

EXIT
