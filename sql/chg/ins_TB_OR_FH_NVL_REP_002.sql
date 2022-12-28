/*==============================================================================
* 프로그램ID      : 
* 프로그램명      : ins_TB_OR_FH_NVL_REP_002
* 프로그램유형    : BATCH PROGRAM
* ARGUEMENT : 전월(YYYYMMDD)
* 사용테이블     	: TB_OR_FH_NVL, TB_OR_FH_NVL_DCZ, TB_OR_KH_NVL, TB_OR_FH_REL_RKI
                      
* 입력파일        : 
* 출력파일        : 
* 로그파일        : 
* ------------------------------------------------------------------------------
* 작성자          : 김병현
* 작성일          : 2022.11.16
* ------------------------------------------------------------------------------
* 수정내역  수정자   일자       수정근거          변경내용
* --------- ------  ---------- ------------ ------------------------------------
* 
==============================================================================*/
  DECLARE  P_DTDATE   VARCHAR2(8);  -- 기준일자
        P_RUNDATE  VARCHAR2(8);  -- 실행일자(TB_OR_OM_SCHD 실행일자)
        P_BASYM    VARCHAR2(6);  -- 기준년월
        P_DUMMY	   VARCHAR2(8);
        P_BASECNT  NUMBER;  -- 실행기준건수
        P_LD_CN    NUMBER;   -- 로딩건수
        P_RKI_ID VARCHAR2(8); --ID
        P_ED_DATE  VARCHAR2(8); -- 마감일자
  
 BEGIN 
     SELECT  NXT_DT
	   INTO    P_DTDATE
	   FROM    OPEOWN.TB_OPE_DT_BC
	  ;
  
  SELECT NVL(A.REP_RKI_ST_DT,B.DUMMY) REP_RKI_ST_DT
        ,A.BAS_YM
        ,B.DUMMY
        ,NVL(A.REP_RKI_ED_DT,B.DUMMY) REP_RKI_ED_DT
    INTO P_RUNDATE
        ,P_BASYM
        ,P_DUMMY
        ,P_ED_DATE
    FROM 
  (SELECT A.REP_RKI_ST_DT
         ,A.BAS_YM
         ,'99991231' DUMMY
         ,A.REP_RKI_ED_DT
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE REP_EVL_TGT_YN = 'Y' 
     AND REP_RKI_PRG_STSC = '02' --평가중에 다른업무 재작업시 날라가는 위험 방지
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE REP_EVL_TGT_YN = 'Y' 
               )
  ) A
  ,(SELECT 99991231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;             
               
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :기준일 : '||P_DTDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :기준일 : '||P_RUNDATE);
        

          IF P_DTDATE >= P_RUNDATE AND P_DTDATE <= P_ED_DATE THEN 

                DBMS_OUTPUT.PUT_LINE('기준일 일치 평가데이터 생성을 시작합니다.');

        SELECT 'REP_002'
          INTO P_RKI_ID
          FROM DUAL
        ;
     
        DELETE FROM OPEOWN.TB_OR_FH_NVL
              WHERE REP_RKI_ID = P_RKI_ID
                AND BAS_YM = P_BASYM
        ;
     
    INSERT INTO OPEOWN.TB_OR_FH_NVL  
    (                                            
         GRP_ORG_C  	                            
        ,BAS_YM		                            
        ,REP_RKI_ID
        ,REP_KRI_NVL
        ,INPMN_ENO
        ,INPDT
        ,DCZ_SQNO
        ,FIR_INP_DTM	                            
        ,FIR_INPMN_ENO	                        
        ,LSCHG_DTM		                        
        ,LS_WKR_ENO		                        
    )
    VALUES
    (
        '01'
       ,P_BASYM
       ,P_RKI_ID
       ,(
        SELECT -(SUM(A.KRI_NVL)-SUM(B.KRI_NVL))/DECODE(SUM(B.KRI_NVL),0,NULL,SUM(B.KRI_NVL))*100
          FROM OPEOWN.TB_OR_KH_NVL A
          LEFT JOIN OPEOWN.TB_OR_KH_NVL B
            ON A.OPRK_RKI_ID = B.OPRK_RKI_ID
           AND B.BAS_YM IN ( TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-5),'YYYYMM'),
                             TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-4),'YYYYMM'),   
                             TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-3),'YYYYMM') )
         INNER JOIN OPEOWN.TB_OR_KH_NVL C
            ON A.OPRK_RKI_ID = C.OPRK_RKI_ID
           AND A.BAS_YM = C.BAS_YM
         INNER JOIN OPEOWN.TB_OR_KH_NVL_DCZ D
            ON C.OPRK_RKI_ID = D.OPRK_RKI_ID
           AND C.BAS_YM = D.BAS_YM
           AND C.DCZ_SQNO = D.DCZ_SQNO
           AND C.BRC = D.BRC
           AND D.RKI_DCZ_STSC >= '13'
         WHERE A.BAS_YM IN ( TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-2),'YYYYMM'),
                             TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM,'YYYYMM'),-1),'YYYYMM'),   
                             TO_CHAR(TO_DATE(P_BASYM,'YYYYMM'),'YYYYMM') )
           AND A.OPRK_RKI_ID IN (SELECT OPRK_RKI_ID FROM OPEOWN.TB_OR_FH_REL_RKI WHERE REP_RKI_ID = P_RKI_ID)
        )
       ,'SYSTEM'
       ,SYSDATE
       ,'0'
       ,SYSDATE
       ,'SYSTEM'
       ,SYSDATE
       ,'SYSTEM'
    )
    ;
    
    DELETE FROM OPEOWN.TB_OR_FH_NVL_DCZ
          WHERE REP_RKI_ID = P_RKI_ID
            AND BAS_YM = P_BASYM
    ;

    INSERT INTO OPEOWN.TB_OR_FH_NVL_DCZ  
        (                                            
             GRP_ORG_C  	                            
            ,BAS_YM		                            
            ,REP_RKI_ID
            ,DCZ_SQNO
            ,DCZMN_ENO
            ,DCZ_DT
            ,REP_RKI_DCZ_STSC
            ,RTN_CNTN
            ,DCZ_OBJR_ENO
            ,DCZ_RMK_C
            ,FIR_INP_DTM	                            
            ,FIR_INPMN_ENO	                        
            ,LSCHG_DTM		                        
            ,LS_WKR_ENO		                        
        )
        VALUES
        (
            '01'
           ,P_BASYM
           ,P_RKI_ID
           ,'0'
           ,'SYSTEM'
           ,SYSDATE
           ,'13'
           ,''
           ,''
           ,''
           ,SYSDATE
           ,'SYSTEM'
           ,SYSDATE
           ,'SYSTEM'
        )
        ;
     
     DBMS_OUTPUT.PUT_LINE('기준일자 : '||P_BASYM);
     DBMS_OUTPUT.PUT_LINE('평판리스크 지표 ID : '||P_RKI_ID);
     COMMIT;
 ELSE
                DBMS_OUTPUT.PUT_LINE('실행일자와 일치하지 않습니다.');

               -- RAISE NO_DATA_FOUND;
              
          END IF;
 
END ;
/
EXIT 