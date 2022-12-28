#! /bin/ksh
. ${OPEHOME}/.profile

/opeapp/opesql.exe /opeapp/sql/chg/ins_TB_OR_OM_EMP_ภฮป็

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi
