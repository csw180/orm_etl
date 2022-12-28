DROP TABLE OPEOWN.TB_OPE_KRI_인사팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_인사팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,EMP_DTT                                 VARCHAR2(8)  -- 직원구분코드
  ,EMP_DTT_NM                              VARCHAR2(20)  -- 직원구분명
  ,EMP_NO                                  VARCHAR2(10)  -- 사번
  ,RTRM_DT                                 VARCHAR2(8)  -- 퇴사일
  ,RTRM_YN                                 VARCHAR2(1)  -- 퇴직여부
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_인사팀01               IS 'OPE_KRI_인사팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_인사팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_인사팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_인사팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_인사팀01.EMP_DTT      IS '직원구분';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_인사팀01.EMP_DTT_NM   IS '직원구분명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_인사팀01.EMP_NO       IS '직원번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_인사팀01.RTRM_DT      IS '퇴직일';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_인사팀01.RTRM_YN      IS '퇴직여부';

GRANT SELECT ON TB_OPE_KRI_인사팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_인사팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_인사팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_인사팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_인사팀01 TO RL_OPE_SEL;

EXIT
