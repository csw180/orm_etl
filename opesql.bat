#! /bin/ksh
. /opeapp/.profile

SQL_FILE="$1.sql"
LOG_NM=`echo $1 | rev | cut -d"/" -f1 |rev`
PARAM1="$2"
if  [ ${#PARAM1} != 0 ]
then
        LOG_NM="${LOG_NM}_${PARAM1}"
fi

#echo "bat:SQL_FILE=$SQL_FILE"
#echo "bat:LOG_NM=$LOG_NM"
#echo "bat:PARAM1=[${PARAM1}]"

echo "��bat��====================================================" | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "��bat���۾������Ͻ�  : "`date "+%Y-%m-%d %H:%M:%S"` | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log

# DB Connection ���� ��������
dbcon=`/opeapp/common/config/get_connection_string.sh OPE`

# SQL����
sqlplus -s $dbcon >> ${OPE_LOG_PATH}/${LOG_NM}.log << EOF
SET SERVEROUTPUT ON
    @${SQL_FILE} ${PARAM1}
EOF

echo "��bat���۾������Ͻ�  : "`date "+%Y-%m-%d %H:%M:%S"` | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "��bat��====================================================" | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "��bat��LOG��ġ       : ${OPE_LOG_PATH}/${LOG_NM}.log "
