/*
  ���α׷��� : ins_TB_OPE_KRI_ī���ȹ��01
  Ÿ�����̺� : TB_OPE_KRI_ī���ȹ��01
  KRI ��ǥ�� : �ſ�ī��(����) Ư���ѵ� ���ΰǼ�
  ��      �� : �弱������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ī���ȹ��-01 �ſ�ī��(����) Ư���ѵ� ���ΰǼ�
       A: ������/�������� �ſ�ī�� ����ȸ���� ���� Ư���ѵ��� ������ �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_ī���ȹ��01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_ī���ȹ��01

    SELECT   A.STD_DT
            ,A.CRD_MBR_ADM_BRNO
            ,J1.BR_NM
            ,A.CRD_MBR_DSCD
            ,A.PREN_DSCD
            ,B.CUST_SPCL_LMT_AMT
            ,B.SPCL_LMT_APC_RSN            -- Ư���ѵ���û����
         --   ,B.SPCL_LMT_EVD_PPR_CTS        --Ư���ѵ�������������
            ,B.LMT_CHG_USR_NO
            ,B.LMT_CHG_DT                --�ѵ���������
    FROM     (
              SELECT   STD_DT
                      ,CRD_MBR_ADM_BRNO
                      ,CUST_NO
                      ,CRD_MBR_NO
                      ,CRD_MBR_DSCD
                      ,PREN_DSCD
              FROM     OT_DWA_INTG_CRD_BC    A   -- DWA_����ī��⺻
              WHERE    1=1
              AND      A.STD_DT  =  P_BASEDAY
              AND      A.PREN_DSCD     =  '1'  -- ����
              AND      A.CRD_MBR_DSCD  =  '1'  -- ī��ȸ������ (1:�ſ�)
              GROUP BY STD_DT
                      ,CRD_MBR_ADM_BRNO
                      ,CUST_NO
                      ,CRD_MBR_NO
                      ,CRD_MBR_DSCD
                      ,PREN_DSCD
             )  A
    JOIN     TB_SOR_MBR_LMT_CHG_HT  B    --SOR_MBR_ī����ѵ������̷�
             ON   A.CRD_MBR_NO    =  B.CRD_MBR_NO
             AND  B.LMT_CHG_HDCD  =  '14'  -- �ѵ������׸��ڵ�(14:����Ư���ѵ�)
             AND  B.CUST_SPCL_LMT_AMT  > 0  --   ��Ư���ѵ��ݾ�, Ư���ѵ��� ���ΰ��� ����
             AND  B.LMT_CHG_DT  BETWEEN  P_SOTM_DT  AND   P_EOTM_DT

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
             ON  A.CRD_MBR_ADM_BRNO  =  J1.BRNO

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_ī���ȹ��01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
