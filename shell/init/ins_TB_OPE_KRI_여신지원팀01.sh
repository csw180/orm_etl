#! /bin/ksh
. ${OPEHOME}/.profile

dbcon=`/opeapp/common/config/get_connection_string.sh OPE`
#echo 'dbcon '${dbcon}

SQL_FILE="/opeapp/sql/init/ins_TB_OPE_KRI_����������01.sql"
echo $@

# SQL����
sqlplus -s $dbcon > /opeapp/logs/init_ins_TB_OPE_KRI_����������01.log << EOF
SET SERVEROUTPUT ON
    @${SQL_FILE} $@
EOF

cat /opeapp/logs/init_ins_TB_OPE_KRI_����������01.log

