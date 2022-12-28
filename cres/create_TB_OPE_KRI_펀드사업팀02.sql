DROP TABLE OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02;

CREATE TABLE OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,NW_DT                                   VARCHAR2(8)
  ,ACNO                                    VARCHAR2(12)
  ,CUST_NO                                 NUMBER(9)
  ,RCV_DEN_YN                              VARCHAR2(1)   -- ¼ö½Å°ÅºÎ¿©ºÎ
  ,RCV_DEN_DT                              VARCHAR2(8)   -- ¼ö½Å°ÅºÎµî·ÏÀÏ
  ,TR_AMT                                  NUMBER(18,2)  -- °Å·¡±Ý¾×
) NOLOGGING;

COMMENT ON TABLE  OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02                 IS 'OPE_KRI_ÆÝµå»ç¾÷ÆÀ02';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02.STD_DT          IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02.BRNO            IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02.BR_NM           IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02.NW_DT           IS '½Å±ÔÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02.ACNO            IS '°èÁÂ¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02.CUST_NO         IS '°í°´¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02.RCV_DEN_YN      IS '¼ö½Å°ÅºÎ¿©ºÎ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02.RCV_DEN_DT      IS '¼ö½Å°ÅºÎÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02.TR_AMT          IS '°Å·¡±Ý¾×';

GRANT SELECT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ÆÝµå»ç¾÷ÆÀ02 TO RL_OPE_SEL;

EXIT
