LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_?ڱݼ?Ź??????04
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(  STD_DT
  ,BRNO
  ,BR_NM             "TRIM(:BR_NM)"
  ,STR_NO            "TRIM(:STR_NO)"
  ,STR_DT
)
