/*
  ���α׷��� : ins_TB_OPE_KRI_����������01
  Ÿ�����̺� : TB_OPE_KRI_����������01
  KRI ��ǥ�� : ���ڹ��� �̰��� �Ǽ�
  ��      �� : Ȳ��������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-01 ���ڹ��� �̰��� �Ǽ�
       A: �����ڿ��� ���� ��󹮼��� �����Ͽ����� 3������ �̳� ����ó���� ���� ���� �Ǽ�
          (��ȹ��� ���)
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

  DELETE FROM OPEOWN.TB_OPE_KRI_����������01
  WHERE  STD_DT  IN  ( SELECT DISTINCT STD_DT FROM  TEMP_OPE_KRI_����������01 );

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

  COMMIT;

  INSERT INTO OPEOWN.TB_OPE_KRI_����������01
  SELECT *
  FROM   TEMP_OPE_KRI_����������01;

  P_LD_CN := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

  COMMIT;

  SELECT  NVL(MAX(STD_DT),P_BASEDAY)
  INTO    P_BASEDAY
  FROM    TEMP_OPE_KRI_����������01;

  SP_INS_ETLLOG('TB_OPE_KRI_����������01',P_BASEDAY,P_LD_CN,'KRI_ETL');

END
;
/
EXEC SP_DROP_TABLE('TEMP_OPE_KRI_����������01');

EXIT
