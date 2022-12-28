/*
  ���α׷��� : ins_TB_OPE_KRI_�ݵ�����14
  Ÿ�����̺� : TB_OPE_KRI_�ݵ�����14
  KRI ��ǥ�� : ��65�� �̻� �ű��ݵ�ݾ�
  ��      �� : �������븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ݵ�����-14: ��65�� �̻� �ű��ݵ�ݾ�
       A: ������ �űԵ� �� 65�� �̻� ���� �ݵ� �� ��Ź ���� �ݾ��� ��
     - �ݵ�����-15: ��65�� �̻� �ű��ݵ� �Ǽ�
       A: ������ �űԵ� �� 65�� �̻� ���� ��Ź  �Ǵ� �ݵ� ��ǰ �ű� ���� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�ݵ�����14
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ݵ�����14
    SELECT *
    FROM
    (
     SELECT   P_BASEDAY
             ,T1.ADM_BRNO
             ,J1.BR_NM
             ,T1.ACNO
             ,T1.CUST_NO
             ,CASE WHEN LENGTH(TRIM(CUS.CUST_RNNO)) = 13 THEN
                       CASE WHEN SUBSTR(CUS.CUST_RNNO, 3, 4) > SUBSTR(T1.NW_DT, 5, 4) THEN
                                CASE WHEN SUBSTR(CUS.CUST_RNNO, 7, 1) IN ( '3', '4', '7', '8' ) THEN
                                          CAST(SUBSTR(T1.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('20'|| SUBSTR(CUS.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                     WHEN SUBSTR(CUS.CUST_RNNO, 7, 1) IN ( '9', '0' ) THEN
                                          CAST(SUBSTR(T1.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('18'|| SUBSTR(CUS.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                     ELSE CAST(SUBSTR(T1.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('19'|| SUBSTR(CUS.CUST_RNNO, 1, 2) AS NUMERIC(04)) - 1
                                END
                            ELSE
                                CASE WHEN SUBSTR(CUS.CUST_RNNO, 7, 1) IN ( '3', '4', '7', '8' ) THEN
                                          CAST(SUBSTR(T1.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('20'|| SUBSTR(CUS.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                     WHEN SUBSTR(CUS.CUST_RNNO, 7, 1) IN ( '9', '0' ) THEN
                                          CAST(SUBSTR(T1.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('18'|| SUBSTR(CUS.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                     ELSE CAST(SUBSTR(T1.NW_DT, 1, 4) AS NUMERIC(04)) - CAST('19'|| SUBSTR(CUS.CUST_RNNO, 1, 2) AS NUMERIC(04))
                                END
                       END
                   ELSE 999
              END    AS  AGE   -- ������
             ,T1.NW_DT
             ,T1.EXPI_DT
             ,PD2.PRD_KR_NM
             ,T2.TR_AMT
     FROM     TB_SOR_BCM_BNAC_BC    T1     -- SOR_BCM_�������ǰ��±⺻
     JOIN     (
               SELECT   ACNO
                       ,SUM(TR_AMT)  TR_AMT
               FROM     TB_SOR_BCM_TR_TR   -- SOR_BCM_�ŷ�����
               WHERE    1=1
               AND      TR_SNO =  '1'
               AND      CNCL_YN =  'N'
               GROUP BY ACNO
              )   T2
              ON    T1.ACNO  =  T2.ACNO

     JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
              ON    T1.ADM_BRNO  =  J1.BRNO

     LEFT OUTER JOIN
              TB_SOR_PDF_PRD_BC    PD2   -- SOR_PDF_��ǰ�⺻
              ON   T1.PDCD  =  PD2.PDCD
              AND  PD2.APL_STCD  = '10'  -- ��������ڵ�: Ȱ��(10)
              AND  PD2.PRD_DSCD  = '01'  -- ��ǰ�����ڵ� : �ݵ�⺻(01)

     JOIN     OM_DWA_INTG_CUST_BC  CUS   --DWA_���հ��⺻
              ON   T1.CUST_NO   =  CUS.CUST_NO

     WHERE    1=1
     AND      T1.NW_DT  BETWEEN  P_SOTM_DT  AND  P_EOTM_DT
     AND      T1.RTPN_DSCD  =  '00'
     AND      T1.NW_CHNL_TPCD  =   'TTML'
    )   A
    WHERE     1=1
    AND       AGE >= 65
    AND       AGE != 999
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ݵ�����14',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
