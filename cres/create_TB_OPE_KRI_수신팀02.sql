DROP TABLE OPEOWN.TB_OPE_KRI_수신팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,TR_DT                                   VARCHAR2(8)
  ,DPS_TSK_TR_CD                           VARCHAR2(7)   -- 수신업무거래코드
  ,CRCD                                    VARCHAR2(3)
  ,TR_AMT                                  NUMBER(18,2)  -- 거래금액
  ,USR_NO                                  VARCHAR2(10)  -- 거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신팀02               IS 'OPE_KRI_수신팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀02.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀02.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀02.DPS_TSK_TR_CD     IS '수신업무거래코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀02.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀02.TR_AMT       IS '거래금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀02.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신팀02 TO RL_OPE_SEL;

EXIT
