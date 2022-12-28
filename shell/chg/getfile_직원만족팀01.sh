#! /bin/ksh
. ${OPEHOME}/.profile

/sw/eai/batch_agent/bin/batch.sh -i GWSOPEBF0001 -f gws_approvallist.dat -t gws_approvallist.dat

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi
