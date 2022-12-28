DROP TABLE OPEOWN.TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01;

CREATE TABLE OPEOWN.TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,TR_DT                                   VARCHAR2(8)
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,WND_DTT                                 VARCHAR2(20)    -- Ã¢±¸±¸ºÐ
  ,TR_DTT                                  VARCHAR2(10)    -- °Å·¡±¸ºÐ
  ,USER_NO                                 VARCHAR2(10)     --»ç¿ëÀÚ¹øÈ£
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01                 IS 'OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01.STD_DT          IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01.TR_DT           IS '°Å·¡ÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01.BRNO            IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01.BR_NM           IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01.WND_DTT         IS 'Ã¢±¸±¸ºÐ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01.TR_DTT          IS '°Å·¡±¸ºÐ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01.USER_NO         IS '»ç¿ëÀÚ¹øÈ£';

GRANT SELECT ON TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ÇÁ·Î¼¼½ºÇõ½ÅÆÀ01 TO RL_OPE_SEL;

EXIT
