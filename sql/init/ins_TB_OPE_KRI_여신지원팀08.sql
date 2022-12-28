/*
  ���α׷��� : ins_TB_OPE_KRI_����������08
  Ÿ�����̺� : TB_OPE_KRI_����������08
  KRI ��ǥ�� : ���� ���� ���� �� ���� �� �� �ֱ� 1������ ������ ����Ǽ�
  ��      �� : ���񼱰���
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-08 ���� ���� ���� �� ���� �� �� �ֱ� 1������ ������ ����Ǽ�
       A: �������� ���� Ȥ�� ���� ���� �ֱ� 1���� �̳��� ����������� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_����������08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������08

    SELECT   P_BASEDAY
            ,A.STUP_RGT_BRNO AS ����ȣ
            ,J1.BR_NM        AS ����
            ,A.MRT_NO        AS �㺸��ȣ
--            ,A.MRT_TPCD      AS �㺸�����ڵ�
            ,B.MRT_CD        AS �㺸������
            ,B.DPS_ACNO      AS ���ݰ��¹�ȣ
            ,B.OWNR_CUST_NO  AS �����ְ���ȣ
            ,A.DBR_CUST_NO   AS ���ְ���ȣ
            ,A.STUP_STCD     AS �㺸���������ڵ�
            ,A.STUP_DT       AS ���Ǽ�������
            ,CASE WHEN A.STUP_STCD ='04' THEN A.LST_CHG_DT ELSE NULL END AS ������������
            ,NVL(C.MBTL_NO_CHG_YN,'N') �޴���ȭ��ȣ���濩��
            ,C.MBTL_NO_CHG_DTTM
            ,NVL(C.RCV_DEN_YN,'N') ��ȭ��ȭ�źε�Ͽ���
            ,C.RCV_DEN_ENR_DTTM
            ,C.ENR_USR_NO

    FROM     TB_SOR_CLM_STUP_BC A         -- SOR_CLM_�����⺻

    JOIN     TB_SOR_CLM_TBK_PRD_MRT_BC B  -- SOR_CLM_�����ǰ�㺸�⺻
             ON   A.MRT_NO    = B.MRT_NO
             AND  B.MRT_CD IN ( '401','402','403','404','405','406',
                                '410','411','412','413','414','415',
                                '427','429','430','431','432','433',
                                '434','435','436','437','438','439',
                                '440','441','442')
    JOIN     (
              SELECT   CUST_NO                      AS ����ȣ
                      ,TO_CHAR(ENR_DTTM,'YYYYMMDD') AS �������Ͻ�
                      ,ENR_USR_NO
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0001' THEN 'Y' ELSE NULL END  MBTL_NO_CHG_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0001' THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS MBTL_NO_CHG_DTTM
                      ,CASE WHEN A.CUST_INF_CHG_DSCD IN ('0039') THEN 'Y' ELSE NULL END  RCV_DEN_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD IN ('0039') THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS RCV_DEN_ENR_DTTM
                      ,ROW_NUMBER() OVER (PARTITION BY CUST_NO ORDER BY ENR_DTTM DESC) AS ����
              FROM     TB_SOR_CUS_CHG_TR A   --�����������̷�
              WHERE    1 = 1
              AND      (
                        (A.CUST_INF_CHG_DSCD = '0001' AND A.CHNL_TPCD LIKE 'E%' AND A.CHB_DAT_CTS != '   ' ) OR  --�޴���ȭ��ȣ
                        (A.CUST_INF_CHG_DSCD = '0039' AND A.CHA_DAT_CTS NOT IN ('  ','00  ')  )                  --��ȭ���Űź������ڵ�
                       )
              AND      TO_CHAR(A.ENR_DTTM,'YYYYMMDD') BETWEEN P_SOTM_DT AND P_EOTM_DT
             ) C
             ON   B.OWNR_CUST_NO = C.����ȣ
             AND  C.���� = 1

    JOIN     TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_���⺻
             ON   A.STUP_RGT_BRNO  =  J1.BRNO

    WHERE    1=1
    AND      A.STUP_STCD IN ('02','03','04')
    AND      A.LST_CHG_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT













-- ����������-08 : ���� ���� ���� �� ���� �� �� �ֱ� 1������ ������ ����Ǽ�
