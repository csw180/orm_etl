/*
        프로그램명 : ins_TB_OR_OM_ORGZ_조직
        타켓테이블 : TB_OR_OM_ORGZ
        최조작성자 : 박승윤
*/
DECLARE
        P_BASEDAY  VARCHAR2(8);  -- 기준일자
        P_BASECNT  NUMBER;  -- 실행기준건수
        P_ORGZCNT  NUMBER;  -- 조직테이블 건수
        P_NEWORGZ  NUMBER;  -- 신규 조직 건수
        P_LD_CN    NUMBER;  -- 로딩건수

BEGIN
        SELECT TO_CHAR(SYSDATE,'YYYYMMDD') 
          INTO P_BASEDAY
          FROM DUAL;
  
        DBMS_OUTPUT.PUT_LINE('실행기준일 : '||P_BASEDAY);
        
        SELECT  COUNT(사번)
          INTO    P_BASECNT
          FROM    DWZOWN."TB_MDWT중앙회인사"
         WHERE   작성기준일  = TRIM(P_BASEDAY);


          IF P_BASECNT > 0  THEN

                DBMS_OUTPUT.PUT_LINE('DW중앙회인사테이블 데이터 존재, 조직 배치 시작');
                
                SELECT COUNT(BRC)
                  INTO P_ORGZCNT
                  FROM OPEOWN.TB_OR_OM_ORGZ;
                  
                  /*조직 배치 시작*/
                  IF P_ORGZCNT = 0 THEN 
                
                     DBMS_OUTPUT.PUT_LINE('TB_OR_OM_ORGZ 테이블 건수 '||P_ORGZCNT||'건 운영리스크 조직 전체 재생성');
                    
                     /*조직 미존재시 재생성*/
                     INSERT INTO OPEOWN.TB_OR_OM_ORGZ
                      SELECT GRP_ORG_C,BRC,BRNM,LEVEL-1 LVL_NO,UP_BRC,BR_LKO_YN,RGN_C,HURSAL_BR_FORM_C,HOFC_BIZO_DSC,ORGZ_CFC,UYN,
                             LWST_ORGZ_YN,RCSA_ORGZ_YN,KRI_ORGZ_YN,LSS_ORGZ_YN,ANW_YN,TEMGR_DCZ_YN,
                             FIR_INP_DTM,FIR_INPMN_ENO,LSCHG_DTM,LS_WKR_ENO
                      FROM
                      (
                      SELECT 
                      NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
                      ,'SHBK' BRC
                      ,'수협은행' BRNM
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
                      NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
                      ,'SHHQ' BRC
                      ,'본부부서' BRNM
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
                      NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
                      ,'SHBR' BRC
                      ,'영업점' BRNM
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
                       NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
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
                      (SELECT DISTINCT TRIM("점번호") BRC ,MIN(TRIM("점명")) BRNM ,TRIM("점종류코드") HOFC_BIZO_DSC
                      FROM DWZOWN."TB_MDWT중앙회인사"
                      WHERE "작성기준일" = TRIM(P_BASEDAY)
                        AND TRIM("점구분명") = '수협은행'
                        AND TRIM("재직구분명") = '재직'
                        AND TRIM("직원구분명") = '정규직'
                        AND TRIM("점번호") IS NOT NULL
                      GROUP BY "점번호","점종류코드"
                      ) A
                      ,DWZOWN.TB_SOR_CMI_BR_BC B
                      WHERE A.BRC = B.BRNO
                      ) START WITH LVL_NO = '0'
                        CONNECT BY PRIOR BRC = UP_BRC					
                        ORDER SIBLINGS BY BRC	
                      ;
                    
                    
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows inserted(조직)');
                
                DBMS_OUTPUT.PUT_LINE('팀코드 BRC 적재 시작');
				INSERT INTO OPEOWN.TB_OR_OM_ORGZ
					SELECT DISTINCT
					 NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
					,DECODE(A."팀코드",NULL,C."팀코드",A."팀코드") BRC
					,DECODE(A."팀명",NULL,C."팀명",A."팀명") BRNM
					,MAX(B.LVL_NO)+1 LVL_NO
					,DECODE(A."점번호",NULL,C."점번호",A."점번호") UP_BRC
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
                    DWZOWN."TB_MDWT중앙회인사" A
				   ,OPEOWN.TB_OR_OM_ORGZ B
                   ,DWZOWN."TB_MDWT인사" C
					WHERE TRIM(A."작성기준일") = TRIM(P_BASEDAY)
					  AND DECODE(TRIM(A."점번호"),NULL,TRIM(C."점번호"),TRIM(A."점번호")) = B.BRC
                      AND TRIM(A."작성기준일") = TRIM(C."작성기준일")
                      AND TRIM(A."사번") = TRIM(C."사번")
					  AND B.HOFC_BIZO_DSC = '02'
				      AND B.BR_LKO_YN = 'N' /* 운영리스크 본부부서 폐쇄 여부 */
					GROUP BY A."점번호",A."팀코드",A."팀명",C."점번호",C."팀코드",C."팀명",B.RGN_C,B.HOFC_BIZO_DSC,B.ORGZ_CFC,B.HURSAL_BR_FORM_C 	
				;
				P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows inserted(팀)');
                COMMIT;
				
                --SP_INS_ETLLOG('TB_OR_OM_ORGZ_조직',P_BASEDAY,P_LD_CN,'조직');
                
                ELSE
                  /*폐쇄조직확인*/
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
                	DBMS_OUTPUT.PUT_LINE('폐쇄조직 : '||P_LD_CN || '건');
                	
                	
                	/* 조직 UPDATE 및 신규조직 INSERT */
                	MERGE INTO OPEOWN.TB_OR_OM_ORGZ A
                          USING 
                               	(	SELECT 
                               			 GRP_ORG_C,BRC,BRNM,LEVEL-1 LVL_NO,UP_BRC,BR_LKO_YN,RGN_C,HURSAL_BR_FORM_C,HOFC_BIZO_DSC,ORGZ_CFC,UYN,
                               			 LWST_ORGZ_YN,RCSA_ORGZ_YN,KRI_ORGZ_YN,LSS_ORGZ_YN,ANW_YN,TEMGR_DCZ_YN,
                              			 FIR_INP_DTM,FIR_INPMN_ENO,LSCHG_DTM,LS_WKR_ENO
  	                        		FROM
  	                        		(
                                         SELECT 
                                           NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
                                           ,'SHBK' BRC
                                           ,'수협은행' BRNM
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
                                           NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
                                           ,'SHHQ' BRC
                                           ,'본부부서' BRNM
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
                                           NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
                                           ,'SHBR' BRC
                                           ,'영업점' BRNM
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
                                            NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
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
                                           ,CASE WHEN A.HOFC_BIZO_DSC = '20' THEN '03' ELSE '02' END HOFC_BIZO_DSC /*20 -> EDW영업점코드 / 운영리스크  03 */
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
                                           (SELECT DISTINCT TRIM("점번호") BRC ,MIN(TRIM("점명")) BRNM ,TRIM("점종류코드") HOFC_BIZO_DSC
                                           FROM DWZOWN."TB_MDWT중앙회인사"
                                           WHERE "작성기준일" = TRIM(P_BASEDAY)
                                             AND TRIM("점구분명") = '수협은행'
                                             AND TRIM("재직구분명") = '재직'
                                             AND TRIM("직원구분명") = '정규직'
                                             AND TRIM("점번호") IS NOT NULL
                                           GROUP BY "점번호","점종류코드"
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
                            
                    DBMS_OUTPUT.PUT_LINE('신규조직: '||P_NEWORGZ || '건');         
                    
                	DBMS_OUTPUT.PUT_LINE('조직 UPDATE건수 : '||TO_CHAR(P_LD_CN-P_NEWORGZ)|| '건');
                	
                	
                	/* 팀 UPDATE 및 신규팀 INSERT */
                	MERGE INTO OPEOWN.TB_OR_OM_ORGZ A
                          USING 
                               	(	
                                      SELECT 
					                     NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
					                     ,DECODE(A."팀코드",NULL,C."팀코드",A."팀코드") BRC
					                     ,DECODE(A."팀명",NULL,C."팀명",A."팀명") BRNM
					                     ,MAX(B.LVL_NO)+1 LVL_NO
					                     ,DECODE(A."점번호",NULL,C."점번호",A."점번호") UP_BRC
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
										  DWZOWN."TB_MDWT중앙회인사" A
										 ,OPEOWN.TB_OR_OM_ORGZ B
                                         ,DWZOWN."TB_MDWT인사" C
										 WHERE TRIM(A."작성기준일") = TRIM(P_BASEDAY)
										   AND DECODE(TRIM(A."점번호"),NULL,TRIM(C."점번호"),TRIM(A."점번호")) = B.BRC
                                           AND TRIM(A."작성기준일") = TRIM(C."작성기준일")
                                           AND TRIM(A."사번") = TRIM(C."사번")
										   AND B.HOFC_BIZO_DSC = '02'
										   AND B.BR_LKO_YN = 'N' /* 운영리스크 본부부서 폐쇄 여부 */
										 GROUP BY A."점번호",A."팀코드",A."팀명",B.RGN_C,B.HOFC_BIZO_DSC,B.ORGZ_CFC,B.HURSAL_BR_FORM_C 	
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
                    
                	DBMS_OUTPUT.PUT_LINE('팀 업데이트 : '||P_LD_CN || '건');
                	
                	
                	
                	COMMIT;
                END IF;
          ELSE
                DBMS_OUTPUT.PUT_LINE('중앙회인사테이블 실행기준일자 총 건수 : '||P_BASECNT);
                DBMS_OUTPUT.PUT_LINE('DW중앙회인사 테이블에 데이터가 없어 실행을 하지 않습니다.DW중앙회 인사 테이블을 확인 해 주세요');

                RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT