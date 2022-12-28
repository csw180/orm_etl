-- #DWA_공통코드기본 #공통코드 
select CMN_CD,CMN_CD_NM
from  OM_DWA_CMN_CD_BC  -- DWA_공통코드기본
where TPCD_NO_EN_NM = 'LNRV_STS_DSCD'    -- 고객정보변경구분코드
and   CMN_CD_US_YN = 'Y'  -- 공통코드사용여부
order by 1 ASC
;

      CUST_NO	고객번호
     ,CUST_INF_CHG_SNO	고객정보변경일련번호
-- #SOR_CUS_고객변경내역 #고객정보
select
     ,CUST_INF_CHG_DSCD	고객정보변경구분코드
     ,CHB_DAT_CTS	변경전데이터내용
     ,CHA_DAT_CTS	변경후데이터내용
     ,ENR_DTTM  등록일시
from  TB_SOR_CUS_CHG_TR   a  -- SOR_CUS_고객변경내역
where CUST_INF_CHG_DSCD='0037'
order by 6 desc;


##  ADD_MONTHS

몇달전후 날짜를 구하는데
입력한날짜가 해당달의 마지막일자인 경우는 
저절로 구해지는 날짜도 마지막날짜가 구해져 나온다..

SELECT ADD_MONTHS(TO_DATE('20220430', 'YYYYMMDD'), 1) FROM DUAL;
 20220530 일이 한달후의 날짜이지만 20220430 가 4월의 마지막날이므로
 결과는 20220531 로 5월의 마지막날이 리턴되어 나온다.

SELECT ADD_MONTHS(TO_DATE('20220330', 'YYYYMMDD'), -1) FROM DUAL;
 20220330 일의 한달전 날짜는 산술적으로 계산하면 20220230 이겠지만
 20220330 일이 3월의 마지막날이므로 20220228 일이 리턴되어 나온다.


## MONTHS_BETWEEN
앞에날짜에서 뒤에날짜를 빼는 형식
첫번째 파라메타가 앞선날짜이면 마이너스가 나온다.
SELECT MONTHS_BETWEEN(TO_DATE('20220228','YYYYMMDD'),TO_DATE('20220101','YYYYMMDD')) FROM DUAL;
1.87096774193548387096774193548387096774
 
 
 

-- 테스트값
  P_SOTM_DT  := '20210430';
  P_EOTM_DT  := '20220430';
  P_BASEDAY  := '20220430'; 
  

## DTROWN.UP_TRM_TRUNCATE_TB

CREATE OR REPLACE PROCEDURE DTROWN.UP_TRM_TRUNCATE_TB ( PV_TABLE_NAME IN VARCHAR2 )
IS
    GV_SQL_TXT    VARCHAR2(1000) ;
    GV_ERROR_CD   NUMBER(10) ;
    GV_ERROR_CONT VARCHAR2(1000) ;
BEGIN
    GV_ERROR_CD       := 0 ;
    GV_ERROR_CONT     := '' ;
    GV_SQL_TXT        := NULL ;
    DBMS_OUTPUT.ENABLE;

    BEGIN
        SELECT 'TRUNCATE TABLE '|| TABLE_NAME AS  SQL_TXT
          INTO GV_SQL_TXT
          FROM ALL_TABLES
         WHERE OWNER      = 'DTROWN'
           AND TABLE_NAME = PV_TABLE_NAME
        ;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
        GV_ERROR_CD    := 0 ;
    WHEN OTHERS THEN
        GV_ERROR_CD    := SQLCODE ;
        GV_ERROR_CONT  := SQLERRM ;
        DBMS_OUTPUT.PUT_LINE( 'TRUNC_TABLE     - UP_TRM_TRUNCATE_TB ERROR : ' || GV_ERROR_CONT ) ;
        RETURN ;
    END;

    IF TRIM(GV_SQL_TXT) IS NOT NULL  THEN
        DBMS_OUTPUT.PUT_LINE( 'TRUNC_TABLE     - UP_TRM_TRUNCATE_TB : ' || GV_SQL_TXT ) ;
        EXECUTE IMMEDIATE GV_SQL_TXT ;
    END IF;

END ;

GRANT EXECUTE ON DTROWN.UP_TRM_TRUNCATE_TB TO DTRDEV;
GRANT EXECUTE ON DTROWN.UP_TRM_TRUNCATE_TB TO DTRETT;



#! /bin/ksh
. ${OPEHOME}/.profile

/opeapp/opesql.exe /opeapp/sql/chg/tosam_EOTM_DT
RET=$?
ORA_ERR=`grep -c '^ORA-[0-9][0-9][0-9][0-9]' /opeapp/logs/tosam_EOTM_DT.log`
if [ $RET != 0 -o $ORA_ERR != 0 ]
then
    echo "!! STD_DT.dat 생성시 오류가 발생하였습니다."
    cat /opeapp/logs/tosam_EOTM_DT.log
    exit 1
fi

STD_DT=`cat /opeapp/STD_DT.dat`
#STD_DT=20220831
echo ${STD_DT}

/sw/eai/batch_agent/bin/batch.sh -i ABMOPEBD0001 -t abm_02.dat -s "STD_DATE=${STD_DT}"

if [ $? -eq 0 ]
then
        exit 0
else
        exit 1
fi

## EAI 파라메타 이용하기

2020.09.22 : batch.sh -i PPSCBIBD3004 -s "STD_DATE=조건값1 & LOG_SNO=조건값2"

/* 전표발생내역 조회 통합업무로그요약테이블 */
SELECT 
 V.SYS_DT             AS  SYS_DT
,V.RL_TR_HM_SEC       AS  RL_TR_HM_SEC     --실거래시간 
,V.RL_TR_DT           AS  RL_TR_DT          --실거래일자   
,V.GBL_ID_NO          AS  GBL_ID_NO 
,V.FW_LOG_LKG_NO	  AS  FW_LOG_LKG_NO																					   																					 -- 프레임워크로그연동번호
,V.FW_LOG_NO	      AS  FW_LOG_NO
,V.INTG_LOG_TR_SNO	  AS  INTG_LOG_TR_SNO
,V.LST_AMN_TS         AS  LST_AMN_TS--최종타임스탬프
,V.INTG_ACNO          AS  INTG_ACNO
,V.TLR_NO             AS  TLR_NO
,V.HDL_BRNO           AS HDL_BRNO
,V.INP_SCRN_ID        AS INP_SCRN_ID
,V.USR_NM             AS USR_NM
,V.SLP_NO             AS SLP_NO
,V.TLG_RQS_DTTM       AS TLG_RQS_DTTM
,V.LOG_SNO            AS LOG_SNO
,V.CRC_CNCL_DSCD  AS CRC_CNCL_DSCD  --정정취소구분코드
,V.FSC_DT 	 	      AS FSC_DT	    --회계일자

  FROM (SELECT /*+ FULL(A) PARALLEL(2) */
              A.SYS_DT 	
             ,A.RL_TR_HM_SEC                --실거래시간 
		     ,A.RL_TR_DT                    --실거래일자   
		     ,A.GBL_ID_NO
			 ,A.FW_LOG_LKG_NO																						   																					 -- 프레임워크로그연동번호
	         ,A.FW_LOG_NO	
			 ,A.INTG_LOG_TR_SNO		
			 ,  to_char( A.LST_AMN_TS,'YYYYMMDDHH24MISS' )  AS LST_AMN_TS   --최종타임스탬프
			 , CASE WHEN A.INP_INTG_ACNO IS NULL THEN A.INTG_ACNO       
                    ELSE A.INP_INTG_ACNO       
			        END	AS  INTG_ACNO                       -- 계좌번호  
--		     , CASE WHEN (A.TLR_NO IS NULL) OR (A.TLR_NO = '0') THEN A.USR_NO       
--	                ELSE  A.TLR_NO END AS TLR_NO             -- 텔러번호 
--2020.12.21 텔러번호 대신 사용자번호로 변경
                 ,A.USR_NO  AS TLR_NO                 
			 ,A.HDL_BRNO                                     --취급점번호		
			 , CASE WHEN A.CHNL_TPCD = 'STML'  
			                             THEN  
			                             CASE WHEN A.FST_FRWD_SYS_CD = 'INS'  THEN SUBSTR(A.INP_SCRN_ID,1,4)  
				                              ELSE A.FST_FRWD_SYS_CD  
			                             END       
			        ELSE SUBSTR(A.INP_SCRN_ID,1,4)  
		            END AS  INP_SCRN_ID                                     -- 입력화면 ID   	
	        , CASE  WHEN (A.USR_NM IS NULL) OR (A.USR_NM = '0') THEN ' '       
		            ELSE  A.USR_NM      
		            END AS USR_NM                                           -- 취급자명(사용자명)
		    ,LPAD(A.SLP_NO,5,'0') AS SLP_NO 		    -- 전표번호
-- 2021.01.27 전표명세 단체여부 인자를 위해 여신일괄거래화면만 다건계산서식별번호를 RCV_SVC_CD에 적재
   	        ,CASE WHEN SUBSTR(INP_SCRN_ID,1,4) IN ('1033','1034','1018') THEN RCV_SVC_CD
			      ELSE to_char( A.TLG_RQS_DTTM ,  'YYYYMMDDHH24MISS' ) END AS TLG_RQS_DTTM   --전문요청일시
            ,A.LOG_SNO   --로그일련번호
           , A.CRC_CNCL_DSCD  -- 정정취소구분코드
		   , A.FSC_DT 	 --회계일자
                  
         FROM TB_CMP_TSK_LOG_SMR_TR A
         WHERE A.ONL_DT = #STD_DATE#
         AND A.PCS_DD = SUBSTR(#STD_DATE#,7,2)          -- 필요  
       --  AND A.LOG_SNO > 0                              -- 필요 (LAST KEY)
          AND A.LOG_SNO >  #LOG_SNO#            -- 필요 (LAST KEY)
         AND A.SLP_NO  BETWEEN 1  AND 99999             -- 필요 
         AND ((A.CHNL_TPCD = 'TTML') OR (A.CHNL_TPCD = 'STML'))  --필요 
     	--	 AND A.TR_BR_DSCD = '1'  -- 1:은행 2:조합  (공제에서 NULL로 넣어줘서 쿼리 수정함) 2020.09.25
             AND ( A.TR_BR_DSCD IS NULL  OR  A.TR_BR_DSCD =  '1' )  -- 1:은행 2:조합 
         ORDER BY LOG_SNO 
)V
 WHERE ROWNUM < 10000 --한번에 만건을 넘지 않는다.  


## GEN_CREATE_SCRIPT.SQL

DECLARE
	TABLE_SCRIPT CLOB;

BEGIN
	SELECT  REPLACE(REPLACE(XMLAGG(XMLELEMENT(E,CREATE_SCRIPTS,' '||CHR(10)).EXTRACT('//text()') ORDER BY COLUMN_ID).GETCLOBVAL(),'',''),'','')
	INTO   TABLE_SCRIPT
	  FROM  (
	        SELECT  CASE WHEN COLUMN_ID = 1 THEN
	                'CREATE TABLE '||OWNER||'.'||TABLE_NAME
	                ||CHR(10)||'('
	                ||CHR(10)||'  ' ELSE ', ' END
	                ||COLUMN_NAME||RPAD(' ',ABS(30-LENGTHB(COLUMN_NAME)) )||' '
	                ||CASE  WHEN DATA_TYPE IN ('NUMBER') AND DATA_PRECISION IS NULL THEN DATA_TYPE
	                        WHEN DATA_TYPE IN ('NUMBER') THEN DATA_TYPE||'('||DATA_PRECISION||','||DATA_SCALE||')'
	                        WHEN DATA_TYPE IN ('CHAR','VARCHAR2') THEN DATA_TYPE||'('||DATA_LENGTH||')'
	                        WHEN DATA_TYPE IN ('CLOB')   THEN 'CLOB'
	                        ELSE DATA_TYPE
	                  END
	                ||CASE  WHEN COLUMN_ID = (MAX(COLUMN_ID) OVER(PARTITION BY OWNER,TABLE_NAME ORDER BY OWNER,TABLE_NAME)) THEN CHR(10)||') NOLOGGING;'
	                        ELSE NULL END   CREATE_SCRIPTS,COLUMN_ID
	          FROM  DBA_TAB_COLUMNS
	         WHERE  OWNER       = 'OPEOWN'
	           AND  TABLE_NAME  = 'TB_OPE_KRI_정보보호팀03'
	         ORDER  BY COLUMN_ID
	        );            
    DBMS_OUTPUT.PUT_LINE(TABLE_SCRIPT);	        
END             

## insert_log

PROCEDURE INSERT_LOG (
     P_OWNER            IN VARCHAR2
    ,P_TABLE_NAME       IN VARCHAR2
    ,P_WORK_DAY         IN VARCHAR2     
    ,P_JOB_NAME         IN VARCHAR2
    ,P_SEQ              IN NUMBER
    ,P_STEP_NAME        IN VARCHAR2
    ,P_JOB_START_TIME   IN TIMESTAMP
    ,P_STEP_START_TIME  IN TIMESTAMP
)
AS
    /* 프로시져를 실행하는 사용자 정보 추출 */
    V_STATUS            CHAR(1)     := 'R';
    V_CLIENT_INFO       VARCHAR2(64) := SYS_CONTEXT('userenv','CLIENT_INFO');
    V_MODULE            VARCHAR2(48) := SYS_CONTEXT('userenv','MODULE');
    V_HOST              VARCHAR2(50) := SYS_CONTEXT('userenv','HOST') ;
    V_IP_ADDRESS        VARCHAR2(30) := SYS_CONTEXT('userenv','IP_ADDRESS');
    V_OSUSER            VARCHAR2(30) := SYS_CONTEXT('userenv','OS_USER');
    V_USER              VARCHAR2(30) := SYS_CONTEXT('userenv','SESSION_USER');
    
BEGIN
    INSERT INTO TB_PRG_LOG
    (OWNER,TABLE_NAME,WORK_DAY,JOB_NAME,SEQ,STEP_NAME,JOB_START_TIME,STEP_START_TIME,STATUS    -- 인자로 받음
    ,CLIENT_INFO,MODULE,HOST,IP_ADDRESS,OSUSER,USERNAME)    -- 자동 할당
    VALUES
    (P_OWNER,P_TABLE_NAME,P_WORK_DAY,P_JOB_NAME,P_SEQ,P_STEP_NAME,P_JOB_START_TIME,P_STEP_START_TIME,V_STATUS -- 인자로 받음
    ,V_CLIENT_INFO,V_MODULE,V_HOST,V_IP_ADDRESS,V_OSUSER,V_USER);   -- 자동 할당
    COMMIT; 
    
END INSERT_LOG;


## tosam_BEOM_DT

set serveroutput on
set markup csv ON delimi | quote off
set feedback off
set heading off
SET FEEDBACK OFF
SET TERMOUT OFF
spool /opeapp/BEOM_DT.dat
--          select TO_CHAR(TO_DATE(EOTM_DT,'YYYYMMDD'),'YYYY-MM-DD')
          select BEOM_DT
          from   OPEOWN.TB_OPE_DT_BC
          where  STD_DT_YN = 'Y'
;
spool off

exit


## 메모

tar -cvpf opeapp_p.tar -L inputlist
/opeapp/cres/create_TB_OPE_KRI_수신제도지원팀23.sql
/opeapp/sql/init/ins_TB_OPE_KRI_수신제도지원팀23.sql
/opeapp/sql/chg/ins_TB_OPE_KRI_수신제도지원팀23.sql

/opeapp/cres/create_TB_OPE_KRI_자금세탁방지팀06.sql
/opeapp/sql/init/ins_TB_OPE_KRI_자금세탁방지팀06.sql
/opeapp/sql/chg/ins_TB_OPE_KRI_자금세탁방지팀06.sql

/opeapp/cres/create_TB_OPE_KRI_직원만족팀01.sql
/opeapp/shell/chg/getfile_직원만족팀01.sh
/opeapp/ctl/TB_OPE_KRI_직원만족팀01.ctl
/opeapp/sql/chg/ins_TB_OPE_KRI_직원만족팀01.sql
/opeapp/shell/chg/lod_TB_OPE_KRI_직원만족팀01.sh

/opeapp/sql/chg/ins_TB_OPE_KRI_카드기획팀02.sql
/opeapp/sql/init/ins_TB_OPE_KRI_카드기획팀02.sql

계정및 비번
------------------------
Windows비번 : a!from1205 -> !rfrom1205
Tgate : a!from1205 -> !rfrom1205
DBsafer비번 :   a!from1205 -> !rfrom1205

웹운영리스크
--------------------
/weblogic/bi/opeDomain01/config/config.xml  
  -- 소스의경로 및 jdbc설정xml
  -- 소스의 경로(/weblogic/bi/apps/ope)
  -- JDBC설정xml (/weblogic/bi/opeDomain01/config/jdbc/)

http://localhost:8180/orms/login.jsp
OPE_012/OPE_012

통합리스크
/ohs/bi/trmDomain01/config/fmwconfig/components/OHS/instances/trmOhs01/httpd.conf   <== 이 파일에 40060 적혀있음

운영리스크 포트(개발)
/ohs/bi/opeDomain01/config/fmwconfig/components/OHS/instances/opeOhs01/httpd.conf   <== 7060 이라고 적혀있음

IP주소세팅
-------------------
IP:192.168.187.187
G/W : 192.168.187.1
DNS : 138.240.112.121, 122



EKP 메신져 ID
-------------------------
bj31229902/!1q2w3e4r
bj31229901/!1q2w3e4r

파일서버접속
  ----------------------
\\192.168.187.151\          OPE_012/1Q2w3e4r!@

Tgate설치페이지 및 보안프로그램 설치
--------------------------
http://138.240.112.50/agent/index.html
0021220098/a!from1205
관련된 보안필수 프로그램 설치
백신, DRM, Privacy-i 등등
DRM : 0021220098/a!from1205

SSO test 접속 (방화벽Open필요)
-------------------------------------
http://shssotest.suhyup.co.kr:7060/

위성용 jobmind
-------------------------------
개발  OPE_012/j.ope_012!@
http://jobmindtd.suhyup.co.kr:8185/jobmind/frame/login/getLoginForm.do
운영
http://jobmind.suhyup.co.kr:8185/jobmind/frame/login/getLoginForm.do

계정관리시스템 계정생성 및 신청
-----------------------------------------
1) 계정생성
http://tim.suhyup.co.kr:8080
회원가입절차진행 - 5분이상 지나야 -
아이디/비번 넣고 로그인가능(더 기다려야 할 수도)
p9000597/a!from1205

2) DB계정/권한신청
DB계정/권한신청>DB safer사용신청>기타DB접속신청
>시스템선택> edwdbd02_rip,edwdbd03_rip,edwdbd02_vip,
edwdbd03_vip,edwdbd_scan1,2,3
> 1차결재자 윤석헌, 2차결재자 박상환
> 사용기간세팅
DBsafer 설치후 ID는 계정관리시스템ID 사용, 초기비번 1111 
비번변경후 사용할 것

DB 계정 :     
-------------------
opeown/opeown!2209 :  테이블등 각종 Object 생성( Owner계정)opeett/opeown!2209   : 배치작업용
opeprc/opeown!2209  : 프로시져생성 (Owner계정)
opedev/opeown!2209 : 개발용(개발기간만 사용하고 사라짐)

Unix에서 sqlplus 사용
--------------------------
sqlplus opeett/opeett!2209@138.240.38.34:1523/DBDOPE
sqlplus opeett/opeett!2209@DBDOPE
sqlplus opeown/opeown!2209@138.240.38.33:1523/DBDOPE

Unix 계정
-------------------------------
배치서버 opeett/opeett!2205 : 배치작업용 Unix 계정
웹서버 : opeadm/opeadm!2205 : 관리자용계정 이면서 업무용계정

------------------------------TODO----------------------------
erd - 메타  - 테이블creation - grant_all
프로그램이관
운영배치서버 환경정비(.profile, 디렉토리편성, DB접속등)
dw작업선행작업으로 세팅 - 스케줄러이관
 
 
## 오라클권한관련


-- 시장리스크 ope 관련한 ROLE 이 어떤것들이 있는지 확인한다.
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE LIKE  '%OPE%';

SYSTEM RL_OPE_ALL YES NO  YES NO  NO
SYSTEM RL_OPE_SEL YES NO  YES NO  NO
SYSTEM RL_OPE_EXE YES NO  YES NO  NO
OPEPRC RL_OPE_ALL NO  NO  YES NO  NO
OPEPRC RL_OPE_EXE
OPEDEV RL_OPE_ALL NO  NO  YES NO  NO
OPEETT RL_OPE_ALL NO  NO  YES NO  NO
OPEETT RL_OPE_EXE NO  NO  YES NO  NO
## RL_OPE_ALL,RL_OPE_SEL,RL_OPE_EXE 등이 운영리스크관련된 롤로 보인다.

-- 사용계정에 부여된 롤이 어떤것이 있는지 확인한다.
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'OPEETT';

OPEETT RL_EDW_SEL NO  NO  YES NO  NO
OPEETT CONNECT NO  NO  YES NO  NO
OPEETT RL_OPE_ALL NO  NO  YES NO  NO
OPEETT RL_OPE_EXE
## OPEETT 계정에는 RL_EDW_SEL,RL_OPE_ALL,RL_OPE_EXE 이렇게 3가지 롤이 부여되어 있다.


-- 특정ROLE에 의해 접속한 사용자에게 부여된 테이블에 대한 권한을 보여준다.
SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = 'RL_OPE_ALL'
SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = 'RL_OPE_SEL'
## 처음에는 아무것도 출력되지 않는다.
## 테이블을 생성하고 아래와 같이 테이블에 대한 권한들을 롤에 부여하고
GRANT SELECT ON TB_FG_OR_MK_RI012 TO RL_OPE_ALL;
GRANT DELETE ON TB_FG_OR_MK_RI012 TO RL_OPE_ALL;
GRANT UPDATE ON TB_FG_OR_MK_RI012 TO RL_OPE_ALL;
GRANT INSERT ON TB_FG_OR_MK_RI012 TO RL_OPE_ALL;

GRANT SELECT ON TB_FG_OR_MK_RI012 TO RL_OPE_SEL;

## 다시 RL_OPE_ALL,RL_OPE_SEL 등의 롤이 부여된 계정(OPEETT) 로 접속하여  ROLE_TAB_PRIVS 를 조회하면 부여된 권한들이 보인다.

# 접속계정확인
select SYS_CONTEXT ('USERENV', 'SESSION_USER') from dual

# 롤에 부여된 프로시져의 실행권한도 동일하게 ROLE_TAB_PRIVS 를 통하여 확인할수 있다.
SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = 'RL_OPE_EXE'

# 계정이 lock 걸렸는지 확인  ACCOUNT_STATUS
select * from dba_users
where username = 'OPEOWN';

# RL_EDW_SEL 롤에 부여된 롤들.
select * from role_role_privs;
role       GRANTED_ROLE
RL_EDW_SEL	RL_DWR_SEL
RL_EDW_SEL	RL_INS_SEL
RL_EDW_SEL	RL_AXI_SEL
RL_EDW_SEL	RL_DIM_SEL
RL_EDW_SEL	RL_CBL_SEL
RL_EDW_SEL	RL_DSM_SEL
RL_EDW_SEL	RL_KPI_SEL
RL_EDW_SEL	RL_DTR_SEL
RL_EDW_SEL	RL_MKR_SEL
RL_EDW_SEL	RL_DWC_SEL
RL_EDW_SEL	RL_CFM_SEL
RL_EDW_SEL	RL_DAM_SEL
RL_EDW_SEL	RL_DRV_SEL
RL_EDW_SEL	RL_DWM_SEL
RL_EDW_SEL	RL_DWZ_SEL
RL_EDW_SEL	RL_CBC_SEL


CREATE OR REPLACE PUBLIC SYNONYM TB_FG_OR_MK_RI012 FOR OPEOWN.TB_FG_OR_MK_RI012;
GRANT SELECT ON TB_FG_OR_MK_RI012 TO RL_EDW_ALL;  -- PUBLIC SYNONYM 은 GRANT 안줘도 되지 않을까 

DROP PUBLIC SYNONYM TB_FG_OR_MK_RI012;


select * from dba_sys_privs
where grantee = 'MKROWN';
/*
MKROWN	CREATE TABLE
MKROWN	CREATE DATABASE LINK
MKROWN	CREATE VIEW
MKROWN	CREATE PUBLIC SYNONYM  <== 요권한이 있어야 PUBLIC SYNONYM 를 만들수 있다.
MKROWN	SELECT ANY DICTIONARY
MKROWN	CREATE PROCEDURE
MKROWN	CREATE SESSION
*/

select * from dba_sys_privs
where grantee = 'OPEOWN';
/*
OPEOWN	CREATE TABLE
OPEOWN	CREATE PROCEDURE
OPEOWN	CREATE SESSION
*/

## 조직

/*
여신관리부          16104000
수산해양금융부        16112000
  사회공헌팀        H0003532
심사부            K0002000
자금부            K0006000
  자금세탁방지팀      K0056000
IT지원부          K0077000
IB사업본부         K0079000
전략기획부          K0105000
인사총무부          K0107000
  준법감시팀        K0116000
  정보보호팀        K0118000
  보안운영팀        K0119000
  리스크관리팀       K0120000
  신용리스크 내부등급법 승인 TF팀  O0000050 *
지속경영추진부        K0126000
디지털개인금융부       K0127000
디지털전략부         K0129000
카드사업부          K0130000
기업금융부          K0131000
글로벌외환사업부       K0132000
여신정책부          K0134000
디지털개발부         K0135000
  신용평가팀        K0136000
IT개발부          K0137000
  재산신탁팀        K0138000
  금전신탁팀        K0139000
감사부            K0140000
  론리뷰팀         K0149000
  신용리스크팀       K0150000
  신탁영업추진팀      K0155000
방카펀드사업부        K0157000
  소비자보호팀       O0000001
  소비자지원팀       O0000055  *
*/



WITH MO AS
(
    SELECT    A.USR_NO
             ,A.USR_NM
             ,CASE WHEN A.DPT_CD IN  ('H0003532','K0056000','K0116000','K0118000','K0119000','K0120000','K0136000'
                                     ,'K0138000','K0139000','K0149000','K0150000','K0155000','O0000001') THEN
                CASE WHEN A.USR_PSTN_CD = '00054002' THEN NULL        -- 팀장
                     ELSE A.DPT_CD
                END
              ELSE
                CASE WHEN A.USR_PSTN_CD IN ('00053001','00059800')  THEN NULL  -- 부장, 부서장
                     WHEN A.USR_PSTN_CD = '00054002' THEN A.DPT_CD        -- 팀장
                     ELSE A.TEAM_CD
                END
              END      AS  PA_소속코드   -- Parent_소속코드
             ,CASE WHEN A.DPT_CD IN  ('H0003532','K0056000','K0116000','K0118000','K0119000','K0120000','K0136000'
                                     ,'K0138000','K0139000','K0149000','K0150000','K0155000','O0000001') THEN
                CASE WHEN A.USR_PSTN_CD = '00054002'  THEN A.DPT_CD
                     ELSE NULL
                END
              ELSE
                CASE WHEN A.USR_PSTN_CD IN ('00053001','00059800')  THEN A.DPT_CD  -- 부장, 부서장
                     WHEN A.USR_PSTN_CD = '00054002' THEN A.TEAM_CD
                     ELSE NULL
                END
              END  AS  담당소속코드
             ,A.TEAM_CD
             ,A.DPT_CD
             ,A.USR_PSCL_CD
             ,A.USR_PSTN_CD

    FROM     TB_SOR_CMI_USR_BC   A
    JOIN     OT_DWA_DD_BR_BC   J      -- DWA_일점기본
             ON   A.DPTC_BRNO  = J.BRNO
             AND  J.STD_DT = ( SELECT MAX(STD_DT) FROM OT_DWA_DD_BR_BC)
             AND  J.BR_KDCD  <>  '20'
    where    1=1
    and      A.HLFC_DSCD = '1'  -- 재직구분코드(1:재직,2:휴직,3:퇴직)
    AND      A.USR_NO  LIKE '000%'
    --and      A.USR_SMJG_CD = '00023000' -- 사용자직군코드:신용
    and      A.unn_cd = '000' -- 사용자직군코드:신용
    AND      A.USR_PSTN_CD NOT IN ('00053986')  -- '특정업무전담본부' 제외
    AND      A.DPT_CD IN  ('16104000','16112000','H0003532','K0002000','K0006000','K0056000','K0077000'
                          ,'K0079000','K0105000','K0107000','K0116000','K0118000','K0119000','K0120000'
                          ,'K0126000','K0127000','K0129000','K0130000','K0131000','K0132000','K0134000'
                          ,'K0135000','K0136000','K0137000','K0138000','K0139000','K0140000','K0149000'
                          ,'K0150000','K0155000','K0157000','O0000001')
)
SELECT    A.*, LEVEL AS LV1
         ,TRIM(CD1.CMN_CD_NM) AS 팀코드명
         ,TRIM(CD2.CMN_CD_NM) AS 부서코드명
         ,TRIM(CD3.CMN_CD_NM) AS 사용자직급코드명
         ,TRIM(CD4.CMN_CD_NM) AS 사용자직위코드명
FROM     MO  A

LEFT OUTER JOIN
         OM_DWA_CMN_CD_BC   CD1    -- DWA_공통코드기본
         ON   A.TEAM_CD         = CD1.CMN_CD
         AND  CD1.TPCD_NO_EN_NM = 'TEAM_CD'
         AND  CD1.CMN_CD_US_YN = 'Y'  -- 공통코드사용여부

LEFT OUTER JOIN
         OM_DWA_CMN_CD_BC   CD2    -- DWA_공통코드기본
         ON   A.DPT_CD         = CD2.CMN_CD
         AND  CD2.TPCD_NO_EN_NM = 'DPT_CD'
         AND  CD2.CMN_CD_US_YN = 'Y'  -- 공통코드사용여부

LEFT OUTER JOIN
         OM_DWA_CMN_CD_BC   CD3    -- DWA_공통코드기본
         ON   A.USR_PSCL_CD         = CD3.CMN_CD
         AND  CD3.TPCD_NO_EN_NM = 'USR_PSCL_CD'
         AND  CD3.CMN_CD_US_YN = 'Y'  -- 공통코드사용여부

LEFT OUTER JOIN
         OM_DWA_CMN_CD_BC   CD4    -- DWA_공통코드기본
         ON   A.USR_PSTN_CD         = CD4.CMN_CD
         AND  CD4.TPCD_NO_EN_NM = 'USR_PSTN_CD'
         AND  CD3.CMN_CD_US_YN = 'Y'  -- 공통코드사용여부

START WITH PA_소속코드 IS NULL
CONNECT BY PRIOR
         담당소속코드 = PA_소속코드

ORDER BY DPT_CD, NVL(TEAM_CD,'00000000'), LV1;


select CMN_CD,CMN_CD_NM
from  OM_DWA_CMN_CD_BC  -- DWA_공통코드기본
where TPCD_NO_EN_NM = 'USR_PSCL_CD'    -- 고객정보변경구분코드
and   CMN_CD_US_YN = 'Y'  -- 공통코드사용여부
order by 1 ASC
;


부서장 - 팀장 - 차장, 과장, 대리, 행원


/*
여신관리부          16104000
수산해양금융부        16112000
  사회공헌팀        H0003532
심사부            K0002000
자금부            K0006000
  자금세탁방지팀      K0056000
IT지원부          K0077000
IB사업본부         K0079000
전략기획부          K0105000
인사총무부          K0107000
  준법감시팀        K0116000
  정보보호팀        K0118000
  보안운영팀        K0119000
  리스크관리팀       K0120000
  신용리스크 내부등급법 승인 TF팀  O0000050 *
지속경영추진부        K0126000
디지털개인금융부       K0127000
디지털전략부         K0129000
카드사업부          K0130000
기업금융부          K0131000
글로벌외환사업부       K0132000
여신정책부          K0134000
디지털개발부         K0135000
  신용평가팀        K0136000
IT개발부          K0137000
  재산신탁팀        K0138000
  금전신탁팀        K0139000
감사부            K0140000
  론리뷰팀         K0149000
  신용리스크팀       K0150000
  신탁영업추진팀      K0155000
방카펀드사업부        K0157000
  소비자보호팀       O0000001
  소비자지원팀       O0000055  * 인사테이블에 점번호 없음, SSO 사용자기본에도 등록정보 없는 본부산하 부서임...출력안됨
*/

WITH 인사 AS
(
    SELECT    A.사번
             ,A.성명
             ,CASE WHEN A.부서코드 IN  ('H0003532','K0056000','K0116000','K0118000','K0119000','K0120000','K0136000'
                                     ,'K0138000','K0139000','K0149000','K0150000','K0155000','O0000001','O0000050','O0000055') THEN
                CASE WHEN A.직위명 = '팀장' THEN NULL        -- 팀장
                     ELSE A.부서코드
                END
              ELSE
                CASE WHEN A.직위명 in ('부서장','본부장')  THEN NULL  -- 부장, 부서장
                     WHEN A.직위명 = '팀장' THEN A.부서코드        -- 팀장
                     ELSE A.팀코드
                END
              END      AS  PA_소속코드   -- Parent_소속코드
             ,CASE WHEN A.부서코드 IN  ('H0003532','K0056000','K0116000','K0118000','K0119000','K0120000','K0136000'
                                     ,'K0138000','K0139000','K0149000','K0150000','K0155000','O0000001','O0000050','O0000055') THEN
                CASE WHEN A.직위명 = '팀장'  THEN A.부서코드
                     ELSE NULL
                END
              ELSE
                CASE WHEN A.직위명 in ('부서장','본부장')  THEN A.부서코드  -- 부장, 부서장
                     WHEN A.직위명 = '팀장' THEN A.팀코드
                     ELSE NULL
                END
              END  AS  담당소속코드
             ,CASE WHEN A.부서코드 IN  ('H0003532','K0056000','K0116000','K0118000','K0119000','K0120000','K0136000'
                                     ,'K0138000','K0139000','K0149000','K0150000','K0155000','O0000001','O0000050','O0000055') THEN
                CASE WHEN A.직위명 = '팀장'  THEN 1 ELSE 0 END
              ELSE
                CASE WHEN A.직위명 in  ('부서장','본부장')  THEN 1  ELSE 0 END
              END  AS  부서장여부
             ,A.팀코드
             ,A.팀명
             ,A.부서코드
             ,A.부서명
             ,A.직위코드
             ,A.직위명
             ,A.직급코드
             ,A.직급명

    FROM      (
                SELECT   A.*, NVL(TRIM(A.점번호),J1.DPTC_BRNO) AS 점번호_추가

                FROM     TB_MDWT중앙회인사   A

                LEFT OUTER JOIN
                        (
                          SELECT USR_NO, DPTC_BRNO
                          FROM TB_SOR_CMI_USR_BC   A
                          where 1=1
                          AND      A.DPT_CD IN  ('16104000','16112000','H0003532','K0002000','K0006000','K0056000','K0077000'
                                                ,'K0079000','K0105000','K0107000','K0116000','K0118000','K0119000','K0120000','O0000050'
                                                ,'K0126000','K0127000','K0129000','K0130000','K0131000','K0132000','K0134000'
                                                ,'K0135000','K0136000','K0137000','K0138000','K0139000','K0140000','K0149000'
                                                ,'K0150000','K0155000','K0157000','O0000001','O0000055')
                        )  J1
                        ON   A.사번 = J1.USR_NO
                WHERE    1=1
                AND      A.작성기준일  = '20220822'
                and      A.재직구분명 = '재직'
                AND      A.점구분명 = '수협은행'
                AND      A.직위명 <>  '특정업무'  -- '특정업무전담본부' 제외
                AND      A.부서코드 IN  ('16104000','16112000','H0003532','K0002000','K0006000','K0056000','K0077000'
                                      ,'K0079000','K0105000','K0107000','K0116000','K0118000','K0119000','K0120000','O0000050'
                                      ,'K0126000','K0127000','K0129000','K0130000','K0131000','K0132000','K0134000'
                                      ,'K0135000','K0136000','K0137000','K0138000','K0139000','K0140000','K0149000'
                                      ,'K0150000','K0155000','K0157000','O0000001','O0000055')
              )  A

              JOIN   OT_DWA_DD_BR_BC   J      -- DWA_일점기본
                     ON   A.점번호_추가   = J.BRNO
                     AND  J.STD_DT = ( SELECT MAX(STD_DT) FROM OT_DWA_DD_BR_BC)
                     AND  J.BR_KDCD  <>  '20' -- 본점만
),
조직 AS
(
SELECT    A.*, LEVEL AS LV1, CONNECT_BY_ISLEAF AS LEAF
FROM      인사  A
START WITH PA_소속코드 IS NULL
CONNECT BY PRIOR
         담당소속코드 = PA_소속코드
)
--접속자
--SELECT * FROM 조직
--ORDER BY 부서코드, 부서장여부 DESC, 팀코드, LV1;

-- 결재라인
SELECT    A.사번, A.성명, A.PA_소속코드, A.담당소속코드, A.팀명, A.부서명, A.직위명
         ,B.사번 AS 결재자1차_사번 , B.성명 AS  결재자1차_성명
         ,C.사번 AS 결재자2차_사번 , C.성명 AS  결재자2차_성명
         ,CASE WHEN A.PA_소속코드 = B.담당소속코드 THEN '1.우선'  ELSE '2.차선' END  AS 비고   -- 직속결재라인
FROM      조직  A
JOIN      조직  B
          ON  A.부서코드    = B.부서코드
          AND A.LV1 -1      = B.LV1
          
LEFT OUTER JOIN
          조직  C
          ON  B.PA_소속코드 = C.담당소속코드
          AND B.부서코드    = C.부서코드
          AND B.LV1 -1      = C.LV1

UNION ALL

-- 부서장 --
SELECT    A.사번, A.성명, A.PA_소속코드, A.담당소속코드, ' ' AS 팀명, A.부서명, A.직위명
         ,NULL  AS 결재자1차_사번 , NULL AS  결재자1차_성명
         ,NULL  AS 결재자2차_사번 , NULL AS  결재자2차_성명
         ,'1.우선'  AS 비고   -- 직속결재라인
FROM      조직  A
WHERE     1=1
AND       A.PA_소속코드 IS NULL
         
ORDER BY 6,5,1,12,3;



select *
from  TB_MDWT중앙회인사   A
where 1=1
and  작성기준일  = '20220819'
and 부서코드  = 'H0003532'
H0003532
팀장


## TB_OPE_KRI_정보보호팀01_참고.ctl
OPTIONS(SKIP=2)
LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_정보보호팀01
WHEN (1:1) <> '('
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(  STD_DT            "TO_CHAR(TO_DATE(TRIM(:STD_DT),'YYYY-MM-DD'),'YYYYMMDD')"
  ,BR_NM             "TRIM(CONVERT(:BR_NM,'KO16KSC5601','UTF8'))"
  ,USR_NM            "TRIM(CONVERT(:USR_NM,'KO16KSC5601','UTF8'))"
  ,USR_ID            "TRIM(:USR_ID)"
  ,FL_CNT            "TRIM(:FL_CNT)"
  ,PTR_CNT           "TRIM(:PTR_CNT)"
  ,ADTG_TP           "TRIM(:ADTG_TP)"
  ,ADTG_DT           "TO_CHAR(TO_DATE(TRIM(:ADTG_DT),'YYYY-MM-DD'),'YYYYMMDD')"  
)


 
 
##  SQL Loader 사용법

-----------------------------
LOAD DATA
TRUNCATE
INTO TABLE TEMP_FG_OR_MK_RI013
FIELDS TERMINATED BY '^'
TRAILING NULLCOLS
(   STD_YM                                           -- 기준년월
,   TMP_SNO                                          -- 임시일련번호
,   LST_CHG_DTTM        SYSDATE                      -- 최종변경일시
,   SVY_HDN_VL_CTS      "TRIM(:SVY_HDN_VL_CTS  )"    -- 조사항목값내용
,   NFFC_UNN_DSCD_NM    "TRIM(:NFFC_UNN_DSCD_NM)"    -- 중앙회조합구분코드명
,   CRD_PRD_DSCD_NM     "TRIM(:CRD_PRD_DSCD_NM )"    -- 카드상품구분코드명
,   SCTN_FVL                                         -- 구간숫자값
)

tel  char(4) nullif  tel=blanks,

iss_time   DATE "YYYY/MM/DD HH:MI:SS",

sql Loader 사용법  으로 구글링

OPTIONS(SKIP=2)
LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_정보보호팀01
WHEN (1:1) <> '('
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(  STD_DT            "TO_CHAR(TO_DATE(TRIM(:STD_DT),'YYYY-MM-DD'),'YYYYMMDD')"
  ,BR_NM             "TRIM(CONVERT(:BR_NM,'KO16KSC5601','UTF8'))"
  ,USR_NM            "TRIM(CONVERT(:USR_NM,'KO16KSC5601','UTF8'))"
  ,USR_ID            "TRIM(:USR_ID)"
  ,FL_CNT            "TRIM(:FL_CNT)"
  ,PTR_CNT           "TRIM(:PTR_CNT)"
  ,ADTG_TP           "TRIM(:ADTG_TP)"
  ,ADTG_DT           "TO_CHAR(TO_DATE(TRIM(:ADTG_DT),'YYYY-MM-DD'),'YYYYMMDD')"  
)

LOAD DATA
CHARACTERSET UTF8
TRUNCATE
INTO TABLE TEMP_OPE_KRI_직원만족팀01
FIELDS TERMINATED BY '|'
TRAILING NULLCOLS
(
   STD_DT
  ,BRNO
  ,BR_NM                               "TRIM(:BR_NM)"
  ,DCM_DTT
  ,DCM_NO                              "TRIM(:DCM_NO)"
  ,DCM_TLT                             "TRIM(:DCM_TLT)"
  ,DCD_RQST_DT
  ,DCD_RQMR_NM                         "TRIM(:DCD_RQMR_NM)"
  ,DCDR_NM                             "TRIM(:DCDR_NM)"
  ,DCD_ARV_DT
  ,DCD_TMNT_DT
)
