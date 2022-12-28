/*
  ���α׷��� : ins_TB_OPE_KRI_������01
  Ÿ�����̺� : TB_OPE_KRI_������01
  KRI ��ǥ�� : ���Űŷ����� ����/��Ұŷ� �Ǽ�
  ��      �� : ���� ����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ������-01 ���Űŷ����� ����/��Ұŷ� �Ǽ�
       A: ������ ���� ���Űŷ��������� �ŷ������ڵ尡 ����/����� �ŷ��Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_������01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_������01
    SELECT   /*+ FULL(A) FULL(B)  FULL(C) */
             P_BASEDAY
            ,A.TR_BRNO
            ,B.BR_NM
            ,A.ACNO
            ,A.DPS_TSK_CD   -- �ŷ������ڵ�
            ,DECODE(A.DPS_TR_STCD,'2',A.TR_DT,NULL)  -- �����ŷ�����
            ,DECODE(A.DPS_TR_STCD,'3',A.TR_DT,NULL)  -- ��Ұŷ�����
    --        ,A.OGTR_DT    -- �Աݰŷ�����
            ,A.DPS_TR_RCD_CTS  -- ������һ���
            ,A.TR_USR_NO   -- ������������ȣ
    from     TB_SOR_DEP_TR_TR   A  -- SOR_DEP_�ŷ�����
    JOIN     TB_SOR_CMI_BR_BC   B  -- SOR_CMI_���⺻
             ON  A.TR_BRNO   =   B.BRNO
             AND B.BR_DSCD  =  '1'
    JOIN     TB_SOR_DEP_DPAC_BC  C  -- SOR_DEP_���Ű��±⺻
             ON  A.ACNO      =   C.ACNO
    WHERE    1=1
    AND      A.TR_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND      A.DPS_TR_STCD IN ('2','3')  -- ���Űŷ������ڵ� 2:����, 3:���
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_������01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
