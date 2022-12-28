/*
  ���α׷��� : ins_TB_OPE_KRI_��������������33
  Ÿ�����̺� : TB_OPE_KRI_��������������33
  KRI ��ǥ�� : Ÿ���� ��ȯ������ ���ްǼ�
  ��      �� : �̴�ȣ����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��������������-33 Ÿ���� ��ȯ������ ���ްǼ�
       A: Ÿ���� ��ȯ������ ���� ���� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��������������33
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��������������33
    SELECT   P_BASEDAY
            ,B.TR_BRNO
            ,C.BR_NM
            ,A.ACNO
            ,B.TR_DT
            ,B.TR_USR_NO

    FROM     TB_SOR_DEP_DPAC_BC A  -- SOR_DEP_���Ű��±⺻

    JOIN     TB_SOR_DEP_TR_TR B   -- SOR_DEP_�ŷ�����
             ON  A.ACNO = B.ACNO
             AND  B.TR_DT BETWEEN  P_SOTM_DT AND P_EOTM_DT
             AND  B.CHNL_TPCD = 'TTML'
             AND  B.DPS_TSK_CD = '0301'  -- ���ž����ڵ�( '0301':���� )
             AND  B.DPS_TSK_DTL_CD = '162'
             AND  B.DPS_TR_STCD = '1'

    JOIN     TB_SOR_CMI_BR_BC C    -- SOR_CMI_���⺻
             ON   B.TR_BRNO = C.BRNO
             AND  C.BR_DSCD  = '1'
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��������������33',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
