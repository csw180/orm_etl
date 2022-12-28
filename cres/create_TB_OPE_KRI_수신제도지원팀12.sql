DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀12;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀12
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,ACNO                                    VARCHAR2(12)
  ,CRWR_DESC                               VARCHAR2(10)  -- 증서설명('실물')
  ,IMCW_NO                                 NUMBER(12)    -- 중요증서번호
  ,PRPR_AMT                                NUMBER(18,2)   -- 액면가금액
  ,LDGR_RMD                                NUMBER(20,2)  -- 원장잔액
  ,NW_DT                                   VARCHAR2(8)
  ,USR_NO                                  VARCHAR2(10)  -- 거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀12               IS 'OPE_KRI_수신제도지원팀12';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.CRWR_DESC    IS '증서설명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.IMCW_NO      IS '중요증서번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.PRPR_AMT     IS '액면가금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.LDGR_RMD     IS '원장잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀12.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀12 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀12 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀12 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀12 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀12 TO RL_OPE_SEL;

EXIT
