DROP TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01;

CREATE TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01
(
   STD_DT                                  VARCHAR2(8) NOT NULL
  ,BRNO                                    VARCHAR2(4)
  ,BR_NM                                   VARCHAR2(100)
  ,CUST_NO                                 NUMBER(9)
  ,DMD_AMT                                 NUMBER(18,2)
  ,DMD_DT                                  VARCHAR2(8)  -- Ã»±¸ÀÏÀÚ
  ,TR_DT                                   VARCHAR2(8)  -- Ã³¸®ÀÏÀÚ
) NOLOGGING;

COMMENT ON TABLE OPEOWN.TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01               IS 'OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01.STD_DT       IS '±âÁØÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01.BRNO         IS 'Á¡¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01.BR_NM        IS 'Á¡¸í';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01.CUST_NO      IS '°í°´¹øÈ£';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01.DMD_AMT      IS 'Ã»±¸±Ý¾×';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01.DMD_DT       IS 'Ã»±¸ÀÏÀÚ';
COMMENT ON COLUMN OPEOWN.TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01.TR_DT        IS '°Å·¡ÀÏÀÚ';

GRANT SELECT ON TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01 TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01 TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01 TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01 TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_KRI_ÀÚ±Ý°ü¸®ÆÀ01 TO RL_OPE_SEL;

EXIT
