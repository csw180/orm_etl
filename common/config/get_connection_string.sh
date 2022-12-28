#!/usr/bin/ksh

################################################################################
# 1.���α׷���     : get_connection_string.sh
# 2.Parameter      : ���� ���� ��
# 3.�����۾���     : N/A
# 4.���α׷�����   : ��û�ϴ� ���� ���� �� �ش�Ǵ� ��������(����/�н�����@�ν��Ͻ�)
# 5.�۾��ֱ�       : ����
# 6.��õSam&Table  :
# 7.���Sam&Table  :
# 8.����ҿ�ð�   :
# 9.���α׷��̷�   :
# *----------------------------------------------------------------------------*
#  NO DATE       �̸�   DESCRIPTION
# *----------------------------------------------------------------------------*
#  01 2019/10/23 ������ �ű��ۼ�
#
# *----------------------------------------------------------------------------*
# 10.���(���ǻ���) :
#
################################################################################
# ���� ����&�Լ� ���� Include
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
