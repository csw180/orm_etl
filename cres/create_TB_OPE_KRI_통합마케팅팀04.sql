DROP TABLE OPEOWN.TB_OPE_KRI_통합마케팅팀04;

CREATE TABLE OPEOWN.TB_OPE_KRI_통합마케팅팀04
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CRM_GD                                  VARCHAR2(2)
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_통합마케팅팀04                 IS 'OPE_KRI_통합마케팅팀04';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀04.STD_DT          IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀04.BRNO            IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀04.BR_NM           IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀04.CUST_NO         IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀04.CRM_GD          IS 'CRM등급';

GRANT SELECT ON TB_OPE_KRI_통합마케팅팀04 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_통합마케팅팀04 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_통합마케팅팀04 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_통합마케팅팀04 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_통합마케팅팀04 TO RL_OPE_SEL;

EXIT
