DROP TABLE OPEOWN.TB_OPE_KRI_통합마케팅팀03;

CREATE TABLE OPEOWN.TB_OPE_KRI_통합마케팅팀03
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,CUST_DSCD                               VARCHAR2(2)    -- 고객구분코드
  ,ENR_DTTM                                DATE
  ,CUST_APRV_STCD                          VARCHAR2(1)    -- 고객승인상태코드
  ,APC_RSN                                 VARCHAR2(200)  -- 신청사유
  ,APRV_USR_NO                             VARCHAR2(10)   -- 승인사용자번호
  ,APRV_BRNO                               VARCHAR2(4)    -- 승인점번호
  ,ENR_USR_NO                              VARCHAR2(10)   -- 등록사용자번호
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_통합마케팅팀03                 IS 'OPE_KRI_통합마케팅팀03';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.STD_DT          IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.BRNO            IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.BR_NM           IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.CUST_NO         IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.CUST_DSCD       IS '고객구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.ENR_DTTM        IS '등록일시';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.CUST_APRV_STCD  IS '고객승인상태코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.APC_RSN         IS '신청사유';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.APRV_USR_NO     IS '승인사용자번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.APRV_BRNO       IS '승인점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_통합마케팅팀03.ENR_USR_NO      IS '등록사용자번호';

GRANT SELECT ON TB_OPE_KRI_통합마케팅팀03 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_통합마케팅팀03 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_통합마케팅팀03 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_통합마케팅팀03 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_통합마케팅팀03 TO RL_OPE_SEL;

EXIT
