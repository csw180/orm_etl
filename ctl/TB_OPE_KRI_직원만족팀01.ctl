LOAD DATA
--CHARACTERSET UTF8
TRUNCATE
INTO TABLE TEMP_OPE_KRI_Á÷¿ø¸¸Á·ÆÀ01
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
   STD_DT
  ,BRNO
  ,BR_NM                               "TRIM(:BR_NM)"
  ,DCM_DTT
  ,DCM_NO                              "TRIM(:DCM_NO)"
  ,DCM_TLT                             "TRIM(:DCM_TLT)"
  ,DCD_RQST_DT
  ,DCD_RQMR_NM                         "TRIM(:DCD_RQMR_NM)"
  ,DCDR_NM                             "TRIM(:DCDR_NM)"
  ,DCD_ARV_DT
  ,DCD_TMNT_DT
)
