/*
        ���α׷��� : ins_���Ǹ��������� ����
        Ÿ�����̺� : OPEOWN.TB_OR_FH_NVL
        �����ۼ��� : �ڽ���
*/
DECLARE
        P_DTDATE    VARCHAR2(8);  -- ��������
        P_RUNDATE   VARCHAR2(8);  -- ��������(TB_OR_OM_SCHD ��������)
        P_BASYM     VARCHAR2(6);  -- ���س��
        P_BF_BASYM  VARCHAR2(6);
        P_FW_BASYM  VARCHAR2(6);
        P_LD_CN     NUMBER;  -- �ε��Ǽ�
        P_DUMMY	    VARCHAR2(8);
        P_ST_DATE       VARCHAR2(8);  -- �򰡽�������

BEGIN
  SELECT  NXT_DT
  INTO    P_DTDATE
  FROM    OPEOWN.TB_OPE_DT_BC
  ;
  
  SELECT NVL(A.REP_RKI_ED_DT,B.DUMMY) REP_RKI_ED_DT
        ,A.BAS_YM
        ,B.DUMMY
        ,NVL(A.REP_RKI_ST_DT,B.DUMMY) REP_RKI_ST_DT
    INTO P_RUNDATE
        ,P_BASYM
        ,P_DUMMY
        ,P_ST_DATE
    FROM 
  (SELECT A.REP_RKI_ED_DT
         ,A.REP_RKI_ST_DT
         ,A.BAS_YM
        ,'10001231' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE REP_EVL_TGT_YN = 'Y' 
     AND REP_EVL_TGT_YN = '02' --�� ���� BAS_YM �ʿ�
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE REP_EVL_TGT_YN = 'Y' 
               )
  ) A
  ,(SELECT 10001231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;
  
   
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :������ : '||P_DTDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :������ : '||P_RUNDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_BASYM :���س�� : '||P_BASYM);
   
    
          IF P_DTDATE <= P_RUNDATE AND P_DTDATE >=P_ST_DATE  THEN

                DBMS_OUTPUT.PUT_LINE('������ ��ġ �򰡵����� ������ �����մϴ�.');
                
                
                DELETE FROM OPEOWN.TB_OR_FH_INDEX
                      WHERE BAS_YM = P_BASYM
                      ;
		  INSERT
  INTO OPEOWN.TB_OR_FH_INDEX ( GRP_ORG_C, BAS_YM, REP_STDD_SUM, BEF_REP_IDX, BEF_REP_STDD_AVG, BEF_REP_STDD_STDV )
  SELECT *
    FROM (
        SELECT GRP_ORG_C,
               MAX(BAS_YM) BAS_YM,
               SUM(STD0) REP_STDD_SUM
          FROM (
              SELECT TYPNM, BAS_YM, ROUND(NVL(AVG(STD0), ''), 2) STD0, GRP_ORG_C
                FROM (
                    SELECT NVL((REP_RKI_NVL_0 - REP_RKI_NVL_00_AVG) / DECODE(REP_RKI_NVL_00_STD,0,NULL,REP_RKI_NVL_00_STD),NULL) AS STD0, TYPNM, BAS_YM, GRP_ORG_C
                      FROM (
                          SELECT A.REP_RKI_ID AS RKI_ID, B1.INTG_IDVD_CNM AS TYPNM,
                                       NVL(TO_CHAR((SELECT REP_KRI_NVL+100
                                                      FROM OPEOWN.TB_OR_FH_NVL
                                                     WHERE REP_RKI_ID = A.REP_RKI_ID
                                                       AND BAS_YM = C.BAS_YM)), '') AS REP_RKI_NVL_0,
                                       NVL(TO_CHAR((SELECT SUM(REP_KRI_NVL+100)/DECODE(COUNT(REP_KRI_NVL),0,1,COUNT(REP_KRI_NVL))
                                                            FROM OPEOWN.TB_OR_FH_NVL
                                                           WHERE REP_RKI_ID = A.REP_RKI_ID
                                                             AND BAS_YM < C.BAS_YM)), '') AS REP_RKI_NVL_00_AVG,
                                       TO_CHAR((SELECT STDDEV_POP(REP_KRI_NVL+100)
                                                               FROM OPEOWN.TB_OR_FH_NVL
                                                              WHERE REP_RKI_ID = A.REP_RKI_ID
                                                                AND BAS_YM < C.BAS_YM)) AS REP_RKI_NVL_00_STD,
                                       C.BAS_YM BAS_YM, A.GRP_ORG_C
                              FROM OPEOWN.TB_OR_FM_REPRKI A 
                              LEFT JOIN OPEOWN.TB_OR_OM_CODE B1 
                                ON A.GRP_ORG_C = B1.GRP_ORG_C
                               AND B1.INTG_GRP_C = 'REP_TYP_DSCD'
                               AND B1.C_UYN = 'Y'
                               AND A.REP_TYP_DSCD = B1.IDVDC_VAL 
                              INNER JOIN OPEOWN.TB_OR_FH_NVL C 
                                ON A.GRP_ORG_C = C.GRP_ORG_C
                               AND C.REP_RKI_ID = A.REP_RKI_ID
                               AND C.BAS_YM = P_BASYM
                             WHERE A.GRP_ORG_C = '01'
                               AND A.VLD_YN = 'Y'
                             ORDER BY RKI_ID ) )
                 GROUP BY TYPNM, BAS_YM, GRP_ORG_C )
         GROUP BY GRP_ORG_C ) 
          LEFT JOIN 
          (SELECT REP_IDX BEF_REP_IDX, REP_STDD_AVG BEF_REP_STDD_AVG, REP_STDD_STDV BEF_REP_STDD_STDV
             FROM OPEOWN.TB_OR_FH_INDEX
            WHERE BAS_YM = TO_CHAR(ADD_MONTHS(TO_DATE(P_BASYM, 'YYYYMM'), -3), 'YYYYMM')) ON 1=1 ;
 
 
UPDATE OPEOWN.TB_OR_FH_INDEX
   SET ( REP_IDX, IDX_INDC_RT, REP_STDD_AVG, REP_STDD_STDV,FIR_INP_DTM,FIR_INPMN_ENO,LSCHG_DTM,LS_WKR_ENO ) 
     = ( SELECT A.REP_IDX, A.REP_IDX/DECODE(B.BEF_REP_IDX, 0, NULL, B.BEF_REP_IDX) IDX_INDC_RT, A.REP_STDD_AVG, A.REP_STDD_STDV
                ,SYSDATE,'SYSTEM',SYSDATE,'SYSTEM'
           FROM (
               SELECT ROUND((REP_STDD_SUM - BEF_REP_STDD_AVG)/DECODE(BEF_REP_STDD_STDV, 0, NULL, BEF_REP_STDD_STDV)*10+100, 2) REP_IDX,
                      ROUND(REP_STDD_AVG, 2) REP_STDD_AVG,
                      ROUND(REP_STDD_STDV, 2) REP_STDD_STDV
                 FROM (
                     SELECT (SELECT REP_STDD_SUM
                               FROM OPEOWN.TB_OR_FH_INDEX
                              WHERE BAS_YM = P_BASYM ) REP_STDD_SUM,
                            (SELECT AVG(REP_STDD_SUM)
                               FROM OPEOWN.TB_OR_FH_INDEX) REP_STDD_AVG,
                            (SELECT STDDEV_POP(REP_STDD_SUM)
                               FROM OPEOWN.TB_OR_FH_INDEX) REP_STDD_STDV,
                            (SELECT AVG(REP_STDD_SUM)
                               FROM OPEOWN.TB_OR_FH_INDEX
                              WHERE BAS_YM < P_BASYM) BEF_REP_STDD_AVG,
                            (SELECT STDDEV_POP(REP_STDD_SUM)
                               FROM OPEOWN.TB_OR_FH_INDEX
                              WHERE BAS_YM < P_BASYM) BEF_REP_STDD_STDV
                      FROM OPEOWN.TB_OR_FH_INDEX
                     WHERE BAS_YM = P_BASYM
                     GROUP BY REP_STDD_AVG, REP_STDD_STDV ) 
                 )A,
                 (
                    SELECT BEF_REP_IDX
                      FROM OPEOWN.TB_OR_FH_INDEX
                     WHERE BAS_YM = P_BASYM 
                 )B 
            )
 WHERE BAS_YM = P_BASYM;
 				
 				P_LD_CN := SQL%ROWCOUNT;

                 DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� �ε��� ó�� �Ϸ�');
                 
                 
         IF P_DTDATE = P_RUNDATE  THEN            
                 
                UPDATE OPEOWN.TB_OR_OM_SCHD_PLAN SET REP_RKI_PRG_STSC ='03'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� ������ �÷� ���̺�  �򰡿Ϸ�� ������Ʈ');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD SET REP_RKI_PRG_STSC ='03'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� ���������̺� �򰡿Ϸ�� ������Ʈ');
                
                
                MERGE INTO OPEOWN.TB_OR_OM_SCHD A
   USING (
   SELECT BAS_YM,B.REP_EVL_TGT_YN ,B.REP_RKI_ST_DT,B.REP_RKI_ED_DT,B.REP_RKI_PRG_STSC,B.RK_ACT_ST_DT,B.RK_ACT_ED_DT
     FROM OPEOWN.TB_OR_OM_SCHD_PLAN B
   WHERE BAS_YM = 
          (SELECT MIN(BAS_YM) 
           FROM OPEOWN.TB_OR_OM_SCHD_PLAN 
          WHERE BAS_YM  > P_BASYM
            AND REP_EVL_TGT_YN = 'Y')
            
     ) B
     ON (A.BAS_YM = B.BAS_YM)
     WHEN MATCHED THEN UPDATE SET 
                  A.REP_RKI_ST_DT = B.REP_RKI_ST_DT
                 ,A.REP_RKI_ED_DT = B.REP_RKI_ED_DT
                 ,A.REP_RKI_PRG_STSC = B.REP_RKI_PRG_STSC
                 ,A.REP_EVL_TGT_YN = B.REP_EVL_TGT_YN
                 ,A.LSCHG_DTM = SYSDATE
                 ,A.LS_WKR_ENO = 'SYSTEM'
     WHEN NOT MATCHED THEN 
     INSERT (A.GRP_ORG_C,A.BAS_YM,A.REP_RKI_ST_DT,A.REP_RKI_ED_DT
                 ,A.REP_RKI_PRG_STSC,A.REP_EVL_TGT_YN,A.FIR_INP_DTM,A.FIR_INPMN_ENO,A.LSCHG_DTM,A.LS_WKR_ENO
                 )
           VALUES ('01',B.BAS_YM,B.REP_RKI_ST_DT,B.REP_RKI_ED_DT
                   ,B.REP_RKI_PRG_STSC,B.REP_EVL_TGT_YN,SYSDATE,'SYSTEM',SYSDATE,'SYSTEM'
                 )
             ;
             
           DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�������� ������ ���� �򰡿Ϸ�� ������Ʈ');
       END IF;         

                COMMIT;
                
          ELSE
                DBMS_OUTPUT.PUT_LINE('�������ڿ� ��ġ���� �ʽ��ϴ�.');

             --   RAISE NO_DATA_FOUND;
              
          END IF;

END
;
EXIT
/