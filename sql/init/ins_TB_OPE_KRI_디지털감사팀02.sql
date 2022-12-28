/*
  ���α׷��� : ins_TB_OPE_KRI_�����а�����02
  Ÿ�����̺� : TB_OPE_KRI_�����а�����02
  KRI ��ǥ�� : �������� ���� �Ǵ� ��ü ���ްǼ�
  ��      �� : �ھƶ�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �����а�����-02 �������� ���� �Ǵ� ��ü ���ްǼ�
       A: �������ްǼ�
       B: ��ü���ްǼ�
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

    DELETE OPEOWN.TB_OPE_KRI_�����а�����02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�����а�����02
    SELECT   P_BASEDAY
            ,A.ADM_BRNO   -- ����ȣ
            ,C.BR_NM
            --,A.TMAC_ACNO
            ,A.ACSB_CD
            ,A.OCC_DT     -- �߻�����
            ,A.NARN_RMD   -- �������ܾ�
            --,A.ARN_DT     -- ��������
            ,CASE WHEN B.RMDF_DSCD = '2' THEN B.CUR_AMT ELSE 0 END -- �������޾�
            ,CASE WHEN B.RMDF_DSCD = '2' THEN B.ALT_AMT ELSE 0 END -- ��ü���޾�

    FROM     DWZOWN.TB_SOR_APW_TMAC_TR_BC   A -- SOR_APW_�������ŷ��⺻

    JOIN     DWZOWN.TB_SOR_APW_TMAC_TR_TR   B -- SOR_APW_�������ŷ�����
             ON  A.TMAC_ACNO =   B.TMAC_ACNO

    JOIN     DWZOWN.TB_SOR_CMI_BR_BC  C  -- SOR_CMI_���⺻
             ON  A.ADM_BRNO = C.BRNO
             AND C.BR_DSCD = '1'   -- 1.�߾�ȸ, 2.����

    WHERE    1=1
    AND      A.ACSB_CD = '26008711'  -- ��Ÿ������
    AND      A.OCC_DT   BETWEEN  P_SOTM_DT AND P_EOTM_DT

    ;
    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�����а�����02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
