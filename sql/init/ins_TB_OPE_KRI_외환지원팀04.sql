/*
  ���α׷��� : ins_TB_OPE_KRI_��ȯ������04
  Ÿ�����̺� : TB_OPE_KRI_��ȯ������04
  KRI ��ǥ�� : ��ȯ ������, �̰��� ��� ������ �Ǽ�(���)
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��ȯ������-04 ��ȯ ������, �̰��� ��� ������ �Ǽ�(���)
       A: ���� �� ��ȯ������, ��ȯ �̰���, �̼����� �� ä�ǰ��� ���(1�������) �̰��� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��ȯ������04
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��ȯ������04

    SELECT   P_BASEDAY
            ,SUBSTR(A.REF_NO,3,4) as "����ȣ"
            ,CM.BR_NM             as "����"
            ,A.TR_DT              as "��ȯ�����"
            ,ARN_DT               as "��������"
            ,CRCD                 as "��ȭ"
            ,FCA                  as "��ȯ���ݾ�"
            ,A.REF_NO             as "������ȣ"
            ,CASE WHEN A.ARN_CMPL_YN = 'Y' THEN TO_DATE(ARN_DT,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD')
                  ELSE TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD')
             END    -- �������
            ,TR.TLR_NO            as "�����ڹ�ȣ"
            ,A.ARN_CMPL_YN        as "�����ϷῩ��"

    FROM     TB_SOR_FEC_NDFY_NSTL_TR A   -- SOR_FEC_�����޹̰�������

    JOIN     TB_SOR_CMI_BR_BC CM         -- SOR_CMI_���⺻
             ON   SUBSTR(A.REF_NO,3,4)  = CM.BRNO

    LEFT OUTER JOIN
             TB_SOR_FEC_FRXC_TR_TR TR   -- SOR_FEC_��ȯ�ŷ�����
             ON  A.REF_NO  = TR.REF_NO
             AND TR.TR_SNO = 1

    WHERE    1=1
    AND      A.TR_STCD = '1'
    AND      (
               -- ���������� �������ڱ��� 1��������� ����
               (     A.ARN_CMPL_YN = 'N'     -- �����ϷῩ��
                 AND TO_CHAR(ADD_MONTHS(TO_DATE(P_BASEDAY,'YYYYMMDD'),-1),'YYYYMMDD')  >  A.TR_DT
               )     OR

               -- �������� �������ڱ��� 1�������, �������ڰ� �ݿ��ΰǸ� ����
               (     A.ARN_CMPL_YN = 'Y'     -- �����ϷῩ��
                 AND TO_CHAR(ADD_MONTHS(TO_DATE(ARN_DT,'YYYYMMDD'),-1),'YYYYMMDD')  >  A.TR_DT
                 AND ARN_DT  BETWEEN  P_SOTM_DT  AND P_EOTM_DT
               )
             )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��ȯ������04',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT




