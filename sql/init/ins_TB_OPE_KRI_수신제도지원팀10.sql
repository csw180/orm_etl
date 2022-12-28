/*
  ���α׷��� : ins_TB_OPE_KRI_��������������10
  Ÿ�����̺� : TB_OPE_KRI_��������������10
  KRI ��ǥ�� : ���� �űԴ��Ͽ� �ܾ����� �߱��� ���°Ǽ�
  ��      �� : ���������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-10 ���� �űԴ��Ͽ� �ܾ����� �߱��� ���°Ǽ�
       A: ���� ���Ű����� �ű��� ���� ���ܱ�Ϻο��忡 �ܾ�����߱����� ��ϵ� ���� ���°Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������10
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������10
    SELECT   P_BASEDAY
            ,B.ISN_BRNO  -- �߱�����ȣ
            ,J.BR_NM
            ,A.ACNO      -- ���¹�ȣ
            ,A.CUST_NO   -- ����ȣ
            ,A.NW_DT     -- �ű�����
            ,'Y'
            ,B.ISN_DT    -- �߱�����
            --,B.ISN_STD_DT -- �߱ޱ�������
    FROM     TB_SOR_DEP_DPAC_BC A   -- SOR_DEP_���Ű��±⺻
    JOIN     TB_SOR_DEP_CFWR_ISN_TR B  -- SOR_DEP_�����߱޳���
             ON    A.ACNO  = B.ACNO
             AND   A.NW_DT = B.ISN_DT
             AND   B.CFWR_ISN_KDCD IN ('001', '002') -- �����߱������ڵ� 001: �ܾ�����(����), 002: �ܾ�����(����)
             AND   B.RMD_PRF_TGT_TSK_DSCD = '1' -- ���Ű���
             AND   B.LDGR_STCD = '1'
    JOIN     TB_SOR_CMI_BR_BC   J     --  SOR_CMI_���⺻
             ON    B.ISN_BRNO = J.BRNO
    WHERE    1=1
    AND      A.NW_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT -- �ű�����
    AND      A.ACNO < '200000000000' -- �������
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������10',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT





