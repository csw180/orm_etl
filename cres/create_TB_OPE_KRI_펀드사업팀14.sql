DROP TABLE OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14;

CREATE TABLE OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,AGE                                     NUMBER(3)
  ,NW_DT                                   VARCHAR2(8)
  ,EXPI_DT                                 VARCHAR2(8)
  ,PRD_KR_NM                               VARCHAR2(100)
  ,TR_AMT                                  NUMBER(18,2)  -- °Å·¡±Ý¾×
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14                 IS 'OPE_KRI_ÆÝµå»ç¾÷ÆÀ14';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14.STD_DT          IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14.BRNO            IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14.BR_NM           IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14.ACNO            IS '°èÁÂ¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14.CUST_NO         IS '°í°´¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14.AGE             IS '¿¬·É';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14.NW_DT           IS '½Å±ÔÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14.EXPI_DT         IS '¸¸±âÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14.PRD_KR_NM       IS '»óÇ°ÇÑ±Û¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14.TR_AMT          IS '°Å·¡±Ý¾×';

GRANT SELECT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ14 TO RL_OPE_SEL;

EXIT
