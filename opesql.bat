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

echo "▶bat▶====================================================" | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "▶bat▶작업시작일시  : "`date "+%Y-%m-%d %H:%M:%S"` | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log

# DB Connection 정보 가져오기
dbcon=`/opeapp/common/config/get_connection_string.sh OPE`

# SQL실행
sqlplus -s $dbcon >> ${OPE_LOG_PATH}/${LOG_NM}.log << EOF
SET SERVEROUTPUT ON
    @${SQL_FILE} ${PARAM1}
EOF

echo "▶bat▶작업종료일시  : "`date "+%Y-%m-%d %H:%M:%S"` | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "▶bat▶====================================================" | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "▶bat▶LOG위치       : ${OPE_LOG_PATH}/${LOG_NM}.log "
