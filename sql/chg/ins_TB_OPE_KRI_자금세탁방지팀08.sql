/*
  ���α׷��� : ins_TB_OPE_KRI_�ڱݼ�Ź������08
  Ÿ�����̺� : TB_OPE_KRI_�ڱݼ�Ź������08
  KRI ��ǥ�� : ������ �񿵸����� KYC�������
  ��      �� : �������븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ڱݼ�Ź������-08 ������ �񿵸����� KYC�������
      A: ���� �� ������ ������/������ �񿵸����� KYC ���� �� �� Ȯ��
         ���ؿ� �� ������/������ �񿵸����� KYC ���� ����(������)
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

    DELETE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������08
    SELECT   P_BASEDAY
            ,A.BLNT_BRNO      -- ����ȣ
            ,J.BR_NM          -- ����
            ,A.CUST_NO        -- ����ȣ
            ,'�񿵸�'         -- ������
            ,TO_CHAR(A.VRF_ENR_DTTM,'YYYYMMDD') --  KYC������
            ,A.KYC_SNO        -- KYC�Ϸù�ȣ
    FROM     TB_SOR_CUS_KYC_TR A   -- SOR_CUS_KYC����
    JOIN     TB_SOR_CUS_MAS_BC B   -- SOR_CUS_���⺻
             ON    A.CUST_NO = B.CUST_NO
             AND   B.CUST_INF_STCD = '1'
             AND   B.CUST_AVL_CD   = '1'
             AND   B.CUST_DSCD     = '02'
             AND   B.PSNL_CD      IN ('2101', '2201', '3204',
                                      '3212', '3213', '3215',
                                      '4101', '4102', '4103',
                                      '4111', '4112', '4201',
                                      '4211', '4221', '4301',
                                      '4401', '4501', '5201',
                                      '5211')

    JOIN     TB_SOR_CMI_BR_BC    J   -- SOR_CMI_���⺻
             ON    A.ENR_BRNO   = J.BRNO
             AND   J.BR_DSCD = '1'
        --     AND  (CLBR_DT IS NULL OR CLBR_DT >= '20220430')
        --     AND  (CLBR_DT IS NULL OR CLBR_DT >= P_BASEDAY)
    WHERE    1=1
    AND      TO_CHAR(VRF_ENR_DTTM,'YYYYMMDD') BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND      A.CUST_CNFM_LBL_CMPL_YN = 'Y'
    AND      A.TR_BR_DSCD    = '1'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ڱݼ�Ź������08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








