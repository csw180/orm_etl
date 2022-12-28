/*
  ���α׷��� : ins_TB_OPE_KRI_����������18
  Ÿ�����̺� : TB_OPE_KRI_����������18
  KRI ��ǥ�� : ����� �������� ��ü ���� �Ǽ�
  ��      �� : ����������
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - ����������-18 : ����� �������� ��ü ���� �Ǽ�
       A: ���� ����� ���,���������� �ش������ �ŷ������� �ű��� ��ü�� �̷���� ���� ���Ž���Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_����������18
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_����������18
    SELECT   P_BASEDAY                          AS ��������
            ,A.TR_BRNO                          AS   ����ȣ
            ,J.BR_NM                            AS   ����
            ,A.CLN_ACNO                         AS   ���¹�ȣ
            ,A.CUST_NO                          AS   ����ȣ
            ,A.CUST_DSCD                        AS   �������ڵ�
            ,A.PDCD                             AS   ��ǰ�ڵ�
            ,PD.PRD_KR_NM                       AS   ��ǰ��
            ,A.CRCD                             AS   ��ȭ�ڵ�
            ,A.APRV_AMT                         AS   ���Ž��αݾ�
            ,A.CLN_EXE_NO                       AS   ���Ž����ȣ
            ,A.TR_PCPL                          AS   ���Ž���ݾ�
            ,A.TR_DT                            AS   �ŷ�����
            ,A.RCFM_DT                          AS   �����
            ,DECODE(C.LKG_FCNO,NULL,'N','Y')    AS   �����Աݿ���
            ,C.LKG_FCNO                         AS   �Աݰ��¹�ȣ
            ,A.TR_USR_NO                        AS   ������������ȣ
            ,A.CLN_TR_DTL_KDCD                  AS   ���Űŷ��������ڵ�
            ,A.TR_STCD                          AS   �ŷ������ڵ�
    FROM     (
                SELECT
                         A.CLN_ACNO                    -- ���Ű��¹�ȣ
                        ,A.APRV_AMT
                        ,A.CUST_NO
                        ,A.PDCD
                        ,A.CRCD
                        ,CASE WHEN A.LN_SBCD IN ('021','022','450','452') THEN '2'  --��������ڵ�('021','022','450','452':��������)
                              ELSE  '1'                                             --�׿� �������
                         END        CUST_DSCD
                        ,B.CLN_EXE_NO                  -- ���Ž����ȣ
                        ,B.CLN_TR_NO                   -- ���Űŷ���ȣ
                        ,B.CLN_TR_DTL_KDCD             -- ���Űŷ��������ڵ�
                        ,B.TR_STCD                     -- �ŷ������ڵ�
                        ,B.TR_USR_NO                   -- �ŷ�����ڹ�ȣ
                        ,B.CHNL_TPCD                   -- ä�������ڵ�
                        ,B.TR_DT                       -- �ŷ�����
                        ,B.RCFM_DT                     -- �������
                        ,B.TR_BRNO                     -- �ŷ�����ȣ
                        ,B.TR_PCPL                     -- �ŷ�����
                FROM     TB_SOR_LOA_ACN_BC    A   -- SOR_LOA_���±⺻
                JOIN     TB_SOR_LOA_TR_TR     B   -- SOR_LOA_�ŷ�����
                         ON     A.CLN_ACNO    =  B.CLN_ACNO
                         AND    B.TR_DT   BETWEEN  P_SOTM_DT AND   P_EOTM_DT
                         AND    B.CLN_TR_KDCD  IN  ('200','201')  -- ���Űŷ������ڵ� 200(�������), 201(����������)
                         AND    B.TR_STCD   =  '1'  -- �ŷ������ڵ� 1:'����' ,2:'����', 3:���', 4:'���ŷ�����', 5:'���ŷ����'
                WHERE    1=1
                AND      A.PREN_CLN_DSCD  IN ('2','3')  --  ���α�����ű����ڵ�(2:�������,3:�ұ������)
                AND      A.NFFC_UNN_DSCD  =  '1'        --  �߾�ȸ���ձ����ڵ�(1:�߾�ȸ)
             )    A

    JOIN     TB_SOR_CMI_BR_BC     J
             ON   A.TR_BRNO      =   J.BRNO

    LEFT OUTER JOIN
             (
                  SELECT   A.CLN_ACNO                 -- ���Ű��¹�ȣ
                          ,A.CLN_EXE_NO               -- ���Ž����ȣ
                          ,A.CLN_TR_NO                -- ���Űŷ���ȣ
                          ,A.LKG_FCNO                 -- ��������������¹�ȣ
                          ,B.CUST_NO   AS  DEP_CUST_NO       -- ���Ű���ȣ
                  FROM     TB_SOR_LOA_TR_BYCS_LKG_DL    A    --  SOR_LOA_�ŷ��Ǻ�������
                  JOIN     TB_SOR_DEP_DPAC_BC           B    --  SOR_DEP_���Ű��±⺻
                           ON  (
                                  A.LKG_FCNO =  B.ACNO OR
                                  A.LKG_FCNO =  B.OD_ACNO OR
                                  A.LKG_FCNO =  B.CSMD_ACNO
                               )
                  WHERE    1=1
                  AND      A.CLN_LKG_TR_KDCD  IN  ('11','12')  --  ���ſ����ŷ������ڵ�(11:�����Աݿ���, 12:�����Աݿ������)
             )   C
             ON   A.CLN_ACNO     =  C.CLN_ACNO
             AND  A.CLN_EXE_NO   =  C.CLN_EXE_NO
             AND  A.CLN_TR_NO    =  C.CLN_TR_NO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD        --  SOR_PDF_��ǰ�⺻
             ON     A.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE    1=1
    AND      (
               C.DEP_CUST_NO IS NULL   OR         -- �����Աݵ��� �ʾҰų�
               A.CUST_NO  <>   C.DEP_CUST_NO      -- ���ְ��·� �����Ա� ���� ������(���� ���ⳳ�������� ��ü�� ����)
             )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_����������18',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT