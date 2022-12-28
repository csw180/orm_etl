/*
        ���α׷��� : ins_�����򰡵����� ����
        Ÿ�����̺� : TB_OR_FH_NVL
        �����ۼ��� : �ڽ���
*/
DECLARE
        P_DTDATE   VARCHAR2(8);  -- ��������
        P_RUNDATE  VARCHAR2(8);  -- ��������(TB_OR_OM_SCHD ��������)
        P_BASYM    VARCHAR2(6);  -- ���س��
        P_DUMMY	   VARCHAR2(8);
        P_BASECNT  NUMBER;  -- ������ذǼ�
        P_LD_CN    NUMBER;  -- �ε��Ǽ�

BEGIN
	  SELECT  NXT_DT
	  INTO    P_DTDATE
	  FROM    OPEOWN.TB_OPE_DT_BC
	  ;
  
  SELECT NVL(A.REP_RKI_ST_DT,B.DUMMY) REP_RKI_ST_DT
        ,A.BAS_YM
        ,B.DUMMY
    INTO P_RUNDATE
        ,P_BASYM
        ,P_DUMMY
    FROM 
  (SELECT A.REP_RKI_ST_DT
         ,A.BAS_YM
         ,'99991231' DUMMY
    FROM OPEOWN.TB_OR_OM_SCHD A
   WHERE REP_EVL_TGT_YN = 'Y' 
     AND REP_RKI_PRG_STSC = '01' --���߿� �ٸ����� ���۾��� ���󰡴� ���� ����
     AND BAS_YM = 
              (
      SELECT MAX(BAS_YM) FROM OPEOWN.TB_OR_OM_SCHD 
       WHERE REP_EVL_TGT_YN = 'Y' 
               )
  ) A
  ,(SELECT 99991231 DUMMY FROM DUAL) B
  WHERE A.DUMMY (+) = B.DUMMY    
  ;             
               
  DBMS_OUTPUT.PUT_LINE('TB_OPE_DT_BC :������ : '||P_DTDATE);
  
  DBMS_OUTPUT.PUT_LINE('P_RUNDATE :������ : '||P_RUNDATE);
        

          IF P_DTDATE = P_RUNDATE  THEN

                DBMS_OUTPUT.PUT_LINE('������ ��ġ �򰡵����� ������ �����մϴ�.');

               

                
                DELETE FROM OPEOWN.TB_OR_FH_NVL A
                      WHERE A.BAS_YM = P_BASYM
                        AND A.REP_RKI_ID  IN (SELECT REP_RKI_ID FROM OPEOWN.TB_OR_FM_REPRKI WHERE COM_COL_PSB_YN = 'N' AND VLD_YN = 'Y') ;
                      
                DELETE FROM OPEOWN.TB_OR_FH_NVL_DCZ A
                      WHERE A.BAS_YM = P_BASYM
                        AND A.REP_RKI_ID  IN (SELECT REP_RKI_ID FROM OPEOWN.TB_OR_FM_REPRKI WHERE COM_COL_PSB_YN = 'N' AND VLD_YN = 'Y') ;
                       
      INSERT INTO OPEOWN.TB_OR_FH_NVL
      (
         SELECT 
      	 '01' GRP_ORG_C
      	 ,P_BASYM
      	 ,A.REP_RKI_ID
         ,'' REP_KRI_NVL
         ,'SYSTEM'
         ,TO_CHAR(SYSDATE,'YYYYMMDD')
         ,'0'
         ,SYSDATE
         ,'SYSTEM'
         ,SYSDATE
         ,'SYSTEM'
         FROM 
           OPEOWN.TB_OR_FM_REPRKI A
          ,OPEOWN.TB_OR_OM_FQ B
        WHERE A.RPT_FQ_DSC = B.RPT_FQ_DSC
          AND SUBSTR(P_BASYM,5,2) = B.AMN_MM
          AND A.COM_COL_PSB_YN = 'N'
          AND A.VLD_YN = 'Y'
      );
      
      INSERT INTO OPEOWN.TB_OR_FH_NVL_DCZ
      (
         SELECT 
      	 '01' GRP_ORG_C
      	 ,P_BASYM
      	 ,A.REP_RKI_ID
      	 ,'0'
         ,'SYSTEM'
         ,TO_CHAR(SYSDATE,'YYYYMMDD')
         ,'01'
         ,''
         ,''
         ,''
         ,SYSDATE
         ,'SYSTEM'
         ,SYSDATE
         ,'SYSTEM'
         FROM 
           OPEOWN.TB_OR_FM_REPRKI A
          ,OPEOWN.TB_OR_OM_FQ B
        WHERE A.RPT_FQ_DSC = B.RPT_FQ_DSC
          AND SUBSTR(P_BASYM,5,2) = B.AMN_MM
          AND A.COM_COL_PSB_YN = 'N'
          AND A.VLD_YN = 'Y'
      );
                
                
       
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� �򰡵����� ����');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD_PLAN SET REP_RKI_PRG_STSC ='02'
                WHERE BAS_YM = P_BASYM 
                ;
                P_LD_CN := SQL%ROWCOUNT;

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� ������ �÷� ���̺� �������� ������Ʈ');
                
                UPDATE OPEOWN.TB_OR_OM_SCHD SET REP_RKI_PRG_STSC ='02'
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