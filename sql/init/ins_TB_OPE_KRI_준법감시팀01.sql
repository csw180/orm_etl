/*
  ���α׷��� : ins_TB_OPE_KRI_�ع�������01
  Ÿ�����̺� : TB_OPE_KRI_�ع�������01
  ��      �� : ��ȿ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ع�������01 : �������� ���� ���¼�
       A: �ش���� ����ڹ�ȣ�� ������ �䱸�ҽ� Ȱ������ ��
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

    DELETE OPEOWN.TB_OPE_KRI_�ع�������01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ع�������01

    SELECT   B.STD_DT
            ,A.BRNO
            ,A.BR_NM
            ,B.ACNO
            ,B.DPS_DP_DSCD
            ,B.NW_DT
            ,B.LDGR_RMD
    FROM     (
              SELECT   S2.BRNO
                      ,S2.BR_NM
                      ,S2.BRN
              FROM     (
                          SELECT   DISTINCT  DECODE(BR_STCD,'02',INTG_BRNO,BRNO)  BR_NO
                          FROM     OT_DWA_DD_BR_BC  -- DWA_�����⺻
                          WHERE    STD_DT  = P_BASEDAY
                          AND      BR_DSCD = '1'  -- ����
                          AND      BR_KDCD = '20'   -- ������(20:������)
                          AND      BR_STCD  IN  ('01','02')  -- �������ڵ� 01:���󿵾�, 02:����
                       )   S1
              JOIN     OT_DWA_DD_BR_BC  S2   -- DWA_�����⺻
                       ON   S1.BR_NO  =  S2.BRNO
                       AND  S2.STD_DT =  P_BASEDAY
             )  A
    JOIN     OT_DWA_INTG_DPS_BC  B    -- DWA_���ռ��ű⺻
             ON  A.BRN    =  B.CUST_RNNO
             AND A.BRNO   =  B.ADM_BRNO
             AND B.STD_DT =  P_BASEDAY
             AND B.DPS_DP_DSCD   =  '1'   --��ȭ�䱸��
             AND B.DPS_ACN_STCD  =  '01'  -- ���Ű��»����ڵ� 01:Ȱ��
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ع�������01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
