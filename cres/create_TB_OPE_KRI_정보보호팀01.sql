DROP TABLE OPEOWN.TB_OPE_KRI_정보보호팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_정보보호팀01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BR_NM                                    VARCHAR2(100)
  ,USR_NM                                   VARCHAR2(100)
  ,USR_ID                                   VARCHAR2(10)
  ,FL_CNT                                   NUMBER(10)
  ,PTR_CNT                                  NUMBER(10)
  ,ADTG_TP                                  VARCHAR2(1)  -- 검사유형
  ,ADTG_DT                                  VARCHAR2(8)   -- 검사완료일
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_정보보호팀01              IS 'OPE_KRI_정보보호팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀01.USR_NM       IS '사용자명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀01.USR_ID       IS '사용자ID';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀01.FL_CNT       IS '파일수';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀01.PTR_CNT      IS '패턴수';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀01.ADTG_TP      IS '검사유형';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀01.ADTG_DT      IS '검사일자';

GRANT SELECT ON TB_OPE_KRI_정보보호팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_정보보호팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_정보보호팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_정보보호팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_정보보호팀01 TO RL_OPE_SEL;

EXIT
