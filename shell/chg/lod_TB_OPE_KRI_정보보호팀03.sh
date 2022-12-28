#! /bin/ksh
. ${OPEHOME}/.profile

KRI_ID=정보보호팀03
TBL_NM=TB_OPE_KRI_${KRI_ID}
JOB_NM=lod_${TBL_NM}
CTL_FILE=/opeapp/ctl/${TBL_NM}.ctl
INSERT_JOB_NM=/opeapp/sql/chg/ins_${TBL_NM}
TEMP_TBL_NM=TEMP_`echo ${TBL_NM} | cut -d"_" -f2-`

# DB Connection Infomation
dbcon=`/opeapp/common/config/get_connection_string.sh OPE`
#===============================================================
#1. TEMP 테이블생성
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
# SQL 오류 확인 ,오류발생시 에러종료
ORA_ERR=`grep -c '^ORA-[0-9][0-9][0-9][0-9]' ${OPE_LOG_PATH}/${JOB_NM}_1.log`
if [ $RET != 0 -o $ORA_ERR != 0 ]
then
    echo "STEP1: TEMP Table(${TEMP_TBL_NM}) 생성시 오류가 발생하였습니다."
    cat ${OPE_LOG_PATH}/${JOB_NM}_1.log
    exit 1
fi
echo "STEP1: TEMP Table(${TEMP_TBL_NM}) 생성완료!!!"

#===============================================================
#2. TEMP 테이블 데이터로딩
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
    echo "▷▷ Sql*Loader 실행시 오류가 발생하였습니다."
    echo "▷▷ LOG파일[ ${OPE_LOG_PATH}/${JOB_NM}_2.log ]의 내용 참조"
    exit 1
fi

echo "STEP2: TEMP Table(${TEMP_TBL_NM}) 데이터로딩완료 !!!"

##if [ -e $DATA_DIR/$DATA_CHK ]
##then
##    mv $DATA_DIR/$DATA_CHK $CHK_BACKUP_DIR/$DATA_CHK
##fi

#===============================================================
#3. TEMP 테이블 -> TB 테이블로 Delete/Insert
#===============================================================
# 작업수행 전 기존 log파일 삭제
LOG_NM=`echo ${INSERT_JOB_NM} | rev | cut -d"/" -f1 |rev`
rm -f ${OPE_LOG_PATH}/${LOG_NM}.log
/opeapp/opesql.bat ${INSERT_JOB_NM}
# SQL 오류 확인 ,오류발생시 에러종료
RET=$?
ORA_ERR=`grep -c '^ORA-[0-9][0-9][0-9][0-9]' ${OPE_LOG_PATH}/${LOG_NM}.log`
if [ $RET != 0 -o $ORA_ERR != 0 ]
then
    echo "STEP3: TEMP Table(${TEMP_TBL_NM}) -> TB Table Delete/Insert 오류!!!"
    cat ${OPE_LOG_PATH}/${LOG_NM}.log
    exit 1
fi
echo "STEP3: TEMP Table(${TEMP_TBL_NM}) -> TB Table Delete/Insert 완료 !!!"
exit 0

