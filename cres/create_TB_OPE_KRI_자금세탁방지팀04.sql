DROP TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04;

CREATE TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,STR_NO                                   VARCHAR2(50)
  ,STR_DT                                   VARCHAR2(8)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04               IS 'OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04.STD_DT       IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04.BRNO         IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04.BR_NM        IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04.STR_NO       IS 'ÇøÀÇ°Å·¡º¸°í¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04.STR_DT       IS 'ÇøÀÇ°Å·¡º¸°íÀÏÀÚ';

GRANT SELECT ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ04 TO RL_OPE_SEL;

EXIT
