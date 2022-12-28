/*
  ���α׷��� : ins_TB_OPE_KRI_������Ź��01
  Ÿ�����̺� : TB_OPE_KRI_������Ź��01
  KRI ��ǥ�� : ������ 3��� �̻� ��Ź �ݾ� ����
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ������Ź��-01 ������ 3��� �̻� ��Ź �ݾ� ����
       A: �������� �Ǹ��� ������ 3��� �̻� ��Ź��ǰ�ݾ�
       B: �������� �Ǹ��� ��Ź��ǰ�ݾ�
     - ������Ź��-02 ������ 3��� �̻� ��Ź ���� �� ����
       A: �������� �Ǹ��� ������ 3��� �̻� ��Ź��ǰ ���¼�
       B: �������� �Ǹ��� ��Ź��ǰ�ݾ�
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

    DELETE OPEOWN.TB_OPE_KRI_������Ź��01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_������Ź��01
    /*ISA���� ��Ź �űԳ���*/
    SELECT
             A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,TRIM(B.DTL_CND_DESC)   -- ��ǰ�������ڵ�
            ,NULL             -- ��ǰ���Թ�ȣ
            ,PD.PRD_KR_NM     -- ��ǰ��
            ,'KRW'            -- ��ȭ�ڵ�
            ,A.LDGR_RMD       -- ���Աݾ�
            ,A.NW_DT          -- ���½ű�����
            ,A.EXPI_DT        -- ���¸�������
    FROM     OT_DWA_INTG_DPS_BC A   -- DWA_���ռ��ű⺻
    JOIN     (
              SELECT B.PDCD
                    ,C.DTL_CND_DESC
              FROM   TB_SOR_PDF_CND_TP_CMPS_BC A  -- SOR_PDF_�������������⺻
              JOIN   TB_SOR_PDF_CND_TP_RLT_DL  B  -- SOR_PDF_��ǰ�������������
                     ON   A.CND_TP_ADM_NO = B.CND_TP_ADM_NO
                     AND  B.APL_STCD = '10'
              JOIN   TB_SOR_PDF_DTL_CND_TP_BC C   -- SOR_PDF_�����������⺻
                     ON   A.MN_DTL_CND_ADM_NO = C.DTL_CND_ADM_NO
                     AND  C.APL_STCD = '10'
              WHERE  1=1
              AND    A.MN_DTL_CND_ADM_NO like 'C192%'
              AND    A.APL_STCD = '10'
             ) B
             ON    A.PDCD = B.PDCD
    JOIN     TB_SOR_CMI_BR_BC    J   -- SOR_CMI_���⺻
             ON    A.ADM_BRNO   = J.BRNO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD   -- SOR_PDF_��ǰ�⺻
             ON     A.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE    1=1
    AND      STD_DT = P_BASEDAY
    AND      A.DPS_DP_DSCD = '5'
    AND      A.ACNO NOT LIKE '176%'
    AND      A.ACNO NOT LIKE '169%'
    AND      A.DPS_ACN_STCD = '01'
    AND      A.NW_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT

    UNION ALL
       /*ISA�űԳ���*/
    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.CUST_NO
            ,A.ACNO                            -- ���¹�ȣ
            ,TRIM(CD.CMN_CD) || '-' || TRIM(CD.CMN_CD_NM)  -- ��ǰ�������ڵ�
            ,C.ISA_PRD_ACNO                    -- ��ǰ���Թ�ȣ
            ,B.AST_ADM_PRD_NO_NM               -- ��ǰ�����ڵ�
            ,'KRW'                             -- ��ȭ�ڵ�
            ,C.ACBK_PRC                        -- ���Աݾ�
            ,C.NW_DT                           -- ���½ű�����
            ,C.EXPI_DT                         -- ���¸�������
    FROM     OT_DWA_INTG_DPS_BC A    -- DWA_���ռ��ű⺻
    JOIN     (
              SELECT STD_DT
                    ,DPS_ACNO
                    ,AST_ADM_PRD_NO
                    ,ISA_PRD_ACNO
                    ,NW_DT
                    ,EVL_AMT
                    ,'' as EXPI_DT
                    ,ACBK_PRC
              FROM   TB_SOR_ISA_BNFC_BLN_LDGR_TR   -- SOR_ISA_���������ܰ���峻��
              WHERE  1=1
              AND    STD_DT = P_BASEDAY

              UNION ALL

              SELECT STD_DT
                    ,DPS_ACNO
                    ,AST_ADM_PRD_NO
                    ,ISA_PRD_ACNO
                    ,NW_DT
                    ,EVL_AMT
                    ,EXPI_DT
                    ,ACBK_PRC
              FROM   TB_SOR_ISA_DP_BLN_LDGR_TR   -- SOR_ISA_�����ܰ���峻��
              WHERE  1=1
              AND    STD_DT = P_BASEDAY
             ) C
             ON    A.ACNO = C.DPS_ACNO
             AND   C.NW_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT

    JOIN     TB_SOR_ISA_PRD_INF_BC B  -- SOR_ISA_��ǰ�����⺻
             ON    C.AST_ADM_PRD_NO = B.AST_ADM_PRD_NO

    JOIN     TB_SOR_CMI_BR_BC    J   -- SOR_CMI_���⺻
             ON    A.ADM_BRNO   = J.BRNO

    JOIN     TB_SOR_CMI_CMN_CD_BC  CD -- SOR_CMI_�����ڵ�⺻
             ON    B.AST_GRP_CLCD = CD.CMN_CD
             AND   CD.TPCD_NO = '4600824422'

    WHERE    1=1
    AND      A.DPS_ACN_STCD = '01'
    AND      A.STD_DT = P_BASEDAY
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_������Ź��01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
