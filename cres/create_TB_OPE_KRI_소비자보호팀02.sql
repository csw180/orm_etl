DROP TABLE OPEOWN.TB_OPE_KRI_소비자보호팀02;

CREATE TABLE OPEOWN.TB_OPE_KRI_소비자보호팀02
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,CHNL_CD                                  VARCHAR2(30)
  ,CVPL_NO                                  VARCHAR2(20)  -- 민원번호
  ,CVPL_SNO                                 VARCHAR2(2)   -- 민원일련번호
  ,CVPL_CTS                                 VARCHAR2(200)  --  민원내용
  ,ACP_DT                                   VARCHAR2(8)   -- 민원접수일자
  ,TRNT_DPT                                 VARCHAR2(100)   -- 이첩부서
  ,CVPL_DTT                                 VARCHAR2(10)   -- 민원구분
  ,PCS_TMLM_DT                              VARCHAR2(8)   --  처리기한
  ,PCS_CMPL_DT                              VARCHAR2(8)   -- 처리완료일자
  ,PCS_EMNM                                 VARCHAR2(100)  -- 민원처리직원번호
  ,PRD_DTT                                  VARCHAR2(100)   --  상품구분
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_소비자보호팀02               IS 'OPE_KRI_소비자보호팀02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.STD_DT       IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.BRNO         IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.BR_NM        IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.CHNL_CD      IS '채널코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.CVPL_NO      IS '민원번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.CVPL_SNO     IS '민원일련번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.CVPL_CTS     IS '민원내용';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.ACP_DT       IS '접수일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.TRNT_DPT     IS '이첩부서';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.CVPL_DTT     IS '민원구분';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.PCS_TMLM_DT  IS '처리기한일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.PCS_CMPL_DT  IS '처리완료일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.PCS_EMNM     IS '처리직원번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_소비자보호팀02.PRD_DTT      IS '상품구분';

GRANT SELECT ON TB_OPE_KRI_소비자보호팀02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_소비자보호팀02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_소비자보호팀02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_소비자보호팀02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_소비자보호팀02 TO RL_OPE_SEL;

EXIT
