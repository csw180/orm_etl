/*
  ���α׷��� : ins_TB_OPE_KRI_��������������20
  Ÿ�����̺� : TB_OPE_KRI_��������������20
  ��      �� : ��ȿ������
  �����ۼ��� : �ֻ��  
  KRI ��ǥ�� :
     - ��������������20 : ��׿��� �����ŷ� �Ǽ�
       A: ���� �߻��� ��ȭ ���⼺���� 50�鸸�� �̻� �ű� �Ա�����/��Ұŷ� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������20
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������20

    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.ACNO
            ,A.CUST_NO
            ,PD.PRD_KR_NM
            ,A.DPS_ACN_STCD
--            ,A.NW_DT
            ,A.LST_TR_DT
            ,A.LDGR_RMD

    FROM     OT_DWA_INTG_DPS_BC  A    -- DWA_���ռ��ű⺻

    JOIN     TB_SOR_CMI_BR_BC J       -- SOR_CMI_���⺻
             ON   A.ADM_BRNO = J.BRNO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC  PD   -- SOR_PDF_��ǰ�⺻
             ON   A.PDCD   = PD.PDCD
             AND  PD.APL_STCD  =  '10'

    WHERE    1=1
    AND      A.STD_DT  = P_BASEDAY
    AND      A.SBCD  =   '120'                -- ��ȭ���⿹��
    AND      A.LDGR_RMD  >= 50000000          -- 50�鸸���̻�
    AND      A.DPS_ACN_STCD  IN   ('98','99') -- ���Ű��»����ڵ� 98:�ű�����,99:�ű����
    AND      A.LST_TR_DT BETWEEN P_SOTM_DT  AND  P_EOTM_DT
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������20',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


