/*
  ���α׷��� : ins_TB_OPE_KRI_IB�������03
  Ÿ�����̺� : TB_OPE_KRI_IB�������03
  KRI ��ǥ�� : �ű� �� 6���� �̳� ��ü �߻��� ���� ���� (���)(IB�������)
  ��      �� : ��õ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - IB�������-03 �ű� �� 6���� �̳� ��ü �߻��� ���� ���� (���)(IB�������)
       A: ���� �� ���� ��ü����� �� �ű�/����� ���ڿ� ��ü�߻��� ���̰� 6���� �̳���,
          5õ���� �̻��� �������
       B: ���� �� ���� ����� �� �ű�/����� ���ڰ� 6���� �̳�, 5õ�����̻��� �������
          ��뿹)
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

    DELETE OPEOWN.TB_OPE_KRI_IB�������03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_IB�������03
    SELECT   A.STD_DT           AS ����������
            ,B_1.BRNO           AS ����ȣ
            ,TRIM(B_1.BR_NM)    AS ����
            ,A.CUST_NO          AS ����ȣ
            ,A.INTG_ACNO        AS ���¹�ȣ
            ,A.CLN_EXE_NO       AS �����ȣ
            ,A.PDCD             AS ��ǰ�ڵ�
            ,TRIM(PD.PRD_KR_NM) AS ��ǰ��
            ,A.CRCD             AS ��ȭ�ڵ�
            ,A.LN_EXE_AMT       AS ����ݾ�
            ,A.LN_RMD           AS �����ܾ�
            ,A.FC_RMD           AS ��ȭ�ܾ�
            ,CASE WHEN NVL(AG.AGR_CNT, 0) IN (0, 1) THEN '�ű�' -- �����Ͱ� ���� ��쿡�� �űԷ�
                  ELSE '�����' -- �űԾ����� 2�� �̻��̸� ���������
             END                AS ���Ž�û����
            ,A.AGR_DT           AS ��������
            ,CASE WHEN A.OVD_AMT > 0 THEN 'Y'
                  ELSE 'N'
             END                AS ��ü����
            ,A.CLN_OVD_DSCD     AS ��ü�����ڵ�
            ,TRIM(CD.CMN_CD_NM) AS ��ü�����ڵ��

            ,A.OVD_AMT          AS ��ü���ݾ�
            ,A.OVD_OCC_DT       AS ��ü�߻�����

    FROM     OT_DWA_INTG_CLN_BC     A  -- DWA_���տ��ű⺻
    JOIN     OT_DWA_DD_BR_BC        B  -- DWA_�����⺻
             ON     A.BRNO           = B.BRNO
             AND    A.STD_DT         = B.STD_DT
             AND    B.BR_DSCD        = '1'
             AND    B.FSC_DSCD       = '1'         -- ����
             AND    B.BR_KDCD        < '40'        -- 10:���κμ�, 20:������, 30:������
    JOIN     OT_DWA_DD_BR_BC        B_1  -- DWA_�����⺻
             ON     B.LST_MVN_BRNO   = B_1.BRNO
             AND    B.STD_DT         = B_1.STD_DT
             AND    B_1.BR_DSCD      = '1'
             AND    B_1.FSC_DSCD     = '1'         -- ����
             AND    B_1.BR_KDCD      < '40'        -- 10:���κμ�, 20:������, 30:������
    JOIN     OT_DWA_DD_ACSB_TR      C  -- DWA_�ϰ������񳻿�
             ON     A.BS_ACSB_CD     = C.ACSB_CD
             AND    A.STD_DT         = C.STD_DT
             AND    C.FSC_SNCD      IN ('K','C')
             AND    C.ACSB_CD3       = '12000401' -- ����ä��
             AND    C.ACSB_CD5      <> '14002501' -- �����ڱݴ������ ���� (������Ÿ�)
                          
    LEFT OUTER JOIN
             OT_DWA_CLN_PRD_STRC_BC    PD   -- DWA_���Ż�ǰ�����⺻
             ON     A.PDCD          = PD.PDCD
             AND    A.STD_DT        = PD.STD_DT
             
    LEFT OUTER JOIN
             (-- �űԾ����� ���� �� �� ��� ��������� ���� ������ �켱 ����..
              SELECT      CLN_ACNO
                         ,COUNT(*)  AS AGR_CNT
              FROM        TB_SOR_LOA_AGR_HT  -- SOR_LOA_�����̷�
              WHERE       TR_STCD = '1'
              AND         CLN_APC_DSCD < '10'                     -- ���Ž�û�����ڵ�(<10:�ű�)
              AND         ENR_DT <= P_BASEDAY
              GROUP BY    CLN_ACNO
             )   AG
             ON     A.INTG_ACNO = AG.CLN_ACNO
             
    LEFT OUTER JOIN
             OM_DWA_CMN_CD_BC CD -- DWA_�����ڵ�⺻
             ON     A.CLN_OVD_DSCD = CD.CMN_CD
             AND    CD.CMN_CD_US_YN = 'Y'
             AND    CD.TPCD_NO_EN_NM = 'CLN_OVD_DSCD'
             
    WHERE    1 = 1
    AND      A.STD_DT          =  P_BASEDAY
    AND      A.CLN_ACN_STCD    = '1'
    AND      A.BRNO            = '0328' -- ����ȣ(0328:IB�������)
    AND      MONTHS_BETWEEN( TO_DATE(A.STD_DT,'YYYYMMDD'), TO_DATE(A.AGR_DT,'YYYYMMDD') )  <= 6  -- �������ڰ� 6�����̳�
--    AND      (
--               ABS( MONTHS_BETWEEN( A.OVD_OCC_DT, A.AGR_DT ) ) <= 6  OR   -- ������ ��ü�����ϰ� ���������� ���̰� 6���� �̳��� ��
--               ABS( MONTHS_BETWEEN( A.STD_DT, A.AGR_DT ) ) <= 6      -- ���������ڿ� ���������� ���̰� 6���� �̳��� ��
--              )
    AND      A.LN_RMD        >= 50000000         -- ���ÿ� �����ܾ�[����ݾ�, �����ݾ����� �Һи� - ���� �ʿ�]�� 5õ���� �̻��� ��
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_IB�������03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
