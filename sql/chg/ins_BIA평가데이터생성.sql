/*
        프로그램명 : ins_BIA평가데이터 생성
        타켓테이블 : 
        최조작성자 : 김병현
*/
  DECLARE  
        P_DTDATE  VARCHAR2(8);  -- 기준일자
        P_RUNDATE VARCHAR2(8);
        P_BASYM   VARCHAR2(6);
        P_BASECNT  NUMBER;  -- 실행기준건수
        P_LD_CN    NUMBER;  -- 로딩건수
        P_DUMMY	   VARCHAR2(8);
        P_BF_BASYM VARCHAR2(6); --이전
  
 BEGIN 
    SELECT  NXT_DT
      INTO  P_DTDATE
      FROM  OPEOWN.TB_OPE_DT_BC
  ;
 
 
    SELECT NVL(A.BIA_EVL_ST_DT,B.DUMMY) BIA_EVL_ST_DT
        ,A.BAS_YM
        ,B.DUMMY
    INTO P_RUNDATE
        ,P_BASYM
        ,P_DUMMY
    FROM 
  (SELECT A.BIA_EVL_ST_DT
        ,A.BAS_YM
        ,'99991231' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE BIA_EVL_TGT_YN = 'Y' 
     AND BIA_EVL_PRG_STSC = '01' --평가중에 다른업무 재작업시 날라가는 위험 방지
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE BIA_EVL_TGT_YN = 'Y' 
               )
  ) A
  ,(SELECT 99991231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;
    SELECT A.BAS_YM
      INTO P_BF_BASYM
      FROM (
        SELECT MAX(BAS_YM) BAS_YM    
          FROM OPEOWN.TB_OR_OM_SCHD   
         WHERE BIA_EVL_TGT_YN = 'Y'    		
           AND BIA_EVL_PRG_STSC = '03'
           )A;
  
  
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :기준일 : '||P_DTDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :기준일 : '||P_RUNDATE);
        

          IF P_DTDATE = P_RUNDATE  THEN

                DBMS_OUTPUT.PUT_LINE('기준일 일치 평가데이터 생성을 시작합니다.');

                DELETE FROM OPEOWN.TB_OR_ON_BIA_PRSSMM
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_ON_BIA_PRSS_UGBRM
                      WHERE BAS_YM = P_BASYM
                      ;   
                INSERT INTO OPEOWN.TB_OR_ON_BIA_PRSSMM
                (
 GRP_ORG_C
,BSN_PRSS_C
,BAS_YM
,BSN_PRSNM
,ENG_BSN_PRSNM
,LVL_NO
,UP_BSN_PRSS_C
,VLD_ST_DT
,VLD_ED_DT
,VLD_YN
,FIR_INP_DTM
,FIR_INPMN_ENO
,LSCHG_DTM
,LS_WKR_ENO
)SELECT
 GRP_ORG_C
,BSN_PRSS_C
,P_BASYM
,BSN_PRSNM
,ENG_BSN_PRSNM
,LVL_NO
,UP_BSN_PRSS_C
,VLD_ST_DT
,VLD_ED_DT
,VLD_YN
,SYSDATE
,'SYSTEM'
,SYSDATE
,'SYSTEM'
FROM OPEOWN.TB_OR_OC_PRSS
;
INSERT INTO OPEOWN.TB_OR_ON_BIA_PRSS_UGBRM
(GRP_ORG_C
,BSN_PRSS_C
,BRC
,BAS_YM
,FIR_INP_DTM
,FIR_INPMN_ENO
,LSCHG_DTM
,LS_WKR_ENO
)
SELECT 
 GRP_ORG_C
,BSN_PRSS_C
,BRC
,P_BASYM
,SYSDATE
,'SYSTEM'
,SYSDATE
,'SYSTEM'
FROM OPEOWN.TB_OR_OH_PRSS_UGBR
;

                
                
                DELETE FROM OPEOWN.TB_OR_BM_BIAEVL
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_BM_BIAEVL_DCZ
                      WHERE BAS_YM = P_BASYM
                       ;
                
                INSERT INTO OPEOWN.TB_OR_BM_BIAEVL
(GRP_ORG_C
,BAS_YM
,BSN_PRSS_C
,BRC
,BSN_TP_IPTD_VAL
,BSN_SSP_IFN_VAL
,MAX_PMSS_SSP_PRDC
,OBT_RCVR_PTM_C
,QSN_RG_YN
,FIR_OBT_RCVR_HR_C
,OBT_RCVR_HR_C
,VLR_ENO
,DCZ_SQNO
,BIA_EVL_PRG_STSC
,FIR_INP_DTM
,FIR_INPMN_ENO
,LSCHG_DTM
,LS_WKR_ENO)
SELECT 
 A.GRP_ORG_C
,P_BASYM
,A.BSN_PRSS_C
,C.BRC
,A.BSN_TP_IPTD_VAL    
,A.BSN_SSP_IFN_VAL    
,A.MAX_PMSS_SSP_PRDC  
,A.OBT_RCVR_PTM_C     
,A.QSN_RG_YN
,FIR_OBT_RCVR_HR_C
,A.OBT_RCVR_HR_C
,'' VLR_ENO
,'0' DCZ_SQNO
,'01' BIA_EVL_PRG_STSC
,SYSDATE 
,'SYSTEM'
,SYSDATE
,'SYSTEM'
FROM OPEOWN.TB_OR_BM_BIAEVL A   
    ,OPEOWN.TB_OR_OC_PRSS B     
    ,OPEOWN.TB_OR_OH_PRSS_UGBR C
  WHERE A.BAS_YM(+) = P_BF_BASYM           
  AND A.GRP_ORG_C(+) = B.GRP_ORG_C   
  AND A.BSN_PRSS_C(+) = B.BSN_PRSS_C 
  AND B.GRP_ORG_C = C.GRP_ORG_C      
  AND B.BSN_PRSS_C = C.BSN_PRSS_C   	
  AND A.BRC(+) = C.BRC
  AND B.VLD_YN ='Y'
                ;
INSERT INTO OPEOWN.TB_OR_BM_BIAEVL_DCZ
(
GRP_ORG_C
,BAS_YM
,DCZ_SQNO
,BSN_PRSS_C
,BRC
,BIA_DCZ_STSC
,FIR_INP_DTM
,FIR_INPMN_ENO
,LSCHG_DTM
,LS_WKR_ENO
)
SELECT '01',BAS_YM,'0',BSN_PRSS_C,BRC,DCZ_SQNO,SYSDATE,'SYSTEM',SYSDATE,'SYSTEM' 
 FROM  OPEOWN.TB_OR_BM_BIAEVL
WHERE BAS_YM = P_BASYM            
                ;
                
                DELETE FROM OPEOWN.TB_OR_BH_BSNTP_EVL
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_BH_SSPIFN_EVL
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_BH_IPTINF
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_BH_PALS_RLR
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_BH_NED_HMRS
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_BH_PRCD_BSN
                      WHERE BAS_YM = P_BASYM
                      ;
                
INSERT INTO OPEOWN.TB_OR_BH_BSNTP_EVL     
(                                     
     GRP_ORG_C  	                     
	,BAS_YM		                     
	,BSN_PRSS_C	                         
	,BRC			                     
	,BCP_BSN_TPC	                     
	,COIC_YN		                     
    ,FIR_INP_DTM	                     
    ,FIR_INPMN_ENO	                 
    ,LSCHG_DTM		                 
    ,LS_WKR_ENO		                 
)                                     
SELECT                                
     B.GRP_ORG_C                      
	,P_BASYM                      				
    ,B.BSN_PRSS_C                     
	,D.BRC                              	
    ,C.BCP_BSN_TPC                    
    ,NVL(A.COIC_YN,'N') COIC_YN       
    ,SYSDATE FIR_INP_DTM              
    ,'SYSTEM' FIR_INPMN_ENO           
    ,SYSDATE LSCHG_DTM                
    ,'SYSTEM' LS_WKR_ENO              
   FROM OPEOWN.TB_OR_BH_BSNTP_EVL A       
       ,OPEOWN.TB_OR_OC_PRSS B         		
	   ,OPEOWN.TB_OR_BM_BSNTP C        			
	   ,OPEOWN.TB_OR_OH_PRSS_UGBR D    			
  WHERE A.BAS_YM(+) = P_BF_BASYM           
	AND A.GRP_ORG_C(+) = B.GRP_ORG_C     
	AND A.BSN_PRSS_C(+) = B.BSN_PRSS_C   
	AND A.GRP_ORG_C(+) = C.GRP_ORG_C     
	AND A.BCP_BSN_TPC(+) = C.BCP_BSN_TPC 
	AND B.GRP_ORG_C = C.GRP_ORG_C        
	AND B.GRP_ORG_C = D.GRP_ORG_C        
	AND B.BSN_PRSS_C = D.BSN_PRSS_C      
	AND A.BRC = D.BRC                 		
	AND B.VLD_YN = 'Y';          
                
INSERT INTO OPEOWN.TB_OR_BH_SSPIFN_EVL   
(                                    
     GRP_ORG_C  	                    
	,BAS_YM		                    
	,BSN_PRSS_C	                        
	,BRC			                    
	,BCP_IFN_DSC	                    
	,COIC_YN		                    
    ,FIR_INP_DTM	                    
    ,FIR_INPMN_ENO	                
    ,LSCHG_DTM		                
    ,LS_WKR_ENO		                
)                                    
SELECT                               
     B.GRP_ORG_C                     
	,P_BASYM                         			
    ,B.BSN_PRSS_C                    
	,D.BRC                              
    ,C.BCP_IFN_DSC                   
    ,NVL(A.COIC_YN,'N') COIC_YN      
    ,SYSDATE FIR_INP_DTM             
    ,'SYSTEM' FIR_INPMN_ENO          
    ,SYSDATE LSCHG_DTM               
    ,'SYSTEM' LS_WKR_ENO             
   FROM OPEOWN.TB_OR_BH_SSPIFN_EVL A   	
       ,OPEOWN.TB_OR_OC_PRSS B         	
	   ,OPEOWN.TB_OR_BM_SSPIFN C        	
	   ,OPEOWN.TB_OR_OH_PRSS_UGBR D     	
  WHERE A.BAS_YM(+) = P_BF_BASYM 
	AND A.GRP_ORG_C(+) = B.GRP_ORG_C    
	AND A.BSN_PRSS_C(+) = B.BSN_PRSS_C  
	AND A.GRP_ORG_C(+) = C.GRP_ORG_C    
	AND A.BCP_IFN_DSC(+) = C.BCP_IFN_DSC
	AND B.GRP_ORG_C = C.GRP_ORG_C       
	AND B.GRP_ORG_C = D.GRP_ORG_C       
	AND B.BSN_PRSS_C = D.BSN_PRSS_C     
	AND A.BRC = D.BRC                 	
	AND B.VLD_YN = 'Y'                  ;
                
                INSERT INTO OPEOWN.TB_OR_BH_IPTINF   
(                                
     GRP_ORG_C  	                
	,BAS_YM		                
	,BSN_PRSS_C	                    
	,BRC			                
	,DSQNO		                    
	,IPT_INFNM	                    
	,IPT_INF_FORM_C	                
	,STRG_LOCNM	                    
	,BKUP_YN	                    
	,BKUP_FORM_C	                
	,BKUP_FQC		                
	,PLCNM		   	                
    ,FIR_INP_DTM	                
    ,FIR_INPMN_ENO	            
    ,LSCHG_DTM		            
    ,LS_WKR_ENO		            
)                                
SELECT                           
     A.GRP_ORG_C                 
	,P_BASYM                       		
    ,A.BSN_PRSS_C                
	,A.BRC                          
    ,A.DSQNO                     
    ,A.IPT_INFNM                 
    ,A.IPT_INF_FORM_C            
    ,A.STRG_LOCNM                
    ,A.BKUP_YN                   
    ,A.BKUP_FORM_C               
    ,A.BKUP_FQC                  
    ,A.PLCNM                     
    ,SYSDATE FIR_INP_DTM         
    ,'SYSTEM' FIR_INPMN_ENO      
    ,SYSDATE LSCHG_DTM           
    ,'SYSTEM' LS_WKR_ENO         
   FROM OPEOWN.TB_OR_BH_IPTINF A    	
  WHERE A.BAS_YM = P_BF_BASYM		;
    
    
                INSERT INTO OPEOWN.TB_OR_BH_PALS_RLR 	
(                                    
     GRP_ORG_C  	                    
	,BAS_YM		                    
	,BSN_PRSS_C	                        
	,BRC			                    
	,DSQNO		                        
	,CONM	       	                    
	,DEPTNM	   		                    
	,CHRG_EMPNM	                        
	,PZCNM	   		                    
	,CHRG_BSNNM		                    
	,EMAIL_ADR		                    
	,MPNO		   	                    
	,OFFC_TELNO	   	                    
    ,FIR_INP_DTM	                    
    ,FIR_INPMN_ENO	                
    ,LSCHG_DTM		                
    ,LS_WKR_ENO		                
)                                    
SELECT                               
     A.GRP_ORG_C                     
	,P_BASYM                   				
    ,A.BSN_PRSS_C                    
	,A.BRC                              
    ,A.DSQNO                         
    ,A.CONM                          
    ,A.DEPTNM                        
    ,A.CHRG_EMPNM                    
    ,A.PZCNM                         
    ,A.CHRG_BSNNM                    
    ,A.EMAIL_ADR                     
    ,A.MPNO                          
    ,A.OFFC_TELNO                    
    ,SYSDATE FIR_INP_DTM             
    ,'SYSTEM' FIR_INPMN_ENO          
    ,SYSDATE LSCHG_DTM               
    ,'SYSTEM' LS_WKR_ENO             
   FROM OPEOWN.TB_OR_BH_PALS_RLR A   	
  WHERE A.BAS_YM = P_BF_BASYM 			;
    
    
                
                INSERT INTO OPEOWN.TB_OR_BH_NED_HMRS 
(                                
     GRP_ORG_C  	                
	,BAS_YM		                
	,BSN_PRSS_C	                    
	,BRC			                
	,DSQNO		                    
	,RCVR_HMRS_DSC 	                
	,EMPNM
    ,PZCNM
	,CHRG_BSNNM	   	                
	,MPNO			                
	,EMAIL_ADR		                
	,OHSE_ADR	   	                
	,OHSE_TELNO	   	                
    ,FIR_INP_DTM	                
    ,FIR_INPMN_ENO	            
    ,LSCHG_DTM		            
    ,LS_WKR_ENO		            
)                                
SELECT                           
     A.GRP_ORG_C                 
	,P_BASYM                      		
    ,A.BSN_PRSS_C                
	,A.BRC                          
    ,A.DSQNO                     
    ,A.RCVR_HMRS_DSC             
    ,A.EMPNM 
    ,A.PZCNM
    ,A.CHRG_BSNNM                
    ,A.MPNO                      
    ,A.EMAIL_ADR                 
    ,A.OHSE_ADR                  
    ,A.OHSE_TELNO                
    ,SYSDATE FIR_INP_DTM         
    ,'SYSTEM' FIR_INPMN_ENO      
    ,SYSDATE LSCHG_DTM           
    ,'SYSTEM' LS_WKR_ENO         
   FROM OPEOWN.TB_OR_BH_NED_HMRS A   
  WHERE A.BAS_YM = P_BF_BASYM			;
                
                
                INSERT INTO OPEOWN.TB_OR_BH_NED_BZDE 
(                                
     GRP_ORG_C  	                
	,BAS_YM		                
	,BSN_PRSS_C	                    
	,BRC			                
	,DSQNO		                    
	,BZS_DEVCNM 	                
	,QT		   		                
	,UG_UZ_EXPL   	                
    ,FIR_INP_DTM	                
    ,FIR_INPMN_ENO	            
    ,LSCHG_DTM		            
    ,LS_WKR_ENO		            
)                                
SELECT                           
     A.GRP_ORG_C                 
	,P_BASYM                     		
    ,A.BSN_PRSS_C                
	,A.BRC                         	
    ,A.DSQNO                     
    ,A.BZS_DEVCNM                
    ,A.QT                        
    ,A.UG_UZ_EXPL                
    ,SYSDATE FIR_INP_DTM         
    ,'SYSTEM' FIR_INPMN_ENO      
    ,SYSDATE LSCHG_DTM           
    ,'SYSTEM' LS_WKR_ENO         
   FROM OPEOWN.TB_OR_BH_NED_BZDE A  	
  WHERE A.BAS_YM = P_BF_BASYM			;
    
    
    
            INSERT INTO OPEOWN.TB_OR_BH_PRCD_BSN 
(                                
     GRP_ORG_C  	                
	,BAS_YM		                
	,BSN_PRSS_C	                    
	,BRC			                
	,PRCD_BRC                
    ,FIR_INP_DTM	                
    ,FIR_INPMN_ENO	            
    ,LSCHG_DTM		            
    ,LS_WKR_ENO		            
)                                
SELECT                           
     A.GRP_ORG_C                 
	,P_BASYM                     			
    ,A.BSN_PRSS_C                
	,A.BRC                          
    ,A.PRCD_BRC           
    ,SYSDATE FIR_INP_DTM         
    ,'SYSTEM' FIR_INPMN_ENO      
    ,SYSDATE LSCHG_DTM           
    ,'SYSTEM' LS_WKR_ENO         
   FROM OPEOWN.TB_OR_BH_PRCD_BSN A   
  WHERE A.BAS_YM = P_BF_BASYM 		;
    
    
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 평가데이터 생성');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD_PLAN 
                SET BIA_EVL_PRG_STSC ='02'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 스케쥴 플랜 테이블 평가중으로 업데이트');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD 
                SET BIA_EVL_PRG_STSC ='02'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 스케쥴테이블 평가중으로 업데이트');
                
                
                COMMIT;
                
          ELSE
                DBMS_OUTPUT.PUT_LINE('실행일자와 일치하지 않습니다.');

               -- RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT