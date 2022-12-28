/*
  ���α׷��� : ins_TB_OPE_KRI_����������09
  Ÿ�����̺� : TB_OPE_KRI_����������09
  KRI ��ǥ�� : ���ݽű� 2������ �̳��� �㺸 ������ ���ݰ��°Ǽ�
  ��      �� : ���񼱰���
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-09 ���ݽű� 2������ �̳��� �㺸 ������ ���ݰ��°Ǽ�
       A: ���� �� ���ݰ������� �����Ͽ� �ű� 2������ �̳��� �㺸������ ���ݰ��°Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_����������09
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������09

    SELECT   P_BASEDAY
            ,A.STUP_RGT_BRNO AS ����ȣ
            ,J1.BR_NM        AS ����
            ,A.MRT_NO        AS �㺸��ȣ
    --        ,A.MRT_TPCD      AS �㺸�����ڵ�
            ,B.MRT_CD        AS �㺸�ڵ�
            ,B.OWNR_CUST_NO  AS �����ֹ�ȣ
            ,A.DBR_CUST_NO   AS ���ֹ�ȣ
            ,B.DPS_ACNO      AS ���ݰ��¹�ȣ
            ,B.ENR_DT        AS �㺸�������
            ,B.NW_DT         AS ���ݽű���
            ,B.HDLG_USR_NO   AS ������������ȣ

    FROM     TB_SOR_CLM_STUP_BC A         -- SOR_CLM_�����⺻

    JOIN     TB_SOR_CLM_TBK_PRD_MRT_BC B  -- SOR_CLM_�����ǰ�㺸�⺻
             ON  A.MRT_NO    = B.MRT_NO
             AND B.ENR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
             AND B.MRT_CD IN ( '401','402','403','404','405','406','410',
                               '411','412','413','414','415','427','429',
                               '430','431','432','433','434','435','436',
                               '437','438','439','440','441','442'
                              )

    JOIN     TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_���⺻
             ON   A.STUP_RGT_BRNO  =  J1.BRNO

    JOIN     OM_DWA_DT_BC D  -- DWA_���ڱ⺻
             ON   B.ENR_DT  =  D.STD_DT

    WHERE    1=1
    AND      A.STUP_STCD IN ('02','04')
    AND      D.D2_BF_SLS_DT <= B.NW_DT   -- �㺸����Ϸ� 2�������̳� ���ݰ��½ű����� ����
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������09',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT