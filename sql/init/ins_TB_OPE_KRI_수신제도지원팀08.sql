/*
  ���α׷��� : ins_TB_OPE_KRI_��������������08
  Ÿ�����̺� : TB_OPE_KRI_��������������08
  KRI ��ǥ�� : �����ܾ����� �߱���ҰǼ�
  ��      �� : ���������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-08 �����ܾ����� �߱���ҰǼ�
       A: ��ȸ�� �߻��� �����ܾ�����(��Ź,�߱�ä, ��ȭ���� ����) �߱���ҰǼ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������08
    SELECT   P_BASEDAY
            ,A.ISN_CNCL_BRNO  -- �߱��������ȣ
            ,B.BR_NM
            ,A.ACNO           -- ���¹�ȣ
            ,A.CUST_NO        -- ����ȣ
            ,'1'
            ,A.CFWR_ISN_NO    -- �����߱޹�ȣ
            ,A.ISN_DT         -- �߱�����
            ,A.LDGR_STCD      -- ��������ڵ� ( 3:���)
--            ,A.ISN_STD_DT     -- �߱ޱ�������
            ,A.ISN_CNCL_DT    -- �߱��������
    FROM     TB_SOR_DEP_CFWR_ISN_TR A  -- SOR_DEP_�����߱޳���
    JOIN     TB_SOR_CMI_BR_BC       B  -- SOR_CMI_���⺻
             ON   A.ISN_CNCL_BRNO = B.BRNO
    WHERE    1=1
    AND      A.CFWR_ISN_KDCD IN ('001', '002') -- �����߱������ڵ� 001: �ܾ�����(����), 002: �ܾ�����(����)
    AND      A.RMD_PRF_TGT_TSK_DSCD = '1' -- ���Ű���
    AND      A.ISN_CNCL_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT  -- �߱��������
    AND      A.LDGR_STCD = '3' -- ����(���)
    AND      A.ACNO < '200000000000' -- �������
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT





