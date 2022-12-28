/*
  ���α׷��� : ins_TB_OPE_KRI_��������������11
  Ÿ�����̺� : TB_OPE_KRI_��������������11
  KRI ��ǥ�� : �����ð� �� �ߵ����� �Ǽ�
  ��      �� : �̴�ȣ����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-11 �����ð��� �ߵ������Ǽ�
       A: ������ �ŷ��ð� 08:30 ������ 17:00 ���� �߻��� �Ǵ� �����ݾ� 5�鸸�� �̻� �ߵ������Ǽ�
          - 08:30 ����, 17:00 ���� �ߵ���������
          - ������ ������ �ִ� ��� ���Ű���
          - ��������� �ش�
          - ���� + ����
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

    DELETE OPEOWN.TB_OPE_KRI_��������������11
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������11
    SELECT  /*+ FULL(A) FULL(B) FULL(D) FULL(J1) FULL(E)   */
             P_BASEDAY
            ,B.TR_BRNO
            ,J1.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,A.DPS_DP_DSCD
            ,A.NW_DT
            ,A.EXPI_DT
            ,B.TR_DT
            ,B.TR_TM
            ,B.CRCD
            ,E.LDGR_RMD
            ,(D.TR_PCPL + D.BSC_INT) AS ��ݱݾ�
            ,B.TR_USR_NO

    FROM     TB_SOR_DEP_DPAC_BC A   -- SOR_DEP_���Ű��±⺻

    JOIN     TB_SOR_DEP_TR_TR   B   -- SOR_DEP_�ŷ�����
             ON  A.ACNO = B.ACNO
             AND B.TR_DT BETWEEN P_SOTM_DT  AND  P_EOTM_DT
             AND ( B.TR_TM < '083000'  OR  B.TR_TM > '170000' )
             AND B.CHNL_TPCD = 'TTML'
             AND B.DPS_TSK_CD = '0401'  -- 0401:����

    JOIN     TB_SOR_DEP_TR_DL D  -- SOR_DEP_�ŷ���
             ON   B.ACNO   = D.ACNO
             AND  B.TR_DT  = D.TR_DT
             AND  B.TR_SNO = D.TR_SNO
             AND  D.TR_PCPL + D.BSC_INT >= 5000000

    JOIN     TB_SOR_DEP_DPAC_CUR_BC E  -- SOR_DEP_���Ű�����ȭ�⺻
             ON   A.ACNO   = E.ACNO

    JOIN     TB_SOR_CMI_BR_BC  J1   -- SOR_CMI_���⺻
             ON  B.TR_BRNO = J1.BRNO
             AND J1.BR_DSCD  = '1'

    WHERE    1=1
    AND      ( A.DPS_ACN_STCD = '33' OR  B.SPLT_CNCN_YN = 'Y' )
    AND      A.DPS_DP_DSCD = '2'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������11',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








