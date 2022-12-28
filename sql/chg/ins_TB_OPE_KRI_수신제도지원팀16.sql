/*
  ���α׷��� : ins_TB_OPE_KRI_��������������16
  Ÿ�����̺� : TB_OPE_KRI_��������������16
  KRI ��ǥ�� : ���� �� 1���� �̻� ����� 2õ�����̻� ���� ���� �Ǽ�(���� ���� ����)
  ��      �� : ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-16 ���� �� 1���� �̻� ����� 2õ�����̻� ���� ���� �Ǽ�(���� ���� ����)
       A: ���Ⱑ 1���� �̻� ����� 20�鸸���̻� ������ ����(�� ���� ���� ����)
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

    DELETE OPEOWN.TB_OPE_KRI_��������������16
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������16
    SELECT   T1.STD_DT
            ,T2.TR_BRNO                AS ����ȣ
            ,T3.BR_NM                  AS ����
            ,T1.ACNO                   AS ���¹�ȣ
            ,T1.LDGR_RMD               AS ���������ݾ�
            ,T1.NW_DT                  AS ���ݽű�����
            ,T1.EXPI_DT                AS ���ݸ�������
            ,TO_DATE(T1.CNCN_DT,'YYYYMMDD') - TO_DATE(T1.EXPI_DT,'YYYYMMDD') +1  AS �������ϼ�
            ,T1.CNCN_DT                AS ������������

    FROM     OT_DWA_INTG_DPS_BC T1      -- DWA_���ռ��ű⺻

    JOIN     TB_SOR_DEP_TR_TR T2        -- SOR_DEP_�ŷ�����
             ON  T1.ACNO = T2.ACNO
             AND T1.CNCN_DT = T2.TR_DT
             AND T2.DPS_TR_STCD = '1'
             AND T2.CHNL_TPCD = 'TTML'              -- �ܸ��ŷ�

    JOIN     TB_SOR_CMI_BR_BC T3        -- SOR_CMI_���⺻
             ON T2.TR_BRNO = T3.BRNO

    WHERE    1=1
    AND      T1.STD_DT = P_BASEDAY
    AND      T1.LDGR_RMD >= 20000000          -- �ܾ�2õ�����̻�
    AND      T1.DPS_DP_DSCD = '2'                    -- ��ȭ���༺
    AND      T1.DPS_RSVG_TPCD = '2'                  -- ��ġ�Ŀ���
    AND      T1.CNCN_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      T1.DPS_ACN_STCD != '01'                 -- ��������
    AND      T1.ACNO < '200000000000'                -- �������(���հ�������)
    AND      TO_CHAR(ADD_MONTHS(TO_DATE(T1.CNCN_DT,'YYYYMMDD'), -1), 'YYYYMMDD') >= T1.EXPI_DT -- �����ϰ�� 1�����̻�
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������16',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
