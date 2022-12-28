/*
        프로그램명 : ins_KRI마감재작업
        타켓테이블 :  TB_OR_KS_BR_SMST
               TB_OR_KS_RKI_BR_SMST
               TB_OR_KS_RKI_SMST             
        최조작성자 : 박승윤
*/
DECLARE
        P_DTDATE        VARCHAR2(8);  -- 기준일자
        P_RUNDATE       VARCHAR2(8);  -- 실행일자
        P_ST_DATE       VARCHAR2(8);  -- 평가시작일자
        P_BASYM         VARCHAR2(6);  -- 기준년월
        P_BF_BASYM      VARCHAR2(6);  -- 기준년월전월
        P_BF_BF_BASYM  VARCHAR2(6);  -- 기준년월전전월
        P_FW_BASYM      VARCHAR2(6);  -- 기준년월다음월
        P_DUMMY	        VARCHAR2(8);
        P_SOCO_KRI		VARCHAR2(20); -- 사회공헌 투자금액 합계 KRI ID
        P_LD_CN         NUMBER;  -- 로딩건수

BEGIN
  SELECT  NXT_DT
  INTO    P_DTDATE
  FROM    OPEOWN.TB_OPE_DT_BC
  ;
  
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :기준일 : '||P_DTDATE);
 
  --사회공헌 투자 KRI ID
  SELECT  'H-KRI-128' 
  INTO    P_SOCO_KRI
  FROM DUAL
  ;
  
  SELECT NVL(A.RKI_ED_DT,B.DUMMY) RKI_ED_DT
        ,'&2'
        ,B.DUMMY
        ,NVL(A.RKI_ST_DT,B.DUMMY) RKI_ST_DT
    INTO P_RUNDATE
        ,P_BASYM
        ,P_DUMMY
        ,P_ST_DATE
    FROM 
  (SELECT A.RKI_ED_DT
         ,A.RKI_ST_DT
         ,A.BAS_YM
        ,'10001231' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE RKI_EVL_TGT_YN = 'Y' 
     AND RKI_PRG_STSC = '02' --평가 중인 BAS_YM 필요
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE RKI_EVL_TGT_YN = 'Y' 
               )
  ) A
  ,(SELECT 10001231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;
   
  DBMS_OUTPUT.PUT_LINE('P_BASYM :기준년월 : '||P_BASYM); 
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :기준일 : '||P_RUNDATE);
  
  
  SELECT NVL(A.BAS_YM,B.DUMMY) BF_BAS_YM
    INTO P_BF_BASYM
    FROM 
  (SELECT MAX(A.BAS_YM) BAS_YM
        ,'000000' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE RKI_EVL_TGT_YN = 'Y' 
     AND BAS_YM < P_BASYM
  ) A
  ,(SELECT 000000 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;
  
  DBMS_OUTPUT.PUT_LINE('P_BF_BASYM :기준년월전월: '||P_BF_BASYM); 
  
   SELECT NVL(A.BAS_YM,B.DUMMY) BF_BAS_YM
    INTO P_BF_BF_BASYM
    FROM 
  (SELECT MAX(A.BAS_YM) BAS_YM
        ,'000000' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE RKI_EVL_TGT_YN = 'Y' 
     AND BAS_YM < P_BF_BASYM
  ) A
  ,(SELECT 000000 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;
  
  DBMS_OUTPUT.PUT_LINE('P_BF_BF_BASYM :기준년월전전월: '||P_BF_BF_BASYM); 
  
  
  
   
   --최종 마감일자 
   IF 1 = 1 AND 1 =1  THEN
				
   				
   				
   				DELETE FROM OPEOWN.TB_OR_KH_NVL A
				  WHERE A.BAS_YM = P_BASYM
				    AND A.OPRK_RKI_ID = P_SOCO_KRI
				  ;
				
				 DELETE FROM OPEOWN.TB_OR_KH_NVL_DCZ A
				  WHERE A.BAS_YM = P_BASYM
				    AND A.OPRK_RKI_ID = P_SOCO_KRI
				  ;
				  
				INSERT INTO OPEOWN.TB_OR_KH_NVL 
				(
				SELECT 
				   A.GRP_ORG_C
				  ,A.BAS_YM
				  ,C.OPRK_RKI_ID
				  ,(SELECT MAX(BRC) FROM OPEOWN.TB_OR_KH_BRC WHERE OPRK_RKI_ID = P_SOCO_KRI) BRC
				  ,NVL(SUM(A.KRI_NVL),'0') KRI_NVL
				  ,'SYSTEM' INPMN_ENO
				  ,TO_CHAR(SYSDATE,'YYYYMMDD') INPDT
				  ,'0' DCZ_SQNO
				  ,SYSDATE
				  ,'SYSTEM'
				  ,SYSDATE
				  ,'SYSTEM'
				 FROM OPEOWN.TB_OR_KH_NVL A
				     ,OPEOWN.TB_OR_KH_NVL_DCZ B
				     ,OPEOWN.TB_OR_KH_BRC C
				 WHERE A.OPRK_RKI_ID = B.OPRK_RKI_ID
				   AND A.BAS_YM = B.BAS_YM
				   AND A.BRC = B.BRC
				   AND A.DCZ_SQNO = B.DCZ_SQNO
				   AND C.OPRK_RKI_ID = P_SOCO_KRI
				   AND A.BAS_YM = P_BASYM
				   AND A.OPRK_RKI_ID IN ('H-KRI-127','H-KRI-160','H-KRI-161','H-KRI-162','H-KRI-163','H-KRI-164')
				 GROUP BY A.GRP_ORG_C , A.BAS_YM , C.OPRK_RKI_ID
				)
				;
				
				INSERT INTO OPEOWN.TB_OR_KH_NVL_DCZ
				      (
				         SELECT 
				      	 '01' GRP_ORG_C
				      	 ,C.BAS_YM
				      	 ,C.OPRK_RKI_ID
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
				           OPEOWN.TB_OR_KH_NVL C
				        WHERE C.OPRK_RKI_ID = P_SOCO_KRI
				          AND C.BAS_YM = P_BASYM
				      );
   
				P_LD_CN := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '사회공헌투자 집계 완료');    				      
				COMMIT;      
   				
			      
                DBMS_OUTPUT.PUT_LINE('기준일 일치 KRI마감 데이터 생성을 시작합니다.');
                
                --집계 테이블 초기화
                DELETE FROM OPEOWN.TB_OR_KS_RKI_BR_SMST
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_KS_RKI_SMST
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_KS_BR_SMST
                      WHERE BAS_YM = P_BASYM
                      ;
                
               
                --사무소별,지표별 집계
                INSERT INTO OPEOWN.TB_OR_KS_RKI_BR_SMST   	                              
                 (                                                                     
                    GRP_ORG_C       ,    /* 그룹기관코드 */          
                    OPRK_RKI_ID     ,    /* 리스크지표ID */         
                    BRC             ,    /* 사무소코드 */           
                    BAS_YM          ,    /* 기준년월 */            
                    OPRK_RKINM      ,    /* 운영리스크리스크지표명  */    
                    BRNM			,    /* 사무소명  */           
                    RKI_ATTR_C      ,    /* 리스크지표속성코드 */         
                    KRI_NVL         ,    /* 핵심리스크지표수치  */        
                    KRI_GRDNM       ,    /* 핵심리스크지표등급명  	   */ 
                    KRI_LMT_DSC     ,    /* 핵심리스크지표한도구분코드  */  
                    AFLCO_ORGZ_CN   ,    /* 계열사조직수             */
                    AFLCO_TT_VAL    ,    /* 계열사합계값       	  */
                    RKI_UNT_C       ,    /* 리스크지표단위코드     */   
                    KRI_UNTNM       ,    /* 핵심리스크지표단위명   */    
                    GU_DRTN_RER_DSC ,    /* 순방향역방향구분코드   */    
                    ACT_PLN_GRDC    ,    /* 조치계획등급코드        */ 
                    SC1_LMT_VAL     ,    /* 1차 한도 값		   */ 
                    SQ2_LMT_VAL     ,    /* 2차 한도 값		   */ 
                    FIR_INP_DTM     ,    /* 최초입력일시 */          
                    FIR_INPMN_ENO   ,    /* 최초입력자개인번호 */       
                    LSCHG_DTM       ,    /* 최종변경일시 */          
                    LS_WKR_ENO           /* 최종작업자개인번호 */                                                      
                 )                                                                     
				SELECT                                                                 
                    A.GRP_ORG_C         ,                                                 
                    A.OPRK_RKI_ID       ,                                                 
                    D.BRC       BRC		,                                                 
                    P_BASYM 	BAS_YM  ,                    		                              
                    A.OPRK_RKINM		,                                                 
                    G.BRNM				,                                                 
                    A.RKI_ATTR_C		,                                                 
                    E.KRI_NVL			,                                                 
                    (                                                                     
                      CASE WHEN  A.KRI_LMT_DSC ='04'                                    
                             THEN 'WHITE'                                                 
                             ELSE
                      CASE WHEN A.GU_DRTN_RER_DSC ='1' THEN
		                      CASE WHEN NVL(E.KRI_NVL,0) > C.SQ2_LMT_VAL                 
		                                    THEN 'RED'                                            
		                                    ELSE                                                  
		                                    CASE WHEN NVL(E.KRI_NVL,0) > C.SC1_LMT_VAL           	
		                                         THEN 'YELLOW'                                    
		                                         ELSE 'GREEN'                                     
		                                    END                                                   
		                               END
		              ELSE CASE WHEN NVL(E.KRI_NVL,0) < C.SQ2_LMT_VAL
		                                    THEN 'RED'
		                                    ELSE
		                                    CASE WHEN NVL(E.KRI_NVL,0) < C.SC1_LMT_VAL
		                                         THEN 'YELLOW'
		                                         ELSE 'GREEN'
		                                     END
		                               END
		                    END
                      END             
                    ) KRI_GRDNM			,  
                    A.KRI_LMT_DSC		,        
                    ''  AFLCO_ORGZ_CN ,                
                    ''  AFLCO_TT_VAL ,                           
                    A.RKI_UNT_C			,                      
                    H.INTG_IDVD_CNM     ,                      
                    A.GU_DRTN_RER_DSC	,                      
                    ''          		,                  
                    C.SC1_LMT_VAL		,                      
                    C.SQ2_LMT_VAL		,                      
                    SYSDATE FIR_INP_DTM     ,                  
                    'SYSTEM' FIR_INPMN_ENO  ,                  
                    SYSDATE LSCHG_DTM       ,                  
                    'SYSTEM' LS_WKR_ENO                        
                FROM OPEOWN.TB_OR_KN_RKIMM	  A                
                   , OPEOWN.TB_OR_KH_RKISLT  B                  
                   , OPEOWN.TB_OR_KH_LMT	  C                    
                   , OPEOWN.TB_OR_KH_BRC     D                  
                   , OPEOWN.TB_OR_KH_NVL     E                  
                   , OPEOWN.TB_OR_KH_NVL_DCZ F                  
                   , OPEOWN.TB_OR_OM_ORGZ    G                  
                   , OPEOWN.TB_OR_OM_CODE    H                  
                WHERE A.GRP_ORG_C = '01'
			 AND A.GRP_ORG_C = B.GRP_ORG_C            	
	         AND A.OPRK_RKI_ID = B.OPRK_RKI_ID  
			 AND A.GRP_ORG_C = C.GRP_ORG_C          	
			 AND A.OPRK_RKI_ID = C.OPRK_RKI_ID      	
			 AND A.GRP_ORG_C = D.GRP_ORG_C          	
			 AND A.OPRK_RKI_ID = D.OPRK_RKI_ID       	
			 AND A.GRP_ORG_C = E.GRP_ORG_C           	
			 AND A.OPRK_RKI_ID = E.OPRK_RKI_ID      
			 AND A.GRP_ORG_C = E.GRP_ORG_C          
			 AND A.OPRK_RKI_ID = E.OPRK_RKI_ID      
			 AND A.GRP_ORG_C = F.GRP_ORG_C          
			 AND A.OPRK_RKI_ID = F.OPRK_RKI_ID      
			 AND A.GRP_ORG_C = G.GRP_ORG_C          
			 AND A.GRP_ORG_C = H.GRP_ORG_C(+)       
			 AND A.RKI_UNT_C = H.IDVDC_VAL(+)       
			 AND H.INTG_GRP_C = 'RKI_UNT_C'		    
			 AND B.BAS_YM = P_BASYM			      		
			 AND B.BAS_YM = C.BAS_YM    
             AND A.BAS_YM = B.BAS_YM
			 AND B.OPRK_RKI_ID = C.OPRK_RKI_ID      
			 AND B.OPRK_RKI_ID = D.OPRK_RKI_ID      
			 AND B.BAS_YM = E.BAS_YM                
			 AND B.OPRK_RKI_ID = E.OPRK_RKI_ID      
			 AND B.BAS_YM = F.BAS_YM                
			 AND B.OPRK_RKI_ID = F.OPRK_RKI_ID      
			 AND C.OPRK_RKI_ID = D.OPRK_RKI_ID      
			 AND C.BRC = D.BRC                      
			 AND C.GRP_ORG_C = E.GRP_ORG_C       
			 AND C.OPRK_RKI_ID = E.OPRK_RKI_ID   
			 AND C.BRC = E.BRC                   
			 AND C.BAS_YM = E.BAS_YM             
			 AND C.GRP_ORG_C = F.GRP_ORG_C       
			 AND C.OPRK_RKI_ID = F.OPRK_RKI_ID  	
			 AND C.BRC = F.BRC                   
			 AND C.BAS_YM = F.BAS_YM				
			 AND D.BRC = G.BRC			         
			 AND G.UYN = 'Y'                     
			 AND G.KRI_ORGZ_YN = 'Y'		 	 
			 AND E.GRP_ORG_C = F.GRP_ORG_C		 
			 AND E.OPRK_RKI_ID = F.OPRK_RKI_ID   
			 AND E.BRC = F.BRC                   
			 AND E.BAS_YM = F.BAS_YM             	
			 AND E.DCZ_SQNO = F.DCZ_SQNO  
			 AND A.KRI_YN = 'Y'
			 AND A.VLD_YN = 'Y'
			 AND B.KRI_EVL_TGT_YN = 'Y'
         UNION ALL
         SELECT                                                                 
                    A.GRP_ORG_C         ,                                                 
                    A.OPRK_RKI_ID       ,                                                 
                    G.BRC       BRC		,                                                 
                    P_BASYM 	BAS_YM  ,                    		                              
                    A.OPRK_RKINM		,                                                 
                    G.BRNM				,                                                 
                    A.RKI_ATTR_C		,                                                 
                    E.KRI_NVL			,                                                 
                    (                                                                     
                      CASE WHEN  A.KRI_LMT_DSC ='04'                                    
                             THEN 'WHITE'                                                 
                             ELSE
                      CASE WHEN A.GU_DRTN_RER_DSC ='1' THEN
		                      CASE WHEN NVL(E.KRI_NVL,0) > C.SQ2_LMT_VAL                 
		                                    THEN 'RED'                                            
		                                    ELSE                                                  
		                                    CASE WHEN NVL(E.KRI_NVL,0) > C.SC1_LMT_VAL           	
		                                         THEN 'YELLOW'                                    
		                                         ELSE 'GREEN'                                     
		                                    END                                                   
		                               END
		              ELSE CASE WHEN NVL(E.KRI_NVL,0) < C.SQ2_LMT_VAL
		                                    THEN 'RED'
		                                    ELSE
		                                    CASE WHEN NVL(E.KRI_NVL,0) < C.SC1_LMT_VAL
		                                         THEN 'YELLOW'
		                                         ELSE 'GREEN'
		                                     END
		                               END
		                    END
                      END            
                    ) KRI_GRDNM			,  
                    A.KRI_LMT_DSC		,        
                    ''  AFLCO_ORGZ_CN ,                
                    ''  AFLCO_TT_VAL ,                           
                    A.RKI_UNT_C			,                      
                    H.INTG_IDVD_CNM     ,                      
                    A.GU_DRTN_RER_DSC	,                      
                    ''          		,                  
                    C.SC1_LMT_VAL		,                      
                    C.SQ2_LMT_VAL		,                      
                    SYSDATE FIR_INP_DTM     ,                  
                    'SYSTEM' FIR_INPMN_ENO  ,                  
                    SYSDATE LSCHG_DTM       ,                  
                    'SYSTEM' LS_WKR_ENO                        
                FROM OPEOWN.TB_OR_KN_RKIMM	  A                
                   , OPEOWN.TB_OR_KH_RKISLT  B                  
                   , OPEOWN.TB_OR_KH_LMT	  C                    
                   , OPEOWN.TB_OR_KH_BRC     D                  
                   , OPEOWN.TB_OR_KH_NVL     E                  
                   , OPEOWN.TB_OR_KH_NVL_DCZ F                  
                   ,(SELECT GRP_ORG_C,BRC,BRNM FROM OPEOWN.TB_OR_OM_ORGZ WHERE HOFC_BIZO_DSC = '03' AND UYN ='Y') G             
                   , OPEOWN.TB_OR_OM_CODE    H                  
                WHERE A.GRP_ORG_C = '01'
			 AND A.GRP_ORG_C = B.GRP_ORG_C            	
	         AND A.OPRK_RKI_ID = B.OPRK_RKI_ID  
			 AND A.GRP_ORG_C = C.GRP_ORG_C          	
			 AND A.OPRK_RKI_ID = C.OPRK_RKI_ID      	
			 AND A.GRP_ORG_C = D.GRP_ORG_C          	
			 AND A.OPRK_RKI_ID = D.OPRK_RKI_ID       	
			 AND A.GRP_ORG_C = E.GRP_ORG_C           	
			 AND A.OPRK_RKI_ID = E.OPRK_RKI_ID      
			 AND A.GRP_ORG_C = E.GRP_ORG_C          
			 AND A.OPRK_RKI_ID = E.OPRK_RKI_ID      
			 AND A.GRP_ORG_C = F.GRP_ORG_C          
			 AND A.OPRK_RKI_ID = F.OPRK_RKI_ID      
			 AND A.GRP_ORG_C = G.GRP_ORG_C          
			 AND A.GRP_ORG_C = H.GRP_ORG_C(+)       
			 AND A.RKI_UNT_C = H.IDVDC_VAL(+)       
			 AND H.INTG_GRP_C = 'RKI_UNT_C'		    
			 AND B.BAS_YM = P_BASYM			      		
			 AND B.BAS_YM = C.BAS_YM    
             AND A.BAS_YM = B.BAS_YM
			 AND B.OPRK_RKI_ID = C.OPRK_RKI_ID      
			 AND B.OPRK_RKI_ID = D.OPRK_RKI_ID      
			 AND B.BAS_YM = E.BAS_YM                
			 AND B.OPRK_RKI_ID = E.OPRK_RKI_ID      
			 AND B.BAS_YM = F.BAS_YM                
			 AND B.OPRK_RKI_ID = F.OPRK_RKI_ID      
			 AND C.OPRK_RKI_ID = D.OPRK_RKI_ID      
			 AND C.BRC = G.BRC                      
			 AND C.GRP_ORG_C = E.GRP_ORG_C       
			 AND C.OPRK_RKI_ID = E.OPRK_RKI_ID   
			 AND C.BRC = E.BRC                   
			 AND C.BAS_YM = E.BAS_YM             
			 AND C.GRP_ORG_C = F.GRP_ORG_C       
			 AND C.OPRK_RKI_ID = F.OPRK_RKI_ID  	
			 AND C.BRC = F.BRC                   
			 AND C.BAS_YM = F.BAS_YM				
			 AND D.BRC = 'SHBR'		   	 	 
			 AND E.GRP_ORG_C = F.GRP_ORG_C		 
			 AND E.OPRK_RKI_ID = F.OPRK_RKI_ID   
			 AND E.BRC = F.BRC                   
			 AND E.BAS_YM = F.BAS_YM             	
			 AND E.DCZ_SQNO = F.DCZ_SQNO
			 AND A.KRI_YN = 'Y'
			 AND A.VLD_YN = 'Y'
			 AND B.KRI_EVL_TGT_YN = 'Y'
                ;
                
                P_LD_CN := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 TB_OR_KS_RKI_BR_SMST INSERT 완료');
                
                
                UPDATE  OPEOWN.TB_OR_KS_RKI_BR_SMST
                  SET KRI_GRDNM = 'GREEN'
                WHERE BAS_YM <= '202306'
                 ;

                
                
                DELETE FROM OPEOWN.TB_OR_KM_ACT
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_KH_ACT_DCZ
                      WHERE BAS_YM = P_BASYM
                       ;
                
               INSERT INTO OPEOWN.TB_OR_KM_ACT
               (
                       SELECT '01',P_BASYM,A.OPRK_RKI_ID,A.BRC,'','','','','','','',0,SYSDATE,'SYSTEM',SYSDATE,'SYSTEM'
                       FROM
                       (SELECT  
		                     A.OPRK_RKI_ID
		                    ,A.BRC
                     	 FROM    OPEOWN.TB_OR_KS_RKI_BR_SMST        A 
						 WHERE A.BAS_YM = P_BASYM
                           AND A.KRI_GRDNM ='RED'
                       ) A
                       ,(SELECT  
		                     A.OPRK_RKI_ID
		                    ,A.BRC
                     	 FROM    OPEOWN.TB_OR_KS_RKI_BR_SMST        A 
						 WHERE A.BAS_YM = P_BF_BASYM
                           AND A.KRI_GRDNM ='RED'
                       ) B
                      ,(SELECT  
		                     A.OPRK_RKI_ID
		                    ,A.BRC
                     	 FROM    OPEOWN.TB_OR_KS_RKI_BR_SMST        A 
						 WHERE A.BAS_YM = P_BF_BF_BASYM
                           AND A.KRI_GRDNM ='RED'
                       ) C
                       WHERE A.OPRK_RKI_ID = B.OPRK_RKI_ID
                         AND A.OPRK_RKI_ID = C.OPRK_RKI_ID
                         AND A.BRC = B.BRC
                         AND A.BRC = C.BRC
                  )
                ;
                
						INSERT INTO OPEOWN.TB_OR_KH_ACT_DCZ
						SELECT '01',BAS_YM,OPRK_RKI_ID,BRC,DCZ_SQNO,TO_CHAR(SYSDATE,'YYYYMMDD'),'','01','','','',SYSDATE,'SYSTEM',SYSDATE,'SYSTEM' 
						 FROM  OPEOWN.TB_OR_KM_ACT
						WHERE BAS_YM = P_BASYM            
						                ;   
                
                
                
                P_LD_CN := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 대응방안 생성 완료');
                
                
                MERGE INTO OPEOWN.TB_OR_KS_RKI_BR_SMST A
				 USING(
				 SELECT * FROM  OPEOWN.TB_OR_KM_ACT WHERE BAS_YM = P_BASYM
				        ) B
				 ON (A.BAS_YM = B.BAS_YM AND A.BRC = B.BRC AND A.OPRK_RKI_ID = B.OPRK_RKI_ID AND A.BAS_YM = P_BASYM)
				 WHEN MATCHED THEN 
				UPDATE SET CFT_PLAN_YN = 'Y'
				    ; 
				    
				P_LD_CN := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 대응방안 대상건 업데이트 완료');
                
                
                
                
              INSERT INTO OPEOWN.TB_OR_KS_RKI_SMST                                                       
                         (                                                                                 
                            GRP_ORG_C       ,            /* 그룹기관코드 */                                      
                            OPRK_RKI_ID     ,            /* 리스크지표ID */                                     
                            BAS_YM          ,            /* 기준년월 */                                        
                            OPRK_RKINM      ,            /* 운영리스크리스크지표       */                            
                            RKI_ATTR_C      ,            /* 리스크지표속성코드         */                           
                            KRI_GRDNM       ,            /* 핵심리스크지표등급         */                           
                            CFT_PLAN_YN		,            /* 대응방안여부 */                                      
                            KRI_LMT_DSC     ,            /* 핵심리스크지표한도         */                           
                            AFLCO_ORGZ_CN   ,            /* 계열사조직수        */                                 
                            AFLCO_TT_VAL    ,            /* 계열사합계값        */                                 
                            RKI_UNT_C       ,            /* 리스크지표단위코드         */                           
                            KRI_UNTNM       ,            /* 핵심리스크지표단위         */                           
                            GU_DRTN_RER_DSC ,            /* 순방향역방향구분코         */                           
                            ACT_PLN_GRDC    ,            /* 조치계획등급코드           */                          
                            SC1_LMT_VAL     ,            /* 1차 한도 값		 */                                
                            SQ2_LMT_VAL     ,            /* 2차 한도 값		 */                                
                            FIR_INP_DTM     ,            /* 최초입력일시 */                                      
                            FIR_INPMN_ENO   ,            /* 최초입력자개인번호         */                           
                            LSCHG_DTM       ,            /* 최종변경일시 */                                      
                            LS_WKR_ENO                   /* 최종작업자개인번호 */                                   
                         )                                                                                 
                    SELECT                                                                                 
                            A.GRP_ORG_C         ,                                                          
                            A.OPRK_RKI_ID       ,                                                          
                            A.BAS_YM 			,                                                          
                            MAX(A.OPRK_RKINM)	,                                                          
                            MAX(A.RKI_ATTR_C)	,                                                          
                            MAX(A.KRI_GRDNM)	,                                                          
                            'N' CFT_PLAN_YN		,                                                          
                            MAX(A.KRI_LMT_DSC)	,                                                          
                            COUNT(A.BRC)    	,                                                          
                            SUM(A.KRI_NVL)	 	,                                                          
                            MAX(A.RKI_UNT_C)	,                                                          
                            MAX(A.KRI_UNTNM)	    ,                                                      
                            MAX(A.GU_DRTN_RER_DSC)	,                                                      
                            MAX(A.ACT_PLN_GRDC)		,                                                      
                            MAX(A.SC1_LMT_VAL)		,                                                      
                            MAX(A.SQ2_LMT_VAL)		,                                                      
                            SYSDATE FIR_INP_DTM     ,                                                      
                            'SYSTEM' FIR_INPMN_ENO  ,                                                      
                            SYSDATE LSCHG_DTM       , 	                                                   
                            'SYSTEM' LS_WKR_ENO	                                                           
                        FROM OPEOWN.TB_OR_KS_RKI_BR_SMST A                                                     
                            ,OPEOWN.TB_OR_KN_RKIMM B                                                             
                       WHERE A.GRP_ORG_C = 01                                                               
                         AND A.BAS_YM = P_BASYM                                                                  
                         AND A.GRP_ORG_C = B.GRP_ORG_C  
                         AND A.BAS_YM = B.BAS_YM
                         AND A.OPRK_RKI_ID = B.OPRK_RKI_ID                                                          
            		 GROUP BY A.GRP_ORG_C , A.OPRK_RKI_ID , A.BAS_YM                                                
             ;
                
                P_LD_CN := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 TB_OR_KS_RKI_SMST INSERT 완료'); 
             
             MERGE INTO OPEOWN.TB_OR_KS_RKI_BR_SMST A	                
                  USING OPEOWN.TB_OR_KS_RKI_SMST B			                
                     ON (A.GRP_ORG_C = 01				                
                    AND A.GRP_ORG_C = B.GRP_ORG_C		                
                    AND A.BAS_YM = P_BASYM					                
                    AND A.BAS_YM = B.BAS_YM			                
                    AND A.OPRK_RKI_ID = B.OPRK_RKI_ID	                
                        ) WHEN MATCHED THEN						        
                    UPDATE SET A.AFLCO_ORGZ_CN = B.AFLCO_ORGZ_CN ,   
                               A.AFLCO_TT_VAL = B.AFLCO_TT_VAL		    
               ;
               
             INSERT INTO OPEOWN.TB_OR_KS_BR_SMST                                                                
                 (                                                                                             
                    GRP_ORG_C       ,      /* 그룹기관코드 */                                                        
                    BRC			    ,      /* 사무소코드 */                                                         
                    BAS_YM          ,      /* 기준년월 */                                                          
                    BRNM		    ,      /* 사무소명 */                                                          
                    UP_BRC		    ,      /* 상위사무소코드  */                                                      
                    LVL_NO	        ,      /* 레벨번호 */                                                          
                    WHT_CN		    ,      /* 해당없음건수 */                                                          
                    RED_CN		    ,      /* 적색건수 */                                                          
                    YLW_CN  	    ,      /* 황색건수 */                                                          
                    GREEN_CN	    ,      /* 녹색건수 */                                                          
                    CFT_PLAN_CN	    ,      /* 대응방안건수 */                                                        
                    FIR_INP_DTM     ,      /* 최초입력일시 */                                                        
                    FIR_INPMN_ENO   ,      /* 최초입력자개인번호 */                                                     
                    LSCHG_DTM       ,      /* 최종변경일시 */                                                        
                    LS_WKR_ENO             /* 최종작업자개인번호 */                                                     
                 ) 
               SELECT 
                  AA.GRP_ORG_C
                 ,AA.BRC 
                 ,AA.BAS_YM
                 ,AA.BRNM
                 ,AA.UP_BRC
                 ,AA.LVL_NO
                 ,NVL(SUM(AA.WHT_CN),0)    WHT_CN                   
                 ,NVL(SUM(AA.RED_CN),0)    RED_CN                   
                 ,NVL(SUM(AA.YLW_CN),0) YLW_CN                  
                 ,NVL(SUM(AA.GREEN_CN),0)  GREEN_CN
                 ,NVL(SUM(AA.CFT_PLAN_CN),0)  CFT_PLAN_CN	                                                                   
                 ,SYSDATE FIR_INP_DTM                                                                       
                 ,'SYSTEM' FIR_INPMN_ENO                                                                    
                 ,SYSDATE LSCHG_DTM                                                                         
                 ,'SYSTEM' LS_WKR_ENO 
               FROM
               (
               SELECT --기본 집계                                                                                   
                    A.GRP_ORG_C     ,                                                                          
                       A.BRC		   ,                                                                         
                       A.BAS_YM 	,                                                                         
                       A.BRNM		,                                                                        
                       B.UP_BRC		,                                                                             
                       B.LVL_NO		,                                                                             
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'WHITE' THEN 1 ELSE 0 END),0)    WHT_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'RED' THEN 1 ELSE 0 END),0)    RED_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'YELLOW' THEN 1 ELSE 0 END),0) YLW_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'GREEN' THEN 1 ELSE 0 END),0)  GREEN_CN  ,                 
                       NVL(SUM(CASE WHEN A.CFT_PLAN_YN = 'Y' THEN 1 ELSE 0 END),0)  CFT_PLAN_CN  , 		                                                                   
                       SYSDATE FIR_INP_DTM     ,                                                                  
                       'SYSTEM' FIR_INPMN_ENO  ,                                                                  
                       SYSDATE LSCHG_DTM       ,                                                                  
                       'SYSTEM' LS_WKR_ENO                                                                        
                  FROM OPEOWN.TB_OR_KS_RKI_BR_SMST A                                                               
                     , OPEOWN.TB_OR_OM_ORGZ B                                                                      
                 WHERE A.GRP_ORG_C = 01                                                                         
                   AND A.BAS_YM = P_BASYM                                                                            
                   AND A.GRP_ORG_C = B.GRP_ORG_C                                                               
                   AND A.BRC = B.BRC    
                 GROUP BY A.GRP_ORG_C , A.BRC , A.BAS_YM , A.BRNM , B.UP_BRC , B.LVL_NO
               UNION ALL 
               SELECT -- 영업점 총계
                  A.GRP_ORG_C
                 ,B.BRC 
                 ,A.BAS_YM
                 ,B.BRNM
                 ,B.UP_BRC
                 ,B.LVL_NO
                 ,NVL(SUM(A.WHT_CN),0)    WHT_CN                   
                 ,NVL(SUM(A.RED_CN),0)    RED_CN                   
                 ,NVL(SUM(A.YLW_CN),0) YLW_CN                  
                 ,NVL(SUM(A.GREEN_CN),0)  GREEN_CN 
                 ,NVL(SUM(A.CFT_PLAN_CN),0)  CFT_PLAN_CN 	                                                                   
                 ,SYSDATE FIR_INP_DTM                                                                       
                 ,'SYSTEM' FIR_INPMN_ENO                                                                    
                 ,SYSDATE LSCHG_DTM                                                                         
                 ,'SYSTEM' LS_WKR_ENO 
                FROM 
                (
                SELECT                                                                                         
                    A.GRP_ORG_C     ,                                                                          
                       A.BRC		   ,                                                                         
                       A.BAS_YM 	,                                                                         
                       A.BRNM		,                                                                        
                       B.UP_BRC		,                                                                             
                       B.LVL_NO		,                                                                             
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'WHITE' THEN 1 ELSE 0 END),0)    WHT_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'RED' THEN 1 ELSE 0 END),0)    RED_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'YELLOW' THEN 1 ELSE 0 END),0) YLW_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'GREEN' THEN 1 ELSE 0 END),0)  GREEN_CN  ,                 
                       NVL(SUM(CASE WHEN A.CFT_PLAN_YN = 'Y' THEN 1 ELSE 0 END),0)  CFT_PLAN_CN ,                                                                   
                       SYSDATE FIR_INP_DTM     ,                                                                  
                       'SYSTEM' FIR_INPMN_ENO  ,                                                                  
                       SYSDATE LSCHG_DTM       ,                                                                  
                       'SYSTEM' LS_WKR_ENO                                                                        
                  FROM OPEOWN.TB_OR_KS_RKI_BR_SMST A                                                               
                     , OPEOWN.TB_OR_OM_ORGZ B                                                                      
                 WHERE A.GRP_ORG_C = 01                                                                         
                   AND A.BAS_YM = P_BASYM                                                                            
                   AND A.GRP_ORG_C = B.GRP_ORG_C                                                               
                   AND A.BRC = B.BRC
                   AND B.HOFC_BIZO_DSC = '03'
                 GROUP BY A.GRP_ORG_C , A.BRC , A.BAS_YM , A.BRNM , B.UP_BRC , B.LVL_NO
                 ) A
                ,OPEOWN.TB_OR_OM_ORGZ B 
               WHERE A.UP_BRC = B.BRC
               GROUP BY A.GRP_ORG_C
                 ,B.BRC 
                 ,A.BAS_YM
                 ,B.BRNM
                 ,B.UP_BRC
                 ,B.LVL_NO
               UNION ALL
                SELECT -- 본부부서 팀별 합계
                  A.GRP_ORG_C
                 ,B.BRC 
                 ,A.BAS_YM
                 ,B.BRNM
                 ,B.UP_BRC
                 ,B.LVL_NO
                 ,NVL(SUM(A.WHT_CN),0)    WHT_CN                   
                 ,NVL(SUM(A.RED_CN),0)    RED_CN                   
                 ,NVL(SUM(A.YLW_CN),0) YLW_CN                  
                 ,NVL(SUM(A.GREEN_CN),0)  GREEN_CN
                 ,NVL(SUM(A.CFT_PLAN_CN),0)  CFT_PLAN_CN	                                                                   
                 ,SYSDATE FIR_INP_DTM                                                                       
                 ,'SYSTEM' FIR_INPMN_ENO                                                                    
                 ,SYSDATE LSCHG_DTM                                                                         
                 ,'SYSTEM' LS_WKR_ENO 
                FROM 
                (
                SELECT                                                                                         
                    A.GRP_ORG_C     ,                                                                          
                       A.BRC		   ,                                                                         
                       A.BAS_YM 	,                                                                         
                       A.BRNM		,                                                                        
                       B.UP_BRC		,                                                                             
                       B.LVL_NO		,                                                                             
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'WHITE' THEN 1 ELSE 0 END),0)    WHT_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'RED' THEN 1 ELSE 0 END),0)    RED_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'YELLOW' THEN 1 ELSE 0 END),0) YLW_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'GREEN' THEN 1 ELSE 0 END),0)  GREEN_CN  ,                 
                       NVL(SUM(CASE WHEN A.CFT_PLAN_YN = 'Y' THEN 1 ELSE 0 END),0)  CFT_PLAN_CN ,                                                                
                       SYSDATE FIR_INP_DTM     ,                                                                  
                       'SYSTEM' FIR_INPMN_ENO  ,                                                                  
                       SYSDATE LSCHG_DTM       ,                                                                  
                       'SYSTEM' LS_WKR_ENO                                                                        
                  FROM OPEOWN.TB_OR_KS_RKI_BR_SMST A                                                               
                     , OPEOWN.TB_OR_OM_ORGZ B                                                                      
                 WHERE A.GRP_ORG_C = 01                                                                         
                   AND A.BAS_YM = P_BASYM                                                                            
                   AND A.GRP_ORG_C = B.GRP_ORG_C                                                               
                   AND A.BRC = B.BRC
                   AND B.HOFC_BIZO_DSC = '02'
                   AND B.UP_BRC <> 'SHHQ'
                 GROUP BY A.GRP_ORG_C , A.BRC , A.BAS_YM , A.BRNM , B.UP_BRC , B.LVL_NO
                 ) A
                ,OPEOWN.TB_OR_OM_ORGZ B 
               WHERE A.UP_BRC = B.BRC
               GROUP BY A.GRP_ORG_C
                 ,B.BRC 
                 ,A.BAS_YM
                 ,B.BRNM
                 ,B.UP_BRC
                 ,B.LVL_NO
              UNION ALL
              SELECT -- 본부부서 총계
                  A.GRP_ORG_C
                 ,B.BRC 
                 ,A.BAS_YM
                 ,B.BRNM
                 ,B.UP_BRC
                 ,B.LVL_NO
                 ,NVL(SUM(A.WHT_CN),0)    WHT_CN                   
                 ,NVL(SUM(A.RED_CN),0)    RED_CN                   
                 ,NVL(SUM(A.YLW_CN),0) YLW_CN                  
                 ,NVL(SUM(A.GREEN_CN),0)  GREEN_CN
                 ,NVL(SUM(A.CFT_PLAN_CN),0)  CFT_PLAN_CN	                                                                   
                 ,SYSDATE FIR_INP_DTM                                                                       
                 ,'SYSTEM' FIR_INPMN_ENO                                                                    
                 ,SYSDATE LSCHG_DTM                                                                         
                 ,'SYSTEM' LS_WKR_ENO 
                FROM 
                (
                SELECT                                                                                         
                    A.GRP_ORG_C     ,                                                                          
                       A.BRC		   ,                                                                         
                       A.BAS_YM 	,                                                                         
                       A.BRNM		,                                                                        
                       B.UP_BRC		,                                                                             
                       B.LVL_NO		,                                                                             
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'WHITE' THEN 1 ELSE 0 END),0)    WHT_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'RED' THEN 1 ELSE 0 END),0)    RED_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'YELLOW' THEN 1 ELSE 0 END),0) YLW_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'GREEN' THEN 1 ELSE 0 END),0)  GREEN_CN  ,                 
                       NVL(SUM(CASE WHEN A.CFT_PLAN_YN = 'Y' THEN 1 ELSE 0 END),0)  CFT_PLAN_CN ,                                                                
                       SYSDATE FIR_INP_DTM     ,                                                                  
                       'SYSTEM' FIR_INPMN_ENO  ,                                                                  
                       SYSDATE LSCHG_DTM       ,                                                                  
                       'SYSTEM' LS_WKR_ENO                                                                        
                  FROM OPEOWN.TB_OR_KS_RKI_BR_SMST A                                                               
                     , OPEOWN.TB_OR_OM_ORGZ B                                                                      
                 WHERE A.GRP_ORG_C = 01                                                                         
                   AND A.BAS_YM = P_BASYM                                                                            
                   AND A.GRP_ORG_C = B.GRP_ORG_C                                                               
                   AND A.BRC = B.BRC
                   AND B.HOFC_BIZO_DSC = '02'
                 GROUP BY A.GRP_ORG_C , A.BRC , A.BAS_YM , A.BRNM , B.UP_BRC , B.LVL_NO
                 ) A
                ,OPEOWN.TB_OR_OM_ORGZ B
               WHERE B.BRC = 'SHHQ'
              GROUP BY A.GRP_ORG_C
                 ,B.BRC 
                 ,A.BAS_YM
                 ,B.BRNM
                 ,B.UP_BRC
                 ,B.LVL_NO
               UNION ALL
               SELECT -- 수협은행 총계
                  A.GRP_ORG_C
                 ,B.BRC 
                 ,A.BAS_YM
                 ,B.BRNM
                 ,B.UP_BRC
                 ,B.LVL_NO
                 ,NVL(SUM(A.WHT_CN),0)    WHT_CN                   
                 ,NVL(SUM(A.RED_CN),0)    RED_CN                   
                 ,NVL(SUM(A.YLW_CN),0) YLW_CN                  
                 ,NVL(SUM(A.GREEN_CN),0)  GREEN_CN
                 ,NVL(SUM(A.CFT_PLAN_CN),0)  CFT_PLAN_CN	                                                                   
                 ,SYSDATE FIR_INP_DTM                                                                       
                 ,'SYSTEM' FIR_INPMN_ENO                                                                    
                 ,SYSDATE LSCHG_DTM                                                                         
                 ,'SYSTEM' LS_WKR_ENO 
                FROM 
                (
                SELECT                                                                                         
                       A.GRP_ORG_C     ,                                                                          
                       A.BRC		   ,                                                                         
                       A.BAS_YM 	,                                                                         
                       A.BRNM		,                                                                        
                       B.UP_BRC		,                                                                             
                       B.LVL_NO		,                                                                             
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'WHITE' THEN 1 ELSE 0 END),0)    WHT_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'RED' THEN 1 ELSE 0 END),0)    RED_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'YELLOW' THEN 1 ELSE 0 END),0) YLW_CN    ,                 
                       NVL(SUM(CASE WHEN A.KRI_GRDNM = 'GREEN' THEN 1 ELSE 0 END),0)  GREEN_CN  ,                 
                       NVL(SUM(CASE WHEN A.CFT_PLAN_YN = 'Y' THEN 1 ELSE 0 END),0)  CFT_PLAN_CN ,                                                                
                       SYSDATE FIR_INP_DTM     ,                                                                  
                       'SYSTEM' FIR_INPMN_ENO  ,                                                                  
                       SYSDATE LSCHG_DTM       ,                                                                  
                       'SYSTEM' LS_WKR_ENO                                                                        
                  FROM OPEOWN.TB_OR_KS_RKI_BR_SMST A                                                               
                     , OPEOWN.TB_OR_OM_ORGZ B                                                                      
                 WHERE A.GRP_ORG_C = 01                                                                         
                   AND A.BAS_YM = P_BASYM                                                                            
                   AND A.GRP_ORG_C = B.GRP_ORG_C                                                               
                   AND A.BRC = B.BRC
                 GROUP BY A.GRP_ORG_C , A.BRC , A.BAS_YM , A.BRNM , B.UP_BRC , B.LVL_NO
                 ) A
               ,OPEOWN.TB_OR_OM_ORGZ B
               WHERE B.BRC = 'SHBK'
              GROUP BY A.GRP_ORG_C
                 ,B.BRC 
                 ,A.BAS_YM
                 ,B.BRNM
                 ,B.UP_BRC
                 ,B.LVL_NO
          ) AA
          GROUP BY AA.GRP_ORG_C
                 ,AA.BRC 
                 ,AA.BAS_YM
                 ,AA.BRNM
                 ,AA.UP_BRC
                 ,AA.LVL_NO
          ORDER BY LVL_NO ASC
               ;
             
         P_LD_CN := SQL%ROWCOUNT;
         DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 TB_OR_KS_BR_SMST INSERT 완료');
         INSERT INTO OPEOWN.TB_OR_KH_NVL_DCZ
			      (
			         SELECT 
			      	 '01' GRP_ORG_C
			      	 ,C.BAS_YM
			      	 ,C.OPRK_RKI_ID
			      	 ,C.BRC
			      	 ,MAX(C.DCZ_SQNO) +1
			         ,'SYSTEM'
			         ,TO_CHAR(SYSDATE,'YYYYMMDD')
			         ,'99'
			         ,''
			         ,''
			         ,''
			         ,SYSDATE
			         ,'SYSTEM'
			         ,SYSDATE
			         ,'SYSTEM'
			         FROM 
			           OPEOWN.TB_OR_KH_NVL C
			        WHERE C.BAS_YM = P_BASYM
			        GROUP BY C.BAS_YM,C.OPRK_RKI_ID,C.BRC
			      );
   				
			    P_LD_CN := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE(P_LD_CN ||'건 KRI 마감 완료');  
                
           		 MERGE INTO OPEOWN.TB_OR_KH_NVL A  
		         USING OPEOWN.TB_OR_KH_NVL_DCZ B 	 
		            ON (A.GRP_ORG_C = '01'			 
		           AND A.GRP_ORG_C = B.GRP_ORG_C 		 
		           AND A.BAS_YM = P_BASYM	     		 
		           AND A.BAS_YM = B.BAS_YM       		 
		           AND A.OPRK_RKI_ID = B.OPRK_RKI_ID   
		           AND A.BRC = B.BRC                   
		           AND B.RKI_DCZ_STSC = '99')     	 
		          WHEN MATCHED THEN				     
		        UPDATE SET A.DCZ_SQNO = B.DCZ_SQNO;      
   
   				P_LD_CN := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE(P_LD_CN ||'건 DCZ_SQNO 업데이트 완료'); 
  

    	
		   COMMIT;	
	
          ELSE 
                 DBMS_OUTPUT.PUT_LINE('실행일자와 일치하지 않습니다.');
                
                
                

             --   RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT