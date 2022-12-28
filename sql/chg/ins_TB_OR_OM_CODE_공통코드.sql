/*
        ���α׷��� : ins_TB_OR_OM_CODE_�����ڵ�
        Ÿ�����̺� : TB_OR_OM_CODE
        �����ۼ��� : �ڽ���
*/
DECLARE
        P_BASEDAY  VARCHAR2(8);  -- ��������
        P_BASECNT  NUMBER;  -- ������ذǼ�
        P_LD_CN    NUMBER;  -- �ε��Ǽ�
BEGIN
     	    SELECT TO_CHAR(SYSDATE,'YYYYMMDD') 
          INTO P_BASEDAY
          FROM DUAL; 
  
        DBMS_OUTPUT.PUT_LINE('��������� : '||P_BASEDAY);
	
		--1.�� �ڵ�
	    
        SELECT  COUNT(*)
          INTO  P_BASECNT
          FROM DWZOWN.TB_SOR_CMI_CMN_CD_BC 
          WHERE TPCD_NO = '4600375305' --�����ڵ� �� ���ڵ� ������ȣ
		;

          IF P_BASECNT > 0  THEN

                DBMS_OUTPUT.PUT_LINE('���ڵ� ���� ����');
              	
                DELETE FROM OPEOWN.TB_OR_OM_CODE WHERE INTG_GRP_C = 'TEAM_CD' ;
                
			 INSERT INTO OPEOWN.TB_OR_OM_CODE (	
                SELECT '01' GRP_ORG_C
			      ,'TEAM_CD' INTG_GRP_C
			      ,TRIM(CMN_CD) IDVDC_VAL
			      ,'���ڵ�' INTG_GRP_CNM
			      ,TRIM(CMN_CD_NM) INTG_IDVD_CNM
			      ,ROWNUM SORT_SQ
			      ,'Y' C_UYN
			      ,'Y' MOD_IMP_YN
			      ,'99991231' DUE_DT
			      ,'' RMK_CNTN
			      ,SYSDATE
			      ,'SYSTEM'
			      ,SYSDATE
			      ,'SYSTEM'
			 FROM DWZOWN.TB_SOR_CMI_CMN_CD_BC 
			 WHERE TRIM(TPCD_NO) = '4600375305'
			   AND TRIM(CMN_CD_US_YN) = 'Y'
			 );
                
				P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows ���ڵ� ����');
		  ELSE  
				
                DBMS_OUTPUT.PUT_LINE('���ڵ� �Ǽ��� �������� �ʽ��ϴ�. DW�����͸� Ȯ���� �ּ���');    
         END IF;       
                
         --2.�����ڵ�
	    
        SELECT  COUNT(*)
          INTO  P_BASECNT
          FROM DWZOWN.TB_SOR_CMI_CMN_CD_BC 
          WHERE TPCD_NO = '4600759591' --�����ڵ� �� ����������ڵ� ������ȣ
			;

          IF P_BASECNT > 0  THEN

                DBMS_OUTPUT.PUT_LINE('����������ڵ� ���� ����');
              	
                DELETE FROM OPEOWN.TB_OR_OM_CODE WHERE INTG_GRP_C = 'OFT_C' ;
                
			 INSERT INTO OPEOWN.TB_OR_OM_CODE (	
                SELECT '01' GRP_ORG_C
			      ,'OFT_C' INTG_GRP_C
			      ,TRIM(CMN_CD) IDVDC_VAL
			      ,'����������ڵ�' INTG_GRP_CNM
			      ,TRIM(CMN_CD_NM) INTG_IDVD_CNM
			      ,ROWNUM SORT_SQ
			      ,'Y' C_UYN
			      ,'Y' MOD_IMP_YN
			      ,'99991231' DUE_DT
			      ,'' RMK_CNTN
			      ,SYSDATE
			      ,'SYSTEM'
			      ,SYSDATE
			      ,'SYSTEM'
			 FROM DWZOWN.TB_SOR_CMI_CMN_CD_BC 
			 WHERE TRIM(TPCD_NO) = '4600759591'
			   AND TRIM(CMN_CD_US_YN) = 'Y'
			 );
                
				P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows ����������ڵ� ����');
		  ELSE  
				
                DBMS_OUTPUT.PUT_LINE('����������ڵ� �Ǽ��� �������� �ʽ��ϴ�. DW�����͸� Ȯ���� �ּ���');    
         END IF;  		
             
         --3.��å�ڵ�
	    
        SELECT  COUNT(*)
          INTO  P_BASECNT
          FROM DWZOWN.TB_SOR_CMI_CMN_CD_BC 
          WHERE TPCD_NO = '4600804098' --�����ڵ� �� �������å�ڵ� ������ȣ
		;

          IF P_BASECNT > 0  THEN

                DBMS_OUTPUT.PUT_LINE('�������å�ڵ� ���� ����');
              	
                DELETE FROM OPEOWN.TB_OR_OM_CODE WHERE INTG_GRP_C = 'PZCC' ;
                
			 INSERT INTO OPEOWN.TB_OR_OM_CODE (	
                SELECT '01' GRP_ORG_C
			      ,'PZCC' INTG_GRP_C
			      ,TRIM(CMN_CD) IDVDC_VAL
			      ,'�������å�ڵ�' INTG_GRP_CNM
			      ,TRIM(CMN_CD_NM) INTG_IDVD_CNM
			      ,ROWNUM SORT_SQ
			      ,'Y' C_UYN
			      ,'Y' MOD_IMP_YN
			      ,'99991231' DUE_DT
			      ,'' RMK_CNTN
			      ,SYSDATE
			      ,'SYSTEM'
			      ,SYSDATE
			      ,'SYSTEM'
			 FROM DWZOWN.TB_SOR_CMI_CMN_CD_BC 
			 WHERE TRIM(TPCD_NO) = '4600804098'
			   AND TRIM(CMN_CD_US_YN) = 'Y'
			 );
                
				P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows �������å�ڵ� ����');
		  ELSE  
				
                DBMS_OUTPUT.PUT_LINE('�������å�ڵ� �Ǽ��� �������� �ʽ��ϴ�. DW�����͸� Ȯ���� �ּ���');    
         END IF;  	
         
         
         --4.DW���ڱ⺻
	    
        SELECT  COUNT(*)
          INTO  P_BASECNT
          FROM DWZOWN.OM_DWA_DT_BC 
          WHERE STD_DT_YN = 'Y' 
		;

          IF P_BASECNT > 0  THEN

                DBMS_OUTPUT.PUT_LINE('DW���ڱ⺻ ���� ����');
              	
             MERGE INTO OPEOWN.TB_OR_OM_DWA_DT_BC A
              USING DWZOWN.OM_DWA_DT_BC B
              ON ( A.STD_DT = B.STD_DT )
             WHEN MATCHED THEN UPDATE 
              SET 
             A.INFS_CHG_DTTM         =    B.INFS_CHG_DTTM     
			,A.HDY_YN                =    B.HDY_YN            
			,A.NXT_SLS_DT            =    B.NXT_SLS_DT        
			,A.BF_SLS_DT             =    B.BF_SLS_DT         
			,A.D2_BF_SLS_DT          =    B.D2_BF_SLS_DT      
			,A.D3_BF_SLS_DT          =    B.D3_BF_SLS_DT      
			,A.D4_BF_SLS_DT          =    B.D4_BF_SLS_DT      
			,A.D5_BF_SLS_DT          =    B.D5_BF_SLS_DT      
			,A.D6_BF_SLS_DT          =    B.D6_BF_SLS_DT      
			,A.D7_BF_SLS_DT          =    B.D7_BF_SLS_DT      
			,A.D8_BF_SLS_DT          =    B.D8_BF_SLS_DT      
			,A.D9_BF_SLS_DT          =    B.D9_BF_SLS_DT      
			,A.D10_BF_SLS_DT         =    B.D10_BF_SLS_DT     
			,A.D11_BF_SLS_DT         =    B.D11_BF_SLS_DT     
			,A.D12_BF_SLS_DT         =    B.D12_BF_SLS_DT     
			,A.D13_BF_SLS_DT         =    B.D13_BF_SLS_DT     
			,A.D14_BF_SLS_DT         =    B.D14_BF_SLS_DT     
			,A.D15_BF_SLS_DT         =    B.D15_BF_SLS_DT     
			,A.D16_BF_SLS_DT         =    B.D16_BF_SLS_DT     
			,A.D17_BF_SLS_DT         =    B.D17_BF_SLS_DT     
			,A.D18_BF_SLS_DT         =    B.D18_BF_SLS_DT     
			,A.D19_BF_SLS_DT         =    B.D19_BF_SLS_DT     
			,A.D20_BF_SLS_DT         =    B.D20_BF_SLS_DT     
			,A.D21_BF_SLS_DT         =    B.D21_BF_SLS_DT     
			,A.D22_BF_SLS_DT         =    B.D22_BF_SLS_DT     
			,A.D23_BF_SLS_DT         =    B.D23_BF_SLS_DT     
			,A.D24_BF_SLS_DT         =    B.D24_BF_SLS_DT     
			,A.D25_BF_SLS_DT         =    B.D25_BF_SLS_DT     
			,A.D26_BF_SLS_DT         =    B.D26_BF_SLS_DT     
			,A.D27_BF_SLS_DT         =    B.D27_BF_SLS_DT     
			,A.D28_BF_SLS_DT         =    B.D28_BF_SLS_DT     
			,A.D29_BF_SLS_DT         =    B.D29_BF_SLS_DT     
			,A.D30_BF_SLS_DT         =    B.D30_BF_SLS_DT     
			,A.NXT_DT                =    B.NXT_DT            
			,A.BF_DT                 =    B.BF_DT             
			,A.D2_BF_DT              =    B.D2_BF_DT          
			,A.D3_BF_DT              =    B.D3_BF_DT          
			,A.D4_BF_DT              =    B.D4_BF_DT          
			,A.D5_BF_DT              =    B.D5_BF_DT          
			,A.D6_BF_DT              =    B.D6_BF_DT          
			,A.D7_BF_DT              =    B.D7_BF_DT          
			,A.D8_BF_DT              =    B.D8_BF_DT          
			,A.D9_BF_DT              =    B.D9_BF_DT          
			,A.D10_BF_DT             =    B.D10_BF_DT         
			,A.D11_BF_DT             =    B.D11_BF_DT         
			,A.D12_BF_DT             =    B.D12_BF_DT         
			,A.D13_BF_DT             =    B.D13_BF_DT         
			,A.D14_BF_DT             =    B.D14_BF_DT         
			,A.D15_BF_DT             =    B.D15_BF_DT         
			,A.D16_BF_DT             =    B.D16_BF_DT         
			,A.D17_BF_DT             =    B.D17_BF_DT         
			,A.D18_BF_DT             =    B.D18_BF_DT         
			,A.D19_BF_DT             =    B.D19_BF_DT         
			,A.D20_BF_DT             =    B.D20_BF_DT         
			,A.D21_BF_DT             =    B.D21_BF_DT         
			,A.D22_BF_DT             =    B.D22_BF_DT         
			,A.D23_BF_DT             =    B.D23_BF_DT         
			,A.D24_BF_DT             =    B.D24_BF_DT         
			,A.D25_BF_DT             =    B.D25_BF_DT         
			,A.D26_BF_DT             =    B.D26_BF_DT         
			,A.D27_BF_DT             =    B.D27_BF_DT         
			,A.D28_BF_DT             =    B.D28_BF_DT         
			,A.D29_BF_DT             =    B.D29_BF_DT         
			,A.D30_BF_DT             =    B.D30_BF_DT         
			,A.TMM_SLS_DCNT          =    B.TMM_SLS_DCNT      
			,A.EOTM_SLS_DT           =    B.EOTM_SLS_DT       
			,A.BEOM_SLS_DT           =    B.BEOM_SLS_DT       
			,A.BF2_EOM_SLS_DT        =    B.BF2_EOM_SLS_DT    
			,A.STD_EOQ_SLS_DT        =    B.STD_EOQ_SLS_DT    
			,A.BF_EOQ_SLS_DT         =    B.BF_EOQ_SLS_DT     
			,A.BF2_EOQ_SLS_DT        =    B.BF2_EOQ_SLS_DT    
			,A.STD_EHY_SLS_DT        =    B.STD_EHY_SLS_DT    
			,A.THY_LST_SLS_DT        =    B.THY_LST_SLS_DT    
			,A.PVY_LST_SLS_DT        =    B.PVY_LST_SLS_DT    
			,A.BF_PVY_LST_SLS_DT     =    B.BF_PVY_LST_SLS_DT 
			,A.TMM_DCNT              =    B.TMM_DCNT          
			,A.MNDR_DCNT             =    B.MNDR_DCNT         
			,A.IMT_DCNT              =    B.IMT_DCNT          
			,A.EOTM_DT               =    B.EOTM_DT           
			,A.BEOM_DT               =    B.BEOM_DT           
			,A.BF2_EOM_DT            =    B.BF2_EOM_DT        
			,A.STD_EOQ_DT            =    B.STD_EOQ_DT        
			,A.BF_EOQ_DT             =    B.BF_EOQ_DT         
			,A.BF2_EOQ_DT            =    B.BF2_EOQ_DT        
			,A.STD_EHY_DT            =    B.STD_EHY_DT        
			,A.STD_DT_YN             =    B.STD_DT_YN         
			,A.HVF_YN                =    B.HVF_YN            
            ; 
				P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows DW���ڱ⺻ ����');
		  ELSE  
				
                DBMS_OUTPUT.PUT_LINE('DW���ڱ⺻ �Ǽ��� �������� �ʽ��ϴ�. DW�����͸� Ȯ���� �ּ���');    
         END IF;  	
         
         COMMIT;
END
;
/
EXIT