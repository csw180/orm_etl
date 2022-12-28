DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀26;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀26
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ASP_ACNO                                VARCHAR2(12)  -- 별단계좌번호
  ,ASP_TXIM_KDCD                           VARCHAR2(2)   -- 별단세목종류코드
  ,ROM_DT                                  VARCHAR2(8)   -- 입금일자
  ,DFRY_DT                                 VARCHAR2(8)   -- 지급일자
  ,DFRY_AMT                                NUMBER(18,2)  -- 지급금액
  ,USR_NO                                  VARCHAR2(10)  -- 사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀26               IS 'OPE_KRI_수신제도지원팀26';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀26.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀26.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀26.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀26.ASP_ACNO     IS '별단계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀26.ASP_TXIM_KDCD  IS '별단세목종류코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀26.ROM_DT       IS '입금일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀26.DFRY_DT      IS '지급일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀26.DFRY_AMT     IS '지급금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀26.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀26 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀26 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀26 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀26 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀26 TO RL_OPE_SEL;

EXIT
