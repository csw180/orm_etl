/*
        ���α׷��� : ins_RCSA���������ͻ���
        Ÿ�����̺� : TB_OR_RN_RKPMM , TB_OR_RN_CTL_SCFMM
        �����ۼ��� : �ڽ���
*/
DECLARE
        P_DTDATE   VARCHAR2(8);  -- ��������
        P_RUNDATE  VARCHAR2(8);  -- ��������(TB_OR_OM_SCHD ��������)
        P_BASYM    VARCHAR2(6);  -- ���س��
        P_BASECNT  NUMBER;  -- ������ذǼ�
        P_LD_CN    NUMBER;  -- �ε��Ǽ���
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

                DBMS_OUTPUT.PUT_LINE('������ ��ġ ���������� ������ �����մϴ�.');

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

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� ����ũǮ ���� ������ ����');
                
                
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

                DBMS_OUTPUT.PUT_LINE(P_LD_CN || '�� ���� ���� ������ ����');
                
                COMMIT;
                
          ELSE
                DBMS_OUTPUT.PUT_LINE('�������ڿ� ��ġ���� �ʽ��ϴ�.');

               -- RAISE NO_DATA_FOUND;
              
          END IF;

END
;
/
EXIT