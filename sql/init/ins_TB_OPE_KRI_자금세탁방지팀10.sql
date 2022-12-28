/*
  ���α׷��� : ins_TB_OPE_KRI_�ڱݼ�Ź������10
  Ÿ�����̺� : TB_OPE_KRI_�ڱݼ�Ź������10
  KRI ��ǥ�� : ������ Ư������������ ����
  ��      �� : �������븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ڱݼ�Ź������-10 ������ Ư������������ ����
      A: ���� �� ������ ������/������ Ư������������ ���� Ȯ��
         ���ؿ� �� ������/������ Ư������������ ����
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

    DELETE OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ڱݼ�Ź������10
    SELECT   P_BASEDAY
            ,A.BLNT_BRNO
            ,J.BR_NM
            ,A.CUST_NO
            ,'DNFBPs'
            ,TO_CHAR(A.VRF_ENR_DTTM,'YYYYMMDD')
            ,A.KYC_SNO
    FROM     TB_SOR_CUS_KYC_TR A    -- SOR_CUS_KYC����
    JOIN     TB_SOR_CUS_MAS_BC B    -- SOR_CUS_���⺻
             ON  A.CUST_NO = B.CUST_NO
    JOIN     TB_SOR_CUS_PRV_DL C    -- SOR_CUS_���ΰ���
             ON  A.CUST_NO = C.CUST_NO
             AND C.JB_CD IN ( SELECT DISTINCT CD_CTS
                              FROM TB_SOR_CUS_KYC_RSK_BC    --  SOR_CUS_KYC����켱����⺻
                              WHERE KYC_RSK_PFRD_APL_DSCD = '08'
                             )  -- Ư������������(�翬EDD��� �����ڵ�)
    JOIN     TB_SOR_CMI_BR_BC    J   -- SOR_CMI_���⺻
             ON    A.ENR_BRNO   = J.BRNO
             AND   J.BR_DSCD = '1'
        --     AND  (CLBR_DT IS NULL OR CLBR_DT >= '20220430')
        --         AND  (CLBR_DT IS NULL OR CLBR_DT > P_BASEDAY)
    WHERE    1=1
    AND      TO_CHAR(A.VRF_ENR_DTTM,'YYYYMMDD') BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND      A.CUST_CNFM_LBL_CMPL_YN = 'Y'
    AND      A.TR_BR_DSCD    = '1'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ڱݼ�Ź������10',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








