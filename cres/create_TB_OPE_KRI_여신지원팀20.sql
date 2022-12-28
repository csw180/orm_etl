DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀20;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀20
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CHNL_TPCD                               VARCHAR2(4)  -- 채널유형코드
  ,CUST_NO                                 NUMBER(9)
  ,CLN_ACNO                                VARCHAR2(12)
  ,PRD_KR_NM                               VARCHAR2(100)  -- 상품한글명
  ,CRCD                                    VARCHAR2(3)
  ,CLN_APC_AMT                             NUMBER(18,2)  -- 여신신청금액
  ,APC_DT                                  VARCHAR2(8)  -- 여신신청일자
  ,CHG_YN                                  VARCHAR2(1)  -- 휴대전화변경여부
  ,CHG_ENR_DT                              VARCHAR2(8)  -- 변경등록일
  ,DEN_YN                                  VARCHAR2(1)  -- 전화문자거부여부
  ,DEN_ENR_DT                              VARCHAR2(8)  -- 거부등록일
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀20               IS 'OPE_KRI_여신지원팀20';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.CHNL_TPCD    IS '채널유형코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.CLN_ACNO     IS '여신계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.CLN_APC_AMT  IS '여신신청금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.APC_DT       IS '신청일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.CHG_YN       IS '변경여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.CHG_ENR_DT   IS '변경등록일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.DEN_YN       IS '거부여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀20.DEN_ENR_DT   IS '거부등록일자';

GRANT SELECT ON TB_OPE_KRI_여신지원팀20 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀20 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀20 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀20 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀20 TO RL_OPE_SEL;

EXIT
