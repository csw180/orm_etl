DROP TABLE OPEOWN.TB_OPE_KRI_직원만족팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_직원만족팀01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,DCM_DTT                                  VARCHAR2(1)
  ,DCM_NO                                   VARCHAR2(100)
  ,DCM_TLT                                  VARCHAR2(100)
  ,DCD_RQST_DT                              VARCHAR2(8)
  ,DCD_RQMR_NM                              VARCHAR2(100)
  ,DCDR_NM                                  VARCHAR2(100)
  ,DCD_ARV_DT                               VARCHAR2(8)
  ,DCD_TMNT_DT                              VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_직원만족팀01               IS 'OPE_KRI_직원만족팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.BR_NM         IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.DCM_DTT       IS '문서구분';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.DCM_NO        IS '문서번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.DCM_TLT       IS '문서제목';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.DCD_RQST_DT   IS '결재의뢰일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.DCD_RQMR_NM   IS '결재요청자명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.DCDR_NM       IS '결재자명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.DCD_ARV_DT    IS '결재도착일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_직원만족팀01.DCD_TMNT_DT   IS '결재종결일자';

GRANT SELECT ON TB_OPE_KRI_직원만족팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_직원만족팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_직원만족팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_직원만족팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_직원만족팀01 TO RL_OPE_SEL;

EXIT
