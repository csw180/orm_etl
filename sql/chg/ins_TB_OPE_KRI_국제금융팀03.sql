/*
  ���α׷��� : ins_TB_OPE_KRI_����������03
  Ÿ�����̺� : TB_OPE_KRI_����������03
  KRI ��ǥ�� : ��ȭ �Ļ���ǰ ���԰ŷ� �ݾ�
  ��      �� : �ڹα԰���
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-03 ��ȭ �Ļ���ǰ ���԰ŷ� �ݾ�
       A: ������ ���� ���� �μ����� �����ϰ� �ִ� ��ȭ �Ļ���ǰ(����)�� ���� ���ŷ� �ݾ��հ�
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

    DELETE OPEOWN.TB_OPE_KRI_����������03
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������03

    SELECT   P_BASEDAY
            ,A.BRNO
            ,J1.BR_NM
            --,A.SUMMIT_TR_ID
            ,A.ITF_TR_DSCD   -- ��ǰ����
            ,A.PCSL_DSCD     -- �ŷ�����
            ,A.TR_DT         -- �ŷ�����
            ,A.PCH_AMT       -- �ŷ��ݾ�
            ,A.PCH_CRCD      -- ��ȭ�ڵ�
            ,A.USR_NO        -- ������ȣ
            
    FROM     TB_SOR_ITF_TRADE_MAST_BC A   -- SOR_ITF_���������ŷ��⺻

    JOIN     TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_���⺻
             ON   A.BRNO  =  J1.BRNO

    WHERE    1=1
    AND      A.ITF_TR_DSCD IN ('FXFWD','FXSWAP')
    AND      A.TR_DT BETWEEN P_SOTM_DT and P_EOTM_DT
    AND      A.ITF_CUST_DSCD IN ( '1','2')
    AND      A.ITF_PGRS_STCD = '2'
    AND      A.PCSL_DSCD = 'B'
    AND      A.FX_SWP_DSCD IN ( '0','2')
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������03',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT




