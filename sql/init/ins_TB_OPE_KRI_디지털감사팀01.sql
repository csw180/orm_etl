/*
  ���α׷��� : ins_TB_OPE_KRI_�����а�����01
  Ÿ�����̺� : TB_OPE_KRI_�����а�����01
  KRI ��ǥ�� : ��ù����˰Ǽ�
  ��      �� : �����븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �����а�����-01  ��ù����˰Ǽ�
       A: ������ ���� ��ð��� �׸��� ������ �Ǽ�
       B: ������ ���� ��ð��� �׸��� ���� �Ǽ�
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
  
  DELETE FROM OPEOWN.TB_OPE_KRI_�����а�����01
  WHERE  STD_DT  IN  ( SELECT DISTINCT STD_DT FROM  TEMP_OPE_KRI_�����а�����01 );

  DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

  COMMIT;

  INSERT INTO OPEOWN.TB_OPE_KRI_�����а�����01
  SELECT STD_DT
        ,CHKG_DTT   -- ��ð��� �����ڵ�(1: ���/2: ����/3: �ϰ�/4: ����)
        ,BRNO
        ,BR_NM
        ,ONL_DT
        ,ADT_HDN
        ,ADT_HDN_NM
        ,CHKG_RSLT
        ,CASE WHEN CHKG_RSLT = '0'  THEN '������'
              WHEN CHKG_RSLT = '1'  THEN '����'
              WHEN CHKG_RSLT = '9'  THEN '����'
              ELSE '��Ÿ'
         END         CHKG_RSLT_NM
        ,CNT
  FROM   TEMP_OPE_KRI_�����а�����01;

  P_LD_CN := SQL%ROWCOUNT;

  DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

  COMMIT;

  SELECT  NVL(MAX(STD_DT),P_BASEDAY)
  INTO    P_BASEDAY
  FROM    TEMP_OPE_KRI_�����а�����01;
  
  SP_INS_ETLLOG('TB_OPE_KRI_�����а�����01',P_BASEDAY,P_LD_CN,'KRI_ETL');

END
;
/
EXEC SP_DROP_TABLE('TEMP_OPE_KRI_�����а�����01');

EXIT


