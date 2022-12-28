/*
  ���α׷��� : ins_TB_OPE_KRI_�Һ��ں�ȣ��01
  Ÿ�����̺� : TB_OPE_KRI_�Һ��ں�ȣ��01
  KRI ��ǥ�� : ������ű������ ����̿���� �������� �����Ǽ�
  ��      �� : ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ������ű������ ����̿���� ���� �������� �Ǽ�
       A: ������ ������ű������ ���ر� ȯ�� ���� ������ ��������(��,Ÿ��)��
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

    DELETE OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�Һ��ں�ȣ��01

    SELECT   /*+ FULL(A) FULL(B) FULL(J1) FULL(J2)  */
             P_BASEDAY
            ,A.ENR_BRNO  �������ȣ
            ,J2.BR_NM    �������
            ,A.ACNO      ���¹�ȣ
            ,A.CUST_NO   ����ȣ
            ,A.TR_DT     �ŷ�����
            ,A.BFTR_CMM_ACD_DCL_DSCD   ������Ż��Ű����ڵ�
            --BFTR_CMM_ACD_DCL_DSCD ������Ż��Ű����ڵ�
            --01  ������ �Ű�,02  Ÿ�����û,03 ������ ��û,04  ���������� ��û,05  ����ȸ�� ��ü����,06  �Ϻ��������� ���
            ,A.FNN_DCP_TPCD    ������������ڵ�
            --FNN_DCP_TPCD ������������ڵ�
            --1 ���̽��ǽ�,2  �Ĺ�,3  �Ϲݴ�����,4  ��å�ڱݴ�����,5  ���̳ʽ����������
            ,A.ENR_USR_NO      ��ϻ���ڹ�ȣ

    FROM     TB_SOR_CUS_FNN_DCP_TR   A  -- SOR_CUS_������ű�����⳻��

    JOIN     TB_SOR_DEP_DPAC_BC    B   -- SOR_DEP_���Ű��±⺻
             ON  ( A.ACNO   = B.ACNO  OR   -- �Ű��¹�ȣ
                   A.ACNO   = B.OD_ACNO OR  -- �����¹�ȣ
                   A.ACNO   = B.CSMD_ACNO   -- ������¹�ȣ
                 )

    JOIN     TB_SOR_CMI_BR_BC     J1   -- SOR_CMI_���⺻
             ON  B.ADM_BRNO = J1.BRNO
             AND J1.BR_DSCD = 1

    LEFT OUTER JOIN
             TB_SOR_CMI_BR_BC     J2   -- SOR_CMI_���⺻
             ON  A.ENR_BRNO = J2.BRNO

    WHERE    1=1
    AND      A.TR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT

    ;
    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�Һ��ں�ȣ��01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

