/*
  ���α׷��� : ins_TB_OPE_KRI_����������06
  Ÿ�����̺� : TB_OPE_KRI_����������06
  KRI ��ǥ�� : �ڱݿ뵵 �� ���� �������� ���Ѱ�� �Ǽ�
  ��      �� : ���α�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-06 :  �ڱݿ뵵 �� ���� �������� ���Ѱ�� �Ǽ�
       A: ������ ���� �ڱݿ뵵 �������˴�� ���� �� ���� ��� �� 3���� �̳� ����� ��볻��ǥ ��¡��
          �� �湮�Ͽ� ����� ��볻�� �������� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_����������06
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������06
    WITH  TEMP AS
    (
     SELECT   P_BASEDAY  AS  STD_DT
             ,A.BRNO
             ,J1.BR_NM
             ,A.CUST_NO
             ,A.CUST_DSCD
             ,A.ACN_DCMT_NO
             ,PD.PRD_KR_NM
             ,A.CRCD
             ,A.APRV_AMT
             ,A.TOT_CLN_RMD
             ,A.AGR_DT
             ,A.EXPI_DT
             ,A.ACK_TGT_YN   -- �뵵�������˴�󿩺�
             ,TO_CHAR(ADD_MONTHS(TO_DATE(A.AGR_DT,'YYYYMMDD'),3),'YYYYMMDD') AS �������˱���
             ,CHKG_DT        -- �������˿Ϸ���
             ,ROW_NUMBER() OVER(PARTITION BY ACN_DCMT_NO ORDER BY TGT_ABST_DT DESC,CLN_APC_NO DESC) AS ����
              -- ���ϰ��¹�ȣ�� �����ȣ���� ������ ������ ��������
              -- ���¼��� Ȯ���ϱ� �����ϰ� ���¹�ȣ���� �ֱٲ� �ϳ��� �������� ����
     FROM     TB_SOR_EWL_LN_USMU_CHK_BC A   -- SOR_EWL_�и���뵵�������˱⺻

     JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
              ON    A.BRNO  =  J1.BRNO

     JOIN     TB_SOR_LOA_ACN_BC   B   -- SOR_LOA_���±⺻
              ON    A.ACN_DCMT_NO  =  B.CLN_ACNO

     LEFT OUTER JOIN
              TB_SOR_PDF_PRD_BC    PD    -- SOR_PDF_��ǰ�⺻
              ON     B.PDCD  =   PD.PDCD
              AND    PD.APL_STCD  =  '10'

     WHERE    TGT_ABST_DT <  TO_CHAR(ADD_MONTHS(LAST_DAY(ADD_MONTHS(TO_DATE(P_BASEDAY,'YYYYMMDD') ,-1)),-3) ,'YYYYMMDD') 
           -- ������ ���� 3���� �����µ� ������ ���
     AND      ACK_TGT_YN = 'Y'     -- �뵵�������˴�󿩺�
     AND      CHKG_DT IS NULL      -- �뵵�������˿Ϸ���
    )
    SELECT    STD_DT
             ,BRNO
             ,BR_NM
             ,CUST_NO
             ,CUST_DSCD
             ,ACN_DCMT_NO
             ,PRD_KR_NM
             ,CRCD
             ,APRV_AMT
             ,TOT_CLN_RMD
             ,AGR_DT
             ,EXPI_DT
             ,ACK_TGT_YN
             ,DECODE(CHKG_DT,NULL,'N','Y')   -- �������˿���
             ,�������˱���
             ,CHKG_DT
    FROM      TEMP
    WHERE     1=1
    AND       ���� = 1
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������06',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

