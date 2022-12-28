DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀19;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀19
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,MRT_NO                                  VARCHAR2(12)  --  담보번호
  ,MRT_TPCD                                VARCHAR2(1)   --  담보유형코드
  ,MRT_CD                                  VARCHAR2(3)   --  담보코드
  ,PDCD                                    VARCHAR2(14)  --  상품코드
  ,DPS_ACNO                                VARCHAR2(12)  --  수신계좌번호
  ,ACN_DCMT_NO                             VARCHAR2(20)  --  계좌식별번호
  ,OWNR_CUST_NO                            NUMBER(9)     --  소유자고객번호
  ,DBR_CUST_NO                             NUMBER(9)     --  채무자고객번호
  ,STUP_STCD                               VARCHAR2(2)   -- 설정상태코드
  ,STUP_DT                                 VARCHAR2(8)   -- 설정일자
  ,LST_CHG_DT                              VARCHAR2(8)   -- 최종변경일자(질권해지일자)
  ,MBTL_NO_CHG_YN                          VARCHAR2(1)   -- 휴대전화번호 변경여부
  ,MBTL_NO_CHG_DT                          VARCHAR2(8)   -- 휴대전화번호 변경일
  ,RCV_DEN_YN                              VARCHAR2(1)   -- 전화문자수신거부여부
  ,RCV_DEN_ENR_DT                          VARCHAR2(8)   -- 전화문자수신거부등록일
  ,USR_NO                                  VARCHAR2(10)  -- 조작자직원번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀19               IS 'OPE_KRI_여신지원팀19';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.BRNO            IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.BR_NM           IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.MRT_NO          IS '담보번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.MRT_TPCD        IS '담보유형코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.MRT_CD          IS '담보코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.PDCD            IS '상품코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.DPS_ACNO        IS '수신계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.ACN_DCMT_NO     IS '계좌식별번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.OWNR_CUST_NO    IS '소유자고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.DBR_CUST_NO     IS '채무자고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.STUP_STCD       IS '설정상태코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.STUP_DT         IS '설정일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.LST_CHG_DT      IS '최종변경일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.MBTL_NO_CHG_YN  IS '휴대전화번호변경여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.MBTL_NO_CHG_DT  IS '휴대전화번호변경일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.RCV_DEN_YN      IS '수신거부여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.RCV_DEN_ENR_DT  IS '수신거부등록일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀19.USR_NO          IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_여신지원팀19 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀19 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀19 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀19 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀19 TO RL_OPE_SEL;

EXIT
