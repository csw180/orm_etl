/*
  ���α׷��� : ins_TB_OPE_KRI_������02
  Ÿ�����̺� : TB_OPE_KRI_������02
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ������02 : ��й�ȣ���� ���ްŷ� �Ǽ�
       A: ������ ���� ���Űŷ��������� ���ž����ŷ��ڵ尡 ��й�ȣ ���� ���ްŷ��� �ŷ��Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_������02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_������02

    SELECT   /*+ FULL(A) FULL(B) */
             P_BASEDAY
            ,A.TR_BRNO
            ,B.BR_NM
            ,A.ACNO
            ,A.TR_DT
            ,A.DPS_TSK_TR_CD
            ,A.CRCD
            ,A.TR_AMT
            ,A.TR_USR_NO
    FROM     TB_SOR_DEP_TR_TR   A   -- SOR_DEP_�ŷ�����
    JOIN     TB_SOR_CMI_BR_BC   B   -- SOR_CMI_���⺻
             ON  A.TR_BRNO   = B.BRNO
    WHERE    1=1
    AND      A.ACNO  LIKE '1%'
    AND      A.TR_DT  BETWEEN  P_SOTM_DT AND P_EOTM_DT
    AND      A.DPS_TSK_TR_CD  =  '0301036'  -- ���ž����ŷ��ڵ� ( '0301036':��Ÿ��ü���� )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_������02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
