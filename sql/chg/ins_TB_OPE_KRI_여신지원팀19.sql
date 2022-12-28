/*
  ���α׷��� : ins_TB_OPE_KRI_����������19
  Ÿ�����̺� : TB_OPE_KRI_����������19
  KRI ��ǥ�� : ������ ���� �� ���ݴ㺸���� ��� �Ǽ�
  ��      �� : ���񼱰���
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-19 ������ ���� �� ���ݴ㺸���� ��� �Ǽ�
       A: ���� �� ���ݴ㺸���� 1õ���� �̻� ��ް� �� 7������ �̳��� �ڵ�����ȣ ������ �־��� �Ǽ�
       B: ���� �� ���ݴ㺸���� 1õ���� �̻� ��ް� �� 7������ �̳��� ��ȭ���Űź� ����� �־��� ��
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

    DELETE OPEOWN.TB_OPE_KRI_����������19
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������19

    SELECT   P_BASEDAY
            ,A.STUP_RGT_BRNO AS ����ȣ
            ,J1.BR_NM        AS ����
            ,A.MRT_NO        AS �㺸��ȣ
            ,A.MRT_TPCD      AS �㺸�����ڵ�
            ,B.MRT_CD        AS �㺸������
            ,D.PDCD          AS ��ǰ�ڵ�
            ,B.DPS_ACNO      AS ���ݰ��¹�ȣ
            ,C.ACN_DCMT_NO   AS ������¹�ȣ
            ,B.OWNR_CUST_NO  AS �����ְ���ȣ
            ,A.DBR_CUST_NO   AS ���ְ���ȣ
            ,A.STUP_STCD     AS �㺸���������ڵ�
            ,A.STUP_DT       AS ���Ǽ�������
            ,CASE WHEN A.STUP_STCD ='04' THEN A.LST_CHG_DT ELSE NULL END ������������
            ,NVL(E.MBTL_NO_CHG_YN,'N')  �޴���ȭ��ȣ���濩��
            ,DECODE(E.MBTL_NO_CHG_YN,'Y',�������Ͻ�,NULL)  �޴���ȭ��ȣ�������Ͻ�
            ,NVL(E.RCV_DEN_YN,'N') ��ȭ��ȭ�źε�Ͽ���
            ,DECODE(E.RCV_DEN_YN,'Y',�������Ͻ�,NULL)  ��ȭ��ȭ�źκ������Ͻ�
            ,E.ENR_USR_NO  AS  ��ϻ���ڹ�ȣ

    FROM     TB_SOR_CLM_STUP_BC A         -- SOR_CLM_�����⺻

    JOIN     TB_SOR_CLM_TBK_PRD_MRT_BC B  -- SOR_CLM_�����ǰ�㺸�⺻
             ON   A.MRT_NO    = B.MRT_NO

    JOIN     TB_SOR_CLM_CLN_LNK_TR C      -- SOR_CLM_���ſ��᳻��
             ON   A.STUP_NO     = C.STUP_NO
             AND  C.CLN_LNK_STCD IN ('02','03','04')
             AND  C.ENR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT

    JOIN     TB_SOR_LOA_ACN_BC D          --  SOR_LOA_���±⺻
             ON   C.ACN_DCMT_NO = D.CLN_ACNO   -- ���Ű��¹�ȣ
             AND  D.PDCD IN ('20051100001001','20051100002001','20051100003011','20051100003021',
                             '20804100001001','20804100002001','20804100003011','20804100003021',
                             '20001100001001','20001100002001','20001100003011','20001100003021',
                             '20003100001001','20007100001001','20013100001001','20021100001001',
                             '20803100001001','20803100002001','20803100003011','20803100003021',
                             '20051101000001','20001101000001','20051001100001','20804000300001'
                            )    --��ǰ�ڵ�

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
                        (A.CUST_INF_CHG_DSCD = '0039' AND A.CHA_DAT_CTS NOT IN ('  ','00  ')  )                   --��ȭ���Űź������ڵ�
                       )
              AND      TO_CHAR(A.ENR_DTTM,'YYYYMMDD') BETWEEN P_SOTM_DT AND P_EOTM_DT
             ) E
             ON   B.OWNR_CUST_NO = E.����ȣ
             -- AND  E.���� = 1

    JOIN     TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_���⺻
             ON   A.STUP_RGT_BRNO  =  J1.BRNO

    JOIN     OM_DWA_DT_BC DD  -- DWA_���ڱ⺻
             ON   A.STUP_DT  =  DD.STD_DT

    WHERE    1=1
    AND      E.�������Ͻ� BETWEEN DD.D7_BF_SLS_DT AND A.STUP_DT  -- ���Ǽ�����(���������)�� ���� ����7�����ϻ��̿� �������������� ����
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������19',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
