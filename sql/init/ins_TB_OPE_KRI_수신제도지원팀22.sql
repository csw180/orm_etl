/*
  ���α׷��� : ins_TB_OPE_KRI_��������������22
  Ÿ�����̺� : TB_OPE_KRI_��������������22
  KRI ��ǥ�� : ��׿��� ���� �ߵ����� ��
  ��      �� : �̴�ȣ����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-22 ��׿��� ���� �ߵ����� ��
       A: 1��� �̻��� ��׿��� �� �ߵ������� ���� ��
     - ��������������-24 3õ���� �̻� ���� �ߵ����� �Ǽ�
       A: 3õ���� �̻��� ���ݰ��� �ߵ����� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������22
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������22
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
             AND  B.TR_DT  BETWEEN  P_SOTM_DT AND P_EOTM_DT
             AND  B.CHNL_TPCD = 'TTML'
             AND  B.DPS_TSK_CD = '0401'  -- �����ŷ�
             AND  B.DPS_TR_STCD = '1'

    JOIN     TB_SOR_CMI_BR_BC C    -- SOR_CMI_���⺻
             ON   B.TR_BRNO = C.BRNO
             AND  C.BR_DSCD  = '1'

    JOIN     TB_SOR_DEP_TR_DL D    -- SOR_DEP_�ŷ���
             ON   B.ACNO   = D.ACNO
             AND  B.TR_DT  = D.TR_DT
             AND  B.TR_SNO = D.TR_SNO
             AND  D.TR_PCPL + D.BSC_INT >= 30000000  -- ����+���� 3õ�����̻�

    WHERE    1=1
    AND      A.DPS_DP_DSCD = '2'     
    AND      A.DPS_ACN_STCD = '33'   -- 33:�ߵ�����
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������22',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT



