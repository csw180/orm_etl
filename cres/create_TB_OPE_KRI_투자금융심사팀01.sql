DROP TABLE OPEOWN.TB_OPE_KRI_투자금융심사팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_투자금융심사팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,SYS_ERLR_JDGM_GDCD                      VARCHAR2(2)  -- 시스템조기경보판정등급코드
  ,TGT_ABST_DT                             VARCHAR2(8)  -- 대상추출일자
--  ,ERLR_JDGM_RSN                           VARCHAR2(4000)  --  조기경보판정사유
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_투자금융심사팀01                 IS 'OPE_KRI_투자금융심사팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_투자금융심사팀01.STD_DT          IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_투자금융심사팀01.BRNO            IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_투자금융심사팀01.BR_NM           IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_투자금융심사팀01.CUST_NO         IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_투자금융심사팀01.SYS_ERLR_JDGM_GDCD    IS '시스템조기경보판정등급코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_투자금융심사팀01.TGT_ABST_DT     IS '대상추출일자';

GRANT SELECT ON TB_OPE_KRI_투자금융심사팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_투자금융심사팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_투자금융심사팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_투자금융심사팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_투자금융심사팀01 TO RL_OPE_SEL;

EXIT
