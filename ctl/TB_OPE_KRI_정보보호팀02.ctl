LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_Á¤º¸º¸È£ÆÀ02
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(  STD_DT
  ,VDCT_DT
  ,LCLS                "TRIM(:LCLS)"
  ,SCLS                "TRIM(:SCLS)"
  ,SNRO_NM             "TRIM(:SNRO_NM)"
  ,USR_ID              "TRIM(:USR_ID)"
  ,USR_NM              "TRIM(:USR_NM)"
  ,BR_NM               "TRIM(:BR_NM)"
  ,CNF_STS             "TRIM(:CNF_STS)"
  ,VDCT_RQS_DT
  ,OCC_DT
)
