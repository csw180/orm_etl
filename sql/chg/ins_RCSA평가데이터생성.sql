/*
        프로그램명 : ins_RCSA평가데이터 생성
        타켓테이블 : TB_OR_RM_RCSA
        최조작성자 : 박승윤
*/
DECLARE
        P_DTDATE   VARCHAR2(8);  -- 기준일자
        P_RUNDATE  VARCHAR2(8);  -- 실행일자(TB_OR_OM_SCHD 실행일자)
        P_BASYM    VARCHAR2(6);  -- 기준년월
        P_BASECNT  NUMBER;  -- 실행기준건수
        P_LD_CN    NUMBER;  -- 로딩건수
        P_RKSLT_CN NUMBER;
        P_DUMMY	   VARCHAR2(8);

BEGIN
  SELECT  NXT_DT
  INTO    P_DTDATE
  FROM    OPEOWN.TB_OPE_DT_BC
  ;

               
   SELECT NVL(A.RK_EVL_ST_DT,B.DUMMY) RK_EVL_ST_DT
        ,A.BAS_YM
        ,B.DUMMY
    INTO P_RUNDATE
        ,P_BASYM
        ,P_DUMMY
    FROM 
  (SELECT A.RK_EVL_ST_DT
        ,A.BAS_YM
        ,'99991231' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE RK_EVL_TGT_YN = 'Y' 
     AND RK_EVL_PRG_STSC = '01' --평가중에 다른업무 재작업시 날라가는 위험 방지
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE RK_EVL_TGT_YN = 'Y' 
               )
  ) A
  ,(SELECT 99991231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;
  
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :기준일 : '||P_DTDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :기준일 : '||P_RUNDATE);
        	

          IF P_DTDATE = P_RUNDATE  THEN

          
          
          		
                DBMS_OUTPUT.PUT_LINE('기준일 일치 평가데이터 생성을 시작합니다.');
				
                SELECT COUNT(*)
                  INTO P_RKSLT_CN
                  FROM OPEOWN.TB_OR_RH_RKI
                
               	IF P_RKSLT_CN = 0
                
                DELETE FROM OPEOWN.TB_OR_RM_EVL
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_RH_EVL_DCZ
                      WHERE BAS_YM = P_BASYM
                       ;
                
                INSERT INTO OPEOWN.TB_OR_RM_EVL
(GRP_ORG_C,BAS_YM,OPRK_RKP_ID,BRC,EVL_OBJ_YN,EVL_CPL_YN,DCZ_SQNO,FIR_INP_DTM,FIR_INPMN_ENO,LSCHG_DTM,LS_WKR_ENO)
SELECT 
A.GRP_ORG_C,D.BAS_YM,A.OPRK_RKP_ID,B.BRC,'Y','N','0',SYSDATE,'SYSTEM',SYSDATE,'SYSTEM'FROM
 OPEOWN.TB_OR_RM_RKP A
,OPEOWN.TB_OR_RH_BRC B
,OPEOWN.TB_OR_OM_ORGZ C
,OPEOWN.TB_OR_RH_RKSLT D
WHERE A.OPRK_RKP_ID = B.OPRK_RKP_ID
  AND C.HOFC_BIZO_DSC = '02'
  AND B.BRC = C.BRC
  AND D.OPRK_RKP_ID = A.OPRK_RKP_ID
  AND D.BAS_YM = P_BASYM
  AND D.EVL_OBJ_YN = 'Y'
  AND A.VLD_YN = 'Y'
UNION
SELECT 
A.GRP_ORG_C,D.BAS_YM,A.OPRK_RKP_ID,E.BRC,'Y','N','0',SYSDATE,'SYSTEM',SYSDATE,'SYSTEM'FROM
 OPEOWN.TB_OR_RM_RKP A
,OPEOWN.TB_OR_RH_BRC B
,OPEOWN.TB_OR_OM_ORGZ C
,OPEOWN.TB_OR_RH_RKSLT D
,(SELECT BRC FROM OPEOWN.TB_OR_OM_ORGZ WHERE HOFC_BIZO_DSC = '03' AND UYN='Y' ) E
WHERE A.OPRK_RKP_ID = B.OPRK_RKP_ID
  AND C.HOFC_BIZO_DSC = '13'
  AND B.BRC = C.BRC
  AND D.OPRK_RKP_ID = A.OPRK_RKP_ID
  AND D.BAS_YM = P_BASYM
  AND D.EVL_OBJ_YN = 'Y'
  AND A.VLD_YN = 'Y'
                ;
  
--전분기 값 UPDATE
MERGE INTO OPEOWN.TB_OR_RM_EVL A
USING (SELECT B.OPRK_RKP_ID
             ,B.BRC
             ,B.FRQ_EVL_C
             ,B.IFN_EVL_C
             ,B.NIFN_EVL_C
             ,B.RK_EVL_GRD_C
             ,B.CTL_DSG_EVL_C
             ,B.CTL_MNGM_EVL_C
             ,B.CTEV_GRD_C
             ,B.RMN_RSK_GRD_C
       FROM OPEOWN.TB_OR_RM_EVL B
      WHERE B.BAS_YM = (SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_RM_EVL WHERE BAS_YM < P_BASYM) 
      ) B
ON (A.OPRK_RKP_ID = B.OPRK_RKP_ID AND A.BRC = B.BRC AND A.BAS_YM = P_BASYM)
WHEN MATCHED THEN UPDATE SET       
              A.RBF_FRQ_EVL_C      = B.FRQ_EVL_C      
             ,A.RBF_IFN_EVL_C      = B.IFN_EVL_C      
             ,A.RBF_NIFN_EVL_C     = B.NIFN_EVL_C     
             ,A.RBF_RK_EVL_GRD_C   = B.RK_EVL_GRD_C   
             ,A.RBF_CTEV_GRD_C     = B.CTEV_GRD_C     
             ,A.RBF_RMN_RSK_GRD_C  = B.RMN_RSK_GRD_C  
                
                ;
                
INSERT INTO OPEOWN.TB_OR_RH_EVL_DCZ
SELECT '01',BAS_YM,OPRK_RKP_ID,BRC,DCZ_SQNO,TO_CHAR(SYSDATE,'YYYYMMDD'),'','01','','','',SYSDATE,'SYSTEM',SYSDATE,'SYSTEM' 
 FROM  OPEOWN.TB_OR_RM_EVL
WHERE BAS_YM = P_BASYM            
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 평가데이터 생성');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD_PLAN SET RK_EVL_PRG_STSC ='02'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 스케쥴 플랜 테이블 평가중으로 업데이트');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD SET RK_EVL_PRG_STSC ='02'
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