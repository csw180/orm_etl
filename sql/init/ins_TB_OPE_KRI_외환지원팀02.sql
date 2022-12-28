/*
  ���α׷��� : ins_TB_OPE_KRI_��ȯ������02
  Ÿ�����̺� : TB_OPE_KRI_��ȯ������02
  KRI ��ǥ�� : ������ ���ϼ����ο��� 2ȸ�̻� �հ�� 1�����ʰ� �۱ݰǼ�
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��ȯ������-02 ������ ���ϼ����ο��� 2ȸ�̻� �հ�� 1�����ʰ� �۱ݰǼ�
       A: ���� �� ���ϼ����ο��� 2ȸ�̻� �հ�� 1�����ʰ� �۱ݰǼ�
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

    DELETE OPEOWN.TB_OPE_KRI_��ȯ������02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��ȯ������02
    SELECT   P_BASEDAY
            ,SUBSTR(A.REF_NO,3,4)
            ,CM.BR_NM as "����"
            ,A.ADRE_EN_NM as "�����θ�"
            ,A.ADRE_FRNW_ACNO as "�����ΰ��¹�ȣ"
            ,A.REF_NO as "������ȣ"
            ,A.TR_DT as "�����"
            ,A.CRCD as "��ȭ�ڵ�"
            ,A.OWMN_AMT as "�۱ݾ�"

    FROM     TB_SOR_INX_OWMN_BC A    -- SOR_INX_��߼۱ݱ⺻

    JOIN     TB_SOR_CMI_BR_BC   CM   -- SOR_CMI_���⺻
             ON  SUBSTR(A.REF_NO,3,4) = CM.BRNO

    WHERE    1=1
    AND      A.TR_DT BETWEEN P_SOTM_DT AND  P_EOTM_DT
    AND      A.FRXC_LDGR_STCD IN ('1','2','9')
    AND      A.ADRE_FRNW_ACNO IS NOT NULL
    AND      (
              A.ADRE_FRNW_ACNO IN (
                    SELECT   ADRE_FRNW_ACNO
                    FROM     TB_SOR_INX_OWMN_BC  -- SOR_INX_��߼۱ݱ⺻
                    WHERE    TR_DT BETWEEN P_SOTM_DT AND  P_EOTM_DT
                    AND      FRXC_LDGR_STCD IN ('1','2','9')
                    AND      ADRE_FRNW_ACNO IS NOT NULL
                    GROUP BY ADRE_FRNW_ACNO
                    HAVING   COUNT(*) > 1 AND SUM(TUSA_TNSL_AMT) > 10000
                 )  OR
              A.ADRE_EN_NM IN (
                    SELECT   ADRE_EN_NM
                    FROM     TB_SOR_INX_OWMN_BC  -- SOR_INX_��߼۱ݱ⺻
                    WHERE    TR_DT BETWEEN P_SOTM_DT AND  P_EOTM_DT
                    AND      FRXC_LDGR_STCD IN ('1','2','9')
                    AND      ADRE_FRNW_ACNO IS NULL
                    GROUP BY ADRE_EN_NM
                    HAVING   COUNT(*) > 1 AND SUM(TUSA_TNSL_AMT) > 10000
                 )
             )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��ȯ������02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

