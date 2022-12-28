DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀13;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀13
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)  --  계좌번호
  ,CUST_NO                                 NUMBER(9)     -- 고객번호
  ,DPS_DP_DSCD                             VARCHAR2(1)  --  수신예금구분코드
  ,NW_DT                                   VARCHAR2(8)  --  신규일자
  ,CNCN_DT                                 VARCHAR2(8)  --  해지일자
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀13               IS 'OPE_KRI_수신제도지원팀13';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀13.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀13.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀13.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀13.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀13.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀13.DPS_DP_DSCD  IS '수신예금구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀13.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀13.CNCN_DT      IS '해지일자';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀13 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀13 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀13 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀13 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀13 TO RL_OPE_SEL;

EXIT
