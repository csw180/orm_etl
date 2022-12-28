/*
  ���α׷��� : ins_TB_OPE_KRI_��������������12
  Ÿ�����̺� : TB_OPE_KRI_��������������12
  KRI ��ǥ�� : �絵���������� ���� ��
  ��      �� : ��ȿ��
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������12 : �絵���������� ���� ��
       A: 1��� �̻��� �絵����������(�ǹ�)�� ���� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������12
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������12
    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,C.BR_NM
            ,A.CUST_NO
            ,A.ACNO
            ,'�ǹ�'         -- �絵��������������
            ,B.IMCW_NO      -- �絵������������ȣ
            ,A.PRPR_AMT     -- �絵����������_�׸�ݾ�
            ,A.LDGR_RMD     -- ����ݾ�
            ,A.NW_DT        -- �絵����������������
            ,D.TR_USR_NO    -- ������������ȣ

    FROM     OT_DWA_INTG_DPS_BC  A    -- DWA_���ռ��ű⺻

    JOIN     TB_SOR_DEP_DPAC_BC  B    -- SOR_DEP_���Ű��±⺻
             ON   A.ACNO  =   B.ACNO

    JOIN     TB_SOR_CMI_BR_BC C      -- SOR_CMI_���⺻
             ON   A.ADM_BRNO = C.BRNO

    LEFT OUTER JOIN
             TB_SOR_DEP_TR_TR  D    -- SOR_DEP_�ŷ�����
             ON   A.ACNO   =  D.ACNO
             AND  A.NW_DT  =  D.RCFM_DT
             AND  D.DPS_TSK_CD = '0101'  -- '0101':�ű�
             AND  D.DPS_TR_STCD  =  '1'

    WHERE    1=1
    AND      A.STD_DT  = P_BASEDAY
    AND      A.PDCD = '10121002800011' -- �絵����������(�ǹ�����)
    AND      A.DPS_ACN_STCD  =  '01'   -- ���Ű��»����ڵ� (01:Ȱ��)
    AND      A.NW_DT  BETWEEN  P_SOTM_DT  AND  P_EOTM_DT
    AND      A.PRPR_AMT  >= 100000000
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������12',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


