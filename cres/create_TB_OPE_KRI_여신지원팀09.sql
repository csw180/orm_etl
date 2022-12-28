DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀09;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀09
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,MRT_NO                                  VARCHAR2(12)  --  담보번호
--  ,MRT_TPCD                                VARCHAR2(1)   --  담보유형코드
  ,MRT_CD                                  VARCHAR2(3)   --  담보코드
  ,OWNR_CUST_NO                            NUMBER(9)     --  소유자고객번호
  ,DBR_CUST_NO                             NUMBER(9)     --  채무자고객번호
  ,DPS_ACNO                                VARCHAR2(12)  --  수신계좌번호
  ,ENR_DT                                  VARCHAR2(8)   --  담보등록일자
  ,NW_DT                                   VARCHAR2(8)   --  예금신규일
  ,USR_NO                                  VARCHAR2(10)  -- 조작자직원번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀09               IS 'OPE_KRI_여신지원팀09';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.MRT_NO       IS '담보번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.MRT_CD       IS '담보코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.OWNR_CUST_NO IS '소유자고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.DBR_CUST_NO  IS '채무자고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.DPS_ACNO     IS '수신계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.ENR_DT       IS '등록일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.NW_DT        IS '신규일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀09.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_여신지원팀09 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀09 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀09 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀09 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀09 TO RL_OPE_SEL;

EXIT
