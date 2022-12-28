/*
  ���α׷��� : ins_TB_OPE_KRI_��������������06
  Ÿ�����̺� : TB_OPE_KRI_��������������06
  KRI ��ǥ�� : ��(���)�Ű� �� ���� ��߱� �Ǽ�
  ��      �� : ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-06 ��(���)�Ű� �� ���� ��߱� �Ǽ�
       A: ���� �� ���ܰŷ������� �ش�� ��(���)�Ű� ������߱� �����Ǽ�
          (�ΰ��н������, ����н������, �ΰ����������, �ΰ��Ѽ�(����)�����)
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

    DELETE OPEOWN.TB_OPE_KRI_��������������06
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������06
    SELECT   P_BASEDAY
            ,T1.ENR_BRNO          AS ����ȣ
            ,T2.BR_NM             AS ����
            ,T1.ACNO              AS ���¹�ȣ
            ,T3.CUST_NO           AS ����ȣ
            ,T1.IMCW_SBCD         AS �߿����������ڵ�
            ,T1.BNKB_ISN_RSCD     AS ��߱޻����ڵ�
            ,T1.ENR_DT            AS ��߱�����
            ,T1.ENR_USR_NO        AS ������������ȣ

    FROM     TB_SOR_DEP_BNKB_ADM_TR T1  -- SOR_DEP_�����������

    JOIN     TB_SOR_CMI_BR_BC T2        -- SOR_CMI_���⺻
             ON T1.ENR_BRNO = T2.BRNO

    JOIN     TB_SOR_DEP_DPAC_BC T3          -- SOR_DEP_���Ű��±⺻
             ON  T1.ACNO = T3.ACNO
             AND T3.ACNO < '200000000000'    -- �������(���հ�������)

    WHERE    1=1
    AND      T1.ENR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      T1.LDGR_STCD = '1'                            -- �����ڵ� : 1 - ����
    AND      T1.DPS_BNKB_ADM_KDCD = '022'                  -- ������������ڵ� : 022-��߱�
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������06',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
