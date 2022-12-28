/*
  ���α׷��� : ins_TB_OPE_KRI_�и�����02
  Ÿ�����̺� : TB_OPE_KRI_�и�����02
  KRI ��ǥ�� : ������� ������� �̵�� ��� ��
  ��      �� : ���α�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
   - �и�����-02 ������� ������� �̵�� ��� ��
     A: ������� �ο� �� �ش� �б⸻���� ������/�������� ��������� ������� ���� ��� ��
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

    DELETE OPEOWN.TB_OPE_KRI_�и�����02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�и�����02
    SELECT   P_BASEDAY
            ,A.BRNO
            ,D.BR_NM
            ,A.ACN_DCMT_NO
            ,A.CUST_NO
            ,A.PREN_DSCD AS ���α������
            ,'���Ῡ��' AS DSCD
            ,PD.PRD_KR_NM
            ,A.CRCD
            ,A.APRV_AMT
            ,A.TOT_CLN_RMD
            ,A.CLN_APRV_DT
            ,C.APRV_LN_EXPI_DT
            ,B.LNRV_JDGM_DSCD   -- �и������������ڵ�(01:����,02:���Ǻ�����,03:����,04:������,05:��������)
            ,B.JDGM_DT          -- ��������
            ,'N'                -- ���࿩�α����ڵ�

    FROM     TB_SOR_EWL_LN_XCDC_CLN_BC A  --  SOR_EWL_�и������Ῡ�ű⺻

    JOIN     TB_SOR_EWL_LN_XCLN_JDGM_TR    B  -- SOR_EWL_�и������Ῡ����������
             ON    A.TGT_ABST_DT = B.TGT_ABST_DT  -- �����������
             AND   A.CLN_APC_NO  = B.CLN_APC_NO
             AND   B.LNRV_JDGM_DSCD IN ('02','03','04')

    JOIN     TB_SOR_CLI_CLN_APRV_BC C    -- SOR_CLI_���Ž��α⺻
             ON    A.CLN_APC_NO  = C.CLN_APC_NO

    JOIN     TB_SOR_CMI_BR_BC D      -- SOR_CMI_���⺻
             ON    A.BRNO = D.BRNO
             
    LEFT OUTER JOIN
            TB_SOR_PDF_PRD_BC  PD
            ON  C.PDCD   = PD.PDCD
            AND PD.APL_STCD ='10'
                      
    WHERE    1=1
    AND      A.NFFC_UNN_DSCD = '1'
    AND      A.DEL_YN = 'N'
    AND      A.EXC_TGT_YN = 'N'
    AND      A.XCDC_CLN_PGRS_STCD in ('03','04','05','06','07')
    AND      A.TGT_ABST_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      NOT(
                 (A.XCDC_CLN_PGRS_STCD = '05' AND A.LNRV_STS_DSCD = '02') OR
                 (A.XCDC_CLN_PGRS_STCD = '07' AND A.LNRV_STS_DSCD = '02')
                )                
--## XCDC_CLN_PGRS_STCD (���Ῡ����������ڵ�)
--01:������,02:��ɻ�,03:��������,04:��ġ����������
--05:��ġ��������,06:���ǽ�û,07:������
--## LNRV_STS_DSCD (�и�����±����ڵ�)
--01:������,02:�Ϸ�,03:�ϰ�,04:������
                
    AND      NOT EXISTS
                (
                  SELECT 1
                  FROM   TB_SOR_EWL_AFM_EXG_TR X   -- SOR_EWL_�и������ܴ�󳻿�
                  WHERE  TGT_ABST_DT = A.TGT_ABST_DT
                  AND    CUST_NO= A.CUST_NO
                )

    UNION  ALL

    SELECT   P_BASEDAY
            ,A.SLS_BRNO AS BRNO
            ,D.BR_NM
            ,C.ACN_DCMT_NO
            ,A.CUST_NO
            ,'' AS ���α������
            ,'���ο���' AS DSCD
            ,PD.PRD_KR_NM
            ,C.CRCD
            ,C.APRV_AMT
            ,0 --A.TOT_CLN_RMD --
            ,C.APRV_DT
            ,C.APRV_LN_EXPI_DT
            ,''
            ,B.DPC_DT
            ,'N'                -- ���࿩�α����ڵ�

    FROM     TB_SOR_EWL_LN_APCL_BC A         --  SOR_EWL_�и�����ο��ű⺻

    JOIN     TB_SOR_EWL_LN_APCL_ACTN_DL B    --  SOR_EWL_�и�����ο�����ġ��(DW �����ʿ�)
             ON    A.TGT_ABST_DT = B.TGT_ABST_DT
             AND   A.CUST_NO     = B.CUST_NO
             AND   A.JUD_APRV_NO = B.JUD_APRV_NO
             AND   LENGTH(B.ACTN_ITM_ESTM_CTS) > 5

    JOIN     TB_SOR_CLI_CLN_APRV_BC C        --  SOR_CLI_���Ž��α⺻
             ON    A.JUD_APRV_NO = C.CLN_APRV_NO

    JOIN     TB_SOR_CMI_BR_BC D        -- SOR_CMI_���⺻
             ON    A.SLS_BRNO = D.BRNO

    LEFT OUTER JOIN
            TB_SOR_PDF_PRD_BC  PD
            ON  C.PDCD   = PD.PDCD
            AND PD.APL_STCD ='10'

    WHERE    1=1
    AND      A.NFFC_UNN_DSCD = '1'
    AND      A.DEL_YN        = 'N'
    AND      A.EXC_TGT_YN    = 'N'
    AND      A.APCL_PGRS_STCD IN ('13','14','15')
    AND      A.TGT_ABST_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    AND      NOT (A.APCL_PGRS_STCD = '15' AND A.LNRV_STS_DSCD = '02')
--## APCL_PGRS_STCD(���ο�����������ڵ�)
--11:������,12:��ɻ�/��ġ���׼���(����),13:���ο����뺸(����),14:��ġ��������(��)
--15:��ġ��������(����)    
--## LNRV_STS_DSCD(�и�����±����ڵ�)
--01:������,02:�Ϸ�,03:�ϰ�,04:������
    AND      NOT EXISTS
                (
                  SELECT 1
                  FROM   TB_SOR_EWL_AFM_EXG_TR X   -- SOR_EWL_�и������ܴ�󳻿�
                  WHERE  TGT_ABST_DT = A.TGT_ABST_DT
                  AND    CUST_NO= A.CUST_NO
                )
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�и�����02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT