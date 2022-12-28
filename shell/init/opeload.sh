#! /bin/ksh
. ${OPEHOME}/.profile

TBL_NM=$1
CTL_FILE=/opeapp/ctl/${TBL_NM}.ctl
DATA_FILE=/nasdat/ope/init/${TBL_NM}.dat
LOG_FILE=/opeapp/logs/${TBL_NM}.log
BAD_FILE=/opeapp/logs/${TBL_NM}.bad

# DB Connection Infomation
dbcon=`/opeapp/common/config/get_connection_string.sh OPE`

sqlldr $dbcon,control=${CTL_FILE},data=${DATA_FILE},silent=header,feedback,errors=0,log=${LOG_FILE},bad=${BAD_FILE}

if [ $? -ne 0 ]; then
    echo "▷▷ Sql*Loader 실행시 오류가 발생하였습니다."
    echo "▷▷ LOG파일[ ${LOG_FILE} ]의 내용 참조"
    exit 1
fi
