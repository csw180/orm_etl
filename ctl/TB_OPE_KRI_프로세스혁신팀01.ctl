LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_���μ���������01
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(  STD_DT
  ,TR_DT
  ,BRNO
  ,BR_NM                                 "TRIM(:BR_NM)"
  ,WND_DTT                               "TRIM(:WND_DTT)"
  ,TR_DTT                                "TRIM(:TR_DTT)"
  ,USER_NO
)
