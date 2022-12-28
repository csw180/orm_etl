LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_ÀÚ±Ý¼¼Å¹¹æÁöÆÀ12
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(  STD_DT
  ,BRNO
  ,BR_NM                       "TRIM(:BR_NM)"
  ,OCC_DT
  ,STR_NO                     "TRIM(:STR_NO)"
  ,TR_AMT
)