/*
  ���α׷��� : ins_TB_OPE_KRI_���������02
  Ÿ�����̺� : TB_OPE_KRI_���������02
  KRI ��ǥ�� : ������ȸ�� ���� �߱� �Ǽ�
  ��      �� : ������ �븮
  �����ۼ��� : �ֻ��

  KRI ��ǥ�� :
     - ���������-02 ������ȸ�� ���� �߱� �Ǽ�
       A: ������ ������ȸ�� ����߱� �Ǽ�(���� �ڵ��߱޺� ����)
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

    DELETE OPEOWN.TB_OPE_KRI_���������02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_���������02
    SELECT   P_BASEDAY              --����������
            ,ISN_BRNO               --�߱�����ȣ
            ,RSBL_SLS_BR_NM         --��翵������
            ,CUST_NO                --����ȣ
            ,RBCI_ISN_NO            --������ȸ���߱޹�ȣ
            ,RBCI_ISN_CD            --������ȸ���߱��ڵ� (1:�߱�,2:��ȸ)
            ,ISN_DT                 --�߱�����
            ,CHPR_NM                --����ڸ�
    FROM     TB_SOR_CIS_RBCI_ISN_TR A   --SOR_CIS_������ȸ���߱޳���
    WHERE    1=1
    AND      NFFC_UNN_DSCD     =  '1'   --�߾�ȸ���ձ����ڵ�(1:�߾�ȸ)
    AND      ISN_DT   BETWEEN  P_SOTM_DT AND P_EOTM_DT
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_���������02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

