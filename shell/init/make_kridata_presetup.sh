#! /bin/ksh
. ${OPEHOME}/.profile

dbcon=`/opeapp/common/config/get_connection_string.sh OPE`
#echo 'dbcon '${dbcon}
cnt=0

for file in `cat /opeapp/shell/init/kri_tables.txt`
do

NAME=`echo $file|cut -d"|" -f1`
TYPE=`echo $file|cut -d"|" -f2`

if [ "$TYPE" == "Query" ]
then

SQL_FILE=/opeapp/sql/init/ins_${NAME}.sql
LOG_FILE=/opeapp/logs/init_ins_${NAME}.log

cnt=$((cnt+1))
if [ ! -e $SQL_FILE ]
then
    /usr/bin/echo "${cnt}: $SQL_FILE �� ���� ���� �ʽ��ϴ�."
    continue
fi
echo ${cnt}': '${SQL_FILE}' '$@

# SQL����
sqlplus -s $dbcon > ${LOG_FILE} << EOF
SET SERVEROUTPUT ON
    @${SQL_FILE} $@
EOF

fi

done
