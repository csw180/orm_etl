DROP TABLE OPEOWN.TB_OPE_KRI_기업지원팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_기업지원팀02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,RBCI_ISN_NO                             VARCHAR2(14)  -- 은행조회서발급번호
  ,RBCI_ISN_CD                             VARCHAR2(1)    --은행조회서발급코드(1:발급, 2:조회)
  ,ISN_DT                                  VARCHAR2(8)   -- 발급일자
  ,CHPR_NM                                 VARCHAR2(100) -- 담당자명
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_기업지원팀02               IS 'OPE_KRI_기업지원팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀02.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀02.RBCI_ISN_NO  IS '은행조회서발급번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀02.RBCI_ISN_CD  IS '은행조회서발급코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀02.ISN_DT       IS '발급일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_기업지원팀02.CHPR_NM      IS '기관신청업체담당자명';

GRANT SELECT ON TB_OPE_KRI_기업지원팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_기업지원팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_기업지원팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_기업지원팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_기업지원팀02 TO RL_OPE_SEL;

EXIT
