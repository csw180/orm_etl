DECLARE
        P_BASEYM    VARCHAR2(6);   -- 기준년월
        P_SQL       VARCHAR2(4000);  -- 추출쿼리
        P_KRI_ID    VARCHAR2(20);  -- KRI아이디
        P_LD_CN     NUMBER;  -- INSERT건수
        P_GRPNM     VARCHAR2(20); --수협은행
        P_WKR_ENO   VARCHAR2(10); --SYSTEM
        P_BASEDAY   VARCHAR2(8); -- 기준일자
        P_EOTM_DT   VARCHAR2(8); -- 당월 말일자
        P_SOTM_DT   VARCHAR2(8);
        P_PSNZ_YN	VARCHAR2(1); --개인화 여부
        v_query     VARCHAR2(4000);
BEGIN
  --기준일자 체크  
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
  FROM   DWZOWN.OM_DWA_DT_BC
  WHERE   STD_DT = '&2';

  --실행할 KRI_ID 체크	
  
  SELECT '&3' 
  	INTO P_KRI_ID
  FROM DUAL;
  
  DBMS_OUTPUT.PUT_LINE('KRI ID : '||P_KRI_ID);

  
  P_GRPNM := '수협은행';
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
v_query := v_query ||   '   NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  =:P_GRPNM),01) GRP_ORG_C --그룹기관코드'||CHR(10);
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
v_query := v_query ||       ',OPEOWN.TB_OR_KH_BRC B'||CHR(10);
v_query := v_query ||   ' WHERE B.OPRK_RKI_ID = TRIM('''||P_KRI_ID||''')'||CHR(10);

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
END
COMMIT
;
/
EXIT
