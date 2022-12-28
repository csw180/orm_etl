#! /bin/ksh
. ${OPEHOME}/.profile

dbcon=`/opeapp/common/config/get_connection_string.sh OPE`
#echo 'dbcon '${dbcon}

NAME=`echo $1`

SQL_FILE=/opeapp/sql/init/${NAME}.sql
LOG_FILE=/opeapp/logs/init_${NAME}.log

if [ ! -e $SQL_FILE ]
then
    /usr/bin/echo "${cnt}: $SQL_FILE 이 존재 하지 않습니다."
    continue
fi
echo  ${SQL_FILE} $2 $3

# SQL실행
sqlplus -s $dbcon > ${LOG_FILE} << EOF
SET SERVEROUTPUT ON
    @${SQL_FILE} $@
EOF

