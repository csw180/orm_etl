/*
        프로그램명 : ins_KRI월말및평가대상데이터생성
        타켓테이블 : TB_OR_KN_RKIMM , TB_OR_KN_BRCMM , TB_OR_KH_RKISLT
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

                DBMS_OUTPUT.PUT_LINE('기준일 일치 월말및평가대상데이터생성 생성을 시작합니다.');

               

                
               
                
                
                DELETE FROM OPEOWN.TB_OR_KN_RKIMM A
                      WHERE A.BAS_YM = P_BASYM
                      ;
                INSERT INTO OPEOWN.TB_OR_KN_RKIMM
                (
				SELECT 
				 GRP_ORG_C
				,OPRK_RKI_ID
				,P_BASYM BAS_YM
				,OPRK_RKINM
				,RKI_ATTR_C
				,RKI_LVL_C
				,RKI_OBV_CNTN
				,RKI_DEF_CNTN
				,IDX_FML_CNTN
				,RKI_UNT_C
				,RPT_FQ_DSC
				,KRI_LMT_DSC
				,LMT_CHG_CNTN
				,COM_COL_PSB_YN
				,KRI_YN
				,GU_DRTN_RER_DSC
				,PSN_KRI_YN
				,VLD_YN
				,VLD_ST_DT
				,VLD_ED_DT
				,SYSDATE
				,'SYSTEM'
				,SYSDATE
				,'SYSTEM'
				FROM OPEOWN.TB_OR_KM_RKI
				);    
                      
           
				P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 월말 데이터(KRI) 생성');
				
                
				DELETE FROM OPEOWN.TB_OR_KN_BRCMM A
                      WHERE A.BAS_YM = P_BASYM
                      ;
                
                INSERT INTO OPEOWN.TB_OR_KN_BRCMM
                (
				SELECT 
				 GRP_ORG_C
				,OPRK_RKI_ID
				,P_BASYM BAS_YM
				,BRC
				,SYSDATE
				,'SYSTEM'
				,SYSDATE
				,'SYSTEM'
				FROM OPEOWN.TB_OR_KH_BRC    
                );      
           
				P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 월말 데이터(BRC) 생성');
                
                
                DELETE OPEOWN.TB_OR_KH_RKISLT WHERE BAS_YM = P_BASYM;
                INSERT INTO OPEOWN.TB_OR_KH_RKISLT
                (
						SELECT 
						      '01' GRP_ORG_C
						      ,C.BAS_YM
						      ,A.OPRK_RKI_ID
						      ,CASE WHEN B.AMN_MM IS NULL THEN 'N'
						            WHEN A.KRI_YN = 'N' THEN 'N'
						            ELSE 'Y'
						        END KRI_EVL_TGT_YN
						      ,SYSDATE
						      ,'SYSTEM'
						      ,SYSDATE
						      ,'SYSTEM'
						  FROM 
						  OPEOWN.TB_OR_KM_RKI A
						 ,OPEOWN.TB_OR_OM_FQ B
						 ,OPEOWN.TB_OR_OM_SCHD C
						WHERE A.RPT_FQ_DSC = B.RPT_FQ_DSC (+)
						  AND SUBSTR(C.BAS_YM,5,2) = B.AMN_MM (+)
						  AND C.BAS_YM = P_BASYM
						  AND A.VLD_YN = 'Y'
                
                );
                
                P_LD_CN := SQL%ROWCOUNT;
                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 (RKISLT) 생성');
                
                
                UPDATE OPEOWN.TB_OR_KM_RKI 
                   SET LMT_CHG_CNTN =''
                     ,LSCHG_DTM = SYSDATE
                     ,LS_WKR_ENO = 'SYSTEM'

                ;
                
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 LMT_CHG_CNTN NULL 업데이트');
                
                
                UPDATE OPEOWN.TB_OR_OM_SCHD_PLAN 
                  SET RKI_PRG_STSC ='02'
                  	  ,LSCHG_DTM = SYSDATE
                     ,LS_WKR_ENO = 'SYSTEM'
                WHERE BAS_YM = P_BASYM 
                ;
                
       			
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 스케쥴 플랜 테이블 평가중으로 업데이트');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD
                   SET RKI_PRG_STSC ='02'
                  	  ,LSCHG_DTM = SYSDATE
                      ,LS_WKR_ENO = 'SYSTEM'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 스케쥴테이블 평가중으로 업데이트');
                
                
                COMMIT;
                
          ELSE
                DBMS_OUTPUT.PUT_LINE('실행일자와 일치하지 않습니다.');

             --   RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT