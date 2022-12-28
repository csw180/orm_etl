DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀11;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀11
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)     -- 고객번호
  ,ACNO                                    VARCHAR2(12)  --  계좌번호
  ,DPS_DP_DSCD                             VARCHAR2(1)  --  수신예금구분코드
  ,NW_DT                                   VARCHAR2(8)  --  신규일자
  ,EXPI_DT                                 VARCHAR2(8)  --  만기일자
  ,TR_DT                                   VARCHAR2(8)  --  거래일자
  ,TR_TM                                   VARCHAR2(6)  --  거래시각
  ,CRCD                                    VARCHAR2(3)   --  통화코드
  ,LDGR_RMD                                NUMBER(20,2)  --  원장잔액
  ,TR_PCPL                                 NUMBER(18,2)  --  거래원금
  ,USR_NO                                  VARCHAR2(10)  --  거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀11               IS 'OPE_KRI_수신제도지원팀11';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.DPS_DP_DSCD  IS '수신예금구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.EXPI_DT      IS '만기일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.TR_TM        IS '거래시간';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.LDGR_RMD     IS '원장잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.TR_PCPL      IS '거래원금';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀11.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀11 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀11 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀11 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀11 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀11 TO RL_OPE_SEL;

EXIT
