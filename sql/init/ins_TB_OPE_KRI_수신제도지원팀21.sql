/*
  ���α׷��� : ins_TB_OPE_KRI_��������������21
  Ÿ�����̺� : TB_OPE_KRI_��������������21
  KRI ��ǥ�� : ��׿��� ������ ���� ���� ��
  ��      �� : �̴�ȣ����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-21 ��׿��� ������ ���� ���� ��
       A: ������/�������� �߻��� �����Ϸκ��� 1���� ����� 1��� �̻��� ��׿��� �� ������ ���¼�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������21
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������21
    SELECT  /*+ FULL(A) FULL(B) FULL(C) FULL(D)   */
             P_BASEDAY
            ,B.TR_BRNO
            ,C.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,A.DPS_DP_DSCD
            ,B.CRCD
            ,D.TR_PCPL + D.BSC_INT AS �ŷ��ݾ�
            ,A.NW_DT
            ,A.EXPI_DT
            ,A.CNCN_DT

    FROM     TB_SOR_DEP_DPAC_BC A   -- SOR_DEP_���Ű��±⺻

    JOIN     TB_SOR_DEP_TR_TR B    -- SOR_DEP_�ŷ�����
             ON   A.ACNO = B.ACNO
             AND  B.TR_DT   BETWEEN  P_SOTM_DT AND P_EOTM_DT
             AND  B.CHNL_TPCD = 'TTML'
             AND  B.DPS_TSK_CD = '0401'   -- �����ŷ�
             AND  B.DPS_TR_STCD = '1'

    JOIN     TB_SOR_CMI_BR_BC C    -- SOR_CMI_���⺻
             ON   B.TR_BRNO = C.BRNO
             AND  C.BR_DSCD  = '1'

    JOIN     TB_SOR_DEP_TR_DL D    -- SOR_DEP_�ŷ���
             ON   B.ACNO   = D.ACNO
             AND  B.TR_DT  = D.TR_DT
             AND  B.TR_SNO = D.TR_SNO
             AND  D.TR_PCPL + D.BSC_INT >= 100000000  -- ����+���� �� 1����̻�

    WHERE    1=1
    AND      A.DPS_DP_DSCD = '2'
    AND      A.CNCN_DT > TO_CHAR(ADD_MONTHS(TO_DATE(A.EXPI_DT,'YYYYMMDD'), 1), 'YYYYMMDD')
             -- �����Ϸκ��� 1������ �����Ŀ� �����Ȱ�

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������21',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

