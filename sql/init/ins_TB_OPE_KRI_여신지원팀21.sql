/*
  ���α׷��� : ins_TB_OPE_KRI_����������21
  Ÿ�����̺� : TB_OPE_KRI_����������21
  KRI ��ǥ�� : SMS �� ��ȭ ���Űź� ��� ����
  ��      �� : ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-21 SMS �� ��ȭ ���Űź� ��� ����
       A: '��ȭ��ȭ�ź�' ��� ����
       B: 'SMS���Űź�' ��� �Ұ���
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

    DELETE OPEOWN.TB_OPE_KRI_����������21
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������21

    SELECT   A.STD_DT                                                 AS ��������
            ,A.BRNO                                                   AS ����ȣ
            ,A.BR_NM                                                  AS ����
            ,A.CUST_NO                                                AS ����ȣ
            ,E.CUST_INF_CHG_SNO                                       AS �����������Ϸù�ȣ
            ,A.INTG_ACNO                                              AS ���¹�ȣ
            ,A.PDCD                                                   AS ��ǰ�ڵ�
            ,A.PRD_KR_NM                                              AS ��ǰ��
            ,A.CRCD                                                   AS ��ȭ�ڵ�
            ,A.SUM_LN_RMD                                             AS �����ܾ�
            ,NVL(E.TL_RCV_DEN_YN,'N')                                 AS ��ȭ��ȭ�źο���
            ,E.TL_RCV_ENR_DT                                          AS ��ȭ��ȭ�źε���Ͻ�
            ,NVL(E.SMS_RCV_DEN_YN,'N')                                AS SMS���Űźο���
            ,E.SMS_RCV_ENR_DT                                         AS SMS���Űźε���Ͻ�
            ,E.ENR_USR_NO                                             AS ��ϻ���ڹ�ȣ
    FROM     (
              SELECT   /*+ FULL(A) FULL(AA) FULL(A_1) FULL(B) FULL(B_1) FULL(C) */
                       A.STD_DT
                      ,A.CUST_NO
                      ,A.INTG_ACNO
                      ,B_1.BRNO
                      ,TRIM(B_1.BR_NM)        AS BR_NM
                      ,A.PDCD
                      ,TRIM(A_1.PRD_KR_NM)    AS PRD_KR_NM
                      ,A.CRCD
                      ,SUM(A.LN_RMD)          AS SUM_LN_RMD

              FROM     OT_DWA_INTG_CLN_BC     A   -- DWA_���տ��ű⺻

              JOIN     TB_SOR_LOA_ACN_BC      AA  -- SOR_LOA_���±⺻
                       ON     A.INTG_ACNO            = AA.CLN_ACNO
                       AND    AA.CLN_ACN_STCD      <> '3'

              LEFT OUTER JOIN
                       OT_DWA_CLN_PRD_STRC_BC A_1 -- DWA_���Ż�ǰ�����⺻
                       ON     A.PDCD           = A_1.PDCD
                       AND    A.STD_DT         = A_1.STD_DT

              JOIN     OT_DWA_DD_BR_BC        B  -- DWA_�����⺻
                       ON     A.BRNO           = B.BRNO
                       AND    A.STD_DT         = B.STD_DT
                       AND    B.BR_DSCD        = '1'
                       AND    B.FSC_DSCD       = '1'         -- ����
                       AND    B.BR_KDCD        < '40'        -- 10:���κμ�, 20:������, 30:������

              JOIN     OT_DWA_DD_BR_BC        B_1  -- DWA_�����⺻
                       ON     B.LST_MVN_BRNO   = B_1.BRNO
                       AND    B.STD_DT         = B_1.STD_DT
                       AND    B_1.BR_DSCD      = '1'
                       AND    B_1.FSC_DSCD     = '1'         -- ����
                       AND    B_1.BR_KDCD      < '40'        -- 10:���κμ�, 20:������, 30:������

              JOIN     OT_DWA_DD_ACSB_TR      C  -- DWA_�ϰ������񳻿�
                       ON     A.BS_ACSB_CD     = C.ACSB_CD
                       AND    A.STD_DT         = C.STD_DT
                       AND    C.FSC_SNCD      IN ('K','C')
                       AND    C.ACSB_CD3       = '12000401' -- ����ä��

              WHERE    A.STD_DT = P_BASEDAY
              AND      A.BR_DSCD      = '1'
              AND      A.CLN_ACN_STCD <> '3'
              GROUP BY A.STD_DT
                      ,A.CUST_NO
                      ,A.INTG_ACNO
                      ,B_1.BRNO
                      ,TRIM(B_1.BR_NM)
                      ,A.CUST_NO
                      ,A.PDCD
                      ,TRIM(A_1.PRD_KR_NM)
                      ,A.CRCD
             )   A
    JOIN     (
              SELECT   /*+ FULL(A) */
                       CUST_NO
                      ,CUST_INF_CHG_SNO
                      ,TO_CHAR(ENR_DTTM,'YYYYMMDD') ENR_DT
                      ,ENR_USR_NO
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0039' THEN 'Y' ELSE NULL END  TL_RCV_DEN_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0039' THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS TL_RCV_ENR_DT
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0040' THEN 'Y' ELSE NULL END  SMS_RCV_DEN_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0040' THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS SMS_RCV_ENR_DT
              FROM     TB_SOR_CUS_CHG_TR A   --�����������̷�
              WHERE    1 = 1
              AND      (
                        (A.CUST_INF_CHG_DSCD = '0039' AND A.CHA_DAT_CTS NOT IN ('  ','00  ')  )    OR  --��ȭ���Űź������ڵ�
                        (A.CUST_INF_CHG_DSCD = '0040' AND A.CHA_DAT_CTS = 'Y  ' )                      --SMS���Űźο���(������ָ�ȵ�)
                       )
              AND      TO_CHAR(A.ENR_DTTM,'YYYYMMDD') BETWEEN P_SOTM_DT AND P_EOTM_DT
             ) E
             ON   A.CUST_NO = E.CUST_NO
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������21',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


