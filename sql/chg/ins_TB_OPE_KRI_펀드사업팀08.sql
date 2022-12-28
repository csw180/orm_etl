/*
  ���α׷��� : ins_TB_OPE_KRI_�ݵ�����08
  Ÿ�����̺� : TB_OPE_KRI_�ݵ�����08
  KRI ��ǥ�� : �ݵ� ���ܿ��� ������ �ܾ� ���� �Ǽ�
  ��      �� : ���Ͽ�
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ݵ�����-08: �ݵ� ���ܿ��� ������ �ܾ� ���� �Ǽ�
       A: ������ �� �ݵ庰�ܰ���[��Ź�Ǹ��������Ǽ�����]�� �Ա� �߻��� ���� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�ݵ�����08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ݵ�����08

    SELECT   P_BASEDAY                         --���س��
            ,A.ASP_ADM_BRNO                    --���ܰ�������ȣ
            ,J1.BR_NM
            ,A.ASP_ACNO                        --���ܰ��¹�ȣ
            ,A.ASP_TXIM_KDCD                   --�����ڵ�
            ,A.ASP_DFRY_PSB_RMD                --�������ް����ܾ�
            ,B.TR_RCFM_DT ROM_DT               --�Ա�����
            ,B.ENR_USR_NO                      --�����ڹ�ȣ

    FROM     TB_SOR_SDM_ASP_DP_BC A     -- SOR_SDM_���ܿ��ݱ⺻
    JOIN     TB_SOR_SDM_ASP_DP_TR_TR B  -- SOR_SDM_���ܿ��ݰŷ�����
             ON   A.ASP_ACNO    = B.ASP_ACNO
             AND  B.ASP_TR_KDCD = '1'     -- �Ա�
             AND  B.TR_STCD     = '1'
             AND  B.TR_RCFM_DT  BETWEEN P_SOTM_DT AND  P_EOTM_DT
    /*
    JOIN     TB_SOR_SDM_ASP_TXIM_BC  CD   -- SOR_SDM_���ܼ���⺻
             ON   A.ASP_TXIM_KDCD  = CD.ASP_TXIM_KDCD
    */
    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
             ON   A.ASP_ADM_BRNO  =  J1.BRNO
    WHERE    1=1
    AND      A.ASP_TXIM_KDCD = '28'  -- �ݵ�������ޱ�
    AND      A.ASP_DP_ACN_STCD = '1' -- �Ա�����
    AND      A.ASP_ACNO LIKE '1%'    -- ���ุ
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ݵ�����08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


