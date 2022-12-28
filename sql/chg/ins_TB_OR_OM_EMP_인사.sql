/*
        ���α׷��� : ins_TB_OR_OM_EMP_�λ�
        Ÿ�����̺� : TB_OR_OM_EMP,TB_OR_OH_EMP_AUTH,TB_OR_OH_ORGZ_EMP_AUTH,TB_OR_OM_SSO_INF
        �����ۼ��� : �ڽ���
*/
DECLARE
        P_BASEDAY  VARCHAR2(8);  -- ��������
        P_BASECNT  NUMBER;  -- ������ذǼ�
        P_EMPCNT   NUMBER;  -- �λ����̺� �Ǽ�
        P_NEWEMP   NUMBER;  -- �ű� �λ� �Ǽ�
        P_LD_CN    NUMBER;  -- �ε��Ǽ�
        P_N_ORGZ_EMP NUMBER; -- �����ũ������ �ƴ� ���� �Ҽӵ��ִ� ���� ��
		P_N_ORGZ_EMP_CNT NUMBER; -- �����ũ �������� ������Ʈ �� ���� ��
BEGIN
        SELECT TO_CHAR(SYSDATE,'YYYYMMDD') 
          INTO P_BASEDAY
          FROM DUAL;
  
        DBMS_OUTPUT.PUT_LINE('��������� : '||P_BASEDAY);
        
        SELECT  COUNT(���)
          INTO    P_BASECNT
          FROM    DWZOWN."TB_MDWT�߾�ȸ�λ�"
         WHERE   �ۼ�������  = TRIM(P_BASEDAY);


          IF P_BASECNT > 0  THEN

                DBMS_OUTPUT.PUT_LINE('DW�߾�ȸ�λ����̺� ������ ����, �λ� ��ġ ����');
                
                SELECT COUNT(ENO)
                  INTO P_EMPCNT
                  FROM OPEOWN.TB_OR_OM_EMP;
                  
                  /*�λ� ��ġ ����*/
                  IF P_EMPCNT = 0 THEN 
                
                     DBMS_OUTPUT.PUT_LINE('TB_OR_OM_EMP ���̺� �Ǽ� '||P_EMPCNT||'�� �����ũ �λ� ��ü �����');
                    
                    /*�λ� ������� ����� EMP���̺�*/
                    INSERT INTO OPEOWN.TB_OR_OM_EMP (GRP_ORG_C,ENO,BRC,TMS_BRC,CHRG_EMPNM,HDOF_RTR_DSC,PZCC,OFT_C,TEAM_CD,ADOP_DT,
							APNT_DT,RTR_DT,OFFC_TEL_CNTN,GNAF_CHRR_YN,OPRK_AMN_YN,LS_CONN_DTM,USR_IPADR,FIR_INP_DTM,
							FIR_INPMN_ENO,LSCHG_DTM,LS_WKR_ENO)
                  SELECT NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
				      ,TRIM(A."���") ENO
				      ,DECODE(TRIM(A."����ȣ"),NULL,TRIM((B."����ȣ")),TRIM(A."����ȣ")) BRC
				      ,DECODE(TRIM(A."����ȣ"),NULL,TRIM((B."����ȣ")),TRIM(A."����ȣ")) TMS_BRC
				      ,TRIM(A."����") CHRG_EMPNM
				      ,'1' HDOF_RTR_DSC
				      ,TRIM(A."�����ڵ�") PZCC
				      ,TRIM(A."�����ڵ�") OFT_C
				      ,TRIM(A."���ڵ�") TEAM_CD
				      ,TRIM(A."�Ի���") ADOP_DT
				      ,TRIM(A."���Ҽӹ߷���") APNT_DT
				      ,'' RTR_DT
				      ,(SELECT MAX(B.TL_ARCD||'-'||B.TL_TONO||'-'||B.TL_SNO) FROM DWZOWN.TB_SOR_CMI_BR_BC B WHERE DECODE(TRIM(A."����ȣ"),'',TRIM(B."����ȣ"),TRIM(A."����ȣ")) = TRIM(B.BRNO)) OFFC_TEL_CNTN
				      ,'' GNAF_CHRR_YN
				      ,'' OPRK_AMN_YN
				      ,'' LS_CONN_DTM
				      ,'' USR_IPADR
				      ,SYSDATE FIR_INP_DTM
				      ,'SYSTEM' FIR_INPMN_ENO
				      ,SYSDATE LSCHG_DTM
				      ,'SYSTEM' LS_WKR_ENO
				 FROM DWZOWN."TB_MDWT�߾�ȸ�λ�" A
                     ,DWZOWN."TB_MDWT�λ�" B
				 WHERE A."�ۼ�������" = TRIM(P_BASEDAY)
				  AND TRIM(A."�����и�") = '��������'
				  AND TRIM(A."�������и�") = '����'
                  AND TRIM(A."�ۼ�������") = TRIM(B."�ۼ�������")
                  AND TRIM(A."���") = TRIM(B."���")
				  --AND TRIM("�������и�") = '������'
				  AND TRIM(B."����ȣ") IS NOT NULL
				  ;
				  
				P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows inserted to TB_OR_OM_EMP (�űԻ���)');
		ELSE  
				/* �λ� UPDATE �� �ű����� INSERT */
				MERGE INTO OPEOWN.TB_OR_OM_EMP A 
                  USING ( 
                  SELECT NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
				      ,TRIM(A."���") ENO
				      ,CASE WHEN A."�������ڵ�" IS NULL THEN 'XXXX'
                            ELSE
                       DECODE(TRIM(A."����ȣ"),NULL,TRIM((B."����ȣ")),TRIM(A."����ȣ")) END BRC
                       
				      ,DECODE(TRIM(A."����ȣ"),NULL,TRIM((B."����ȣ")),TRIM(A."����ȣ")) TMS_BRC
				      ,TRIM(A."����") CHRG_EMPNM
				      ,'1' HDOF_RTR_DSC
				      ,TRIM(A."�����ڵ�") PZCC
				      ,TRIM(A."�����ڵ�") OFT_C
				      ,TRIM(A."���ڵ�") TEAM_CD
				      ,TRIM(A."�Ի���") ADOP_DT
				      ,TRIM(A."���Ҽӹ߷���") APNT_DT
				      ,'' RTR_DT
				      ,(SELECT MAX(B.TL_ARCD||'-'||B.TL_TONO||'-'||B.TL_SNO) FROM DWZOWN.TB_SOR_CMI_BR_BC B WHERE DECODE(TRIM(A."����ȣ"),'',TRIM(B."����ȣ"),TRIM(A."����ȣ")) = TRIM(B.BRNO)) OFFC_TEL_CNTN
				      ,'' GNAF_CHRR_YN
				      ,'' OPRK_AMN_YN
				      ,'' LS_CONN_DTM
				      ,'' USR_IPADR
				      ,SYSDATE FIR_INP_DTM
				      ,'SYSTEM' FIR_INPMN_ENO
				      ,SYSDATE LSCHG_DTM
				      ,'SYSTEM' LS_WKR_ENO
				 FROM DWZOWN."TB_MDWT�߾�ȸ�λ�" A
                     ,DWZOWN."TB_MDWT�λ�" B
				 WHERE A."�ۼ�������" = TRIM(P_BASEDAY)
				  AND TRIM(A."�����и�") = '��������'
				  AND TRIM(A."�������и�") = '����'
                  AND TRIM(A."�ۼ�������") = TRIM(B."�ۼ�������")
                  AND TRIM(A."���") = TRIM(B."���")
				  --AND TRIM("�������и�") = '������'
				  --AND TRIM(B."����ȣ") IS NOT NULL
                         ) B
                  ON (A.ENO = B.ENO)
                WHEN MATCHED THEN UPDATE SET A.BRC = B.BRC,
                                             A.TMS_BRC = B.TMS_BRC,
                                             A.CHRG_EMPNM = B.CHRG_EMPNM,
                                             A.PZCC = B.PZCC,
                                             A.OFT_C = B.OFT_C,
                                             A.TEAM_CD = B.TEAM_CD,
                                             A.ADOP_DT = B.ADOP_DT,
                                             A.APNT_DT = B.APNT_DT,
                                             A.OFFC_TEL_CNTN = B.OFFC_TEL_CNTN,
                                             A.LSCHG_DTM = SYSDATE,
                                             LS_WKR_ENO = 'SYSTEM'
                WHEN NOT MATCHED THEN
                 INSERT (A.GRP_ORG_C,A.ENO,A.BRC,A.TMS_BRC,A.CHRG_EMPNM,A.HDOF_RTR_DSC,A.PZCC,A.OFT_C,A.TEAM_CD,A.ADOP_DT,A.APNT_DT,A.RTR_DT,A.OFFC_TEL_CNTN,
                         A.GNAF_CHRR_YN,A.OPRK_AMN_YN,A.LS_CONN_DTM,A.USR_IPADR,A.FIR_INP_DTM,A.FIR_INPMN_ENO,A.LSCHG_DTM,A.LS_WKR_ENO)
                 VALUES (B.GRP_ORG_C,B.ENO,B.BRC,B.TMS_BRC,B.CHRG_EMPNM,B.HDOF_RTR_DSC,B.PZCC,B.OFT_C,B.TEAM_CD,B.ADOP_DT,B.APNT_DT,B.RTR_DT,B.OFFC_TEL_CNTN,
                         B.GNAF_CHRR_YN,B.OPRK_AMN_YN,B.LS_CONN_DTM,B.USR_IPADR,B.FIR_INP_DTM,B.FIR_INPMN_ENO,B.LSCHG_DTM,B.LS_WKR_ENO)
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows update or insert to TB_OR_OM_EMP');
                
		        /*������ UPDATE*/
                MERGE INTO OPEOWN.TB_OR_OM_EMP A
                  USING ( 
                          SELECT TRIM("���") ENO , TRIM("������") RTR_DT
				            FROM DWZOWN."TB_MDWT�߾�ȸ�λ�"
				           WHERE "�ۼ�������" = TRIM(P_BASEDAY)
				             AND TRIM("�����и�") = '��������'
				             AND TRIM("�������и�") = '����'
				             --AND TRIM("�������и�") = '������'
                        ) B
                     ON (A.ENO = B.ENO)
                WHEN MATCHED THEN UPDATE SET A.RTR_DT = B.RTR_DT,
                                             A.HDOF_RTR_DSC = '2',
                                             A.LSCHG_DTM = SYSDATE,
                                             A.LS_WKR_ENO = 'SYSTEM'
                    ;
                
                P_LD_CN := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE('������ : '||P_LD_CN ||'��');    
         END IF;       
                
         		/*����*/
         
				/*SSO ���̺�*/
				--DELETE FROM OPEOWN.TB_OR_OM_SSO_INF;
				--INSERT INTO OPEOWN.TB_OR_OM_SSO_INF (SSO_ENO,SSO_PWIZE_PW,SSO_USRNM,SSO_BRC,FIR_INP_DTM,FIR_INPMN_ENO,LSCHG_DTM,LS_WKR_ENO)
				--SELECT ENO,ENO,CHRG_EMPNM,BRC,SYSDATE,'SYSTEM',SYSDATE,'SYSTEM' FROM OPEOWN.TB_OR_OM_EMP WHERE HDOF_RTR_DSC = '1';
                DELETE FROM OPEOWN.TB_OR_OM_SSO_INF WHERE SSO_ENO IN (SELECT ENO FROM OPEOWN.TB_OR_OM_EMP WHERE HDOF_RTR_DSC = '2');
         		MERGE INTO OPEOWN.TB_OR_OM_SSO_INF A
				     USING (SELECT ENO SSO_ENO,ENO SSO_PWIZE_PW,CHRG_EMPNM,BRC
				                  ,SYSDATE FIR_INP_DTM,'SYSTEM' FIR_INPMN_ENO
				                  ,SYSDATE LSCHG_DTM,'SYSTEM' LS_WKR_ENO
				              FROM OPEOWN.TB_OR_OM_EMP 
				             WHERE HDOF_RTR_DSC = '1'
				            ) B
						ON (A.SSO_ENO = B.SSO_ENO)
				WHEN MATCHED THEN UPDATE SET A.SSO_USRNM = TRIM(B.CHRG_EMPNM),A.SSO_BRC = B.BRC,A.LSCHG_DTM = B.LSCHG_DTM,A.LS_WKR_ENO = B.LS_WKR_ENO
			    WHEN NOT MATCHED THEN
			         INSERT (A.SSO_ENO,A.SSO_PWIZE_PW,A.SSO_USRNM,A.SSO_BRC,ACCESS_YN,A.FIR_INP_DTM,A.FIR_INPMN_ENO,A.LSCHG_DTM,A.LS_WKR_ENO)
			         VALUES (B.SSO_ENO,B.SSO_PWIZE_PW,TRIM(B.CHRG_EMPNM),B.BRC,'Y',SYSDATE,'SYSTEM',SYSDATE,'SYSTEM')
			    ;
         
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows inserted to TB_OR_OM_SSO_INF');
                
                /*TB_OR_OH_ORGZ_EMP (�����ũ������ ���̺� ����)*/
                
                DELETE FROM OPEOWN.TB_OR_OH_ORGZ_EMP WHERE BRC <> 'SHBK';
                MERGE INTO OPEOWN.TB_OR_OH_ORGZ_EMP A
				     USING (SELECT A.GRP_ORG_C
                                  ,A.ENO
                                  ,CASE WHEN B.HOFC_BIZO_DSC = '02' THEN A.TEAM_CD
                                        WHEN B.HOFC_BIZO_DSC = '03' THEN B.BRC
                                        WHEN A.BRC = 'XXXX' THEN A.TEAM_CD
                                    END BRC 
                              FROM OPEOWN.TB_OR_OM_EMP A
                                  ,OPEOWN.TB_OR_OM_ORGZ B
                              WHERE A.HDOF_RTR_DSC = '1'
                                AND A.BRC = B.BRC (+)
                            ) B
						ON (A.ENO = B.ENO)
					  WHEN NOT MATCHED THEN 
			    INSERT (A.GRP_ORG_C,A.BRC,A.ENO,A.FIR_INP_DTM,A.FIR_INPMN_ENO,A.LSCHG_DTM,A.LS_WKR_ENO)
			    VALUES (B.GRP_ORG_C,NVL(B.BRC,'XXXX'),B.ENO,SYSDATE,'SYSTEM',SYSDATE,'SYSTEM');

			    
               /*TB_OR_OH_ORGZ_EMP (���� ����ִ� �����ũ ��������  UPDATE)*/
			   /*���� ���� ���� �ִ� 6�� UPDATE*/
			   
			   P_N_ORGZ_EMP_CNT := 0;
			    
			  FOR i in 1..6 LOOP
     
			     SELECT COUNT(ENO) 
			       INTO P_N_ORGZ_EMP
			       FROM 
					OPEOWN.TB_OR_OM_ORGZ A
				   ,OPEOWN.TB_OR_OH_ORGZ_EMP B
				  WHERE TRIM(A.BRC) = TRIM(B.BRC)
					AND A.UYN = 'N' 
					AND A.RCSA_ORGZ_YN = 'N' 
					AND A.KRI_ORGZ_YN = 'N' 
					AND A.LSS_ORGZ_YN = 'N'
					AND A.LVL_NO > '2'
  		         ;
  		         IF P_N_ORGZ_EMP_CNT = 0 THEN P_N_ORGZ_EMP_CNT := P_EMPCNT ;
  		         END IF;
  		         
  		         IF P_EMPCNT = 0 THEN 
  		         	DBMS_OUTPUT.PUT_LINE('�����ũ �������� UPDATE ����� : ' || P_N_ORGZ_EMP);
  		         	EXIT;
  		         ELSE                   
  		            MERGE INTO OPEOWN.TB_OR_OH_ORGZ_EMP A
					     USING
					     (
					     SELECT B.ENO,A.BRC,A.UP_BRC FROM 
					      OPEOWN.TB_OR_OM_ORGZ A
					     ,OPEOWN.TB_OR_OH_ORGZ_EMP B
					     WHERE TRIM(A.BRC) = TRIM(B.BRC)
						   AND A.UYN = 'N' 
						   AND A.RCSA_ORGZ_YN = 'N' 
						   AND A.KRI_ORGZ_YN = 'N' 
						   AND A.LSS_ORGZ_YN = 'N'
						   AND A.LVL_NO > '2'
					      ) B
					     ON (TRIM(A.ENO) = TRIM(B.ENO))
					     WHEN MATCHED THEN UPDATE SET A.BRC = B.UP_BRC;
				    DBMS_OUTPUT.PUT_LINE('�����ũ �������� UPDATE "'||i||'"ȸ �Ǽ� '||SQL%ROWCOUNT||'��');
  		         END IF;
  		      END LOOP;
  		        
  		       /*�����ũ  �Ϲ� ����� ���� INSERT*/
  		      DELETE FROM OPEOWN.TB_OR_OH_ORGZ_EMP_AUTH WHERE BRC IN (
                 		SELECT A.BRC 
                 	      FROM 
							OPEOWN.TB_OR_OM_ORGZ A
				   		   ,OPEOWN.TB_OR_OH_ORGZ_EMP B
				  		 WHERE TRIM(A.BRC) = TRIM(B.BRC)
						   AND A.UYN = 'N' 
						   AND A.RCSA_ORGZ_YN = 'N' 
						   AND A.KRI_ORGZ_YN = 'N' 
						   AND A.LSS_ORGZ_YN = 'N'
						   AND A.LVL_NO > '2'
                    	)
                    ;
                    
                    P_LD_CN := SQL%ROWCOUNT;
  		         	DBMS_OUTPUT.PUT_LINE('�����ũ ������ ���� , �̻�� ������ ���� �Ǽ� : '||P_LD_CN);
  		         	
               DELETE FROM OPEOWN.TB_OR_OH_ORGZ_EMP_AUTH WHERE ENO IN (SELECT ENO FROM OPEOWN.TB_OR_OM_EMP WHERE HDOF_RTR_DSC = '2');
                    P_LD_CN := SQL%ROWCOUNT;
  		         	DBMS_OUTPUT.PUT_LINE('�����ũ ������ ���� , ������ ���� �Ǽ� : '||P_LD_CN);
               
               MERGE INTO OPEOWN.TB_OR_OH_ORGZ_EMP_AUTH A
				     USING (SELECT DISTINCT A.GRP_ORG_C,B.BRC,A.ENO 
				              FROM OPEOWN.TB_OR_OM_EMP A
				                  ,OPEOWN.TB_OR_OH_ORGZ_EMP B
				     	     WHERE A.HDOF_RTR_DSC = '1'
				     	       AND A.ENO = B.ENO
				     	       AND B.BRC <> 'SHBK') B
						ON (A.ENO = B.ENO AND A.BRC <> 'SHBK' AND AUTH_GRP_ID NOT IN (SELECT AUTH_GRP_ID FROM OPEOWN.TB_OR_OM_AUTH WHERE AUTH_C ='1'))
			   WHEN NOT MATCHED THEN
			         INSERT (A.GRP_ORG_C,A.BRC,A.ENO,A.AUTH_GRP_ID,A.FIR_INP_DTM,A.FIR_INPMN_ENO,A.LSCHG_DTM,A.LS_WKR_ENO)
			         VALUES (B.GRP_ORG_C,B.BRC,B.ENO,'008',SYSDATE,'SYSTEM',SYSDATE,'SYSTEM')
			    ;
			    
			    P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE('�Ϲ� ����� ���� INSERT �Ǽ� : '||P_LD_CN);
                COMMIT;
         ELSE
                DBMS_OUTPUT.PUT_LINE('�߾�ȸ�λ����̺� ����������� �� �Ǽ� : '||P_BASECNT);
                DBMS_OUTPUT.PUT_LINE('DW�߾�ȸ�λ� ���̺� �����Ͱ� ���� ������ ���� �ʽ��ϴ�.DW�߾�ȸ �λ� ���̺��� Ȯ�� �� �ּ���');
 
                RAISE NO_DATA_FOUND;
              
          END IF;       
              
END
;
/
EXIT