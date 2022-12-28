/*
        프로그램명 : ins_KRI평가데이터 생성
        타켓테이블 : TB_OR_KH_NVL
        최조작성자 : 박승윤
*/
DECLARE
        P_DTDATE  VARCHAR2(8);  -- 기준일자
        P_RUNDATE VARCHAR2(8);  -- 실행일자(TB_OR_OM_SCHD 실행일자)
        P_BASYM   VARCHAR2(6);  -- 기준년월
        P_BASECNT  NUMBER;  -- 실행기준건수
        P_LD_CN    NUMBER;  -- 로딩건수
        P_DUMMY	   VARCHAR2(8);

BEGIN
  SELECT  NXT_DT
  INTO    P_DTDATE
  FROM    OPEOWN.TB_OPE_DT_BC
  ;
  
  
  SELECT NVL(A.RKI_ST_DT,B.DUMMY) RKI_ST_DT
        ,'&2'
        ,B.DUMMY
    INTO P_RUNDATE
        ,P_BASYM
        ,P_DUMMY
    FROM 
  (SELECT A.RKI_ST_DT
         ,A.BAS_YM
         ,'99991231' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE RKI_EVL_TGT_YN = 'Y' 
     AND RKI_PRG_STSC = '01' --평가중에 다른업무 재작업시 날라가는 위험 방지
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE RKI_EVL_TGT_YN = 'Y' 
               )
  ) A
  ,(SELECT 99991231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;             
               
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :기준일 : '||P_DTDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :기준일 : '||P_RUNDATE);
        

          IF 1 = 1  THEN

                DBMS_OUTPUT.PUT_LINE('기준일 일치 평가데이터(수기지표) 생성을 시작합니다.');

               

                
                DELETE FROM OPEOWN.TB_OR_KH_NVL A
                      WHERE A.BAS_YM = P_BASYM
                        AND A.OPRK_RKI_ID  IN (SELECT OPRK_RKI_ID FROM OPEOWN.TB_OR_KM_RKI WHERE COM_COL_PSB_YN = 'N' AND VLD_YN = 'Y') ;
                      
                DELETE FROM OPEOWN.TB_OR_KH_NVL_DCZ A
                      WHERE A.BAS_YM = P_BASYM
                        AND A.OPRK_RKI_ID  IN (SELECT OPRK_RKI_ID FROM OPEOWN.TB_OR_KM_RKI WHERE COM_COL_PSB_YN = 'N' AND VLD_YN = 'Y') ;
                       
      INSERT INTO OPEOWN.TB_OR_KH_NVL
      (
			SELECT 
			 A.GRP_ORG_C
			,P_BASYM
			,A.OPRK_RKI_ID
			,B.BRC
			,''
			,'SYSTEM'
			,TO_CHAR(SYSDATE,'YYYYMMDD')
			,0
			,SYSDATE
			,'SYSTEM'
			,SYSDATE
			,'SYSTEM'
			FROM
			 OPEOWN.TB_OR_KM_RKI A
			,OPEOWN.TB_OR_KH_BRC B
			,OPEOWN.TB_OR_OM_ORGZ C
			,OPEOWN.TB_OR_OM_FQ D
			WHERE A.OPRK_RKI_ID = B.OPRK_RKI_ID
			  AND C.HOFC_BIZO_DSC = '02'
			  AND B.BRC = C.BRC
			  AND A.RPT_FQ_DSC = D.RPT_FQ_DSC
			  AND SUBSTR(P_BASYM,5,2) = D.AMN_MM
			  AND A.COM_COL_PSB_YN = 'N'
			  AND A.VLD_YN = 'Y'
			  AND A.KRI_YN = 'Y'
			UNION
			SELECT 
			 A.GRP_ORG_C
			,P_BASYM
			,A.OPRK_RKI_ID
			,E.BRC
			,''
			,'SYSTEM'
			,TO_CHAR(SYSDATE,'YYYYMMDD')
			,0
			,SYSDATE
			,'SYSTEM'
			,SYSDATE
			,'SYSTEM'
			FROM
			 OPEOWN.TB_OR_KM_RKI A
			,OPEOWN.TB_OR_KH_BRC B
			,OPEOWN.TB_OR_OM_ORGZ C
			,OPEOWN.TB_OR_OM_FQ D
			,(SELECT BRC FROM OPEOWN.TB_OR_OM_ORGZ WHERE HOFC_BIZO_DSC = '03' AND UYN='Y' ) E
			WHERE A.OPRK_RKI_ID = B.OPRK_RKI_ID
			  AND C.HOFC_BIZO_DSC = '13'
			  AND B.BRC = C.BRC
			  AND A.RPT_FQ_DSC = D.RPT_FQ_DSC
			  AND SUBSTR(P_BASYM,5,2) = D.AMN_MM
			  AND A.COM_COL_PSB_YN = 'N'
			  AND A.VLD_YN = 'Y'
			  AND A.KRI_YN = 'Y'
      );
      
      INSERT INTO OPEOWN.TB_OR_KH_NVL_DCZ
      (
         SELECT 
      	 '01' GRP_ORG_C
      	 ,P_BASYM
      	 ,A.OPRK_RKI_ID
      	 ,C.BRC
      	 ,'0'
         ,'SYSTEM'
         ,TO_CHAR(SYSDATE,'YYYYMMDD')
         ,'01'
         ,''
         ,''
         ,''
         ,SYSDATE
         ,'SYSTEM'
         ,SYSDATE
         ,'SYSTEM'
         FROM 
           OPEOWN.TB_OR_KM_RKI A
          ,OPEOWN.TB_OR_OM_FQ B
          ,OPEOWN.TB_OR_KH_NVL C
        WHERE A.RPT_FQ_DSC = B.RPT_FQ_DSC
          AND SUBSTR(P_BASYM,5,2) = B.AMN_MM
          AND A.COM_COL_PSB_YN = 'N'
          AND A.VLD_YN = 'Y'
          AND A.KRI_YN = 'Y'
          AND A.OPRK_RKI_ID = C.OPRK_RKI_ID
          AND C.BAS_YM = P_BASYM
      );
                
                
       
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 평가데이터 생성');
                
                

                
                
                COMMIT;
                
          ELSE
                DBMS_OUTPUT.PUT_LINE('실행일자와 일치하지 않습니다.');

             --   RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT