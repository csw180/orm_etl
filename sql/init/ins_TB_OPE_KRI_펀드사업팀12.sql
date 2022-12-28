/*
  ���α׷��� : ins_TB_OPE_KRI_�ݵ�����12
  Ÿ�����̺� : TB_OPE_KRI_�ݵ�����12
  KRI ��ǥ�� : ���ݼս� ���� ���� ���� �ܾ�(elf)
  ��      �� : �������븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ݵ�����-12: ���ݼս� ���� ���� ���� �ܾ�(elf)
       A: ELF�� ���κ��̷��� �ʰ��ϴ� ���������� ����� ��ǰ�� �� ���� �ܾ�
     - �ݵ�����-13: ���ݼս� ���� ���� ���� ��(elf)
       A: ������ �űԵ� �� 65�� �̻� ���� ��Ź  �Ǵ� �ݵ� ��ǰ �ű� ���� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�ݵ�����12
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ݵ�����12
    SELECT   P_BASEDAY ��������
            ,T1.ADM_BRNO ��������ȣ
            ,T2.BR_NM ��������
            ,T1.ACNO ���¹�ȣ
            ,T1.CUST_NO ����ȣ
            ,T1.BLN_PCPL �����ܾ�
            ,T4.PRD_KR_NM ��ǰ��
            ,T5.BLN_PCPL ���αݾ�
            ,T3.KI_OCC_DT ���ι߻�����

    FROM     TB_SOR_BCM_BNAC_BC T1   -- SOR_BCM_�������ǰ��±⺻
    JOIN     TB_SOR_CMI_BR_BC   T2   -- SOR_CMI_���⺻
             ON   T1.ADM_BRNO  = T2.BRNO

    JOIN     TB_SOR_PDF_FND_BC T3    -- SOR_PDF_�ݵ�⺻
             ON   T1.PDCD = T3.PDCD
             AND  T3.APL_ST_DT <= P_BASEDAY
             AND  T3.APL_END_DT >= P_BASEDAY
             AND  T3.APL_STCD = '10'

    JOIN     TB_SOR_PDF_PRD_BC T4    --  SOR_PDF_��ǰ�⺻
             ON    T1.PDCD = T4.PDCD
             AND   T4.APL_STCD = '10'
             AND   T4.PRD_DSCD = '01'

    JOIN     TB_SOR_BCM_PACN_DD_BLN_TR T5   -- SOR_BCM_���º������ܰ���
             ON    T1.ACNO      = T5.ACNO
             AND   T3.KI_OCC_DT = T5.STD_DT -- ���ι߻�����
             AND   T3.PDCD      = T5.PDCD

    WHERE    1=1
    AND      T1.ACY_DSCD = '1'
    AND      T3.KI_OCC_DT BETWEEN P_SOTM_DT AND P_EOTM_DT --�ش���� �߻��� ����
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ݵ�����12',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
