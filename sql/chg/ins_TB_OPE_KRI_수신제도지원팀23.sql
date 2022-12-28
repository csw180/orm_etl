/*
  ���α׷��� : ins_TB_OPE_KRI_��������������23
  Ÿ�����̺� : TB_OPE_KRI_��������������23
  KRI ��ǥ�� : ������ ���� �� ���� ������ �Ǽ�
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-23 ������ ���� �� ���� ������ �Ǽ�
       A: ���� ���� 3�鸸���̻� ��� �� �� ���� �޴���ȭ��ȣ ������ �־��� �Ǽ�
       B: ���� ���� 3�鸸���̻� ��� �� �� ���� ��ȭ �� ���� ���Űźε���� �־��� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������23
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������23
    SELECT   /*+ FULL(B) FULL(C) FULL(PD)   */
             P_BASEDAY
            ,C.TR_BRNO
            ,D.BR_NM
            ,A.CHNL_TPCD
            ,A.CUST_NO
            ,B.ACNO
            ,PD.PRD_KR_NM
            ,C.CRCD
            ,C.TR_AMT
            ,C.TR_DT
            ,A.MBTL_NO_CHG_YN
            ,A.MBTL_NO_CHG_DTTM
            ,A.RCV_DEN_YN
            ,A.RCV_DEN_ENR_DTTM
            ,C.TR_USR_NO 
    FROM
             (
              SELECT   /*+ FULL(A)  */
                       A.CUST_NO
                      ,A.CHNL_TPCD
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0001' THEN 'Y' ELSE NULL END  MBTL_NO_CHG_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0001' THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS MBTL_NO_CHG_DTTM
                      ,CASE WHEN A.CUST_INF_CHG_DSCD IN ('0039','0040') THEN 'Y' ELSE NULL END  RCV_DEN_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD IN ('0039','0040') THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS RCV_DEN_ENR_DTTM
                      ,TO_CHAR(A.ENR_DTTM,'YYYYMMDD') AS ENR_DT
                      ,A.ENR_USR_NO
              FROM     TB_SOR_CUS_CHG_TR A    --SOR_CUS_�����泻��
              WHERE    1=1
              AND      TO_CHAR(A.ENR_DTTM , 'YYYYMMDD')   BETWEEN  P_SOTM_DT AND   P_EOTM_DT
              AND      (
                         ( A.CHNL_TPCD LIKE 'E%' AND A.CUST_INF_CHG_DSCD = '0001' AND A.CHB_DAT_CTS != '   ' )  OR  -- �޴�����ȣ����
                         ( A.CUST_INF_CHG_DSCD = '0039' AND A.CHB_DAT_CTS NOT IN ('  ','00  ') )  OR  -- ��ȭ���Űź������ڵ�
                         ( A.CUST_INF_CHG_DSCD = '0040' AND A.CHB_DAT_CTS  =  'Y' )                   -- SMS���Űźο���
                       )
             )  A

    JOIN     TB_SOR_DEP_DPAC_BC   B    -- SOR_DEP_���Ű��±⺻
             ON  A.CUST_NO   =  B.CUST_NO
             AND B.ACNO  LIKE  '1%'
             AND B.DPS_DP_DSCD  =  '1'

    JOIN     TB_SOR_DEP_TR_TR     C    -- SOR_DEP_�ŷ�����
             ON  B.ACNO      =  C.ACNO
             AND A.ENR_DT    =  C.TR_DT
             AND C.DPS_TR_STCD  =  '1'  -- ���Űŷ������ڵ�(1:����)
             AND C.RMDF_DSCD    =  '2'  -- �Ա����ޱ����ڵ�(1:�Ա�, 2:����, 3:�����ű�)
             AND C.TR_AMT  >= 3000000

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD   -- SOR_PDF_��ǰ�⺻
             ON     B.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    JOIN     TB_SOR_CMI_BR_BC D    -- SOR_CMI_���⺻
             ON   C.TR_BRNO = D.BRNO
             AND  D.BR_DSCD  = '1'

    WHERE    1=1
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������23',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

