DROP TABLE OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12;

CREATE TABLE OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,BLN_PCPL                                NUMBER(15)    -- ÀÜ°í¿ø±Ý
  ,PRD_KR_NM                               VARCHAR2(100)  -- »óÇ°ÇÑ±Û¸í
  ,KI_AMT                                  NUMBER(15)    -- ³«ÀÎ±Ý¾×
  ,KI_OCC_DT                               VARCHAR2(8)   -- ³«ÀÎ¹ß»ýÀÏÀÚ
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12                 IS 'OPE_KRI_ÆÝµå»ç¾÷ÆÀ12';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12.STD_DT          IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12.BRNO            IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12.BR_NM           IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12.ACNO            IS '°èÁÂ¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12.CUST_NO         IS '°í°´¹ÝÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12.BLN_PCPL        IS 'ÀÜ°í¿ø±Ý';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12.PRD_KR_NM       IS '»óÇ°ÇÑ±Û¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12.KI_AMT          IS '³«ÀÎ±Ý¾×';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12.KI_OCC_DT       IS '³«ÀÎ¹ß»ýÀÏÀÚ';

GRANT SELECT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ12 TO RL_OPE_SEL;

EXIT
