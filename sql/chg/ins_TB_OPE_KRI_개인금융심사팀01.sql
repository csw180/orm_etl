/*
  ���α׷��� : ins_TB_OPE_KRI_���α����ɻ���01
  Ÿ�����̺� : TB_OPE_KRI_���α����ɻ���01
  KRI ��ǥ�� : ���� �������� ������ �Ǽ�(���λ����)
  ��      �� : �̻�ΰ���
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ���α����ɻ���-01  ���� �������� ������ �Ǽ�(���λ����)
       A: ��������� ����Ͽ����� ���� ���� �������� �������� �̿Ϸ� ������ �Ǽ�
     - ��������ɻ���-01  ���� �������� ������ �Ǽ�(�������)
       A: ��������� ����Ͽ����� ���� ���� �������� �������� �̿Ϸ� ������ �Ǽ�
     - ��������ɻ���-01  ���� �������� ������ �Ǽ�(�������)
       A: ��������� ����Ͽ����� ���� ���� �������� �������� �̿Ϸ� ������ �Ǽ�
     - ���ڱ����ɻ���-02  ���� �������� ������ �Ǽ�(���ڱ���)
       A: ��������� ����Ͽ����� ���� ���� �������� �������� �̿Ϸ� ������ �Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_���α����ɻ���01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_���α����ɻ���01
    SELECT P_BASEDAY
          ,B.CSLT_BRNO
          ,J1.BR_NM
          ,F.CUST_DSCD
          ,B.CUST_NO
          ,B.CLN_JUD_RPST_NO
          ,C.APRV_CND_EXE_BNF_DSCD
          ,C.APRV_CND_FLF_FRQ_DSCD
          ,C.JUD_APRV_CND_CTS
          ,C.APRV_CND_NEXT_FLF_PARN_DT
          ,B.RSBL_XMRL_USR_NO
          ,G.JDGR_NM

    FROM   TB_SOR_CLI_JUD_APRV_CND_TR A       -- SOR_CLI_��ǥ�ɻ�������ǳ���

    JOIN   TB_SOR_CLI_RPST_JUD_BC B           -- SOR_CLI_��ǥ�ɻ�⺻
           ON    A.CLN_JUD_RPST_NO = B.CLN_JUD_RPST_NO
           AND   B.CLN_JUD_PGRS_STCD = '20'   -- ���Žɻ���������ڵ�(20:����������)
           AND   B.DPT_CD = '0627'

    JOIN   TB_SOR_CLI_APRV_CND_BC C        -- SOR_CLI_�������Ǳ⺻
           ON    A.JUD_APRV_CND_ADM_NO = C.JUD_APRV_CND_ADM_NO
           AND   C.CLN_APRV_CND_STCD NOT IN ('2','9')  -- ���Ž������ǻ����ڵ�(1:������,2:�������ǿϷ�,9:���)

    LEFT OUTER JOIN
           TB_SOR_CLI_APRV_CND_FLF_TR D   -- SOR_CLI_�����������೻��
           ON    A.JUD_APRV_CND_ADM_NO = D.JUD_APRV_CND_ADM_NO

    LEFT OUTER JOIN
           TB_SOR_CUS_MAS_BC  F   -- SOR_CUS_���⺻
           ON    B.CUST_NO   = F.CUST_NO

    LEFT OUTER JOIN
           TB_SOR_CLI_JUD_TEAM_OGZ_BC    G -- SOR_CLI_�ɻ��������⺻
           ON    B.JUD_TEAM_CD = G.JUD_TEAM_CD
           AND   G.JDGR_CD = '0000'

    JOIN   TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_���⺻
           ON   B.CSLT_BRNO  =  J1.BRNO
           AND  J1.BR_DSCD = '1'   -- 1.�߾�ȸ, 2.����
           
    WHERE  1=1
    AND    A.JUD_APRV_CNCD = '98'   -- �ɻ���������ڵ�
    AND    A.LDGR_STCD <> '9'
    AND    ( D.APRV_CND_FLF_STCD IS NULL OR D.APRV_CND_FLF_STCD NOT IN ('2','9') )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_���α����ɻ���01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


