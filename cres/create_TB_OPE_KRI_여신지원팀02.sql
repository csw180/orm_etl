DROP TABLE OPEOWN.TB_OPE_KRI_여신지원팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_여신지원팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,INTG_ACNO                               VARCHAR2(35)
  ,CUST_NO                                 NUMBER(9)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,CRCD                                    VARCHAR2(3)
  ,AVB_LN_AMT                              NUMBER(18,2)  -- 가용여신금액
  ,STUP_AMT                                NUMBER(18,2)  -- 설정금액
  ,STUP_NO                                 VARCHAR2(12)   -- 설정번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_여신지원팀02               IS 'OPE_KRI_여신지원팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀02.INTG_ACNO    IS '통합계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀02.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀02.PRD_KR_NM    IS '상품한글명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀02.CRCD         IS '통화코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀02.AVB_LN_AMT   IS '가용여신금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀02.STUP_AMT     IS '설정금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_여신지원팀02.STUP_NO      IS '설정번호';

GRANT SELECT ON TB_OPE_KRI_여신지원팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_여신지원팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_여신지원팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_여신지원팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_여신지원팀02 TO RL_OPE_SEL;

EXIT
