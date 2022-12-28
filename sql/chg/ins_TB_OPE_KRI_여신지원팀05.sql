/*
  ���α׷��� : ins_TB_OPE_KRI_����������05
  Ÿ�����̺� : TB_OPE_KRI_����������05
  KRI ��ǥ�� : ������� �������� �̰��� ���� ��
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
   - ����������-05 ������� �������� �̰��� ���� ��
     A: �������Ե� ���� �� ���� ������/������ ������ ��� �� ������ ���� ��
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

    DELETE OPEOWN.TB_OPE_KRI_����������05
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������05
    SELECT   P_BASEDAY       AS   ��������
            ,A.CUST_NO        AS   ����ȣ
            ,A.ACNO           AS   ���¹�ȣ
            ,D.PDCD            AS   ��ǰ�ڵ�
            ,PD.PRD_KR_NM      AS   ��ǰ��
            ,A.CRCD            AS   ��ȭ�ڵ�
            ,A.MIMO_AMT        AS   �����ܾ�
            ,A.MVT_BRNO        AS   �̰�����ȣ
            ,J1.BR_NM          AS   �̰�����
            ,A.MVT_TR_USR_NO   AS   �̰�������������ȣ
            ,A.MVN_BRNO        AS   ��������ȣ
            ,J2.BR_NM          AS   ��������
            ,A.MVN_TR_USR_NO   AS   ����������������ȣ
            ,A.TR_DT           AS   �̼�����������
--            'Y'                AS   ���δ�󿩺�
--            '0000'             AS   ���κμ�
            ,C.APRV_TGT_YN     AS   ���δ�󿩺�
            ,C.APRV_BRNO       AS   ���κμ�
    FROM     (

              SELECT  TR_DT                 -- �ŷ�����
                     ,CHG_DT                -- ��������
                     ,CHG_TM                -- ����ð�
                     ,CHG_BRNO              -- ��������ȣ
                     ,CHG_USR_NO            -- �������ڹ�ȣ
                     ,ENR_BRNO              -- �������ȣ
                     ,CUST_NO               -- ����ȣ
                     ,ACNO                  -- ���¹�ȣ
                     ,CRCD                  -- ��ȭ�ڵ�
                     ,MIMO_AMT              -- ��������ݾ�
                     ,MVT_BRNO              -- ��������ȣ
                     ,MVT_TR_USR_NO         -- ����ŷ�����ڹ�ȣ
                     ,MVN_BRNO              -- ��������ȣ
                     ,MVN_TR_USR_NO         -- ���԰ŷ�����ڹ�ȣ
              FROM    TB_SOR_CMP_MVN_MVT_TR A -- SOR_CMP_�������⳻��
              WHERE   1=1
              AND     TR_DT  BETWEEN  P_SOTM_DT  AND  P_EOTM_DT
              AND     CMN_SPPT_TSK_DSCD = '2'  -- �����������������ڵ�(2:���ž���)
              AND     MIMO_DSCD =  '2'   -- �������ⱸ���ڵ�(2:���Խ���)
              AND     MVT_BRNO IN  ( SELECT BRNO
                                     FROM   TB_SOR_CMI_BR_BC  -- CMI_���⺻
                                     WHERE   FSC_DSCD = '1'   -- ȸ�豸���ڵ�(1:����)
                                    )
             )  A
    JOIN     (
                SELECT  TR_DT              -- �ŷ�����
                       ,MIMO_SNO           -- ���������Ϸù�ȣ
                       ,CHG_DT             -- ��������
                       ,CHG_TM             -- ����ð�
                       ,CHG_BRNO           -- ��������ȣ
                       ,CHG_USR_NO         -- �������ڹ�ȣ
                       ,ACNO               -- ���¹�ȣ
                FROM    TB_SOR_CMP_MVN_MVT_TR A -- SOR_CMP_�������⳻��
                WHERE   1=1
                AND     TR_DT  BETWEEN  P_SOTM_DT  AND  P_EOTM_DT
                AND     MIMO_DSCD =  '3'   -- �������ⱸ���ڵ�(3:���Ե��)
                AND     CMN_SPPT_TSK_DSCD = '2'  -- �����������������ڵ�(2:���ž���)
             )  B
             ON   A.ACNO        =  B.ACNO
             AND  A.CHG_DT      =  B.CHG_DT
             AND  A.CHG_TM      =  B.CHG_TM
             AND  A.CHG_BRNO    =  B.CHG_BRNO
             AND  A.CHG_USR_NO  =  B.CHG_USR_NO
             AND  A.TR_DT       =  B.TR_DT

    LEFT OUTER JOIN
             (
                SELECT   TR_DT
                        ,MIMO_SNO
                        ,APRV_TGT_YN
                        ,APRV_BRNO
                FROM     TB_SOR_CMP_MVT_APRV_TR -- SOR_CMP_�����Ϻ��ν��γ���
                WHERE    TR_DT  BETWEEN  P_SOTM_DT AND P_EOTM_DT
             )   C
             ON      B.TR_DT      =  C.TR_DT
             AND     B.MIMO_SNO   =  C.MIMO_SNO

    JOIN     TB_SOR_LOA_ACN_BC    D
             ON     A.ACNO      = D.CLN_ACNO

    JOIN     TB_SOR_CMI_BR_BC     J1
             ON     A.MVT_BRNO  =  J1.BRNO

    JOIN     TB_SOR_CMI_BR_BC     J2
             ON     A.MVN_BRNO  =  J2.BRNO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD
             ON     D.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������05',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT