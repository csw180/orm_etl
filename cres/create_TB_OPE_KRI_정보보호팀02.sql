DROP TABLE OPEOWN.TB_OPE_KRI_정보보호팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_정보보호팀02
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,VDCT_DT                                  VARCHAR2(8)     -- 소명일
  ,LCLS                                     VARCHAR2(100)   -- 대분류
  ,SCLS                                     VARCHAR2(100)   -- 소분류
  ,SNRO_NM                                  VARCHAR2(100)   -- 시나리오명
  ,USR_ID                                   VARCHAR2(10)    -- 대상자ID
  ,USR_NM                                   VARCHAR2(100)   -- 대상자명
  ,BR_NM                                    VARCHAR2(100)   -- 부서명
  ,CNF_STS                                  VARCHAR2(100)  -- 대응상태
  ,VDCT_RQS_DT                              VARCHAR2(8)    -- 소명요청일
  ,OCC_DT                                   VARCHAR2(8)    -- 발생완료일
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_정보보호팀02              IS 'OPE_KRI_정보보호팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.VDCT_DT      IS '소명일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.LCLS         IS '대분류';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.SCLS         IS '소분류';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.SNRO_NM      IS '시나리오명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.USR_ID       IS '사용자ID';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.USR_NM       IS '사용자명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.CNF_STS      IS '대응상태';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.VDCT_RQS_DT  IS '소명요청일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_정보보호팀02.OCC_DT       IS '발생일자';

GRANT SELECT ON TB_OPE_KRI_정보보호팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_정보보호팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_정보보호팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_정보보호팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_정보보호팀02 TO RL_OPE_SEL;

EXIT
