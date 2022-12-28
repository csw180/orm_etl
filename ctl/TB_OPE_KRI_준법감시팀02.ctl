LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_ÁØ¹ý°¨½ÃÆÀ02
FIELDS TERMINATED BY '¢Ó'
TRAILING NULLCOLS
(  STD_DT
  ,BR_NM                           "TRIM(:BR_NM)"
  ,BRNO
  ,LWS_NO
--  ,LWS_DTT                         "TRIM(:LWS_DTT)"
  ,LWS_NM                          "TRIM(:LWS_NM)"
  ,LWS_AMT
  ,ACP_DT
)