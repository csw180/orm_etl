#!/usr/bin/ksh

################################################################################
# 1.프로그램명     : get_connection_string.sh
# 2.Parameter      : 접속 유저 명
# 3.선행작업명     : N/A
# 4.프로그램설명   : 요청하는 접속 유저 명에 해당되는 연결정보(계정/패스워드@인스턴스)
# 5.작업주기       : 수시
# 6.원천Sam&Table  :
# 7.대상Sam&Table  :
# 8.예상소요시간   :
# 9.프로그램이력   :
# *----------------------------------------------------------------------------*
#  NO DATE       이름   DESCRIPTION
# *----------------------------------------------------------------------------*
#  01 2019/10/23 최진성 신규작성
#
# *----------------------------------------------------------------------------*
# 10.비고(주의사항) :
#
################################################################################
# 공통 변수&함수 파일 Include
################################################################################

DWCFG_PATH="/opeapp/common/config"
DWLIB_PATH="/opeapp/common/lib"

ID=`echo "$1" | awk '{print substr($0,1,3)}'`

INS=`grep "${ID}_INSTANCE" ${DWCFG_PATH}/DWLOGON.cfg | awk '{split($0,a,"="); print a[2]}'`
USR=`grep "${ID}_USER_ID" ${DWCFG_PATH}/DWLOGON.cfg | awk '{split($0,a,"="); print a[2]}'`
PWD=`grep "${ID}_PASSWORD" ${DWCFG_PATH}/DWLOGON.cfg | awk '{split($0,a,"="); print a[2]}'`

DEC_PWD=`java -cp ${DWLIB_PATH}/encryt:. EncDecPasswd DEC ${PWD}`

#echo "DWZETT/DWZETTTNGUQ1010@DBPDWZ"
echo "${USR}/${DEC_PWD}@${INS}"
#echo "${USR}/${DEC_PWD}@138.240.38.34:1523/${INS}"
