/*
  ���α׷��� : ins_TB_OPE_KRI_����������16
  Ÿ�����̺� : TB_OPE_KRI_����������16
  ��      �� : �̻�ΰ���
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-16 : ������� ���� ����� �� ���� ���� �Ƿ� �Ǽ�
       A: ������ ������� ���� ����� �� ���� ���� �ǷڰǼ�
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

    DELETE OPEOWN.TB_OPE_KRI_����������16
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������16
    SELECT   P_BASEDAY
            ,A.CSLT_BRNO
            ,J1.BR_NM
            ,B.ACN_DCMT_NO
            ,A.CUST_NO
            ,B.PREN_CLN_DSCD
            ,PD.PRD_KR_NM
            ,B.APC_AMT
            ,DECODE(B.INDV_LMT_LN_DSCD,'1',B.ALR_LN_RMD,B.ALR_LNMA) ALR_LN_RMD
            ,B.AGR_DT
            ,B.PRX_EXPI_DT
            ,A.CSLT_DT
            ,A.DWUP_USR_NO

    FROM     TB_SOR_CLI_CLN_APC_RPST_BC A   -- SOR_CLI_���Ž�û��ǥ�⺻

    JOIN     TB_SOR_CLI_CLN_APC_BC B   -- SOR_CLI_���Ž�û�⺻
             ON    A.CLN_APC_RPST_NO = B.CLN_APC_RPST_NO
             AND   A.CSLT_DT = B.PRX_EXPI_DT
             AND   B.CLN_APC_DSCD IN ('11')
             AND   B.CLN_APC_CMPL_DSCD = '20'

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
             ON    A.CSLT_BRNO  =  J1.BRNO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD    -- SOR_PDF_��ǰ�⺻
             ON     B.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE    1=1
    AND    A.CSLT_DT BETWEEN P_SOTM_DT  AND P_EOTM_DT
    AND    A.APC_LDGR_STCD <> '99'
    AND    A.NFFC_UNN_DSCD = '1'
    AND    A.CSLT_BRNO NOT IN ('0288','0005')
    AND    A.APC_LDGR_STCD = '10'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������16',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
