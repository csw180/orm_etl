DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀23;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀23
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)           -- 추가
  ,BR_NM                                   VARCHAR2(100)         -- 추가
  ,CHNL_TPCD                               VARCHAR2(4)   -- 채널유형코드
  ,CUST_NO                                 NUMBER(9)     -- 고객번호
  ,ACNO                                    VARCHAR2(12)  -- 계좌번호
  ,PRD_KR_NM                               VARCHAR2(100) -- 상품한글명
  ,CRCD                                    VARCHAR2(3)   -- 통화코드
  ,TR_AMT                                  NUMBER(18,2)  -- 거래금액
  ,TR_DT                                   VARCHAR2(8)   -- 거래일자
  ,MBTL_NO_CHG_YN                          VARCHAR2(1)   -- 휴대전화번호 변경여부
  ,MBTL_NO_CHG_DTTM                        VARCHAR2(8)   -- 휴대전화번호 변경일
  ,RCV_DEN_YN                              VARCHAR2(1)   -- 전화문자수신거부여부
  ,RCV_DEN_ENR_DTTM                        VARCHAR2(8)   -- 전화문자수신거부등록일
  ,USR_NO                                  VARCHAR2(10)   -- 거래사용자번호  추가
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀23               IS 'OPE_KRI_수신제도지원팀23';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.CHNL_TPCD         IS '채널유형코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.CUST_NO           IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.ACNO              IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.PRD_KR_NM         IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.CRCD              IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.TR_AMT            IS '거래금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.TR_DT             IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.MBTL_NO_CHG_YN    IS '휴대전화번호변경여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.MBTL_NO_CHG_DTTM  IS '휴대전화번호변경일시';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.RCV_DEN_YN        IS '수신거부여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.RCV_DEN_ENR_DTTM  IS '수신거부등록일시';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀23.USR_NO            IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀23 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀23 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀23 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀23 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀23 TO RL_OPE_SEL;
