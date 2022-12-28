DECLARE
        P_BASEYM    VARCHAR2(6);   -- ���س��
        P_SQL       VARCHAR2(4000);  -- ��������
        P_KRI_ID    VARCHAR2(20);  -- KRI���̵�
        P_LD_CN     NUMBER;  -- INSERT�Ǽ�
        P_GRPNM     VARCHAR2(20); --��������
        P_WKR_ENO   VARCHAR2(10); --SYSTEM
        P_BASEDAY   VARCHAR2(8); -- ��������
        P_EOTM_DT   VARCHAR2(8); -- ��� ������
        P_SOTM_DT   VARCHAR2(8);
        P_PSNZ_YN	VARCHAR2(1); --����ȭ ����
        P_PSNZ_CL	VARCHAR2(200); --����ȭ Į��
        P_PSNZ_BRC	VARCHAR2(200); --����ȭ ���� Į��
        P_TARGET_TB	VARCHAR2(200); --�������̺�
        v_query     VARCHAR2(4000);
        v_pz_query	VARCHAR2(4000); --����ȭ ����
BEGIN
  --�������� üũ  
  SELECT  STD_DT
         ,CASE WHEN STD_DT = EOTM_DT THEN EOTM_DT
               WHEN STD_DT < EOTM_DT THEN BEOM_DT 
          END
         ,SUBSTR(CASE WHEN STD_DT = EOTM_DT THEN EOTM_DT
                      WHEN STD_DT < EOTM_DT THEN BEOM_DT 
                 END,0,6)||'01'
         ,SUBSTR(CASE WHEN STD_DT = EOTM_DT THEN EOTM_DT
                      WHEN STD_DT < EOTM_DT THEN BEOM_DT 
                 END,0,6)
  INTO    P_BASEDAY
         ,P_EOTM_DT
         ,P_SOTM_DT
         ,P_BASEYM
  FROM    OPEOWN.TB_OPE_DT_BC
  WHERE   STD_DT_YN  = 'Y';
  --������ KRI_ID üũ	
  
  SELECT '&1' 
  	INTO P_KRI_ID
  FROM DUAL;
  
  DBMS_OUTPUT.PUT_LINE('KRI ID : '||P_KRI_ID);

  SELECT NVL(MAX(PSN_KRI_YN),'N') PSN_KRI_YN
    INTO P_PSNZ_YN
    FROM OPEOWN.TB_OR_KM_RKI 
   WHERE OPRK_RKI_ID = P_KRI_ID;
  
  DBMS_OUTPUT.PUT_LINE('����ȭ ����  : '||P_PSNZ_YN);
   
  SELECT NVL(MAX(CLMN_PHNM),'X') CLMN_PHNM 
     INTO P_PSNZ_CL
     FROM OPEOWN.TB_OR_KH_HDNG
	WHERE PSN_KEY_YN = 'Y'
  	  AND OPRK_RKI_ID = P_KRI_ID;
  	  
  DBMS_OUTPUT.PUT_LINE('����ȭ Į��  : '||P_PSNZ_CL);  

  SELECT NVL(MAX(CLMN_PHNM),'X') CLMN_PHNM 
     INTO P_PSNZ_BRC
     FROM OPEOWN.TB_OR_KH_HDNG
	WHERE AMN_ORGZ_YN = 'Y'
  	  AND OPRK_RKI_ID = P_KRI_ID;
  	  
  DBMS_OUTPUT.PUT_LINE('����ȭ BRC Į��  : '||P_PSNZ_BRC);  

  
  SELECT TRIM(MAX(REL_TBLNM)) REL_TBLNM
    INTO P_TARGET_TB
    FROM OPEOWN.TB_OR_KH_INF
   WHERE OPRK_RKI_ID = TRIM(P_KRI_ID);
  	  
  DBMS_OUTPUT.PUT_LINE('���� ���̺�  : '||P_TARGET_TB);  
  
  P_GRPNM := '��������';
  P_WKR_ENO := 'SYSTEM';
  
  SELECT REPLACE(TRIM(MAX(TBL_EXPL)),'P_BASEYM',P_BASEYM) TBL_EXPL
    INTO P_SQL
    FROM OPEOWN.TB_OR_KH_INF
   WHERE OPRK_RKI_ID = TRIM(P_KRI_ID);
  
  DELETE FROM OPEOWN.TB_OR_KH_NVL 
        WHERE BAS_YM = P_BASEYM
          AND OPRK_RKI_ID = P_KRI_ID
          ;
          
          
v_query := v_query ||     'INSERT INTO OPEOWN.TB_OR_KH_NVL'||CHR(10);
v_query := v_query ||   '('||CHR(10);
v_query := v_query ||   '    GRP_ORG_C'||CHR(10);
v_query := v_query ||   '   ,BAS_YM'||CHR(10);
v_query := v_query ||   '   ,OPRK_RKI_ID'||CHR(10);
v_query := v_query ||   '   ,BRC'||CHR(10);
v_query := v_query ||   '   ,KRI_NVL'||CHR(10);
v_query := v_query ||   '   ,INPMN_ENO'||CHR(10);
v_query := v_query ||   '   ,INPDT'||CHR(10);
v_query := v_query ||   '   ,DCZ_SQNO'||CHR(10);
v_query := v_query ||   '   ,FIR_INP_DTM'||CHR(10);
v_query := v_query ||   '   ,FIR_INPMN_ENO'||CHR(10);
v_query := v_query ||   '   ,LSCHG_DTM'||CHR(10);
v_query := v_query ||   '   ,LS_WKR_ENO'||CHR(10);
v_query := v_query ||   ')'||CHR(10);
v_query := v_query ||   'SELECT DISTINCT'||CHR(10);
v_query := v_query ||   '   NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  =:P_GRPNM),01) GRP_ORG_C --�׷����ڵ�'||CHR(10);
v_query := v_query ||   ' ,:P_BASEYM BAS_YM'||CHR(10);
v_query := v_query ||   ' ,:P_KRI_ID OPRK_RKI_ID'||CHR(10);
v_query := v_query ||   ' ,B.BRC'||CHR(10);
v_query := v_query ||   ' ,NVL(A.KRI_NVL,''0'') KRI_NVL'||CHR(10);
v_query := v_query ||   ' ,:P_WKR_ENO INPMN_ENO'||CHR(10);
v_query := v_query ||   ' ,TO_CHAR(SYSDATE,''YYYYMMDD'') INPDT'||CHR(10);
v_query := v_query ||   ' ,0 DCZ_SQNO'||CHR(10);
v_query := v_query ||   ' ,SYSDATE'||CHR(10);
v_query := v_query ||   ' ,:P_WKR_ENO'||CHR(10);
v_query := v_query ||   ' ,SYSDATE'||CHR(10);
v_query := v_query ||   ' ,:P_WKR_ENO'||CHR(10);
v_query := v_query ||   ' FROM ';
v_query := v_query ||       '( '||P_SQL||CHR(10);
v_query := v_query ||       ' ) A';
v_query := v_query ||       ',OPEOWN.TB_OR_OM_ORGZ B'||CHR(10);
v_query := v_query ||   ' WHERE A.BRC (+) = B.BRC'||CHR(10);
v_query := v_query ||     'AND B.HOFC_BIZO_DSC = ''03'''||CHR(10);
v_query := v_query ||     'AND B.UYN = ''Y'''||CHR(10);  

BEGIN EXECUTE IMMEDIATE v_query
  	  USING P_GRPNM,P_BASEYM,P_KRI_ID,P_WKR_ENO,P_WKR_ENO,P_WKR_ENO
  	  ;
  END;


  DELETE FROM OPEOWN.TB_OR_KH_NVL_DCZ 
        WHERE BAS_YM = P_BASEYM
          AND OPRK_RKI_ID = P_KRI_ID
          ;

INSERT INTO OPEOWN.TB_OR_KH_NVL_DCZ
(GRP_ORG_C
,BAS_YM
,OPRK_RKI_ID
,BRC
,DCZ_SQNO
,DCZMN_ENO
,DCZ_DT
,RKI_DCZ_STSC
,RTN_CNTN
,DCZ_OBJR_ENO
,DCZ_RMK_C
,FIR_INP_DTM
,FIR_INPMN_ENO
,LSCHG_DTM
,LS_WKR_ENO
)
SELECT 
 GRP_ORG_C
,BAS_YM
,OPRK_RKI_ID
,BRC
,DCZ_SQNO
,INPMN_ENO
,INPDT
,'13' RKI_DCZ_STSC
,'' RTN_CNTN
,'' DCZ_OBJR_ENO
,'' DCZ_RMK_C
,FIR_INP_DTM
,FIR_INPMN_ENO
,LSCHG_DTM
,LS_WKR_ENO
FROM OPEOWN.TB_OR_KH_NVL
WHERE BAS_YM = P_BASEYM
  AND OPRK_RKI_ID = P_KRI_ID
;

IF P_PSNZ_YN = 'Y' AND P_PSNZ_CL <> 'X'  THEN
  DBMS_OUTPUT.PUT_LINE('����ȭ ��� KRI');
  DELETE FROM OPEOWN.TB_OR_KH_NVL_PSNZ 
        WHERE BAS_YM = P_BASEYM AND OPRK_RKI_ID = P_KRI_ID
  ;
  

 	v_pz_query := v_pz_query ||     'INSERT INTO OPEOWN.TB_OR_KH_NVL_PSNZ'||CHR(10);
	v_pz_query := v_pz_query ||   '('||CHR(10);
	v_pz_query := v_pz_query ||   'SELECT DISTINCT'||CHR(10);
	v_pz_query := v_pz_query ||   '   NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  =:P_GRPNM),01) GRP_ORG_C --�׷����ڵ�'||CHR(10);
	v_pz_query := v_pz_query ||   ' ,:P_BASEYM BAS_YM'||CHR(10);
	v_pz_query := v_pz_query ||   ' ,:P_KRI_ID OPRK_RKI_ID'||CHR(10);
	v_pz_query := v_pz_query ||   ' ,NVL(TRIM('||P_PSNZ_BRC||'),''SYSTEM'')'||CHR(10);
	v_pz_query := v_pz_query ||   ' ,NVL(TRIM('||P_PSNZ_CL||'),''SYSTEM'')'||CHR(10);
	v_pz_query := v_pz_query ||   ' ,COUNT(*) KRI_NVL'||CHR(10);
	v_pz_query := v_pz_query ||   ' ,SYSDATE'||CHR(10);
	v_pz_query := v_pz_query ||   ' ,:P_WKR_ENO'||CHR(10);
	v_pz_query := v_pz_query ||   ' ,SYSDATE'||CHR(10);
	v_pz_query := v_pz_query ||   ' ,:P_WKR_ENO'||CHR(10);
	v_pz_query := v_pz_query ||   ' FROM OPEOWN.'||P_TARGET_TB||CHR(10);
	v_pz_query := v_pz_query ||   ' WHERE SUBSTR(TRIM(STD_DT),0,6) = :P_BASEYM'||CHR(10);
	v_pz_query := v_pz_query ||   '   AND '||P_PSNZ_CL||' IS NOT NULL'||CHR(10);
	v_pz_query := v_pz_query ||     'GROUP BY '||P_PSNZ_CL||','||P_PSNZ_BRC||CHR(10);
	v_pz_query := v_pz_query ||   ')'||CHR(10);
	
	BEGIN EXECUTE IMMEDIATE v_pz_query
	  	  USING P_GRPNM,P_BASEYM,P_KRI_ID,P_WKR_ENO,P_WKR_ENO,P_BASEYM
	  	  ;
	  END;
  
  

END IF;     


END
COMMIT
;
/
EXIT
