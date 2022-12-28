/*
  ���α׷��� : ins_TB_OPE_KRI_ī���ȹ��03
  Ÿ�����̺� : TB_OPE_KRI_ī���ȹ��03
  KRI ��ǥ�� : ī��ű�/�ѵ����� �� ��ü �߻� ȸ����(����)
  ��      �� : ��̳�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ī���ȹ��-02 ī��ű�/�ѵ����� �� ��ü �߻� ȸ����(����)
       A: ī�� �ű� �߱� �� 6���� �̳��� ȸ�� �� 1���� �̻� ��ü���� ���ΰ���
       B: ī�� �ѵ����� �� 6���� �̳��� ȸ���� 1���� �̻� ��ü���� ���� ����
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

    DELETE OPEOWN.TB_OPE_KRI_ī���ȹ��03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_ī���ȹ��03
    SELECT   A.STD_DT           AS ��������
            ,B.CRD_MBR_ADM_BRNO AS ����ȣ
            ,D.BR_NM            AS ����
            ,B.CRD_MBR_DSCD     AS ī��ȸ�������ڵ�
            --,CD1.CMN_CD_NM      AS ī��ȸ�����и�
            ,A.TOT_OVD_PCPL     AS ��ü�ݾ�
            ,NULL               AS �ѵ���������ڵ�
            ,NULL               AS �ѵ���������
            ,C.ISN_DT           AS ī��߱�����
            ,B.MBR_NW_DT        AS ȸ���ű�����
            ,A.OVD_ST_DT        AS ��ü��������
            ,B.PREN_DSCD        AS ���α�������ڵ�
            --,TRIM(CD2.CMN_CD_NM)     -- ���α�������ڵ��

    FROM     (
              SELECT  STD_DT
                     ,CRD_MBR_NO
                     ,SUM(TOT_OVD_PCPL) AS TOT_OVD_PCPL
                     ,MIN(OVD_ST_DT)    AS OVD_ST_DT
              FROM    OT_DWA_CRD_CLN_BC X   /* DWA_ī�忩�ű⺻ */
              WHERE   STD_DT  =  P_BASEDAY
              AND     EXISTS (
                              SELECT 1
                              FROM OT_DWA_CRD_CLN_BC
                              WHERE STD_DT     = X.STD_DT
                              AND CRD_MBR_NO = X.CRD_MBR_NO
                              AND TOT_OVD_PCPL > 0
                              AND MONTHS_BETWEEN(TO_DATE(SUBSTR(STD_DT,1,6),'YYYYMM'), TO_DATE(SUBSTR(OVD_ST_DT,1,6),'YYYYMM')) >= 1
                             )  -- 1���� �̻� ��ü��
              GROUP BY STD_DT, CRD_MBR_NO
             ) A

    JOIN     TB_SOR_CLT_MBR_BC B    /* SOR_CLT_ȸ���⺻ */
             ON  A.CRD_MBR_NO = B.CRD_MBR_NO
             AND B.PREN_DSCD  = '1'  -- ���α�������ڵ� : 1-����

    JOIN     TB_SOR_CLT_CRD_BC C    /* SOR_CLT_ī��⺻ */
             ON  A.CRD_MBR_NO   =  C.CRD_MBR_NO
             AND C.ISN_DT    >= TO_CHAR(ADD_MONTHS(TO_DATE(A.STD_DT,'YYYYMMDD'), -6), 'YYYYMMDD')  -- �߱����� 6���� �̳�

    JOIN     TB_SOR_CMI_BR_BC  D    /* SOR_CMI_���⺻ */
             ON  B.CRD_MBR_ADM_BRNO = D.BRNO

    JOIN     TB_SOR_CUS_MAS_BC E    /* SOR_CUS_���⺻ */
             ON  B.CUST_NO = E.CUST_NO
/*
    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_�����ڵ�⺻
               WHERE   TPCD_NO_EN_NM = 'CRD_MBR_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD1
             ON    B.CRD_MBR_DSCD = CD1.CMN_CD

    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC
               WHERE   TPCD_NO_EN_NM = 'PREN_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD2
             ON    B.PREN_DSCD = CD2.CMN_CD
*/

    UNION ALL

    SELECT   A.STD_DT           AS ��������
            ,B.CRD_MBR_ADM_BRNO AS ����ȣ
            ,D.BR_NM            AS ����
    --        ,B.CUST_NO          AS ����ȣ
    --        ,E.CUST_NM          AS ����
    --        ,A.CRD_MBR_NO       AS ī��ȸ����ȣ
            ,B.CRD_MBR_DSCD     AS ī��ȸ�������ڵ�
            --,CD1.CMN_CD_NM      AS ī��ȸ�����и�
            ,A.TOT_OVD_PCPL     AS ��ü�ݾ�
            ,F.LMT_CHG_RSCD     AS �ѵ���������ڵ�
            --,CD3.CMN_CD_NM      AS �ѵ��������
            ,F.LMT_CHG_DT       AS �ѵ���������
            ,NULL               AS �߱�����
            ,B.MBR_NW_DT        AS ȸ���ű�����
            ,A.OVD_ST_DT        AS ��ü��������
            ,B.PREN_DSCD        AS ���α�������ڵ�
            --,TRIM(CD2.CMN_CD_NM)     -- ���α�������ڵ��

    FROM     (
              SELECT  STD_DT
                     ,CRD_MBR_NO
                     ,SUM(TOT_OVD_PCPL) AS TOT_OVD_PCPL
                     ,MIN(OVD_ST_DT)    AS OVD_ST_DT
              FROM    OT_DWA_CRD_CLN_BC X   /* DWA_ī�忩�ű⺻ */
              WHERE   STD_DT  =  P_BASEDAY
              AND     EXISTS (
                              SELECT 1
                              FROM OT_DWA_CRD_CLN_BC
                              WHERE STD_DT     = X.STD_DT
                              AND CRD_MBR_NO = X.CRD_MBR_NO
                              AND TOT_OVD_PCPL > 0
                              AND MONTHS_BETWEEN(TO_DATE(SUBSTR(STD_DT,1,6),'YYYYMM'), TO_DATE(SUBSTR(OVD_ST_DT,1,6),'YYYYMM')) >= 1
                             )  -- 1���� �̻� ��ü��
              GROUP BY STD_DT, CRD_MBR_NO
             ) A

    JOIN     TB_SOR_CLT_MBR_BC B    /* SOR_CLT_ȸ���⺻ */
             ON  A.CRD_MBR_NO  =  B.CRD_MBR_NO
             AND B.PREN_DSCD  = '1'  -- ���α�������ڵ� : 1-����

    JOIN     TB_SOR_CMI_BR_BC  D    /* SOR_CMI_���⺻ */
             ON  B.CRD_MBR_ADM_BRNO =  D.BRNO

    JOIN     TB_SOR_CUS_MAS_BC E    /* SOR_CUS_���⺻ */
             ON  B.CUST_NO = E.CUST_NO

    JOIN     TB_SOR_MBR_LMT_CHG_HT F  /* SOR_MBR_ī����ѵ������̷� */
             ON A.CRD_MBR_NO     = F.CRD_MBR_NO
             AND F.LMT_CHG_HDCD  = '11'             -- �ѵ������׸��ڵ�(14:����Ư���ѵ�)
             AND SUBSTR(F.LMT_CHG_RSCD, 1, 1) IN ('2', '6', '8')  -- �ѵ���������ڵ�(����)
             AND F.LMT_CHG_DT  >= TO_CHAR(ADD_MONTHS(TO_DATE(A.STD_DT,'YYYYMMDD'), -6), 'YYYYMMDD')  -- �ѵ��������� 6���� �̳�
/*
    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_�����ڵ�⺻
               WHERE   TPCD_NO_EN_NM = 'CRD_MBR_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD1
             ON    B.CRD_MBR_DSCD = CD1.CMN_CD

    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC
               WHERE   TPCD_NO_EN_NM = 'PREN_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD2
             ON    B.PREN_DSCD = CD2.CMN_CD

    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_�����ڵ�⺻
               WHERE   TPCD_NO_EN_NM = 'LMT_CHG_RSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD3
             ON    F.LMT_CHG_RSCD = CD3.CMN_CD
*/
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_ī���ȹ��03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

