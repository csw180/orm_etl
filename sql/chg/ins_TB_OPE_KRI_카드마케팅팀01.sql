/*
  ���α׷��� : ins_TB_OPE_KRI_ī�帶������01
  Ÿ�����̺� : TB_OPE_KRI_ī�帶������01
  KRI ��ǥ�� : �ſ�ī�� ������� ���� ���� �Ǽ�
  ��      �� : ��̳�����
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ī�帶������-01 �ſ�ī�� ������� ���� ���� �Ǽ�
       A: ���� �� �ſ�ī�� ������� ���� ���� �Ǽ� Ȯ��
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

    DELETE OPEOWN.TB_OPE_KRI_ī�帶������01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_ī�帶������01

    SELECT   P_BASEDAY
            ,C.CRD_MBR_ADM_BRNO
            ,J1.BR_NM
            ,C.CRD_MBR_NO       -- ī��ȸ����ȣ
--            ,C.CRD_MBR_DSCD     -- ī��ȸ������
            ,B.CRD_PRD_DSCD    -- ī���ǰ�����ڵ�
--            ,CD1.CMN_CD_NM      -- ī���ǰ�����ڵ��
            ,A.ACD_CMPN_ACP_DT  -- �������������
            ,A.ACD_TMNT_DT      -- �����������
            ,A.RVN_WNA          -- �����ȭ�ݾ�
            ,A.ACD_CMPN_TSK_CD  -- ���������ڵ�
--            ,CD2.CMN_CD_NM      -- ���������ڵ��
    FROM
    (
     SELECT   A.CRD_NO
             ,A.ACD_CMPN_TSK_CD
             ,A.ACD_CMPN_ACP_DT
             ,A.ACD_TMNT_DT
             ,B.ACD_RVN_SNO
             ,B.RVN_WNA
     FROM     TB_SOR_CAM_ACD_CMPN_ACP_TR   A   -- SOR_CAM_�������������
     JOIN     TB_SOR_CAM_ACD_CMPN_RVN_TR   B   -- SOR_CAM_�������⳻��
              ON    A.CRD_NO          =  B.CRD_NO
              AND   A.ACD_CMPN_TSK_CD =  B.ACD_CMPN_TSK_CD  -- ���������ڵ�
              AND   A.ACD_CMPN_ACP_DT =  B.ACD_CMPN_ACP_DT  -- �������������
              AND   B.IPTT_JDGM_CMPL_YN   = 'Y'             -- ��å�����ϷῩ��

     WHERE    1=1
     AND      A.ACD_TMNT_DT  BETWEEN P_SOTM_DT AND P_EOTM_DT   -- �����������
    )   A

    JOIN     TB_SOR_CLT_CRD_BC     B     -- SOR_CLT_ī��⺻
             ON  A.CRD_NO   =  B.CRD_NO

    JOIN     TB_SOR_CLT_MBR_BC     C    -- SOR_CLT_ȸ���⺻
             ON  B.CRD_MBR_NO   =  C.CRD_MBR_NO

    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
             ON  C.CRD_MBR_ADM_BRNO  =  J1.BRNO
             AND J1.BR_DSCD = '1'   -- 1.�߾�ȸ, 2.����
             
/*
    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_�����ڵ�⺻
               WHERE   TPCD_NO_EN_NM = 'CRD_PRD_DSCD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD1
             ON    B.CRD_PRD_DSCD = CD1.CMN_CD

    LEFT OUTER JOIN
             (
               SELECT  CMN_CD, CMN_CD_NM
               FROM    OM_DWA_CMN_CD_BC   -- DWA_�����ڵ�⺻
               WHERE   TPCD_NO_EN_NM = 'ACD_CMPN_TSK_CD'
               AND     CMN_CD_US_YN = 'Y'
             )  CD2
             ON    A.ACD_CMPN_TSK_CD = CD2.CMN_CD
*/
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_ī�帶������01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
