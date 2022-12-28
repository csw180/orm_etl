/*
  ���α׷��� : ins_TB_OPE_KRI_�Һ��ں�ȣ��02
  Ÿ�����̺� : TB_OPE_KRI_�Һ��ں�ȣ��02
  KRI ��ǥ�� : �ο�����������
  ��      �� : �����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �Һ��ں�ȣ��-02 �ο�����������
       A: ���� �ݰ��� �Ǵ� ���� �ο� ���� �Ǽ�
       B: ������ �ݰ��� �Ǵ� ���� �ο� ���� �Ǽ�
     - �Һ��ں�ȣ��-03 �ο� �� ���Ҹ� �ܺ�ä�� ���� �Ǽ�
       A: ���� �� ��ܰ��(EX:�ݰ���, �Һ��� ��)�� ���Ͽ� ������ �Ҹ��ο�����
     - �Һ��ں�ȣ��-04 �ο� �� ���Ҹ� ����ä�� ���� �Ǽ�
       A: ���� �� �ο������ý��� �� ������ �� �Ҹ� �� �ο� ���� �Ǽ�
     - �Һ��ں�ȣ��-05 �ο� ����ó�� ���ѳ� �̿Ϸ� �Ǽ�
       A: "�ο�ó���Ϸ��� >= �ο�����ó������" �� �ο��Ǽ�
       B: "������ >= �ο�����ó������ AND �ο�ó���̿Ϸ�" �� �ο��Ǽ�
     - ��ī��������-01 ��ī������ �ҿ����Ǹ�(�ο��߻�) �Ǽ�
       A: ���հ��������ý��ۿ� ����� �ο� �� ��ī������ ���� �̰��� �ο��� �Ǽ�
*/

DECLARE
  P_BASEDAY  VARCHAR2(8);  -- ��������
  P_SOTM_DT  VARCHAR2(8);  -- �������
  P_EOTM_DT  VARCHAR2(8);  -- �������
  P_LD_CN    NUMBER;       -- �ε��Ǽ�

BEGIN
  SELECT  STD_DT,EOTM_DT,SUBSTR(EOTM_DT,1,6) || '01'
  INTO    P_BASEDAY
         ,P_EOTM_DT
         ,P_SOTM_DT
  FROM    OPEOWN.TB_OPE_DT_BC
  WHERE   STD_DT_YN  = 'Y';

  DELETE FROM OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02
  WHERE  STD_DT  IN  ( SELECT DISTINCT STD_DT FROM  TEMP_OPE_KRI_�Һ��ں�ȣ��02 );

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

  COMMIT;

  INSERT INTO OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��02
  SELECT *
  FROM   TEMP_OPE_KRI_�Һ��ں�ȣ��02;

  P_LD_CN := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

  COMMIT;

  SELECT  NVL(MAX(STD_DT),P_BASEDAY)
  INTO    P_BASEDAY
  FROM    TEMP_OPE_KRI_�Һ��ں�ȣ��02;
  
  SP_INS_ETLLOG('TB_OPE_KRI_�Һ��ں�ȣ��02',P_BASEDAY,P_LD_CN,'KRI_ETL');

END
;
/
EXEC SP_DROP_TABLE('TEMP_OPE_KRI_�Һ��ں�ȣ��02');

EXIT
