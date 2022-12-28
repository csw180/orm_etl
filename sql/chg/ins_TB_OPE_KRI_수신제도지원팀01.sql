/*
  ���α׷��� : ins_TB_OPE_KRI_��������������01
  Ÿ�����̺� : TB_OPE_KRI_��������������01
  KRI ��ǥ�� : �޸���� ��� �Ǽ�
  ��      �� : �̴�ȣ����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-01 �޸հ��� ��ݰǼ�
       A: ������/���� �������� �޸���¿��� 10�����̻� ��� �ŷ��� �߻��� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������01
    SELECT  /*+ FULL(A) FULL(B) FULL(C) FULL(J1) FULL(D)   */
             P_BASEDAY
            ,B.TR_BRNO
            ,J1.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,'Y'
            ,C.OPRF_PCS_DT
            ,B.CRCD
            ,(D.TR_PCPL + D.BSC_INT) AS ��ݱݾ�
            ,D.TR_DT
            ,A.DPS_ACN_STCD
            ,B.TR_USR_NO

    FROM     TB_SOR_DEP_DPAC_BC A   -- SOR_DEP_���Ű��±⺻

    JOIN     TB_SOR_DEP_TR_TR   B   -- SOR_DEP_�ŷ�����
             ON  A.ACNO = B.ACNO
             AND B.TR_DT BETWEEN P_SOTM_DT  AND  P_EOTM_DT
             AND B.DPS_TSK_CD = '0401'  -- 0401:����

    JOIN     TB_SOR_DEP_OPRF_TR C   -- SOR_DEP_����ͳ���
             ON  A.ACNO = C.ACNO

    JOIN     TB_SOR_CMI_BR_BC  J1   -- SOR_CMI_���⺻
             ON  B.TR_BRNO = J1.BRNO
             AND J1.BR_DSCD  = '1'

    JOIN     TB_SOR_DEP_TR_DL D  -- SOR_DEP_�ŷ���
             ON   B.ACNO   = D.ACNO
             AND  B.TR_DT  = D.TR_DT
             AND  B.TR_SNO = D.TR_SNO
             AND  D.TR_PCPL + D.BSC_INT >= 100000

    WHERE    1=1
    AND      A.DPS_ACN_STCD IN ('14','15','18')
            -- ���Ű��»����ڵ�(DPS_ACN_STCD):14:�����â��ȯ������,15:����������ϰ�ȯ������,18:����������޽�û
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
