LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_�ع�������02
FIELDS TERMINATED BY '��'
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