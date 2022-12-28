/*
  ���α׷��� : ins_TB_OPE_KRI_���ո�������04
  Ÿ�����̺� : TB_OPE_KRI_���ո�������04
  KRI ��ǥ�� : �ʿ췮 �� ��Ż �Ǽ�
  ��      �� : �뼺ȯ����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ���ո�������-04: �ʿ췮 �� ��Ż �Ǽ�
       A: ������ �߻��� �ʿ췮 �� ��Ż ��
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
  FROM   DWZOWN.OM_DWA_DT_BC
  WHERE   STD_DT = '&1';
  
  IF P_EOTM_DT = P_BASEDAY  THEN
  
    DELETE OPEOWN.TB_OPE_KRI_���ո�������04
    WHERE  STD_DT = P_EOTM_DT;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_���ո�������04
    -- ���� �ʿ췮 -> ��� �����Ż
    SELECT   /*+ FULL(A) */
             A.��������
            ,A.�ְŷ�����ȣ
            ,A.�ְŷ�����
            ,A.����ȣ
            ,A.CRM����ڵ�
    FROM     CRM.TB_SFAT�����ս��� A
    WHERE    1=1
    AND      A.��������     = P_EOTM_DT
    AND      A.CRM����ڵ� != '01'
    AND      EXISTS (SELECT  /*+ FULL(X) */
                             1
                     FROM    CRM.TB_SFAT�����ս��� X
                     WHERE   X.����ȣ = A.����ȣ
                     AND     X.�������� = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(P_EOTM_DT, 'YYYYMMDD'), -1)), 'YYYYMMDD')  -- ����
                     AND     X.CRM����ڵ� = '01'
                    )
    UNION ALL

    -- ���� �ʿ췮 -> ��� ��������
    SELECT   /*+ FULL(A) */
             P_EOTM_DT
            ,A.�ְŷ�����ȣ
            ,A.�ְŷ�����
            ,A.����ȣ
            ,''  CRM����ڵ�
    FROM     CRM.TB_SFAT�����ս��� A
    WHERE    1=1
    AND      A.��������    = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(P_EOTM_DT, 'YYYYMMDD'), -1)), 'YYYYMMDD')
    AND      A.CRM����ڵ� = '01'
    AND      NOT EXISTS (SELECT /*+ FULL(X) */
                                1
                         FROM   CRM.TB_SFAT�����ս��� X
                         WHERE  X.����ȣ = A.����ȣ
                         AND    X.�������� = P_EOTM_DT
                        )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_���ո�������04',P_EOTM_DT,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
