/*
  ���α׷��� : ins_TB_OPE_KRI_��������������17
  Ÿ�����̺� : TB_OPE_KRI_��������������17
  ��      �� : ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������17 : ������ ���ݰ��� ����
       A: ������ ���� 1õ���� �̻� ������ ���� �� ������ 1���� �̻� ����� �Ǽ�
       B: ������ ���� 1õ���� �̻� ������ ���¼�
     - ��������������18 : ������ ���ݰ��� �Ǽ�
       A: ������ ���� ������ 1���� �̻� ����� 1õ���� �̻� ���ݰ��� �Ǽ� - ��������������17-A �� ����
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
  FROM    OPEOWN.TB_OPE_DT_BC
  WHERE   STD_DT_YN  = 'Y';

  IF P_EOTM_DT = P_BASEDAY  THEN

    DELETE OPEOWN.TB_OPE_KRI_��������������17
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������17
    SELECT   T1.STD_DT                 AS ��������
            ,T1.ADM_BRNO               AS ����ȣ
            ,T2.BR_NM                  AS ����
            ,T1.ACNO                   AS ���¹�ȣ
            ,T1.CUST_NO                AS ����ȣ
            ,T1.LDGR_RMD               AS ���������ݾ�
            ,T1.EXPI_DT                AS ���ݸ�������
            ,TO_DATE(T1.STD_DT,'YYYYMMDD') - TO_DATE(T1.EXPI_DT,'YYYYMMDD') + 1  AS �������ϼ�

    FROM     OT_DWA_INTG_DPS_BC T1      -- DWA_���ռ��ű⺻

    JOIN     TB_SOR_CMI_BR_BC T2        -- SOR_CMI_���⺻
             ON   T1.ADM_BRNO = T2.BRNO

    WHERE    1=1
    AND      T1.STD_DT =  P_BASEDAY
    AND      T1.LDGR_RMD >= 10000000                 -- �ܾ�1õ�����̻�
    AND      T1.DPS_DP_DSCD = '2'                    -- ��ȭ���༺(��/����)
    AND      T1.DPS_ACN_STCD = '01'                  -- Ȱ������
    AND      T1.ACNO < '200000000000'                -- �������(���հ�������)
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������17',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
