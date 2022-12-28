LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_소비자보호팀02
FIELDS TERMINATED BY '†'
TRAILING NULLCOLS
(  STD_DT
  ,BRNO
  ,BR_NM              "TRIM(:BR_NM)"
  ,CHNL_CD            "TRIM(:CHNL_CD)"
  ,CVPL_NO 
  ,CVPL_SNO                              
  ,CVPL_CTS           "TRIM(:CVPL_CTS)"
  ,ACP_DT                          
  ,TRNT_DPT           "TRIM(:TRNT_DPT)"
  ,CVPL_DTT           "TRIM(:CVPL_DTT)"
  ,PCS_TMLM_DT                              
  ,PCS_CMPL_DT                          
  ,PCS_EMNM           "TRIM(:PCS_EMNM)"
  ,PRD_DTT            "TRIM(:PRD_DTT)"
)
