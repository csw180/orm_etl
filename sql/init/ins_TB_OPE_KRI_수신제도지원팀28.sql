/*
  ���α׷��� : ins_TB_OPE_KRI_��������������28
  Ÿ�����̺� : TB_OPE_KRI_��������������28
  KRI ��ǥ�� : ���������ܾ�Ȯ�μ� �߱� �Ǽ�
  ��      �� : ���ڿ�
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������28 : ���������ܾ�Ȯ�μ� �߱� �Ǽ�
       A: ����Ⱓ �� �������� ������������ �ܾ�Ȯ�μ� �߱� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������28
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������28
    SELECT      /*+ FULL(T1) FULL(T2) */
                P_BASEDAY
               ,T1.HDL_BRNO                      --����ȣ
               ,T2.BR_NM                         --����
               ,T1.INP_INTG_ACNO                 --���������ܾ�Ȯ�μ����¹�ȣ
               ,T1.ONL_DT                        --���������ܾ�Ȯ�μ��߱�����
               ,T1.USR_NO                        --������������ȣ

    FROM        TB_CBC_CMP_TSK_LOG_SMR_TR                 T1  -- CBC_CMP_���վ����α׿�೻��

    JOIN        TB_SOR_CMI_BR_BC                          T2  -- SOR_CMI_���⺻
                ON  T1.HDL_BRNO = T2.BRNO
                AND T2.BR_DSCD        = '1'
                AND T2.BR_KDCD  IN ('10','20','30')
                AND T2.FSC_DSCD       = '1'

    WHERE       1=1
    AND         T1.ONL_DT BETWEEN P_SOTM_DT AND P_EOTM_DT  -- �¶�������
    AND         T1.INP_SCRN_ID IN ('6520SC00')  -- �Է�ȭ��ID
    AND         T1.INP_TLG_ID = 'CTD168001'    -- �Է�����ID  -
    AND         T1.SBCD = '440'  -- �����ڵ�(440:��������)
    AND         T1.CHNL_TPCD IN ( 'TTML')  -- ä�������ڵ�(TTML:�ܸ�)
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������28',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








