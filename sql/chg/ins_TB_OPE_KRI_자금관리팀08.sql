/*
  ���α׷��� : ins_TB_OPE_KRI_�ڱݰ�����08
  Ÿ�����̺� : TB_OPE_KRI_�ڱݰ�����08
  KRI ��ǥ�� : H-KRI-058 ��������� ��ȭ�ⳳ ���ױ� �Ǽ�(â��)
  ��      �� : �ھƶ�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
   - �ڱݰ�����-08 ��������� ��ȭ�ⳳ ���ױ� �Ǽ�(â��)
     A: [��ȭ] �߻��Ϸκ��� 3���� ����� â���ⳳ���ױ� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�ڱݰ�����08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ڱݰ�����08
    SELECT   P_BASEDAY
            ,A.ADM_BRNO   -- ����ȣ
            ,C.BR_NM
            ,A.OCC_DT     -- �߻�����
            ,A.CRCD       -- ��ȭ�ڵ�
            ,B.TR_AMT     -- ����ͱݾ�
            ,B.FSC_DT     -- �������������
    FROM     DWZOWN.TB_SOR_APW_TMAC_TR_BC   A -- SOR_APW_�������ŷ��⺻
    
    JOIN     DWZOWN.TB_SOR_APW_TMAC_TR_TR   B -- SOR_APW_�������ŷ�����
             ON  A.TMAC_ACNO =   B.TMAC_ACNO
             AND B.OPRF_PCS_AMT  > 0   --   �����ó���ݾ�
             AND B.TR_DT  BETWEEN  P_SOTM_DT AND P_EOTM_DT
             
    JOIN     DWZOWN.TB_SOR_CMI_BR_BC  C  -- SOR_CMI_���⺻
             ON  A.ADM_BRNO = C.BRNO
             AND C.BR_DSCD = '1'   -- 1.�߾�ȸ, 2.����
             
    WHERE    1=1
    AND      A.ACSB_CD = '26008111'  -- â�������ⳳ��
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ڱݰ�����08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
