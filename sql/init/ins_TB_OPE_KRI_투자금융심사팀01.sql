/*
  ���α׷��� : ins_TB_OPE_KRI_���ڱ����ɻ���01
  Ÿ�����̺� : TB_OPE_KRI_���ڱ����ɻ���01
  KRI ��ǥ�� : ����溸 ���ǵ�� �̻� �з� ���� ��
  ��      �� : ���α�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ���ڱ����ɻ���-01: ����溸 ���ǵ�� �̻� �з� ���� ��
       A: ������ ���� ����溸 ����� '����' �̻��� ������ ��
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

    DELETE OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_���ڱ����ɻ���01
    SELECT   P_BASEDAY            -- ��������
            ,ADM_BRNO
            ,BR_NM
            ,CUST_NO
            ,SYS_ERLR_JDGM_GDCD
            ,TGT_ABST_DT
    FROM     (
               SELECT   A.ADM_BRNO
                       ,J1.BR_NM             -- ����
                       ,A.CUST_NO            -- ����ȣ
                       ,A.SYS_ERLR_JDGM_GDCD -- �ý�������溸��������ڵ�(01:����,02:�����,03:����)
                       ,A.TGT_ABST_DT        -- �����������
               --       ,A.ERLR_JDGM_RSN      -- ����溸��������
               --        ,A.DEL_YN
               --        ,A.EVL_AVL_DT
                       ,ROW_NUMBER() OVER ( PARTITION BY A.CUST_NO ORDER BY A.TGT_ABST_DT DESC) AS ����
               FROM     TB_SOR_EWL_NEW_TGT_BC  A --  SOR_EWL_������溸���⺻
               JOIN     TB_SOR_CMI_BR_BC     J1
                        ON   A.ADM_BRNO  =  J1.BRNO
               WHERE    1=1
               AND      A.TGT_ABST_DT  BETWEEN P_SOTM_DT AND P_EOTM_DT
               AND      A.EVL_AVL_DT   > P_BASEDAY  -- ����ȿ���ڰ� ������ ������
               AND      A.DEL_YN = 'N'
             )  A
    WHERE    1=1
    AND      A.���� = 1
    AND      A.SYS_ERLR_JDGM_GDCD >= '03'   -- 03:���� ����̻�
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_���ڱ����ɻ���01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT