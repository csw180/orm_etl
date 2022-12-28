/*
        ���α׷��� : ins_KRI�ѵ������� ����
        Ÿ�����̺� : TB_OR_KH_LMT
        �����ۼ��� : �ڽ���
*/
DECLARE
        P_DTDATE   VARCHAR2(8);  -- ��������
        P_RUNDATE  VARCHAR2(8);  -- ��������(TB_OR_OM_SCHD ��������)
        P_BASYM    VARCHAR2(6);  -- ���س��
        P_DUMMY	   VARCHAR2(8);  
        P_BF_BASYM VARCHAR2(6);  -- ���س�� ����
        P_LD_CN    NUMBER;       -- �ε��Ǽ�

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
        ,'10001231' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE RKI_EVL_TGT_YN = 'Y' 
     AND RKI_PRG_STSC = '02' --�� ���� BAS_YM �ʿ�
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE RKI_EVL_TGT_YN = 'Y' 
               )
  ) A
  ,(SELECT 10001231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;
   
  DBMS_OUTPUT.PUT_LINE('P_BASYM :���س�� : '||P_BASYM); 
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :������ : '||P_RUNDATE);
  
  
  SELECT NVL(A.BAS_YM,B.DUMMY) P_BF_BASYM
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
  
   DBMS_OUTPUT.PUT_LINE('P_BF_BASYM :���س������: '||P_BF_BASYM); 
    
          IF 1 = 1  THEN

                DBMS_OUTPUT.PUT_LINE('�򰡽����ϰ� �������ڰ� ��ġ�մϴ�. KRI �ѵ��� ���� �մϴ�.');
                
                
               DELETE FROM OPEOWN.TB_OR_KH_LMT
                      WHERE BAS_YM = P_BASYM
                      ;
                
               INSERT INTO OPEOWN.TB_OR_KH_LMT
                (       
                SELECT   --���κμ�           
	            A.GRP_ORG_C	,    
                C.BRC BRC               ,  
                P_BASYM       	BAS_YM   , 
	            A.OPRK_RKI_ID           ,   
		        NVL(CASE A.KRI_LMT_DSC                    
	                WHEN '01' THEN DECODE(H.FIX_SC1_LMT_VAL,NULL,BMM_SC1_MAX_TRH,H.FIX_SC1_LMT_VAL)     
	                WHEN '02' THEN
	                      CASE WHEN A.GU_DRTN_RER_DSC = '1'
                              THEN D.AVG_KRI_NVL + DECODE(D.STDDEV_KRI_NVL,0,0.01,D.STDDEV_KRI_NVL) * 2                                                                                
                              ELSE D.AVG_KRI_NVL - DECODE(D.STDDEV_KRI_NVL,0,0.01,D.STDDEV_KRI_NVL) * 3
                           END
	                WHEN '03' THEN
	                     CASE WHEN A.GU_DRTN_RER_DSC = '1'
	                          THEN E.AVG_KRI_NVL + DECODE(E.STDDEV_KRI_NVL,0,0.01,E.STDDEV_KRI_NVL) * 2                                                                               
	                          ELSE E.AVG_KRI_NVL - DECODE(E.STDDEV_KRI_NVL,0,0.01,E.STDDEV_KRI_NVL) * 3
	                      END
	                ELSE NULL                                                                             
	            END,0) SC1_LMT_VAL  ,                                                                     
	            NVL(CASE A.KRI_LMT_DSC                    
	                WHEN '01' THEN DECODE(H.FIX_SQ2_LMT_VAL,NULL,BMM_SQ2_MAX_TRH,H.FIX_SQ2_LMT_VAL)      
	                WHEN '02' THEN
	                	 CASE WHEN A.GU_DRTN_RER_DSC = '1'
	                	      THEN D.AVG_KRI_NVL + DECODE(D.STDDEV_KRI_NVL,0,0.01,D.STDDEV_KRI_NVL) * 3                                                                                
	                	      ELSE D.AVG_KRI_NVL - DECODE(D.STDDEV_KRI_NVL,0,0.01,D.STDDEV_KRI_NVL) * 2
	                	  END
	                WHEN '03' THEN
	                     CASE WHEN A.GU_DRTN_RER_DSC = '1'
	                          THEN E.AVG_KRI_NVL + DECODE(E.STDDEV_KRI_NVL,0,0.01,E.STDDEV_KRI_NVL) * 3                                                                            
	                          ELSE E.AVG_KRI_NVL - DECODE(E.STDDEV_KRI_NVL,0,0.01,E.STDDEV_KRI_NVL) * 2  
	                      END    
	                ELSE NULL                                                                             
	            END,0) SQ2_LMT_VAL  ,                                                                     
				D.AVG_KRI_NVL 		RYR1_AVL         ,     
				D.STDDEV_KRI_NVL 	RYR1_SDVA        ,     
				D.MAX_KRI_NVL 		RYR1_MAX_VAL     ,     
				D.MIN_KRI_NVL 		RYR1_MIN_VAL     ,     
				E.AVG_KRI_NVL 		BFYY_AVL         ,     
				E.STDDEV_KRI_NVL 	BFYY_SDVA        ,     
				E.MAX_KRI_NVL 		BFYY_MAX_VAL     ,     
				E.MIN_KRI_NVL 		BFYY_MIN_VAL     ,     
				F.BMM_SC1_MAX_TRH	BMM_SC1_MAX_TRH  ,     
				F.BMM_SQ2_MAX_TRH	BMM_SQ2_MAX_TRH  , 
				H.LMT_CHG_CNTN  	LMT_CHG_CNTN	 ,
	            SYSDATE  			FIR_INP_DTM      ,     
	            'SYSTEM' 			FIR_INPMN_ENO  	 ,     
	            SYSDATE  			LSCHG_DTM        ,     
	            'SYSTEM' 			LS_WKR_ENO             
			  FROM OPEOWN.TB_OR_KM_RKI A                  
			     , OPEOWN.TB_OR_KH_RKISLT B               
	             , OPEOWN.TB_OR_KH_BRC C                  
				 , (SELECT                                 
						 A.GRP_ORG_C ,                     
						 A.BRC ,                           
						 A.OPRK_RKI_ID ,                   
						 MAX(A.KRI_NVL) MAX_KRI_NVL,       
						 MIN(A.KRI_NVL) MIN_KRI_NVL,       
						 STDDEV(A.KRI_NVL) STDDEV_KRI_NVL, 
						 AVG(A.KRI_NVL) AVG_KRI_NVL        
					FROM OPEOWN.TB_OR_KH_NVL A            
				   WHERE A.GRP_ORG_C = '01'        
	                 AND A.BAS_YM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-12),'YYYYMM')  
	                                  AND TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-1),'YYYYMM')   
				   GROUP BY A.GRP_ORG_C , A.BRC , A.OPRK_RKI_ID                                          
				   ) D 
				 , (SELECT                                 
						 A.GRP_ORG_C ,                     
						 A.BRC ,                           
						 A.OPRK_RKI_ID ,                   
						 MAX(A.KRI_NVL) MAX_KRI_NVL,       
						 MIN(A.KRI_NVL) MIN_KRI_NVL,       
						 STDDEV(A.KRI_NVL) STDDEV_KRI_NVL, 
						 AVG(A.KRI_NVL) AVG_KRI_NVL        
					FROM OPEOWN.TB_OR_KH_NVL A            
				   WHERE A.GRP_ORG_C = '01'        
				     AND A.BAS_YM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-12),'YYYY') || '01'  
					                  AND TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-12),'YYYY') || '12'  
				   GROUP BY A.GRP_ORG_C , A.BRC , A.OPRK_RKI_ID   
				   ) E                   
				 , (SELECT                                
				    	 A.GRP_ORG_C ,                    
				    	 A.BRC ,                          
				    	 A.OPRK_RKI_ID ,                  
				    	 A.SC1_LMT_VAL  BMM_SC1_MAX_TRH ,	
						 A.SQ2_LMT_VAL  BMM_SQ2_MAX_TRH  	
				    FROM OPEOWN.TB_OR_KH_LMT A           
				      WHERE A.GRP_ORG_C = '01'    
				        AND A.BAS_YM = P_BF_BASYM      
				   ) F
                 ,OPEOWN.TB_OR_OM_ORGZ G
                 ,OPEOWN.TB_OR_KM_FIX_LMT H
		    WHERE A.GRP_ORG_C = '01'        
			  AND A.GRP_ORG_C = B.GRP_ORG_C         
			  AND A.GRP_ORG_C = C.GRP_ORG_C         
			  AND A.GRP_ORG_C = D.GRP_ORG_C (+)     
			  AND A.GRP_ORG_C = E.GRP_ORG_C (+)     
			  AND A.GRP_ORG_C = F.GRP_ORG_C (+)     
			  AND A.OPRK_RKI_ID = B.OPRK_RKI_ID     
			  AND A.OPRK_RKI_ID = C.OPRK_RKI_ID     
			  AND A.OPRK_RKI_ID = D.OPRK_RKI_ID (+) 
			  AND A.OPRK_RKI_ID = E.OPRK_RKI_ID (+) 
			  AND A.OPRK_RKI_ID = F.OPRK_RKI_ID (+) 
			  AND B.OPRK_RKI_ID = C.OPRK_RKI_ID     
			  AND B.OPRK_RKI_ID = D.OPRK_RKI_ID (+) 
			  AND B.OPRK_RKI_ID = E.OPRK_RKI_ID (+) 
			  AND B.OPRK_RKI_ID = F.OPRK_RKI_ID (+) 
			  AND C.BRC = D.BRC (+)                 
			  AND C.BRC = E.BRC (+)                 
			  AND C.BRC = F.BRC (+)
              AND C.BRC = G.BRC  
              AND A.OPRK_RKI_ID = H.OPRK_RKI_ID (+)
              AND C.BRC = H.BRC (+)
              AND A.GRP_ORG_C = H.GRP_ORG_C (+)
              AND G.UYN = 'Y'
			  AND B.BAS_YM = P_BASYM
			  AND G.HOFC_BIZO_DSC= '02'
            UNION ALL
             SELECT   --������           
	            A.GRP_ORG_C	,    
                G.BRC BRC               ,  
                P_BASYM       BAS_YM   ,   
	            A.OPRK_RKI_ID           ,    
		         NVL(CASE A.KRI_LMT_DSC                    
	                WHEN '01' THEN DECODE(H.FIX_SC1_LMT_VAL,NULL,BMM_SC1_MAX_TRH,H.FIX_SC1_LMT_VAL)     
	                WHEN '02' THEN
	                      CASE WHEN A.GU_DRTN_RER_DSC = '1'
                              THEN D.AVG_KRI_NVL + DECODE(D.STDDEV_KRI_NVL,0,0.01,D.STDDEV_KRI_NVL) * 2                                                                                
                              ELSE D.AVG_KRI_NVL - DECODE(D.STDDEV_KRI_NVL,0,0.01,D.STDDEV_KRI_NVL) * 3
                           END
	                WHEN '03' THEN
	                     CASE WHEN A.GU_DRTN_RER_DSC = '1'
	                          THEN E.AVG_KRI_NVL + DECODE(E.STDDEV_KRI_NVL,0,0.01,E.STDDEV_KRI_NVL) * 2                                                                               
	                          ELSE E.AVG_KRI_NVL - DECODE(E.STDDEV_KRI_NVL,0,0.01,E.STDDEV_KRI_NVL) * 3
	                      END
	                ELSE NULL                                                                             
	            END,0) SC1_LMT_VAL  ,                                                                     
	            NVL(CASE A.KRI_LMT_DSC                    
	                WHEN '01' THEN DECODE(H.FIX_SQ2_LMT_VAL,NULL,BMM_SQ2_MAX_TRH,H.FIX_SQ2_LMT_VAL)      
	                WHEN '02' THEN
	                	 CASE WHEN A.GU_DRTN_RER_DSC = '1'
	                	      THEN D.AVG_KRI_NVL + DECODE(D.STDDEV_KRI_NVL,0,0.01,D.STDDEV_KRI_NVL) * 3                                                                                
	                	      ELSE D.AVG_KRI_NVL - DECODE(D.STDDEV_KRI_NVL,0,0.01,D.STDDEV_KRI_NVL) * 2
	                	  END
	                WHEN '03' THEN
	                     CASE WHEN A.GU_DRTN_RER_DSC = '1'
	                          THEN E.AVG_KRI_NVL + DECODE(E.STDDEV_KRI_NVL,0,0.01,E.STDDEV_KRI_NVL) * 3                                                                            
	                          ELSE E.AVG_KRI_NVL - DECODE(E.STDDEV_KRI_NVL,0,0.01,E.STDDEV_KRI_NVL) * 2  
	                      END    
	                ELSE NULL                                                                             
	            END,0) SQ2_LMT_VAL  ,                                                                     
				D.AVG_KRI_NVL 		RYR1_AVL         ,     
				D.STDDEV_KRI_NVL 	RYR1_SDVA        ,     
				D.MAX_KRI_NVL 		RYR1_MAX_VAL     ,     
				D.MIN_KRI_NVL 		RYR1_MIN_VAL     ,     
				E.AVG_KRI_NVL 		BFYY_AVL         ,     
				E.STDDEV_KRI_NVL 	BFYY_SDVA        ,     
				E.MAX_KRI_NVL 		BFYY_MAX_VAL     ,     
				E.MIN_KRI_NVL 		BFYY_MIN_VAL     ,     
				F.BMM_SC1_MAX_TRH	BMM_SC1_MAX_TRH  ,     
				F.BMM_SQ2_MAX_TRH	BMM_SQ2_MAX_TRH  ,  
				H.LMT_CHG_CNTN		LMT_CHG_CNTN	 ,
	            SYSDATE  			FIR_INP_DTM      ,     
	            'SYSTEM' 			FIR_INPMN_ENO  	 ,     
	            SYSDATE  			LSCHG_DTM        ,     
	            'SYSTEM' 			LS_WKR_ENO             
			  FROM OPEOWN.TB_OR_KM_RKI A                  
			     , OPEOWN.TB_OR_KH_RKISLT B               
	             , OPEOWN.TB_OR_KH_BRC C                  
				 , (SELECT                                 
						 A.GRP_ORG_C ,                     
						 A.BRC ,                           
						 A.OPRK_RKI_ID ,                   
						 MAX(A.KRI_NVL) MAX_KRI_NVL,       
						 MIN(A.KRI_NVL) MIN_KRI_NVL,       
						 STDDEV(A.KRI_NVL) STDDEV_KRI_NVL, 
						 AVG(A.KRI_NVL) AVG_KRI_NVL        
					FROM OPEOWN.TB_OR_KH_NVL A            
				   WHERE A.GRP_ORG_C = '01'        
	                 AND A.BAS_YM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-12),'YYYYMM')  
	                                  AND TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-1),'YYYYMM')   
				   GROUP BY A.GRP_ORG_C , A.BRC , A.OPRK_RKI_ID                                          
				   ) D 
				 , (SELECT                                 
						 A.GRP_ORG_C ,                     
						 A.BRC ,                           
						 A.OPRK_RKI_ID ,                   
						 MAX(A.KRI_NVL) MAX_KRI_NVL,       
						 MIN(A.KRI_NVL) MIN_KRI_NVL,       
						 STDDEV(A.KRI_NVL) STDDEV_KRI_NVL, 
						 AVG(A.KRI_NVL) AVG_KRI_NVL        
					FROM OPEOWN.TB_OR_KH_NVL A            
				   WHERE A.GRP_ORG_C = '01'        
				     AND A.BAS_YM BETWEEN TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-12),'YYYY') || '01'  
					                  AND TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-12),'YYYY') || '12'  
				   GROUP BY A.GRP_ORG_C , A.BRC , A.OPRK_RKI_ID   
				   ) E                   
				 , (SELECT                                
				    	 A.GRP_ORG_C ,                    
				    	 A.BRC ,                          
				    	 A.OPRK_RKI_ID ,                  
				    	 A.SC1_LMT_VAL  BMM_SC1_MAX_TRH ,	
						 A.SQ2_LMT_VAL  BMM_SQ2_MAX_TRH  	
				    FROM OPEOWN.TB_OR_KH_LMT A           
				      WHERE A.GRP_ORG_C = '01'    
				        AND A.BAS_YM = P_BF_BASYM      
				   ) F
                 ,(SELECT BRC FROM OPEOWN.TB_OR_OM_ORGZ WHERE HOFC_BIZO_DSC = '03' AND UYN ='Y') G
                 ,OPEOWN.TB_OR_KM_FIX_LMT H
		    WHERE A.GRP_ORG_C = '01'        
			  AND A.GRP_ORG_C = B.GRP_ORG_C         
			  AND A.GRP_ORG_C = C.GRP_ORG_C         
			  AND A.GRP_ORG_C = D.GRP_ORG_C (+)     
			  AND A.GRP_ORG_C = E.GRP_ORG_C (+)     
			  AND A.GRP_ORG_C = F.GRP_ORG_C (+)     
			  AND A.OPRK_RKI_ID = B.OPRK_RKI_ID     
			  AND A.OPRK_RKI_ID = C.OPRK_RKI_ID     
			  AND A.OPRK_RKI_ID = D.OPRK_RKI_ID (+) 
			  AND A.OPRK_RKI_ID = E.OPRK_RKI_ID (+) 
			  AND A.OPRK_RKI_ID = F.OPRK_RKI_ID (+) 
			  AND B.OPRK_RKI_ID = C.OPRK_RKI_ID     
			  AND B.OPRK_RKI_ID = D.OPRK_RKI_ID (+) 
			  AND B.OPRK_RKI_ID = E.OPRK_RKI_ID (+) 
			  AND B.OPRK_RKI_ID = F.OPRK_RKI_ID (+) 
			  AND G.BRC = D.BRC (+)                 
			  AND G.BRC = E.BRC (+)                 
			  AND G.BRC = F.BRC (+)
              AND C.BRC = 'SHBR'
              AND A.OPRK_RKI_ID = H.OPRK_RKI_ID (+)
              AND G.BRC = H.BRC (+)
              AND A.GRP_ORG_C = H.GRP_ORG_C (+)
			  AND B.BAS_YM = P_BASYM            		
			)
			;
			 	P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� �ѵ� ���� �Ϸ�');
                
                UPDATE OPEOWN.TB_OR_KM_FIX_LMT 
                  SET LMT_CHG_CNTN =''
                     ,LSCHG_DTM = SYSDATE
                     ,LS_WKR_ENO = 'SYSTEM'
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� LMT_CHG_CNTN NULL ������Ʈ');
                
                COMMIT;
                
          ELSE
                DBMS_OUTPUT.PUT_LINE('�������ڿ� ��ġ���� �ʽ��ϴ�.');

               -- RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT