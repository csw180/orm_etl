#! /bin/ksh

DATE=`date '+%Y%m%d'`

if [ $# -ne 2 ]
then
    echo "��----------------------------------------------------------"
    echo "�� �Է��Ķ���� Ȯ�� �ʿ�                                   " 
    echo "�� ex) ��ȣȭ�� : encdecpwd.sh ENC EDWCONTNGUQ*2019D        "
    echo "�� ex) ��ȣȭ�� : encdecpwd.sh DEC RURXQ09OVE5HVVEqMjAxOUQ= "
    echo "��----------------------------------------------------------"
    
    exit 0
fi

ENCGB=$1            # �Ϻ�ȣȭ ����
PASSWD=$2           # �н�����

echo "��------------------------------------------"
echo "��- �Է°� : ${ENCGB} - ${PASSWD}           "
echo "��------------------------------------------"

#RESULT=`java -cp /opeapp/common/lib/encryt/lib/commons-codec-1.6.jar:/opeapp/common/lib/encryt:. EncDecPasswd ${ENCGB} ${PASSWD}`
RESULT=`java -cp /opeapp/common/lib/encryt:. EncDecPasswd ${ENCGB} ${PASSWD}`
echo "��------------------------------------------"
echo "��- ��� : ${RESULT}                        "
echo "��------------------------------------------"
