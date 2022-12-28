/*
  ���α׷��� : ins_TB_OPE_KRI_������01
  Ÿ�����̺� : TB_OPE_KRI_������01
  KRI ��ǥ�� : ���� ���� ��� �ŷ� �Ǽ�
  ��      �� : ��õ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ������-01 ���� ���� ��� �ŷ� �Ǽ�
       A: ���Ű��� ����� �ŷ����� �� ��� �Ǽ�
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
    SELECT      P_BASEDAY                                              AS ��������
               ,BR.BRNO                                                AS ����ȣ
               ,TRIM(BR.BR_NM)                                         AS ����
               ,CU.CUST_NO                                             AS ����ȣ
               ,A.CLN_ACNO                                             AS ���¹�ȣ
               ,A.CLN_EXE_NO                                           AS �����ȣ
               ,A.CLN_TR_NO                                            AS �ŷ���ȣ
               ,A.CLN_TR_KDCD                                          AS �ŷ������ڵ�
               ,A.TR_DT                                                AS �ŷ�����
               ,C.TR_DT                                                AS �������
               ,A.RCFM_DT                                              AS �����
               ,A.TR_USR_NO                                            AS �ŷ�����ڹ�ȣ

    FROM        TB_SOR_LOA_TR_TR          A -- SOR_LOA_�ŷ�����

    JOIN        TB_SOR_LOA_TR_BF_LDGR_TR  B -- SOR_LOA_�ŷ������峻��
                ON     A.CLN_ACNO           = B.CLN_ACNO
                AND    A.CLN_EXE_NO         = B.CLN_EXE_NO
                AND    A.CLN_TR_NO          = B.CLN_TR_NO

    JOIN        TB_SOR_LOA_TR_TR          C -- SOR_LOA_�ŷ����� [�ŷ��� ����ϰ� ���� ����� �ŷ�(TR_STCD = 2)]
                ON     A.CLN_ACNO           = C.CLN_ACNO
                AND    A.CLN_EXE_NO         = C.CLN_EXE_NO
                AND    A.CLN_TR_NO          = C.CNCL_OGTR_SNO
                AND    C.TR_DT        BETWEEN  P_SOTM_DT AND P_EOTM_DT -- ���� �� ����� ��

    JOIN        OT_DWA_DD_BR_BC           BR  -- DWA_�����⺻
                ON     A.TR_BRNO        = BR.BRNO
                AND    BR.STD_DT        = P_BASEDAY
                AND    BR.BR_DSCD       = '1'
                AND    BR.FSC_DSCD      = '1'         -- ����
                AND    BR.BR_KDCD       < '40'        -- 10:���κμ�, 20:������, 30:������

    JOIN        TB_SOR_LOA_ACN_BC         AC  -- SOR_LOA_���±⺻
                ON     A.CLN_ACNO       = AC.CLN_ACNO
                AND    AC.NFFC_UNN_DSCD = '1'

    JOIN        OM_DWA_INTG_CUST_BC       CU
                ON     AC.CUST_NO       = CU.CUST_NO

    WHERE       1 = 1
    AND         A.TR_STCD <> '1' -- �ŷ������ڵ�(1:���� �̿� ����,���)
    AND         A.CLN_TR_KDCD  IN ('300','310','320','360')  --���Űŷ������ڵ�(300:�����ȯ,310:�������ڼ���,320:�������ڼ���,360:�����ȯ-CC�κм���)
    AND         A.TR_DT <> A.RCFM_DT -- ��� ��� �ŷ��� ����� �ŷ�
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