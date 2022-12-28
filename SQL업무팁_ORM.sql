-- #DWA_�����ڵ�⺻ #�����ڵ� 
select CMN_CD,CMN_CD_NM
from  OM_DWA_CMN_CD_BC  -- DWA_�����ڵ�⺻
where TPCD_NO_EN_NM = 'LNRV_STS_DSCD'    -- ���������汸���ڵ�
and   CMN_CD_US_YN = 'Y'  -- �����ڵ��뿩��
order by 1 ASC
;

      CUST_NO	����ȣ
     ,CUST_INF_CHG_SNO	�����������Ϸù�ȣ
-- #SOR_CUS_�����泻�� #������
select
     ,CUST_INF_CHG_DSCD	���������汸���ڵ�
     ,CHB_DAT_CTS	�����������ͳ���
     ,CHA_DAT_CTS	�����ĵ����ͳ���
     ,ENR_DTTM  ����Ͻ�
from  TB_SOR_CUS_CHG_TR   a  -- SOR_CUS_�����泻��
where CUST_INF_CHG_DSCD='0037'
order by 6 desc;


##  ADD_MONTHS

������� ��¥�� ���ϴµ�
�Է��ѳ�¥�� �ش���� ������������ ���� 
������ �������� ��¥�� ��������¥�� ������ ���´�..

SELECT ADD_MONTHS(TO_DATE('20220430', 'YYYYMMDD'), 1) FROM DUAL;
 20220530 ���� �Ѵ����� ��¥������ 20220430 �� 4���� ���������̹Ƿ�
 ����� 20220531 �� 5���� ���������� ���ϵǾ� ���´�.

SELECT ADD_MONTHS(TO_DATE('20220330', 'YYYYMMDD'), -1) FROM DUAL;
 20220330 ���� �Ѵ��� ��¥�� ��������� ����ϸ� 20220230 �̰�����
 20220330 ���� 3���� ���������̹Ƿ� 20220228 ���� ���ϵǾ� ���´�.


## MONTHS_BETWEEN
�տ���¥���� �ڿ���¥�� ���� ����
ù��° �Ķ��Ÿ�� �ռ���¥�̸� ���̳ʽ��� ���´�.
SELECT MONTHS_BETWEEN(TO_DATE('20220228','YYYYMMDD'),TO_DATE('20220101','YYYYMMDD')) FROM DUAL;
1.87096774193548387096774193548387096774
 
 
 

-- �׽�Ʈ��
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
    echo "!! STD_DT.dat ������ ������ �߻��Ͽ����ϴ�."
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

## EAI �Ķ��Ÿ �̿��ϱ�

2020.09.22 : batch.sh -i PPSCBIBD3004 -s "STD_DATE=���ǰ�1 & LOG_SNO=���ǰ�2"

/* ��ǥ�߻����� ��ȸ ���վ����α׿�����̺� */
SELECT 
 V.SYS_DT             AS  SYS_DT
,V.RL_TR_HM_SEC       AS  RL_TR_HM_SEC     --�ǰŷ��ð� 
,V.RL_TR_DT           AS  RL_TR_DT          --�ǰŷ�����   
,V.GBL_ID_NO          AS  GBL_ID_NO 
,V.FW_LOG_LKG_NO	  AS  FW_LOG_LKG_NO																					   																					 -- �����ӿ�ũ�α׿�����ȣ
,V.FW_LOG_NO	      AS  FW_LOG_NO
,V.INTG_LOG_TR_SNO	  AS  INTG_LOG_TR_SNO
,V.LST_AMN_TS         AS  LST_AMN_TS--����Ÿ�ӽ�����
,V.INTG_ACNO          AS  INTG_ACNO
,V.TLR_NO             AS  TLR_NO
,V.HDL_BRNO           AS HDL_BRNO
,V.INP_SCRN_ID        AS INP_SCRN_ID
,V.USR_NM             AS USR_NM
,V.SLP_NO             AS SLP_NO
,V.TLG_RQS_DTTM       AS TLG_RQS_DTTM
,V.LOG_SNO            AS LOG_SNO
,V.CRC_CNCL_DSCD  AS CRC_CNCL_DSCD  --������ұ����ڵ�
,V.FSC_DT 	 	      AS FSC_DT	    --ȸ������

  FROM (SELECT /*+ FULL(A) PARALLEL(2) */
              A.SYS_DT 	
             ,A.RL_TR_HM_SEC                --�ǰŷ��ð� 
		     ,A.RL_TR_DT                    --�ǰŷ�����   
		     ,A.GBL_ID_NO
			 ,A.FW_LOG_LKG_NO																						   																					 -- �����ӿ�ũ�α׿�����ȣ
	         ,A.FW_LOG_NO	
			 ,A.INTG_LOG_TR_SNO		
			 ,  to_char( A.LST_AMN_TS,'YYYYMMDDHH24MISS' )  AS LST_AMN_TS   --����Ÿ�ӽ�����
			 , CASE WHEN A.INP_INTG_ACNO IS NULL THEN A.INTG_ACNO       
                    ELSE A.INP_INTG_ACNO       
			        END	AS  INTG_ACNO                       -- ���¹�ȣ  
--		     , CASE WHEN (A.TLR_NO IS NULL) OR (A.TLR_NO = '0') THEN A.USR_NO       
--	                ELSE  A.TLR_NO END AS TLR_NO             -- �ڷ���ȣ 
--2020.12.21 �ڷ���ȣ ��� ����ڹ�ȣ�� ����
                 ,A.USR_NO  AS TLR_NO                 
			 ,A.HDL_BRNO                                     --�������ȣ		
			 , CASE WHEN A.CHNL_TPCD = 'STML'  
			                             THEN  
			                             CASE WHEN A.FST_FRWD_SYS_CD = 'INS'  THEN SUBSTR(A.INP_SCRN_ID,1,4)  
				                              ELSE A.FST_FRWD_SYS_CD  
			                             END       
			        ELSE SUBSTR(A.INP_SCRN_ID,1,4)  
		            END AS  INP_SCRN_ID                                     -- �Է�ȭ�� ID   	
	        , CASE  WHEN (A.USR_NM IS NULL) OR (A.USR_NM = '0') THEN ' '       
		            ELSE  A.USR_NM      
		            END AS USR_NM                                           -- ����ڸ�(����ڸ�)
		    ,LPAD(A.SLP_NO,5,'0') AS SLP_NO 		    -- ��ǥ��ȣ
-- 2021.01.27 ��ǥ�� ��ü���� ���ڸ� ���� �����ϰ��ŷ�ȭ�鸸 �ٰǰ�꼭�ĺ���ȣ�� RCV_SVC_CD�� ����
   	        ,CASE WHEN SUBSTR(INP_SCRN_ID,1,4) IN ('1033','1034','1018') THEN RCV_SVC_CD
			      ELSE to_char( A.TLG_RQS_DTTM ,  'YYYYMMDDHH24MISS' ) END AS TLG_RQS_DTTM   --������û�Ͻ�
            ,A.LOG_SNO   --�α��Ϸù�ȣ
           , A.CRC_CNCL_DSCD  -- ������ұ����ڵ�
		   , A.FSC_DT 	 --ȸ������
                  
         FROM TB_CMP_TSK_LOG_SMR_TR A
         WHERE A.ONL_DT = #STD_DATE#
         AND A.PCS_DD = SUBSTR(#STD_DATE#,7,2)          -- �ʿ�  
       --  AND A.LOG_SNO > 0                              -- �ʿ� (LAST KEY)
          AND A.LOG_SNO >  #LOG_SNO#            -- �ʿ� (LAST KEY)
         AND A.SLP_NO  BETWEEN 1  AND 99999             -- �ʿ� 
         AND ((A.CHNL_TPCD = 'TTML') OR (A.CHNL_TPCD = 'STML'))  --�ʿ� 
     	--	 AND A.TR_BR_DSCD = '1'  -- 1:���� 2:����  (�������� NULL�� �־��༭ ���� ������) 2020.09.25
             AND ( A.TR_BR_DSCD IS NULL  OR  A.TR_BR_DSCD =  '1' )  -- 1:���� 2:���� 
         ORDER BY LOG_SNO 
)V
 WHERE ROWNUM < 10000 --�ѹ��� ������ ���� �ʴ´�.  


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
	           AND  TABLE_NAME  = 'TB_OPE_KRI_������ȣ��03'
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
    /* ���ν����� �����ϴ� ����� ���� ���� */
    V_STATUS            CHAR(1)     := 'R';
    V_CLIENT_INFO       VARCHAR2(64) := SYS_CONTEXT('userenv','CLIENT_INFO');
    V_MODULE            VARCHAR2(48) := SYS_CONTEXT('userenv','MODULE');
    V_HOST              VARCHAR2(50) := SYS_CONTEXT('userenv','HOST') ;
    V_IP_ADDRESS        VARCHAR2(30) := SYS_CONTEXT('userenv','IP_ADDRESS');
    V_OSUSER            VARCHAR2(30) := SYS_CONTEXT('userenv','OS_USER');
    V_USER              VARCHAR2(30) := SYS_CONTEXT('userenv','SESSION_USER');
    
BEGIN
    INSERT INTO TB_PRG_LOG
    (OWNER,TABLE_NAME,WORK_DAY,JOB_NAME,SEQ,STEP_NAME,JOB_START_TIME,STEP_START_TIME,STATUS    -- ���ڷ� ����
    ,CLIENT_INFO,MODULE,HOST,IP_ADDRESS,OSUSER,USERNAME)    -- �ڵ� �Ҵ�
    VALUES
    (P_OWNER,P_TABLE_NAME,P_WORK_DAY,P_JOB_NAME,P_SEQ,P_STEP_NAME,P_JOB_START_TIME,P_STEP_START_TIME,V_STATUS -- ���ڷ� ����
    ,V_CLIENT_INFO,V_MODULE,V_HOST,V_IP_ADDRESS,V_OSUSER,V_USER);   -- �ڵ� �Ҵ�
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


## �޸�

tar -cvpf opeapp_p.tar -L inputlist
/opeapp/cres/create_TB_OPE_KRI_��������������23.sql
/opeapp/sql/init/ins_TB_OPE_KRI_��������������23.sql
/opeapp/sql/chg/ins_TB_OPE_KRI_��������������23.sql

/opeapp/cres/create_TB_OPE_KRI_�ڱݼ�Ź������06.sql
/opeapp/sql/init/ins_TB_OPE_KRI_�ڱݼ�Ź������06.sql
/opeapp/sql/chg/ins_TB_OPE_KRI_�ڱݼ�Ź������06.sql

/opeapp/cres/create_TB_OPE_KRI_����������01.sql
/opeapp/shell/chg/getfile_����������01.sh
/opeapp/ctl/TB_OPE_KRI_����������01.ctl
/opeapp/sql/chg/ins_TB_OPE_KRI_����������01.sql
/opeapp/shell/chg/lod_TB_OPE_KRI_����������01.sh

/opeapp/sql/chg/ins_TB_OPE_KRI_ī���ȹ��02.sql
/opeapp/sql/init/ins_TB_OPE_KRI_ī���ȹ��02.sql

������ ���
------------------------
Windows��� : a!from1205 -> !rfrom1205
Tgate : a!from1205 -> !rfrom1205
DBsafer��� :   a!from1205 -> !rfrom1205

�������ũ
--------------------
/weblogic/bi/opeDomain01/config/config.xml  
  -- �ҽ��ǰ�� �� jdbc����xml
  -- �ҽ��� ���(/weblogic/bi/apps/ope)
  -- JDBC����xml (/weblogic/bi/opeDomain01/config/jdbc/)

http://localhost:8180/orms/login.jsp
OPE_012/OPE_012

���ո���ũ
/ohs/bi/trmDomain01/config/fmwconfig/components/OHS/instances/trmOhs01/httpd.conf   <== �� ���Ͽ� 40060 ��������

�����ũ ��Ʈ(����)
/ohs/bi/opeDomain01/config/fmwconfig/components/OHS/instances/opeOhs01/httpd.conf   <== 7060 �̶�� ��������

IP�ּҼ���
-------------------
IP:192.168.187.187
G/W : 192.168.187.1
DNS : 138.240.112.121, 122



EKP �޽��� ID
-------------------------
bj31229902/!1q2w3e4r
bj31229901/!1q2w3e4r

���ϼ�������
  ----------------------
\\192.168.187.151\          OPE_012/1Q2w3e4r!@

Tgate��ġ������ �� �������α׷� ��ġ
--------------------------
http://138.240.112.50/agent/index.html
0021220098/a!from1205
���õ� �����ʼ� ���α׷� ��ġ
���, DRM, Privacy-i ���
DRM : 0021220098/a!from1205

SSO test ���� (��ȭ��Open�ʿ�)
-------------------------------------
http://shssotest.suhyup.co.kr:7060/

������ jobmind
-------------------------------
����  OPE_012/j.ope_012!@
http://jobmindtd.suhyup.co.kr:8185/jobmind/frame/login/getLoginForm.do
�
http://jobmind.suhyup.co.kr:8185/jobmind/frame/login/getLoginForm.do

���������ý��� �������� �� ��û
-----------------------------------------
1) ��������
http://tim.suhyup.co.kr:8080
ȸ�������������� - 5���̻� ������ -
���̵�/��� �ְ� �α��ΰ���(�� ��ٷ��� �� ����)
p9000597/a!from1205

2) DB����/���ѽ�û
DB����/���ѽ�û>DB safer����û>��ŸDB���ӽ�û
>�ý��ۼ���> edwdbd02_rip,edwdbd03_rip,edwdbd02_vip,
edwdbd03_vip,edwdbd_scan1,2,3
> 1�������� ������, 2�������� �ڻ�ȯ
> ���Ⱓ����
DBsafer ��ġ�� ID�� ���������ý���ID ���, �ʱ��� 1111 
��������� ����� ��

DB ���� :     
-------------------
opeown/opeown!2209 :  ���̺�� ���� Object ����( Owner����)opeett/opeown!2209   : ��ġ�۾���
opeprc/opeown!2209  : ���ν������� (Owner����)
opedev/opeown!2209 : ���߿�(���߱Ⱓ�� ����ϰ� �����)

Unix���� sqlplus ���
--------------------------
sqlplus opeett/opeett!2209@138.240.38.34:1523/DBDOPE
sqlplus opeett/opeett!2209@DBDOPE
sqlplus opeown/opeown!2209@138.240.38.33:1523/DBDOPE

Unix ����
-------------------------------
��ġ���� opeett/opeett!2205 : ��ġ�۾��� Unix ����
������ : opeadm/opeadm!2205 : �����ڿ���� �̸鼭 ���������

------------------------------TODO----------------------------
erd - ��Ÿ  - ���̺�creation - grant_all
���α׷��̰�
���ġ���� ȯ������(.profile, ���丮��, DB���ӵ�)
dw�۾������۾����� ���� - �����ٷ��̰�
 
 
## ����Ŭ���Ѱ���


-- ���帮��ũ ope ������ ROLE �� ��͵��� �ִ��� Ȯ���Ѵ�.
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTED_ROLE LIKE  '%OPE%';

SYSTEM RL_OPE_ALL YES NO  YES NO  NO
SYSTEM RL_OPE_SEL YES NO  YES NO  NO
SYSTEM RL_OPE_EXE YES NO  YES NO  NO
OPEPRC RL_OPE_ALL NO  NO  YES NO  NO
OPEPRC RL_OPE_EXE
OPEDEV RL_OPE_ALL NO  NO  YES NO  NO
OPEETT RL_OPE_ALL NO  NO  YES NO  NO
OPEETT RL_OPE_EXE NO  NO  YES NO  NO
## RL_OPE_ALL,RL_OPE_SEL,RL_OPE_EXE ���� �����ũ���õ� �ѷ� ���δ�.

-- �������� �ο��� ���� ����� �ִ��� Ȯ���Ѵ�.
SELECT * FROM DBA_ROLE_PRIVS WHERE GRANTEE = 'OPEETT';

OPEETT RL_EDW_SEL NO  NO  YES NO  NO
OPEETT CONNECT NO  NO  YES NO  NO
OPEETT RL_OPE_ALL NO  NO  YES NO  NO
OPEETT RL_OPE_EXE
## OPEETT �������� RL_EDW_SEL,RL_OPE_ALL,RL_OPE_EXE �̷��� 3���� ���� �ο��Ǿ� �ִ�.


-- Ư��ROLE�� ���� ������ ����ڿ��� �ο��� ���̺� ���� ������ �����ش�.
SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = 'RL_OPE_ALL'
SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = 'RL_OPE_SEL'
## ó������ �ƹ��͵� ��µ��� �ʴ´�.
## ���̺��� �����ϰ� �Ʒ��� ���� ���̺� ���� ���ѵ��� �ѿ� �ο��ϰ�
GRANT SELECT ON TB_FG_OR_MK_RI012 TO RL_OPE_ALL;
GRANT DELETE ON TB_FG_OR_MK_RI012 TO RL_OPE_ALL;
GRANT UPDATE ON TB_FG_OR_MK_RI012 TO RL_OPE_ALL;
GRANT INSERT ON TB_FG_OR_MK_RI012 TO RL_OPE_ALL;

GRANT SELECT ON TB_FG_OR_MK_RI012 TO RL_OPE_SEL;

## �ٽ� RL_OPE_ALL,RL_OPE_SEL ���� ���� �ο��� ����(OPEETT) �� �����Ͽ�  ROLE_TAB_PRIVS �� ��ȸ�ϸ� �ο��� ���ѵ��� ���δ�.

# ���Ӱ���Ȯ��
select SYS_CONTEXT ('USERENV', 'SESSION_USER') from dual

# �ѿ� �ο��� ���ν����� ������ѵ� �����ϰ� ROLE_TAB_PRIVS �� ���Ͽ� Ȯ���Ҽ� �ִ�.
SELECT * FROM ROLE_TAB_PRIVS WHERE ROLE = 'RL_OPE_EXE'

# ������ lock �ɷȴ��� Ȯ��  ACCOUNT_STATUS
select * from dba_users
where username = 'OPEOWN';

# RL_EDW_SEL �ѿ� �ο��� �ѵ�.
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
GRANT SELECT ON TB_FG_OR_MK_RI012 TO RL_EDW_ALL;  -- PUBLIC SYNONYM �� GRANT ���൵ ���� ������ 

DROP PUBLIC SYNONYM TB_FG_OR_MK_RI012;


select * from dba_sys_privs
where grantee = 'MKROWN';
/*
MKROWN	CREATE TABLE
MKROWN	CREATE DATABASE LINK
MKROWN	CREATE VIEW
MKROWN	CREATE PUBLIC SYNONYM  <== ������� �־�� PUBLIC SYNONYM �� ����� �ִ�.
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

## ����

/*
���Ű�����          16104000
�����ؾ������        16112000
  ��ȸ������        H0003532
�ɻ��            K0002000
�ڱݺ�            K0006000
  �ڱݼ�Ź������      K0056000
IT������          K0077000
IB�������         K0079000
������ȹ��          K0105000
�λ��ѹ���          K0107000
  �ع�������        K0116000
  ������ȣ��        K0118000
  ���ȿ��        K0119000
  ����ũ������       K0120000
  �ſ븮��ũ ���ε�޹� ���� TF��  O0000050 *
���Ӱ濵������        K0126000
�����а��α�����       K0127000
������������         K0129000
ī������          K0130000
���������          K0131000
�۷ι���ȯ�����       K0132000
������å��          K0134000
�����а��ߺ�         K0135000
  �ſ�����        K0136000
IT���ߺ�          K0137000
  ����Ź��        K0138000
  ������Ź��        K0139000
�����            K0140000
  �и�����         K0149000
  �ſ븮��ũ��       K0150000
  ��Ź����������      K0155000
��ī�ݵ�����        K0157000
  �Һ��ں�ȣ��       O0000001
  �Һ���������       O0000055  *
*/



WITH MO AS
(
    SELECT    A.USR_NO
             ,A.USR_NM
             ,CASE WHEN A.DPT_CD IN  ('H0003532','K0056000','K0116000','K0118000','K0119000','K0120000','K0136000'
                                     ,'K0138000','K0139000','K0149000','K0150000','K0155000','O0000001') THEN
                CASE WHEN A.USR_PSTN_CD = '00054002' THEN NULL        -- ����
                     ELSE A.DPT_CD
                END
              ELSE
                CASE WHEN A.USR_PSTN_CD IN ('00053001','00059800')  THEN NULL  -- ����, �μ���
                     WHEN A.USR_PSTN_CD = '00054002' THEN A.DPT_CD        -- ����
                     ELSE A.TEAM_CD
                END
              END      AS  PA_�Ҽ��ڵ�   -- Parent_�Ҽ��ڵ�
             ,CASE WHEN A.DPT_CD IN  ('H0003532','K0056000','K0116000','K0118000','K0119000','K0120000','K0136000'
                                     ,'K0138000','K0139000','K0149000','K0150000','K0155000','O0000001') THEN
                CASE WHEN A.USR_PSTN_CD = '00054002'  THEN A.DPT_CD
                     ELSE NULL
                END
              ELSE
                CASE WHEN A.USR_PSTN_CD IN ('00053001','00059800')  THEN A.DPT_CD  -- ����, �μ���
                     WHEN A.USR_PSTN_CD = '00054002' THEN A.TEAM_CD
                     ELSE NULL
                END
              END  AS  ���Ҽ��ڵ�
             ,A.TEAM_CD
             ,A.DPT_CD
             ,A.USR_PSCL_CD
             ,A.USR_PSTN_CD

    FROM     TB_SOR_CMI_USR_BC   A
    JOIN     OT_DWA_DD_BR_BC   J      -- DWA_�����⺻
             ON   A.DPTC_BRNO  = J.BRNO
             AND  J.STD_DT = ( SELECT MAX(STD_DT) FROM OT_DWA_DD_BR_BC)
             AND  J.BR_KDCD  <>  '20'
    where    1=1
    and      A.HLFC_DSCD = '1'  -- ���������ڵ�(1:����,2:����,3:����)
    AND      A.USR_NO  LIKE '000%'
    --and      A.USR_SMJG_CD = '00023000' -- ����������ڵ�:�ſ�
    and      A.unn_cd = '000' -- ����������ڵ�:�ſ�
    AND      A.USR_PSTN_CD NOT IN ('00053986')  -- 'Ư���������㺻��' ����
    AND      A.DPT_CD IN  ('16104000','16112000','H0003532','K0002000','K0006000','K0056000','K0077000'
                          ,'K0079000','K0105000','K0107000','K0116000','K0118000','K0119000','K0120000'
                          ,'K0126000','K0127000','K0129000','K0130000','K0131000','K0132000','K0134000'
                          ,'K0135000','K0136000','K0137000','K0138000','K0139000','K0140000','K0149000'
                          ,'K0150000','K0155000','K0157000','O0000001')
)
SELECT    A.*, LEVEL AS LV1
         ,TRIM(CD1.CMN_CD_NM) AS ���ڵ��
         ,TRIM(CD2.CMN_CD_NM) AS �μ��ڵ��
         ,TRIM(CD3.CMN_CD_NM) AS ����������ڵ��
         ,TRIM(CD4.CMN_CD_NM) AS ����������ڵ��
FROM     MO  A

LEFT OUTER JOIN
         OM_DWA_CMN_CD_BC   CD1    -- DWA_�����ڵ�⺻
         ON   A.TEAM_CD         = CD1.CMN_CD
         AND  CD1.TPCD_NO_EN_NM = 'TEAM_CD'
         AND  CD1.CMN_CD_US_YN = 'Y'  -- �����ڵ��뿩��

LEFT OUTER JOIN
         OM_DWA_CMN_CD_BC   CD2    -- DWA_�����ڵ�⺻
         ON   A.DPT_CD         = CD2.CMN_CD
         AND  CD2.TPCD_NO_EN_NM = 'DPT_CD'
         AND  CD2.CMN_CD_US_YN = 'Y'  -- �����ڵ��뿩��

LEFT OUTER JOIN
         OM_DWA_CMN_CD_BC   CD3    -- DWA_�����ڵ�⺻
         ON   A.USR_PSCL_CD         = CD3.CMN_CD
         AND  CD3.TPCD_NO_EN_NM = 'USR_PSCL_CD'
         AND  CD3.CMN_CD_US_YN = 'Y'  -- �����ڵ��뿩��

LEFT OUTER JOIN
         OM_DWA_CMN_CD_BC   CD4    -- DWA_�����ڵ�⺻
         ON   A.USR_PSTN_CD         = CD4.CMN_CD
         AND  CD4.TPCD_NO_EN_NM = 'USR_PSTN_CD'
         AND  CD3.CMN_CD_US_YN = 'Y'  -- �����ڵ��뿩��

START WITH PA_�Ҽ��ڵ� IS NULL
CONNECT BY PRIOR
         ���Ҽ��ڵ� = PA_�Ҽ��ڵ�

ORDER BY DPT_CD, NVL(TEAM_CD,'00000000'), LV1;


select CMN_CD,CMN_CD_NM
from  OM_DWA_CMN_CD_BC  -- DWA_�����ڵ�⺻
where TPCD_NO_EN_NM = 'USR_PSCL_CD'    -- ���������汸���ڵ�
and   CMN_CD_US_YN = 'Y'  -- �����ڵ��뿩��
order by 1 ASC
;


�μ��� - ���� - ����, ����, �븮, ���


/*
���Ű�����          16104000
�����ؾ������        16112000
  ��ȸ������        H0003532
�ɻ��            K0002000
�ڱݺ�            K0006000
  �ڱݼ�Ź������      K0056000
IT������          K0077000
IB�������         K0079000
������ȹ��          K0105000
�λ��ѹ���          K0107000
  �ع�������        K0116000
  ������ȣ��        K0118000
  ���ȿ��        K0119000
  ����ũ������       K0120000
  �ſ븮��ũ ���ε�޹� ���� TF��  O0000050 *
���Ӱ濵������        K0126000
�����а��α�����       K0127000
������������         K0129000
ī������          K0130000
���������          K0131000
�۷ι���ȯ�����       K0132000
������å��          K0134000
�����а��ߺ�         K0135000
  �ſ�����        K0136000
IT���ߺ�          K0137000
  ����Ź��        K0138000
  ������Ź��        K0139000
�����            K0140000
  �и�����         K0149000
  �ſ븮��ũ��       K0150000
  ��Ź����������      K0155000
��ī�ݵ�����        K0157000
  �Һ��ں�ȣ��       O0000001
  �Һ���������       O0000055  * �λ����̺� ����ȣ ����, SSO ����ڱ⺻���� ������� ���� ���λ��� �μ���...��¾ȵ�
*/

WITH �λ� AS
(
    SELECT    A.���
             ,A.����
             ,CASE WHEN A.�μ��ڵ� IN  ('H0003532','K0056000','K0116000','K0118000','K0119000','K0120000','K0136000'
                                     ,'K0138000','K0139000','K0149000','K0150000','K0155000','O0000001','O0000050','O0000055') THEN
                CASE WHEN A.������ = '����' THEN NULL        -- ����
                     ELSE A.�μ��ڵ�
                END
              ELSE
                CASE WHEN A.������ in ('�μ���','������')  THEN NULL  -- ����, �μ���
                     WHEN A.������ = '����' THEN A.�μ��ڵ�        -- ����
                     ELSE A.���ڵ�
                END
              END      AS  PA_�Ҽ��ڵ�   -- Parent_�Ҽ��ڵ�
             ,CASE WHEN A.�μ��ڵ� IN  ('H0003532','K0056000','K0116000','K0118000','K0119000','K0120000','K0136000'
                                     ,'K0138000','K0139000','K0149000','K0150000','K0155000','O0000001','O0000050','O0000055') THEN
                CASE WHEN A.������ = '����'  THEN A.�μ��ڵ�
                     ELSE NULL
                END
              ELSE
                CASE WHEN A.������ in ('�μ���','������')  THEN A.�μ��ڵ�  -- ����, �μ���
                     WHEN A.������ = '����' THEN A.���ڵ�
                     ELSE NULL
                END
              END  AS  ���Ҽ��ڵ�
             ,CASE WHEN A.�μ��ڵ� IN  ('H0003532','K0056000','K0116000','K0118000','K0119000','K0120000','K0136000'
                                     ,'K0138000','K0139000','K0149000','K0150000','K0155000','O0000001','O0000050','O0000055') THEN
                CASE WHEN A.������ = '����'  THEN 1 ELSE 0 END
              ELSE
                CASE WHEN A.������ in  ('�μ���','������')  THEN 1  ELSE 0 END
              END  AS  �μ��忩��
             ,A.���ڵ�
             ,A.����
             ,A.�μ��ڵ�
             ,A.�μ���
             ,A.�����ڵ�
             ,A.������
             ,A.�����ڵ�
             ,A.���޸�

    FROM      (
                SELECT   A.*, NVL(TRIM(A.����ȣ),J1.DPTC_BRNO) AS ����ȣ_�߰�

                FROM     TB_MDWT�߾�ȸ�λ�   A

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
                        ON   A.��� = J1.USR_NO
                WHERE    1=1
                AND      A.�ۼ�������  = '20220822'
                and      A.�������и� = '����'
                AND      A.�����и� = '��������'
                AND      A.������ <>  'Ư������'  -- 'Ư���������㺻��' ����
                AND      A.�μ��ڵ� IN  ('16104000','16112000','H0003532','K0002000','K0006000','K0056000','K0077000'
                                      ,'K0079000','K0105000','K0107000','K0116000','K0118000','K0119000','K0120000','O0000050'
                                      ,'K0126000','K0127000','K0129000','K0130000','K0131000','K0132000','K0134000'
                                      ,'K0135000','K0136000','K0137000','K0138000','K0139000','K0140000','K0149000'
                                      ,'K0150000','K0155000','K0157000','O0000001','O0000055')
              )  A

              JOIN   OT_DWA_DD_BR_BC   J      -- DWA_�����⺻
                     ON   A.����ȣ_�߰�   = J.BRNO
                     AND  J.STD_DT = ( SELECT MAX(STD_DT) FROM OT_DWA_DD_BR_BC)
                     AND  J.BR_KDCD  <>  '20' -- ������
),
���� AS
(
SELECT    A.*, LEVEL AS LV1, CONNECT_BY_ISLEAF AS LEAF
FROM      �λ�  A
START WITH PA_�Ҽ��ڵ� IS NULL
CONNECT BY PRIOR
         ���Ҽ��ڵ� = PA_�Ҽ��ڵ�
)
--������
--SELECT * FROM ����
--ORDER BY �μ��ڵ�, �μ��忩�� DESC, ���ڵ�, LV1;

-- �������
SELECT    A.���, A.����, A.PA_�Ҽ��ڵ�, A.���Ҽ��ڵ�, A.����, A.�μ���, A.������
         ,B.��� AS ������1��_��� , B.���� AS  ������1��_����
         ,C.��� AS ������2��_��� , C.���� AS  ������2��_����
         ,CASE WHEN A.PA_�Ҽ��ڵ� = B.���Ҽ��ڵ� THEN '1.�켱'  ELSE '2.����' END  AS ���   -- ���Ӱ������
FROM      ����  A
JOIN      ����  B
          ON  A.�μ��ڵ�    = B.�μ��ڵ�
          AND A.LV1 -1      = B.LV1
          
LEFT OUTER JOIN
          ����  C
          ON  B.PA_�Ҽ��ڵ� = C.���Ҽ��ڵ�
          AND B.�μ��ڵ�    = C.�μ��ڵ�
          AND B.LV1 -1      = C.LV1

UNION ALL

-- �μ��� --
SELECT    A.���, A.����, A.PA_�Ҽ��ڵ�, A.���Ҽ��ڵ�, ' ' AS ����, A.�μ���, A.������
         ,NULL  AS ������1��_��� , NULL AS  ������1��_����
         ,NULL  AS ������2��_��� , NULL AS  ������2��_����
         ,'1.�켱'  AS ���   -- ���Ӱ������
FROM      ����  A
WHERE     1=1
AND       A.PA_�Ҽ��ڵ� IS NULL
         
ORDER BY 6,5,1,12,3;



select *
from  TB_MDWT�߾�ȸ�λ�   A
where 1=1
and  �ۼ�������  = '20220819'
and �μ��ڵ�  = 'H0003532'
H0003532
����


## TB_OPE_KRI_������ȣ��01_����.ctl
OPTIONS(SKIP=2)
LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_������ȣ��01
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


 
 
##  SQL Loader ����

-----------------------------
LOAD DATA
TRUNCATE
INTO TABLE TEMP_FG_OR_MK_RI013
FIELDS TERMINATED BY '^'
TRAILING NULLCOLS
(   STD_YM                                           -- ���س��
,   TMP_SNO                                          -- �ӽ��Ϸù�ȣ
,   LST_CHG_DTTM        SYSDATE                      -- ���������Ͻ�
,   SVY_HDN_VL_CTS      "TRIM(:SVY_HDN_VL_CTS  )"    -- �����׸񰪳���
,   NFFC_UNN_DSCD_NM    "TRIM(:NFFC_UNN_DSCD_NM)"    -- �߾�ȸ���ձ����ڵ��
,   CRD_PRD_DSCD_NM     "TRIM(:CRD_PRD_DSCD_NM )"    -- ī���ǰ�����ڵ��
,   SCTN_FVL                                         -- �������ڰ�
)

tel  char(4) nullif  tel=blanks,

iss_time   DATE "YYYY/MM/DD HH:MI:SS",

sql Loader ����  ���� ���۸�

OPTIONS(SKIP=2)
LOAD DATA
TRUNCATE
INTO TABLE TEMP_OPE_KRI_������ȣ��01
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
INTO TABLE TEMP_OPE_KRI_����������01
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
