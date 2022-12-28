DROP TABLE OPEOWN.TB_OPE_KRI_외환지원팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_외환지원팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ADRE_EN_NM                              VARCHAR2(35)   -- 수취인명
  ,ADRE_FRNW_ACNO                          VARCHAR2(35)   -- 수취인계좌번호
  ,REF_NO                                  VARCHAR2(20)   --REFNO
  ,TR_DT                                   VARCHAR2(8)
  ,CRCD                                    VARCHAR2(3)    --통화코드
  ,OWMN_AMT                                NUMBER(18,2)   --당발송금금액
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_외환지원팀02               IS 'OPE_KRI_외환지원팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀02.BRNO             IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀02.BR_NM            IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀02.ADRE_EN_NM       IS '수취인영문명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀02.ADRE_FRNW_ACNO   IS '수취인외신계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀02.REF_NO           IS 'REF번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀02.TR_DT            IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀02.CRCD             IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_외환지원팀02.OWMN_AMT         IS '당발송금금액';

GRANT SELECT ON TB_OPE_KRI_외환지원팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_외환지원팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_외환지원팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_외환지원팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_외환지원팀02 TO RL_OPE_SEL;

EXIT
