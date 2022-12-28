DROP TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀07;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀07
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)   --  계좌번호
  ,CUST_NO                                 NUMBER(9)
  ,TR_AMT                                  NUMBER(18,2)  -- 거래금액
  ,DPS_TR_STCD                             VARCHAR2(1)   -- 2:'정정' 3:'취소'
  ,OGTR_DT                                 VARCHAR2(8)   -- 입금거래일자
  ,TR_DT                                   VARCHAR2(8)   -- 취소거래일자
  ,USR_NO                                  VARCHAR2(10)  -- 거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신제도지원팀07               IS 'OPE_KRI_수신제도지원팀07';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀07.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀07.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀07.BR_NM        IS '정명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀07.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀07.CUST_NO      IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀07.TR_AMT       IS '거래금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀07.DPS_TR_STCD  IS '수신거래상태코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀07.OGTR_DT      IS '원거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀07.TR_DT        IS '거래일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신제도지원팀07.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신제도지원팀07 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신제도지원팀07 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신제도지원팀07 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신제도지원팀07 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신제도지원팀07 TO RL_OPE_SEL;

EXIT
