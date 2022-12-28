/*
        프로그램명 : ins_RA평가데이터 생성
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
 
 
    SELECT NVL(A.RA_EVL_ST_DT,B.DUMMY) RA_EVL_ST_DT
        ,A.BAS_YM
        ,B.DUMMY
    INTO P_RUNDATE
        ,P_BASYM
        ,P_DUMMY
    FROM 
  (SELECT A.RA_EVL_ST_DT
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
      INTO P_BF_BASYM
      FROM (
        SELECT MAX(BAS_YM) BAS_YM    
          FROM OPEOWN.TB_OR_OM_SCHD   
         WHERE RA_EVL_TGT_YN = 'Y'    		
           AND RA_EVL_PRG_STSC = '03'
           )A;
  
  
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :기준일 : '||P_DTDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :기준일 : '||P_RUNDATE);
        

          IF P_DTDATE = P_RUNDATE  THEN

                DBMS_OUTPUT.PUT_LINE('기준일 일치 평가데이터 생성을 시작합니다.');

                
                DELETE FROM OPEOWN.TB_OR_BH_RA
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_BH_RADCZ
                      WHERE BAS_YM = P_BASYM
                       ;
                
                INSERT INTO OPEOWN.TB_OR_BH_RA
(GRP_ORG_C
,BAS_YM
,RSK_C
,BZPL_ACS_IMP_YN
,HMRS_LSS_YN
,IPT_RESC_IPMT_YN
,SYS_UG_IMP_YN
,DOFE_SPT_SSP_YN
,BCP_AMN_OBJ_YN
,RA_X_RSNC
,X_RSNCTT
,NATV_RSK_EVL_SCR
,RSK_CTL_SUV_CNTN
,RM_RSK_EVL_SCR
,RM_RSK_GRD_C
,RSK_MTG_ACT_CNTN
,DCZ_SQNO
,FIR_INP_DTM
,FIR_INPMN_ENO
,LSCHG_DTM
,LS_WKR_ENO)
SELECT 
 A.GRP_ORG_C
,P_BASYM
,A.RSK_C
,A.BZPL_ACS_IMP_YN
,A.HMRS_LSS_YN
,A.IPT_RESC_IPMT_YN
,A.SYS_UG_IMP_YN
,A.DOFE_SPT_SSP_YN
,A.BCP_AMN_OBJ_YN
,A.RA_X_RSNC
,A.X_RSNCTT
,A.NATV_RSK_EVL_SCR
,A.RSK_CTL_SUV_CNTN
,A.RM_RSK_EVL_SCR
,A.RM_RSK_GRD_C
,A.RSK_MTG_ACT_CNTN
,'0'
,SYSDATE 
,'SYSTEM'
,SYSDATE
,'SYSTEM'
FROM OPEOWN.TB_OR_BH_RA A,
OPEOWN.TB_OR_BC_RKFCTR B
  WHERE A.BAS_YM(+) = P_BF_BASYM     
  AND A.RSK_C(+) = B.RSK_C
  AND A.GRP_ORG_C(+) = B.GRP_ORG_C
  AND B.LVL_NO = '3'
  
  ;

INSERT INTO OPEOWN.TB_OR_BH_RADCZ
(
GRP_ORG_C
,BAS_YM
,RSK_C
,DCZ_SQNO
,RA_DCZ_STSC
,FIR_INP_DTM
,FIR_INPMN_ENO
,LSCHG_DTM
,LS_WKR_ENO
)
SELECT '01',BAS_YM,RSK_C,'0','01',SYSDATE,'SYSTEM',SYSDATE,'SYSTEM' 
 FROM  OPEOWN.TB_OR_BH_RA
WHERE BAS_YM = P_BASYM            
                ;
                
                DELETE FROM OPEOWN.TB_OR_BH_NATV_RA
                      WHERE BAS_YM = P_BASYM
                      ;
                
INSERT INTO OPEOWN.TB_OR_BH_NATV_RA     
(                                     
GRP_ORG_C
,BAS_YM
,RSK_C
,NATV_RSK_HDNG_C
,NATV_RSK_DTLC
,FIR_INP_DTM
,FIR_INPMN_ENO
,LSCHG_DTM
,LS_WKR_ENO		                 
)                                     
SELECT                                
     A.GRP_ORG_C
    ,P_BASYM
    ,A.RSK_C
    ,A.NATV_RSK_HDNG_C
    ,A.NATV_RSK_DTLC
    ,SYSDATE              
    ,'SYSTEM'         
    ,SYSDATE                
    ,'SYSTEM'          
   FROM OPEOWN.TB_OR_BH_NATV_RA A   
  WHERE A.BAS_YM = P_BF_BASYM           
	;          
                
    
    
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 평가데이터 생성');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD_PLAN 
                SET RA_EVL_PRG_STSC ='02'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 스케쥴 플랜 테이블 평가중으로 업데이트');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD 
                SET RA_EVL_PRG_STSC ='02'
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