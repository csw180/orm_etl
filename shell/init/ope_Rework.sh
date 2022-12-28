#! /bin/ksh
. ${OPEHOME}/.profile

dbcon=`/opeapp/common/config/get_connection_string.sh OPE`
#echo 'dbcon '${dbcon}

NAME=`echo $1`

SQL_FILE=/opeapp/sql/init/${NAME}.sql
LOG_FILE=/opeapp/logs/init_${NAME}.log

if [ ! -e $SQL_FILE ]
then
    /usr/bin/echo "${cnt}: $SQL_FILE �� ���� ���� �ʽ��ϴ�."
    continue
fi
echo  ${SQL_FILE} $2 $3

# SQL����
sqlplus -s $dbcon > ${LOG_FILE} << EOF
SET SERVEROUTPUT ON
    @${SQL_FILE} $@
EOF

