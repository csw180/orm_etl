#! /bin/ksh
. ${OPEHOME}/.profile

dbcon=`/opeapp/common/config/get_connection_string.sh OPE`
#echo 'dbcon '${dbcon}

SQL_FILE="/opeapp/sql/init/ins_TB_OPE_KRI_여신지원팀01.sql"
echo $@

# SQL실행
sqlplus -s $dbcon > /opeapp/logs/init_ins_TB_OPE_KRI_여신지원팀01.log << EOF
SET SERVEROUTPUT ON
    @${SQL_FILE} $@
EOF

cat /opeapp/logs/init_ins_TB_OPE_KRI_여신지원팀01.log

