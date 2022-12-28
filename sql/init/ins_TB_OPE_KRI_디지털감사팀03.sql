/*
  ���α׷��� : ins_TB_OPE_KRI_�����а�����03
  Ÿ�����̺� : TB_OPE_KRI_�����а�����03
  KRI ��ǥ�� : ������/�����ޱ� ������ �Ǽ�
  ��      �� : �ھƶ�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �����а�����-03 ������/�����ޱ� ������ �Ǽ�
       A: ������ ���� �������ݾ� �߻����ڷ� ���� 3���� �̻� �������� ������/�����ޱ� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�����а�����03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�����а�����03

    SELECT   P_BASEDAY
            ,A.ADM_BRNO   -- ����ȣ
            ,C.BR_NM
            ,A.OCC_DT     -- �߻�����
            ,A.OCC_AMT    -- �߻��ݾ�
            ,A.NARN_RMD   -- �������ܾ�
            ,A.ARN_DT     -- ��������

    FROM     DWZOWN.TB_SOR_APW_TMAC_TR_BC   A -- SOR_APW_�������ŷ��⺻
    
    JOIN     DWZOWN.TB_SOR_CMI_BR_BC  C  -- SOR_CMI_���⺻
             ON  A.ADM_BRNO = C.BRNO
             AND C.BR_DSCD = '1'   -- 1.�߾�ȸ, 2.����

    WHERE    1=1
    AND      A.JONT_CD = '11'
    AND      TO_CHAR(ADD_MONTHS(TO_DATE(A.OCC_DT,'YYYYMMDD'),3),'YYYYMMDD') BETWEEN  P_SOTM_DT  AND P_EOTM_DT 
    AND      (
                ( TO_CHAR(ADD_MONTHS(TO_DATE(A.OCC_DT,'YYYYMMDD'),3),'YYYYMMDD') < A.ARN_DT )  OR
                ( A.ARN_DT IS NULL AND TO_CHAR(ADD_MONTHS(TO_DATE(A.OCC_DT,'YYYYMMDD'),3),'YYYYMMDD') < P_BASEDAY )
             )
    ;
    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�����а�����03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT



