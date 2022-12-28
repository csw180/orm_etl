DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀21;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀21
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)      -- 고객번호
  ,CUST_INF_CHG_SNO                        NUMBER(10)     -- 고객정보변경일련번호
  ,INTG_ACNO                               VARCHAR2(35)   -- 통합계좌번호
  ,PDCD                                    VARCHAR2(14)   --  상품코드
  ,PRD_KR_NM                               VARCHAR2(100)  -- 상품한글명
  ,CRCD                                    VARCHAR2(3)    -- 통화코드
  ,LN_RMD                                  NUMBER(20, 2)  -- 대출잔액
  ,TL_RCV_DEN_YN                           VARCHAR2(1)    -- 전화통화거부여부
  ,TL_RCV_ENR_DT                           VARCHAR2(8)    -- 전화통화거부등록일시
  ,SMS_RCV_DEN_YN                          VARCHAR2(1)    -- SMS수신거부여부
  ,SMS_RCV_ENR_DT                          VARCHAR2(8)    -- SMS수신거부등록일시
  ,USR_NO                                  VARCHAR2(10)   -- 등록사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀21               IS 'OPE_KRI_여신지원팀21';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.BRNO               IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.BR_NM              IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.CUST_NO            IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.CUST_INF_CHG_SNO   IS '고객정보변경일련번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.INTG_ACNO          IS '통합계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.PDCD               IS '상품코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.PRD_KR_NM          IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.CRCD               IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.LN_RMD             IS '여신잔액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.TL_RCV_DEN_YN      IS '전화수신거부여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.TL_RCV_ENR_DT      IS '전화수신등록일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.SMS_RCV_DEN_YN     IS 'SMS수신거부여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.SMS_RCV_ENR_DT     IS 'SMS수신등록일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀21.USR_NO             IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_여신지원팀21 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀21 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀21 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀21 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀21 TO RL_OPE_SEL;

EXIT
