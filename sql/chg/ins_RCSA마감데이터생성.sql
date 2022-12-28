/*
        프로그램명 : ins_RCSA마감데이터 생성
        타켓테이블 : TB_OR_RH_ACT
        최조작성자 : 박승윤
*/
DECLARE
        P_DTDATE  VARCHAR2(8);  -- 기준일자
        P_RUNDATE VARCHAR2(8);  -- 실행일자(TB_OR_OM_SCHD 실행일자)
        P_BASYM   VARCHAR2(6);  -- 기준년월
        P_BF_BASYM VARCHAR2(6);
        P_FW_BASYM VARCHAR2(6);
        P_LD_CN    NUMBER;  -- 로딩건수

BEGIN
  SELECT  NXT_DT
  INTO    P_DTDATE
  FROM    OPEOWN.TB_OPE_DT_BC
  ;
  
  SELECT RK_EVL_ED_DT
        ,BAS_YM 
    INTO P_RUNDATE
        ,P_BASYM
    FROM OPEOWN.TB_OR_OM_SCHD 
   WHERE RK_EVL_TGT_YN = 'Y' 
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE RK_EVL_TGT_YN = 'Y' 
               )
               ;
  
  
   
   SELECT BAS_YM 
    INTO P_BF_BASYM
    FROM OPEOWN.TB_OR_OM_SCHD 
   WHERE RK_EVL_TGT_YN = 'Y' 
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE RK_EVL_TGT_YN = 'Y' 
         AND BAS_YM < P_BASYM
               )
               ;
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :기준일 : '||P_DTDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :기준일 : '||P_RUNDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_BASYM :기준년월 : '||P_BASYM);
   
  DBMS_OUTPUT.PUT_LINE('P_BF_BASYM :기준년월(전분기) : '||P_BF_BASYM); 
    
          IF P_DTDATE = P_RUNDATE  THEN

                DBMS_OUTPUT.PUT_LINE('기준일 일치 평가데이터 생성을 시작합니다.');
                
                
                DELETE FROM OPEOWN.TB_OR_RM_ACT
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_RH_ACT_DCZ
                      WHERE BAS_YM = P_BASYM
                       ;
                
               INSERT INTO OPEOWN.TB_OR_RM_ACT
                       SELECT '01',P_BASYM,A.BSN_PRSS_C,A.BRC,'','','','','','',0,SYSDATE,'SYSTEM',SYSDATE,'SYSTEM'
                       FROM
                       (SELECT * FROM (
                         SELECT  
                          C.BSN_PRSS_C
                         ,A.BRC
						,CASE WHEN NVL(AVG(A.RK_EVL_GRD_C* A.CTEV_GRD_C),'0') = 0 THEN '미평가'
                              WHEN NVL(AVG(A.RK_EVL_GRD_C* A.CTEV_GRD_C),'0') <= 3 THEN 'GREEN'
                              WHEN NVL(AVG(A.RK_EVL_GRD_C* A.CTEV_GRD_C),'0') <= 6 THEN 'YELLOW'
                              WHEN NVL(AVG(A.RK_EVL_GRD_C* A.CTEV_GRD_C),'0') <= 9 THEN 'RED' 
                              END SHEET2_RMN_RSK_GRD_C
                     	 FROM    OPEOWN.TB_OR_RM_EVL        A                                 
						     ,   OPEOWN.TB_OR_RH_EVL_DCZ    B
                             ,   OPEOWN.TB_OR_RN_RKPMM      C
						 WHERE A.OPRK_RKP_ID = B.OPRK_RKP_ID
                           AND A.BAS_YM = B.BAS_YM
                           AND A.DCZ_SQNO = B.DCZ_SQNO
                           AND A.BRC = B.BRC
                           AND A.OPRK_RKP_ID = C.OPRK_RKP_ID
                           AND A.BAS_YM = C.BAS_YM
                           AND A.BAS_YM = P_BASYM
                           AND B.RK_EVL_DCZ_STSC ='15'
                           AND A.RK_EVL_GRD_C IS NOT NULL
                        GROUP BY C.BSN_PRSS_C,A.BRC
                       )
                       WHERE SHEET2_RMN_RSK_GRD_C = 'RED'
                       ) A
                       ,(SELECT * FROM (
                         SELECT  
                          C.BSN_PRSS_C
                         ,A.BRC
						,CASE WHEN NVL(AVG(A.RK_EVL_GRD_C* A.CTEV_GRD_C),'0') = 0 THEN '미평가'
                              WHEN NVL(AVG(A.RK_EVL_GRD_C* A.CTEV_GRD_C),'0') <= 3 THEN 'GREEN'
                              WHEN NVL(AVG(A.RK_EVL_GRD_C* A.CTEV_GRD_C),'0') <= 6 THEN 'YELLOW'
                              WHEN NVL(AVG(A.RK_EVL_GRD_C* A.CTEV_GRD_C),'0') <= 9 THEN 'RED' 
                              END SHEET2_RMN_RSK_GRD_C
                     	 FROM    OPEOWN.TB_OR_RM_EVL        A                                 
						     ,   OPEOWN.TB_OR_RH_EVL_DCZ    B
                             ,   OPEOWN.TB_OR_RN_RKPMM      C
						 WHERE A.OPRK_RKP_ID = B.OPRK_RKP_ID
                           AND A.BAS_YM = B.BAS_YM
                           AND A.DCZ_SQNO = B.DCZ_SQNO
                           AND A.BRC = B.BRC
                           AND A.OPRK_RKP_ID = C.OPRK_RKP_ID
                           AND A.BAS_YM = C.BAS_YM
                           AND A.BAS_YM = P_BF_BASYM
                           AND B.RK_EVL_DCZ_STSC ='15'
                           AND A.RK_EVL_GRD_C IS NOT NULL
                        GROUP BY C.BSN_PRSS_C,A.BRC
                       )
                       WHERE SHEET2_RMN_RSK_GRD_C = 'RED'
                       ) B
                       WHERE A.BSN_PRSS_C = B.BSN_PRSS_C
                         AND A.BRC = B.BRC
                ;
                
INSERT INTO OPEOWN.TB_OR_RH_ACT_DCZ
SELECT '01',BAS_YM,BSN_PRSS_C,BRC,DCZ_SQNO,TO_CHAR(SYSDATE,'YYYYMMDD'),'','01','','','',SYSDATE,'SYSTEM',SYSDATE,'SYSTEM' 
 FROM  OPEOWN.TB_OR_RM_ACT
WHERE BAS_YM = P_BASYM            
                ;

                
                 UPDATE OPEOWN.TB_OR_OM_SCHD_PLAN SET RK_EVL_PRG_STSC ='03'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 스케쥴 플랜 테이블  평가완료로 업데이트');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD SET RK_EVL_PRG_STSC ='03'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 스케쥴테이블 평가완료로 업데이트');
                
                
                MERGE INTO OPEOWN.TB_OR_OM_SCHD A
   USING (
   SELECT BAS_YM,B.RK_EVL_TGT_YN ,B.RK_EVL_ST_DT,B.RK_EVL_ED_DT,B.RK_EVL_PRG_STSC,B.RK_ACT_ST_DT,B.RK_ACT_ED_DT
     FROM OPEOWN.TB_OR_OM_SCHD_PLAN B
   WHERE BAS_YM = 
          (SELECT MIN(BAS_YM) 
           FROM OPEOWN.TB_OR_OM_SCHD_PLAN 
          WHERE BAS_YM  > P_BASYM
            AND RK_EVL_TGT_YN = 'Y')
            
     ) B
     ON (A.BAS_YM = B.BAS_YM)
     WHEN MATCHED THEN UPDATE SET 
                  A.RK_EVL_TPC = '02' 
                 ,A.RK_EVL_ST_DT = B.RK_EVL_ST_DT
                 ,A.RK_EVL_ED_DT = B.RK_EVL_ED_DT
                 ,A.RK_ACT_ST_DT = B.RK_ACT_ST_DT
                 ,A.RK_ACT_ED_DT = B.RK_ACT_ED_DT
                 ,A.RK_EVL_PRG_STSC = B.RK_EVL_PRG_STSC
                 ,A.RK_EVL_TGT_YN = B.RK_EVL_TGT_YN
                 ,A.LSCHG_DTM = SYSDATE
                 ,A.LS_WKR_ENO = 'SYSTEM'
     WHEN NOT MATCHED THEN 
     INSERT (A.GRP_ORG_C,A.BAS_YM,A.RK_EVL_TPC
                 ,A.RK_EVL_ST_DT,A.RK_EVL_ED_DT,A.RK_ACT_ST_DT,A.RK_ACT_ED_DT
                 ,A.RK_EVL_PRG_STSC,A.RK_EVL_TGT_YN,A.FIR_INP_DTM,A.FIR_INPMN_ENO,A.LSCHG_DTM,A.LS_WKR_ENO
                 )
           VALUES ('01',B.BAS_YM,'02',B.RK_EVL_ST_DT,B.RK_EVL_ED_DT,B.RK_ACT_ST_DT,B.RK_ACT_ED_DT
                 ,B.RK_EVL_PRG_STSC,B.RK_EVL_TGT_YN,SYSDATE,'SYSTEM',SYSDATE,'SYSTEM'
                 )
             ;
             
           DBMS_OUTPUT.PUT_LINE(P_LD_CN || '다음RCSA 스케쥴 생성 평가완료로 업데이트');
                
          SELECT MAX(BAS_YM)
            INTO P_FW_BASYM
           FROM OPEOWN.TB_OR_OM_SCHD 
          WHERE RK_EVL_TGT_YN = 'Y'      
                ;
                  DBMS_OUTPUT.PUT_LINE('P_FW_BASYM :기준년월(다음분기) : '||P_FW_BASYM);
                  
 DELETE FROM OPEOWN.TB_OR_RH_RKSLT WHERE BAS_YM = P_FW_BASYM  ;               
 INSERT INTO OPEOWN.TB_OR_RH_RKSLT
(
    GRP_ORG_C
   ,BAS_YM
   ,OPRK_RKP_ID
   ,EVL_OBJ_YN
   ,FIR_INP_DTM
   ,FIR_INPMN_ENO
   ,LSCHG_DTM
   ,LS_WKR_ENO
)
SELECT 
      '01' GRP_ORG_C
      ,C.BAS_YM
      ,A.OPRK_RKP_ID
      ,CASE WHEN B.AMN_MM IS NULL THEN 'N'
            ELSE 'Y'
        END EVL_OBJ_YN
      ,SYSDATE
      ,'SYSTEM'
      ,SYSDATE
      ,'SYSTEM'
  FROM 
  OPEOWN.TB_OR_RM_RKP A
 ,OPEOWN.TB_OR_OM_FQ B
 ,OPEOWN.TB_OR_OM_SCHD C
WHERE A.RPT_FQ_DSC = B.RPT_FQ_DSC (+)
  AND SUBSTR(C.BAS_YM,5,2) = B.AMN_MM (+)
  AND C.BAS_YM = P_FW_BASYM  
  ;
                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '다음RCSA 평가대상생성 ');
                COMMIT;
                
          ELSE
                DBMS_OUTPUT.PUT_LINE('실행일자와 일치하지 않습니다.');

               -- RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT