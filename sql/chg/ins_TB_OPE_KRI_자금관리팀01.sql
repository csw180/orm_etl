/*
  ���α׷��� : ins_TB_OPE_KRI_�ڱݰ�����01
  Ÿ�����̺� : TB_OPE_KRI_�ڱݰ�����01
  KRI ��ǥ�� : �����۱� ��ȯû�� �ڵ���ȯ�ź� �Ǽ�
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ڱݰ�����-01 �����۱� ��ȯû�� �ڵ���ȯ�ź� �Ǽ�
       A: Ÿ��û���� 30�� ��� ��ó���� ���� ��ȯ�ź� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�ڱݰ�����01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ڱݰ�����01
    SELECT   P_BASEDAY
            ,A.RSTR_BRNO  --��ȯ����ȣ
            ,B.BR_NM      --��ȯ����
            ,A.CUST_NO    --����ȣ
            ,A.DMD_AMT    --û���ݾ�
            ,A.DMD_DT     --û������
            ,A.TR_DT      --ó������
            
    FROM     DWZOWN.TB_SOR_FTN_RTM_DMD_RSTR_TR  A  -- SOR_FTN_�ǽð�û����ȯ����
    
    JOIN     DWZOWN.TB_SOR_CMI_BR_BC  B  -- SOR_CMI_���⺻
             ON  A.RSTR_BRNO = B.BRNO
             AND B.BR_DSCD = '1'   -- 1.�߾�ȸ, 2.����
             
    WHERE    1=1
    AND      A.TR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT  -- ������ �ź�ó��������
    AND      A.HDL_OPN_DSCD = '1'  -- ������ȯó����
    AND      A.RQS_USR_NO = 'BFTN001000'  -- �ڵ��ź�

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ڱݰ�����01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

