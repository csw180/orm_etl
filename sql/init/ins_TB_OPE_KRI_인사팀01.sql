/*
  ���α׷��� : ins_TB_OPE_KRI_�λ���01
  Ÿ�����̺� : TB_OPE_KRI_�λ���01
  KRI ��ǥ�� : ���������� ������
  ��      �� :
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �λ���-01 ���������� ������
       A: ���� �� ���� ���� ���� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�λ���01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�λ���01
    SELECT
             �ۼ�������
            ,����ȣ
            ,����
            ,���������ڵ�
            ,�������и�
            ,���
            ,������
            ,��������
    --        ,ȸ���ڵ��
    FROM     TB_MDWT�߾�ȸ�λ�
    WHERE    �ۼ������� = P_BASEDAY
    AND      ������   BETWEEN  P_SOTM_DT AND P_EOTM_DT
    AND      �����и�   = '��������'
    AND      �������и� = '������'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�λ���01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT