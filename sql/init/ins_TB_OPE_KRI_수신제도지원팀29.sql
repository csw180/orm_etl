/*
  ���α׷��� : ins_TB_OPE_KRI_��������������29
  Ÿ�����̺� : TB_OPE_KRI_��������������29
  KRI ��ǥ�� : �������� ��Ź ����/��� �� ��ȯ �Ǽ�
  ��      �� : ���ڿ�
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������29 : �������� ��Ź ����/��� �� ��ȯ �Ǽ�
       A: ����Ⱓ �� �������� �������� ��Ź����/��� �� ��ȯ�� �ŷ� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������29
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������29
    SELECT   /*+ FULL(T1) FULL(T2) */
             P_BASEDAY
            ,T1.HDL_BRNO       -- ����ȣ
            ,TRIM(T2.BR_NM)    -- ����
            ,T1.CSNT_ACNO      -- �����������¹�ȣ
            ,CASE WHEN (T1.CSNT_TR_DSCD = '25' AND T1.CSNT_STCD = '15') THEN '��Ź���'
                  WHEN (T1.CSNT_TR_DSCD = '29' AND T1.CSNT_STCD = '19') THEN '��Ź����'
                  WHEN (T1.CSNT_TR_DSCD = '40' AND T1.CSNT_STCD = '21') THEN '��ȯ'
             END                         -- ��Ź����������ұ���
            ,CASE WHEN (T1.CSNT_TR_DSCD = '40' AND T1.CSNT_STCD = '21') THEN T1.TR_DT END --��ȯ����
            ,T1.ENR_USR_NO               -- ������������ȣ

    FROM     TB_SOR_CTD_CSNT_TR_TR                     T1 -- SOR_CTD_���������ŷ�����

    JOIN     TB_SOR_CMI_BR_BC                          T2 -- SOR_CMI_���⺻
             ON  T1.HDL_BRNO = T2.BRNO
             AND T2.BR_DSCD        = '1'
             AND T2.BR_KDCD  IN ('10','20','30')
             AND T2.FSC_DSCD       = '1'

    WHERE    1=1
    AND      T1.TR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      T1.CSNT_TR_DSCD IN ('25', '29', '40')  -- ���������ŷ������ڵ� (25 : ��Ź���, 29 : ��Ź����, 40 : ��ȯ)
    AND      T1.CSNT_STCD IN ('15', '19', '21') -- �������������ڵ� (15 : ��Ź���, 19 : ��Ź����, 21 : ��ȯ)
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������29',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








