/*
  ���α׷��� : ins_TB_OPE_KRI_���ո�������03
  Ÿ�����̺� : TB_OPE_KRI_���ո�������03
  KRI ��ǥ�� : ��Ʈ�� �� Ư�� ���� �Ǽ�
  ��      �� : ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ���ո�������-03: ��Ʈ�� �� Ư�� ���� �Ǽ�
       A: ���������� ��û�� Ư������ �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_���ո�������03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_���ո�������03

    SELECT   P_BASEDAY
            ,A.ENR_BRNO �������ȣ
            ,J1.BR_NM
            ,A.CUST_NO ����ȣ
            ,B.CUST_DSCD �������ڵ�
            ,A.ENR_DTTM  Ư�ʽ�û��
            ,A.CUST_APRV_STCD   AS �����λ����ڵ�
            ,A.APC_RSN ��û����
            ,A.APRV_USR_NO ���λ���ڹ�ȣ
            ,A.APRV_BRNO ��������ȣ
            ,A.ENR_USR_NO ��ϻ���ڹ�ȣ

    FROM     TB_SOR_CUS_BR_SCS_BC A  --SOR_CUS_����Ư�ʽ�û�⺻

    JOIN     TB_SOR_CUS_MAS_BC B    --SOR_CUS_���⺻
             ON     A.CUST_NO = B.CUST_NO

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
             ON    A.ENR_BRNO  =  J1.BRNO

    WHERE    1 = 1
    AND      TO_CHAR(A.ENR_DTTM,'YYYYMMDD') BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      A.NFFC_UNN_DSCD = '1' --����
    AND      A.CUST_APRV_STCD  = '1'   -- �����λ����ڵ�(1:����,2:�ݷ�,5:��û,6:�κн���)

    UNION ALL

    SELECT   P_BASEDAY
            ,A.ENR_BRNO �������ȣ
            ,J1.BR_NM
            ,A.RLT_CUST_NO ����ȣ
            ,B.CUST_DSCD �������ڵ�
            ,A.ENR_DTTM   Ư�ʽ�û��
            ,'1' AS �����λ����ڵ�
            ,' 'AS ��û����
            ,A.CHG_USR_NO ���λ���ڹ�ȣ
            ,A.CHG_BRNO ��������ȣ
            ,A.CHG_USR_NO ��ϻ���ڹ�ȣ

    FROM     TB_SOR_CUS_RLT_SCS_BC A  --SOR_CUS_����Ư�ʽ�û�⺻
    JOIN     TB_SOR_CUS_MAS_BC B     --SOR_CUS_���⺻
             ON     A.RLT_CUST_NO = B.CUST_NO

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
             ON    A.ENR_BRNO  =  J1.BRNO

    WHERE    1 = 1
    AND      TO_CHAR(A.ENR_DTTM,'YYYYMMDD') BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      A.APRV_CUST_GDCD IS NOT NULL
    AND      A.NFFC_UNN_DSCD = '1' --����
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_���ո�������03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


