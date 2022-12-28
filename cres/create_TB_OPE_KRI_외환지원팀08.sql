DROP TABLE OPEOWN.TB_OPE_KRI_외환지원팀08;

CREATE TABLE OPEOWN.TB_OPE_KRI_외환지원팀08
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,REF_NO                                  VARCHAR2(20)
  ,ACP_DT                                  VARCHAR2(8)
  ,LC_ADC_PGRS_STCD                        VARCHAR2(1)
  ,USR_NO                                  VARCHAR2(10)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_외환지원팀08               IS 'OPE_KRI_외환지원팀08';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀08.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀08.BRNO              IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀08.BR_NM             IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀08.REF_NO            IS 'REF번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀08.ACP_DT            IS '접수일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀08.LC_ADC_PGRS_STCD  IS '신용장통지진행상태코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀08.USR_NO            IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_외환지원팀08 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_외환지원팀08 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_외환지원팀08 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_외환지원팀08 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_외환지원팀08 TO RL_OPE_SEL;

EXIT
