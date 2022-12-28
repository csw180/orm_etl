/*
  ���α׷��� : ins_TB_OPE_KRI_��������������27
  Ÿ�����̺� : TB_OPE_KRI_��������������27
  KRI ��ǥ�� : 1�����̻� �������� ���ܿ��� �Ͻÿ����ݼ����� �Ǽ�
  ��      �� : ���Ͽ����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-27 :1�����̻� �������� ���ܿ��� �Ͻÿ����ݼ����� �Ǽ�
       A: ���ܿ��� �Ͻÿ����ݼ����� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������27
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������27
    SELECT   P_BASEDAY
            ,A.ASP_ADM_BRNO                    --���ܰ�������ȣ
            ,J.BR_NM
            ,A.ASP_ACNO                        --���ܰ��¹�ȣ
            ,A.ASP_TXIM_KDCD                   --�����ڵ�
            ,B.TR_RCFM_DT                      --�Ա�����
            ,C.MAX_TR_RCFM_DT                  --��������(������ �������϶��� �ֱٳ�¥)
            ,B.ENR_USR_NO                     --�����ڹ�ȣ

    FROM     TB_SOR_SDM_ASP_DP_BC A        -- SOR_SDM_���ܿ��ݱ⺻

    JOIN     TB_SOR_CMI_BR_BC   J       -- SOR_CMI_���⺻
             ON    A.ASP_ADM_BRNO  = J.BRNO

    JOIN     TB_SOR_SDM_ASP_DP_TR_TR B     -- SOR_SDM_���ܿ��ݰŷ�����
             ON    A.ASP_ACNO = B.ASP_ACNO
             AND   B.ASP_TR_KDCD = '1'     -- �Ա�
             AND   B.TR_STCD = '1'
             AND   TO_CHAR(ADD_MONTHS(TO_DATE(B.TR_RCFM_DT,'YYYYMMDD'), 1), 'YYYYMMDD')  <= P_BASEDAY
                -- �Աݵ��� 1������ ������

    LEFT OUTER JOIN
             (
               SELECT   ASP_ACNO, MAX(TR_RCFM_DT)  MAX_TR_RCFM_DT
               FROM     TB_SOR_SDM_ASP_DP_TR_TR  -- SOR_SDM_���ܿ��ݰŷ�����
               WHERE    1=1
               AND      ASP_TR_KDCD  = '2'   -- ����
               AND      TR_STCD = '1'
               GROUP BY ASP_ACNO
             )  C
             ON   A.ASP_ACNO = C.ASP_ACNO

    WHERE    1=1
    AND      A.ASP_TXIM_KDCD IN ('05','08','10','11','12','13','16','23','25','28')
    AND      A.ASP_DP_ACN_STCD = '1' -- ���ܿ��ݰ��»����ڵ�(1:����, 2:����, 3:������, 4: ����)
    AND      A.ASP_ACNO LIKE '1%'    -- ���ุ
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������27',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








