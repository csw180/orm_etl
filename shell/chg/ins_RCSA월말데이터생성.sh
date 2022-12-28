#! /bin/ksh
. ${OPEHOME}/.profile

/opeapp/opesql.exe /opeapp/sql/chg/ins_RCSA岿富单捞磐积己

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi
