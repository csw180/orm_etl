DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀10;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀10
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)   --  계좌번호
  ,CUST_NO                                 NUMBER(9)
  ,NW_DT                                   VARCHAR2(8)  -- 신규일자
  ,ISN_YN                                  VARCHAR2(1)  -- 발급여부
  ,ISN_DT                                  VARCHAR2(8)  -- 발급일자
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀10               IS 'OPE_KRI_수신제도지원팀10';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀10.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀10.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀10.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀10.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀10.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀10.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀10.ISN_YN       IS '발급여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀10.ISN_DT       IS '발급일자';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀10 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀10 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀10 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀10 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀10 TO RL_OPE_SEL;

EXIT
