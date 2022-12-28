/*
        프로그램명 : ins_RA마감데이터 생성
        타켓테이블 : 
        최조작성자 : 김병현
*/
DECLARE
        P_DTDATE  VARCHAR2(8);  -- 기준일자
        P_RUNDATE VARCHAR2(8);  -- 실행일자
        P_BASYM   VARCHAR2(6);
        P_BF_BASYM VARCHAR2(6);
        P_FW_BASYM VARCHAR2(6);
        P_LD_CN    NUMBER;  -- 로딩건수
        P_DUMMY	   VARCHAR2(8);

BEGIN
  SELECT  NXT_DT
  INTO    P_DTDATE
  FROM    OPEOWN.TB_OPE_DT_BC
  ;
  
  SELECT NVL(A.RA_EVL_ED_DT,B.DUMMY) RA_EVL_ED_DT
        ,A.BAS_YM
        ,B.DUMMY
    INTO P_RUNDATE
        ,P_BASYM
        ,P_DUMMY
    FROM 
  (SELECT A.RA_EVL_ED_DT
        ,A.BAS_YM
        ,'99991231' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE RA_EVL_TGT_YN = 'Y' 
     AND RA_EVL_PRG_STSC = '01' --평가중에 다른업무 재작업시 날라가는 위험 방지
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE RA_EVL_TGT_YN = 'Y' 
               )
  ) A
  ,(SELECT 99991231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;
  
  SELECT A.BAS_YM
        ,B.DUMMY
    INTO P_BF_BASYM
        ,P_DUMMY
    FROM 
  (SELECT A.RA_EVL_ED_DT
        ,A.BAS_YM
        ,'99991231' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE RA_EVL_TGT_YN = 'Y' 
     AND RA_EVL_PRG_STSC = '01' --평가중에 다른업무 재작업시 날라가는 위험 방지
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE RA_EVL_TGT_YN = 'Y' 
         AND BAS_YM < P_BASYM
               )
  ) A
  ,(SELECT 99991231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;
               
               
               
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :기준일 : '||P_DTDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :기준일 : '||P_RUNDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_BASYM :기준년월 : '||P_BASYM);
   
  DBMS_OUTPUT.PUT_LINE('P_BF_BASYM :기준년월(이전평가) : '||P_BF_BASYM); 
    
          IF P_DTDATE = P_RUNDATE  THEN

                DBMS_OUTPUT.PUT_LINE('기준일 일치 평가데이터 생성을 시작합니다.');
                
                 UPDATE OPEOWN.TB_OR_OM_SCHD_PLAN SET RA_EVL_PRG_STSC ='03'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 스케쥴 플랜 테이블  평가완료로 업데이트');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD SET RA_EVL_PRG_STSC ='03'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 스케쥴테이블 평가완료로 업데이트');
                
                
                MERGE INTO OPEOWN.TB_OR_OM_SCHD A
   USING (
   SELECT BAS_YM,B.RA_EVL_TGT_YN ,B.RA_EVL_ST_DT,B.RA_EVL_ED_DT,B.RA_EVL_PRG_STSC
     FROM OPEOWN.TB_OR_OM_SCHD_PLAN B
   WHERE BAS_YM = 
          (SELECT MIN(BAS_YM) 
           FROM OPEOWN.TB_OR_OM_SCHD_PLAN 
          WHERE BAS_YM  > P_BASYM
            AND RA_EVL_TGT_YN = 'Y')
            
     ) B
     ON (A.BAS_YM = B.BAS_YM)
     WHEN MATCHED THEN UPDATE SET 
                  A.RA_YY = SUBSTR(A.BAS_YM,0,4)
                 ,A.RA_EVL_ST_DT = B.RA_EVL_ST_DT
                 ,A.RA_EVL_ED_DT = B.RA_EVL_ED_DT
                 ,A.RA_EVL_PRG_STSC = B.RA_EVL_PRG_STSC
                 ,A.RA_EVL_TGT_YN = B.RA_EVL_TGT_YN
                 ,A.LSCHG_DTM = SYSDATE
                 ,A.LS_WKR_ENO = 'SYSTEM'
     WHEN NOT MATCHED THEN 
     INSERT (A.GRP_ORG_C,A.BAS_YM
                 ,A.RA_EVL_ST_DT,A.RA_EVL_ED_DT
                 ,A.RA_EVL_PRG_STSC,A.RA_EVL_TGT_YN,A.FIR_INP_DTM,A.FIR_INPMN_ENO,A.LSCHG_DTM,A.LS_WKR_ENO
                 )
           VALUES ('01',B.BAS_YM,B.RA_EVL_ST_DT,B.RA_EVL_ED_DT
                 ,B.RA_EVL_PRG_STSC,B.RA_EVL_TGT_YN,SYSDATE,'SYSTEM',SYSDATE,'SYSTEM'
                 )
             ;
             
           DBMS_OUTPUT.PUT_LINE(P_LD_CN || '다음RA 스케쥴 생성 평가완료로 업데이트');
                
          SELECT MAX(BAS_YM)
            INTO P_FW_BASYM
           FROM OPEOWN.TB_OR_OM_SCHD 
          WHERE RA_EVL_TGT_YN = 'Y'      
                ;
                DBMS_OUTPUT.PUT_LINE('P_FW_BASYM :기준년월(다음평가) : '||P_FW_BASYM);
                  
                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '다음 RA 평가대상생성 ');
                COMMIT;
                
          ELSE
                DBMS_OUTPUT.PUT_LINE('실행일자와 일치하지 않습니다.');

               -- RAISE NO_DATA_FOUND;
              
          END IF;
          

END
;
/
EXIT