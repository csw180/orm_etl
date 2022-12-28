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
    echo "���� Sql*Loader ����� ������ �߻��Ͽ����ϴ�."
    echo "���� LOG����[ ${LOG_FILE} ]�� ���� ����"
    exit 1
fi
