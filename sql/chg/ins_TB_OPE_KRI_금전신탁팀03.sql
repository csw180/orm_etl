/*
  ���α׷��� : ins_TB_OPE_KRI_������Ź��03
  Ÿ�����̺� : TB_OPE_KRI_������Ź��03
  KRI ��ǥ�� : ��65�� �̻� �ű� ��Ź�ݾ�
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ������Ź��-03 ��65�� �ű� ��Ź �ݾ�
       A: ���� �űԵ� �� 65�� �̻� ���� ��Ź ���� �ݾ��� ��
     - ������Ź��-04 ��65�� �ű� ��Ź �Ǽ�
       A: ���� �űԵ� �� 65�� �̻� ���� ��Ź ��ǰ �ű� ���� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_������Ź��03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_������Ź��03
    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.CUST_NO
            ,CASE WHEN LENGTH(TRIM(A.CUST_RNNO)) = 13 THEN
                      CASE WHEN SUBSTR(A.CUST_RNNO, 3, 4) > SUBSTR(A.NW_DT, 5, 4) THEN
                               CASE WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '3', '4', '7', '8' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('20'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                    WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '9', '0' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('18'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                    ELSE CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('19'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                               END
                           ELSE
                               CASE WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '3', '4', '7', '8' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('20'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                    WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '9', '0' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('18'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                    ELSE CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('19'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                               END
                      END
                  ELSE 999
             END    AS  AGE   -- ������
            ,A.ACNO           -- ���¹�ȣ
            ,B.DTL_CND_DESC   -- ��ǰ�������ڵ�
            ,PD.PRD_KR_NM     -- ��ǰ��
            ,'KRW'            -- ��ȭ�ڵ�
            ,C.TR_AMT         -- ���Աݾ�
            ,A.NW_DT          -- ���½ű�����
            ,A.EXPI_DT        -- ���¸�������
    FROM     OT_DWA_INTG_DPS_BC A    -- DWA_���ռ��ű⺻
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
             AND   J.BR_DSCD    = '1'   -- 1.�߾�ȸ, 2.����
             
    JOIN     TB_SOR_DEP_TR_TR   C   -- SOR_DEP_�ŷ�����
             ON    A.ACNO   = C.ACNO
             AND   A.NW_DT  = C.TR_DT
             AND   C.DPS_TSK_CD = '0101'

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD   -- SOR_PDF_��ǰ�⺻
             ON     A.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE    1=1
    AND      A.STD_DT = P_BASEDAY
    AND      A.DPS_DP_DSCD = '5'
    AND      A.ACNO  NOT LIKE '176%'
    AND      A.DPS_ACN_STCD NOT IN ('99', '98')
    AND      CASE WHEN LENGTH(TRIM(A.CUST_RNNO)) = 13 THEN
                      CASE WHEN SUBSTR(A.CUST_RNNO, 3, 4) > SUBSTR(A.NW_DT, 5, 4) THEN
                               CASE WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '3', '4', '7', '8' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('20'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                    WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '9', '0' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('18'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                    ELSE CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('19'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                               END
                           ELSE
                               CASE WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '3', '4', '7', '8' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('20'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                    WHEN SUBSTR(A.CUST_RNNO, 7, 1) IN ( '9', '0' ) THEN
                                         CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('18'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                    ELSE CAST(SUBSTR(A.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('19'|| SUBSTR(A.CUST_RNNO, 1, 2) AS NUMERIC(04))
                               END
                      END
                  ELSE 999
             END  BETWEEN 65  AND  900
    AND      A.NW_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT
		;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_������Ź��03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


