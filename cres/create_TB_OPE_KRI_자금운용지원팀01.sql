DROP TABLE OPEOWN.TB_OPE_KRI_자금운용지원팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_자금운용지원팀01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
--  ,TR_DT                                    VARCHAR2(8)   -- 거래일자
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,DLN_STLM_NO                              NUMBER(9)     -- 매매결제번호
  ,EXPI_DT                                  VARCHAR2(8)   -- 만기일자
  ,STLM_DT                                  VARCHAR2(8)   -- 결제일자
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_자금운용지원팀01               IS 'OPE_KRI_자금운용지원팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금운용지원팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금운용지원팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금운용지원팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금운용지원팀01.DLN_STLM_NO  IS '매매결제번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금운용지원팀01.EXPI_DT      IS '만기일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_자금운용지원팀01.STLM_DT      IS '결제일자';

GRANT SELECT ON TB_OPE_KRI_자금운용지원팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_자금운용지원팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_자금운용지원팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_자금운용지원팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_자금운용지원팀01 TO RL_OPE_SEL;

EXIT
