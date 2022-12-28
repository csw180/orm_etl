#! /bin/ksh

DATE=`date '+%Y%m%d'`

if [ $# -ne 2 ]
then
    echo "■----------------------------------------------------------"
    echo "■ 입력파라미터 확인 필요                                   " 
    echo "■ ex) 암호화시 : encdecpwd.sh ENC EDWCONTNGUQ*2019D        "
    echo "■ ex) 복호화시 : encdecpwd.sh DEC RURXQ09OVE5HVVEqMjAxOUQ= "
    echo "■----------------------------------------------------------"
    
    exit 0
fi

ENCGB=$1            # 암복호화 구분
PASSWD=$2           # 패스워드

echo "■------------------------------------------"
echo "■- 입력값 : ${ENCGB} - ${PASSWD}           "
echo "■------------------------------------------"

#RESULT=`java -cp /opeapp/common/lib/encryt/lib/commons-codec-1.6.jar:/opeapp/common/lib/encryt:. EncDecPasswd ${ENCGB} ${PASSWD}`
RESULT=`java -cp /opeapp/common/lib/encryt:. EncDecPasswd ${ENCGB} ${PASSWD}`
echo "■------------------------------------------"
echo "■- 결과 : ${RESULT}                        "
echo "■------------------------------------------"
