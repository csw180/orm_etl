DROP TABLE OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05;

CREATE TABLE OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,ACNO                                    VARCHAR2(12)
  ,NW_DT                                   VARCHAR2(8)
  ,EXPI_DT                                 VARCHAR2(8)
  ,PRD_KR_NM                               VARCHAR2(100)   -- »óÇ°¸í  
  ,PAR_AMT                                 NUMBER(18,2)    -- ¾×¸é±Ý¾×
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05               IS 'OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05.STD_DT       IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05.BRNO         IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05.BR_NM        IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05.CUST_NO      IS '°í°´¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05.ACNO         IS '°èÁÂ¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05.NW_DT        IS '½Å±ÔÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05.EXPI_DT      IS '¸¸±âÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05.PRD_KR_NM    IS '»óÇ°ÇÑ±Û¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05.PAR_AMT      IS '¾×¸é±Ý¾×';

GRANT SELECT ON TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_±ÝÀü½ÅÅ¹ÆÀ05 TO RL_OPE_SEL;

EXIT
