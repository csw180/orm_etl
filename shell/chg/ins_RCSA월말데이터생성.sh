#! /bin/ksh
. ${OPEHOME}/.profile

/opeapp/opesql.exe /opeapp/sql/chg/ins_RCSA월말데이터생성

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi
