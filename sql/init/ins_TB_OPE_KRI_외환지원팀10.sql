/*
  ���α׷��� : ins_TB_OPE_KRI_��ȯ������10
  Ÿ�����̺� : TB_OPE_KRI_��ȯ������10
  KRI ��ǥ�� : ������ Ÿ�߼۱� �Ǽ�
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��ȯ������-10 ������ Ÿ�߼۱� �Ǽ�
       A: ��� �� ���� �����޵� Ÿ�߼۱� �� ������/���� �����Ϸκ��� 5������ �ʰ� ����� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��ȯ������10
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��ȯ������10

    SELECT   P_BASEDAY
            ,SUBSTR(A.REF_NO,3,4)        -- ����ȣ
            ,CM.BR_NM                    -- ����
            ,A.REF_NO                    -- ������ȣ
            ,B.LDGR_ENR_DT               -- Ÿ�߳�����
            ,A.TR_DT                     -- ������
            ,A.ARN_DT                    -- ��������
            ,A.CRCD                      -- ��ȭ
            ,A.FCA                       -- ��ȯ���ݾ�
            ,CASE WHEN A.ARN_CMPL_YN = 'Y' THEN
                       TO_DATE(ARN_DT,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD')
                  ELSE TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD')
             END                  -- �������
            ,A.ARN_CMPL_YN        -- �����ϷῩ��
            ,TR.TLR_NO            -- �����ڹ�ȣ

    FROM     TB_SOR_FEC_NDFY_NSTL_TR A   -- SOR_FEC_�����޹̰�������

    JOIN     TB_SOR_INX_INMY_TLG_BC   B   -- SOR_INX_Ÿ�߼۱������⺻
             ON    A.REF_NO = B.REF_NO

    JOIN     TB_SOR_CMI_BR_BC CM         -- SOR_CMI_���⺻
             ON   SUBSTR(A.REF_NO,3,4)  = CM.BRNO

    LEFT OUTER JOIN
             TB_SOR_FEC_FRXC_TR_TR TR   -- SOR_FEC_��ȯ�ŷ�����
             ON  A.REF_NO  = TR.REF_NO
             AND TR.TR_SNO = 1
             and TR.FRXC_LDGR_STCD = '1'
             and TR.ENR_CNCL_DSCD = '1'
             and TR.TSK_PGM_NM = 'INXO413102'

    JOIN     OM_DWA_DT_BC    D
             ON   CASE WHEN A.ARN_CMPL_YN = 'N' THEN P_BASEDAY ELSE A.ARN_DT END = D.STD_DT

    WHERE    1=1
    AND      A.NDFY_NSTL_DSCD  = '1'  -- �����޹̰��������ڵ�
    AND      A.TR_STCD = '1'
    AND      A.SBCD in ('510','532','575')
    AND      D.D5_BF_SLS_DT > A.TR_DT
    AND      (
                A.ARN_CMPL_YN = 'N'   OR     -- ���������̰ų�
                (A.ARN_CMPL_YN = 'Y'  AND A.ARN_DT BETWEEN P_SOTM_DT AND P_EOTM_DT)  -- �����Ǿ����� ����� �����Ȱ�
             )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��ȯ������10',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
