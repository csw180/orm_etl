/*
  ���α׷��� : ins_TB_OPE_KRI_����������22
  Ÿ�����̺� : TB_OPE_KRI_����������22
  KRI ��ǥ�� : 2õ�����̻� ���Ż�ȯ��� �� �̻�ȯ �Ǽ�
  ��      �� : ��õ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-22 2õ�����̻� ���Ż�ȯ��� �� �̻�ȯ �Ǽ�
       A: ���� ��ȯ ����/��� �� 30�� �� ���ȯ���� ���� ��(20�鸸�� �̻�) �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_����������22
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������22
    WITH TB_TEMP_����������_22 AS
    (
    SELECT      P_BASEDAY                        AS ��������
               ,'�����ŷ� =>'                    AS ����1
               ,A.*
               ,'=> �� �����ŷ��� 30�г� ���� �ŷ�(1:N) =>' AS ����2
               ,B.CLN_ACNO                      AS ���¹�ȣ_����30�г��ŷ�
               ,B.CLN_EXE_NO                    AS �����ȣ_����30�г��ŷ�
               ,B.CLN_TR_NO                     AS �ŷ���ȣ_����30�г��ŷ�
               ,B.TR_DT                         AS �ŷ�����_����30�г��ŷ�
               ,B.TR_TM                         AS �ŷ��ð�_����30�г��ŷ�
               ,B.TR_STCD                       AS �ŷ������ڵ�_����30�г��ŷ�
               ,B.CLN_TR_KDCD                   AS ���Űŷ������ڵ�_����30�г��ŷ�
               ,B.RCFM_DT                       AS �������_����30�г��ŷ�
               ,B.WN_TNSL_PCPL                  AS �ŷ�����_����30�г��ŷ�
               ,B.WN_TNSL_INT                   AS �ŷ�����_����30�г��ŷ�
               ,TO_TIMESTAMP(B.TR_DT || B.TR_TM, 'YYYYMMDDHH24MISS')                      AS �ŷ�TIMESTAMP_����30�г��ŷ�  -- 30�� �̳� �ŷ����� TIMESTAMP
               ,TO_TIMESTAMP(A.�ŷ�����_������ || A.�ŷ��ð�_������, 'YYYYMMDDHH24MISS')     AS �ŷ�TIMESTAMP_������         -- 2õ���� �̻� ���ݻ�ȯ ������ ���� TIMESTAMP
               ,TO_TIMESTAMP(B.TR_DT || B.TR_TM, 'YYYYMMDDHH24MISS') - TO_TIMESTAMP(A.�ŷ�����_������ || A.�ŷ��ð�_������, 'YYYYMMDDHH24MISS') AS �ð��� -- 30�� �̳����� ����
    FROM       (-- 2õ���� �̻� ���ݻ�ȯ ���� ������ ��
                SELECT      A.CLN_ACNO         AS ���¹�ȣ_������
                           ,A.CLN_EXE_NO       AS �����ȣ_������
                           ,A.CLN_TR_NO        AS �ŷ���ȣ_������
                           ,A.TR_DT            AS �ŷ�����_������
                           ,A.TR_TM            AS �ŷ��ð�_������
                           ,A.TR_STCD          AS �ŷ������ڵ�_������
                           ,A.CLN_TR_KDCD      AS ���Űŷ������ڵ�_������
                           ,A.RCFM_DT          AS �������_������
                           ,B.NEXT_INT_IMP_DT  AS �ŷ����������ڼ�������_������
                           ,A.WN_TNSL_PCPL     AS �ŷ�����_������
                           ,A.WN_TNSL_INT      AS �ŷ�����_������
                           ,A.TR_BRNO          AS �ŷ���_������
                           ,CU.CUST_NO         AS ����ȣ_������
                           ,BR.BRNO            AS ����ȣ_������
                           ,TRIM(BR.BR_NM)     AS ����_������
                           ,PD.PDCD            AS ��ǰ�ڵ�_������
                           ,TRIM(PD.PRD_KR_NM) AS ��ǰ��_������
                           ,A.TR_USR_NO        AS �ŷ�����ڹ�ȣ_������
                FROM        TB_SOR_LOA_TR_TR          A -- SOR_LOA_�ŷ�����
                JOIN        TB_SOR_LOA_TR_BF_LDGR_TR  B -- SOR_LOA_�ŷ������峻��
                            ON     A.CLN_ACNO           = B.CLN_ACNO
                            AND    A.CLN_EXE_NO         = B.CLN_EXE_NO
                            AND    A.CLN_TR_NO          = B.CLN_TR_NO
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
                LEFT OUTER
                JOIN        OT_DWA_CLN_PRD_STRC_BC    PD
                            ON     AC.PDCD          = PD.PDCD
                            AND    PD.STD_DT        = P_BASEDAY
                WHERE       1 = 1
                AND         A.WN_TNSL_PCPL >= 20000000 -- 2õ���� �̻� ��ȯ
                AND         A.TR_STCD <> '1' -- �ŷ������ڵ�(1:���� �̿� ����,���)
                AND         A.TR_DT BETWEEN  P_SOTM_DT AND P_EOTM_DT
                AND         A.CLN_TR_KDCD  IN ('300','310','320','360')  --���Űŷ������ڵ�(300:�����ȯ,310:�������ڼ���,320:�������ڼ���,360:�����ȯ-CC�κм���)
                )   A
    LEFT OUTER JOIN
                TB_SOR_LOA_TR_TR   B -- SOR_LOA_�ŷ����� [���� 30�г� �߻��� �ŷ�]
                ON     A.���¹�ȣ_������      = B.CLN_ACNO
                AND    A.�����ȣ_������      = B.CLN_EXE_NO
                AND    A.�ŷ���ȣ_������      < B.CLN_TR_NO  -- ������ ������ �ŷ�
                AND    A.�ŷ�����_������      = B.TR_DT      -- ������ ���� �ŷ��� ���� (���ڰ� ����Ǵ� �������� ��ȯ�ŷ��� ���ٰ� ����)
                -- AND    B.WN_TNSL_PCPL > 0                    -- ���ڻ�ȯ �ŷ��� �����Ϸ��� ������ �ʿ���
                AND    ( TO_TIMESTAMP(A.�ŷ�����_������ || A.�ŷ��ð�_������, 'YYYYMMDDHH24MISS') + (INTERVAL '30' MINUTE)  ) >  TO_TIMESTAMP(B.TR_DT || B.TR_TM,'YYYYMMDDHH24MISS')
                --AND    EXTRACT ( HOUR   FROM TO_TIMESTAMP(B.TR_DT || B.TR_TM) - TO_TIMESTAMP(A.�ŷ�����_������ || A.�ŷ��ð�_������) ) = 0  -- ���� ���� ��� 30�� �̳� �ŷ��� ���� ã�� ����
                --AND    EXTRACT ( MINUTE FROM TO_TIMESTAMP(B.TR_DT || B.TR_TM) - TO_TIMESTAMP(A.�ŷ�����_������ || A.�ŷ��ð�_������) ) < 30 -- ���� ���� ��� 30�� �̳� �ŷ��� ���� ã�� ����
                AND    B.CLN_TR_KDCD  IN ('300','310','320','360')  --���Űŷ������ڵ�(300:�����ȯ,310:�������ڼ���,320:�������ڼ���,360:�����ȯ-CC�κм���)
                AND    B.TR_STCD       = '1' -- �ŷ������ڵ�(1:����)
    )

    -- ������ �ŷ��������� GROUP BY (���¹�ȣ and �����ȣ and �ŷ���ȣ�� KEY)
    SELECT      ��������
               ,����ȣ_������
               ,����_������
               ,����ȣ_������
               ,���¹�ȣ_������
               ,�����ȣ_������
               ,�ŷ���ȣ_������
               ,��ǰ�ڵ�_������
               ,��ǰ��_������
               ,�ŷ�����_������
               ,NVL( SUM(�ŷ�����_����30�г��ŷ�), 0 ) AS �ŷ����ݰ�_����30�г��ŷ�
               ,CASE WHEN SUM( NVL(�ŷ�����_����30�г��ŷ�,0) ) < �ŷ�����_������ THEN 'Y' -- [���� �� 30�г� �ŷ� ���ݰ�]�� [������ �ŷ��� ����] ���� ���ٸ� ��ҷ� ���� 'Y'�� �����. ��û�� Ȯ�� �ʿ�
                     ELSE 'N'
                END                                  AS ��Ұŷ�����
               ,�ŷ�����_������
               ,�ŷ��ð�_������
               ,�ŷ�����ڹ�ȣ_������
    FROM        TB_TEMP_����������_22
    GROUP BY    ��������
               ,����ȣ_������
               ,����_������
               ,����ȣ_������
               ,���¹�ȣ_������
               ,�����ȣ_������
               ,�ŷ���ȣ_������
               ,��ǰ�ڵ�_������
               ,��ǰ��_������
               ,�ŷ�����_������
               ,�ŷ�����_������
               ,�ŷ��ð�_������
               ,�ŷ�����ڹ�ȣ_������
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������22',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
