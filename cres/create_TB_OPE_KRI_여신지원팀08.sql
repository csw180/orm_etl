DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀08;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀08
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,MRT_NO                                  VARCHAR2(12)  --  담보번호
  --,MRT_TPCD                                VARCHAR2(1)   --  담보유형코드
  ,MRT_CD                                  VARCHAR2(3)   --  담보코드
  ,DPS_ACNO                                VARCHAR2(12)  --  수신계좌번호
  ,OWNR_CUST_NO                            NUMBER(9)     --  소유자고객번호
  ,DBR_CUST_NO                             NUMBER(9)     --  채무자고객번호
  ,STUP_STCD                               VARCHAR2(2)   -- 설정상태코드
  ,STUP_DT                                 VARCHAR2(8)   -- 설정일자
  ,LST_CHG_DT                              VARCHAR2(8)   -- 최종변경일자(질권해지일자)
  ,MBTL_NO_CHG_YN                          VARCHAR2(1)   -- 휴대전화번호 변경여부
  ,MBTL_NO_CHG_DTTM                        VARCHAR2(8)   -- 휴대전화번호 변경일
  ,RCV_DEN_YN                              VARCHAR2(1)   -- 전화문자수신거부여부
  ,RCV_DEN_ENR_DTTM                        VARCHAR2(8)   -- 전화문자수신거부등록일
  ,USR_NO                                  VARCHAR2(10)  -- 등록사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀08               IS 'OPE_KRI_여신지원팀08';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.MRT_NO       IS '담보번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.MRT_CD       IS '담보코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.DPS_ACNO     IS '수신계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.OWNR_CUST_NO IS '소유자고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.DBR_CUST_NO  IS '채무자고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.STUP_STCD    IS '설정상태코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.STUP_DT      IS '설정일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.LST_CHG_DT   IS '최종변경일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.MBTL_NO_CHG_YN       IS '휴대전화번호변경여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.MBTL_NO_CHG_DTTM     IS '휴대전화번호변경일시';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.RCV_DEN_YN           IS '수신거부여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.RCV_DEN_ENR_DTTM     IS '수신거부등록일시';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀08.USR_NO               IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_여신지원팀08 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀08 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀08 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀08 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀08 TO RL_OPE_SEL;

EXIT
