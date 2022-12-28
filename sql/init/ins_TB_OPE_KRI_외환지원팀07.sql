/*
  ���α׷��� : ins_TB_OPE_KRI_��ȯ������07
  Ÿ�����̺� : TB_OPE_KRI_��ȯ������07
  KRI ��ǥ�� : ����ȯ���� �߽��� ������ ���Ա� �Ǽ�
  ��      �� : ��ȣ������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ��ȯ������-07 ����ȯ���� �߽��� ������ ���Ա� �Ǽ�
       A: ������ ���� ����ȯ���� ���� �� �� �Ա� �������� ����� �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_��ȯ������07
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_��ȯ������07
    SELECT   P_BASEDAY
            ,B.ADM_SLS_BRNO      --������������ȣ
            ,D.BR_NM             --����
            ,C.CUST_NM           --����
            ,A.REF_NO            --REF��ȣ
            ,A.CRCD              --��ȭ�ڵ�
            ,A.PCH_AMT           --���Աݾ�
            ,A.ANT_EXPI_DT       --���󸸱�����
            ,A.LST_EXPI_DT       --Ȯ����������
            
    FROM     TB_SOR_EXP_EXP_BC A -- SOR_EXP_����⺻

    JOIN     TB_SOR_FEC_FRXC_BC B  -- SOR_FEC_��ȯ�⺻
             ON   A.REF_NO =  B.REF_NO
             AND  B.FRXC_LDGR_STCD = '1'

    JOIN     TB_SOR_CUS_MAS_BC C    -- SOR_CUS_���⺻
             ON   B.CUST_NO  = C.CUST_NO

    JOIN     TB_SOR_CMI_BR_BC D    --  SOR_CMI_���⺻
             ON   B.ADM_SLS_BRNO  =  D.BRNO
             AND  D.BR_DSCD = '1'   -- 1.�߾�ȸ, 2.����

    WHERE    1=1
    AND      A.PCH_CLCT_DSCD = '1'           -- �����߽ɱ����ڵ�
    AND      A.DSH_AF_OVS_ROM_SMTL_AMT = 0   -- �ε����ؿ��Ա��հ�ݾ�
    AND      A.DSH_SMTL_AMT = 0              -- �ε��հ�ݾ�
    AND      A.PCH_RMD > 0                   -- �����ܾ�
    AND      A.SNDG_DT IS NOT NULL           -- �߼�����
    AND      NVL(A.DSH_PPM_END_DT,A.LST_EXPI_DT) < P_BASEDAY
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_��ȯ������07',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

