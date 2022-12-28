DROP TABLE OPEOWN.TB_OPE_KRI_감사기획팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_감사기획팀01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,EXE_NO                                   VARCHAR2(14)   -- 감사실시번호
  ,PTO_SNO                                  NUMBER(4)      -- 지적일련번호
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,PTO_NO                                   VARCHAR2(14)   -- 지적번호
  ,PTO_DTT_CD_NM                            VARCHAR2(256)  -- 지적구분코드명  
  ,OCC_DT                                   VARCHAR2(8)    -- 발생일자
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_감사기획팀01                       IS 'OPE_KRI_감사기획팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_감사기획팀01.STD_DT                IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_감사기획팀01.EXE_NO                IS '실행번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_감사기획팀01.PTO_SNO               IS '지적일련번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_감사기획팀01.BRNO                  IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_감사기획팀01.BR_NM                 IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_감사기획팀01.PTO_NO                IS '지적번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_감사기획팀01.PTO_DTT_CD_NM         IS '지적구분코드명';  
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_감사기획팀01.OCC_DT                IS '발생일자';  

GRANT SELECT ON TB_OPE_KRI_감사기획팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_감사기획팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_감사기획팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_감사기획팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_감사기획팀01 TO RL_OPE_SEL;

EXIT
