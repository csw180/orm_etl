LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_�ڱݼ�Ź������09
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(  STD_DT
  ,BRNO
  ,BR_NM                   "TRIM(:BR_NM)"
  ,CUST_NO
  ,CUST_DTT                "TRIM(:CUST_DTT)"
  ,TR_AMT
)