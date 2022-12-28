DROP TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12;

CREATE TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,OCC_DT                                   VARCHAR2(8)
  ,STR_NO                                   VARCHAR2(50)
  ,TR_AMT                                   NUMBER(20,4)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12               IS 'OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12.STD_DT       IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12.BRNO         IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12.BR_NM        IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12.OCC_DT       IS '¹ß»ýÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12.STR_NO       IS 'ÇøÀÇ°Å·¡º¸°í¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12.TR_AMT       IS '°Å·¡±Ý¾×';

GRANT SELECT ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12 TO RL_OPE_SEL;

EXIT
