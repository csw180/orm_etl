DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀31;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀31
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CSNT_ACNO                               VARCHAR2(12)   -- 보관어음계좌번호
  ,TKCT_DT                                 VARCHAR2(8)    -- 수탁일자
  ,DFRY_DT                                 VARCHAR2(8)    -- 지급일자
  ,DLVY_DT                                 VARCHAR2(8)    -- 출고일자
  ,NML_PCS_YN                              VARCHAR2(1)    -- 정상처리여부
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀31               IS 'OPE_KRI_수신제도지원팀31';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀31.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀31.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀31.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀31.CSNT_ACNO    IS '보관어음계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀31.TKCT_DT      IS '수탁일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀31.DFRY_DT      IS '지급일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀31.DLVY_DT      IS '출고일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀31.NML_PCS_YN   IS '정상처리여부';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀31 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀31 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀31 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀31 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀31 TO RL_OPE_SEL;

EXIT
