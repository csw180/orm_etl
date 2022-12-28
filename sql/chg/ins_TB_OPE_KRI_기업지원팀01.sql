/*
  ���α׷��� : ins_TB_OPE_KRI_���������01
  Ÿ�����̺� : TB_OPE_KRI_���������01
  KRI ��ǥ�� : ��ü TCB�� �Ƿڰ��� ���ܽ��� �����
  ��      �� : �̻�ΰ���
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ���������-01 ��ü TCB�� �Ƿڰ��� ���ܽ��� �����
       A: ��ü TCB�� �Ƿڰ� �� ���ܽ��� �����
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

    DELETE OPEOWN.TB_OPE_KRI_���������01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_���������01
    SELECT   P_BASEDAY
            ,TRIM(A.TCH_EVL_APCT_BR_CD_NM)      -- ����򰡽�û�����ڵ��
            ,TRIM(A.TCH_EVL_APC_BR_NM)          -- ����򰡽�û����
            ,A.TCH_EVL_BRN                      -- ����򰡻���ڵ�Ϲ�ȣ
            ,A.STDD_INDS_CLCD                   -- ǥ�ػ���з��ڵ�
            ,A.TCH_EVL_APC_DT                   -- ����򰡽�û����
            ,'Y'                                -- ���ܿ���
            ,C.TCH_EVL_EXCP_ENR_RSCD            -- ����򰡿��ܵ�ϻ����ڵ�

    FROM     TB_SOR_CCR_TCB_EVL_APC_TR   A -- SOR_CCR_TCB�򰡽�û����

    JOIN     TB_SOR_CCR_TCB_EVL_TR       B -- SOR_CCR_TCB�򰡳���
             ON   A.TCH_EVL_RQST_ISTT_ADM_NO  = B.TCH_EVL_RQST_ISTT_ADM_NO
             AND  B.TCH_EVL_PGRS_STS_CD  <> '03'   -- �������������ڵ�

    JOIN     TB_SOR_CCR_TCB_EVL_RQS_TR   C -- SOR_CCR_TCB�򰡿�û����
             ON   B.TCH_EVL_RQST_ISTT_ADM_NO  = C.TCH_EVL_RQST_ISTT_ADM_NO

    WHERE    1=1
    AND      A.TCH_EVL_APC_DT  BETWEEN P_SOTM_DT AND P_EOTM_DT
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_���������01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
