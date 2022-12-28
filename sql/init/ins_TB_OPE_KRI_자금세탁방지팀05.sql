/*
  ���α׷��� : ins_TB_OPE_KRI_�ڱݼ�Ź������05
  Ÿ�����̺� : TB_OPE_KRI_�ڱݼ�Ź������05
  KRI ��ǥ�� : ������ ���ΰ� �� EDD �� ��
  ��      �� : �������븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ڱݼ�Ź������-05 ������ ���ΰ� �� EDD �� ��
       A: ���� �� ���ΰ� EDD �ش� �Ǽ� ������ ������/�������� ��ǥ �Ѱ�
*/
DECLARE
  P_BASEDAY  VARCHAR2(8);  -- ��������
  P_SOTM_DT  VARCHAR2(8);  -- �������
  P_EOTM_DT  VARCHAR2(8);  -- �������
  P_LD_CN    NUMBER;  -- �ε��Ǽ�

BEGIN
  SELECT  STD_DT,EOTM_DT,SUBSTR(EOTM_DT,1,6) || '01'
  INTO    P_BASEDAY
         ,P_EOTM_DT
         ,P_SOTM_DT
  FROM   DWZOWN.OM_DWA_DT_BC
  WHERE   STD_DT = '&1';
  
  IF P_EOTM_DT = P_BASEDAY  THEN

    DELETE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������05
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������05
    SELECT   P_BASEDAY
            ,BLNT_BRNO  -- ����ȣ
            ,B.BR_NM
            ,A.CUST_NO  -- ����ȣ
            ,A.KYC_SNO  -- KYC�Ϸù�ȣ
    FROM     TB_SOR_CUS_KYC_TR   A   -- SOR_CUS_KYC����
    JOIN     TB_SOR_CMI_BR_BC    B   -- SOR_CMI_���⺻
             ON    A.ENR_BRNO   = B.BRNO
             AND   B.BR_DSCD = '1'
--             AND  (B.CLBR_DT IS NULL OR B.CLBR_DT >= '20220401')
--             AND  (CLBR_DT IS NULL OR CLBR_DT >= P_BASEDAY)
    JOIN     TB_SOR_CUS_MAS_BC   C   -- SOR_CUS_���⺻
             ON    A.CUST_NO  =  C.CUST_NO
             AND   (
                     C.CUST_DSCD = '01'   OR
                     ( C.CUST_DSCD = '02' AND (C.PSNL_CD ='1101' OR C.PSNL_CD ='1102') ) OR
                     C.CUST_DSCD = '03'   OR
                     ( C.CUST_DSCD = '07' AND (C.PSNL_CD ='1101' OR C.PSNL_CD ='1102' OR C.PSNL_CD IS NULL) )
                   )
    WHERE    1=1
    AND      TO_CHAR(VRF_ENR_DTTM,'YYYYMMDD') BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND      A.CUST_CNFM_LBL_CMPL_YN = 'Y'   -- ��Ȯ���ǹ��ϷῩ��
    AND      A.TR_BR_DSCD = '1'  -- �ŷ��������ڵ�
    AND      A.KYC_TGT_RSCD NOT IN ('01','02')    --���˱������������ڵ�, IN�̸� CDD / NOT IN �̸� EDD
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ڱݼ�Ź������05',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








