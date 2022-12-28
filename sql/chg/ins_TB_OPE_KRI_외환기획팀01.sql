/*
  ���α׷��� : ins_TB_OPE_KRI_��ȯ��ȹ��01
  Ÿ�����̺� : TB_OPE_KRI_��ȯ��ȹ��01
  KRI ��ǥ�� : �ܱ�ȯ ��� �̴�ȯ �Ǽ�
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��ȯ��ȹ��-01 �ܱ�ȯ ��� �̴�ȯ �Ǽ�
       A: ������ ���� ��� 2���� �̻� �̴ްǼ�
       B: ������ ���� Ÿ�� 2���� �̻� ������ �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��ȯ��ȹ��01

    SELECT   P_BASEDAY
            ,SUBSTR(RC.REF_NO,3,4) as "����ȣ"
            ,CM.BR_NM              as "����"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN RC.REF_NO   END as "��߼۱ݰ�����ȣ"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN RC.PCS_DT   END as "��߼۱�����"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN RC.CRCD     END as "��߼۱���ȭ�ڵ�"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN RC.DFRY_AMT END as "��߼۱ݾ�"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN TR.TLR_NO   END as "���������ȣ"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(RC.PCS_DT,'YYYYMMDD') END as "��߰���ϼ�"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN RC.REF_NO   END as "Ÿ�߼۱ݰ�����ȣ"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN RC.PCS_DT   END as "Ÿ�߼۱�����"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN RC.CRCD     END as "Ÿ�߼۱���ȭ�ڵ�"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN RC.DFRY_AMT END as "Ÿ�߼۱ݾ�"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN TR.TLR_NO   END as "Ÿ��������ȣ"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(RC.PCS_DT,'YYYYMMDD') end as "Ÿ�߰���ϼ�"

    FROM     TB_SOR_FEC_RCNC_PNG_TR  RC     -- SOR_FEC_���̴�ȯ����

    LEFT OUTER JOIN
             TB_SOR_FEC_FRXC_TR_TR   TR     -- SOR_FEC_��ȯ�ŷ�����
             ON   RC.REF_NO = TR.REF_NO
             AND  TR.TR_SNO = 1

    JOIN     TB_SOR_CMI_BR_BC        CM     --  SOR_CMI_���⺻
             ON   SUBSTR(RC.REF_NO,3,4)  =  CM.BRNO
             AND  CM.BR_DSCD = '1'         -- 1.�߾�ȸ, 2.����
             
    AND      RC.PCS_DT <= TO_CHAR(ADD_MONTHS(TO_DATE(P_BASEDAY,'YYYYMMDD'),-2), 'YYYYMMDD')
    AND      RC.DFRY_AMT <>  0
    AND      RC.FRNW_TSK_DSCD in ('OC','IC')   -- �ܽž��������ڵ�

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��ȯ��ȹ��01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

