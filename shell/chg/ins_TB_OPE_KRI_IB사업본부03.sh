#! /bin/ksh
. ${OPEHOME}/.profile

/opeapp/opesql.exe /opeapp/sql/chg/ins_TB_OPE_KRI_IB�������03 $1

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi
