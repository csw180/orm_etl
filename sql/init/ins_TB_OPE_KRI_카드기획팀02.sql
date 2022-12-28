/*
  ���α׷��� : ins_TB_OPE_KRI_ī���ȹ��02
  Ÿ�����̺� : TB_OPE_KRI_ī���ȹ��02
  KRI ��ǥ�� : �ű� �� 3���� �̳� �ſ�ī�� ��üȸ�� ����
  ��      �� : ��̳�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ī���ȹ��-02 �ű� �� 3���� �̳� �ſ�ī�� ��üȸ�� ����
       A: ������ ���� 3���� ������ ��ȸ�� ���ΰ� �� �����(������ȸ����)�� ����������
          15�� �̻� ��ü���� ȸ����
       B: ���� �� ���� 3���� ������ ��ȸ�� ���ΰ� �� ����� ��
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

    DELETE OPEOWN.TB_OPE_KRI_ī���ȹ��02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_ī���ȹ��02

    SELECT   A.STD_DT
            ,B.CRD_MBR_ADM_BRNO
            ,J1.BR_NM
            --,A.CRD_MBR_NO
            ,C.CRD_PRD_DSCD         -- ī���ǰ�����ڵ�
            --,CD1.CMN_CD_NM         -- ī���ǰ�����ڵ��
            ,C.ISN_DT             -- �߱�����
            --,B.CRD_MBR_DSCD
            ,B.MBR_NW_DT
            ,A.OVD_ST_DT
            ,A.OVD_AMT
            ,B.PREN_DSCD             -- ���α�������ڵ�
            --,TRIM(CD2.CMN_CD_NM)     -- ���α�������ڵ��

    FROM     (
              SELECT   A.STD_DT
                      ,A.CRD_MBR_NO
                      ,SUM(A.TOT_OVD_PCPL)     AS  OVD_AMT   -- ���ݿ�ü�ݾ�
                      ,MIN(A.OVD_ST_DT)        AS  OVD_ST_DT -- ���ݿ�ü��������
              FROM     OT_DWA_CRD_CLN_BC   A   -- DWA_ī�忩�ű⺻
              WHERE    1=1
              AND      A.STD_DT  =  P_BASEDAY
              GROUP BY A.STD_DT
                      ,A.CRD_MBR_NO
             )   A

    JOIN     TB_SOR_CLT_MBR_BC     B   -- SOR_CLT_ȸ���⺻
             ON   A.CRD_MBR_NO  =   B.CRD_MBR_NO

    JOIN     TB_SOR_CLT_CRD_BC     C   -- SOR_CLT_ī��⺻
             ON   A.CRD_MBR_NO  =   C.CRD_MBR_NO
             AND  C.ISN_DT >=  TO_CHAR(ADD_MONTHS(TO_DATE(P_BASEDAY, 'YYYYMMDD'), -3), 'YYYYMMDD') -- �߱����� 3���� �̳�

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
             ON  B.CRD_MBR_ADM_BRNO   =  J1.BRNO
--           AND J1.BR_DSCD = '1'      -- ����

/*
    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_�����ڵ�⺻
               WHERE   TPCD_NO_EN_NM = 'CRD_PRD_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD1
             ON    C.CRD_PRD_DSCD = CD1.CMN_CD

    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC
               WHERE   TPCD_NO_EN_NM = 'PREN_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD2
             ON    B.PREN_DSCD = CD2.CMN_CD
*/
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_ī���ȹ��02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
