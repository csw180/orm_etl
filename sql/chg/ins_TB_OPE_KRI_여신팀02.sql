/*
  ���α׷��� : ins_TB_OPE_KRI_������02
  Ÿ�����̺� : TB_OPE_KRI_������02
  KRI ��ǥ�� : �̻�� ������� ������
  ��      �� : ��õ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
   - ������-02 �̻�� ������� ������
     A: ���� �̻�� ������� ��
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

    DELETE OPEOWN.TB_OPE_KRI_������02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_������02
    SELECT      P_BASEDAY              AS ��������
               ,A.VACN_NO              AS ������¹�ȣ
               ,A.VACN_NO_US_CMPL_YN   AS ������¹�ȣ���ϷῩ��

    FROM        TB_SOR_LOA_VACN_ACN_INF_BC  A -- SOR_LOA_������°��������⺻

    WHERE       1 = 1
    AND         A.MO_ACNO      = '101011327368' -- ��������� ����°� ���� ������ �͸� (������ ���� ���¸� ����·� �Ѵ�.)
    AND         TO_CHAR(A.FST_ENR_DTTM,'YYYYMMDD') <=  P_BASEDAY     -- 1. �۾��������� ������ ���忡 ��ϵ� ������¸� ����
    AND        (
                  A.VACN_NO_US_CMPL_YN    = 'N'  OR      -- 2-1. ������� �̻���� ��
                  (     A.VACN_NO_US_CMPL_YN  = 'Y' 
                    AND A.APL_DT          >  P_BASEDAY
                  ) -- 2-2. ������ȸ���� ����, ��������� ���õ� ���̳� �۾��������ڰ� ������ں��� ���� ��
               )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_������02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
