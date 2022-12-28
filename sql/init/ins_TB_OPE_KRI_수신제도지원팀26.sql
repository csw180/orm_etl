/*
  ���α׷��� : ins_TB_OPE_KRI_��������������26
  Ÿ�����̺� : TB_OPE_KRI_��������������26
  KRI ��ǥ�� : 1�����̻� �������� ���ܿ��� �Ͻÿ����ݼ����� ���� �߻��Ǽ�
  ��      �� : ���Ͽ����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������26 : 1�����̻� �������� ���ܿ��� �Ͻÿ����ݼ����� ���� �߻��Ǽ�
       A: ������ ���� 1���� �̻� �������� ���ܿ��� �Ͻÿ����ݼ����� ���޹߻�(��������) �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������26
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������26
    SELECT   P_BASEDAY
            ,A.ASP_ADM_BRNO                    --���ܰ�������ȣ
            ,J.BR_NM                           --����
            ,A.ASP_ACNO                        --���ܰ��¹�ȣ
            ,A.ASP_TXIM_KDCD                   --�����ڵ�
            ,C.TR_RCFM_DT                      -- ROM_DT �Ա�����
            ,B.TR_RCFM_DT                      -- DFRY_DT ��������
            ,A.DFRY_AMT                        --���ޱݾ�
            ,B.ENR_USR_NO                      --�����ڹ�ȣ

    FROM     TB_SOR_SDM_ASP_DP_BC    A    -- SOR_SDM_���ܿ��ݱ⺻

    JOIN     TB_SOR_SDM_ASP_DP_TR_TR B    -- SOR_SDM_���ܿ��ݰŷ�����
             ON    A.ASP_ACNO = B.ASP_ACNO
             AND   B.TR_RCFM_DT  BETWEEN  P_SOTM_DT AND   P_EOTM_DT  -- �ŷ��������
             AND   B.ASP_TR_KDCD = '2'     -- ����
             AND   B.TR_STCD = '1'

    JOIN     TB_SOR_SDM_ASP_DP_TR_TR C    -- SOR_SDM_���ܿ��ݰŷ�����
             ON    A.ASP_ACNO = C.ASP_ACNO
             AND   C.ASP_TR_KDCD = '1'    -- �Ա�
             AND   C.TR_STCD = '1'

    JOIN     TB_SOR_CMI_BR_BC   J
             ON    A.ASP_ADM_BRNO  = J.BRNO

    WHERE    1=1
    AND      A.ASP_TXIM_KDCD IN ('05','08','10','11','12','13','16','23','25','28')
    AND      A.ASP_DP_ACN_STCD = '4' -- ����
    AND      A.ASP_ACNO LIKE '1%'    -- ���ุ
    AND      ADD_MONTHS(TO_DATE(C.TR_RCFM_DT,'YYYYMMDD'),1) <= TO_DATE(B.TR_RCFM_DT,'YYYYMMDD')
           -- �Ա� 1������ �����Ŀ� ������ �߻��Ѱ��
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������26',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








