/*
  ���α׷��� : ins_TB_OPE_KRI_��������������14
  Ÿ�����̺� : TB_OPE_KRI_��������������14
  KRI ��ǥ�� : ��ȣ���� ���� ����� ����
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-14 ��ȣ���� ���� ����� ����
       A: ���� �� ���� ��ȣ���� �Ⱓ �������� 1�� ����� �Ǽ�
       B: ���� �� ���� ��ȣ���� Ȱ���°Ǽ�<��ȣ���� ������ �Ǽ�>
     - ��������������-15 ��ȣ���� ���� ����� �Ǽ�
       A: ���� �� ���� ��ȣ���� �Ⱓ �������� 1�� ����� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������14
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������14
    SELECT    P_BASEDAY
             ,A.BRNO
             ,J.BR_NM
             ,A.BRNO||A.SFDP_YY||LPAD(A.SFDP_SNO,10,'0')   -- ��ȣ���������Ϸù�ȣ
             ,A.SFDP_PRD_NM     -- ��ȣ��������
             ,A.DNC_AMT         -- ��ȣ�����ݾ�
             ,A.NW_DT           -- ��ȣ������������
             ,A.EXPI_DT         -- ��ȣ������������
             ,TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(A.EXPI_DT,'YYYYMMDD')    -- �������ϼ�
             ,SUBSTR(A.LAST_CHNG_MN_USID,1,10)    -- �����ڻ���ڹ�ȣ
             
    FROM      TB_SOR_PTD_SFDP_BC   A   -- SOR_PTD_��ȣ�����⺻
    
    JOIN      TB_SOR_CMI_BR_BC     J   -- SOR_CMI_���⺻
              ON   A.BRNO      =   J.BRNO
              AND  J.BR_DSCD   =  '1'
              
    WHERE     1=1
    AND       ( A.CNCL_DT IS NULL OR CNCL_DT > P_BASEDAY )
    AND       ( (A.SFDP_STCD  = '1' AND A.RSTR_DT IS NULL ) OR ( A.RSTR_DT > P_BASEDAY ) )
    -- ��ȣ���������ڵ� 1(�űԻ���) OR ��ȯ���ڰ� ���ų� �̷���¥�ΰ�
    -- ��ȣ���������ڵ�(SFDP_STCD) 1:�ű�,2:��ȯ,3:�ű����
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������14',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








