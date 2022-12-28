/*
  ���α׷��� : ins_TB_OPE_KRI_��ȯ������03
  Ÿ�����̺� : TB_OPE_KRI_��ȯ������03
  KRI ��ǥ�� : ��ȿ���� ��� ����(����)�ſ��� ���� ��
  ��      �� : ��ȣ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��ȯ������-03 ��ȿ���� ��� ����(����)�ſ��� ���� ��
       A: ������ ���� ������/���� �������� ����(����)�ſ��� ���� �� �ϰ������ ���� ���� �� ��ȿ���� 1���� ����� ���� ��
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

    DELETE OPEOWN.TB_OPE_KRI_��ȯ������03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��ȯ������03
    SELECT   P_BASEDAY
            ,B.ADM_SLS_BRNO
            ,J.BR_NM
            ,B.REF_NO
            ,A.CRCD
            ,A.OPN_AMT
            ,A.OPN_DT
            ,A.AVL_DT
    FROM     TB_SOR_FEC_FRXC_BC        B  -- SOR_FEC_��ȯ�⺻

    JOIN     TB_SOR_IMP_IMP_OPN_BC     A  -- SOR_IMP_���԰����⺻
             ON  B.REF_NO = A.REF_NO
             AND A.AVL_DT <= TO_CHAR(ADD_MONTHS( TO_DATE(P_BASEDAY,'YYYYMMDD') , -1),'YYYYMMDD')

    JOIN     TB_SOR_CUS_MAS_BC         L  -- SOR_CUS_���⺻
             ON   B.CUST_NO = L.CUST_NO

    JOIN     TB_SOR_CMI_BR_BC        J    -- SOR_CMI_���⺻
             ON   B.ADM_SLS_BRNO = J.BRNO

    WHERE    1=1
    AND      B.FRXC_LDGR_STCD = '1'  /* ��ȯ��������ڵ� 1���� */
    AND      B.SBCD IN ('504','505')
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��ȯ������03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

