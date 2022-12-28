/*
  ���α׷��� : ins_TB_OPE_KRI_��������������19
  Ÿ�����̺� : TB_OPE_KRI_��������������19
  ��      �� : ��ȿ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������19 : ���Ѻο��� �ű� ��� �Ǽ�
       A: ���� ������ �߻� ���Ѻο��� �ű԰��� ���� �ű� ��� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������19
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������19
    SELECT   A.STD_DT
            ,A.ADM_BRNO
            ,J.BR_NM
            ,A.ACNO
            ,A.CUST_NO
            ,PD.PRD_KR_NM
            ,A.NW_DT
            ,C.TR_DT
            ,C.RCFM_DT
            ,C.TR_USR_NO

    FROM     OT_DWA_INTG_DPS_BC  A    -- DWA_���ռ��ű⺻

    JOIN     TB_SOR_CMI_BR_BC J       -- SOR_CMI_���⺻
             ON   A.ADM_BRNO = J.BRNO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC  PD   -- SOR_PDF_��ǰ�⺻
             ON   A.PDCD   = PD.PDCD
             AND  PD.APL_STCD  =  '10'

    LEFT OUTER JOIN
             TB_SOR_DEP_TR_TR  C    -- SOR_DEP_�ŷ�����
             ON   A.ACNO   =  C.ACNO
             AND  A.NW_DT  =  C.RCFM_DT
             AND  C.DPS_TSK_CD = '0101'
             AND  C.DPS_TR_STCD  =  '2'  -- ���Űŷ������ڵ�(2:����)

    WHERE    1=1
    AND      A.STD_DT  = P_BASEDAY
    AND      A.ACNO  <  '20000000000'   -- �����ǰ
    AND      A.DPS_DP_DSCD  IN  ('2','4')  -- ���Ѻο���(2:��ȭ���༺, 4:��ȭ���༺)
    AND      A.DPS_ACN_STCD  =  '98'     -- ���Ű��»����ڵ� 98:�ű�����
    AND      A.NW_DT  BETWEEN  P_SOTM_DT  AND  P_EOTM_DT

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������19',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


