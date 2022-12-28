DROP TABLE OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01;

CREATE TABLE OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,CHKG_DTT                                 VARCHAR2(1)   -- Á¡°Ë±¸ºÐ
--  ,CHKG_DTT_NM                              VARCHAR2(10)   -- Á¡°Ë±¸ºÐ¸í
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,ONL_DT                                   VARCHAR2(8)    -- ¿Â¶óÀÎÀÏÀÚ
  ,ADT_HDN                                  VARCHAR2(13)   -- °¨»çÇ×¸ñ
  ,ADT_HDN_NM                               VARCHAR2(100)  -- °¨»çÇ×¸ñ¸í
  ,CHKG_RSLT                                VARCHAR2(1)    -- Á¡°Ë°á°ú
  ,CHKG_RSLT_NM                             VARCHAR2(10)   -- Á¡°Ë°á°ú¸í
  ,CNT                                      NUMBER(4)      -- °Ç¼ö
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01               IS 'OPE_KRI_µðÁöÅÐ°¨»çÆÀ01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01.STD_DT       IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01.CHKG_DTT     IS 'Á¡°Ë±¸ºÐ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01.BRNO         IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01.BR_NM        IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01.ONL_DT       IS '¿Â¶óÀÎÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01.ADT_HDN      IS '°¨»çÇ×¸ñ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01.ADT_HDN_NM   IS '°¨»çÇ×¸ñ¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01.CHKG_RSLT      IS 'Á¡°Ë°á°ú';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01.CHKG_RSLT_NM   IS 'Á¡°Ë°á°ú¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01.CNT            IS '°Ç¼ö';

GRANT SELECT ON TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_µðÁöÅÐ°¨»çÆÀ01 TO RL_OPE_SEL;

EXIT
