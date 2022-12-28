/*
  ���α׷��� : ins_TB_OPE_KRI_��������������02
  Ÿ�����̺� : TB_OPE_KRI_��������������02
  KRI ��ǥ�� : ������� �ŷ� ������ ����
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-02 ������� �ŷ� ������ ����
       ���� �� ���� ��ް��� 15�� �ʰ��Ͽ� �����ϰų� �������� ����
       A: ���� �� 15�� �ʰ��Ͽ� ������ ���� ���� ��ްŷ��Ǽ�
       B: ���� �� �߻��� ������� �ŷ� �Ǽ�
     - ��������������-03 ������� �ŷ� ������ �Ǽ�
       ���� �� ���� ��ް��� 15�� �ʰ��Ͽ� �����ϰų� �������� �Ǽ�
       A: ���� �� 15�� �ʰ��Ͽ� ������ ������� �ŷ� �Ǽ�
       B: ���� �� ���� 15�� �ʰ��Ͽ� ������ ���� ������ްŷ� �Ǽ�
     - ��������������-04 ������� �ŷ��Ǽ�
       A: ������� �ŷ� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������02
    SELECT   P_BASEDAY
            ,A.TR_BRNO
            ,B.BR_NM
            ,A.ACNO
            ,C.CUST_NO
            ,A.CNVC_DSCD
            ,A.TR_DT
            ,A.TR_AMT
            ,CASE WHEN A.LDGR_STCD = '1'  THEN  'N' ELSE  'Y'  END CNVC_HDL_ARN_YN
            ,A.RLS_DT
            ,A.NARN_ACCR_DCNT

    FROM     (
              SELECT    A.ACNO            -- ���¹�ȣ
                       ,A.TR_DT           -- �ŷ�����
                       ,A.TR_SNO          -- �ŷ��Ϸù�ȣ
                       ,A.TR_AMT          -- �ŷ��ݾ�
                      ,CASE WHEN  A.CNVC_HDL_DSCD = '1' THEN  '����������'
                            WHEN  A.CNVC_HDL_DSCD = '2' THEN  '���ΰ�����'
                            WHEN  A.CNVC_HDL_DSCD = '3' THEN  '������+���ΰ�����'
                       END         CNVC_DSCD  -- ������ޱ����ڵ�
                      ,TR_BRNO            -- �ŷ�����ȣ
                      ,TO_CHAR( TO_DATE(A.TR_DT,'YYYYMMDD') + 15,'YYYYMMDD')  AF15_DT
                      ,B.DP_ACD_KDCD      -- ���ݻ�������ڵ�
                      ,B.LDGR_STCD        -- ��������ڵ�
                      ,B.ENR_DT           -- �������
                      ,B.RLS_DT           -- ��������
                      ,CASE WHEN B.LDGR_STCD = '3' THEN TO_DATE(B.RLS_DT,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD') END ACCR_DCNT
                      ,CASE WHEN B.LDGR_STCD = '1' THEN TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD') END NARN_ACCR_DCNT
              FROM     TB_SOR_DEP_TR_TR    A  -- SOR_DEP_�ŷ�����
              JOIN     TB_SOR_DEP_ACD_TR   B  -- SOR_DEP_�����
                       ON   A.ACNO   = B.ACNO
                       AND  A.TR_DT  = B.ENR_DT
                       AND  A.TR_AMT = B.ACD_AMT

              WHERE    1=1
              AND      A.ACNO  LIKE  '1%'
              AND      A.TR_DT  BETWEEN  P_SOTM_DT AND  P_EOTM_DT
              AND      A.CNVC_HDL_DSCD  IN  ('1','2','3')
             )  A
    JOIN     TB_SOR_CMI_BR_BC     B    -- SOR_CMI_���⺻
             ON    A.TR_BRNO  =  B.BRNO

    JOIN     TB_SOR_DEP_DPAC_BC     C   -- SOR_DEP_���Ű��±⺻
             ON    A.ACNO     =  C.ACNO

    --WHERE    1=1
    --AND      A.LDGR_STCD  =  '1'
    --AND      A.NARN_ACCR_DCNT >  15
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


