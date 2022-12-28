/*
  ���α׷��� : ins_TB_OPE_KRI_����������01
  Ÿ�����̺� : TB_OPE_KRI_����������01
  KRI ��ǥ�� : �ѵ��� ���� ���� ���� ���� �� ������ ���� ���� ��
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-01  �ѵ��� ���� ���� ���� ���� �� ������ ���� ���� ��
       A: �ѵ��� �������� ���� ���� �� �ſ���ǥ�� �ſ����� ccc+�����̸�,
          �ſ����� �ѵ������� ���� ��� �϶��� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_����������01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������01
    SELECT   A.��������
            ,A1.��ǥ��
            ,J.BR_NM
            ,A.���հ��¹�ȣ
            ,A.����ȣ
            ,A.���αݾ�
            --,a.�������ݾ�
            --,a.�����ܾ�
            ,sum(A.�����ܾ�)  AS �ܾ�
            --,a.�̻���ѵ��ݾ�
            ,A.��������
            --,a.��������
            ,A.����ſ��򰡵��
            ,A.����ȿ����
            --,max(A.���°���������ڵ�)
    FROM     TB_DWF_LAQ_�����������Ϻ���   A
    --FROM     TB_DWF_LAQ_���������¿�����   A

    JOIN     (   -- ���º��� ���������� ����������� ���ü� �־� �־��� ����� ���µ������ ����.
                 -- ���ϰ��¹�ȣ�� �����е��������� �ٸ����� ���ÿ� �����ϴ°�� �����е������� ������ �ٸ����� ��ǥ������ �Ѵ�.
              SELECT   A.���հ��¹�ȣ, MAX(A.���°���������ڵ� ) MAX_GD
                      ,NVL(MAX(CASE WHEN A.����ȣ  = '0865' THEN NULL ELSE A.����ȣ END),'0865') AS ��ǥ��
              FROM     TB_DWF_LAQ_�����������Ϻ���  A
              --FROM     TB_DWF_LAQ_���������¿�����   A
              WHERE    1=1
              AND      A.��������  =  P_BASEDAY
              GROUP BY A.���հ��¹�ȣ
              HAVING   MAX(A.���°���������ڵ�) >= '2'  -- ����������
             )    A1
             ON   A.���հ��¹�ȣ  = A1.���հ��¹�ȣ

    JOIN     TB_SOR_CMI_BR_BC   J
             ON A1.��ǥ��  = J.BRNO

    WHERE    1=1
    AND      A.��������  =  P_BASEDAY
    AND      A.�����ѵ����ⱸ���ڵ�  =  '2'  -- �ѵ�

    GROUP BY A.��������
            ,A1.��ǥ��
            ,J.BR_NM
            ,A.���հ��¹�ȣ
            ,A.����ȣ
            ,A.���αݾ�
            ,A.��������
            ,A.����ſ��򰡵��
            ,A.����ȿ����
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
