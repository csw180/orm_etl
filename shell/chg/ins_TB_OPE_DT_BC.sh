#! /bin/ksh
. ${OPEHOME}/.profile

/opeapp/opesql.exe /opeapp/sql/chg/ins_TB_OPE_DT_BC

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi
