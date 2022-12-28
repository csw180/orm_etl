/*
  ���α׷��� : ins_TB_OPE_KRI_����������20
  Ÿ�����̺� : TB_OPE_KRI_����������20
  KRI ��ǥ�� : ������ ���� �� �ſ���� ��û �Ǽ�
  ��      �� : �̻��/��õ��
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-20 ������ ���� �� �ſ���� ��û �Ǽ�
       A: ���� ���� 20�鸸�� �̻� �ſ���� ��û �� �� ���� �޴���ȭ��ȣ ������ �־��� �Ǽ�
       B: ���� ���� 20�鸸�� �̻� �ſ���� ��û �� �� ���� ��ȭ �� ���ڼ��Űź� ����� �־��� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_����������20
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������20
    SELECT    P_BASEDAY
             ,A.ADM_BRNO                AS   ����ȣ
             ,J1.BR_NM                  AS   ����
             ,A.CHNL_TPCD               AS   ä�������ڵ�
             ,A.CUST_NO                 AS   ����ȣ
             ,A.CLN_ACNO                AS   ���¹�ȣ
             ,PD.PRD_KR_NM              AS   ��ǰ��
             ,'KRW'                     AS   ��ȭ�ڵ�
             ,A.CLN_APC_AMT             AS   ���Ž�û�ݾ�
             ,A.APC_DT                  AS   ���Ž�û��
             ,DECODE(C.������1,NULL,'N','Y')  AS �޴���ȭ��ȣ���濩��
             ,C.������1                 AS   �޴���ȭ��������
             ,CASE WHEN C.������2 IS NOT NULL OR C.������3 IS NOT NULL THEN  'Y'
                   ELSE 'N'
              END                       AS  ��ȭ���ڼ��Űźο���
             ,CASE WHEN C.������2 IS NULL THEN
                   CASE WHEN C.������3 IS NULL THEN  NULL
                        ELSE C.������3
                   END
                   ELSE C.��������2
              END                       AS  �źε����
    FROM      TB_SOR_PLI_INET_TR A          -- SOR_PLI_���ͳݴ��⳻��
    JOIN      TB_SOR_PLI_APC_POT_CUST_TR B  -- SOR_PLI_��û����������
              ON   A.CLN_APC_NO  =  B.CLN_APC_NO
              AND  A.CUST_NO     =  B.CUST_NO
    JOIN      (
                SELECT   CUST_NO
                        ,�޴���ȭ������           AS ������1
                        ,���ڼ��ź�����           AS ������2
                        ,���ڼ��ź�������       AS ��������2
                        ,��ȭ���ź�����           AS ������3
                FROM     (
                            -- �޴���ȭ��ȣ����
                            -- ���Ⱓ�ȿ� �Ѱ��� �޴���ȭ��ȣ ������ ������ �Ͼ� ������ �ִ�.
                            SELECT   CUST_NO
                                    ,TO_CHAR(ENR_DTTM,'YYYYMMDD')  AS �޴���ȭ������
                                    ,NULL                          AS ���ڼ��ź�����
                                    ,NULL                          AS ���ڼ��ź�������
                                    ,NULL                          AS ��ȭ���ź�����
                            from     TB_SOR_CUS_CHG_TR A    --SOR_CUS_�����泻��
                            WHERE    1=1
                            AND      TO_CHAR(ENR_DTTM , 'YYYYMMDD')   BETWEEN  P_SOTM_DT AND   P_EOTM_DT
                            AND      CUST_INF_CHG_DSCD = '0001'     -- �޴�����ȣ����
                            AND      CHNL_TPCD IN ('EIRB' , 'ERIB' , 'ESRB' , 'ESRM' )
                            AND      TRIM(CHB_DAT_CTS) IS NOT NULL  -- �������� ���� ���� ����� ����ϼ� �־..

                            UNION ALL

                            select   CUST_NO
                                    ,NULL                           AS �޴���ȭ������
                                    ,TO_CHAR(CHG_DTTM , 'YYYYMMDD') AS ���ڼ��ź�����
                                    ,TO_CHAR(ENR_DTTM , 'YYYYMMDD') AS ���ڼ��ź�������
                                    ,NULL                           AS ��ȭ���ź�����
                            FROM     TB_SOR_CUS_CTN_INF_DL A    --SOR_CUS_����������
                            WHERE    1=1
                            AND      TO_CHAR(CHG_DTTM,'YYYYMMDD') BETWEEN  P_SOTM_DT AND   P_EOTM_DT
                            AND      CUST_CTN_INF_CD = '15'     --   �����������ڵ� (15:SMS���Űź�)
                            AND      SUBSTR(CHG_USR_NO ,1,4) IN ('EIRB' , 'ERIB' , 'ESRB' , 'ESRM' )

                            UNION ALL

                            SELECT   CUST_NO
                                    ,NULL                           AS  �޴���ȭ������
                                    ,NULL                           AS  ���ڼ��ź�����
                                    ,NULL                           AS  ���ڼ��ź�������
                                    ,ENR_DT                         AS  ��ȭ���ź�����
                            FROM    TB_SOR_CUS_DONC_CUST_BC A      -- SOR_CUS_�γ��ݰ��⺻
                            WHERE   1=1
                            AND     ENR_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT
                            AND     DONC_STCD = '1'
                         )  A
              )   C
              ON  A.CUST_NO  = C.CUST_NO
              AND (
                      A.APC_DT   = C.������1  OR
                      A.APC_DT   = C.������2  OR
                      A.APC_DT   = C.������3
                  )

    JOIN     TB_SOR_CMI_BR_BC     J1   -- SOR_CMI_���⺻
             ON     A.ADM_BRNO  =  J1.BRNO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD   -- SOR_PDF_��ǰ�⺻
             ON     A.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE     1=1
    AND       A.APC_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND       A.INET_CLN_APC_PGRS_STCD = '41'  -- 41:�������Ϸ�
    AND       A.CLN_APC_AMT > '20000000';

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������20',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
