DROP TABLE OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05;

CREATE TABLE OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,NW_DT                                   VARCHAR2(8)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,RCV_DEN_YN                              VARCHAR2(1)   -- ¼ö·É°ÅºÎ¼±ÅÃ¿©ºÎ
  ,TR_AMT                                  NUMBER(18,2)  -- °Å·¡±Ý¾×
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05                 IS 'OPE_KRI_ÆÝµå»ç¾÷ÆÀ05';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05.STD_DT          IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05.BRNO            IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05.BR_NM           IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05.NW_DT           IS '½Å±ÔÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05.ACNO            IS '°èÁÂ¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05.CUST_NO         IS '°í°´¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05.RCV_DEN_YN      IS '¼ö½Å°ÅºÎ¿©ºÎ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05.TR_AMT          IS '°Å·¡±Ý¾×';

GRANT SELECT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ05 TO RL_OPE_SEL;

EXIT
