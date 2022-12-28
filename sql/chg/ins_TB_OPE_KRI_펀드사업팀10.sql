/*
  ���α׷��� : ins_TB_OPE_KRI_�ݵ�����10
  Ÿ�����̺� : TB_OPE_KRI_�ݵ�����10
  KRI ��ǥ�� : ���Ǽ����� �ݵ� ȯ�� ��û �Ǽ�
  ��      �� : �������븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ݵ�����-10: ���Ǽ����� �ݵ� ȯ�� ��û �Ǽ�
       A: ���Ǽ����� �ݵ� ȯ�� ��û �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�ݵ�����10
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ݵ�����10
    SELECT   P_BASEDAY
            ,T1.ADM_BRNO
            ,J1.BR_NM
            ,T1.ACNO
            ,T1.CUST_NO
            ,'Y'    -- ���Ǽ�������
            ,T2.STLM_DT

    FROM     TB_SOR_BCM_BNAC_BC    T1     -- SOR_BCM_�������ǰ��±⺻

    JOIN     TB_SOR_BCM_RPCH_APC_TR    T2  -- SOR_BCM_ȯ�Ž�û����
             ON   T1.ACNO   = T2.ACNO
             AND  T2.STLM_DT   BETWEEN  P_SOTM_DT AND P_EOTM_DT
             AND  T2.CNCL_YN =  'N'

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
             ON    T1.ADM_BRNO  =  J1.BRNO


    JOIN     TB_SOR_BCM_ROP_BC    T3    --SOR_BCM_���Ǽ����⺻
             ON   T1.ACNO   = T3.ACNO
             AND  T3.CNCL_YN =  'N'

    WHERE    1=1
    AND      T2.STLM_DT   BETWEEN  T3.ENR_DT AND NVL(T3.RLS_DT,'99991231')
             -- ȯ�Ŵ���������ڰ� ���ǵ�����ڿ� �������ڻ��̿� �ִ��� Ȯ��

    UNION ALL

    SELECT   P_BASEDAY
            ,T1.ADM_BRNO
            ,J1.BR_NM
            ,T1.ACNO
            ,T1.CUST_NO
            ,'Y'    -- ���Ǽ�������
            ,T2.TR_DT

    FROM     TB_SOR_BCM_BNAC_BC    T1     -- SOR_BCM_�������ǰ��±⺻

    JOIN     TB_SOR_BCM_DRW_TR    T2       -- SOR_BCM_��ݳ���
             ON   T1.ACNO   =   T2.ACNO
             AND  T2.TR_DT  BETWEEN  P_SOTM_DT AND P_EOTM_DT
             AND  T2.CNCL_YN  =  'N'

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
             ON    T1.ADM_BRNO  =  J1.BRNO

    JOIN     TB_SOR_BCM_ROP_BC    T3    --SOR_BCM_���Ǽ����⺻
             ON   T2.ACNO   = T3.ACNO
             AND  T3.CNCL_YN =  'N'

    JOIN     TB_SOR_PDF_FND_BC     PD1  -- SOR_PDF_�ݵ�⺻
             ON   T1.PDCD  =  PD1.PDCD
             AND  P_BASEDAY  BETWEEN PD1.APL_ST_DT  AND PD1.APL_END_DT
             AND  PD1.INVM_TGT_DSCD  =  '01'
             AND  PD1.APL_STCD  = '10'  -- ��������ڵ�: Ȱ��(10)

    WHERE    1=1
    AND      T2.TR_DT   BETWEEN  T3.ENR_DT AND NVL(T3.RLS_DT,'99991231')
             -- ȯ�Ŵ���������ڰ� ���ǵ�����ڿ� �������ڻ��̿� �ִ��� Ȯ��

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ݵ�����10',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT





