#! /bin/ksh
. ${OPEHOME}/.profile

# DB Connection 정보 가져오기
dbcon=`/opeapp/common/config/get_connection_string.sh OPE`

STD_DT=`sqlplus -s $dbcon << EOF
SET FEEDBACK OFF
SET LINESIZE 32767
SET PAGES 0
SELECT CASE WHEN STD_DT = EOTM_DT THEN EOTM_DT
            WHEN STD_DT < EOTM_DT THEN BEOM_DT 
       END
FROM   OPEOWN.TB_OPE_DT_BC
WHERE  STD_DT_YN = 'Y';
EXIT;
EOF`
#STD_DT=20220930
echo 'STD_DT='${STD_DT}

/sw/eai/batch_agent/bin/batch.sh -i ABMOPEBD0001 -t abm_02.dat -s "STD_DATE=${STD_DT}"

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi
