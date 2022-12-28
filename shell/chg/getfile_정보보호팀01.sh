#! /bin/ksh
. ${OPEHOME}/.profile

/sw/eai/batch_agent/bin/batch.sh -i PRIOPEBF0001 -f kri_priview.txt -t pri_01.dat

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi
