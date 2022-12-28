/*
        프로그램명 : ins_RCSA월말데이터생성
        타켓테이블 : TB_OR_RN_RKPMM , TB_OR_RN_CTL_SCFMM
        최조작성자 : 박승윤
*/
DECLARE
        P_DTDATE   VARCHAR2(8);  -- 기준일자
        P_RUNDATE  VARCHAR2(8);  -- 실행일자(TB_OR_OM_SCHD 실행일자)
        P_BASYM    VARCHAR2(6);  -- 기준년월
        P_BASECNT  NUMBER;  -- 실행기준건수
        P_LD_CN    NUMBER;  -- 로딩건수ㄴ
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

                DBMS_OUTPUT.PUT_LINE('기준일 일치 월말데이터 생성을 시작합니다.');

                DELETE FROM OPEOWN.TB_OR_RN_RKPMM
                      WHERE BAS_YM = P_BASYM
                      ;
                DELETE FROM OPEOWN.TB_OR_RN_CTL_SCFMM
                      WHERE BAS_YM = P_BASYM
                      ;      
                INSERT INTO OPEOWN.TB_OR_RN_RKPMM
                (
					 GRP_ORG_C
					,OPRK_RKP_ID
					,BAS_YM
					,BSN_PRSS_C
					,HPN_TPC
					,CAS_TPC
					,IFN_TPC
					,EMRK_TPC
					,RKP_DIGITAL_YN
					,RKP_NFTF_YN
					,RK_ISC_CNTN
					,ENG_RK_ISC_CNTN
					,RPT_FQ_DSC
					,RKP_TPC
					,KRK_YN
					,APL_AFLCO_DSC
					,VLD_YN
					,VLD_ST_DT
					,VLD_ED_DT
					,FIR_INP_DTM
					,FIR_INPMN_ENO
					,LSCHG_DTM
					,LS_WKR_ENO
				)SELECT
					 GRP_ORG_C
					,OPRK_RKP_ID
					,P_BASYM
					,BSN_PRSS_C
					,HPN_TPC
					,CAS_TPC
					,IFN_TPC
					,EMRK_TPC
					,RKP_DIGITAL_YN
					,RKP_NFTF_YN
					,RK_ISC_CNTN
					,ENG_RK_ISC_CNTN
					,RPT_FQ_DSC
					,RKP_TPC
					,KRK_YN
					,APL_AFLCO_DSC
					,VLD_YN
					,VLD_ST_DT
					,VLD_ED_DT
					,SYSDATE
					,'SYSTEM'
					,SYSDATE
					,'SYSTEM'
				FROM OPEOWN.TB_OR_RM_RKP
				;
				
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 리스크풀 월말 데이터 생성');
                
                
				INSERT INTO OPEOWN.TB_OR_RN_CTL_SCFMM
				(	 GRP_ORG_C
					,BAS_YM
					,OPRK_RKP_ID
					,RK_CP_ID
					,RK_CTL_SQNO
					,RK_CTL_TPC
					,RK_CP_CNTN
					,ENG_RK_CP_CNTN
					,FIR_INP_DTM
					,FIR_INPMN_ENO
					,LSCHG_DTM
					,LS_WKR_ENO
				)
				SELECT GRP_ORG_C
					,P_BASYM
					,OPRK_RKP_ID
					,RK_CP_ID
					,RK_CTL_SQNO
					,RK_CTL_TPC
					,RK_CP_CNTN
					,ENG_RK_CP_CNTN
					,SYSDATE
					,'SYSTEM'
					,SYSDATE
					,'SYSTEM'
				  FROM OPEOWN.TB_OR_RH_CTL_SCF
				;

                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '건 통제 월말 데이터 생성');
                
                COMMIT;
                
          ELSE
                DBMS_OUTPUT.PUT_LINE('실행일자와 일치하지 않습니다.');

               -- RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT