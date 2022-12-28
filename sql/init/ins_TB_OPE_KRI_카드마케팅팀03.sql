/*
  ���α׷��� : ins_TB_OPE_KRI_ī�帶������03
  Ÿ�����̺� : TB_OPE_KRI_ī�帶������03
  ��      �� : ������븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ī�帶������-03 : ���� ���� �� �ſ�ī�� ��(��ü)
       A: ������/���� ��������Ϸκ��� 5������ �ʰ��� �ſ�ī�� �� üũī�� ��
*/
DECLARE
  P_BASEDAY  VARCHAR2(8);  -- ��������
  P_SOTM_DT  VARCHAR2(8);  -- �������
  P_EOTM_DT  VARCHAR2(8);  -- �������
  P_D5_BF_SLS_DT  VARCHAR2(8);  -- 5������������
  P_LD_CN    NUMBER;  -- �ε��Ǽ�

BEGIN
  SELECT  STD_DT,EOTM_DT,SUBSTR(EOTM_DT,1,6) || '01',D5_BF_SLS_DT
  INTO    P_BASEDAY
         ,P_EOTM_DT
         ,P_SOTM_DT
         ,P_D5_BF_SLS_DT
  FROM   DWZOWN.OM_DWA_DT_BC
  WHERE   STD_DT = '&1';
  
  IF P_EOTM_DT = P_BASEDAY  THEN

    DELETE OPEOWN.TB_OPE_KRI_ī�帶������03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_ī�帶������03
    SELECT
            P_BASEDAY
           ,T.HGOV_BRNO
           ,Y.BR_NM
           ,T.CRD_PRD_DSCD
/*
           ,CASE WHEN T.CRD_PRD_DSCD = '01' THEN '�ſ�ī��'
                 WHEN T.CRD_PRD_DSCD = '02' THEN '��Ʈ��üũī��'
                 WHEN T.CRD_PRD_DSCD = '03' THEN '������üũī��'
                 WHEN T.CRD_PRD_DSCD = '04' THEN '���α���ī��'
                 WHEN T.CRD_PRD_DSCD = '05' THEN '�鼼��ī��'
                 WHEN T.CRD_PRD_DSCD = '06' THEN '�ַ���������ī��'
                 WHEN T.CRD_PRD_DSCD = '07' THEN '������ī��'
                 WHEN T.CRD_PRD_DSCD = '08' THEN '����ī��'
                 WHEN T.CRD_PRD_DSCD = '09' THEN '����ICī��'
                 WHEN T.CRD_PRD_DSCD = '10' THEN '����ī��'
                 WHEN T.CRD_PRD_DSCD = '11' THEN '�ĺ������н�ī��'
                 WHEN T.CRD_PRD_DSCD = '12' THEN '����Ϲ�ŷICī��'
                 WHEN T.CRD_PRD_DSCD = '13' THEN '������ġ/���������ī��'
                 WHEN T.CRD_PRD_DSCD = '14' THEN '���ڰ�������'
                 WHEN T.CRD_PRD_DSCD = '15' THEN '��ũ�Ӵ�'
                 WHEN T.CRD_PRD_DSCD = '80' THEN '���ī�����(ī���)'
                 WHEN T.CRD_PRD_DSCD = '91' THEN 'Ÿ��ſ�ī��'
                 WHEN T.CRD_PRD_DSCD = '92' THEN 'Ÿ��üũī��'
                 ELSE '�ش����' END AS ī���ǰ����    --ī���ǰ�����ڵ�
*/                 
        --   ,T.CRD_NO            AS ī���ȣ
           ,T.ISN_DT            -- ī��߱�����
           ,T.SHPP_ENVL_DT      -- ī��������
           ,T.BR_ACP_DT         AS ����������
          -- ,CASE WHEN T.CRD_ACP_TPCD = '1' THEN '�Ϲ�Ư������'
          --       WHEN T.CRD_ACP_TPCD = '2' THEN '�ݼۺ�����'
          --       WHEN T.CRD_ACP_TPCD = '3' THEN 'Ÿ�������̰�����'
          --       WHEN T.CRD_ACP_TPCD = '4' THEN '���������'
          --6  ELSE '�ش����' END  AS ī�����������ڵ�
    FROM  (
            SELECT
                   A.SHPP_ENVL_DT         /*��ۺ�������             */
                  ,A.SHPP_ENVL_NO         /*��ۺ�����ȣ             */
                  ,A.CRD_NO               /*ī���ȣ                 */
                  ,A.HGOV_BRNO            /*��������ȣ               */
                  ,C.CRD_PRD_DSCD         --ī���ǰ�����ڵ�
                  ,A.BR_ACP_DT            /*����������               */
                  ,A.CRD_ACP_TPCD         /*ī�����������ڵ�         1 �Ϲ�Ư������  2 �ݼۺ����� 3 Ÿ�������̰����� 4 ��������� */
                  ,A.HLDG_CRD_PCS_DSCD    /*����ī��ó�������ڵ�     10 ���� 20 �̰� 30 ���� 40 �߼� 50 ��� */
                  ,A.SNDG_DT              /*�߼�����                 */
                  ,C.ISN_DT
                  ,DECODE(C.PSSR_DSCD,'4', C.PSSR_CUST_NO, C.CUST_NO) AS CUST_NO /*����ȣ */
                  ,' ' AS BC_SNDG_NO      /*�񾾹߼۹�ȣ             */
                  ,B.CRD_RCPL_DSCD        /*ī������������ڵ�       */
            FROM
                   TB_SOR_ISU_CRD_HGOV_TR  A    --SOR_ISU_ī�屳�γ���
                  ,TB_SOR_ISU_CRD_SNDG_TR  B    --SOR_ISU_ī��߼۳���
                  ,TB_SOR_CLT_CRD_BC       C    --SOR_CLT_ī��⺻

            WHERE
                   A.SHPP_ENVL_DT            = B.SHPP_ENVL_DT   --��ۺ�������
              AND  A.SHPP_ENVL_NO            = B.SHPP_ENVL_NO   --��ۺ�����ȣ
              AND  A.CRD_NO                  = B.CRD_NO
              AND  B.CRD_NO                  = C.CRD_NO
              AND  A.BR_ACP_DT               < P_D5_BF_SLS_DT

            union ALL

    /* BC���� ��������*/
            SELECT
                   A.SNDG_DT AS SHPP_ENVL_DT  /*�߼�����                 */
                  ,' ' AS SHPP_ENVL_NO        /*��ۺ�����ȣ             */
                  ,A.CRD_NO                 /*ī���ȣ                 */
                  ,A.HGOV_BRNO              /*��������ȣ               */
                  ,C.CRD_PRD_DSCD         --ī���ǰ�����ڵ�
                  ,A.BR_ACP_DT              /*����������               */
                  ,A.CRD_ACP_TPCD           /*ī�����������ڵ�         */
                  ,A.HLDG_CRD_PCS_DSCD      /*����ī��ó�������ڵ�     */
                  ,A.SNDG_DT                /*�߼�����                     */
                  ,C.ISN_DT
                  ,DECODE(C.PSSR_DSCD,'4', C.PSSR_CUST_NO, C.CUST_NO) AS CUST_NO /*����ȣ */
                  ,A.BC_SNDG_NO             /*�񾾹߼۹�ȣ             */
                  ,B.CRD_RCPL_DSCD          /*ī������������ڵ�       */
            FROM
                   TB_SOR_ISU_BC_HGOV_TR   A,   -- SOR_ISU_��ī�屳�γ���
                   TB_SOR_ISU_BC_SHPP_TR   B,   -- SOR_ISU_��ī���۳���
                   TB_SOR_CLT_CRD_BC       C    -- SOR_CLT_ī��⺻
            WHERE  A.CRD_NO = B.CRD_NO
              AND  A.BC_SNDG_NO =B.BC_SNDG_NO
              AND  A.CRD_NO                  = C.CRD_NO
              AND  A.BR_ACP_DT               < P_D5_BF_SLS_DT
        ) T
       , OT_DWA_DD_BR_BC  Y   -- DWA_�����⺻
    WHERE 1=1
    AND T.HGOV_BRNO = Y.BRNO
    AND Y.STD_DT = P_BASEDAY
    AND HLDG_CRD_PCS_DSCD = '10'

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_ī�帶������03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
