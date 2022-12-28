/*
        프로그램명 : ins_TB_OR_OM_EMP_인사
        타켓테이블 : TB_OR_OM_EMP,TB_OR_OH_EMP_AUTH,TB_OR_OH_ORGZ_EMP_AUTH,TB_OR_OM_SSO_INF
        최조작성자 : 박승윤
*/
DECLARE
        P_BASEDAY  VARCHAR2(8);  -- 기준일자
        P_BASECNT  NUMBER;  -- 실행기준건수
        P_EMPCNT   NUMBER;  -- 인사테이블 건수
        P_NEWEMP   NUMBER;  -- 신규 인사 건수
        P_LD_CN    NUMBER;  -- 로딩건수
        P_N_ORGZ_EMP NUMBER; -- 운영리스크조직이 아닌 곳에 소속되있는 직원 수
		P_N_ORGZ_EMP_CNT NUMBER; -- 운영리스크 조직으로 업데이트 한 직원 수
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

                DBMS_OUTPUT.PUT_LINE('DW중앙회인사테이블 데이터 존재, 인사 배치 시작');
                
                SELECT COUNT(ENO)
                  INTO P_EMPCNT
                  FROM OPEOWN.TB_OR_OM_EMP;
                  
                  /*인사 배치 시작*/
                  IF P_EMPCNT = 0 THEN 
                
                     DBMS_OUTPUT.PUT_LINE('TB_OR_OM_EMP 테이블 건수 '||P_EMPCNT||'건 운영리스크 인사 전체 재생성');
                    
                    /*인사 미존재시 재생성 EMP테이블*/
                    INSERT INTO OPEOWN.TB_OR_OM_EMP (GRP_ORG_C,ENO,BRC,TMS_BRC,CHRG_EMPNM,HDOF_RTR_DSC,PZCC,OFT_C,TEAM_CD,ADOP_DT,
							APNT_DT,RTR_DT,OFFC_TEL_CNTN,GNAF_CHRR_YN,OPRK_AMN_YN,LS_CONN_DTM,USR_IPADR,FIR_INP_DTM,
							FIR_INPMN_ENO,LSCHG_DTM,LS_WKR_ENO)
                  SELECT NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
				      ,TRIM(A."사번") ENO
				      ,DECODE(TRIM(A."점번호"),NULL,TRIM((B."점번호")),TRIM(A."점번호")) BRC
				      ,DECODE(TRIM(A."점번호"),NULL,TRIM((B."점번호")),TRIM(A."점번호")) TMS_BRC
				      ,TRIM(A."성명") CHRG_EMPNM
				      ,'1' HDOF_RTR_DSC
				      ,TRIM(A."직급코드") PZCC
				      ,TRIM(A."직위코드") OFT_C
				      ,TRIM(A."팀코드") TEAM_CD
				      ,TRIM(A."입사일") ADOP_DT
				      ,TRIM(A."현소속발령일") APNT_DT
				      ,'' RTR_DT
				      ,(SELECT MAX(B.TL_ARCD||'-'||B.TL_TONO||'-'||B.TL_SNO) FROM DWZOWN.TB_SOR_CMI_BR_BC B WHERE DECODE(TRIM(A."점번호"),'',TRIM(B."점번호"),TRIM(A."점번호")) = TRIM(B.BRNO)) OFFC_TEL_CNTN
				      ,'' GNAF_CHRR_YN
				      ,'' OPRK_AMN_YN
				      ,'' LS_CONN_DTM
				      ,'' USR_IPADR
				      ,SYSDATE FIR_INP_DTM
				      ,'SYSTEM' FIR_INPMN_ENO
				      ,SYSDATE LSCHG_DTM
				      ,'SYSTEM' LS_WKR_ENO
				 FROM DWZOWN."TB_MDWT중앙회인사" A
                     ,DWZOWN."TB_MDWT인사" B
				 WHERE A."작성기준일" = TRIM(P_BASEDAY)
				  AND TRIM(A."점구분명") = '수협은행'
				  AND TRIM(A."재직구분명") = '재직'
                  AND TRIM(A."작성기준일") = TRIM(B."작성기준일")
                  AND TRIM(A."사번") = TRIM(B."사번")
				  --AND TRIM("직원구분명") = '정규직'
				  AND TRIM(B."점번호") IS NOT NULL
				  ;
				  
				P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || 'rows inserted to TB_OR_OM_EMP (신규생성)');
		ELSE  
				/* 인사 UPDATE 및 신규직원 INSERT */
				MERGE INTO OPEOWN.TB_OR_OM_EMP A 
                  USING ( 
                  SELECT NVL((SELECT GRP_ORG_C FROM OPEOWN.TB_OR_OM_GRPORG WHERE GRP_ORGNM  ='수협은행'),'01') GRP_ORG_C --그룹기관코드
				      ,TRIM(A."사번") ENO
				      ,CASE WHEN A."점종류코드" IS NULL THEN 'XXXX'
                            ELSE
                       DECODE(TRIM(A."점번호"),NULL,TRIM((B."점번호")),TRIM(A."점번호")) END BRC
                       
				      ,DECODE(TRIM(A."점번호"),NULL,TRIM((B."점번호")),TRIM(A."점번호")) TMS_BRC
				      ,TRIM(A."성명") CHRG_EMPNM
				      ,'1' HDOF_RTR_DSC
				      ,TRIM(A."직급코드") PZCC
				      ,TRIM(A."직위코드") OFT_C
				      ,TRIM(A."팀코드") TEAM_CD
				      ,TRIM(A."입사일") ADOP_DT
				      ,TRIM(A."현소속발령일") APNT_DT
				      ,'' RTR_DT
				      ,(SELECT MAX(B.TL_ARCD||'-'||B.TL_TONO||'-'||B.TL_SNO) FROM DWZOWN.TB_SOR_CMI_BR_BC B WHERE DECODE(TRIM(A."점번호"),'',TRIM(B."점번호"),TRIM(A."점번호")) = TRIM(B.BRNO)) OFFC_TEL_CNTN
				      ,'' GNAF_CHRR_YN
				      ,'' OPRK_AMN_YN
				      ,'' LS_CONN_DTM
				      ,'' USR_IPADR
				      ,SYSDATE FIR_INP_DTM
				      ,'SYSTEM' FIR_INPMN_ENO
				      ,SYSDATE LSCHG_DTM
				      ,'SYSTEM' LS_WKR_ENO
				 FROM DWZOWN."TB_MDWT중앙회인사" A
                     ,DWZOWN."TB_MDWT인사" B
				 WHERE A."작성기준일" = TRIM(P_BASEDAY)
				  AND TRIM(A."점구분명") = '수협은행'
				  AND TRIM(A."재직구분명") = '재직'
                  AND TRIM(A."작성기준일") = TRIM(B."작성기준일")
                  AND TRIM(A."사번") = TRIM(B."사번")
				  --AND TRIM("직원구분명") = '정규직'
				  --AND TRIM(B."점번호") IS NOT NULL
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
                
		        /*퇴직자 UPDATE*/
                MERGE INTO OPEOWN.TB_OR_OM_EMP A
                  USING ( 
                          SELECT TRIM("사번") ENO , TRIM("퇴직일") RTR_DT
				            FROM DWZOWN."TB_MDWT중앙회인사"
				           WHERE "작성기준일" = TRIM(P_BASEDAY)
				             AND TRIM("점구분명") = '수협은행'
				             AND TRIM("재직구분명") = '퇴직'
				             --AND TRIM("직원구분명") = '정규직'
                        ) B
                     ON (A.ENO = B.ENO)
                WHEN MATCHED THEN UPDATE SET A.RTR_DT = B.RTR_DT,
                                             A.HDOF_RTR_DSC = '2',
                                             A.LSCHG_DTM = SYSDATE,
                                             A.LS_WKR_ENO = 'SYSTEM'
                    ;
                
                P_LD_CN := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE('퇴직자 : '||P_LD_CN ||'명');    
         END IF;       
                
         		/*공통*/
         
				/*SSO 테이블*/
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
                
                /*TB_OR_OH_ORGZ_EMP (운영리스크평가조직 테이블 생성)*/
                
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

			    
               /*TB_OR_OH_ORGZ_EMP (실제 살아있는 운영리스크 조직으로  UPDATE)*/
			   /*무한 루프 방지 최대 6번 UPDATE*/
			   
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
  		         	DBMS_OUTPUT.PUT_LINE('운영리스크 조직으로 UPDATE 사원수 : ' || P_N_ORGZ_EMP);
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
				    DBMS_OUTPUT.PUT_LINE('운영리스크 조직으로 UPDATE "'||i||'"회 건수 '||SQL%ROWCOUNT||'건');
  		         END IF;
  		      END LOOP;
  		        
  		       /*운영리스크  일반 사용자 권한 INSERT*/
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
  		         	DBMS_OUTPUT.PUT_LINE('운영리스크 조직별 권한 , 미사용 조직들 삭제 건수 : '||P_LD_CN);
  		         	
               DELETE FROM OPEOWN.TB_OR_OH_ORGZ_EMP_AUTH WHERE ENO IN (SELECT ENO FROM OPEOWN.TB_OR_OM_EMP WHERE HDOF_RTR_DSC = '2');
                    P_LD_CN := SQL%ROWCOUNT;
  		         	DBMS_OUTPUT.PUT_LINE('운영리스크 조직별 권한 , 퇴직자 삭제 건수 : '||P_LD_CN);
               
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

                DBMS_OUTPUT.PUT_LINE('일반 사용자 권한 INSERT 건수 : '||P_LD_CN);
                COMMIT;
         ELSE
                DBMS_OUTPUT.PUT_LINE('중앙회인사테이블 실행기준일자 총 건수 : '||P_BASECNT);
                DBMS_OUTPUT.PUT_LINE('DW중앙회인사 테이블에 데이터가 없어 실행을 하지 않습니다.DW중앙회 인사 테이블을 확인 해 주세요');
 
                RAISE NO_DATA_FOUND;
              
          END IF;       
              
END
;
/
EXIT