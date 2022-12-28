/*
  ���α׷��� : ins_TB_OPE_KRI_��ȯ������08
  Ÿ�����̺� : TB_OPE_KRI_��ȯ������08
  KRI ��ǥ�� : ����ſ��� ��� �̱��� �Ǽ�
  ��      �� : ��ȣ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��ȯ������-08 ����ſ��� ��� �̱��� �Ǽ�
       A: ������ ���� ���������Ϸκ��� 1���� ����Ͽ����� ������/���� ������ ����������
          �����ִ� ����ſ��� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��ȯ������08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��ȯ������08
    SELECT   P_BASEDAY
            ,A.ADC_BRNO
            ,B.BR_NM
            ,A.LC_NO
            ,A.ACP_DT
            ,A.LC_ADC_PGRS_STCD
            ,SUBSTR(A.LAST_CHNG_MN_USID,1,10)
    FROM     TB_SOR_EXP_ADC_BC A   -- SOR_EXP_����ſ��������⺻
    JOIN     TB_SOR_CMI_BR_BC  B   -- SOR_CMI_���⺻
             ON   A.ADC_BRNO = B.BRNO

    WHERE    1=1
    AND      A.LC_ADC_PGRS_STCD < 2 -- �ſ���������������ڵ� 0:���屸��,1:�����ۼ�,2:��������׽���,9:�������
    AND      A.ACP_DT < TO_CHAR(ADD_MONTHS( TO_DATE(P_BASEDAY,'YYYYMMDD') , -1),'YYYYMMDD')
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��ȯ������08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

