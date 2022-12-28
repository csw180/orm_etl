DROP TABLE OPEOWN.TB_OPE_KRI_개인금융심사팀01;

CREATE TABLE OPEOWN.TB_OPE_KRI_개인금융심사팀01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_DSCD                               VARCHAR2(2)     -- 고객구분코드
  ,CUST_NO                                 NUMBER(9)
  ,CLN_JUD_RPST_NO                         VARCHAR2(14)    -- 여신심사대표번호
  ,APRV_CND_EXE_BNF_DSCD                   VARCHAR2(1)     -- 승인조건실행전후구분코드
  ,APRV_CND_FLF_FRQ_DSCD                   VARCHAR2(2)     -- 승인조건이행주기구분코드
  ,JUD_APRV_CND_CTS                        VARCHAR2(1000)  -- 심사승인조건내용
  ,APRV_CND_NEXT_FLF_PARN_DT               VARCHAR2(8)     -- 승인조건다음이행예정일자
  ,RSBL_XMRL_USR_NO                        VARCHAR2(10)    -- 담당심사역사용자번호
  ,JDGR_NM                                 VARCHAR2(100)   -- 심사반명
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_개인금융심사팀01                       IS 'OPE_KRI_개인금융심사팀01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.STD_DT                IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.BRNO                  IS '점번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.BR_NM                 IS '점명';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.CUST_DSCD             IS '고객구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.CUST_NO               IS '고객번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.CLN_JUD_RPST_NO       IS '심사대표번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.APRV_CND_EXE_BNF_DSCD IS '승인조건실행전후구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.APRV_CND_FLF_FRQ_DSCD IS '승인조건이행주기구분코드';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.JUD_APRV_CND_CTS      IS '심사승인조건내용';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.APRV_CND_NEXT_FLF_PARN_DT   IS '승인조건다음이행예정일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.RSBL_XMRL_USR_NO      IS '담당심사역사용자번호';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_개인금융심사팀01.JDGR_NM               IS '심사반명';

GRANT SELECT ON TB_OPE_KRI_개인금융심사팀01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_개인금융심사팀01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_개인금융심사팀01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_개인금융심사팀01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_개인금융심사팀01 TO RL_OPE_SEL;

EXIT
