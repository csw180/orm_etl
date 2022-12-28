#! /bin/ksh
. ${OPEHOME}/.profile

SQL_FILE="$1"
LOG_NM=`echo $1 | rev | cut -d"/" -f1 |rev|cut -d"." -f1`

rm -f ${OPE_LOG_PATH}/${LOG_NM}.log

echo "▶bat▶====================================================" | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "▶bat▶작업시작일시  : "`date "+%Y-%m-%d %H:%M:%S"` | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log

dbcon=`/opeapp/common/config/get_connection_string.sh OPE`

# SQL실행
sqlplus -s $dbcon > ${OPE_LOG_PATH}/${LOG_NM}.log << EOF
SET SERVEROUTPUT ON
    @${SQL_FILE}
EOF

echo "▶bat▶작업종료일시  : "`date "+%Y-%m-%d %H:%M:%S"` | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "▶bat▶RESULT:[$?] =========================================" | tee -a ${OPE_LOG_PATH}/${LOG_NM}.log
echo "▶bat▶LOG위치       : ${OPE_LOG_PATH}/${LOG_NM}.log "
