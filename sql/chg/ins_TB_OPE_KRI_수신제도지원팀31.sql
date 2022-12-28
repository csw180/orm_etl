/*
  ���α׷��� : ins_TB_OPE_KRI_��������������31
  Ÿ�����̺� : TB_OPE_KRI_��������������31
  KRI ��ǥ�� : �������� ���ϵ��� �Ǽ�
  ��      �� : ���ڿ�
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������31 : �������� ���ϵ��� �Ǽ�
       A: �������� ������ �������������� ���ޱ��� �����Ͽ� ���� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������31
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������31
    SELECT   /*+ FULL(T1) FULL(T2) FULL(T3) */
             P_BASEDAY          --
            ,T1.HDL_BRNO         -- ����ȣ
            ,T3.BR_NM            -- ����
            ,T1.CSNT_ACNO        -- �����������¹�ȣ
            ,T1.TKCT_DT          -- ��Ź����
            ,T1.DFRY_DT          -- ��������
            ,T1.DLVY_DT          -- �������
            ,CASE WHEN T2.CC_NML_PCS_YN = '1' THEN 'Y' ELSE 'N' END  -- �������������Աݿ���

    FROM     TB_SOR_CTD_CSNT_TR_TR                       T1 -- SOR_CTD_���������ŷ�����

    JOIN     TB_SOR_CTD_CSNT_BC                          T2 -- SOR_CTD_���������⺻
             ON  T1.NT_NO = T2.NT_NO
             AND T1.NT_SNO = T2.NT_SNO
             AND T1.CSNT_ACNO = T2.CSNT_ACNO

    JOIN     TB_SOR_CMI_BR_BC                            T3 -- SOR_CMI_���⺻
             ON  T1.HDL_BRNO = T3.BRNO
             AND T3.BR_DSCD        = '1'
             AND T3.BR_KDCD  IN ('10','20','30')
             AND T3.FSC_DSCD       = '1'

    WHERE    1=1
    AND      T1.CSNT_TR_DSCD = '30'  -- ���������ŷ������ڵ�(30 : ���)
    AND      T1.CSNT_STCD = '20'  -- �������������ڵ�(20 : ���)
    AND      T1.DFRY_DT BETWEEN P_SOTM_DT AND P_EOTM_DT  -- ���ޱ���
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������31',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
