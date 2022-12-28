/*
  ���α׷��� : ins_TB_OPE_KRI_��������������07
  Ÿ�����̺� : TB_OPE_KRI_��������������07
  KRI ��ǥ�� : �Ա� ��� �Ǽ�
  ��      �� : ��������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-07 �Ա� ��� �Ǽ�
       A: ���� �� ���� 100���� �ʰ� ������ŷ� �Ա� ����/��� �߻� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������07
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������07
    SELECT P_BASEDAY
          ,A.TR_BRNO
          ,B.BR_NM
          ,A.ACNO
          ,C.CUST_NO
          ,A.TR_AMT
          ,A.DPS_TR_STCD
          --,CASE WHEN A.DPS_TR_STCD = '2' THEN '����'
          --      WHEN A.DPS_TR_STCD = '3' THEN '���'
          --      ELSE A.DPS_TR_STCD
          -- END          -- ���Űŷ������ڵ�
          ,A.OGTR_DT    -- �Աݰŷ�����
          ,A.TR_DT      -- ��Ұŷ�����
          ,A.TR_USR_NO  -- ������������ȣ

    FROM   TB_SOR_DEP_TR_TR   A    --  SOR_DEP_�ŷ�����
    JOIN   TB_SOR_CMI_BR_BC      B   -- SOR_CMI_���⺻
           ON  A.TR_BRNO   =   B.BRNO
           AND B.BR_DSCD   =   '1'  -- ����
    JOIN   TB_SOR_DEP_DPAC_BC  C   -- SOR_DEP_���Ű��±⺻
           ON  A.ACNO      =  C.ACNO
    WHERE  1=1
    AND    A.TR_DT   BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND    A.DPS_TSK_CD   =  '0201'  -- ���ž����ڵ� �Ա�:0201
    AND    A.DPS_TR_STCD   IN  ('2','3')  -- ���Űŷ������ڵ� 2:����, 3:���
    AND    A.WOBK_YN  = 'Y'      -- �����忩��
    AND    A.TR_AMT > 1000000    -- ������ 100�����̻�ŷ�
    AND    A.CHNL_TPCD =  'TTML'  -- ä�������ڵ� �ܸ��ŷ�:TTML
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������07',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT





