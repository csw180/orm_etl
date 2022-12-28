/*
        ���α׷��� : ins_RCSA�򰡵����� ����
        Ÿ�����̺� : TB_OR_RM_RCSA
        �����ۼ��� : �ڽ���
*/
DECLARE
        P_DTDATE   VARCHAR2(8);  -- ��������
        P_RUNDATE  VARCHAR2(8);  -- ��������(TB_OR_OM_SCHD ��������)
        P_BASYM    VARCHAR2(6);  -- ���س��
        P_BASECNT  NUMBER;  -- ������ذǼ�
        P_LD_CN    NUMBER;  -- �ε��Ǽ�
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
     AND RK_EVL_PRG_STSC = '01' --���߿� �ٸ����� ���۾��� ���󰡴� ���� ����
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE RK_EVL_TGT_YN = 'Y' 
               )
  ) A
  ,(SELECT 99991231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;
  
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :������ : '||P_DTDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :������ : '||P_RUNDATE);
        	

          IF P_DTDATE = P_RUNDATE  THEN

          
          
          		
                DBMS_OUTPUT.PUT_LINE('������ ��ġ �򰡵����� ������ �����մϴ�.');
				
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
  
--���б� �� UPDATE
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

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� �򰡵����� ����');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD_PLAN SET RK_EVL_PRG_STSC ='02'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� ������ �÷� ���̺� �������� ������Ʈ');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD SET RK_EVL_PRG_STSC ='02'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� ���������̺� �������� ������Ʈ');
                
                
                COMMIT;
                
          ELSE
                DBMS_OUTPUT.PUT_LINE('�������ڿ� ��ġ���� �ʽ��ϴ�.');

               -- RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT