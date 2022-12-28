/*
  ���α׷��� : ins_TB_OPE_KRI_��ȯ������05
  Ÿ�����̺� : TB_OPE_KRI_��ȯ������05
  KRI ��ǥ�� : ��ȭ�����볻�� Ȯ�ε�� ���� �Ǽ�
  ��      �� : ���α�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��ȯ������-05 :  ��ȭ�����볻�� Ȯ�ε�� ���� �Ǽ�
       A: ��ȭ���� ��� �� 1���� �ʰ��� ���� ��ȭ���� ��볻�� Ȯ�ε���� �̽ǽõ� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��ȯ������05
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��ȯ������05

    SELECT   P_BASEDAY
            ,A.BRNO
            ,J1.BR_NM
            ,A.CUST_NO
            ,A.CUST_DSCD
            ,A.ACN_DCMT_NO
            ,PD.PRD_KR_NM
            ,A.CRCD
            ,A.APRV_AMT
            ,A.CLN_EXE_NO
            ,B.LN_EXE_AMT
            ,A.LN_EXE_DT
            ,'N' AS  �������˿ϷῩ��
            ,TO_CHAR(ADD_MONTHS(TO_DATE(A.AGR_DT,'YYYYMMDD'),1),'YYYYMMDD') AS �������˱���
            ,CHKG_DT

    FROM     TB_SOR_EWL_LN_USMU_CHK_BC A  -- SOR_EWL_�и���뵵�������˱⺻

    JOIN     TB_SOR_LOA_EXE_BC B          -- SOR_LOA_����⺻
             ON    A.ACN_DCMT_NO = B.CLN_ACNO
             AND   A.CLN_EXE_NO  = B.CLN_EXE_NO

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
             ON    A.BRNO  =  J1.BRNO
             AND   J1.BR_DSCD = '1'   -- 1.�߾�ȸ, 2.����
             
    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD    -- SOR_PDF_��ǰ�⺻
             ON     B.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE    1=1
    AND      A.TGT_ABST_DT <  TO_CHAR(ADD_MONTHS(LAST_DAY(ADD_MONTHS(TO_DATE(P_BASEDAY,'YYYYMMDD') ,-1)),-1) ,'YYYYMMDD')
             /* ������ ���� 1���� �����µ� ������ ���*/
    AND      A.ACK_TGT_YN = 'Y'
    AND      A.CRCD !='KRW'
    AND      A.CHKG_DT IS NULL
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��ȯ������05',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
