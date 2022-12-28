DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)     -- 고객번호
  ,ACNO                                    VARCHAR2(12)  --  계좌번호
  ,DRM_YN                                  VARCHAR2(1)   --  휴면여부
  ,OPRF_PCS_DT                             VARCHAR2(8)   --  잡수익처리일자
  ,CRCD                                    VARCHAR2(3)   --  통화코드
  ,TR_PCPL                                 NUMBER(18,2)  --  거래원금
  ,TR_DT                                   VARCHAR2(8)   --  거래일자
  ,DPS_ACN_STCD                            VARCHAR2(2)   --  계좌상태코드
  ,USR_NO                                  VARCHAR2(10)  --  거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀01               IS 'OPE_KRI_수신제도지원팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.DRM_YN       IS '휴면여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.OPRF_PCS_DT  IS '잡수익처리일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.TR_PCPL      IS '거래원금';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.DPS_ACN_STCD IS '수신계좌상태코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀01.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀01 TO RL_OPE_SEL;

EXIT
