DROP TABLE OPEOWN.TB_OPE_KRI_준법감시팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_준법감시팀02
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,LWS_NO                                   VARCHAR2(20)    -- 소송번호
  --,LWS_DTT                                  VARCHAR2(4)     -- 소송구분(원고, 피고)
  ,LWS_NM                                   VARCHAR2(1000)  -- 소송내용
  ,LWS_AMT                                  NUMBER(18,2)    -- 소송금액
  ,ACP_DT                                   VARCHAR2(8)   -- 접수일자
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_준법감시팀02              IS 'OPE_KRI_준법감시팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀02.LWS_NO       IS '소송번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀02.LWS_NM       IS '소송명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀02.LWS_AMT      IS '소송금액';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_준법감시팀02.ACP_DT       IS '접수일자';

GRANT SELECT ON TB_OPE_KRI_준법감시팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_준법감시팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_준법감시팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_준법감시팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_준법감시팀02 TO RL_OPE_SEL;

EXIT
