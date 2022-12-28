DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀20;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀20
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,DPS_ACN_STCD                            VARCHAR2(2)
--  ,NW_DT                                   VARCHAR2(8)
  ,LST_TR_DT                               VARCHAR2(8)
  ,LDGR_RMD                                NUMBER(20,2)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀20               IS 'OPE_KRI_수신제도지원팀20';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀20.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀20.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀20.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀20.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀20.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀20.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀20.DPS_ACN_STCD IS '수신계좌상태코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀20.LST_TR_DT    IS '최종거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀20.LDGR_RMD     IS '원장잔액';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀20 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀20 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀20 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀20 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀20 TO RL_OPE_SEL;

EXIT
