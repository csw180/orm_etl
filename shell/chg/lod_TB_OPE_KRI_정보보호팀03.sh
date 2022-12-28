#! /bin/ksh
. ${OPEHOME}/.profile

KRI_ID=������ȣ��03
TBL_NM=TB_OPE_KRI_${KRI_ID}
JOB_NM=lod_${TBL_NM}
CTL_FILE=/opeapp/ctl/${TBL_NM}.ctl
INSERT_JOB_NM=/opeapp/sql/chg/ins_${TBL_NM}
TEMP_TBL_NM=TEMP_`echo ${TBL_NM} | cut -d"_" -f2-`

# DB Connection Infomation
dbcon=`/opeapp/common/config/get_connection_string.sh OPE`
#===============================================================
#1. TEMP ���̺����
#===============================================================
rm -f ${OPE_LOG_PATH}/${JOB_NM}_1.log
sqlplus -s $dbcon > ${OPE_LOG_PATH}/${JOB_NM}_1.log << EOF
SET SERVEROUTPUT ON
EXEC SP_DROP_TABLE('${TEMP_TBL_NM}');
CREATE TABLE ${TEMP_TBL_NM} AS
SELECT * FROM  OPEOWN.${TBL_NM}
WHERE 1=2
;
quit
EOF
RET=$?
# SQL ���� Ȯ�� ,�����߻��� ��������
ORA_ERR=`grep -c '^ORA-[0-9][0-9][0-9][0-9]' ${OPE_LOG_PATH}/${JOB_NM}_1.log`
if [ $RET != 0 -o $ORA_ERR != 0 ]
then
    echo "STEP1: TEMP Table(${TEMP_TBL_NM}) ������ ������ �߻��Ͽ����ϴ�."
    cat ${OPE_LOG_PATH}/${JOB_NM}_1.log
    exit 1
fi
echo "STEP1: TEMP Table(${TEMP_TBL_NM}) �����Ϸ�!!!"

#===============================================================
#2. TEMP ���̺� �����ͷε�
#===============================================================
## DAT File
DATA_DIR=/opeapp/opeftp/rcv
CHK_BACKUP_DIR=/nasdat/ope/chk
#DATA_FILE=${KRI_ID}.dat
#DATA_CHK=`echo ${DATA_FILE} | cut -d"." -f1`".chk"
DATA_FILE=isc_03.dat
DATA_CHK=isc_03.chk

rm -f ${OPE_LOG_PATH}/${JOB_NM}_2.log
sqlldr $dbcon,control=${CTL_FILE},data=${DATA_DIR}/${DATA_FILE},silent=header,feedback,errors=0,log=${OPE_LOG_PATH}/${JOB_NM}_2.log,bad=${OPE_LOG_PATH}/${JOB_NM}.bad

if [ $? -ne 0 ]; then
    echo "���� Sql*Loader ����� ������ �߻��Ͽ����ϴ�."
    echo "���� LOG����[ ${OPE_LOG_PATH}/${JOB_NM}_2.log ]�� ���� ����"
    exit 1
fi

echo "STEP2: TEMP Table(${TEMP_TBL_NM}) �����ͷε��Ϸ� !!!"

##if [ -e $DATA_DIR/$DATA_CHK ]
##then
##    mv $DATA_DIR/$DATA_CHK $CHK_BACKUP_DIR/$DATA_CHK
##fi

#===============================================================
#3. TEMP ���̺� -> TB ���̺�� Delete/Insert
#===============================================================
# �۾����� �� ���� log���� ����
LOG_NM=`echo ${INSERT_JOB_NM} | rev | cut -d"/" -f1 |rev`
rm -f ${OPE_LOG_PATH}/${LOG_NM}.log
/opeapp/opesql.bat ${INSERT_JOB_NM}
# SQL ���� Ȯ�� ,�����߻��� ��������
RET=$?
ORA_ERR=`grep -c '^ORA-[0-9][0-9][0-9][0-9]' ${OPE_LOG_PATH}/${LOG_NM}.log`
if [ $RET != 0 -o $ORA_ERR != 0 ]
then
    echo "STEP3: TEMP Table(${TEMP_TBL_NM}) -> TB Table Delete/Insert ����!!!"
    cat ${OPE_LOG_PATH}/${LOG_NM}.log
    exit 1
fi
echo "STEP3: TEMP Table(${TEMP_TBL_NM}) -> TB Table Delete/Insert �Ϸ� !!!"
exit 0

