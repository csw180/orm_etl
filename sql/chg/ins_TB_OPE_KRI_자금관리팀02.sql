/*
  ���α׷��� : ins_TB_OPE_KRI_�ڱݰ�����02
  Ÿ�����̺� : TB_OPE_KRI_�ڱݰ�����02
  KRI ��ǥ�� : â�� �� ATM �ⳳ���� �߻��Ǽ�
  ��      �� : �ھƶ�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ڱݰ�����-02 â�� �� ATM �ⳳ���� �߻��Ǽ�
       A: ���� �� â���ⳳ ��ȭ ������ �߻� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�ڱݰ�����02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ڱݰ�����02
    SELECT   P_BASEDAY
            ,A.ADM_BRNO   -- ����ȣ
            ,B.BR_NM
            ,A.OCC_DT     -- �߻�����
            ,A.CRCD       -- ��ȭ�ڵ�
            ,A.OCC_AMT    -- �߻��ݾ�

    FROM     DWZOWN.TB_SOR_APW_TMAC_TR_BC   A -- SOR_APW_�������ŷ��⺻
    JOIN
             DWZOWN.TB_SOR_CMI_BR_BC  B  -- SOR_CMI_���⺻
             ON  A.ADM_BRNO = B.BRNO
             AND B.BR_DSCD = '1'   -- 1.�߾�ȸ, 2.����

    WHERE    1=1
    AND      A.OCC_DT BETWEEN P_SOTM_DT AND P_EOTM_DT  -- ������ �߻���
    AND      A.ACSB_CD = '15011511'  -- �ⳳ������
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ڱݰ�����02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
