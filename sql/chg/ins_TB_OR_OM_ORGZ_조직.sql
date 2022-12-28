/*
        ���α׷��� : ins_TB_OR_OM_ORGZ_����
        Ÿ�����̺� : TB_OR_OM_ORGZ
        �����ۼ��� : �ڽ���
*/
DECLARE
        P_BASEDAY  VARCHAR2(8);  -- ��������
        P_BASECNT  NUMBER;  -- ������ذǼ�
        P_ORGZCNT  NUMBER;  -- �������̺� �Ǽ�
        P_NEWORGZ  NUMBER;  -- �ű� ���� �Ǽ�
        P_LD_CN    NUMBER;  -- �ε��Ǽ�

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

                DBMS_OUTPUT.PUT_LINE('DW�߾�ȸ�λ����̺� ������ ����, ���� ��ġ ����');
                
                SELECT COUNT(BRC)
                  INTO P_ORGZCNT
                  FROM OPEOWN.TB_OR_OM_ORGZ;
                  
                  /*���� ��ġ ����*/
                  IF P_ORGZCNT = 0 THEN 
                
                     DBMS_OUTPUT.PUT_LINE('TB_OR_OM_ORGZ ���̺� �Ǽ� '||P_ORGZCNT||'�� �����ũ ���� ��ü �����');
                    
                     /*���� ������� �����*/
                     INSERT INTO OPEOWN.TB_OR_OM_ORGZ
                      SELECT GRP_ORG_C,BRC,BRNM,LEVEL-1 LVL_NO,UP_BRC,BR_LKO_YN,RGN_C,HURSAL_BR_FORM_C,HOFC_BIZO_DSC,ORGZ_CFC,UYN,
                             LWST_ORGZ_YN,RCSA_ORGZ_YN,KRI_ORGZ_YN,LSS_ORGZ_YN,ANW_YN,TEMGR_DCZ_YN,
                             FIR_INP_DTM,FIR_INPMN_ENO,LSCHG_DTM,LS_WKR_ENO
                      FROM
                      (
                      SELECT 
                      NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
                      ,'SHBK' BRC
                      ,'��������' BRNM
                      ,'0' LVL_NO
                      ,'' UP_BRC
                      ,'N' BR_LKO_YN
                      ,'' RGN_C
                      ,'' HURSAL_BR_FORM_C
                      ,'01' HOFC_BIZO_DSC
                      ,'' ORGZ_CFC
                      ,'Y' UYN
                      ,'N' LWST_ORGZ_YN
                      ,'N' RCSA_ORGZ_YN
                      ,'N' KRI_ORGZ_YN
                      ,'N' LSS_ORGZ_YN
                      ,'N' ANW_YN
                      ,'N' TEMGR_DCZ_YN
                      ,SYSDATE FIR_INP_DTM
                      ,'SYSTEM' FIR_INPMN_ENO
                      ,SYSDATE LSCHG_DTM
                      ,'SYSTEM' LS_WKR_ENO
                      FROM DUAL
                      UNION ALL
                      SELECT 
                      NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
                      ,'SHHQ' BRC
                      ,'���κμ�' BRNM
                      ,'' LVL_NO
                      ,'SHBK' UP_BRC
                      ,'N' BR_LKO_YN
                      ,'' RGN_C
                      ,'' HURSAL_BR_FORM_C
                      ,'12' HOFC_BIZO_DSC
                      ,'' ORGZ_CFC
                      ,'Y' UYN
                      ,'N' LWST_ORGZ_YN
                      ,'N' RCSA_ORGZ_YN
                      ,'N' KRI_ORGZ_YN
                      ,'N' LSS_ORGZ_YN
                      ,'N' ANW_YN
                      ,'N' TEMGR_DCZ_YN
                      ,SYSDATE FIR_INP_DTM
                      ,'SYSTEM' FIR_INPMN_ENO
                      ,SYSDATE LSCHG_DTM
                      ,'SYSTEM' LS_WKR_ENO
                      FROM DUAL
                      UNION ALL
                      SELECT
                      NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
                      ,'SHBR' BRC
                      ,'������' BRNM
                      ,'' LVL_NO
                      ,'SHBK' UP_BRC
                      ,'N' BR_LKO_YN
                      ,'' RGN_C
                      ,'' HURSAL_BR_FORM_C
                      ,'13' HOFC_BIZO_DSC
                      ,'' ORGZ_CFC
                      ,'Y' UYN
                      ,'N' LWST_ORGZ_YN
                      ,'N' RCSA_ORGZ_YN
                      ,'N' KRI_ORGZ_YN
                      ,'N' LSS_ORGZ_YN
                      ,'N' ANW_YN
                      ,'N' TEMGR_DCZ_YN
                      ,SYSDATE FIR_INP_DTM
                      ,'SYSTEM' FIR_INPMN_ENO
                      ,SYSDATE LSCHG_DTM
                      ,'SYSTEM' LS_WKR_ENO
                      FROM DUAL
                      UNION ALL
                      SELECT DISTINCT
                       NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
                      ,A.BRC
                      ,A.BRNM
                      ,'' LVL_NO
                      ,CASE WHEN B.MO_BRNO = A.BRC AND A.HOFC_BIZO_DSC = '10' THEN 'SHHQ'
                            WHEN B.MO_BRNO = A.BRC AND A.HOFC_BIZO_DSC = '20' THEN 'SHBR'
                            ELSE 'SHHQ'
                        END UP_BRC
                      ,'N' BR_LKO_YN
                      ,B.ARCD RGN_C
                      ,'' HURSAL_BR_FORM_C
                      ,CASE WHEN A.HOFC_BIZO_DSC = '20' THEN '03' ELSE '02' END HOFC_BIZO_DSC
                      ,'' ORGZ_CFC
                      ,'Y' UYN
                      ,CASE WHEN A.HOFC_BIZO_DSC = '20' THEN 'Y' ELSE 'N' END  LWST_ORGZ_YN
                      ,'Y' RCSA_ORGZ_YN
                      ,'Y' KRI_ORGZ_YN
                      ,'Y' LSS_ORGZ_YN
                      ,'N' ANW_YN
                      ,CASE WHEN A.HOFC_BIZO_DSC = '10' THEN 'Y' ELSE 'N' END TEMGR_DCZ_YN
                      ,SYSDATE FIR_INP_DTM
                      ,'SYSTEM' FIR_INPMN_ENO
                      ,SYSDATE LSCHG_DTM
                      ,'SYSTEM' LS_WKR_ENO
                      FROM
                      (SELECT DISTINCT TRIM("����ȣ") BRC ,MIN(TRIM("����")) BRNM ,TRIM("�������ڵ�") HOFC_BIZO_DSC
                      FROM DWZOWN."TB_MDWT�߾�ȸ�λ�"
                      WHERE "�ۼ�������" = TRIM(P_BASEDAY)
                        AND TRIM("�����и�") = '��������'
                        AND TRIM("�������и�") = '����'
                        AND TRIM("�������и�") = '������'
                        AND TRIM("����ȣ") IS NOT NULL
                      GROUP BY "����ȣ","�������ڵ�"
                      ) A
                      ,DWZOWN.TB_SOR_CMI_BR_BC B
                      WHERE A.BRC = B.BRNO
                      ) START WITH LVL_NO = '0'
                        CONNECT BY PRIOR BRC = UP_BRC					
                        ORDER SIBLINGS BY BRC	
                      ;
                    
                    
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows inserted(����)');
                
                DBMS_OUTPUT.PUT_LINE('���ڵ� BRC ���� ����');
				INSERT INTO OPEOWN.TB_OR_OM_ORGZ
					SELECT DISTINCT
					 NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
					,DECODE(A."���ڵ�",NULL,C."���ڵ�",A."���ڵ�") BRC
					,DECODE(A."����",NULL,C."����",A."����") BRNM
					,MAX(B.LVL_NO)+1 LVL_NO
					,DECODE(A."����ȣ",NULL,C."����ȣ",A."����ȣ") UP_BRC
					,'N' BR_LKO_YN 
					,B.RGN_C
					,B.HURSAL_BR_FORM_C
					,B.HOFC_BIZO_DSC
					,B.ORGZ_CFC
					,'Y' UYN
					,'Y' LWST_ORGZ_YN
					,'Y' RCSA_ORGZ_YN
					,'Y' KRI_ORGZ_YN
					,'Y' LSS_ORGZ_YN
					,'N' ANW_YN
					,'Y' TEMGR_DCZ_YN
					,SYSDATE FIR_INP_DTM
					,'SYSTEM' FIR_INPMN_ENO
					,SYSDATE LSCHG_DTM
					,'SYSTEM' LS_WKR_ENO
					FROM 
                    DWZOWN."TB_MDWT�߾�ȸ�λ�" A
				   ,OPEOWN.TB_OR_OM_ORGZ B
                   ,DWZOWN."TB_MDWT�λ�" C
					WHERE TRIM(A."�ۼ�������") = TRIM(P_BASEDAY)
					  AND DECODE(TRIM(A."����ȣ"),NULL,TRIM(C."����ȣ"),TRIM(A."����ȣ")) = B.BRC
                      AND TRIM(A."�ۼ�������") = TRIM(C."�ۼ�������")
                      AND TRIM(A."���") = TRIM(C."���")
					  AND B.HOFC_BIZO_DSC = '02'
				      AND B.BR_LKO_YN = 'N' /* �����ũ ���κμ� ��� ���� */
					GROUP BY A."����ȣ",A."���ڵ�",A."����",C."����ȣ",C."���ڵ�",C."����",B.RGN_C,B.HOFC_BIZO_DSC,B.ORGZ_CFC,B.HURSAL_BR_FORM_C 	
				;
				P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows inserted(��)');
                COMMIT;
				
                --SP_INS_ETLLOG('TB_OR_OM_ORGZ_����',P_BASEDAY,P_LD_CN,'����');
                
                ELSE
                  /*�������Ȯ��*/
                   UPDATE OPEOWN.TB_OR_OM_ORGZ A SET A.BR_LKO_YN ='Y' , UYN = 'N' , RCSA_ORGZ_YN = 'N' , KRI_ORGZ_YN = 'N' , LSS_ORGZ_YN = 'N',
                   								     LSCHG_DTM = SYSDATE , LS_WKR_ENO = 'SYSTEM'
       				WHERE BRC IN 
       				     (
        					SELECT A.BRC FROM 
       						   OPEOWN.TB_OR_OM_ORGZ A
					          ,(SELECT DISTINCT
					                B.BRNO BRC
					                  FROM
					                  DWZOWN.TB_SOR_CMI_BR_BC B
					               WHERE B.CLBR_DT IS NOT NULL
					            ) B
					       WHERE A.BRC = B.BRC (+)
					         AND LVL_NO NOT IN ('0','1')
					         AND B.BRC IS NOT NULL
					         AND A.BR_LKO_YN = 'N'
					     );
                	P_LD_CN := SQL%ROWCOUNT;
                	DBMS_OUTPUT.PUT_LINE('������� : '||P_LD_CN || '��');
                	
                	
                	/* ���� UPDATE �� �ű����� INSERT */
                	MERGE INTO OPEOWN.TB_OR_OM_ORGZ A
                          USING 
                               	(	SELECT 
                               			 GRP_ORG_C,BRC,BRNM,LEVEL-1 LVL_NO,UP_BRC,BR_LKO_YN,RGN_C,HURSAL_BR_FORM_C,HOFC_BIZO_DSC,ORGZ_CFC,UYN,
                               			 LWST_ORGZ_YN,RCSA_ORGZ_YN,KRI_ORGZ_YN,LSS_ORGZ_YN,ANW_YN,TEMGR_DCZ_YN,
                              			 FIR_INP_DTM,FIR_INPMN_ENO,LSCHG_DTM,LS_WKR_ENO
  	                        		FROM
  	                        		(
                                         SELECT 
                                           NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
                                           ,'SHBK' BRC
                                           ,'��������' BRNM
                                           ,'0' LVL_NO
                                           ,'' UP_BRC
                                           ,'N' BR_LKO_YN
                                           ,'' RGN_C
                                           ,'' HURSAL_BR_FORM_C
                                           ,'01' HOFC_BIZO_DSC
                                           ,'' ORGZ_CFC
                                           ,'Y' UYN
                                           ,'N' LWST_ORGZ_YN
                                           ,'N' RCSA_ORGZ_YN
                                           ,'N' KRI_ORGZ_YN
                                           ,'N' LSS_ORGZ_YN
                                           ,'N' ANW_YN
                                           ,'N' TEMGR_DCZ_YN
                                           ,SYSDATE FIR_INP_DTM
                                           ,'SYSTEM' FIR_INPMN_ENO
                                           ,SYSDATE LSCHG_DTM
                                           ,'SYSTEM' LS_WKR_ENO
                                           FROM DUAL
                                        UNION ALL
                                           SELECT 
                                           NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
                                           ,'SHHQ' BRC
                                           ,'���κμ�' BRNM
                                           ,'' LVL_NO
                                           ,'SHBK' UP_BRC
                                           ,'N' BR_LKO_YN
                                           ,'' RGN_C
                                           ,'' HURSAL_BR_FORM_C
                                           ,'12' HOFC_BIZO_DSC
                                           ,'' ORGZ_CFC
                                           ,'Y' UYN
                                           ,'N' LWST_ORGZ_YN
                                           ,'N' RCSA_ORGZ_YN
                                           ,'N' KRI_ORGZ_YN
                                           ,'N' LSS_ORGZ_YN
                                           ,'N' ANW_YN
                                           ,'N' TEMGR_DCZ_YN
                                           ,SYSDATE FIR_INP_DTM
                                           ,'SYSTEM' FIR_INPMN_ENO
                                           ,SYSDATE LSCHG_DTM
                                           ,'SYSTEM' LS_WKR_ENO
                                           FROM DUAL
                                        UNION ALL
                                           SELECT
                                           NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
                                           ,'SHBR' BRC
                                           ,'������' BRNM
                                           ,'' LVL_NO
                                           ,'SHBK' UP_BRC
                                           ,'N' BR_LKO_YN
                                           ,'' RGN_C
                                           ,'' HURSAL_BR_FORM_C
                                           ,'13' HOFC_BIZO_DSC
                                           ,'' ORGZ_CFC
                                           ,'Y' UYN
                                           ,'N' LWST_ORGZ_YN
                                           ,'N' RCSA_ORGZ_YN
                                           ,'N' KRI_ORGZ_YN
                                           ,'N' LSS_ORGZ_YN
                                           ,'N' ANW_YN
                                           ,'N' TEMGR_DCZ_YN
                                           ,SYSDATE FIR_INP_DTM
                                           ,'SYSTEM' FIR_INPMN_ENO
                                           ,SYSDATE LSCHG_DTM
                                           ,'SYSTEM' LS_WKR_ENO
                                           FROM DUAL
                                         UNION ALL
                                           SELECT DISTINCT
                                            NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
                                           ,A.BRC
                                           ,A.BRNM
                                           ,'' LVL_NO
                                           ,CASE WHEN B.MO_BRNO = A.BRC AND A.HOFC_BIZO_DSC = '10' THEN 'SHHQ'
                                                 WHEN B.MO_BRNO = A.BRC AND A.HOFC_BIZO_DSC = '20' THEN 'SHBR'
                                                 ELSE B.MO_BRNO
                                             END UP_BRC
                                           ,'N' BR_LKO_YN
                                           ,B.ARCD RGN_C
                                           ,'' HURSAL_BR_FORM_C
                                           ,CASE WHEN A.HOFC_BIZO_DSC = '20' THEN '03' ELSE '02' END HOFC_BIZO_DSC /*20 -> EDW�������ڵ� / �����ũ  03 */
                                           ,'' ORGZ_CFC
                                           ,'Y' UYN
                                           ,CASE WHEN A.HOFC_BIZO_DSC = '20' THEN 'Y' ELSE 'N' END  LWST_ORGZ_YN
                                           ,'Y' RCSA_ORGZ_YN
                                           ,'Y' KRI_ORGZ_YN
                                           ,'Y' LSS_ORGZ_YN
                                           ,'Y' ANW_YN
                                           ,CASE WHEN A.HOFC_BIZO_DSC = '10' THEN 'Y' ELSE 'N' END TEMGR_DCZ_YN
                                           ,SYSDATE FIR_INP_DTM
                                           ,'SYSTEM' FIR_INPMN_ENO
                                           ,SYSDATE LSCHG_DTM
                                           ,'SYSTEM' LS_WKR_ENO
                                           FROM
                                           (SELECT DISTINCT TRIM("����ȣ") BRC ,MIN(TRIM("����")) BRNM ,TRIM("�������ڵ�") HOFC_BIZO_DSC
                                           FROM DWZOWN."TB_MDWT�߾�ȸ�λ�"
                                           WHERE "�ۼ�������" = TRIM(P_BASEDAY)
                                             AND TRIM("�����и�") = '��������'
                                             AND TRIM("�������и�") = '����'
                                             AND TRIM("�������и�") = '������'
                                             AND TRIM("����ȣ") IS NOT NULL
                                           GROUP BY "����ȣ","�������ڵ�"
                                           ) A
                                           ,DWZOWN.TB_SOR_CMI_BR_BC B
                                           WHERE A.BRC = B.BRNO
                                           ) START WITH LVL_NO = '0'
                                             CONNECT BY PRIOR BRC = UP_BRC					
                                             ORDER SIBLINGS BY BRC	
                               ) B
                             ON (A.BRC = B.BRC)
                            WHEN MATCHED THEN 
                             UPDATE SET A.BRNM = B.BRNM,
                                        A.UP_BRC = B.UP_BRC,
                                        A.RGN_C = B.RGN_C,
                                        A.HOFC_BIZO_DSC = B.HOFC_BIZO_DSC,
                                        A.LWST_ORGZ_YN = B.LWST_ORGZ_YN,
                                        A.BR_LKO_YN = B.BR_LKO_YN,
                                        LSCHG_DTM = SYSDATE,
                                        LS_WKR_ENO = 'SYSTEM'
                            WHEN NOT MATCHED THEN
                             INSERT (A.GRP_ORG_C,A.BRC,A.BRNM,A.LVL_NO,A.UP_BRC,A.BR_LKO_YN,A.RGN_C,A.HURSAL_BR_FORM_C,
                                     A.HOFC_BIZO_DSC,A.ORGZ_CFC,A.UYN,A.LWST_ORGZ_YN,A.RCSA_ORGZ_YN,A.KRI_ORGZ_YN,
                                     A.LSS_ORGZ_YN,A.ANW_YN,A.TEMGR_DCZ_YN,A.FIR_INP_DTM,A.FIR_INPMN_ENO,A.LSCHG_DTM,A.LS_WKR_ENO
                                    )
                             VALUES (B.GRP_ORG_C,B.BRC,B.BRNM,B.LVL_NO,B.UP_BRC,B.BR_LKO_YN,B.RGN_C,B.HURSAL_BR_FORM_C,
                                     B.HOFC_BIZO_DSC,B.ORGZ_CFC,B.UYN,B.LWST_ORGZ_YN,B.RCSA_ORGZ_YN,B.KRI_ORGZ_YN,
                                     B.LSS_ORGZ_YN,B.ANW_YN,B.TEMGR_DCZ_YN,B.FIR_INP_DTM,B.FIR_INPMN_ENO,B.LSCHG_DTM,B.LS_WKR_ENO
                                    )
                            ;
                	P_LD_CN := SQL%ROWCOUNT;
                	
                            SELECT COUNT(ANW_YN)
                              INTO P_NEWORGZ
                              FROM OPEOWN.TB_OR_OM_ORGZ
                             WHERE ANW_YN = 'Y';
                            
                    DBMS_OUTPUT.PUT_LINE('�ű�����: '||P_NEWORGZ || '��');         
                    
                	DBMS_OUTPUT.PUT_LINE('���� UPDATE�Ǽ� : '||TO_CHAR(P_LD_CN-P_NEWORGZ)|| '��');
                	
                	
                	/* �� UPDATE �� �ű��� INSERT */
                	MERGE INTO OPEOWN.TB_OR_OM_ORGZ A
                          USING 
                               	(	
                                      SELECT 
					                     NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='��������'),'01') GRP_ORG_C --�׷����ڵ�
					                     ,DECODE(A."���ڵ�",NULL,C."���ڵ�",A."���ڵ�") BRC
					                     ,DECODE(A."����",NULL,C."����",A."����") BRNM
					                     ,MAX(B.LVL_NO)+1 LVL_NO
					                     ,DECODE(A."����ȣ",NULL,C."����ȣ",A."����ȣ") UP_BRC
										 ,'N' BR_LKO_YN 
										 ,B.RGN_C
										 ,B.HURSAL_BR_FORM_C
										 ,B.HOFC_BIZO_DSC
										 ,B.ORGZ_CFC
										 ,'Y' UYN
										 ,'Y' LWST_ORGZ_YN
										 ,'Y' RCSA_ORGZ_YN
										 ,'Y' KRI_ORGZ_YN
										 ,'Y' LSS_ORGZ_YN
										 ,'N' ANW_YN
										 ,'Y' TEMGR_DCZ_YN
										 ,SYSDATE FIR_INP_DTM
										 ,'SYSTEM' FIR_INPMN_ENO
										 ,SYSDATE LSCHG_DTM
										 ,'SYSTEM' LS_WKR_ENO
										 FROM 
										  DWZOWN."TB_MDWT�߾�ȸ�λ�" A
										 ,OPEOWN.TB_OR_OM_ORGZ B
                                         ,DWZOWN."TB_MDWT�λ�" C
										 WHERE TRIM(A."�ۼ�������") = TRIM(P_BASEDAY)
										   AND DECODE(TRIM(A."����ȣ"),NULL,TRIM(C."����ȣ"),TRIM(A."����ȣ")) = B.BRC
                                           AND TRIM(A."�ۼ�������") = TRIM(C."�ۼ�������")
                                           AND TRIM(A."���") = TRIM(C."���")
										   AND B.HOFC_BIZO_DSC = '02'
										   AND B.BR_LKO_YN = 'N' /* �����ũ ���κμ� ��� ���� */
										 GROUP BY A."����ȣ",A."���ڵ�",A."����",B.RGN_C,B.HOFC_BIZO_DSC,B.ORGZ_CFC,B.HURSAL_BR_FORM_C 	
                               ) B
                             ON (A.BRC = B.BRC)
                            WHEN MATCHED THEN 
                             UPDATE SET A.BRNM = B.BRNM,
                                        A.UP_BRC = B.UP_BRC,
                                        A.RGN_C = B.RGN_C,
                                        A.HOFC_BIZO_DSC = B.HOFC_BIZO_DSC,
                                        A.LWST_ORGZ_YN = B.LWST_ORGZ_YN,
                                        A.BR_LKO_YN = B.BR_LKO_YN,
                                        LSCHG_DTM = SYSDATE,
                                        LS_WKR_ENO = 'SYSTEM'
                            WHEN NOT MATCHED THEN
                             INSERT (A.GRP_ORG_C,A.BRC,A.BRNM,A.LVL_NO,A.UP_BRC,A.BR_LKO_YN,A.RGN_C,A.HURSAL_BR_FORM_C,
                                     A.HOFC_BIZO_DSC,A.ORGZ_CFC,A.UYN,A.LWST_ORGZ_YN,A.RCSA_ORGZ_YN,A.KRI_ORGZ_YN,
                                     A.LSS_ORGZ_YN,A.ANW_YN,A.TEMGR_DCZ_YN,A.FIR_INP_DTM,A.FIR_INPMN_ENO,A.LSCHG_DTM,A.LS_WKR_ENO
                                    )
                             VALUES (B.GRP_ORG_C,B.BRC,B.BRNM,B.LVL_NO,B.UP_BRC,B.BR_LKO_YN,B.RGN_C,B.HURSAL_BR_FORM_C,
                                     B.HOFC_BIZO_DSC,B.ORGZ_CFC,B.UYN,B.LWST_ORGZ_YN,B.RCSA_ORGZ_YN,B.KRI_ORGZ_YN,
                                     B.LSS_ORGZ_YN,B.ANW_YN,B.TEMGR_DCZ_YN,B.FIR_INP_DTM,B.FIR_INPMN_ENO,B.LSCHG_DTM,B.LS_WKR_ENO
                                    )
                            ;
                	P_LD_CN := SQL%ROWCOUNT;  
                    
                	DBMS_OUTPUT.PUT_LINE('�� ������Ʈ : '||P_LD_CN || '��');
                	
                	
                	
                	COMMIT;
                END IF;
          ELSE
                DBMS_OUTPUT.PUT_LINE('�߾�ȸ�λ����̺� ����������� �� �Ǽ� : '||P_BASECNT);
                DBMS_OUTPUT.PUT_LINE('DW�߾�ȸ�λ� ���̺� �����Ͱ� ���� ������ ���� �ʽ��ϴ�.DW�߾�ȸ �λ� ���̺��� Ȯ�� �� �ּ���');

                RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT