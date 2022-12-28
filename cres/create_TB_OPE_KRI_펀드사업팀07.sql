DROP TABLE OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07;

CREATE TABLE OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,NW_DT                                   VARCHAR2(8)
  ,ACNO                                    VARCHAR2(12)
  ,PRD_KR_NM                               VARCHAR2(100)  -- »óÇ°ÇÑ±Û¸í
  ,CUST_NO                                 NUMBER(9)
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07                 IS 'OPE_KRI_ÆÝµå»ç¾÷ÆÀ07';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07.STD_DT          IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07.BRNO            IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07.BR_NM           IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07.NW_DT           IS '½Å±ÔÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07.ACNO            IS '°èÁÂ¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07.PRD_KR_NM       IS '»óÇ°ÇÑ±Û¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07.CUST_NO         IS '°í°´¹øÈ£';

GRANT SELECT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ07 TO RL_OPE_SEL;

EXIT
