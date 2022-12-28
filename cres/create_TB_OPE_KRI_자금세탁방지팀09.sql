DROP TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09;

CREATE TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09
(
   STD_DT                                   VARCHAR2(8) NOT NULL
  ,BRNO                                     VARCHAR2(4)
  ,BR_NM                                    VARCHAR2(100)
  ,CUST_NO                                  NUMBER(9)
  ,CUST_DTT                                 VARCHAR2(20)  -- °í°´±¸ºÐ(1:70¼¼ÀÌ»ó,2:¹Ì¼º³âÀÚ,3:½Å¿ëºÒ·®ÀÚ)
  ,TR_AMT                                   NUMBER(20,4)  --  °Å·¡±Ý¾×(¿ä±¸ºÒ+ÀúÃà¼º)
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09               IS 'OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09.STD_DT       IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09.BRNO         IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09.BR_NM        IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09.CUST_NO      IS '°í°´¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09.CUST_DTT     IS '°í°´±¸ºÐ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09.TR_AMT       IS '°Å·¡±Ý¾×';

GRANT SELECT ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ09 TO RL_OPE_SEL;

EXIT
