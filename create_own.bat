#! /bin/ksh
. ${OPEHOME}/.profile

SQL_FILE="$1"
LOG_NM=`echo $1 | rev | cut -d"/" -f1 |rev|cut -d"." -f1`

rm -f ${OPE_LOG_PATH}/${LOG_NM}.log

echo "��bat��====================================================" | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "��bat���۾������Ͻ�  : "`date "+%Y-%m-%d %H:%M:%S"` | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log

# DB Connection ���� ��������
dbcon=`/opeapp/common/config/get_connection_string.sh OPW`

# SQL����
sqlplus -s $dbcon > ${OPE_LOG_PATH}/${LOG_NM}.log << EOF
SET SERVEROUTPUT ON
    @${SQL_FILE}
EOF

echo "��bat���۾������Ͻ�  : "`date "+%Y-%m-%d %H:%M:%S"` | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "��bat��RESULT:[$?] =========================================" | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "��bat��LOG��ġ       : ${OPE_LOG_PATH}/${LOG_NM}.log "
