#! /bin/ksh
. ${OPEHOME}/.profile

/opeapp/opesql.exe /opeapp/sql/chg/ins_BIA�򰡵����ͻ���

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi
