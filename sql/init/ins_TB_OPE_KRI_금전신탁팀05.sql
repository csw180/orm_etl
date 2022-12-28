/*
  ���α׷��� : ins_TB_OPE_KRI_������Ź��05
  Ÿ�����̺� : TB_OPE_KRI_������Ź��05
  KRI ��ǥ�� : ���������ڻ��������(ISA) �̿���ڻ� �����Ǽ�
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ������Ź��-05 ���������ڻ��������(ISA) �̿���ڻ� �����Ǽ�
       A: ������ ���� 5���� �̻� �̿���ڻ��� ������ isa ���� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_������Ź��05
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_������Ź��05
    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,A.NW_DT
            ,A.EXPI_DT
            ,PD.PRD_KR_NM              -- ��ǰ�����ڵ�            
            ,B.PAR_AMT                 -- �̿���ڻ�ݾ�

    FROM     OT_DWA_INTG_DPS_BC   A     -- DWA_���ռ��ű⺻

    JOIN     TB_SOR_ISA_BNK_CST_EVL_TR B -- SOR_ISA_�������򰡳���
             ON   A.ACNO   = B.DPS_ACNO
             AND  A.STD_DT = B.STD_DT

    JOIN     TB_SOR_CMI_BR_BC    J   -- SOR_CMI_���⺻
             ON    A.ADM_BRNO   = J.BRNO

    JOIN     TB_SOR_PDF_PRD_BC  PD   -- SOR_PDF_��ǰ�⺻
             ON    A.PDCD  = PD.PDCD
             AND   PD.APL_STCD = '10'

    WHERE    1=1
    AND      A.STD_DT = P_BASEDAY
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_������Ź��05',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT