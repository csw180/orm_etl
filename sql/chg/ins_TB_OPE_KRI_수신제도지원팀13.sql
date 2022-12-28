/*
  ���α׷��� : ins_TB_OPE_KRI_��������������13
  Ÿ�����̺� : TB_OPE_KRI_��������������13
  KRI ��ǥ�� : �ű� �� 1���� �̳� ���� �ߵ����� �Ǽ�
  ��      �� : �̴�ȣ����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-13 �ű� �� 1���� �̳� ���� �ߵ����� �Ǽ�
       A: ���� �������� ���� �� �ű� �� 1���� �̳� �����Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������13
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������13
    SELECT   /*+ FULL(A) FULL(B) FULL(C) */
             P_BASEDAY
            ,C.BRNO
            ,C.BR_NM
            ,A.ACNO
            ,A.CUST_NO
            ,A.DPS_DP_DSCD
            ,A.NW_DT
            ,A.CNCN_DT
    FROM     TB_SOR_DEP_DPAC_BC A   -- SOR_DEP_���Ű��±⺻

    JOIN     TB_SOR_DEP_TR_TR B    -- SOR_DEP_�ŷ�����
             ON   A.ACNO = B.ACNO
             AND  B.TR_DT   BETWEEN  P_SOTM_DT AND P_EOTM_DT
             AND  B.CHNL_TPCD = 'TTML'
             AND  B.DPS_TSK_CD = '0401'   -- '0401':����
             AND  B.DPS_TR_STCD = '1'

    JOIN     TB_SOR_CMI_BR_BC C    -- SOR_CMI_���⺻
             ON   B.TR_BRNO = C.BRNO
             AND  C.BR_DSCD  = '1'

    WHERE    1=1
    AND      A.DPS_ACN_STCD = '33'
    AND      A.DPS_DP_DSCD = '2'
    AND      A.CNCN_DT <= TO_CHAR(ADD_MONTHS(TO_DATE(A.NW_DT,'YYYYMMDD'), 1), 'YYYYMMDD')
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������13',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT











--��������-13
