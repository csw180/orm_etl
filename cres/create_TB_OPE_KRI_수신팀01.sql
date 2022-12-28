DROP TABLE OPEOWN.TB_OPE_KRI_수신팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_수신팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)   --  계좌번호
  ,DPS_TSK_CD                              VARCHAR2(4)  -- 수신업무코드
  ,CRC_DT                                  VARCHAR2(8)  -- 정정거래일자
  ,CNCL_DT                                 VARCHAR2(8)  -- 취소거래일자
  ,DPS_TR_RCD_CTS                          VARCHAR2(100)  -- 수신거래기록내용
  ,USR_NO                                  VARCHAR2(10)  -- 거래사용자번호
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_수신팀01               IS 'OPE_KRI_수신팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀01.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀01.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀01.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀01.ACNO         IS '계좌번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀01.DPS_TSK_CD       IS '수신업무코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀01.CRC_DT           IS '정정일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀01.CNCL_DT          IS '취소일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀01.DPS_TR_RCD_CTS   IS '수신거래기록내용';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_수신팀01.USR_NO       IS '사용자번호';

GRANT SELECT ON TB_OPE_KRI_수신팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_수신팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_수신팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_수신팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_수신팀01 TO RL_OPE_SEL;

EXIT
