/*
  ���α׷��� : ins_TB_OPE_KRI_�ڱݼ�Ź������06
  Ÿ�����̺� : TB_OPE_KRI_�ڱݼ�Ź������06
  KRI ��ǥ�� : ������ ����ڻ갡 ���Ǽ�
  ��      �� : �������븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ڱݼ�Ź������-06 ������ ����ڻ갡 �� �Ǽ�(������)
       A: ���� �� ���� ����ڻ갡 �� �� ������ ������/������ ��ǥ �Ѱ�
          ���ؿ� �� ���� ���� ��� ����ڻ갡 �� �� ������ ������/�������� ��ǥ �Ѱ� Ȯ��
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

    DELETE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������06
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������06
    SELECT   P_BASEDAY  AS ��������
            ,A.ENR_BRNO 
            ,D.BR_NM
            ,TRIM(CD_CTS) AS ����ȣ
            
    FROM     TB_SOR_CUS_KYC_RSK_BC  A  -- SOR_CUS_KYC����켱����⺻
    
    LEFT OUTER JOIN
             TB_SOR_CMI_BR_BC D    -- SOR_CMI_���⺻
             ON   A.ENR_BRNO = D.BRNO
             AND  D.BR_DSCD  = '1'
                 
    WHERE    1=1
    AND      A.KYC_RSK_PFRD_APL_DSCD = '04' -- ���˱���������켱���뱸���ڵ�
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ڱݼ�Ź������06',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
