/*
  ���α׷��� : ins_TB_OPE_KRI_�и�����01
  Ÿ�����̺� : TB_OPE_KRI_�и�����01
  KRI ��ǥ�� : ���Ῡ�� '������' ���� ��� �ο� ���� �Ǽ�
  ��      �� : ���α�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
   - �и�����-01 ���Ῡ�� '������' ���� ��� �ο� ���� �Ǽ�
     A: ������ ���� ���Ű����� ������� ������ �� ���ž�����޼�Ģ ���� ���ݻ��� ��
        ������ȹ ������ �ʿ��� �ǰ�(����,������)�� �ο��� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�и�����01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�и�����01
    SELECT   P_BASEDAY
            ,B.BRNO
            ,D.BR_NM
            ,C.ACN_DCMT_NO
            ,B.CUST_NO
            ,B.CUST_DSCD
            ,B.APCL_DSCD
            ,C.LN_SBCD
            ,B.CRCD
            ,B.APRV_AMT
            ,B.TOT_CLN_RMD
            ,B.CLN_APRV_DT
            ,C.APRV_LN_EXPI_DT
            ,DECODE(A.LNRV_JDGM_DSCD,'03','����','04','������') AS LNRV_JDGM_DSCD
            ,A.HDQ_JDGM_OPNN_CTS
            ,A.JDGM_DT

    FROM     TB_SOR_EWL_LN_XCLN_JDGM_TR A   -- SOR_EWL_�и������Ῡ����������

    JOIN     TB_SOR_EWL_LN_XCDC_CLN_BC  B   -- SOR_EWL_�и������Ῡ�ű⺻
             ON   A.TGT_ABST_DT = B.TGT_ABST_DT
             AND  A.CLN_APC_NO  = B.CLN_APC_NO

    JOIN     TB_SOR_CLI_CLN_APRV_BC C       -- SOR_CLI_���Ž��α⺻
             ON   A.CLN_APC_NO = C.CLN_APC_NO

    JOIN     TB_SOR_CMI_BR_BC D     -- SOR_CMI_���⺻
             ON   B.BRNO = D.BRNO
             AND  D.BR_DSCD = '1'   -- 1.�߾�ȸ, 2.����             

    WHERE    1=1
    AND      A.TGT_ABST_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      A.LNRV_JDGM_DSCD IN ('03','04')  -- �и������������ڵ�(03:����,04:������)
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�и�����01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

