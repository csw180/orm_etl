#! /bin/ksh
. ${OPEHOME}/.profile

/opeapp/opesql.exe /opeapp/sql/chg/ins_TB_OR_KH_NVL_본부부서 $1

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi
