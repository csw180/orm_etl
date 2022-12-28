DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀14;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀14
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,SFDP_SNO                                VARCHAR2(18)   -- 점번호(4)+보호예수년도(4)_보호예수일련번호(10)
  ,SFDP_PRD_NM                             VARCHAR2(100)  -- 보호예수상품명
  ,DNC_AMT                                 NUMBER(18,2)   -- 보호예수금액
  ,NW_DT                                   VARCHAR2(8)    -- 보호예수시작일자
  ,EXPI_DT                                 VARCHAR2(8)    -- 보호예수만기일자
  ,ACCR_DCNT                               NUMBER(10)     -- 경과일수
  ,USR_NO                                  VARCHAR2(10)   -- 거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀14               IS 'OPE_KRI_수신제도지원팀14';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀14.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀14.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀14.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀14.SFDP_SNO     IS '보호예수일련번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀14.SFDP_PRD_NM  IS '보호예수상품명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀14.DNC_AMT      IS '예수금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀14.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀14.EXPI_DT      IS '만기일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀14.ACCR_DCNT    IS '경과일수';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀14.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀14 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀14 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀14 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀14 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀14 TO RL_OPE_SEL;

EXIT
