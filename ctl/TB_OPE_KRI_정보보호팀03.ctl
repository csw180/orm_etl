LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_������ȣ��03
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(  STD_DT
  ,RULE_NM            "TRIM(:RULE_NM)"
  ,RULE_CNT
)
