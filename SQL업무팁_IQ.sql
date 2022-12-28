//{ #TEMP���̺�

CREATE TABLE  #������
(
  ����           INT,
  ���¹�ȣ       CHAR(12)
  -- ����ȣ   NUMERIC(9)
);


LOAD   TABLE  #������
(
����   '|',
���¹�ȣ '\x0a'
)   FROM '/nasdat/edw/in/etc/������.dat'
QUOTES OFF
ESCAPES OFF
--SKIP 1   -- Ÿ��Ʋ ����
--BLOCK FACTOR 3000
FORMAT ASCII
;

temp table create ��뿹

declare local temporary table temp1
(
 �����ڵ� numeric(1),
 �Ǹ��ȣ numeric(15),
 ����ȣ numeric(5)
) on commit preserve rows;


//}

//{ #��ȣȭ  #�Ϻ�ȣ

-- CASE 1

CREATE TABLE  #����
(
     ����           int,
     ��           CHAR(13),
     ��ȣ��         CHAR(13)
);

LOAD   TABLE  #����
(
����   '|',
��   '|',
��ȣ�� '\x0a'
)   FROM '/ettapp/common/crypt/����.out'
QUOTES OFF
ESCAPES OFF
--SKIP 1   -- Ÿ��Ʋ ����
--BLOCK FACTOR 3000
FORMAT ASCII;

/*   ��ȣȭSET �Ŀ� Ȱ��ȭ��ų��
UPDATE TB_MDWT�λ�  A
SET   A.�ֹι�ȣ  = B.��ȣ��
FROM   #����  B
WHERE  A.�ۼ������� = '$$WRT_DATE1'  --�ۼ������� = $��������
AND    A.�ֹι�ȣ  = B.��
;
*/

TRUNCATE TABLE TB_SOR_CUS_ALT_RRNO_BC;   -- SOR_CUS_��ü�ֹε�Ϲ�ȣ�⺻

INSERT INTO TB_SOR_CUS_ALT_RRNO_BC
SELECT ����,NOW(),'EDW','931436','','',NOW(),��ȣ��,��
FROM   #����
;

-- CASE 2
�ܰ� �Ϻ�ȣȭ ��ȸ�� ����Ŭ������ �Լ��� �̿��Ͽ� �Ҽ��ִ�
  - ��ġ������ ��ó�� ��������  ������ ����

  select ENCRYPT_FL('DBSEC.KEY.RRNO', '6910211684712') FROM DUAL
  select DECRYPT_FL('DBSEC.KEY.RRNO', '6910211AUGGMA') FROM DUAL

//}


//{ #�ܾ׸�����  #����ڱ�  #�����ڱ� #��ȭ�����  #������

-- 1. �ܾ׸����� ����ڱ�
SELECT      A.STD_DT                     AS  ��������
           ,A.CUST_NO                    AS  ����ȣ
           ,A.CUST_NM                    AS  ����

           ,CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999'
                   AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014����� 88�� ������� ���Խ�Ų��.
                 THEN CASE WHEN ISNULL(D.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.����'  ELSE '2.�߼ұ��'  END
            ELSE '3.���λ����'
            END                          AS  �������
           ,A.BRNO                       AS  ����ȣ
           ,E.BR_NM                      AS  ����
           ,A.INTG_ACNO                  AS  ���հ��¹�ȣ
           ,A.CLN_EXE_NO                 AS  ���Ž����ȣ
           ,A.FRPP_KDCD                  AS  ��ǥ����
           ,A.AGR_DT                     AS  ��������
           ,A.AGR_AMT                    AS  �����ݾ�
           ,A.FST_LN_DT                  AS  ��������
           ,A.LN_EXE_AMT                 AS  �������ݾ�
           ,A.LN_RMD                     AS  �ܾ�
           ,A.MRT_CD                     AS  �㺸�ڵ�
           ,A.INDV_LMT_LN_DSCD           AS  �����ѵ����ⱸ���ڵ�

INTO        #�������   -- DROP TABLE #�������

FROM        OT_DWA_INTG_CLN_BC   A
JOIN        (
              SELECT   STD_DT
                      ,ACSB_CD
                      ,ACSB_NM
                      ,ACSB_CD4  --��ȭ�����
                      ,ACSB_NM4
                      ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                      ,ACSB_NM5
                      ,ACSB_CD6  --��������ڱݴ����(15002001), ����ü��ڱݴ����(15002101)
                      ,ACSB_NM6
              FROM     OT_DWA_DD_ACSB_TR
              WHERE    1=1
              AND      FSC_SNCD      IN ('K','C')
              AND      ACSB_CD5 IN ('14002401')     --����ڱݴ����
            )          C
            ON    A.BS_ACSB_CD  =  C.ACSB_CD
            AND   A.STD_DT      =  C.STD_DT

LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_����Ը�⺻
            ON     A.RNNO      = D.RNNO
            AND    A.STD_DT    = D.STD_DT

JOIN        OT_DWA_DD_BR_BC      E       -- DWA_�����⺻
            ON     A.STD_DT    = E.STD_DT
            AND    A.BRNO      = E.BRNO

WHERE       1=1
AND         A.STD_DT        IN ('20101231','20111231','20121231','20131231','20141231','20151231','20161031')
AND         A.BR_DSCD       = '1'   --�߾�ȸ
AND         A.CLN_ACN_STCD  = '1'           --���Ű��»����ڵ�:1 ����
;

-- 2. �ܾ׸����� �����ڱ�
SELECT      A.STD_DT             AS   ��������
           ,CASE WHEN  SUBSTR(A.RNNO,7,1) IN ('0','9') THEN '18'  --1800��� ����,����
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('1','2') THEN '19'  --1900��� ����,����
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('3','4') THEN '20'  --2000��� ����,����
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('5','6') THEN '19'  --1900��� �ܱ��γ���,����
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('7','8') THEN '20'  --2000��� �ܱ��γ���,����
            END  ||    SUBSTR(A.RNNO,1,6)      AS    �������

--            ��������߿� ���� �� �ܱ��α��� ������ �̻��Ѱǵ��� �־ ���� ���� �����Ͽ� ���, 100�� ������ ��������, 18�̶�� ���ڴ� �۾��⵵(2018)�������� ���Ƿ� ���� ������
           ,CASE WHEN  LEFT(A.RNNO,2) < '18'   THEN  CONVERT(CHAR(2),'20')
                 WHEN  LEFT(A.RNNO,2) >= '18'  THEN  CONVERT(CHAR(2),'19')
                 ELSE  'XX'
            END  ||   SUBSTR(A.RNNO,1,6)      AS    �������2
            
           ,CONVERT(INT,LEFT(A.STD_DT,4)) - CONVERT(INT,LEFT(�������,4)) + CASE WHEN CONVERT(INT,RIGHT(�������,4)) > CONVERT(INT,RIGHT(A.STD_DT,4)) THEN -1 ELSE 0 END  AS ������

           ,CASE WHEN ������ <  20                     THEN '1.20�� �̸�'
                 WHEN ������ >= 20  AND ������ < 30  THEN '2.20���̻� ~ 30���̸�'
                 WHEN ������ >= 30  AND ������ < 40  THEN '3.30���̻� ~ 40���̸�'
                 WHEN ������ >= 40  AND ������ < 50  THEN '4.40���̻� ~ 50���̸�'
                 WHEN ������ >= 50  AND ������ < 60  THEN '5.50���̻� ~ 60���̸�'
                 WHEN ������ >= 60                     THEN '6.60�� �̻�'
                 ELSE '7.��Ÿ'
                 END  AS ���̱���

           ,A.INTG_ACNO                       AS ���հ��¹�ȣ
           ,A.CLN_EXE_NO                      AS �����ȣ
           ,A.CUST_NO                         AS ����ȣ
           ,A.LN_RMD                          AS �����ܾ�
           ,CASE WHEN ISDATE(A.FSS_OVD_ST_DT ) = 1  THEN 'Y'           ELSE NULL    END     AS �ݰ�����ü����
           ,CASE WHEN ISDATE(A.FSS_OVD_ST_DT ) = 1  THEN A.OVD_AMT     ELSE 0       END     AS �ݰ�����ü�ݾ�

INTO        #����  -- DROP TABLE #����

FROM        OT_DWA_INTG_CLN_BC   A

JOIN        OT_DWA_DD_BR_BC      B       -- DWA_�����⺻
            ON         A.STD_DT       = B.STD_DT
            AND        A.BRNO         = B.BRNO

JOIN        (
              SELECT   STD_DT
                      ,ACSB_CD
                      ,ACSB_NM
                      ,ACSB_CD4  --��ȭ�����
                      ,ACSB_NM4
                      ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                      ,ACSB_NM5
                      ,ACSB_CD6  --��������ڱݴ����(15002001), ����ü��ڱݴ����(15002101)
                      ,ACSB_NM6
              FROM     OT_DWA_DD_ACSB_TR
              WHERE    1=1
              AND      FSC_SNCD      IN ('K','C')
              AND      ACSB_CD5      IN ('14002501')     --�����ڱݴ����

            )       C
            ON    A.BS_ACSB_CD  =  C.ACSB_CD
            AND   A.STD_DT      =  C.STD_DT

WHERE       1=1
AND         A.STD_DT        = '20180531'
AND         A.BR_DSCD       = '1'   --����
AND         A.CLN_ACN_STCD  = '1'   --���Ű��»����ڵ�:1 ����
;

//}


//{ #��ǰ�⺻  #��ǰ�ڵ�  #��ǰ�ڵ�� #�귣���ڵ� #�귣���ڵ�� #���Ż�ǰ����

  ,SUBSTR(A.PDCD, 6, 4)              AS �귣���ڵ�

SELECT
           ,A.PRD_BRND_CD       AS ��ǰ�귣���ڵ�
           ,ISNULL(TRIM(H.PRD_BRND_CD_NM),' ')    AS ��ǰ�귣���ڵ��
           ,A.PDCD              AS   ��ǰ�ڵ�
           ,ISNULL(TRIM(G.PRD_KR_NM),' ')    AS ��ǰ�ڵ��
...........
LEFT OUTER JOIN
            TB_SOR_PDF_PRD_BC G                       -- SOR_PDF_��ǰ�⺻
            ON     A.PDCD  = G.PDCD
            AND    G.APL_STCD  =  '10'                -- �̰ź����� ������ ������

LEFT OUTER JOIN
            DWZOWN.OT_DWA_CLN_PRD_STRC_BC H           --���Ż�ǰ
            ON     A.PDCD     = H.PDCD
            AND    H.STD_DT   = '20151031'
//}

//{ #���ڼ��� #�ŷ�����

-- �ŷ������� �ŷ�����
SELECT      A.CLN_ACNO                   AS ���Ű��¹�ȣ
           ,A.GRLN_ADM_NO                AS ���ܴ�����ι�ȣ
           ,B.CLN_EXE_NO                 AS ���Ž����ȣ
           ,E.CLN_TR_NO                  AS ���Űŷ���ȣ
           ,ISNULL(E.TR_INT,0)           AS �ŷ�����1          -- �ŷ������� �ŷ�����
           ,E.TR_DT                      AS �ŷ�����
           ,ISNULL(SUM(F.LN_INT),0)      AS �ŷ�����2          -- ���ڰ�곻���� ��������
                                                               -- �ŷ������� �ŷ����ڿ� ���ϱ� ���ؼ� ���� �����غ�..
INTO        #TEMP           -- DROP TABLE #TEMP
FROM        TB_SOR_LOA_ACN_BC      A     --SOR_LOA_���±⺻
JOIN        TB_SOR_LOA_EXE_BC      B     --SOR_LOA_����⺻
            ON      A.CLN_ACNO     =  B.CLN_ACNO

JOIN        OM_DWA_INTG_CUST_BC    C     --DWA_���հ��⺻
            ON      A.CUST_NO      =  C.CUST_NO

JOIN        TB_SOR_LOA_TR_TR        E     --SOR_LOA_�ŷ�����
            ON      B.CLN_ACNO     =   E.CLN_ACNO
            AND     B.CLN_EXE_NO   =   E.CLN_EXE_NO
            AND     E.TR_STCD      =   '1' --����
            AND     E.CLN_TR_DTL_KDCD IN ('3001','3002','3003','3004',
                                          '3101','3102','3103','3201','3202','3301','3302','3601')
            AND     E.TR_DT BETWEEN  '20130701'  AND '20160523'

LEFT OUTER JOIN
            TB_SOR_LOA_INT_CAL_DL    F    --  SOR_LOA_���ڰ���
            ON      E.CLN_ACNO     =   F.CLN_ACNO
            AND     E.CLN_EXE_NO   =   F.CLN_EXE_NO
            AND     E.CLN_TR_NO    =   F.CLN_TR_NO
            AND     F.CLN_INT_CAL_TPCD  IN ('11','13','16','19')
            --  �������ڰ�������ڵ� (11:��������,13:���ݿ�ü����,16:���ڿ�ü����,19:�̼�����(ȸ��))
            --  19:�̼�����(ȸ��), 20:�̼�����(�߻�) �� ���ܰŷ��� �߻��ϴ� �׸�����
            --  ���ܰŷ��� ���Ƿ� ����Ѵ�� �ް�(�̼��ŷ�ȸ��), ����� ��ŭ ���ܳ�����(�̼��ŷ��߻�) �ִ�
            --  �� �̼������� �ڱ��� �������ڼ������� ��ü���ڼ��������� �Ǵ��Ҽ� ����.
            --  LOA_�ŷ������� �ŷ����ڿ� ���� �ݾ��� �������� ��������, ���ݿ�ü����, ���ڿ�ü������ ���Խ��Ѿ� �Ѵ�
            --  ��¼�� 12:ȯ�����ڸ� �����ϸ� ������ �𸥴�.�Ф�

WHERE       1=1
AND         A.GRLN_ADM_NO IN ('G1201300000013','G1201300000024')

--AND         E.TR_DT >=  '20160101'
GROUP BY    A.CLN_ACNO
           ,A.GRLN_ADM_NO
           ,B.CLN_EXE_NO
           ,E.CLN_TR_NO
           ,E.TR_INT
           ,E.TR_DT
--HAVING      �ŷ�����1 <> �ŷ�����2    -- �ŷ������� �ŷ����ڿ� ���ڰ����� �������ڰ� ������ ���ϱ� ���ؼ� �ӽ÷� �߰�
ORDER BY    1,3,5
;


-- ������ �������� ���ϴ� ��
SELECT      A.��������
           ,A.���հ��¹�ȣ
           ,A.���Ž����ȣ
           ,LEFT(E.TR_DT,6)                          AS �ŷ�����
           ,ISNULL(SUM(E.LN_INT + E.OVD_INT + E.NNPR_INT + E.NNPR_DLY_INT),0)      AS �ŷ�����  -- �������� + ��ü���� + �̿������� + �̿�����������
-- �̿������� : ���� �ѵ��������� ���ڼ����� �ȵ�����(�̿�������) ���߿� �Աݵ����� ���ڰ� ������. �̿����������ڴ� �̿������ڿ� ���� ���� �̴�
-- TB_SOR_DEP_TR_DL(SOR_DEP_�ŷ���) �� ���̺��� ����/��Ұ��� ���� ����ŷ��Ǹ� �����Ƿ� ���� üũ���� ���Ҽ��ִ�
FROM        #��ȭ�����   A

JOIN        TB_SOR_DEP_TR_DL    E     --SOR_DEP_�ŷ���
            ON      A.���հ��¹�ȣ     =   E.CLN_ACNO
            AND     LEFT(A.��������,6) =  LEFT(E.TR_DT,6)
            AND     E.TR_DT BETWEEN  '20110101'  AND '20160331'

WHERE       1=1
GROUP BY    A.��������
           ,A.���հ��¹�ȣ
           ,A.���Ž����ȣ
           ,LEFT(E.TR_DT,6)
;

-- ��ü�Ⱓ���� �������� �� ��ü���� ���Աݾ�
-- ���Ű�����(20171030)_���ô㺸���⿬ü����_��ȫ��.SQL  ����
SELECT      A.��������
           ,A.���¹�ȣ
           ,A.���Ž����ȣ
           ,A.�����ݾ�
           ,A.���Ž���ݾ�
           ,A.��ü�߻�����
           ,A.�ݰ�����ü��������
           ,A.���ݿ�ü�ݾ�
           ,A.�Һο�ü�ݾ�
           ,A.���ݿ�ü����
           ,A.�Һο�ü����
           ,A.���ڿ�ü����

           ,E.TR_DT             AS  �ŷ�����
           ,CASE WHEN F.CLN_INT_CAL_TPCD  IN ('11')      THEN F.LN_INT ELSE NULL END   AS ��������
           ,CASE WHEN F.CLN_INT_CAL_TPCD  IN ('13','14','15','16') THEN F.LN_INT ELSE NULL END   AS ��ü����

INTO        #�ִ㿬ü����_���ڼ���   --  DROP TABLE #�ִ㿬ü����_���ڼ���

FROM        #�ִ㿬ü����   A

JOIN        TB_SOR_LOA_TR_TR        E     --SOR_LOA_�ŷ�����
            ON      A.���¹�ȣ       =   E.CLN_ACNO
            AND     A.���Ž����ȣ   =   E.CLN_EXE_NO
            AND     E.TR_DT           >  A.��ü�߻�����
            AND     E.TR_DT          <=  A.��������
            AND     E.TR_STCD        =   '1' --����

JOIN        TB_SOR_LOA_INT_CAL_DL    F    --  SOR_LOA_���ڰ���
            ON      E.CLN_ACNO     =   F.CLN_ACNO
            AND     E.CLN_EXE_NO   =   F.CLN_EXE_NO
            AND     E.CLN_TR_NO    =   F.CLN_TR_NO
//-----------------------------------------------------------------------------
            AND     F.CLN_INT_CAL_TPCD  IN ('11','13','14','15','16')   --
            --  �������ڰ�������ڵ� (11:��������,13:���ݿ�ü����,16:���ڿ�ü����,19:�̼�����(ȸ��))
            --  LOA_�ŷ������� �ŷ����ڿ� ���� �ݾ��� �������� ��������, ���ݿ�ü����, ���ڿ�ü������ ���Խ��Ѿ� �Ѵ�
            --  ��¼�� 12:ȯ�����ڸ� �����ϸ� ������ �𸥴�.
//-----------------------------------------------------------------------------
WHERE       1=1

UNION ALL

SELECT      A.��������
           ,A.���¹�ȣ
           ,A.���Ž����ȣ
           ,A.�����ݾ�
           ,A.���Ž���ݾ�
           ,A.��ü�߻�����
           ,A.�ݰ�����ü��������
           ,A.���ݿ�ü�ݾ�
           ,A.�Һο�ü�ݾ�
           ,A.���ݿ�ü����
           ,A.�Һο�ü����
           ,A.���ڿ�ü����

           ,E.TR_DT             AS  �ŷ�����
           ,E.LN_INT            AS  ��������
           ,E.OVD_INT           AS  ��ü����
--           ,ISNULL(SUM(E.LN_INT + E.OVD_INT + E.NNPR_INT + E.NNPR_DLY_INT),0)      AS �ŷ�����  -- �������� + ��ü���� + �̿������� + �̿�����������
-- �̿������� : ���� �ѵ��������� ���ڼ����� �ȵ�����(�̿�������) ���߿� �Աݵ����� ���ڰ� ������. �̿����������ڴ� �̿������ڿ� ���� ���� �̴�
-- TB_SOR_DEP_TR_DL(SOR_DEP_�ŷ���) �� ���̺��� ����/��Ұ��� ���� ����ŷ��Ǹ� �����Ƿ� ���� üũ���� ���Ҽ��ִ�
FROM        #�ִ㿬ü����   A

JOIN        TB_SOR_DEP_TR_DL    E     --SOR_DEP_�ŷ���
            ON      A.���¹�ȣ         =   E.ACNO
            AND     E.TR_DT           >  A.��ü�߻�����
            AND     E.TR_DT          <=  A.��������

WHERE       1=1
AND         ( E.LN_INT <> 0 OR E.OVD_INT <> 0 )  -- �������ڿ� ��ü����
;

//}

//{ #��ȭ����� #����ڱ� #�����ڱݴ���� #��ȭ�����  #���޺���

-- CASE 1 : ��ȭ�����
JOIN        (
                  SELECT   STD_DT
                          ,ACSB_CD
                          ,ACSB_NM
                          ,ACSB_CD4  --��ȭ�����
                          ,ACSB_NM4
                          ,ACSB_CD5  --����ڱݴ����(14002401), �����ڱݴ����(14002501), �����ױ�Ÿ(14002601)
                          ,ACSB_NM5
                          ,ACSB_CD6
                          ,ACSB_NM6
                  FROM     OT_DWA_DD_ACSB_TR
                  WHERE    1=1
                  AND      FSC_SNCD IN ('K','C')
                  AND      ACSB_CD4 IN ('13000801')       --��ȭ�����
            )           K
            ON       A.BS_ACSB_CD   =   K.ACSB_CD
            AND      A.STD_DT       =   K.STD_DT


-- CASE 2 : �������ݰ���, �����ڱݴ����
JOIN        (
                   SELECT   STD_DT
                           ,ACSB_CD
                           ,ACSB_NM
                           ,ACSB_CD4  --��ȭ�����
                           ,ACSB_NM4
                           ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                           ,ACSB_NM5
                   FROM     OT_DWA_DD_ACSB_TR
                   WHERE    FSC_SNCD IN ('K','C')
--                AND       ACSB_CD4 = '13000801'                      --��ȭ�����
                  AND      ACSB_CD5 IN ('14002401','14002501')     --�������ݰ���,�����ڱݴ����
            )           C
            ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS���������ڵ�
            AND      A.STD_DT       =   C.STD_DT

-- CASE3 : ��ȭ�����,��ȭ�����
JOIN        (
              SELECT   STD_DT
                      ,ACSB_CD
                      ,ACSB_NM
                      ,ACSB_CD4  --��ȭ�����
                      ,ACSB_NM4
                      ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                      ,ACSB_NM5
              FROM     OT_DWA_DD_ACSB_TR
              WHERE    FSC_SNCD IN ('K','C')
              AND       ACSB_CD4 IN ( '13000801','13001108')         --��ȭ�����, ��ȭ�����
            )           C
            ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS���������ڵ�
            AND      A.STD_DT       =   C.STD_DT

-- CASE4 ���޺���
              AND      FSC_SNCD      IN ('K','C')
              AND      (    ACSB_CD5   IN ('14002401','14002601')   OR -- ����ڱݴ����,�����ױ�Ÿ�ڱ�
                            ACSB_CD2    ='93000201'                 OR -- ��Ȯ�����޺���
                            ACSB_CD3   IN ('94000208','94000101')      -- ��ȭȮ�����޺���, ��ȭȮ�����޺���
                       )
//}

//{ #��ȯ���ѵ� #��ȯ�ѵ� #�ѵ�����

�������ν���  :  UP_DWZ_��ȯ_N0012_��ȯ���ѵ�
�������α׷�  :  ��ȯ�����(20131108)_��ȯ��ü�ѵ��װ��ý���_�Ǻ�.sql

//}

//{ #���ν���  #���� #������� #���Ῡ��  #���ο���

-- CASE 1
CREATE  TABLE  #TEMP_���ν���      --  DROP TABLE  #TEMP_���ν���
(
             ��������             CHAR(8)
            ,���¹�ȣ             CHAR(20)
            ,����                 CHAR(100)
            ,�ɻ籸��             CHAR(10)
            ,��������             CHAR(8)
);


BEGIN
DECLARE   V_BASEDAY   CHAR(8);

SET    V_BASEDAY = '20141231';
--  SET    V_BASEDAY = '20150630';
--  SET    V_BASEDAY = '20150831';

INSERT INTO #TEMP_���ν���
--�������
SELECT      V_BASEDAY             AS ��������
           ,A.ACN_DCMT_NO         AS ���¹�ȣ
           --,B.APRV_BRNO           AS ��������ȣ
           ,TRIM(D.BR_NM)         AS ������
           ,'����ɻ�'            AS �ɻ籸��
           ,MAX(B.HDQ_APRV_DT)    AS ��������
INTO        #TEMP_���ν���
FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
           ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
           ,(SELECT   A.ACN_DCMT_NO         AS ���¹�ȣ
                     ,MAX(B.HDQ_APRV_DT)    AS ��������
             FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
                     ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
             WHERE    A.ACN_DCMT_NO       IS NOT NULL
             AND      A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
             AND      A.CLN_APC_CMPL_DSCD IN ('20','21')              -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
             AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�

             AND      B.APCL_DSCD         = '2'               -- ���ο��ű����ڵ�(1:����������,2:���ν���)
             AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
             AND      B.HDQ_APRV_DT      <= V_BASEDAY
             GROUP BY A.ACN_DCMT_NO
             ) C
           ,OT_DWA_DD_BR_BC D  --DWA_�����⺻
WHERE       A.ACN_DCMT_NO       IS NOT NULL
AND         A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����, 21:����)
AND         B.APCL_DSCD         = '2'               -- ���ο��ű����ڵ�(1:����������,2:���ν���)
AND         A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
AND         B.HDQ_APRV_DT       <= V_BASEDAY      -- ��������
AND         A.ACN_DCMT_NO       = C.���¹�ȣ
AND         B.HDQ_APRV_DT       = C.��������
AND         B.APRV_BRNO         *= D.BRNO
AND         D.STD_DT            = V_BASEDAY
AND         D.BRNO              <> 'XXXX'
GROUP BY    A.ACN_DCMT_NO
           ,������

UNION ALL

--���ο����� ��� ��� �ɻ�ν���
SELECT      V_BASEDAY          AS ��������
           ,A.CLN_ACNO         AS ���¹�ȣ
           ,'�ɻ��'           AS ������
           ,'���νɻ�'         AS �ɻ籸��
           ,MAX(A.CLN_APRV_DT) AS ��������
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
           ,(SELECT   A.CLN_ACNO         AS ���¹�ȣ
                     ,MAX(A.CLN_APRV_DT) AS ��������
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
             WHERE    A.CLN_ACNO          IS NOT NULL
             AND      A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
             AND      A.CSS_XCDC_DSCD     = '22'              -- CSS���ᱸ���ڵ�(11:������-����,21:����-�߾�ȸ,22:�μ���(�߾�ȸ))
             AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
             AND      A.CLN_APRV_DT       <= V_BASEDAY
             GROUP BY A.CLN_ACNO
            ) B
WHERE       A.CLN_ACNO          IS NOT NULL
AND         A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
AND         A.CSS_XCDC_DSCD     = '22'              -- CSS���ᱸ���ڵ�(11:������-����,21:����-�߾�ȸ,22:�μ���(�߾�ȸ))
AND         A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
AND         A.CLN_APRV_DT       <= V_BASEDAY
AND         A.CLN_ACNO          = B.���¹�ȣ
AND         A.CLN_APRV_DT       = B.��������
GROUP BY    A.CLN_ACNO;

END;


-- CASE 2

CREATE  TABLE  #TEMP_���ν���      --  DROP TABLE  #TEMP_���ν���
(
            ��������             CHAR(8)
           ,���¹�ȣ             CHAR(20)
           ,����                 CHAR(100)
           ,�ɻ籸��             CHAR(10)
           ,��������             CHAR(8)
           ,���ι�ȣ             CHAR(14)
           ,���ɻ翪����ڹ�ȣ CHAR(10)
           ,���Ž�û�����ڵ�     CHAR(2)
           ,�������ᱸ��         CHAR(100)
           ,��û��               CHAR(5)
);


--#TEMP_���ν���

BEGIN
DECLARE     V_BASEDAY   CHAR(8);

SET         V_BASEDAY = '20161130';
--SET         V_BASEDAY = '20141231';
--SET         V_BASEDAY = '20151130';

--�������
SELECT      A.ACN_DCMT_NO         AS ���¹�ȣ
           --,B.APRV_BRNO           AS ��������ȣ
           ,TRIM(D.BR_NM)         AS ������
           ,'����ɻ�'            AS �ɻ籸��
           ,B.HDQ_APRV_DT         AS ��������
           ,A.CLN_APRV_NO         AS ���ι�ȣ
           ,B.RSBL_XMRL_USR_NO    AS ���ɻ翪����ڹ�ȣ
           ,A.CLN_APC_DSCD        AS ��û����
           ,B.CSLT_BRNO           AS ��û��
INTO        #TEMP
FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
           ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
           ,(SELECT   A.ACN_DCMT_NO         AS ���¹�ȣ
                     ,MAX(B.HDQ_APRV_DT)    AS ��������
             FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
                     ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
             WHERE    A.ACN_DCMT_NO       IS NOT NULL
             -------------------------------------------------------------------------------
             AND      A.CLN_APC_DSCD       < '10'             -- �ű� ( �̰� ������ ���尰���͵� ������� ����.)
             -------------------------------------------------------------------------------
             AND      A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
             AND      A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
             AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
             AND      B.APCL_DSCD         = '2'               -- ���ο��ű����ڵ�(1:����������,2:���ν���)
             AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
             AND      B.HDQ_APRV_DT       <= V_BASEDAY   -- ��������
             GROUP BY A.ACN_DCMT_NO
            ) C
           ,OT_DWA_DD_BR_BC D  --DWA_�����⺻
WHERE       A.ACN_DCMT_NO       IS NOT NULL
AND         A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
AND         B.APCL_DSCD         = '2'               -- ���ο��ű����ڵ�(1:����������,2:���ν���)
AND         A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
AND         B.HDQ_APRV_DT       <= V_BASEDAY   -- ��������
AND         A.ACN_DCMT_NO       = C.���¹�ȣ
AND         B.HDQ_APRV_DT       = C.��������
AND         B.APRV_BRNO         *= D.BRNO
AND         D.STD_DT            = V_BASEDAY
AND         D.BRNO              <> 'XXXX'

UNION ALL

--���ο����� ��� ��� �ɻ�ν���
SELECT      A.CLN_ACNO         AS ���¹�ȣ
           ,'�ɻ��'           AS ������
           ,'���νɻ�'         AS �ɻ籸��
           ,A.CLN_APRV_DT      AS ��������
           ,A.CLN_APRV_NO        AS ���ι�ȣ
           ,A.RSBL_XMRL_USR_NO   AS ���ɻ翪����ڹ�ȣ
           ,A.CLN_APC_DSCD       AS ��û����
           ,A.ADM_BRNO           AS ��û��
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
           ,(SELECT   A.CLN_ACNO         AS ���¹�ȣ
                     ,MAX(A.CLN_APRV_DT) AS ��������
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
             WHERE    A.CLN_ACNO          IS NOT NULL
             -------------------------------------------------------------------------------
             AND      A.CLN_APC_DSCD       < '10'             -- �ű�
             -------------------------------------------------------------------------------
             AND      A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
             AND      A.CSS_XCDC_DSCD     = '22'              -- CSS���ᱸ���ڵ�(11:������-����,21:����-�߾�ȸ,22:�μ���(�߾�ȸ))
             AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
             AND      A.CLN_APRV_DT       <= V_BASEDAY   -- ��������
             GROUP BY A.CLN_ACNO
            ) B
WHERE       A.CLN_ACNO          IS NOT NULL
AND         A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
AND         A.CSS_XCDC_DSCD     = '22'              -- CSS���ᱸ���ڵ�(11:������-����,21:����-�߾�ȸ,22:�μ���(�߾�ȸ))
AND         A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
AND         A.CLN_APRV_DT       <= V_BASEDAY   -- ��������
AND         A.CLN_ACNO          = B.���¹�ȣ
AND         A.CLN_APRV_DT       = B.��������
;

INSERT INTO #TEMP_���ν���
SELECT      V_BASEDAY
           ,A.���¹�ȣ
           ,A.������
           ,A.�ɻ籸��
           ,A.��������
           ,A.���ι�ȣ
           ,A.���ɻ翪����ڹ�ȣ
           ,A.��û����
           ,C.LST_XCDC_DSCD ||'('||TRIM(D.XCDC_DSCD_NM)||')'  AS �������ᱸ��
           ,A.��û��

FROM        #TEMP A

JOIN        (
             SELECT   A.���¹�ȣ
                     ,A.��������
                     ,MAX(A.���ι�ȣ)   AS �������ι�ȣ
             FROM     #TEMP A
                     ,(SELECT   ���¹�ȣ
                               ,MAX(��������)   AS ������������
                       FROM     #TEMP
                       GROUP BY ���¹�ȣ
                       ) B
             WHERE    A.���¹�ȣ = B.���¹�ȣ
             AND      A.�������� = B.������������
             GROUP BY A.���¹�ȣ
                     ,A.��������
            ) B
            ON   A.���¹�ȣ    = B.���¹�ȣ
            AND  A.��������    = B.��������
            AND  A.���ι�ȣ    = B.�������ι�ȣ

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APRV_BC   C     -- SOR_CLI_���Ž��α⺻
            ON   A.���ι�ȣ  =  C.CLN_APRV_NO

/*
LEFT OUTER JOIN
                        ,(SELECT   CRDT_EVL_NO        AS �ſ��򰡹�ȣ
                      ,CRDT_EVL_MODL_DSCD AS �ſ��򰡸���
                      ,LST_ADJ_GD         AS �����������
              FROM     TB_SOR_CCR_EVL_INF_TR              --SOR_CCR_����������
              WHERE    CRDT_EVL_PGRS_STCD = '2'           --�ſ�����������ڵ�(2:�򰡿Ϸ�)
              AND      NFFC_UNN_DSCD      = '1'           --�߾�ȸ���ձ����ڵ�(1:�߾�ȸ)
              AND      CMPL_DT           <= V_BASEDAY    --�Ϸ�����
              )  C
                  AND      A.����ſ��򰡹�ȣ *= C.�ſ��򰡹�ȣ
*/


LEFT OUTER JOIN
            TB_SOR_CLI_XCDC_DSCD_BC  D   --SOR_CLI_���ᱸ���ڵ�⺻
            ON   C.LST_XCDC_DSCD  = D.CLN_XCDC_DSCD  --�������ᱸ���ڵ�
;

END;

-- CASE3
-- CASE2�� �űԽ�û�ǵ��� ã�Ƽ� �ش� ��û�ǿ� �پ� �ִ� ���κμ��� ���������� �Ǵ��ϴ� ����
-- �׷��� CASE3 �� ��û����ü(31�ݸ����θ� �����ϰ� �ű�,���Ǻ���,����,����,ä���μ��� ��� ��û���� ������� �����ֱٽ�û���� ���ν������� �Ǵ��ϴ� ������

CREATE  TABLE  #TEMP_���ν���      --  DROP TABLE  #TEMP_���ν���
(
            ��������             CHAR(8)
           ,���¹�ȣ             CHAR(20)
           ,����                 CHAR(100)
           ,�ɻ籸��             CHAR(10)
           ,��������             CHAR(8)
           ,���ι�ȣ             CHAR(14)
           ,���ɻ翪����ڹ�ȣ CHAR(10)
           ,���Ž�û�����ڵ�     CHAR(2)
           ,�������ᱸ��         CHAR(100)
           ,��û��               CHAR(5)
);

--#TEMP_���ν���
BEGIN
DECLARE     V_BASEDAY   CHAR(8);

SET         V_BASEDAY = '20171231';
--SET         V_BASEDAY = '20180131';
--SET         V_BASEDAY = '20180207';
--SET         V_BASEDAY = '20180228';
--SET         V_BASEDAY = '20180328';
--SET         V_BASEDAY = '20180330';
--SET         V_BASEDAY = '20180411';
--SET         V_BASEDAY = '20180430';
--SET         V_BASEDAY = '20180509';
--SET         V_BASEDAY = '20180531';
--SET         V_BASEDAY = '20180627';
--SET         V_BASEDAY = '20180629';
--SET         V_BASEDAY = '20180630';
--SET         V_BASEDAY = '20180711';

--�������
SELECT      A.ACN_DCMT_NO         AS ���¹�ȣ
           --,B.APRV_BRNO           AS ��������ȣ
           ,TRIM(D.BR_NM)         AS ������
           ,'����ɻ�'            AS �ɻ籸��
           ,B.HDQ_APRV_DT         AS ��������
           ,A.CLN_APRV_NO         AS ���ι�ȣ
           ,B.RSBL_XMRL_USR_NO    AS ���ɻ翪����ڹ�ȣ
           ,A.CLN_APC_DSCD        AS ��û����
           ,B.CSLT_BRNO           AS ��û��
INTO        #TEMP
FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- SOR_CLI_���Ž�û�⺻
           ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- SOR_CLI_���Ž�û��ǥ�⺻
           ,(-- ���ν��� ���������� ���о��� �� ��û�Ǻ��� �����ϰ� ���ι�ȣ �ֱټ����� ��ȣ�� ���δ�. ���߿� �ֱٰ��� �����ð��̴�.
             SELECT   A.ACN_DCMT_NO         AS ���¹�ȣ
                     ,A.CLN_APC_NO          AS ���Ž�û��ȣ
                     ,ROW_NUMBER() OVER(PARTITION BY A.ACN_DCMT_NO ORDER BY 
                                        CASE WHEN B.HDQ_APRV_DT  IS NOT NULL AND B.HDQ_APRV_DT >  '19000000' THEN B.HDQ_APRV_DT
                                             ELSE B.SLS_BR_APRV_DT
                                        END DESC, A.CLN_APRV_NO DESC ) AS ����
             FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
                     ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
             WHERE    A.ACN_DCMT_NO       IS NOT NULL
            --------------------------------------------------------------------------------
            --- �ݹ��ڷ�� �ű԰ǿ� �������� �ʰ� ���ѿ���, ���Ǻ���, ä���μ� �� ��� �����Ѵ�.
             AND      A.CLN_APC_DSCD    <> '31'            -- 31(�ݸ�����) �� �����ϰ� ��� ��û���� �����
            ---AND      A.CLN_APC_DSCD       < '10'             -- �ű� ( �̰� ������ ���尰���͵� ������� ����.)
            --------------------------------------------------------------------------------
             AND      A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
             AND      A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
             AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
--             AND      B.APCL_DSCD         = '2'             -- ���ο��ű����ڵ�(1:����������,2:���ν���)
             AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
             AND      CASE WHEN B.HDQ_APRV_DT  IS NOT NULL AND B.HDQ_APRV_DT >  '19000000' THEN B.HDQ_APRV_DT
                           ELSE B.SLS_BR_APRV_DT
                      END    <= V_BASEDAY   -- ��������
            ) C
           ,OT_DWA_DD_BR_BC D  --DWA_�����⺻
WHERE       A.ACN_DCMT_NO       IS NOT NULL
AND         A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
AND         B.APCL_DSCD         = '2'               -- ���ο��ű����ڵ�(1:����������,2:���ν���)
AND         A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
//----------------------------------------------------------------------------
AND         A.ACN_DCMT_NO       = C.���¹�ȣ
AND         A.CLN_APC_NO        = C.���Ž�û��ȣ
AND         C.����              = 1
//-------------------------------------------------------------------------------
AND         B.APRV_BRNO        *= D.BRNO
AND         D.STD_DT            = V_BASEDAY
AND         D.BRNO              <> 'XXXX'

UNION ALL

--���ο����� ��� ��� �ɻ�ν���
SELECT      A.CLN_ACNO         AS ���¹�ȣ
           ,'�ɻ��'           AS ������
           ,'���νɻ�'         AS �ɻ籸��
           ,A.CLN_APRV_DT      AS ��������
           ,A.CLN_APRV_NO        AS ���ι�ȣ
           ,A.RSBL_XMRL_USR_NO   AS ���ɻ翪����ڹ�ȣ
           ,A.CLN_APC_DSCD       AS ��û����
           ,A.ADM_BRNO           AS ��û��
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
           ,(SELECT   A.CLN_ACNO         AS ���¹�ȣ
                     ,MAX(A.CLN_APRV_DT) AS ��������
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
             WHERE    A.CLN_ACNO          IS NOT NULL
            --------------------------------------------------------------------------------
            --- �ݹ��ڷ�� �ű԰ǿ� �������� �ʰ� ���ѿ���, ���Ǻ���, �ݸ�����, ä���μ� �� ��� �����Ѵ�.
             AND       A.CLN_APC_DSCD    <> '31'            -- 31(�ݸ�����) �� �����ϰ� ��� ��û���� �����
            ---AND      A.CLN_APC_DSCD       < '10'             -- �ű�
            --------------------------------------------------------------------------------
             AND      A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
--             AND      A.CSS_XCDC_DSCD     = '22'              -- CSS���ᱸ���ڵ�(11:������-����,21:����-�߾�ȸ,22:�μ���(�߾�ȸ))
             AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
             AND      A.CLN_APRV_DT       <= V_BASEDAY   -- ��������
             GROUP BY A.CLN_ACNO
            ) B
WHERE       A.CLN_ACNO          IS NOT NULL
AND         A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
AND         A.CSS_XCDC_DSCD     = '22'              -- CSS���ᱸ���ڵ�(11:������-����,21:����-�߾�ȸ,22:�μ���(�߾�ȸ))
AND         A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
AND         A.CLN_APRV_DT       <= V_BASEDAY   -- ��������
AND         A.CLN_ACNO          = B.���¹�ȣ
AND         A.CLN_APRV_DT       = B.��������
;


INSERT INTO #TEMP_���ν���
SELECT      V_BASEDAY
           ,A.���¹�ȣ
           ,A.������
           ,A.�ɻ籸��
           ,A.��������
           ,A.���ι�ȣ
           ,A.���ɻ翪����ڹ�ȣ
           ,A.��û����
           ,C.LST_XCDC_DSCD ||'('||TRIM(D.XCDC_DSCD_NM)||')'  AS �������ᱸ��
           ,A.��û��

FROM        #TEMP A

JOIN        (
             SELECT   A.���¹�ȣ
                     ,A.��������
                     ,MAX(A.���ι�ȣ)   AS �������ι�ȣ
             FROM     #TEMP A
                     ,(SELECT   ���¹�ȣ
                               ,MAX(��������)   AS ������������
                       FROM     #TEMP
                       GROUP BY ���¹�ȣ
                       ) B
             WHERE    A.���¹�ȣ = B.���¹�ȣ
             AND      A.�������� = B.������������
             GROUP BY A.���¹�ȣ
                     ,A.��������
            ) B
            ON   A.���¹�ȣ    = B.���¹�ȣ
            AND  A.��������    = B.��������
            AND  A.���ι�ȣ    = B.�������ι�ȣ

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APRV_BC   C     -- SOR_CLI_���Ž��α⺻
            ON   A.���ι�ȣ  =  C.CLN_APRV_NO

/*
LEFT OUTER JOIN
                        ,(SELECT   CRDT_EVL_NO        AS �ſ��򰡹�ȣ
                      ,CRDT_EVL_MODL_DSCD AS �ſ��򰡸���
                      ,LST_ADJ_GD         AS �����������
              FROM     TB_SOR_CCR_EVL_INF_TR              --SOR_CCR_����������
              WHERE    CRDT_EVL_PGRS_STCD = '2'           --�ſ�����������ڵ�(2:�򰡿Ϸ�)
              AND      NFFC_UNN_DSCD      = '1'           --�߾�ȸ���ձ����ڵ�(1:�߾�ȸ)
              AND      CMPL_DT           <= V_BASEDAY    --�Ϸ�����
              )  C
                  AND      A.����ſ��򰡹�ȣ *= C.�ſ��򰡹�ȣ
*/


LEFT OUTER JOIN
            TB_SOR_CLI_XCDC_DSCD_BC  D   --SOR_CLI_���ᱸ���ڵ�⺻
            ON   C.LST_XCDC_DSCD  = D.CLN_XCDC_DSCD  --�������ᱸ���ڵ�
;

END;

//}

//{ #�ſ��򰡵�� #��ȣ��� #SOHO��� #�ұ�� #CRS��� #CSS��� #ASS���

-- ����ſ��򰡸��������� 10����� ������ ������ ���� ó��
-- ���νſ��򰡸��������� 15����� ������ ������ ���� ó��

--2. ���� ������ ����ݸ� ��Ȳ(���CRS ����)
SELECT      ������
           ,CASE WHEN ����ſ��򰡵�� IS NULL OR ����ſ��򰡸��������ڵ� IN ('31','32','33','34')  THEN '��Ÿ'
                 ELSE ����ſ��򰡵��
            END           �ſ���
            -- ��ȣ���� ('31','32','33','34') �� 10���ü��� CRS���(15���ü��) �� �ٸ��Ƿ�
            -- ���� ����� �Ұ��Ͽ� '��Ÿ' �� �з���
           ,SUM(�����ܾ�)          �ܾ�
           ,CASE WHEN SUM(�����ܾ�) > 0 THEN
                    CONVERT(NUMERIC(7,5),
                              SUM(�����ܾ� * �ý��ۻ���ݸ�)
                             /SUM(�����ܾ�)
                            )
                 ELSE   0
            END                              AS  �ý��۱ݸ�

           ,CASE WHEN SUM(�����ܾ�) > 0 THEN
                    CONVERT(NUMERIC(7,5),
                              SUM(�����ܾ� * ��������)
                             /SUM(�����ܾ�)
                            )
                 ELSE   0
            END                              AS  ����ݸ�

FROM        #TEMP
WHERE       1=1
-- AND         ���߽űԿ��� = 1
AND         ���߿��忩�� = 1
AND         �ڱݱ��� = '����ڱݴ����'
GROUP BY    ������
           ,�ſ���
ORDER BY    1,2
;

--3. ���� ������ ����ݸ� ��Ȳ (CSS���θ���)
SELECT      ������
           ,CONVERT(INT,CASE WHEN ASS�ſ��� IS NULL OR ASS�ſ��� IN ('0','00','11')  OR
                                  CSS���������ڵ� IN ('10','20','30','40','41','50','51','52','53','54','70','80')
                                  THEN  '99'
                             ELSE ASS�ſ���
                             END
                   )                 AS �ſ���
            -- ���νſ��� 10��� ü�谡 �ƴ϶� 15���ü��� �з��Ǵ� '�ұ��' �� ���������ڵ� ('10','20','30','40','41','50','51','52','53','54','70','80')
            -- �� CSS��ް� ���� ��ºҰ��Ͽ� '99' �� �з���
           ,SUM(�����ܾ�)  AS  �ܾ�
           ,CASE WHEN SUM(�����ܾ�) > 0 THEN
                    CONVERT(NUMERIC(7,5),
                              SUM(�����ܾ� * �ý��ۻ���ݸ�)
                             /SUM(�����ܾ�)
                            )
                 ELSE   0
            END                              AS  �ý��۱ݸ�

           ,CASE WHEN SUM(�����ܾ�) > 0 THEN
                    CONVERT(NUMERIC(7,5),
                              SUM(�����ܾ� * ��������)
                             /SUM(�����ܾ�)
                            )
                 ELSE   0
            END                              AS  ����ݸ�

FROM        #TEMP
WHERE       1=1
--AND         ���߽űԿ��� = 1
AND         ���߿��忩�� = 1
AND         �ڱݱ��� = '�����ڱݴ����'
GROUP BY    ������
           ,�ſ���
ORDER BY    1,2
;

//}

//{ #���űݸ��ý��� #�ý��ۻ���ݸ�  #�ý��۱ݸ� #���ʾ��� #���ι�ȣ

-- CASE1
UPDATE      #TEMP   A
--SET         A.�ý��ۻ���ݸ�  = B.AGCS_APL_IRT                 -- �������ݸ�  *������ ������ݸ��� �ʹ� ����ϰ� ����
SET         A.�ý��ۻ���ݸ�  = B.TOT_STD_IRT  + B.TOT_ADD_IRT  -- �Ѱ���ݸ� + �ѱ��رݸ�
            
FROM        (
                SELECT A.*
                FROM          TB_SOR_IRL_IRT_CALC_TR A
                INNER JOIN (
                              SELECT A.CLN_APC_NO, MAX(A.APCL_DSCD) APCL_DSCD
                              FROM (
                        SELECT A.CLN_APC_NO, A.APCL_DSCD
                        FROM   TB_SOR_IRL_IRT_CALC_TR A
                        WHERE  APCL_DSCD IN ('1','2')  -- ���ο��ű����ڵ�(1:����������,2:���ν���,3:�ݸ�����)
            
                                      UNION
                        SELECT A.CLN_APC_NO, '3' APCL_DSCD
                        FROM   TB_SOR_IRL_IRT_CALC_TR A
                                      INNER JOIN
                                             TB_SOR_IRL_IRT_RNX_APRV_BC B
                                             ON A.CLN_APC_NO = B.CLN_APC_NO
                                             AND A.APCL_DSCD = '3'
                                             AND B.IRT_RNX_PGRS_STCD = '04'
                                   ) A
                              GROUP BY A.CLN_APC_NO
                           ) B
                ON  A.CLN_APC_NO = B.CLN_APC_NO
                AND A.APCL_DSCD  = B.APCL_DSCD
            )  B
WHERE       A.���Ž�û��ȣ  = B.CLN_APC_NO
;

-- CASE1-2 �̰� �� ��Ȯ�� ������

UPDATE      #TEMP   A
--SET         A.�ý��ۻ���ݸ�  = B.AGCS_APL_IRT                 -- �������ݸ�  *������ ������ݸ��� �ʹ� ����ϰ� ����
SET         A.�ý��ۻ���ݸ�  = B.TOT_STD_IRT  + B.TOT_ADD_IRT  -- �Ѱ���ݸ� + �ѱ��رݸ�
            
FROM        (
                SELECT      A.*
                FROM        TB_SOR_IRL_IRT_CALC_TR A
                INNER JOIN (
                             SELECT A.CLN_APC_NO, MAX(A.A_APCL_DSCD) AS APCL
                             FROM   (
                                    SELECT A.CLN_APC_NO, A.APCL_DSCD AS A_APCL_DSCD, C.APCL_DSCD AS C_APCL_DSCD
                                    FROM   TB_SOR_IRL_IRT_CALC_TR A
                                         ,(
                                           SELECT CLN_APC_NO, APCL_DSCD
                                           FROM TB_SOR_IRL_IRT_CALC_TR
                                           WHERE APCL_DSCD = '3'
                                           AND IRT_RNX_APL_YN <> 'Y'
                                           
                                           UNION
                                           
                                           SELECT CLN_APC_NO,'3' AS APCL_DSCD
                                           FROM TB_SOR_IRL_IRT_RNX_APRV_BC
                                           WHERE IRT_RNX_PGRS_STCD IN ('03', '05')
                                           
                                          ) C
                                     WHERE   A.CLN_APC_NO  *= C.CLN_APC_NO
                                     AND     A.APCL_DSCD   *= C.APCL_DSCD
                                     ) A
                             WHERE   A.C_APCL_DSCD IS NULL
                             GROUP BY A.CLN_APC_NO
                           ) B
                ON         A.CLN_APC_NO = B.CLN_APC_NO
                AND        A.APCL_DSCD  = B.APCL
            )  B
WHERE       A.���Ž�û��ȣ  = B.CLN_APC_NO
;

-- CASE2
--20170329_�ֽź��⿬�ݴ����¾�������_����ȯ �ҽ�������
SELECT      A.CLN_ACNO
           ,A.AGR_DT
           ,A.TR_STCD
           ,A.CLN_APRV_NO   AS ���Ž��ι�ȣ
           ,C.CLN_APC_NO    AS ���Ž�û��ȣ
           ,C.APCL_DSCD     AS ���ο��ű����ڵ�
           ,C.TOT_STD_IRT   AS �ѱ��رݸ�
           ,C.MKT_PCMN_IRT  AS �������ޱݸ�
           ,C.PLCY_ADJ_IRT  AS ��å�����ݸ�
           ,C.TALM_ADJ_IRT  AS �Ѿ��ѵ����������ݸ�
           ,C.MKT_ADJ_IRT   AS ���������ݸ�
           ,C.FC_BRW_SPRD   AS ��ȭ���Խ�������
           ,C.TOT_ADD_IRT   AS �Ѱ���ݸ�
           ,C.LQT_PRMM_IRT  AS �����������̾��ݸ�
           ,C.INXP_ADD_RT   AS �δ��밡����
           ,C.EDU_TXRT      AS ��������
           ,C.HS_KCGF_GRFE_RT AS ���ýſ뺸������⿬����
           ,C.NGSA_GRFE_RT  AS �󸲼�����ڽſ뺸������⿬����
           ,C.TSK_PCST_ADD_IRT AS ������������ݸ�
           ,C.DRCT_TSK_PCST_RT AS ��������������
           ,C.INDR_TSK_PCST_RT AS ��������������
           ,C.CRDT_PCST_ADD_IRT AS �ſ��������ݸ�
           ,C.ANT_LOSS_RT   AS ����ս���
           ,C.NANT_LOSS_RT  AS �񿹻�ս���
           ,C.GL_MRGN_ADD_IRT AS ��ǥ��������ݸ�
           ,C.PRD_TP_ADD_IRT AS ��ǰ��������ݸ�
           ,C.LMT_LN_ADD_IRT AS �ѵ����Ⱑ��ݸ�
           ,C.INDV_NTC_ADD_IRT AS ������ð���ݸ�
           ,C.DNNS_MRT_ADD_IRT AS �����ݴ㺸����ݸ�
           ,C.SYS_CALC_PCST_IRT AS �ý��ۻ�������ݸ�
           ,C.TOT_ADD_PRM_IRT AS �Ѱ�����ݸ�
           ,C.SLS_BR_ADD_IRT AS ����������ݸ�  --���ᰡ��ݸ�
           ,C.BRNO          AS ����ȣ
           ,C.APL_ST_DT     AS �����������
           ,C.APL_END_DT    AS ������������
           ,C.SLS_BR_PRM_BSC_IRT AS ���������⺻�ݸ�
           ,C.SLS_BR_GRDN_MXM_IRT AS �����������ִ�ݸ�
           ,C.SLS_BR_GRDN_APL_IRT AS ��������������ݸ�
           ,C.SLS_BR_PRM_IRT AS ���������ݸ� --���ᰨ��ݸ�
           ,C.HDQ_APRV_IRT  AS ���ν��αݸ�
           ,C.INDV_ADJ_IRT  AS ���������ݸ�
           ,C.AGCS_LN_IRT   AS �������ݸ�
           ,C.CLN_APL_LWST_IRT AS �������������ݸ�
           ,C.CLN_APL_HGST_IRT AS ���������ְ�ݸ�
           ,C.AGCS_APL_IRT  AS �������ݸ�
           ,C.SLS_BR_MRGN_IRT AS �����������ݸ�
           ,C.FTP_IRT       AS FTP�ݸ�
           ,C.ENR_USR_NO    AS ��ϻ���ڹ�ȣ
           ,C.ENR_DT        AS �������
           ,C.EDTX_ICD_AGCS_APL_IRT AS ���������Դ������ݸ�
           ,C.IRT_RNX_APL_YN AS �ݸ��������뿩��
           ,C.CRDT_CLN_GL_MRGN_ADD_IRT AS �ſ뿩�Ÿ�ǥ��������ݸ�
           ,C.MRT_CLN_GL_MRGN_ADD_IRT AS �㺸���Ÿ�ǥ��������ݸ�
           ,C.GRN_PART_GL_MRGN_ADD_IRT AS �����κи�ǥ��������ݸ�
           ,C.NGRN_PART_GL_MRGN_ADD_IRT AS �����κи�ǥ��������ݸ�
           ,C.IRT_ADJ_CFC   AS �ݸ��������
           ,C.GRN_PART_CRDT_PCST_ADD_IRT AS �����κнſ��������ݸ�
           ,C.GRN_PART_ANT_LOSS_RT AS �����κп���ս���
           ,C.GRN_PART_NANT_LOSS_RT AS �����κк񿹻�ս���
           ,C.NGRN_PART_CRDT_PCST_ADD_IRT AS �����κнſ��������ݸ�
           ,C.NGRN_PART_ANT_LOSS_RT AS �����κп���ս���
           ,C.NGRN_PART_NANT_LOSS_RT AS �����κк񿹻�ս���
           ,C.GRN_PART_ADD_IRT AS �����κа���ݸ�
           ,C.NGRN_PART_ADD_IRT AS �����κа���ݸ�
           ,ISNULL(C.APL_PRM_IRT,0) AS �μ��ŷ�����ݸ�
INTO        #TEMP_���űݸ� --DROP TABLE #TEMP_���űݸ�
FROM
            (          -- �������� ���ʾ����� ���ϱ�
             SELECT  A.CLN_ACNO
                    ,B.CLN_APRV_NO
                    ,B.AGR_DT
                    ,B.TR_STCD
             FROM    TB_SOR_LOA_ACN_BC A
             INNER JOIN
                     TB_SOR_LOA_AGR_HT   B
                     ON         A.CLN_ACNO = B.CLN_ACNO
                     AND        B.CLN_TR_KDCD NOT IN ('130','131')  --ä���μ� ����
                     AND        B.CLN_TR_KDCD IN ('100')            -- ���Ž�û�����ڵ� �űԾ���
                     AND        B.CLN_APRV_NO IS NOT NULL
                     AND        A.NFFC_UNN_DSCD = '1'
             INNER JOIN
                     (
                      SELECT    A.CLN_ACNO
                               ,MAX(A.AGR_TR_SNO) AS MAX_SNO
                      FROM      TB_SOR_LOA_AGR_HT A
                      WHERE     A.CLN_TR_KDCD NOT IN ('130','131')  --ä���μ� ����
                      AND       A.CLN_TR_KDCD IN ('100')            -- ���Ž�û�����ڵ� �űԾ���
                      AND       A.CLN_APRV_NO IS NOT NULL
                      AND       A.ENR_DT <=   '20170831'
                      GROUP BY  A.CLN_ACNO
                     ) C
                     ON  B.CLN_ACNO   = C.CLN_ACNO
                     AND B.AGR_TR_SNO = C.MAX_SNO
              WHERE  1=1
              //=========================================================================
              AND    A.CLN_ACNO IN  (SELECT   DISTINCT ���¹�ȣ  FROM #������_�ܾ� )
              //=========================================================================
            ) A

INNER JOIN              -- ���ʾ������� ��û��ȣ�� �������� ���Ͽ� ���ο����� �д´�
            TB_SOR_CLI_CLN_APRV_BC B --SELECT CLN_APC_DSCD, CLN_APRV_LDGR_STCD, CLN_APC_NO FROM TB_SOR_CLI_CLN_APRV_BC WHERE CLN_APRV_NO = 'P1201600179215'
            ON       A.CLN_APRV_NO = B.CLN_APRV_NO
            AND      B.CLN_APC_DSCD != '51'
            AND      B.CLN_APRV_LDGR_STCD IN ('20','21') --AND A.CLN_ACNO = '321006763199'

INNER JOIN
            (
             SELECT  A.*
                     --LQT_PRMM_IRT  AS �����������̾��ݸ�
                     --INXP_ADD_RT   AS �δ��밡���� ,
                     --EDU_TXRT      AS �������� ,
                     --HS_KCGF_GRFE_RT AS ���ýſ뺸������⿬���� ,
                     --NGSA_GRFE_RT  AS �󸲼�����ڽſ뺸������⿬���� ,
                     --TSK_PCST_ADD_IRT AS ������������ݸ� ,
                     --DRCT_TSK_PCST_RT AS �������������� ,
                     --INDR_TSK_PCST_RT AS �������������� ,
                     --CRDT_PCST_ADD_IRT AS �ſ��������ݸ� ,
                     --ANT_LOSS_RT   AS ����ս��� ,
                     --NANT_LOSS_RT  AS �񿹻�ս��� ,
                     --GL_MRGN_ADD_IRT AS ��ǥ��������ݸ�
                    ,C.APL_PRM_IRT
             FROM    TB_SOR_IRL_IRT_CALC_TR A
             INNER JOIN
                     (
                      SELECT  A.CLN_APC_NO, MAX(A.APCL_DSCD) APCL_DSCD
                      FROM    (
                                SELECT A.CLN_APC_NO, A.APCL_DSCD
                                FROM   TB_SOR_IRL_IRT_CALC_TR  A
                                WHERE  APCL_DSCD IN ('1','2') --1���������� 2���ν���
                                UNION
                                SELECT A.CLN_APC_NO, '3' APCL_DSCD
                                FROM   TB_SOR_IRL_IRT_CALC_TR A
                                INNER JOIN
                                       TB_SOR_IRL_IRT_RNX_APRV_BC B
                                       ON A.CLN_APC_NO = B.CLN_APC_NO
                                       AND A.APCL_DSCD = '3'  --3 �ݸ�����
                                       AND B.IRT_RNX_PGRS_STCD = '04'
                              ) A
                      GROUP BY A.CLN_APC_NO
                     ) B
                     ON       A.CLN_APC_NO = B.CLN_APC_NO
                     AND      A.APCL_DSCD = B.APCL_DSCD
             LEFT OUTER JOIN
                    (
                     SELECT   CLN_APC_NO
                             ,APCL_DSCD
                             ,SUM(-APL_PRM_IRT)*100 APL_PRM_IRT
                     FROM     TB_SOR_IRL_IRT_CALC_PRM_DL A --SOR_IRL_�ݸ��������
                     WHERE    ADD_PRM_IRT_DSCD = '2' --������ݸ������ڵ� 2 ���ݸ�
                     AND      ADD_PRM_IRT_GRP_CD = '21' --������ݸ��׷��ڵ�
                     AND      CHC_YN = 'Y' --���ÿ���
                     GROUP BY CLN_APC_NO, APCL_DSCD
                    ) C
                    ON        A.CLN_APC_NO = C.CLN_APC_NO
                    AND       A.APCL_DSCD  = C.APCL_DSCD
            ) C
            ON B.CLN_APC_NO = C.CLN_APC_NO
;
//}

//{ #�����̺� #�߾�ȸ�ſ���
JOIN        OT_DWA_DD_BR_BC             J
            ON      A.STD_DT       = J.STD_DT
            AND     A.BRNO         = J.BRNO
            AND     J.BR_DSCD      = '1'   -- �߾�ȸ
            AND     J.FSC_DSCD     = '1'   -- �ſ�
            AND     J.BR_KDCD      < '40'  -- 10:���κμ�,20:������,30:������
//}

//{ #���űݸ������ڵ� #�����ڵ�

-- CASE 1 : �����ڵ� �� �����ڵ���� �ٿ���� ���
,A.GRLN_SIT_DSCD|| CASE WHEN X1.CMN_CD_NM IS NULL THEN '' ELSE '.' || TRIM(X1.CMN_CD_NM) END AS  ���ܴ������������


SELECT     ,A.CLN_IRT_DSCD||'.'||ISNULL(TRIM(X1.CMN_CD_NM),' ')         AS ���űݸ������ڵ��
......
LEFT OUTER JOIN
            OM_DWA_CMN_CD_BC       X1                  -- DWA_�����ڵ�⺻
            ON    A.CLN_IRT_DSCD  = X1.CMN_CD          -- �����ڵ�
            AND   X1.TPCD_NO_EN_NM = 'CLN_IRT_DSCD'    -- �����ڵ��ȣ������



SELECT     ,CASE WHEN A.CLN_RDM_MHCD IS NOT NULL THEN A.CLN_RDM_MHCD || '.' || ISNULL(TRIM(X1.CMN_CD_NM),' ') ELSE '' END    AS   ���Ż�ȯ��������ڵ�
LEFT OUTER JOIN
            OM_DWA_CMN_CD_BC   X1
            ON    A.CLN_RDM_MHCD  = X1.CMN_CD          -- �����ڵ�
            AND   X1.TPCD_NO_EN_NM = 'CLN_RDM_MHCD'    -- �����ڵ��ȣ������

//}


//{  #���������ڵ�
-- CASE 1  ���������ڵ�
SELECT JB_PSTN_CD,JB_PSTN_NM FROM TB_SOR_CUS_JB_PSTN_CD_BC
//}

//{ #�ſ��򰡵�� #���ι�ȣ  #TEMP_�ſ���  #������

-- CASE 1 Ư�������Ϸ� ���� ���� �ֱ��� �������� �������� �����
-- �������α׷� : ���Ż����(20140325)_����ݸ���Ȳ.SQL ����
-- ���ΰ��� ������ �ſ����� ã�� �����̳� ��� ���ΰǿ� �ſ����� ����� ���������� �ǹ�..

CREATE  TABLE  #TEMP_�ſ���
(
             ��������             CHAR(8)
            ,���¹�ȣ             CHAR(20)
            ,����ȣ             NUMERIC(9)
            ,���Ž��ι�ȣ         CHAR(14)
            ,���Ž�û��ǥ��ȣ     CHAR(14)
            ,���Ž�û��ȣ         CHAR(14)
            ,���Ž�û�����ڵ�     CHAR(2)
            ,��������             CHAR(8)
            ,����ſ��򰡸��������ڵ�     CHAR(2)
            ,����ſ��򰡵��     CHAR(3)
            ,CSS���������ڵ�      CHAR(2)
            ,ASS�ſ���          CHAR(3)
            ,���ο��ű���_���������� INT
            ,���ο��ű���_���ν���   INT
            ,���ο��ű���_�ݸ�����   INT
            ,���ν��ο���_��û       INT
);
-- DROP  TABLE #TEMP_�ſ���

BEGIN

  DECLARE  V_BASEDAY   CHAR(8);

  SET   V_BASEDAY  = '20140731';
--  SET   V_BASEDAY  = '20140831';
--  SET   V_BASEDAY  = '20140930';
--  SET   V_BASEDAY  = '20141031';
--  SET   V_BASEDAY  = '20141130';
--  SET   V_BASEDAY  = '20141231';
--  SET   V_BASEDAY  = '20150131';
--  SET   V_BASEDAY  = '20150228';
--  SET   V_BASEDAY  = '20150331';
--  SET   V_BASEDAY  = '20150430';
--  SET   V_BASEDAY  = '20150531';
--  SET   V_BASEDAY  = '20150630';

INSERT  INTO   #TEMP_�ſ���
(
             ��������
            ,���¹�ȣ
            ,����ȣ
            ,���Ž��ι�ȣ
            ,���Ž�û��ǥ��ȣ
            ,���Ž�û��ȣ
            ,���Ž�û�����ڵ�
            ,��������
            ,����ſ��򰡸��������ڵ�
            ,����ſ��򰡵��
            ,CSS���������ڵ�
            ,ASS�ſ���
            ,���ο��ű���_����������
            ,���ο��ű���_���ν���
            ,���ο��ű���_�ݸ�����
            ,���ν��ο���_��û
)

SELECT       V_BASEDAY  AS ��������
            ,A.���¹�ȣ
            ,A.����ȣ
            ,A.���Ž��ι�ȣ
            ,A.���Ž�û��ǥ��ȣ
            ,A.���Ž�û��ȣ
            ,A.���Ž�û�����ڵ�
            ,A.��������
            ,C.�ſ��򰡸���      AS ����ſ��򰡸���
            ,A.����ſ��򰡵��
            ,B.CSS_MODL_DSCD     AS ���νſ��򰡸���
            ,B.ASS_CRDT_GD       AS ASS�ſ���
            ,ISNULL(D.���ο��ű���_����������,0) AS ���ο��ű���_����������
            ,ISNULL(D.���ο��ű���_���ν���,0)  AS ���ο��ű���_���ν���
            ,ISNULL(D.���ο��ű���_�ݸ�����,0)  AS ���ο��ű���_�ݸ�����
            ,CASE WHEN E.���Ž�û��ȣ IS NOT NULL THEN 1 ELSE 0 END   AS ���ν��ο���_��û
            --,C.�����������      --����ſ��򰡵���̶� ����
FROM        (SELECT   A.ACN_DCMT_NO       AS ���¹�ȣ
                     ,A.CUST_NO           AS ����ȣ
                     ,A.CLN_APRV_NO       AS ���Ž��ι�ȣ
                     ,A.APRV_DT           AS ��������
                     ,A.CRDT_EVL_GD       AS ����ſ��򰡵��
                     ,A.CRDT_EVL_NO       AS ����ſ��򰡹�ȣ
                     ,A.CLN_APC_RPST_NO   AS ���Ž�û��ǥ��ȣ
                     ,A.CLN_APC_NO        AS ���Ž�û��ȣ
                     ,A.CLN_APC_DSCD      AS ���Ž�û�����ڵ�

             FROM     TB_SOR_CLI_CLN_APRV_BC  A
                    ,(SELECT   A.ACN_DCMT_NO       AS ���¹�ȣ
                              ,MAX(A.CLN_APRV_NO)  AS ���Ž��ι�ȣ
                      FROM     TB_SOR_CLI_CLN_APRV_BC A  --SOR_CLI_���Ž��α⺻
                             ,(SELECT   ACN_DCMT_NO
                                       ,MAX(APRV_DT)   AS MAX_APRV_DT
                               FROM     TB_SOR_CLI_CLN_APRV_BC  --SOR_CLI_���Ž��α⺻
                               WHERE    APRV_DT            <= V_BASEDAY        --��������
                               AND      CLN_APRV_LDGR_STCD IN ('10','20','21')   --���Ž��ο�������ڵ�(10:����,20:����,21:����Ϸ�)
                               AND      NFFC_UNN_DSCD       = '1'                --�߾�ȸ���ձ����ڵ�(1:�߾�ȸ)
                               GROUP BY ACN_DCMT_NO
                               ) B
                      WHERE    A.APRV_DT            <=  V_BASEDAY        --��������
                      AND      A.CLN_APRV_LDGR_STCD IN ('10','20','21')   --���Ž��ο�������ڵ�(10:����,20:����,21:����Ϸ�)
                      AND      A.NFFC_UNN_DSCD       = '1'                --�߾�ȸ���ձ����ڵ�(1:�߾�ȸ)
                      AND      A.ACN_DCMT_NO         = B.ACN_DCMT_NO
                      AND      A.APRV_DT             = B.MAX_APRV_DT
                      GROUP BY ���¹�ȣ
                      ) B
             WHERE    A.ACN_DCMT_NO        = B.���¹�ȣ
             AND      A.CLN_APRV_NO        = B.���Ž��ι�ȣ
             AND      A.APRV_DT            <=  V_BASEDAY        --��������
             AND      A.CLN_APRV_LDGR_STCD IN ('10','20','21')   --���Ž��ο�������ڵ�(10:����,20:����,21:����Ϸ�)
             AND      A.NFFC_UNN_DSCD      = '1'
             ) A
            ,TB_SOR_PLI_SYS_JUD_RSLT_TR B          --SOR_PLI_�ý��۽ɻ�������
            ,(SELECT   CRDT_EVL_NO        AS �ſ��򰡹�ȣ
                      ,CRDT_EVL_MODL_DSCD AS �ſ��򰡸���
                      ,LST_ADJ_GD         AS �����������
              FROM     TB_SOR_CCR_EVL_INF_TR              --SOR_CCR_����������
              WHERE    CRDT_EVL_PGRS_STCD = '2'           --�ſ�����������ڵ�(2:�򰡿Ϸ�)
              AND      NFFC_UNN_DSCD      = '1'           --�߾�ȸ���ձ����ڵ�(1:�߾�ȸ)
              AND      CMPL_DT           <= V_BASEDAY    --�Ϸ�����
              )  C
            ,(SELECT   A.CLN_APC_NO
                      ,MAX(CASE WHEN A.APCL_DSCD = '1'  THEN 1 ELSE 0 END) AS  ���ο��ű���_����������
                      ,MAX(CASE WHEN A.APCL_DSCD = '2'  THEN 1 ELSE 0 END) AS  ���ο��ű���_���ν���
                      ,MAX(CASE WHEN A.APCL_DSCD = '3'  THEN 1 ELSE 0 END) AS  ���ο��ű���_�ݸ�����
              FROM    (SELECT   CLN_APC_NO
                               ,APCL_DSCD
                       FROM     TB_SOR_IRL_IRT_CALC_TR         --SOR_IRL_�ݸ����⳻��  --SELECT * FROM TB_SOR_IRL_IRT_CALC_TR WHERE  CLN_APC_NO = 'A1201300157709'
                       WHERE    APCL_DSCD IN ('1','2')         --���ο��ű����ڵ�(1:����������,2:���ν���)
                       UNION ALL
                       SELECT   A.CLN_APC_NO
                               ,A.APCL_DSCD
                       FROM     TB_SOR_IRL_IRT_CALC_TR     A   --SOR_IRL_�ݸ����⳻��
                               ,TB_SOR_IRL_IRT_RNX_APRV_BC B   --SOR_IRL_�ݸ�������α⺻  --SELECT * FROM TB_SOR_IRL_IRT_RNX_APRV_BC
                       WHERE    A.CLN_APC_NO        = B.CLN_APC_NO
                       AND      A.APCL_DSCD         = '3'      --���ο��ű����ڵ�(3:�ݸ�����)
                       AND      B.IRT_RNX_PGRS_STCD = '04'     --�ݸ�������������ڵ�(04:���οϷ�)
                      ) A
              GROUP BY A.CLN_APC_NO
             ) D
            ,(
                SELECT   CLN_APC_NO            AS ���Ž�û��ȣ
                FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
                        ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
                WHERE    1=1
                AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
                AND      B.APCL_DSCD         = '2'               -- ���ο��ű����ڵ�(1:����������,2:���ν���)

                UNION ALL

                -- ���ο����� ��� �ɻ�� ����
                SELECT   CLN_APC_NO            AS ���Ž�û��ȣ
                FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
                WHERE    1=1
              )  E

    WHERE    A.����ȣ         *= B.CUST_NO
    AND      A.���Ž�û��ȣ     *= B.CLN_APC_NO
    AND      A.����ſ��򰡹�ȣ *= C.�ſ��򰡹�ȣ
    AND      A.���Ž�û��ȣ     *= D.CLN_APC_NO
    AND      A.���Ž�û��ȣ     *= E.���Ž�û��ȣ
;
END;


-- CASE 2 �űԽ����� ������ �������� ���
/********************************************************************************
*                     ������� �űԽ��� ������ ��������                       *
********************************************************************************/
SELECT      T.���հ��¹�ȣ
           ,B.CLN_APC_NO         AS  ���Ž�û��ȣ
           ,B.CLN_APRV_NO        AS  ���Ž��ι�ȣ
           ,D.CRDT_EVL_NO        AS  �ſ��򰡹�ȣ
           ,D.CRDT_EVL_GD        AS  �ſ��򰡵��
           ,D.STDD_INDS_CLCD     AS  ǥ�ػ���з��ڵ�
           ,F.��з���           AS  ������
           ,E.CMPL_DT            AS  �򰡿Ϸ�����
           ,E.CRDT_EVL_MODL_DSCD AS  �ſ��򰡸���
           ,E.LST_ADJ_GD         AS  �����������  --   D.CRDT_EVL_GD �� ��ġ��, Ȯ���غ����� ����غ�

INTO        #�������_�űԽ�û��ȣ    -- DROP TABLE #�������_�űԽ�û��ȣ

FROM        ( SELECT DISTINCT ���հ��¹�ȣ,�������� FROM  #�������)   T

JOIN
            TB_SOR_CLI_CLN_APC_BC      B    -- SOR_CLI_���Ž�û�⺻
            ON  T.���հ��¹�ȣ      = B.ACN_DCMT_NO
            AND T.��������          = B.AGR_DT             -- ���붧���� �̰� �ɾ���� ���°� �ߺ��ȵȴ�.
            AND B.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- ���Ž�û�����ڵ�(01:�ű�,02:��ȯ)
            AND B.NFFC_UNN_DSCD   = '1'     -- �߾�ȸ
            AND B.APC_LDGR_STCD   = '10'    -- ��û��������ڵ�(01:�ۼ���,02:������,10:�Ϸ�,99:���)
            AND B.CLN_APC_CMPL_DSCD IN ('20','21') -- ���Ž�û�Ϸᱸ���ڵ� -- 09:�ΰ�, 10:���� 18:�����Ĺ����, 20:����, 21:����,17:öȸ
--
--JOIN        TB_SOR_CLI_CLN_APC_RPST_BC C  -- SOR_CLI_���Ž�û��ǥ�⺻
--            ON  B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO

JOIN
            TB_SOR_CLI_CLN_APRV_BC  D   --SOR_CLI_���Ž��α⺻
            ON  B.CLN_APRV_NO  =  D.CLN_APRV_NO

LEFT OUTER JOIN
            TB_SOR_CCR_EVL_INF_TR  E   --SOR_CCR_����������
            ON    D.CRDT_EVL_NO  =  E.CRDT_EVL_NO
            AND   E.CRDT_EVL_PGRS_STCD = '2'           --�ſ�����������ڵ�(2:�򰡿Ϸ�)
            AND   E.NFFC_UNN_DSCD      = '1'           --�߾�ȸ���ձ����ڵ�(1:�߾�ȸ)

LEFT OUTER JOIN
            #TEMP_ǥ�ػ���з�     F
            ON   LEFT(D.STDD_INDS_CLCD, 4) = F.���з��ڵ�
;

-- CASE 3 �ֱ��������� �������� ���
-- CASE1�� �����ֱ� ���γ������� �򰡹�ȣ�� �����ͼ� �������� �������� ���
-- �׿� ���ؼ� �̼ҽ��� ���γ����� �������� �ʰ� �������� ���� �ֱ� �������� �������� ���
-- �� ����� �̼��� �������� ���������� ����.
-- UP_DWZ_����_N0149_����ſ����򰡿���� �ҽ��� �Ϻ�

SELECT      P_��������  AS  ��������
           ,A.�Ǹ��ȣ
           ,A.��������ڵ�
           ,A.����Ը�󼼱����ڵ�
           ,A.��������
           ,A.�����������
           ,A.�򰡿Ϸ���
           ,A.�ſ��򰡱����ڵ�             --  92:����(����)��
           ,A.�������⼱���ڵ�
INTO        #TEMP_�ſ��򰡸���      -- DROP TABLE #TEMP_�ſ��򰡸���
FROM        (SELECT   CASE WHEN B.RPST_RNNO > ' ' THEN B.RPST_RNNO
                           ELSE A.RNNO
                      END                  AS �Ǹ��ȣ
                     ,A.ENTP_FRCD	         AS ��������ڵ�
                     ,A.ENTP_SCL_DTL_DSCD  AS ����Ը�󼼱����ڵ�
                     ,B.CRDT_EVL_MODL_DSCD AS ��������                     -- �ſ��򰡸��������ڵ�
                     ,B.LST_ADJ_GD         AS �����������
                     ,B.CMPL_DT            AS �򰡿Ϸ���
                     ,B.CRDT_EVL_DSCD      AS �ſ��򰡱����ڵ�
                     ,B.UPW_DWTR_CHC_CD	   AS �������⼱���ڵ�
                     ,ROW_NUMBER(*) OVER(PARTITION BY  �Ǹ��ȣ ORDER BY B.CMPL_DT DESC,B.CRDT_EVL_NO DESC) AS RNUM
                        -- �Ǹ��ȣ�� �����Ѱǵ��� ����� ������ �ʿ��ϴ�
             FROM     DWZOWN.TB_SOR_CCR_EVL_BZNS_OTL_TR A        --SOR_CCR_�򰡾�ü���䳻��
                     ,DWZOWN.TB_SOR_CCR_EVL_INF_BC B      --SOR_CCR_�������⺻
                     ,(SELECT   RNNO             AS �Ǹ��ȣ
                               ,CRDT_EVL_NO      AS �ſ��򰡹�ȣ
                               ,ROW_NUMBER(*) OVER(PARTITION BY  RNNO ORDER BY CMPL_DT DESC,CRDT_EVL_NO DESC) AS RNUM
                                 -- �򰡿Ϸ����� ���� ���߰��� �켱, �򰡿Ϸ����� �����ϸ� �򰡹�ȣ�� ū���� ���߰����� ����
                       FROM     DWZOWN.TB_SOR_CCR_EVL_INF_BC               -- (SOR_CCR_�������⺻)
                       WHERE    1=1
                       AND      CRDT_EVL_PGRS_STCD = '2'                   -- �ſ�����������ڵ�(2:�򰡿Ϸ�)
                       AND      NFFC_UNN_DSCD      = '1'                   -- �߾�ȸ���ձ����ڵ�(1:�߾�ȸ)
                       AND      CRDT_EVL_MODL_DSCD  IS NOT NULL  AND CRDT_EVL_MODL_DSCD <> '34'
                       AND      CRDT_EVL_OMT_DSCD  = '02'
                       AND      ST_DT >  '20120813'
                       AND      SMPR_RNNO IS NOT NULL
                         //------------------------------------------------------------------
                         AND    CMPL_DT  <=  P_��������
                         //------------------------------------------------------------------
                      ) C
             WHERE    1=1
               AND    C.RNUM          = 1 -- �򰡳����� �����ֱ��򰡰� ��������
               AND    A.RNNO          = B.RNNO
               AND    A.CRDT_EVL_NO   = B.CRDT_EVL_NO
               AND    B.RNNO          = C.�Ǹ��ȣ
               AND    B.CRDT_EVL_NO   = C.�ſ��򰡹�ȣ
            ) A
WHERE       1=1
AND         A.RNUM = 1
//}


//{   #�űԽ�û��ȣ  #���ʾ��� #�����̷� #���ʾ������ι�ȣ
-- ó�������ǿ� �پ� �ִ� ���ι�ȣ�� ��û��ȣ �������� ����� �űԽ�û��ȣ�������� ���� ��Ȯ�� ����̴�.
-- ������ �̷�������δ� ���������� �űԽ�û���� ���ؿü� ��� �����ϴ� ������ �߰��Ѵ�.
SELECT      A.*
           ,ISNULL(D.CLN_APC_NO,E.CLN_APC_NO)  AS  ���Ž�û��ȣ

INTO        #��üä��    -- DROP TABLE #��üä��
FROM        #TEMP_��üä�� A

LEFT OUTER JOIN
            (
             SELECT      TA.CLN_ACNO
                        ,TA.AGR_DT
                        ,TA.AGR_EXPI_DT
                        ,TA.CLN_APRV_NO
             FROM        DWZOWN.TB_SOR_LOA_AGR_HT       TA
             JOIN        (
                           SELECT   CLN_ACNO
                                   ,AGR_DT
                                   ,MIN(AGR_TR_SNO) AS AGR_TR_SNO    --���¹�ȣ�� �������ں��� �űԾ������� 1���̶�� ������ 2�Ǿ� �����°� ����
                           FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                           WHERE    CLN_APC_DSCD IN ('01','02','04','07','08','09') --���Ž�û�����ڵ� <10 �� �ű԰�
                           --AND      TR_STCD       =  '1'             --�ŷ������ڵ�(1:����) �̰Űɸ� ���°� ����
                           GROUP BY CLN_ACNO,AGR_DT
                         )            TB
                         ON    TA.CLN_ACNO   = TB.CLN_ACNO
                         AND   TA.AGR_TR_SNO = TB.AGR_TR_SNO
            )  B
            ON    A.���հ��¹�ȣ  =  B.CLN_ACNO
            AND   A.��������      =  B.AGR_DT

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APRV_BC   C     -- SOR_CLI_���Ž��α⺻
            ON   B.CLN_APRV_NO  =  C.CLN_APRV_NO

LEFT OUTER JOIN
            TB_SOR_PLI_CLN_APC_BC      D   -- SOR_PLI_���Ž�û�⺻
            ON  C.CLN_APC_NO        = D.CLN_APC_NO

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APC_BC       E   -- SOR_CLI_���Ž�û�⺻
            ON  C.CLN_APC_NO        = E.CLN_APC_NO
;

-- ������ ������û���� ���ο����� ���ؼ� ã�Ƶ��� ��ȿ�� ��û��ȣ�� ã���� ����.
-- �Ʒ� �������� ���� �������� ������ ���ش�.

SELECT      A.CLN_ACNO         AS ���¹�ȣ
           ,A.LN_AGR_DT        AS ��������
           ,MAX(A.CLN_APC_NO)  AS ��û��ȣ
INTO        #TEMP_�űԽ�û��ȣ  --DROP TABLE  #TEMP_�űԽ�û��ȣ
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
WHERE       A.CLN_ACNO          IS NOT NULL
AND         A.CLN_APC_DSCD   BETWEEN  '01' AND '09'         -- �ű�
AND         A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
GROUP BY    A.CLN_ACNO,A.LN_AGR_DT

UNION ALL

SELECT      A.ACN_DCMT_NO      AS ���¹�ȣ
           ,A.AGR_DT           AS ��������
           ,MAX(A.CLN_APC_NO)  AS ��û��ȣ
FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC      A    -- SOR_CLI_���Ž�û�⺻
WHERE       A.ACN_DCMT_NO IS NOT NULL
AND         A.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- ���Ž�û�����ڵ�(01:�ű�,02:��ȯ)
AND         A.NFFC_UNN_DSCD   = '1'     -- �߾�ȸ
AND         A.APC_LDGR_STCD   = '10'    -- ��û��������ڵ�(01:�ۼ���,02:������,10:�Ϸ�,99:���)
AND         A.CLN_APC_CMPL_DSCD IN ('20','21') -- ���Ž�û�Ϸᱸ���ڵ� -- 09:�ΰ�, 10:���� 18:�����Ĺ����, 20:����, 21:����,17:öȸ
GROUP BY    A.ACN_DCMT_NO,A.AGR_DT
;

-- ���Ž�û��ȣ ��� �ִ°͵� ����
UPDATE      #��üä��  A
SET         A.���Ž�û��ȣ  =  B.��û��ȣ
FROM        #TEMP_�űԽ�û��ȣ  B
WHERE       A.���հ��¹�ȣ   = B.���¹�ȣ
AND         A.��������       = B.��������
AND         A.���Ž�û��ȣ IS NULL
;

-- CASE2 ���������߻��� ���Ž�û + ���α����� �̷���� ���Ž�û + ���ε� �̷������ �� ���Ž�û ���   -- ������ �ʿ��� ����
SELECT      CLN_ACNO      AS   ����_���Ű��¹�ȣ
           ,AGR_DT        AS   ����_��������
           ,AGR_TR_SNO    AS   ����_�����ŷ��Ϸù�ȣ
           ,CLN_APC_DSCD  AS   ����_���Ž�û�����ڵ�

           ,CLN_APRV_NO   AS   ����_���Ž��ι�ȣ
           ,ACN_DCMT_NO   AS   ����_���¹�ȣ
           ,CLN_APC_NO    AS   ����_���Ž�û��ȣ
           ,CLN_APC_DSCD  AS   ����_���Ž�û�����ڵ�

           ,CASE WHEN LEFT(B.CLN_APC_NO,2) = 'A1' THEN C.CLN_APC_NO
                 WHEN LEFT(B.CLN_APC_NO,2) = 'A2' THEN D.CLN_APC_NO
                 ELSE NULL
            END           AS    ��û_���Ž�û��ȣ

           ,CASE WHEN LEFT(B.CLN_APC_NO,2) = 'A1' THEN C.CLN_APC_DSCD
                 WHEN LEFT(B.CLN_APC_NO,2) = 'A2' THEN D.CLN_APC_DSCD
                 ELSE NULL
            END           AS    ��û_���Ž�û�����ڵ�

INTO        #TEMP   -- DROP TABLE #TEMP

FROM        TB_SOR_LOA_AGR_HT    A   -- SOR_LOA_�����̷�

JOIN        TB_SOR_CLI_CLN_APRV_BC  B   --SOR_CLI_���Ž��α⺻
            ON  A.CLN_APRV_NO  =  B.CLN_APRV_NO

LEFT OUTER JOIN
            TB_SOR_PLI_CLN_APC_BC    C   -- SOR_PLI_���Ž�û�⺻
            ON  B.CLN_APC_NO        = C.CLN_APC_NO

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APC_BC     D   -- SOR_CLI_���Ž�û�⺻
            ON  B.CLN_APC_NO        = D.CLN_APC_NO
;


SELECT      NULL      AS   ����_���Ű��¹�ȣ
           ,NULL      AS   ����_��������
           ,NULL      AS   ����_�����ŷ��Ϸù�ȣ
           ,NULL      AS   ����_���Ž�û�����ڵ�

           ,CLN_APRV_NO   AS   ����_���Ž��ι�ȣ
           ,ACN_DCMT_NO   AS   ����_���¹�ȣ
           ,CLN_APC_NO    AS   ����_���Ž�û��ȣ
           ,CLN_APC_DSCD  AS   ����_���Ž�û�����ڵ�

           ,CASE WHEN LEFT(B.CLN_APC_NO,2) = 'A1' THEN C.CLN_APC_NO
                 WHEN LEFT(B.CLN_APC_NO,2) = 'A2' THEN D.CLN_APC_NO
                 ELSE NULL
            END           AS    ��û_���Ž�û��ȣ

           ,CASE WHEN LEFT(B.CLN_APC_NO,2) = 'A1' THEN C.CLN_APC_DSCD
                 WHEN LEFT(B.CLN_APC_NO,2) = 'A2' THEN D.CLN_APC_DSCD
                 ELSE NULL
            END           AS    ��û_���Ž�û�����ڵ�

FROM        TB_SOR_CLI_CLN_APRV_BC  B   --SOR_CLI_���Ž��α⺻

LEFT OUTER JOIN
            TB_SOR_PLI_CLN_APC_BC    C   -- SOR_PLI_���Ž�û�⺻
            ON  B.CLN_APC_NO        = C.CLN_APC_NO

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APC_BC     D   -- SOR_CLI_���Ž�û�⺻
            ON  B.CLN_APC_NO        = D.CLN_APC_NO

WHERE       1=1
AND         ����_���Ž��ι�ȣ  NOT IN ( SELECT  ����_���Ž��ι�ȣ FROM  #TEMP)
;

SELECT      NULL      AS   ����_���Ű��¹�ȣ
           ,NULL      AS   ����_��������
           ,NULL      AS   ����_�����ŷ��Ϸù�ȣ
           ,NULL      AS   ����_���Ž�û�����ڵ�

           ,NULL      AS   ����_���Ž��ι�ȣ
           ,NULL      AS   ����_���¹�ȣ
           ,NULL      AS   ����_���Ž�û��ȣ
           ,NULL      AS   ����_���Ž�û�����ڵ�

           ,C.CLN_APC_NO    AS    ��û_���Ž�û��ȣ
           ,C.CLN_APC_DSCD  AS    ��û_���Ž�û�����ڵ�
           ,C.CLN_ACNO      AS    ��û_���Ű��¹�ȣ

FROM        TB_SOR_PLI_CLN_APC_BC    C   -- SOR_PLI_���Ž�û�⺻
WHERE       1=1
AND         ��û_���Ž�û��ȣ  NOT IN ( SELECT  ��û_���Ž�û��ȣ FROM  #TEMP)



UNION  ALL

SELECT      NULL      AS   ����_���Ű��¹�ȣ
           ,NULL      AS   ����_��������
           ,NULL      AS   ����_�����ŷ��Ϸù�ȣ
           ,NULL      AS   ����_���Ž�û�����ڵ�

           ,NULL      AS   ����_���Ž��ι�ȣ
           ,NULL      AS   ����_���¹�ȣ
           ,NULL      AS   ����_���Ž�û��ȣ
           ,NULL      AS   ����_���Ž�û�����ڵ�

           ,D.CLN_APC_NO       AS    ��û_���Ž�û��ȣ
           ,D.CLN_APC_DSCD     AS    ��û_���Ž�û�����ڵ�
           ,D.ACN_DCMT_NO      AS    ��û_���Ű��¹�ȣ

FROM        TB_SOR_CLI_CLN_APC_BC     D   -- SOR_CLI_���Ž�û�⺻
WHERE       1=1
AND         ��û_���Ž�û��ȣ  NOT IN ( SELECT  ��û_���Ž�û��ȣ FROM  #TEMP)
;
//}


//{  #���ʾ��� #���ο���
FROM
            (          -- �������� ���ʾ����� ���ϱ�
             SELECT  A.CLN_ACNO
                    ,B.CLN_APRV_NO
                    ,B.AGR_DT
                    ,B.TR_STCD
             FROM    TB_SOR_LOA_ACN_BC A
             INNER JOIN
                     TB_SOR_LOA_AGR_HT   B
                     ON         A.CLN_ACNO = B.CLN_ACNO
                     AND        B.CLN_TR_KDCD NOT IN ('130','131')  --ä���μ� ����
                     AND        B.CLN_TR_KDCD IN ('100')            -- ���Ž�û�����ڵ� �űԾ���
                     AND        B.CLN_APRV_NO IS NOT NULL
                     AND        A.NFFC_UNN_DSCD = '1'
             INNER JOIN
                     (
                      SELECT    A.CLN_ACNO
                               ,MAX(A.AGR_TR_SNO) AS MAX_SNO
                      FROM      TB_SOR_LOA_AGR_HT A
                      WHERE     A.CLN_TR_KDCD NOT IN ('130','131')  --ä���μ� ����
                      AND       A.CLN_TR_KDCD IN ('100')            -- ���Ž�û�����ڵ� �űԾ���
                      AND       A.CLN_APRV_NO IS NOT NULL
                      AND       A.ENR_DT <=   '20170831'
                      GROUP BY  A.CLN_ACNO
                     ) C
                     ON  B.CLN_ACNO   = C.CLN_ACNO
                     AND B.AGR_TR_SNO = C.MAX_SNO
              WHERE  1=1
              //=========================================================================
              AND    A.CLN_ACNO IN  (SELECT   DISTINCT ���¹�ȣ  FROM #������_�ܾ� )
              //=========================================================================
            ) A

INNER JOIN              -- ���ʾ������� ��û��ȣ�� �������� ���Ͽ� ���ο����� �д´�
            TB_SOR_CLI_CLN_APRV_BC B --SELECT CLN_APC_DSCD, CLN_APRV_LDGR_STCD, CLN_APC_NO FROM TB_SOR_CLI_CLN_APRV_BC WHERE CLN_APRV_NO = 'P1201600179215'
            ON       A.CLN_APRV_NO = B.CLN_APRV_NO
            AND      B.CLN_APC_DSCD != '51'
            AND      B.CLN_APRV_LDGR_STCD IN ('20','21') --AND A.CLN_ACNO = '321006763199'

//}

//{ #�ſ뵵�Ǵ� #�ſ뵵�Ǵ������뺸
SELECT          A.CUST_NO
                   ,B.CRIN_ENR_RSCD     AS �ſ�������ϻ����ڵ�      ,TRIM(C.�ڵ��) AS �ſ�������ϻ����ڵ��
FROM           DWZOWN.TB_SOR_CUS_MAS_BC                   A
JOIN             TT_SOR_LOE_MM_CDJI_DPC_DL                  B   --  SOR_LOE_���ſ뵵�Ǵ������뺸��
                    ON  A.CUST_RNNO   =   B.RNNO
-- ���λ���ڿ� ���λ���ڴ� ���࿬��ȸ���� ���λ������ ��� ����ڹ�ȣ�� �����ֹι�ȣ, ���λ������ ���
-- ���ι�ȣ�� ����ڹ�ȣ�� ���� �������� �����Ͱ� �����Ƿ� ���νǸ��ȣ�� ����ڹ�ȣ�������� ������� �츮 �������
-- �̷������� ������ �Ͽ� ����ϴµ� ������ ����
                    AND B.STD_YM ='201403'
                    AND B.UNN_CD = '999'                -- 999:�߾�ȸ+����, 998:����  999����� �ߺ��ȵ�
                    AND (        B.RLS_ACP_DT  IS NULL
                             OR  B.RLS_ACP_DT = '00000000'
                        )  -- ������������
JOIN                (
                         SELECT   CMN_CD
                                 ,TRIM(CMN_CD_NM)    AS �ڵ��
                         FROM     OM_DWA_CMN_CD_BC
                         WHERE    TPCD_NO_EN_NM = 'CRIN_ENR_RSCD'  -- �ſ�������ϻ����ڵ�
                         AND      CMN_CD_US_YN = 'Y'
                         ORDER BY CMN_CD
                    )    C
                    ON   B.CRIN_ENR_RSCD =  C.CMN_CD
//}

//{ #������  #��ȿ�� #������
FROM                DWZOWN.TB_SOR_CUS_MAS_BC                   A
WHERE               1=1
AND                 A.CUST_AVL_CD   = '1' -- ����ȿ�ڵ� 1: �ŷ���
                     -- ����,����,�ܱ����� �� �Ǹ����� �ŷ��� �ɼ� �ֱ⶧���� �ŷ����̰�
                     -- ���λ����, ���ε�Ϲ�ȣ , BIC�ڵ���� �� ��ȣ�� �ŷ��� �ȵǱ⶧���� �ŷ����� �ƴ�
AND                 A.CUST_INF_STCD = '1' -- �����������ڵ� 1: ����, 2.�����Ǹ�, 3.����
//}

//{ #�����̷�  #��������
-- CASE 1   ���º� ������������� ����
JOIN
            ( -- ���� ���ѿ������� ����
             SELECT   TA.CLN_ACNO
                     ,TA.ENR_DT      AS ������
                     ,TA_AGR_EXPI_DT AS ����������
             FROM     DWZOWN.TB_SOR_LOA_AGR_HT       TA
                     ,(SELECT   CLN_ACNO
                               ,MAX(AGR_TR_SNO) AS AGR_TR_SNO    --�����ŷ��Ϸù�ȣ(�������ѿ����� �����ŷ��Ϸù�ȣ)
                       FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                       WHERE    CLN_APC_DSCD IN ('11','12','13') --���Ž�û�����ڵ�(11:���ѿ���,12:���ѿ��������,13:���ѿ�������Ǻ���)
                       AND      TR_STCD       =  '1'             --�ŷ������ڵ�(1:����)
                       GROUP BY CLN_ACNO)            TB
             WHERE    TA.CLN_ACNO   = TB.CLN_ACNO
             AND      TA.AGR_TR_SNO = TB.AGR_TR_SNO
            )                                          B
            ON   A.CLN_ACNO  = B.CLN_ACNO

-- CASE 2  ���º� �űԾ����� ��������, �űԾ����� ������ ��������
LEFT OUTER JOIN
            (
             SELECT      TA.CLN_ACNO
                        ,TA.AGR_DT
                        ,TA.AGR_EXPI_DT

             FROM        DWZOWN.TB_SOR_LOA_AGR_HT       TA
             JOIN        (
                           SELECT   CLN_ACNO
                                   ,AGR_DT
                                   ,MAX(AGR_TR_SNO) AS AGR_TR_SNO    --���¹�ȣ�� �������ں��� �űԾ������� 1���̶�� ������ 2�Ǿ� �����°� ����
                           FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                           WHERE    CLN_APC_DSCD IN ('01','02','04','07','08','09') --���Ž�û�����ڵ� <10 �� �ű԰�
                           AND      TR_STCD       =  '1'             --�ŷ������ڵ�(1:����)
                           GROUP BY CLN_ACNO,AGR_DT
                         )            TB
                         ON    TA.CLN_ACNO   = TB.CLN_ACNO
                         AND   TA.AGR_TR_SNO = TB.AGR_TR_SNO
            )  B
            ON    A.INTG_ACNO   =  B.CLN_ACNO
            AND   A.AGR_DT      =  B.AGR_DT
//}

//{ #��������  #������ #���� #����

-- CASE 1 ���� �̼������� �̴¹�
-- �������α׷� : ���絿(20140715)_���絿�����̰�ä�Ǹ�.SQL
-- ������ ����� ������ ������ ���ڵ�� ������ �̷�������� �Ѱ����� ���� ���⸦ ������ SQL
FROM
(
         SELECT    A.ACNO
                  ,A.MVT_MVN_SNO
                  ,A.MVT_MVN_DSCD
                  ,A.ENR_DT
                  ,A.ENR_BRNO
                  ,B.MVT_MVN_SNO
                  ,B.MVT_MVN_DSCD
                  ,B.ENR_DT
                  ,B.ENR_BRNO
                  ,CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  AS ������
                  ,CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  AS ������
                  ,CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_DT ELSE B.ENR_DT END      AS ��������
                  ,CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_DT ELSE B.ENR_DT END      AS ��������
         FROM      TB_SOR_DEP_MVT_MVN_TR   A
         JOIN      TB_SOR_DEP_MVT_MVN_TR   B
                   ON  A.ACNO  =  B.ACNO
                   AND A.MVT_MVN_SNO + 1 = B.MVT_MVN_SNO
         WHERE     (  A.RLS_DT   IS NULL  OR  A.RLS_DT = ''  )
         AND       CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  = '0058'  -- ������ ���絿����
         AND       CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  = '0018'  -- ������ �����ǿ��Ű�������
         AND       A.ENR_DT   BETWEEN  '20120630'  AND  '20140711'     -- ��� ��������
)        A

--  ���տ����� �̿��ؼ� �������� ��ġ��
SELECT   DISTINCT INTG_ACNO,MVT_BRNO,FRPP_KDCD
FROM
(
SELECT    INTG_ACNO,MVT_BRNO,FRPP_KDCD
FROM      OT_DWA_INTG_CLN_BC
WHERE     STD_DT =  '20140630'
AND       BRNO  = '0018'
AND       MVT_BRNO = '0058'
AND       MIMO_STD_DT  BETWEEN  '20120630'  AND  '20140711'

UNION  ALL

SELECT    INTG_ACNO,MVT_BRNO,FRPP_KDCD
FROM      OT_DWA_INTG_CLN_BC
WHERE     STD_DT =  '20131231'
AND       BRNO  = '0018'
AND       MVT_BRNO = '0058'
AND       MIMO_STD_DT  BETWEEN  '20120630'  AND  '20140711'

UNION ALL

SELECT    INTG_ACNO,MVT_BRNO,FRPP_KDCD
FROM      OT_DWA_INTG_CLN_BC
WHERE     STD_DT =  '20121231'
AND       BRNO  = '0018'
AND       MVT_BRNO = '0058'
AND       MIMO_STD_DT  BETWEEN  '20120630'  AND  '20140711'
)  A


-- CASE 2   ���ʰ������� �����Գ����� ���ٷ� �ö󰡼� ã�� ���
--  1. �Ϲݿ���
LEFT OUTER JOIN
            (
               SELECT   A.��������ȣ
                       ,A.�������¹�ȣ
                       ,CASE WHEN A.������¹�ȣ IS NULL THEN A.�������¹�ȣ ELSE A.������¹�ȣ END AS ������¹�ȣ
                       ,A.��������
               FROM
               (
                    SELECT   MVT_BRNO   AS ��������ȣ
                        ,MVN_BRNO   AS ��������ȣ
                        ,MVT_DT     AS ��������
                        ,MVN_DT     AS ��������
                        ,CLN_ACNO   AS ���Ű��¹�ȣ
                        ,CLN_EXE_NO AS ���Ž����ȣ
                        ,LN_RMD     AS �����ܾ�
                        ,MVT_ACNO   AS ������¹�ȣ
                        ,MVN_ACNO   AS ���԰��¹�ȣ
                        ,CASE WHEN TRIM(LST_ACNO) IS NULL OR LST_ACNO = ''  THEN CLN_ACNO ELSE LST_ACNO END   AS �������¹�ȣ
                        ,ROW_NUMBER() OVER(PARTITION BY CLN_ACNO ORDER BY MVT_DT ASC ,SNO  ASC) AS ����
                    FROM     TB_SOR_LOA_MVN_MVT_HT
                    WHERE    1=1
                    AND      CASE WHEN TRIM(LST_ACNO) IS NULL OR LST_ACNO = ''  THEN CLN_ACNO ELSE LST_ACNO END IN ( SELECT  ���¹�ȣ FROM #������_�ߺ�����)
               )     A
               WHERE       1=1
               AND         A.���� = 1
            )  B
            ON    A.���¹�ȣ  = B.�������¹�ȣ

--  2. ����
LEFT OUTER JOIN
            (
               SELECT     A.��������ȣ
                         ,A.���¹�ȣ AS �������¹�ȣ
                         ,A.���¹�ȣ AS ������¹�ȣ  -- ���������� �����԰ǿ� ���� ������´� ���Ҽ��� ��� ������·� ����� 2��
                         ,A.��������
               FROM
               (
                 SELECT    A.ACNO                AS ���¹�ȣ
                          ,B.MVT_MVN_AMT         AS �����Աݾ�
                          ,A.ENR_BRNO            AS ��������ȣ
                          ,B.ENR_BRNO            AS ��������ȣ
                          ,A.ENR_DT              AS ��������
                          ,B.ENR_DT              AS ��������
                          ,ROW_NUMBER() OVER(PARTITION BY A.ACNO ORDER BY A.MVT_MVN_SNO ASC) AS ����
                 FROM      TB_SOR_DEP_MVT_MVN_TR   A
                 JOIN      TB_SOR_DEP_MVT_MVN_TR   B
                           ON  A.ACNO  =  B.ACNO
                           AND A.MVT_MVN_SNO + 1 = B.MVT_MVN_SNO
                           AND B.MVT_MVN_DSCD = '3'       -- ����
                           AND ( B.RLS_DT   IS NULL  OR  B.RLS_DT = ''  )
                 WHERE     ( A.RLS_DT   IS NULL  OR  A.RLS_DT = ''  )
                 AND       A.MVT_MVN_DSCD  = '1'  -- ����
                 AND       A.ENR_BRNO  NOT IN ('0018','0805','0542','0090')   -- �������� �Ϲݿ�����
                 AND       A.ACNO    IN ( SELECT  ���¹�ȣ FROM #������_�ߺ�����)

               )   A
               WHERE  ���� = 1
            )   C
            ON    A.���¹�ȣ  = C.�������¹�ȣ


-- CASE 3 ������ �̼��� �������� �̴¹�

-- 1. ���� ������
SELECT      A.ACNO     AS   ���¹�ȣ
           ,CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  AS ������
           ,CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  AS ������
--           ,CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_DT ELSE B.ENR_DT END      AS ��������
           ,CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_DT ELSE B.ENR_DT END      AS ��������
FROM        TB_SOR_DEP_MVT_MVN_TR   A
JOIN        TB_SOR_DEP_MVT_MVN_TR   B
            ON  A.ACNO  =  B.ACNO
            AND A.MVT_MVN_SNO + 1 = B.MVT_MVN_SNO
WHERE       (  A.RLS_DT   IS NULL  OR  A.RLS_DT = ''  )
AND         CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_BRNO ELSE B.ENR_BRNO END IN ('0610','0818')  -- ������ �����������
--AND         CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  = '0018'  -- ������ �����ǿ��Ű�������
AND         A.ENR_DT   BETWEEN  '20150101'  AND  '20161130'     -- ��� ��������

�������� �̰������� ����
select * from OT_DWA_DD_BR_BC
where   brno in ('0872','0070')  -- 0070 �����߾�����, 0872 ����5��������
and std_dt = '20161220'


-- 2.�Ϲݿ��� ������
SELECT      CLN_ACNO    AS ���¹�ȣ
           ,MVT_BRNO    AS ������
--           ,MVT_DT     AS ��������
           ,MVN_BRNO    AS ������
           ,MAX(MVN_DT) AS ��������
--           ,CLN_ACNO   AS ���Ű��¹�ȣ
--           ,CLN_EXE_NO AS ���Ž����ȣ
--           ,LN_RMD     AS �����ܾ�
--           ,MVT_ACNO   AS ������¹�ȣ
--           ,MVN_ACNO   AS ���԰��¹�ȣ
--           ,CASE WHEN TRIM(LST_ACNO) IS NULL OR LST_ACNO = ''  THEN CLN_ACNO ELSE LST_ACNO END   AS �������¹�ȣ
--           ,ROW_NUMBER() OVER(PARTITION BY CLN_ACNO ORDER BY MVT_DT ASC ,SNO  ASC) AS ����
INTO        #TEMP         -- DROP TABLE #TEMP
FROM        TB_SOR_LOA_MVN_MVT_HT
WHERE       1=1
AND         MVT_BRNO IN  ('0610','0818')
AND         MVN_DT   BETWEEN  '20150101'  AND  '20161130'
GROUP  BY   CLN_ACNO
           ,MVT_BRNO
           ,MVN_BRNO


-- 3. �ſ�ī��

SELECT      A.CRD_MBR_NO    AS   ī��ȸ����ȣ
           ,A.MVT_APC_BRNO  AS   ������
           ,A.MVN_PCS_BRNO  AS   ������
           ,A.MVT_APC_DT    AS   ������
           ,A.MVN_PCS_DT    AS   ������

INTO        #TEMP            -- DROP TABLE #TEMP

FROM        DWZOWN.TB_SOR_MBR_ADM_BR_MVN_TR   A
WHERE       1=1
AND         A.MIMO_PGRS_STCD   = '2'            -- ����������������ڵ� : '2'(���Ե��)
AND         A.MVN_PCS_YN       = 'Y'            -- ����ó������
AND         A.MVN_PCS_DT      BETWEEN  '20150101'  AND  '20161130'     -- ��� ��������
AND         A.MVT_APC_BRNO  IN  ('0610','0818')

-- 4  KPS

SELECT      ī���ȣ
           ,LEFT(��������Ͻ�, 8)
           ,�̰�����ȣ
           ,��������ȣ
FROM        TB_CCCMKPS�̼�������
WHERE       �̼�������     = '4'
  AND       �̼����������� = '1'
  AND       �̰�����ȣ IN  ('0610','0818')
  AND       ��������Ͻ�  BETWEEN  '20150101'  AND  '20161130'

UNION ALL

SELECT      B.ī���ȣ
           ,LEFT(A.��������Ͻ�, 8)
           ,A.�̰�����ȣ
           ,A.��������ȣ
FROM        TB_CCCMKPS�̼�������     A
           ,TB_CCCMKPS�̼����������� B
WHERE       A.�̼���������� = B.�̼����������
AND         A.��ϼ���       = B.��ϼ���
AND         A.����ڵ�       = B.����ڵ�
AND         A.�̼�������     = '4'
AND         A.�̼����������� = '0'
AND         B.��������       = '2'
AND         A.�̰�����ȣ IN  ('0610','0818')
AND         A.��������Ͻ�  BETWEEN  '20150101'  AND  '20161130'


--  5  GPC

SELECT      A.ī���ȣ                       AS ī���ȣ
           ,LEFT(A.��������Ͻ�, 8)          AS ��������
           ,A.�̰�����ȣ                     AS �̰�����ȣ
           ,A.��������ȣ                     AS ��������ȣ
FROM        TB_CCCMGPC�̼�������        A
WHERE       1=1
AND         A.�̼�������    = '4'
AND         A.�̰�����ȣ  IN  ('0610','0818')
AND         LEFT(A.��������Ͻ�, 8)  BETWEEN  '20150101'  AND  '20161130'


-- 6  ��ȯ
SELECT      REF_NO
           ,MVT_DT    ��������
           ,MVT_BRNO  ��������ȣ
           ,MVN_DT    ��������
           ,MVN_BRNO  ��������ȣ

FROM        TB_SOR_FEC_FRXC_REF_FLX_TR   A  -- SOR_FEC_��ȯREF��������
WHERE       1=1
AND         A.REF_FLX_DSCD =  '1'  -- REF���������ڵ�(1:��������)
AND         A.MVT_BRNO  IN  ('0610','0818')
AND         A.MVN_DT  BETWEEN  '20150101'  AND  '20161130'
;


//}

//{ #���ô㺸 #�ſ���� #�����ڱݴ���
SELECT
......
           ,CASE WHEN A.STD_DT < '20120101'  THEN
                      CASE WHEN ((A.BS_ACSB_CD IN ('15005811','15006211','15006311','16006011','16006111','16010811') AND
                                  A.MRT_CD IN ('101','102','103','104','105','170','109','111')) OR
                                  A.BS_ACSB_CD = '14000611')
                                 THEN '1. ���ô㺸����'
                           WHEN  (A.MRT_CD < '100' OR A.MRT_CD IN ('601','602')) THEN '2. �ſ����'
                           ELSE '3. ��Ÿ'
                      END
                 ELSE
                      CASE WHEN ((A.BS_ACSB_CD IN ('15005811','15006211','15006311','16006011','16006111','16010811') AND
                                  A.MRT_CD IN ('101','102','103','104','105','170','109','420','421','422','423','512','521')) OR
                                  A.BS_ACSB_CD = '14000611')
                           THEN '1. ���ô㺸����'
                           WHEN  (A.MRT_CD < '100' OR A.MRT_CD IN ('601','602')) THEN '2. �ſ����'
                           ELSE '3. ��Ÿ'
                      END
                 END                               AS ����㺸����
..........
FROM        OT_DWA_INTG_CLN_BC A

JOIN        (
              SELECT   STD_DT
                      ,ACSB_CD
                      ,ACSB_NM
                      ,ACSB_CD4  --��ȭ�����
                      ,ACSB_NM4
                      ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                      ,ACSB_NM5
              FROM     OT_DWA_DD_ACSB_TR
              WHERE    FSC_SNCD IN ('K','C')
--            AND      ACSB_CD4 = '13000801'                      --��ȭ�����
              AND      ACSB_CD5 IN ('14002501')     --�����ڱݴ����
           )           C
           ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS���������ڵ�
           AND      A.STD_DT       =   C.STD_DT

//}

//{ #����ڱݴ��� #���� #�߼ұ�� #���λ���� #�߰߱��
SELECT
...........

           ,CASE WHEN C.ACSB_CD5 = '14002401' THEN --���
             CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999'
                    AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014����� 88�� ������� ���Խ�Ų��.
                  THEN CASE WHEN ISNULL(D.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.����'  ELSE '2.�߼ұ��'  END
             ELSE '3.���λ����'
             END
            END                               AS �������
...........


FROM          OT_DWA_INTG_CLN_BC A
JOIN          (
                SELECT   STD_DT
                        ,ACSB_CD
                        ,ACSB_NM
                        ,ACSB_CD4  --��ȭ�����
                        ,ACSB_NM4
                        ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                        ,ACSB_NM5
                FROM     OT_DWA_DD_ACSB_TR
                WHERE    FSC_SNCD IN ('K','C')
--              AND      ACSB_CD4 = '13000801'        --��ȭ�����
                AND      ACSB_CD5 IN ('14002401')     --����ڱݴ����
             )           C
             ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS���������ڵ�
             AND      A.STD_DT       =   C.STD_DT

LEFT OUTER JOIN
             DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_����Ը�⺻
             ON     A.RNNO      = D.RNNO
             AND    A.STD_DT    = (  SELECT  MAX(STD_DT) FROM DWZOWN.OT_DWA_ENTP_SCL_BC WHERE STD_DT <= '20160301' )


--CASE2 �߰߱�����
           ,CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999' AND
                      SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014����� 88�� ������� ���Խ�Ų��.
                   THEN CASE WHEN   ISNULL(D.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.����'
                             WHEN   D1.BRN IS NOT NULL THEN '2.�߰߱��'
                             ELSE   '3.�߼ұ��'
                        END
                 ELSE '4.���λ����'
            END                          AS  �������


LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_����Ը�⺻
            ON     A.RNNO      = D.RNNO
            AND    A.STD_DT    = D.STD_DT

LEFT OUTER JOIN
            (
             SELECT DISTINCT BRN
             FROM  TB_SOR_CCR_KIS_BZNS_BC
             WHERE KIS_ENTP_SCL_DSCD = '3'
            )   D1
            ON     A.RNNO =  D1.BRN

//}

//{ #���λ����  #����з��ڵ�  #���δ�ǥ��  #��ǥ��

<UP_DWZ_����_N0051_��������Ȳ_�ڱݺ�>
-- �����ڱݴ�����϶��� �Ʒ� �ӽ����̺��� ����з��ڵ带 ���� �ʵ��� �ؾ��Ѵ�
-- ������ ����з��ڵ�� '99999' �� ���;� �Ѵ�
SELECT      A.CUST_NO        AS ���ΰ���ȣ
           ,A.CUST_RNNO      AS ���νǸ��ȣ
           ,C.CUST_RNNO      AS ���λ���ڽǸ��ȣ
           ,A.PRV_BRN        AS ���λ���ڵ�Ϲ�ȣ
           ,B.CUST_NO        AS ����ڰ���ȣ
           ,A.STDD_INDS_CLCD AS ���λ���з��ڵ�
           ,C.STDD_INDS_CLCD AS ���λ���ڻ���з��ڵ�
INTO        #TEMP_���λ���ڻ���з��ڵ�
FROM        OM_DWA_INTG_CUST_BC  A  --DWA_���հ��⺻
           ,TB_SOR_CUS_RLT_BC    B  --SOR_CUS_������⺻
           ,OM_DWA_INTG_CUST_BC  C
WHERE       B.CUST_INF_STCD = '1'   --����
AND         B.CUST_RLT_DSCD = '03'  --���λ����
AND         B.CUST_RLT_DTL_CD = '09' -- ��������ڵ�(09:��ǥ��)
AND         B.MNBD_BZPL_YN = 'Y'   --��ü����忩��
-- �ϳ��� ���� ����������� ������ �Ҷ� ���� �ֵ� ������� �����Ѵ�, �̰� y ���� ������ �ϳ��� ���� ���λ���ڹ�ȣ�� ������ ���´�
--    AND     B.MNBD_RPST_YN = 'Y'   --��ü��ǥ����
-- �ϳ��� ����忡 �������� ��ǥ�� �����Ҷ� '��ǥ���� ��ǥ��'�ΰ��� ǥ���ϱ� ����, �� ������ ���� �ʾƵ� ���ΰ���ȣ���� ������ ������ ������ ����
-- �ٸ� Y �� �ɾ������ ���λ������ ����з��ڵ带 �������� ����� �پ���.
-- ���տ��ſ��� �� ������ �Ȱɷ��ְ� 'UP_DWZ_����_N0051_��������Ȳ_�ڱݺ�' ���� ������ �ɷ��־ 51�� ���ν����� ����� ���տ����� ����� ���� �ٸ���.
AND         A.CUST_NO       = B.RLT_CUST_NO
AND         B.CUST_NO       = C.CUST_NO
;

--������з��ڵ带 �����ö� ���λ���ڶ����� �����ܰ踦 ���ľ��Ѵ�.
SELECT      CUST_NO
           ,STDD_INDS_CLCD
INTO        #TEMP_��������з��ڵ�
FROM        OM_DWA_INTG_CUST_BC
WHERE       CUST_NO  NOT IN (SELECT ���ΰ���ȣ   FROM #TEMP_���λ���ڻ���з��ڵ�)

UNION ALL

SELECT      ���ΰ���ȣ
           ,���λ���ڻ���з��ڵ�
FROM        #TEMP_���λ���ڻ���з��ڵ�

</UP_DWZ_����_N0051_��������Ȳ_�ڱݺ�>


<���Ż����(20160520)_�������10���̻�űԿ��Űŷ�ó��>

-- ���λ���� �ӽ����̺�
SELECT      A.CUST_NO        AS ���ΰ���ȣ
           ,A.CUST_RNNO      AS ���νǸ��ȣ
           ,A.CUST_NM        AS ���μ���
           ,C.CUST_NM        AS ���λ���ڻ�ȣ��
           ,C.CUST_RNNO      AS ���λ���ڽǸ��ȣ
           ,A.PRV_BRN        AS ���λ���ڵ�Ϲ�ȣ
           ,B.CUST_NO        AS ����ڰ���ȣ
           ,A.MBTL_DSCD || A.MBTL_TONO || A.MBTL_SNO   AS ���ΰ��޴���ȭ
           ,C.BZPL_TL_ARCD  || C.BZPL_TL_TONO || C.BZPL_TL_SNO   AS ���λ���ڻ������ȭ
INTO        #TEMP_���λ���ڸ���    --DROP TABLE #TEMP_���λ���ڸ���
FROM        OM_DWA_INTG_CUST_BC  A  --DWA_���հ��⺻
           ,TB_SOR_CUS_RLT_BC    B  --SOR_CUS_������⺻
           ,OM_DWA_INTG_CUST_BC  C  --DWA_���հ��⺻
WHERE       B.CUST_INF_STCD = '1'   --����
AND         B.CUST_RLT_DSCD = '03'  --���λ����
AND         B.CUST_RLT_DTL_CD = '09' -- ��������ڵ�(09:��ǥ��)
AND         B.MNBD_BZPL_YN = 'Y'   --��ü����忩��
-- �ϳ��� ���� ����������� ������ �Ҷ� ���� �ֵ� ������� �����Ѵ�, �̰� y ���� ������ �ϳ��� ���� ���λ���ڹ�ȣ�� ������ ���´�
--    AND     B.MNBD_RPST_YN = 'Y'   --��ü��ǥ����
-- �ϳ��� ����忡 �������� ��ǥ�� �����Ҷ� '��ǥ���� ��ǥ��'�ΰ��� ǥ���ϱ� ����, �� ������ ���� �ʾƵ� ���ΰ���ȣ���� ������ ������ ������ ����
-- �ٸ� Y �� �ɾ������ ���λ������ ����з��ڵ带 �������� ����� �پ���.
-- ���տ��ſ��� �� ������ �Ȱɷ��ְ� 'UP_DWZ_����_N0051_��������Ȳ_�ڱݺ�' ���� ������ �ɷ��־ 51�� ���ν����� ����� ���տ����� ����� ���� �ٸ���.
AND         A.CUST_NO       = B.RLT_CUST_NO
AND         B.CUST_NO       = C.CUST_NO
;

-- ���δ�ǥ�� �ӽ����̺�
SELECT      A.CUST_NO         AS ���ΰ���ȣ
           ,A.CUST_RNNO       AS ���νǸ��ȣ
           ,A.CUST_NM         AS ���θ�

           ,C.CUST_NO         AS ���δ�ǥ�ڰ���ȣ
           ,C.CUST_RNNO       AS ���δ�ǥ�ڽǸ��ȣ
           ,C.CUST_NM         AS ���δ�ǥ�ڼ���
           ,A.BZPL_TL_ARCD || A.BZPL_TL_TONO || A.BZPL_TL_SNO  AS �������ȭ��ȣ
           ,D.MBTL_DSCD||D.MBTL_TONO||D.MBTL_SNO               AS ��ǥ���޴���ȭ��ȣ
INTO        #���δ�ǥ�ڸ���           --DROP TABLE #���δ�ǥ�ڸ���
FROM        OM_DWA_INTG_CUST_BC    A  --DWA_���հ��⺻
           ,TB_SOR_CUS_RLT_BC      B  --SOR_CUS_������⺻
           ,OM_DWA_INTG_CUST_BC    C
           ,TB_SOR_CUS_ETC_TL_DL D
WHERE       B.CUST_INF_STCD = '1'   --����
AND         B.CUST_RLT_DSCD = '02'  --���λ����
AND         B.CUST_RLT_DTL_CD = '09' -- ��ǥ��
AND         B.MNBD_RPST_YN = 'Y'   --��ü��ǥ����
AND         A.CUST_NO       = B.CUST_NO
AND         B.RLT_CUST_NO   = C.CUST_NO
AND         B.RLT_CUST_NO  *= D.CUST_NO
AND         A.CUST_DSCD     = '02'            --�������ڵ�:���λ����
;

SELECT      A.���ΰ���ȣ          AS   ����ȣ
           ,A.���λ���ڻ�ȣ��      AS   ��ü��
           ,A.���μ���              AS   ��ǥ�ڸ�
           ,A.���ΰ��޴���ȭ      AS   �޴�����ȣ
           ,A.���λ���ڻ������ȭ  AS   �繫����ȭ

INTO        #���ӽ�  -- DROP TABLE #���ӽ�

FROM        #TEMP_���λ���ڸ���  A

UNION ALL

SELECT      A.���ΰ���ȣ          AS   ����ȣ
           ,A.���θ�                AS   ��ü��
           ,A.���δ�ǥ�ڼ���        AS   ��ǥ�ڸ�
           ,A.��ǥ���޴���ȭ��ȣ    AS   �޴�����ȣ
           ,A.�������ȭ��ȣ        AS   �繫����ȭ
FROM        #���δ�ǥ�ڸ���       A

UNION ALL

SELECT      A.CUST_NO               AS   ����ȣ
           ,A.CUST_NM               AS   ��ü��
           ,A.CUST_NM               AS   ��ǥ�ڸ�
           ,A.MBTL_DSCD || A.MBTL_TONO || A.MBTL_SNO             AS �޴�����ȣ
           ,A.BZPL_TL_ARCD  || A.BZPL_TL_TONO || A.BZPL_TL_SNO   AS �繫����ȭ
FROM        OM_DWA_INTG_CUST_BC  A
WHERE       CUST_NO NOT IN ( SELECT  ���ΰ���ȣ     FROM #TEMP_���λ���ڸ���
                             UNION
                             SELECT  ���ΰ���ȣ     FROM #���δ�ǥ�ڸ���
                            )
;
</���Ż����(20160520)_�������10���̻�űԿ��Űŷ�ó��>
//}

//{ #���ҵ�
--CASE 1  UP_DWZ_����_N0051_��������Ȳ_�ڱݺ� ���� ����ϴ� ���
--������û�ǿ� ��ϵ� ���ҵ� �������� ����
    SELECT   A.CLN_ACNO          AS ���¹�ȣ
            ,B.CUST_NO           AS ����ȣ      -- �Ѱ��¿� ��������� �ҵ��� ��ϵǾ� ������ �־ ���ֿ� ����ȣ�� �����ؾ���
            ,MAX(B.FRYR_ICM_AMT) AS ���ҵ�ݾ�
    INTO     #TEMP���ҵ�
    FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC      A     --SOR_PLI_���Ž�û�⺻
            ,DWZOWN.TB_SOR_PLI_APC_POT_CUST_TR B     --SOR_PLI_��û����������
    WHERE    A.CLN_ACNO > ' '
      AND    A.CLN_APC_PGRS_STCD  ='04'       --���Ž�û��������ڵ�(04:����Ϸ�)
      AND    A.NFFC_UNN_DSCD      = '1'       --�߾�ȸ���ձ����ڵ�
      -------JOIN  A:B
      AND    A.CLN_APC_NO = B.CLN_APC_NO
      AND    B.FRYR_ICM_AMT > 0         -- ���ҵ��� ������ ��û�Ǹ� �������
    GROUP BY A.CLN_ACNO
            ,B.CUST_NO
    ;


--CASE 2  �űԽ�û�ǿ� ��ϵǾ� �ִ� ���ҵ� ��������
SELECT   B.��������
        ,A.CLN_ACNO
        ,C.CUST_RNNO
        ,C.CUST_NO
        ,B.���Ž�û��ȣMAX
        ,ISNULL(F.FRYR_ICM_AMT , 0) * 1000 AS ��û_���ҵ�
INTO     #TEMP_��û�ҵ�
--DROP TABLE #TEMP_��û�ҵ�
FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC       A --PLI_���Ž�û�⺻
       ,(SELECT   B.��������
                 ,A.CLN_ACNO        AS ���Ű��¹�ȣ
                 ,MAX(A.CLN_APC_NO) AS ���Ž�û��ȣMAX
         FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A               --PLI_���Ž�û�⺻
                 ,#TEMP_��������               B
         WHERE    A.CLN_APC_PGRS_STCD  IN ('03','04','13')     --���Ž�û��������ڵ�(03:����Ϸ�, 04:����Ϸ�,13:�����Ϸ�)
         AND      A.CLN_ACNO           > '0'                   --���Ű��¹�ȣ
         AND      A.CLN_APC_DSCD       < '10'                  --���Ž�û�����ڵ�:�ű�
         AND      A.NFFC_UNN_DSCD      = '1'                   --�߾�ȸ���ձ����ڵ�
         AND      A.APC_DT             <= B.��������
        GROUP BY B.��������, A.CLN_ACNO
         ) B
        ,DWZOWN.TB_SOR_CUS_MAS_BC           C --CUS_���⺻
        ,DWZOWN.TB_SOR_PLI_APC_POT_CUST_TR  F --SOR_PLI_��û����������

WHERE    A.CLN_ACNO      = B.���Ű��¹�ȣ
AND      A.CLN_APC_NO    = B.���Ž�û��ȣMAX
---------JOIN A:C(CUS_���⺻)
AND      A.CUST_NO       = C.CUST_NO
AND      A.CLN_APC_NO   *= F.CLN_APC_NO
AND      A.CUST_NO       *= F.CUST_NO
;

--CASE 3  ���� ���ҵ� ��������
-- CASE1, CASE2 �� ���º��̹Ƿ� ���ϰ��� ���ҵ��� ���º��� �ٸ��� ���ü� �ִ�
-- ���ҵ��� õ�����ε� �ܴ����� ���������� ����� �ǵ� �ְ� ����� �����Ȱǵ� �ְ�  �����Ͱ� �����̴�
-- ������ ���������� �����Ѵ�

CREATE  TABLE  #TEMP_��û�ҵ�      --  DROP TABLE  #TEMP_��û�ҵ�
(
            ��������             CHAR(8)
--           ,���¹�ȣ             CHAR(12)
--           ,�Ǹ��ȣ             CHAR(20)
           ,����ȣ             NUMERIC(9)
           ,��û��ȣ             CHAR(14)
           ,���ҵ�               NUMERIC(18,2)
);
-- �������ں��� �ݺ������� ���ҵ������ؼ� �������� ���Ͽ� �������ڸ�  �ٲ㰡�鼭 �ݺ��ؼ� ������.
INSERT INTO #TEMP_��û�ҵ�
SELECT      B.��������
           ,A.CUST_NO
           ,A.CLN_APC_NO
           ,ISNULL(F.FRYR_ICM_AMT , 0) * 1000 AS ��û_���ҵ� -- 1000���ؼ� ������

FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC       A             --PLI_���Ž�û�⺻

JOIN
            (
            -------------------------------------------------------------------------------
             SELECT   '20121231'        AS ��������
             SELECT   '20131231'        AS ��������
             SELECT   '20141231'        AS ��������
             SELECT   '20150630'        AS ��������
             SELECT   '20151231'        AS ��������
             SELECT   '20160630'        AS ��������
            -------------------------------------------------------------------------------
                     ,A.CUST_NO         AS ����ȣ
                     ,MAX(A.CLN_APC_NO) AS ���Ž�û��ȣMAX
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A               --PLI_���Ž�û�⺻
             JOIN     DWZOWN.TB_SOR_PLI_APC_POT_CUST_TR  B         --SOR_PLI_��û����������
                      ON   A.CLN_APC_NO  = B.CLN_APC_NO
                      AND  A.CUST_NO     = B.CUST_NO
             WHERE    A.CLN_APC_PGRS_STCD  IN ('03','04','13')     --���Ž�û��������ڵ�(03:����Ϸ�, 04:����Ϸ�,13:�����Ϸ�)
             AND      A.CLN_ACNO           > '0'                   --���Ű��¹�ȣ
             AND      A.CLN_APC_DSCD       < '10'                  --���Ž�û�����ڵ�:�ű�
             AND      A.NFFC_UNN_DSCD      = '1'                   --�߾�ȸ���ձ����ڵ�
             -----------------------------------------------------------------------------
             AND      B.FRYR_ICM_AMT * 1000  >= 500000             -- ���ҵ� 50�����̸� �̳� 10���̻����� �ԷµǾ� �ִ� ����
             AND      B.FRYR_ICM_AMT * 1000  <  1000000000         -- �߸��Էµ� ������ ġ���Ѵ�
             -------------------------------------------------------------------------------
             AND      A.APC_DT             <= '20121231'
             AND      A.APC_DT             <= '20131231'
             AND      A.APC_DT             <= '20141231'
             AND      A.APC_DT             <= '20150630'
             AND      A.APC_DT             <= '20151231'
             AND      A.APC_DT             <= '20160630'
             -------------------------------------------------------------------------------
             GROUP BY  A.CUST_NO
            ) B
            ON  A.CLN_APC_NO  =  B.���Ž�û��ȣMAX

JOIN        DWZOWN.TB_SOR_PLI_APC_POT_CUST_TR  F --SOR_PLI_��û����������
            ON      A.CLN_APC_NO  =  F.CLN_APC_NO
            AND     A.CUST_NO     =  F.CUST_NO
;
//}

//{ #RM��ȣ #��������
-- UP_DWZ_����_N0051_��������Ȳ_�ڱݺ�

    --RM�� ���º��� �ϳ����ۿ� ����.
    SELECT   DISTINCT A.CLN_ACNO                            AS ���Ű��¹�ȣ
            ,RIGHT('0000000000'+RIGHT(A.RM����ڹ�ȣ,7),10) AS RM����ڹ�ȣ -- ����ڹ�ȣ�� 0001079117�� �͵� �ְ� 8071079117�� ���� : 0001079117�� 7�ڸ��� ����
            ,B.����                                         AS RM��
    INTO     #TEMP_RM����ڹ�ȣ              -- DROP TABLE #TEMP_RM����ڹ�ȣ
    FROM     (SELECT DISTINCT A.CLN_ACNO, A.CLN_EXE_NO, B.RM����ڹ�ȣ
              FROM   TB_SOR_LOA_HDL_PTCP_DL A,
                    (
                     SELECT DISTINCT A.CLN_ACNO, A.USR_NO AS RM����ڹ�ȣ
                     FROM   TB_SOR_LOA_HDL_PTCP_DL A,
                            (
                             SELECT A.CLN_ACNO, MAX(A.CLN_EXE_NO)  AS CLN_EXE_NO_MAX
                             FROM   TB_SOR_LOA_HDL_PTCP_DL A, TB_SOR_LOA_ACN_BC B
                             WHERE  A.LN_HDL_PTCP_DSCD = '04'
                             AND    A.CLN_ACNO = B.CLN_ACNO
                             AND    B.INDV_LMT_LN_DSCD = '2' -- �ѵ�����
                             GROUP  BY A.CLN_ACNO
                            ) B

                    WHERE  A.LN_HDL_PTCP_DSCD = '04' ---AND CLN_ACNO = '322000045724'
                    AND A.CLN_ACNO = B.CLN_ACNO
                    AND A.CLN_EXE_NO = B.CLN_EXE_NO_MAX
                   ) B
              WHERE A.CLN_ACNO = B.CLN_ACNO) A
             ,TB_MDWT�λ�  B
    WHERE     RM����ڹ�ȣ *= B.���
    AND       B.�ۼ������� = P_��������

    UNION

    --�ѵ������
    SELECT DISTINCT A.CLN_ACNO                      AS ���Ű��¹�ȣ
          ,RIGHT('0000000000'+RIGHT(A.USR_NO,7),10) AS RM����ڹ�ȣ -- ����ڹ�ȣ�� 0001079117�� �͵� �ְ� 8071079117�� ���� : 0001079117�� 7�ڸ��� ����
          ,C.����                                   AS RM��
    FROM   TB_SOR_LOA_HDL_PTCP_DL A
          ,(SELECT A.CLN_ACNO, MAX(A.CLN_EXE_NO)  AS CLN_EXE_NO_MAX
            FROM   TB_SOR_LOA_HDL_PTCP_DL A, TB_SOR_LOA_ACN_BC B
            WHERE  A.LN_HDL_PTCP_DSCD = '04'
            AND    A.CLN_ACNO = B.CLN_ACNO
            AND    B.INDV_LMT_LN_DSCD <> '2'
            GROUP  BY A.CLN_ACNO
           ) B
          ,TB_MDWT�λ� C

    WHERE  A.LN_HDL_PTCP_DSCD = '04'
    AND    A.CLN_ACNO = B.CLN_ACNO
    AND    A.CLN_EXE_NO = B.CLN_EXE_NO_MAX
    AND    RM����ڹ�ȣ *= C.���
    AND    C.�ۼ������� = P_��������

...........
LEFT OUTER JOIN   (
                       -- ������������ �� 'UP_DWZ_�濵_N0055_RMC�����Ž�����Ȳ'�� ��ġ���
                       -- SOR_LOA_��ް����ڻ󼼿� ��ϵ� RM������� ��������ǿ� ��ϵ� RM����ڸ�
                       -- ���´�ǥ RM��ȣ�� �ν�
                       SELECT DISTINCT A.CLN_ACNO                               AS ���Ű��¹�ȣ
                                      ,RIGHT('0000000000'+RIGHT(A.USR_NO,7),10) AS RM����ڹ�ȣ
                                      ,C.����                                   AS RM��
                       FROM   TB_SOR_LOA_HDL_PTCP_DL A
                             ,(SELECT A.CLN_ACNO, MAX(A.CLN_EXE_NO)  AS CLN_EXE_NO_MAX
                               FROM   TB_SOR_LOA_HDL_PTCP_DL A, TB_SOR_LOA_ACN_BC B
                               WHERE  A.LN_HDL_PTCP_DSCD = '04'
                               AND    A.CLN_ACNO = B.CLN_ACNO
                               GROUP  BY A.CLN_ACNO
                              ) B
                             ,TB_MDWT�λ� C

                       WHERE  A.LN_HDL_PTCP_DSCD = '04' ---AND CLN_ACNO = '322000045724'
                       AND    A.CLN_ACNO = B.CLN_ACNO
                       AND    A.CLN_EXE_NO = B.CLN_EXE_NO_MAX
                       AND    RM����ڹ�ȣ *= C.���
                       AND    C.�ۼ������� = P_��������
                   )      P
                   ON    A.INTG_ACNO  =  P.���Ű��¹�ȣ
//}

//{ #�����ſ�  #�ſ�㺸��
-- ������å��(20140924)_�ſ����������������Ȳ.SQL
SELECT   A.STD_DT       AS ��������
        ,A.INTG_ACNO    AS ���¹�ȣ
        ,SUM(CASE WHEN NOT ( A.MRT_CD < '100' OR A.MRT_CD IN ('601','602'))   THEN  1  ELSE 0 END)  AS �ſ�ܴ㺸�Ǽ�
        ,SUM(CASE WHEN ( A.MRT_CD < '100' OR A.MRT_CD IN ('601','602'))       THEN  1  ELSE 0 END)  AS �ſ�㺸�Ǽ�

FROM     DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL A   -- SOR_LCF_���������¿����߾�ȸ��

JOIN     (                                   -- ����ڱݴ���� �� �����ڱݴ���ݸ� ���
          SELECT   STD_DT
                  ,ACSB_CD
                  ,ACSB_NM
                  ,ACSB_CD4  --��ȭ�����
                  ,ACSB_NM4
                  ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                  ,ACSB_NM5
          FROM     OT_DWA_DD_ACSB_TR
          WHERE    1=1
          AND      FSC_SNCD      IN ('K','C')
          AND      ACSB_CD5      IN ('14002401','14002501')  -- ����ڱݴ����, �����ڱݴ����
         )          C
         ON    A.BS_ACSB_CD  =  C.ACSB_CD
         AND   A.STD_DT      =  C.STD_DT

WHERE    1=1
AND      A.STD_DT      IN  (  SELECT DISTINCT STD_DT FROM  TB_SOR_LCF_SDNS_ACN_MN_DL
                              WHERE   STD_DT BETWEEN '20110101' AND '20140831'
                            )
AND      RIGHT(A.STD_DT,2) <>  '15'
AND      A.CLN_ACN_STCD = '1'
GROUP BY A.STD_DT
        ,A.INTG_ACNO
HAVING   �ſ�㺸�Ǽ� > 0   AND  �ſ�ܴ㺸�Ǽ� = 0



-- CASE 2 �ſ�㺸����( UP_DWZ_����_N0093_�㺸��������Ȳ �� ���ϱ���)
-- ��д㺸�������� 601,602,603 �㺸�� ������ �ſ�㺸��� ��
-- �ſ�㺸�� 601�̿ܿ��� �ٸ��㺸�� ���� ���� ���´� �κ������� �з�
SELECT      A.STD_DT       AS ��������
           ,A.INTG_ACNO    AS ���¹�ȣ
           ,A.CRDT_EVL_MODL_DSCD AS �ſ��򰡸��������ڵ�

           ,CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999'
                   AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014����� 88�� ������� ���Խ�Ų��.
                 THEN CASE WHEN ISNULL(E.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.����'  ELSE '2.�߼ұ��'  END
            ELSE '3.���λ����'
            END                          AS  �������

           ,SUM(A.ACN_RMD )                                                 AS  �����ܾ�
           ,SUM(CASE WHEN D.MRT_TPCD = '6' THEN  A.ACN_RMD  ELSE NULL END)  AS  �ſ�㺸�ܾ�

           ,SUM(CASE WHEN A.MRT_CD = '601' THEN A.ACN_RMD ELSE 0 END)       AS  ��������
           ,SUM(CASE WHEN A.MRT_CD = '602' THEN A.ACN_RMD ELSE 0 END)       AS  �����ſ뺸��
           ,SUM(CASE WHEN A.MRT_CD = '603' THEN A.ACN_RMD ELSE 0 END)       AS  �ſ뺸��

           ,MAX(CASE WHEN D.MRT_TPCD  = '6'  THEN '0' ELSE '1' END)         AS �㺸����
           ,CASE WHEN  �㺸���� = '0' AND �����ſ뺸�� = 0 AND �ſ뺸�� = 0  THEN �ſ�㺸�ܾ� ELSE 0 END  AS �κ��������ܾ�

INTO        #TEMP       -- DROP TABLE #TEMP

FROM        DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL A   -- SOR_LCF_���������¿����߾�ȸ��

JOIN        (                                   -- ����ڱݴ���� �� �����ڱݴ���ݸ� ���
             SELECT   STD_DT
                     ,ACSB_CD
                     ,ACSB_NM
                     ,ACSB_CD4  --��ȭ�����
                     ,ACSB_NM4
                     ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                     ,ACSB_NM5
             FROM     OT_DWA_DD_ACSB_TR
             WHERE    1=1
             AND      FSC_SNCD      IN ('K','C')
             AND      ACSB_CD5      IN ('14002401') -- ����ڱݴ����
            )          C
            ON    A.BS_ACSB_CD  =  C.ACSB_CD
            AND   A.STD_DT      =  C.STD_DT

LEFT OUTER JOIN
            TB_SOR_CLM_MRT_CD_BC    D   -- SOR_CLM_�㺸�ڵ�⺻
            ON   A.MRT_CD      = D.MRT_CD

LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   E   --DWA_����Ը�⺻
            ON     A.RNNO      = E.RNNO
            AND    A.STD_DT    = E.STD_DT

WHERE       1=1
AND         A.STD_DT      IN  ( '20101231','20111231','20121231','20131231','20141231','20151231','20161231','20171031')
--AND         A.STD_DT      IN  ('20161231','20171031')
AND         A.CLN_ACN_STCD = '1'
AND         A.BR_DSCD      = '1'  --�������ڵ�(1:�߾�ȸ)
//---------------------------------------------------------
AND         �������  <>  '1.����'       -- �߼ұ��(���λ��������)
//---------------------------------------------------------
GROUP BY    A.STD_DT
           ,A.INTG_ACNO
           ,�������
           ,A.CRDT_EVL_MODL_DSCD
//---------------------------------------------------------
HAVING      �ſ�㺸�ܾ� > 0               -- �ſ�㺸����
//---------------------------------------------------------
;

//}

//{ #���ܴ��� #�ߵ��ݴ��� #���ֺ� #�ܱݴ���
--201301�������� ���ֺ� ���ܴ���� ���� �ݰ����� ���� �Ͽ�����
--201302�����ʹ� ���ֺ� ���ܴ��⿡�� �����ϰ� ���� �ϰ� ����
--�� ������ ����� �ϰ��� �����Ͽ��� ��
--�ܱݴ����� ���ܴ��⿡�� ó������ ���ܵǾ� ����

    AND     (
--                (
--                   (A.LN_SBCD      =  '052' AND  A.LN_TXIM_CD  IN ('0002','0003')) OR                        --�������ݸ���������(�⺻,�߰����ֺ����)
--                   (A.LN_SBCD      =  '051' AND  A.LN_TXIM_CD   =  '1082' AND A.LN_USCD      =  '01') OR     --����������(���ֺ�-�����Ϲ��ڱݴ���)-20110401�߰�
--                   (A.LN_SBCD      =  '056' AND  A.LN_TXIM_CD   =  '0006')                                   --���������ڱݴ���(���ֺ�(����)����)-20110401�߰�
--                )             OR                                                                             -- ���ֺ�

                (
                   (A.LN_SBCD    IN ('201','203') AND  A.LN_TXIM_CD  =  '1054')    OR                          --���������ߵ������ܴ���
                   (A.LN_SBCD    IN ('051','052','053') AND A.LN_TXIM_CD  =  '1053' AND A.LN_USCD = '04')  OR --���������ڱݴ���(�ߵ��ݳ����ڱ�)
                   (A.LN_SBCD     =  '056'  AND A.LN_TXIM_CD  =  '1053' AND A.LN_USCD     =  '03')    OR      --���������ڱݴ���(�ߵ��ݳ����ڱ�)
                   (A.LN_SBCD     =  '051'  AND A.LN_TXIM_CD  =  '1082' AND A.LN_USCD     =  '02')            --���������� (�ߵ���-�����Ϲ��ڱݴ���)-20110401�߰�
                )             OR                                                                              -- �ߵ���

                (  A.BS_ACSB_CD  =  '14000611' AND
                       (
                       (A.LN_SBCD = '055' AND A.LN_TXIM_CD  =  '0008')            OR       --�ٷ��������ڱݴ���(�ֽź������ߵ��ݴ���)
                       (A.LN_SBCD = '055' AND A.LN_TXIM_CD  =  '1017' AND A.LN_USCD     =  '04')
                   )                            AND                                        --���ýſ뺸�����㺸����(�ߵ���-�ٷ��������ڱݴ���)
                   A.MRT_CD      =  '512'                                                                    -- ���ú���������_�ߵ���
                )
--                                     OR
--
--                A.PDCD     IN ('20052105301011','20053105301011','20056105301011','20056105301021')          -- �ܱݴ���
            )

-- CASE 2
           ,CASE WHEN (A.LN_SBCD      =  '052' AND
                       A.LN_TXIM_CD  IN ('0002','0003')) OR         --�������ݸ���������(�⺻,�߰����ֺ����)
                      (A.LN_SBCD      =  '051' AND
                       A.LN_TXIM_CD   =  '1082' AND
                       A.LN_USCD      =  '01') OR                   --����������(���ֺ�-�����Ϲ��ڱݴ���)-20110401�߰�
                      (A.LN_SBCD      =  '056' AND
                       A.LN_TXIM_CD   =  '0006')                    --���������ڱݴ���(���ֺ�(����)����)-20110401�߰�
                                                        THEN '���ֺ�'
                 WHEN (A.LN_SBCD    IN ('201','203') AND
                       A.LN_TXIM_CD  =  '1054')            OR       --���������ߵ������ܴ���
                      (A.LN_SBCD    IN ('051','052','053') AND
                       A.LN_TXIM_CD  =  '1053' AND
                       A.LN_USCD     =  '04')              OR       --���������ڱݴ���(�ߵ��ݳ����ڱ�)
                      (A.LN_SBCD     =  '056'  AND
                       A.LN_TXIM_CD  =  '1053' AND
                       A.LN_USCD     =  '03')              OR       --���������ڱݴ���(�ߵ��ݳ����ڱ�)
                      (A.LN_SBCD     =  '051'  AND
                       A.LN_TXIM_CD  =  '1082' AND
                       A.LN_USCD     =  '02')                       --���������� (�ߵ���-�����Ϲ��ڱݴ���)-20110401�߰�
                                                        THEN '�ߵ���'
                 WHEN  A.BS_ACSB_CD  =  '14000611' AND
                     ((A.LN_SBCD     =  '055'  AND
                       A.LN_TXIM_CD  =  '0008')            OR       --�ٷ��������ڱݴ���(�ֽź������ߵ��ݴ���)
                      (A.LN_SBCD     =  '055'  AND
                       A.LN_TXIM_CD  =  '1017' AND
                       A.LN_USCD     =  '04')) AND                  --���ýſ뺸�����㺸����(�ߵ���-�ٷ��������ڱݴ���)
                       A.MRT_CD      =  '512'
                                                        THEN '���ú���������_�ߵ���'
            END       AS ���ô㺸����������
            
-- CASE 3  2018�⵵�� DWA_�����ô㺸���⳻�� �� ���� �ݿ��� ���
           ,CASE WHEN AA.GRLN_ADM_NO IS NOT NULL AND  --���ܴ��������ȣ
                      A.PDCD IN ('20056113701021','20056113701011','20056105303011','20055000800001','20055101704001','20051108202001')
                                                                     THEN '�ߵ���' 
                 WHEN AA.GRLN_ADM_NO IS NOT NULL AND  --���ܴ��������ȣ
                      A.PDCD IN ('20056000600001','20051108201001')  THEN '���ֺ�'
                 WHEN AA.GRLN_ADM_NO IS NOT NULL AND  --���ܴ��������ȣ
                      A.PDCD IN ('20056113702011','20056113702021','20056105301031','20056105301011',
                                  '20056116702011','20056116702021') THEN '�ܱ�'
                 WHEN AA.GRLN_ADM_NO IS NOT NULL AND  --���ܴ��������ȣ
                      A.PRD_BRND_CD = '1123'                         THEN '�ܱ�'
                 ELSE 'X'
            END                                                    AS ���ܴ��⿩��

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A --DWA_���տ��ű⺻

JOIN        DWZOWN.TB_SOR_LOA_ACN_BC    AA            --SOR_LOA_���±⺻
            ON     A.INTG_ACNO       = AA.CLN_ACNO


-- ���ܴ���
               ,CASE WHEN ���ô㺸���������� IN ('�ߵ���',
                                                 '���ֺ�',
                                                 '�ܱ�') THEN '����'
                     ELSE '����'
                END                                                    AS ���ô㺸�������¸�
                
               ,CASE WHEN ���ô㺸�������¸� = '����' THEN 'Y'
                     ELSE 'N'
                END                                                    AS ���ܴ��⿩��                                     
//}

//{ #������
      FROM                TB_SOR_FEE_FEE_TR         A
      JOIN                TB_SOR_FEE_FEE_BC         B
                          ON  A.FEE_CD   = B.FEE_CD
                          AND B.FEE_APL_STCD = '10'   -- ��������������ڵ� 10:Ȱ��
                          AND DATEFORMAT(B.APL_END_DTTM,'YYYYMMDD') = '99991231'  -- �̰ž����ϱ� �ߺ��Ǵ°�쵵 ����

//}

//{ #�������ܾ� #���տ��� #���Կ�ȯ #�����������꽺  #�����ܾװ����տ�������
FROM       DWZOWN.OT_DWA_MM_ACN_RMD_TZ        A          --  DWA_�������ܾ�����
               ,DWZOWN.OM_DWA_INTG_CUST_BC         B          --  DWA_���հ�
               ,DWZOWN.TB_SOR_CMI_STDD_INDS_BC     BB         --  SOR_CMI_ǥ�ػ���⺻
               ,DWZOWN.OT_DWA_INTG_CLN_BC          C          --  DWA_���տ���

WHERE
..........
         (
             A.ACSB_CD     IN  ('13001508','14003208','15007518','15007618','15007718','15007818','14002218','14002318','14002418') -- ���Կ�ȯ
        OR A.ACSB_CD     IN  ('13001308','14001818','14001918','14002018') -- �����������꽺
         )
        AND
        AND     C.STD_DT  = V_BASEDAY
        AND     A.INTG_ACNO       = C.INTG_ACNO
        AND     A.ACSB_CD         = C.BS_ACSB_CD
        AND     CASE WHEN A.ACSB_CD     IN  ('15007018','15007118')  THEN '61'
                     WHEN A.ACSB_CD     IN  ('13001508','14003208','15007518','15007618','15007718','15007818','14002318')  THEN '11' -- ����ȯ����
                     WHEN A.ACSB_CD     IN  ('14002418')  THEN  '12'                              -- ��Ÿ���Կ�ȯ (��ȭ��ǥ)
                     WHEN A.ACSB_CD     IN  ('14002218')  THEN  '42'                              -- �����ſ����������
                     ELSE A.FRXC_TSK_DSCD
                END               = C.FRXC_TSK_DSCD
        AND     A.ACN_SNO         = C.CLN_EXE_NO
        AND     A.STD_YM          = SUBSTRING(C.STD_DT,1,6)

//}

//{ #�����ݴ㺸  #���࿹����
--  ������å��(20140819)_��Ÿ�����Ǽ�����Ȳ.SQL
--  ���տ��ſ��� �߾�ȸ ���Ű��¸� �㺸�� ����ϴ� ��쵵 �����Ƿ� �߾�ȸ/���� ����� �㺸����������
--  �����;� ��
SELECT      B.CLN_APC_NO          AS ���Ž�û��ȣ
           ,A.MRT_NO              AS �㺸��ȣ
           ,A.STUP_NO             AS ������ȣ
           ,A.STUP_DT             AS ��������
           ,A.STUP_AMT            AS �����ݾ�
           ,B.ACN_DCMT_NO         AS ���Ű��¹�ȣ
           ,B.CLN_TSK_DSCD        AS ���ž��������ڵ�
           ,C.PBLC_ISTT_BRDP_NM   AS ������������
           ,C.OWNR_CUST_NO        AS �����ڰ���ȣ
           ,C.DPS_ACNO            AS ���Ű��¹�ȣ
           ,C.PDCD                AS ��ǰ�ڵ�
           ,C.BND_RMD             AS ä���ܾ�
           ,C.NW_DT               AS �ű�����
           ,C.EXPI_DT             AS ��������
           ,C.CNTT_AMT            AS ���ݾ�
           ,C.MM_PYM_AMT          AS �����Աݾ�
           ,C.PYM_NOT             AS ����Ƚ��
           ,C.OD_ACNO             AS �����¹�ȣ
INTO        #���࿹���ݴ㺸����  -- DROP TABLE #���࿹���ݴ㺸����
FROM        TT_SOR_CLM_MM_STUP_BC        A   --SOR_CLM_�������⺻
JOIN        TT_SOR_CLM_MM_CLN_LNK_TR     B   --SOR_CLM_�����ſ��᳻��
            ON    A.STUP_NO       = B.STUP_NO
            AND   B.STD_YM        = '201406'
            AND   B.CLN_LNK_STCD  IN ('02','03')   --���ſ�������ڵ�(01:�������,02:����,03:��������
                                                   --                 04:����,05:���)

JOIN        TT_SOR_CLM_MM_TBK_PRD_MRT_BC C   --SOR_CLM_�������ǰ�㺸�⺻
            ON    A.MRT_NO        = C.MRT_NO
            AND   C.STD_YM        = '201406'
            AND   C.MRT_STCD      IN ('02')  -- �㺸�����ڵ�(01:�������,02:������,
                                             -- 04:�㺸����,05:������,06:�簨��������)

WHERE       1=1
-- AND         A.NFFC_UNN_DSCD  =  '1'          -- �߾�ȸ���ձ��� 1: �߾�ȸ
AND         A.STUP_STCD     IN ('02','03')   --���������ڵ�(01:�������,02:����,03:��������
                                             --             04:����,05:���)
AND         A.STD_YM = '201406'
;

//}

//{ #����������  #��ܱ�
                  ,CASE WHEN CONVERT(CHAR(8), DATEADD(YY, 1, D.AGR_DT), 112) >= D.AGR_EXPI_DT THEN '1.�ܱ����'
                        ELSE '2.������'
                   END                            AS ��ܱⱸ��


--  �ð迭���̺�(�����±⺻)�� �����Ͽ� ���������� ��������
FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A       --DWA_���տ��ű⺻

JOIN        (
                SELECT   STD_DT
                        ,ACSB_CD
                        ,ACSB_NM
                        ,ACSB_CD4  --��ȭ�����
                        ,ACSB_NM4
                        ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                        ,ACSB_NM5
                FROM     OT_DWA_DD_ACSB_TR
                WHERE    FSC_SNCD IN ('K','C')
                AND      ACSB_CD4 = '13000801'        --��ȭ�����
--                AND      ACSB_CD5 IN ('14002401')     --����ڱݴ����
            )           C
            ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS���������ڵ�
            AND      A.STD_DT       =   C.STD_DT

JOIN        DWZOWN.TT_SOR_LOA_MM_ACN_BC    AA            --SOR_LOA_�����±⺻
            ON     LEFT(A.STD_DT,6)  = AA.STD_YM
            AND    A.INTG_ACNO       = AA.CLN_ACNO

JOIN        DWZOWN.TB_SOR_LOA_ACN_BC    AA            --SOR_LOA_���±⺻
            ON     A.INTG_ACNO       = AA.CLN_ACNO
//}

//{ #������  #���°����� #���� #���������  #LAQ  #IFRS
-- IFRS������ �������� �ݾ׵��� ��Ģ������ ��ȭ�� ȯ���� �ݾ���, ��ȭ�ݾ��� '��ȭ' ��� ���� �پ� ����(���� ���αݾ��� ��ȭ���ݾ���)

-- CASE5  IFRS����2
-- �������ڿ� ���� �ٸ� ���������̺� �б�
-- ���۾������� �Ϻ����̺� ���� �������̺��� �ϴ� ���� ��Ȯ
-- ������ ������ �Ϻ��� ����ϰ�
-- �׷��� ������ ������ڸ������� ���������͸� Ȱ���Ѵ�( CASE2 �� �ٸ����)

IF  EXISTS(SELECT TOP 1 �������� FROM DWZOWN.TB_DWF_LAQ_���������¿����� WHERE �������� = P_��������) THEN  -- ���������̸� �������忡��

       -- �����ܾ��� ������ ���ܾ��̰�..�����ܾ��� �㺸��е� �ܾ��Դϴ�
       -- �����ܾ��� ����ä��,�̼�����,�̻��,���޺���,�����ޱݹ�бݾ��� ��
       -- BS�� ��ġ�ϴ� ���� ����Ϸ��� �����ܾ׹�бݾ�..
        SELECT   A.���հ��¹�ȣ                                                              AS ���¹�ȣ
                ,A.BS���������ڵ�                                                            AS �����ڵ�
                ,A.���Ž����ȣ                                                              AS �����ȣ
                ,A.��ǰ�ڵ�                                                                  AS ��ǰ�ڵ�
                ,MAX(���°���������ڵ�)                                                     AS ���������
                ,SUM(A.���޺���������бݾ�  + A.�����ܾ׹�бݾ�)                           AS �ܾ�
                ,MAX(A.���αݾ�)                                                             AS ���αݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '1' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS ����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '2' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����Ǳݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '3' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '4' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS ȸ���ǹ��ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '5' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����սǱݾ�
                ,SUM(A.���޺������� + A.����ä������)                                    AS ����
                ,'N'       AS ���ͳݴ��⿩��
        INTO     #TEMP_����������
        FROM     DWZOWN.TB_DWF_LAQ_���������¿�����  A
        WHERE    ��������           = P_��������
          AND    ��ǥ�����ڵ�       IN ('1','2','3','4','7')       -- �ſ�ī�� ����
          AND    BS���������ڵ�  NOT IN ('15009111','15009011')     -- �����ڵ�(ī���ȯ��,ī��� ����)
          AND    SUBSTR(��ǰ�ڵ�,5,4) <> '1019'                      -- ��ǰ�귣���ڵ���(1019:���ο�ũ�ƿ�����)
          AND    LEFT(��ǰ�ڵ�,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  ���α�����ǰ ����
        GROUP BY ���¹�ȣ
                ,�����ڵ�
                ,�����ȣ
                ,��ǰ�ڵ�
        ;

ELSEIF EXISTS(SELECT TOP 1 �������� FROM DWZOWN.TB_DWF_LAQ_�����������Ϻ��� WHERE �������� = P_��������) THEN  -- ������ �ƴϸ� �Ϻ����忡��

       -- �����ܾ��� ������ ���ܾ��̰�..�����ܾ��� �㺸��е� �ܾ��Դϴ�
       -- �����ܾ��� ����ä��,�̼�����,�̻��,���޺���,�����ޱݹ�бݾ��� ��
       -- BS�� ��ġ�ϴ� ���� ����Ϸ��� �����ܾ׹�бݾ�..

        SELECT   A.���հ��¹�ȣ                                                              AS ���¹�ȣ
                ,A.BS���������ڵ�                                                            AS �����ڵ�
                ,A.���Ž����ȣ                                                              AS �����ȣ
                ,A.��ǰ�ڵ�                                                                  AS ��ǰ�ڵ�
                ,MAX(���°���������ڵ�)                                                     AS ���������
                ,SUM(A.���޺���������бݾ�  + A.�����ܾ׹�бݾ�)                           AS �ܾ�
                ,MAX(A.���αݾ�)                                                             AS ���αݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '1' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS ����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '2' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����Ǳݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '3' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '4' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS ȸ���ǹ��ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '5' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����սǱݾ�
                ,SUM(A.���޺������� + A.����ä������)                                    AS ����
                ,'N'       AS ���ͳݴ��⿩��
        INTO     #TEMP_����������
        FROM     DWZOWN.TB_DWF_LAQ_�����������Ϻ���  A
        WHERE    ��������           = P_��������
          AND    ��ǥ�����ڵ�       IN ('1','2','3','4','7')       -- �ſ�ī�� ����
          AND    BS���������ڵ�  NOT IN ('15009111','15009011')     -- �����ڵ�(ī���ȯ��,ī��� ����)
          AND    SUBSTR(��ǰ�ڵ�,5,4) <> '1019'                      -- ��ǰ�귣���ڵ���(1019:���ο�ũ�ƿ�����)
          AND    LEFT(��ǰ�ڵ�,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  ���α�����ǰ ����
        GROUP BY ���¹�ȣ
                ,�����ڵ�
                ,�����ȣ
                ,��ǰ�ڵ�
        ;

ELSE                                                   -- ������ �ƴѵ� �Ϻ����忡�� ������ �ش������ ������ �´�

       -- �����ܾ��� ������ ���ܾ��̰�..�����ܾ��� �㺸��е� �ܾ��Դϴ�
       -- �����ܾ��� ����ä��,�̼�����,�̻��,���޺���,�����ޱݹ�бݾ��� ��
       -- BS�� ��ġ�ϴ� ���� ����Ϸ��� �����ܾ׹�бݾ�..

        SELECT   A.���հ��¹�ȣ                                                              AS ���¹�ȣ
                ,A.BS���������ڵ�                                                            AS �����ڵ�
                ,A.���Ž����ȣ                                                              AS �����ȣ
                ,A.��ǰ�ڵ�                                                                  AS ��ǰ�ڵ�
                ,MAX(���°���������ڵ�)                                                     AS ���������
                ,SUM(A.���޺���������бݾ�  + A.�����ܾ׹�бݾ�)                           AS �ܾ�
                ,MAX(A.���αݾ�)                                                             AS ���αݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '1' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS ����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '2' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����Ǳݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '3' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '4' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS ȸ���ǹ��ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '5' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����սǱݾ�
                ,SUM(A.���޺������� + A.����ä������)                                    AS ����
                ,'N'       AS ���ͳݴ��⿩��
        INTO     #TEMP_����������
        FROM     DWZOWN.TB_DWF_LAQ_���������¿�����  A
        WHERE    SUBSTR(��������,1,6) = SUBSTR(P_��������,1,6)
          AND    RIGHT(��������,2) <>  '15'
          AND    ��ǥ�����ڵ�       IN ('1','2','3','4','7')       -- �ſ�ī�� ����
          AND    BS���������ڵ�  NOT IN ('15009111','15009011')     -- �����ڵ�(ī���ȯ��,ī��� ����)
          AND    SUBSTR(��ǰ�ڵ�,5,4) <> '1019'                      -- ��ǰ�귣���ڵ���(1019:���ο�ũ�ƿ�����)
          AND    LEFT(��ǰ�ڵ�,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  ���α�����ǰ ����
        GROUP BY ���¹�ȣ
                ,�����ڵ�
                ,�����ȣ
                ,��ǰ�ڵ�
        ;

END IF;


-- CASE 1: ���°��������, ����
LEFT OUTER JOIN
            (
             SELECT   STD_DT
                     ,INTG_ACNO
                     ,MAX(ACN_SDNS_GDCD)          AS   ���°��������
                     ,SUM(APMN_NDS_RSVG_AMT)      AS   ���ݿ䱸�����ݾ�
             FROM     DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL     -- (SOR_LCF_���������¿����߾�ȸ��)
             WHERE    1=1
             AND      STD_DT  IN   ('20111231','20121231','20131231','20140630')
             GROUP BY STD_DT
                     ,INTG_ACNO
            )          D
            ON    A.STD_DT    =  D.STD_DT
            AND   A.INTG_ACNO =  D.INTG_ACNO
-- CASE 1: ���°��������, ���� (ifrs����)
BEGIN
  UPDATE       OT_DWA_DD_HSMR_LN_TR             T1
  SET          BDDB_APMN_AMT  =   T3.APMN_NDS_RSVG_AMT               -- ������ݱݾ�
              ,SDNS_GDCD      =   T3.ACN_SDNS_GDCD                   -- ����������ڵ�
  FROM         ( -- ���º� ���ݿ䱸�����ݾ�, ���°���������ڵ� ����
                SELECT   ���հ��¹�ȣ                                       --���հ��¹�ȣ
                        ,SUM(���ݿ䱸�����ݾ�)     AS APMN_NDS_RSVG_AMT   --���ݿ䱸�����ݾ�
                        -- ���ݿ䱸�����ݾ�=(����ä������+�̼���������+�����ޱ�����+���޺�������+�̻���������)
                        ,MAX(���°���������ڵ�)     AS ACN_SDNS_GDCD       --���°���������ڵ�
                FROM     DWZOWN.TB_DWF_LAQ_�����������Ϻ���  -- DWF_LAQ_�����������Ϻ���
                WHERE    ��������        = '$$WORK_DATE'                                     --��������
                AND     (BS���������ڵ�     IN ( -- Ư����������(14002501:�����ڱݴ����)�������� AND 14000611:�����ڱݴ���ݰ��� ����
                                            SELECT   RLT_ACSB_CD                             --������������ڵ�
                                            FROM     DWZOWN.OT_DWA_DD_ACSB_BC           --DWA_�ϰ�������⺻
                                            WHERE    STD_DT        = '$$WORK_DATE'
                                            AND      ACSB_CD       = '14002501'              --���������ڵ�
                                            AND      ACSB_HRC_INF  <> RLT_ACSB_HRC_INF       --��������������� <> ������������������
                                            AND      ACCT_STCD     = '1'                     --���������ڵ�(0:Ȯ����,1:����,2:�������)
                                            AND      RLT_ACCT_STCD = '1'                     --������������ڵ�(0:Ȯ����,1:����,2:�������)
                                           )
                         OR      BS���������ڵ�      = '14000611')
                GROUP BY ���հ��¹�ȣ
               )                                                T3                      --SOR_LCF_�����������Ϻ��߾�ȸ��
   WHERE       1=1
   AND         T1.ACNO    = T3.���հ��¹�ȣ
   AND         T1.STD_DT  = '$$WORK_DATE'
   ;
END

-- CASE 2 : ��������, ����������� ��.
LEFT OUTER JOIN
            (
              SELECT   A.STD_DT              AS ��������
                      ,A.INTG_ACNO           AS ���հ��¹�ȣ
                      ,MAX(A.CUST_SDNS_GDCD) AS ������������ڵ�
                      ,MAX(A.ACN_SDNS_GDCD)  AS ���°���������ڵ�
                      ,SUM(CASE WHEN A.ACN_SDNS_GDCD  IN ('3','4','5')  THEN A.ACN_RMD  ELSE 0 END)   AS ���������ܾ�  --���°���������ڵ�
                      ,SUM(A.PSVL_DC_DPM)    AS �������ݾ�
              FROM     DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL A --SOR_LCF_���������¿����߾�ȸ��
              WHERE    A.STD_DT    =  V_��������
              AND      A.CLN_ACN_STCD  = '1'    --Ȱ��
              AND      A.BR_DSCD       = '1'
              GROUP BY A.STD_DT,A.INTG_ACNO
            ) O
            ON     A.���հ��¹�ȣ   =   O.���հ��¹�ȣ
            AND    A.��������       =   O.��������

-- CSAE 3 : �������ڵ庰�� �ܾױ��ϱ�.
LEFT OUTER JOIN          -- ����������
            (
             SELECT       STD_DT
                         ,INTG_ACNO
                         ,SUM(CASE WHEN ACN_SDNS_GDCD =  '1'  THEN ACN_RMD  ELSE NULL END)  AS ����
                         ,SUM(CASE WHEN ACN_SDNS_GDCD =  '2'  THEN ACN_RMD  ELSE NULL END)  AS ������
                         ,SUM(CASE WHEN ACN_SDNS_GDCD =  '3'  THEN ACN_RMD  ELSE NULL END)  AS ����
                         ,SUM(CASE WHEN ACN_SDNS_GDCD =  '4'  THEN ACN_RMD  ELSE NULL END)  AS ȸ���ǹ�
                         ,SUM(CASE WHEN ACN_SDNS_GDCD =  '5'  THEN ACN_RMD  ELSE NULL END)  AS �����ս�
                         ,SUM(ACN_RMD)   AS  �հ�
                         ,SUM(CASE WHEN A.ACN_SDNS_GDCD  IN ('3','4','5')  THEN A.ACN_RMD  ELSE 0 END)   AS ��������
                         ,SUM(APMN_NDS_RSVG_AMT)      AS   ����

             FROM         DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL  A   -- (SOR_LCF_���������¿����߾�ȸ��)
             WHERE        1=1
             AND          STD_DT  =  '20160630'
             AND          INTG_ACNO  IN ( SELECT DISTINCT ���հ��¹�ȣ FROM #��ȭ�����_���º� )
             GROUP BY     STD_DT
                         ,INTG_ACNO
            )       B
            ON            A.���հ��¹�ȣ  = B.INTG_ACNO

-- CSAE 3 : �������ڵ庰�� �ܾױ��ϱ�.(IFRS����)
       -- �����ܾ��� ������ ���ܾ��̰�..�����ܾ��� �㺸��е� �ܾ��Դϴ�
       -- �����ܾ��� ����ä��,�̼�����,�̻��,���޺���,�����ޱݹ�бݾ��� ��
       -- BS�� ��ġ�ϴ� ���� ����Ϸ��� �����ܾ׹�бݾ�..
        SELECT   A.���հ��¹�ȣ                                                              AS ���¹�ȣ
                ,A.BS���������ڵ�                                                            AS �����ڵ�
                ,A.���Ž����ȣ                                                              AS �����ȣ
                ,A.��ǰ�ڵ�                                                                  AS ��ǰ�ڵ�
                ,MAX(���°���������ڵ�)                                                     AS ���������
                ,SUM(A.���޺���������бݾ�  + A.�����ܾ׹�бݾ�)                           AS �ܾ�
                ,MAX(A.���αݾ�)                                                             AS ���αݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '1' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS ����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '2' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����Ǳݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '3' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '4' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS ȸ���ǹ��ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '5' THEN A.���޺���������бݾ�  + A.�����ܾ׹�бݾ� ELSE 0 END)  AS �����սǱݾ�
                ,SUM(A.���޺������� + A.����ä������)                                    AS ����
        INTO     #TEMP_����������
        FROM     DWZOWN.TB_DWF_LAQ_���������¿�����  A
        WHERE    ��������           = P_��������
          AND    ��ǥ�����ڵ�       IN ('1','2','3','4','7')       -- �ſ�ī�� ����
          AND    BS���������ڵ�  NOT IN ('15009111','15009011')     -- �����ڵ�(ī���ȯ��,ī��� ����)
          AND    SUBSTR(��ǰ�ڵ�,5,4) <> '1019'                      -- ��ǰ�귣���ڵ���(1019:���ο�ũ�ƿ�����)
          AND    LEFT(��ǰ�ڵ�,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  ���α�����ǰ ����
        GROUP BY ���¹�ȣ
                ,�����ڵ�
                ,�����ȣ
                ,��ǰ�ڵ�
        ;

-- CASE4
-- �������ڿ� ���� �ٸ� ���������̺� �б�
-- ���۾������� �Ϻ����̺� ���� �������̺��� �ϴ� ���� ��Ȯ
-- ������ ������ �Ϻ��� ����ϰ�
-- �̶� ������ �����ʹ� �Ϻ��� �����Ƿ� �ش������ �ش��ϴ� �������̺��� �д´�

IF  EXISTS(SELECT TOP 1 STD_DT FROM DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL WHERE STD_DT = P_��������) THEN  -- ���������̸� �������忡��

             SELECT       STD_DT
                         ,INTG_ACNO
                         ,MAX(ACN_SDNS_GDCD)          AS   ���°��������
                         ,SUM(APMN_NDS_RSVG_AMT)      AS   ���ݿ䱸�����ݾ�
             INTO         #�����������߾�ȸ��
             FROM         DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL     -- (SOR_LCF_���������¿����߾�ȸ��)
             WHERE        STD_DT = P_��������
             GROUP BY     STD_DT
                         ,INTG_ACNO
             ;

ELSEIF EXISTS(SELECT TOP 1 STD_DT FROM DWZOWN.TB_SOR_LCF_SDNS_ACN_DN_DL WHERE STD_DT = P_��������) THEN  -- ������ �ƴϸ� �Ϻ����忡��

             SELECT       STD_DT
                         ,INTG_ACNO
                         ,MAX(ACN_SDNS_GDCD)          AS   ���°��������
                         ,SUM(APMN_NDS_RSVG_AMT)      AS   ���ݿ䱸�����ݾ�
             INTO         #�����������߾�ȸ��
             FROM         DWZOWN.TB_SOR_LCF_SDNS_ACN_DN_DL     -- (SOR_LCF_�����������Ϻ��߾�ȸ��)
             WHERE        STD_DT  = P_��������
             GROUP BY     STD_DT
                         ,INTG_ACNO

             ;
ELSE                                                   -- ������ �ƴѵ� �Ϻ����忡�� ������ �ش����� ������ ��������
             SELECT       STD_DT
                         ,INTG_ACNO
                         ,MAX(ACN_SDNS_GDCD)          AS   ���°��������
                         ,SUM(APMN_NDS_RSVG_AMT)      AS   ���ݿ䱸�����ݾ�
             INTO         #�����������߾�ȸ��
             FROM         DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL     -- (SOR_LCF_���������¿����߾�ȸ��)
             WHERE        SUBSTR(STD_DT,1,6) = SUBSTR(P_��������,1,6)
             AND          RIGHT(STD_DT,2) <>  '15'
             GROUP BY     STD_DT
                         ,INTG_ACNO

             ;
END IF;


-- CASE5  IFRS����
-- �������ڿ� ���� �ٸ� ���������̺� �б�
-- ���۾������� �Ϻ����̺� ���� �������̺��� �ϴ� ���� ��Ȯ
-- ������ ������ �Ϻ��� ����ϰ�
-- �׷��� ������ �Ϻ��� ���� �ֱٰ��� �о�´�

IF  EXISTS(SELECT TOP 1 �������� FROM DWZOWN.TB_DWF_LAQ_���������¿����� WHERE �������� = P_��������) THEN  -- ���������̸� �������忡��

        -- �����ܾ��� ������ ���ܾ��̰�..�����ܾ��� �㺸��е� �ܾ��Դϴ�
       -- �����ܾ��� ����ä��,�̼�����,�̻��,���޺���,�����ޱݹ�бݾ��� ��
       -- BS�� ��ġ�ϴ� ���� ����Ϸ��� �����ܾ׹�бݾ�..
        SELECT   A.���հ��¹�ȣ                                                              AS ���¹�ȣ
                ,A.BS���������ڵ�                                                            AS �����ڵ�
                ,A.���Ž����ȣ                                                              AS �����ȣ
                ,MAX(CASE WHEN  �����ܾ� >= 0  THEN  ���°���������ڵ�  END)                AS ���������
                ,SUM(ISNULL(�����ܾ׹�бݾ�,0))                                             AS �ܾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '1' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS ����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '2' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS �����Ǳݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '3' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS �����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '4' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS ȸ���ǹ��ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '5' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS �����սǱݾ�
                ,SUM(����ä������)                                                     AS ����
        INTO     #TEMP_����������
        FROM     DWZOWN.TB_DWF_LAQ_���������¿�����  A
        WHERE    ��������           = P_��������
          AND    ��ǥ�����ڵ�       IN ('1','2','3','4','7')       -- �ſ�ī�� ����
          AND    BS���������ڵ�  NOT IN ('15009111','15009011')     -- �����ڵ�(ī���ȯ��,ī��� ����)
          AND    SUBSTR(��ǰ�ڵ�,5,4) <> '1019'                      -- ��ǰ�귣���ڵ���(1019:���ο�ũ�ƿ�����)
          AND    LEFT(��ǰ�ڵ�,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  ���α�����ǰ ����
        GROUP BY ���¹�ȣ
                ,�����ڵ�
                ,�����ȣ
        ;

ELSEIF EXISTS(SELECT TOP 1 �������� FROM DWZOWN.TB_DWF_LAQ_�����������Ϻ��� WHERE �������� = P_��������) THEN  -- ������ �ƴϸ� �Ϻ����忡��

       -- �����ܾ��� ������ ���ܾ��̰�..�����ܾ��� �㺸��е� �ܾ��Դϴ�
       -- �����ܾ��� ����ä��,�̼�����,�̻��,���޺���,�����ޱݹ�бݾ��� ��
       -- BS�� ��ġ�ϴ� ���� ����Ϸ��� �����ܾ׹�бݾ�..
        SELECT   A.���հ��¹�ȣ                                                              AS ���¹�ȣ
                ,A.BS���������ڵ�                                                            AS �����ڵ�
                ,A.���Ž����ȣ                                                              AS �����ȣ
                ,MAX(CASE WHEN  �����ܾ� >= 0  THEN  ���°���������ڵ�  END)                AS ���������
                ,SUM(ISNULL(�����ܾ׹�бݾ�,0))                                             AS �ܾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '1' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS ����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '2' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS �����Ǳݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '3' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS �����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '4' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS ȸ���ǹ��ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '5' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS �����սǱݾ�
                ,SUM(����ä������)                                                     AS ����
        INTO     #TEMP_����������
        FROM     DWZOWN.TB_DWF_LAQ_�����������Ϻ���  A -- DWF_LAQ_�����������Ϻ���
        WHERE    ��������           = P_��������
          AND    ��ǥ�����ڵ�       IN ('1','2','3','4','7')       -- �ſ�ī�� ����
          AND    BS���������ڵ�  NOT IN ('15009111','15009011')     -- �����ڵ�(ī���ȯ��,ī��� ����)
          AND    SUBSTR(��ǰ�ڵ�,5,4) <> '1019'                      -- ��ǰ�귣���ڵ���(1019:���ο�ũ�ƿ�����)
          AND    LEFT(��ǰ�ڵ�,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  ���α�����ǰ ����
        GROUP BY ���¹�ȣ
                ,�����ڵ�
                ,�����ȣ
        ;
ELSE               -- ������ �ƴѵ� �Ϻ����忡�� ������ �Ϻ����忡�� �����ֱ� ���ڲ� ���

       -- �����ܾ��� ������ ���ܾ��̰�..�����ܾ��� �㺸��е� �ܾ��Դϴ�
       -- �����ܾ��� ����ä��,�̼�����,�̻��,���޺���,�����ޱݹ�бݾ��� ��
       -- BS�� ��ġ�ϴ� ���� ����Ϸ��� �����ܾ׹�бݾ�..
        SELECT   A.���հ��¹�ȣ                                                              AS ���¹�ȣ
                ,A.BS���������ڵ�                                                            AS �����ڵ�
                ,A.���Ž����ȣ                                                              AS �����ȣ
                ,MAX(CASE WHEN  �����ܾ� >= 0  THEN  ���°���������ڵ�  END)                AS ���������
                ,SUM(ISNULL(�����ܾ׹�бݾ�,0))                                             AS �ܾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '1' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS ����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '2' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS �����Ǳݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '3' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS �����ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '4' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS ȸ���ǹ��ݾ�
                ,SUM(CASE WHEN ���°���������ڵ� = '5' THEN ISNULL(�����ܾ׹�бݾ�,0) ELSE 0 END)  AS �����սǱݾ�
                ,SUM(����ä������)                                                     AS ����
        INTO     #TEMP_����������
        FROM     DWZOWN.TB_DWF_LAQ_�����������Ϻ���  A -- DWF_LAQ_�����������Ϻ���
        WHERE    ��������           = ( SELECT MAX(��������) FROM DWZOWN.TB_DWF_LAQ_�����������Ϻ��� WHERE �������� <= P_�������� )
          AND    ��ǥ�����ڵ�       IN ('1','2','3','4','7')       -- �ſ�ī�� ����
          AND    BS���������ڵ�  NOT IN ('15009111','15009011')     -- �����ڵ�(ī���ȯ��,ī��� ����)
          AND    SUBSTR(��ǰ�ڵ�,5,4) <> '1019'                      -- ��ǰ�귣���ڵ���(1019:���ο�ũ�ƿ�����)
          AND    LEFT(��ǰ�ڵ�,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  ���α�����ǰ ����
        GROUP BY ���¹�ȣ
                ,�����ڵ�
                ,�����ȣ
        ;

END IF;


//}

//{ #������

-- �������ݾ� ����.

UPDATE      #��ȭ�����    A
SET         A.�ܾ� =  A.�ܾ� - ISNULL(O.�������ݾ�, 0)
FROM        (
              SELECT   A.��������
                      ,A.���հ��¹�ȣ
                      ,SUM(A.���簡ġ��������)    AS �������ݾ�
              FROM     DWZOWN.TB_DWF_LAQ_���������¿����� A
              WHERE    A.��������   IN ('20171231','20180331')
              AND      A.�������ڵ�       = '1'
              AND      A.���հ��¹�ȣ  IN ( SELECT ���հ��¹�ȣ FROM  #��ȭ����� )
              GROUP BY A.��������,A.���հ��¹�ȣ
            ) O
WHERE       A.���հ��¹�ȣ   =   O.���հ��¹�ȣ
AND         A.��������       =   O.��������
;

//}

//{ #CRS��� #����ſ��򰡵��
-- ����ſ��򰡵�� 10������� �з�
             -- ���࿬��ȸ ���ñ��� ����򰡵�� 10���ü��
           ,CASE WHEN ����ſ��򰡵��  IN  ('1','01','1A','1B')  THEN  '01'
                 WHEN ����ſ��򰡵��  IN  ('2','02','2A','2B')  THEN  '02'
                 WHEN ����ſ��򰡵��  IN  ('3','03','3-','3+','3A','3B')  THEN  '03'
                 WHEN ����ſ��򰡵��  IN  ('4','04','4-','4+','4A','4B')  THEN  '04'
                 WHEN ����ſ��򰡵��  IN  ('5','05','5+','5-','5A')  THEN  '05'
                 WHEN ����ſ��򰡵��  IN  ('5B','6','06','6+','6-','6A','6B')  THEN  '06'
                 WHEN ����ſ��򰡵��  IN  ('7','07','7+','7-','7A','7B')  THEN  '07'
                 WHEN ����ſ��򰡵��  IN  ('8','08','8A','8B')  THEN  '08'
                 WHEN ����ſ��򰡵��  IN  ('9','09','9A','9B')  THEN  '09'
                 WHEN ����ſ��򰡵��  =    '10'                 THEN  '10'
                 WHEN ����ſ��򰡵��  IS NULL OR  ����ſ��򰡵�� IN  ('0','11','')         THEN  '99'
                 ELSE ����ſ��򰡵��
            END                        AS  ����ſ��򰡵��2
//}

//{ #��ü����
           -- 1. �Ϲݿ��� ��ü���ڱݾ�
              SELECT   A.CLN_ACNO
                      ,A.CLN_EXE_NO
                      ,A.TR_DT
                      ,SUM(B.LN_INT)      AS ��ü���ڱݾ�
                      ,COUNT(CASE WHEN B.LN_INT > 0 THEN 1 ELSE NULL END)  AS ��ü���ڰŷ��Ǽ�
              FROM     DWZOWN.TB_SOR_LOA_TR_TR       A
              JOIN     DWZOWN.TB_SOR_LOA_INT_CAL_DL  B
                       ON   A.CLN_ACNO    =  B.CLN_ACNO
                       AND  A.CLN_EXE_NO  =  B.CLN_EXE_NO
                       AND  A.CLN_TR_NO   =  B.CLN_TR_NO
                       AND  B.CLN_INT_CAL_TPCD IN ('13','14','15','16')  -- ���ڰ�������ڵ�
                                                                    -- 13:���ݿ�ü����,14:���һ�ȯ�ݿ�ü����
                                                                    -- 15:�Һαݿ�ü���� 16:���ڿ�ü����
              WHERE    1=1
              AND      A.CLN_TR_KDCD   IN ('300','310')          --���Űŷ������ڵ�(300:�����ȯ,310:�������ڼ���)
              AND      A.TR_STCD        = '1'                    --�ŷ������ڵ�(1:����)
              AND      A.TR_DT  BETWEEN   '20110101'  AND  '20140831'
              AND      A.CLN_ACNO IN  ( SELECT INTG_ACNO FROM #������1)
              GROUP BY A.CLN_ACNO,A.CLN_EXE_NO,A.TR_DT


              UNION ALL

            --2. ���� ��ü���ڱݾ�
        -- ������ ��ȯ�� ��ü���ڿ� �������ڸ� ������ ��ȯ�� �ؼ� ������ �ȵ�
        -- ��� ��ü���ڸ� ���ϴ°��� ������ ���� �����Ϳ����� ������
        -- 2011�⵵�� ��ü���ڴ����ȴٰ� ������ �뺸�� �ڷ�Ȱ����� ��

              SELECT   A.ACNO
                      ,0
                      ,A.TR_DT
                      ,SUM(OVD_INT)         AS ��ü���ڱݾ�
                      ,COUNT(CASE WHEN OVD_INT > 0 THEN 1 ELSE NULL END) AS  ��ü���ڰŷ��Ǽ�
              FROM     TB_SOR_DEP_TR_DL      A  --SOR_DEP_�ŷ���
              WHERE    1=1
              AND      TR_DT  BETWEEN   '20110101'  AND  '20140831'
              AND      A.ACNO  IN  ( SELECT INTG_ACNO FROM #������1)
              GROUP BY A.ACNO,A.TR_DT

//}

//{  #��ü�ݸ�
-- ��ü�ݸ��� ���忡 �ִ� �ݸ��ʹ� ������ �Ǿ������� ������ �ݸ��� ���Ѽ��� �־���.
-- ������ ����ָ� ���簰������ ������ �ɼ������Ƿ� �����۾��� �Ѵ�
           ,CASE WHEN A.OVD_IRT IS NOT NULL THEN
                 CASE WHEN A.STD_DT <= '20111231' AND  A.OVD_IRT > 21.00 THEN 21.00 -- 2011������
                      WHEN A.STD_DT >= '20120101' AND                               -- 2012 ~ 2014��
                           A.STD_DT <= '20141231' AND
                           A.OVD_IRT > 17.00                             THEN 17.00
                      WHEN A.STD_DT >= '20150101' AND  A.OVD_IRT > 15.00 THEN 15.00 -- 2015������
                      ELSE A.OVD_IRT
                 END
                 ELSE A.OVD_IRT
            END                  AS   ��ü�ݸ�
//}

//{ #ASS��� #CSS��� #�ſ���

-- CASE 1 :   ASS��� �����
-- ���տ����� ASS ����� �Ʒ� ���̽����� ��������� ������ ����� �ȳ����� ���µ� �߻��ϰ� �ȴ�
   WHERE    ((A.CLN_APC_PGRS_STCD = '04' AND A.CLN_APC_DSCD IN ('01','07','08','09', '02','04')) OR  --20120820
            (A.CLN_APC_PGRS_STCD = '13' AND A.CLN_APC_DSCD = '51'))  --ä����
-- �Ʒ� �������� ������ ������ �Ѵ� ( UP_DWZ_����_N0051_��������Ȳ_�ڱݺ� ���ν��� ������ ����)

CREATE TABLE  #TEMP_ASS���
(
  ��������     CHAR(8),
  ���¹�ȣ     CHAR(12),
  ���Ž�û��ȣ CHAR(14),
  ����ȣ     NUMERIC(9),
  ���ú������������ڵ�  CHAR(2),
  ASS�ſ���     CHAR(3)
);

BEGIN
DECLARE   P_��������  CHAR(8);

--SET       P_��������  = '20130630';
--SET       P_��������  = '20131231';
--SET       P_��������  = '20140630';
--SET       P_��������  = '20141231';
--SET       P_��������  = '20150630';
--SET       P_��������  = '20151231';
--SET       P_��������  = '20160630';
SET       P_��������  = '20161231';

DELETE   #TEMP_ASS���  WHERE  ��������  = P_��������;

INSERT INTO #TEMP_ASS���
SELECT      P_��������
           ,TBB.CLN_ACNO
           ,TBB.CLN_APC_NO
           ,TBB.CUST_NO
           ,TBB.HSGR_GRN_DSCD
           ,TRIM(TBA.ASS_CRDT_GD) AS ASS_CRDT_GD
FROM        TB_SOR_PLI_SYS_JUD_RSLT_TR  TBA              --SOR_PLI_�ý��۽ɻ�������
           ,(SELECT   TA.CLN_ACNO
                     ,TA.CLN_APC_NO
                     ,TB.CUST_NO
                     ,TB.HSGR_GRN_DSCD  --��������� �ߺ�����
             FROM    (SELECT   A.CLN_ACNO
                              ,MAX(B.CLN_APC_NO) AS CLN_APC_NO
                      FROM     TB_SOR_PLI_CLN_APC_BC       A   --SOR_PLI_���Ž�û�⺻
                              ,TB_SOR_PLI_SYS_JUD_RSLT_TR  B   --SOR_PLI_�ý��۽ɻ�������
                      WHERE    A.CLN_APC_PGRS_STCD IN ( '03','04','13')  --���Ž�û��������ڵ�(03:����Ϸ�,04:����Ϸ�,13:�����Ϸ�)
                      AND      A.NFFC_UNN_DSCD     = '1'       --�߾�ȸ���ձ����ڵ�
                      AND     (B.CSS_MODL_DSCD IS NULL OR B.CSS_MODL_DSCD IN ('31','32','34'))    --  CSS���������ڵ� 30(CRS����)���� 20120824 �����
                      AND      A.CLN_APC_NO        = B.CLN_APC_NO
                      AND      A.CUST_NO           = B.CUST_NO  --20121017 : �߰�
                      AND     (A.APC_DT    <= P_�������� OR A.CLN_APRV_DT <= P_��������)  --��û���� OR ���Ž�������
                      AND      A.CLN_ACNO IN ( SELECT ���հ��¹�ȣ FROM #�����ڱ�  WHERE ��������  = P_��������)
                      GROUP BY A.CLN_ACNO
                      )                         TA
                     ,TB_SOR_PLI_CLN_APC_BC     TB   --SOR_PLI_���Ž�û�⺻
             WHERE    1=1
             AND      TA.CLN_APC_NO         = TB.CLN_APC_NO
             AND      TB.CLN_APC_PGRS_STCD IN ( '03','04','13')
             AND      TB.NFFC_UNN_DSCD      = '1'       --�߾�ȸ���ձ����ڵ�
            )   TBB
WHERE       TBA.CLN_APC_NO        = TBB.CLN_APC_NO
AND         TBA.CUST_NO           = TBB.CUST_NO;
;
END

-- �������ں��� ������ Ȯ��
SELECT ��������,COUNT(*) FROM #TEMP_ASS���
GROUP BY ��������
ORDER BY 1

-- �����ߺ����� Ȯ��
SELECT   ��������,���¹�ȣ,COUNT(*) FROM  #TEMP_ASS���
GROUP BY ��������,���¹�ȣ
HAVING COUNT(*) > 1


-- CASE 2 ASS����� 10��� ü��� �����
           ,CASE WHEN E.ASS�ſ���  IN  ('1','01','1A','1B')  THEN  '01'
                 WHEN E.ASS�ſ���  IN  ('2','02','2A','2B')  THEN  '02'
                 WHEN E.ASS�ſ���  IN  ('3','03','3A','3B')  THEN  '03'
                 WHEN E.ASS�ſ���  IN  ('4','04','4A','4B')  THEN  '04'
                 WHEN E.ASS�ſ���  IN  ('5','05','5A','5B')  THEN  '05'
                 WHEN E.ASS�ſ���  IN  ('6','06','6A','6B')  THEN  '06'
                 WHEN E.ASS�ſ���  IN  ('7','07','7A','7B')  THEN  '07'
                 WHEN E.ASS�ſ���  IN  ('8','08','8A','8B')  THEN  '08'
                 WHEN E.ASS�ſ���  IN  ('9','09','9A','9B')  THEN  '09'
                 WHEN E.ASS�ſ���  =    '10'                 THEN  '10'
                 WHEN E.ASS�ſ���  IS NULL OR  E.ASS�ſ��� IN  ('0','11','')         THEN  '99'
                 ELSE ASS�ſ���
            END                        AS  ASS�ſ���2


-- 2.  ���ؽ����� �ٸ� ���������� �� ������  crs���(��ȣ�������� ����)���ϱ�, ���տ����� soho������ �������� �ʴ´�
SELECT      B.CLN_ACNO
           ,A.CLN_APC_NO
           ,B.CUST_NO
           ,B.APC_DT
           ,A.ASS_CRDT_GD
           ,ROW_NUMBER() OVER (PARTITION BY A.NFFC_UNN_DSCD,B.CLN_ACNO,B.CUST_NO ORDER BY B.APC_DT ASC) AS SEQ
INTO        #ASS�������丮  -- DROP TABLE   #ASS�������丮
FROM        DWZOWN.TB_SOR_PLI_SYS_JUD_RSLT_TR  A      --SOR_PLI_�ý��۽ɻ�������
JOIN        DWZOWN.TB_SOR_PLI_CLN_APC_BC    B
            ON     A.CLN_APC_NO   = B.CLN_APC_NO
            AND    A.CUST_NO      = B.CUST_NO
WHERE      (
              (B.CLN_APC_PGRS_STCD = '04' AND B.CLN_APC_DSCD IN ('01','07','08','09', '02','04')) OR  --20120820
              (B.CLN_APC_PGRS_STCD = '13' AND B.CLN_APC_DSCD = '51')  -- ä���μ�
            )  --ä���μ�
;


SELECT      A.*
INTO        #ASS������  -- DROP TABLE #ASS������
FROM        (
             SELECT      A.CLN_ACNO
                        ,A.CUST_NO
                        ,A.SEQ
                        ,A.APC_DT                                      AS �����������
                        ,A.ASS_CRDT_GD
                        ,CASE WHEN B.APC_DT IS NULL THEN '99999999'
                              ELSE DATEFORMAT(DATE(B.APC_DT)-1,'YYYYMMDD')
                         END                                           AS ������������
                        ,A.CRDT_EVL_NO
--             INTO      #�������丮_����  -- DROP TABLE #�������丮_����
             FROM        #ASS�������丮   A
             LEFT OUTER JOIN
                         #ASS�������丮   B
                         ON   A.CUST_NO  = B.CUST_NO
                         AND  A.CLN_ACNO = B.CLN_ACNO
                         AND  A.SEQ + 1  = B.SEQ
            )      A
;



//}

//{ #BSS��� #�ſ���  #���������������� #��������

--CASE 2 :  BSS��� �����
--���տ����� BSS����� �����ڱ����̶� ����� �ű��� ���µ��� BSS����� �ȳ��´�.
--�Ʒ� �������� BSS����� ������ �´�

CREATE TABLE  #TEMP_BSS��� -- DROP TABLE #TEMP_BSS���
(
  ��������     CHAR(8),
--  �Ǹ��ȣ     CHAR(20),
  ���¹�ȣ     CHAR(12),
  ���յ��     CHAR(3)
);

BEGIN
DECLARE   P_��������  CHAR(8);

--SET       P_��������  = '20130630';
--SET       P_��������  = '20131231';
--SET       P_��������  = '20140630';
--SET       P_��������  = '20141231';
--SET       P_��������  = '20150630';
--SET       P_��������  = '20151231';
--SET       P_��������  = '20160630';
SET       P_��������  = '20161231';

DELETE   #TEMP_BSS���  WHERE  ��������  = P_��������;

INSERT INTO #TEMP_BSS���
SELECT      P_��������                         --��������
           ,TA.ACNO                            --���¹�ȣ
           ,MAX(TB.CMBN_GD)   AS CMBN_GD       --���յ��
FROM       (--�Ǹ��ȣ, ���¹�ȣ����
            SELECT   A.ACNO                      --���¹�ȣ
                    ,MAX(A.STD_YM)  AS STD_YM    --BS������(���س��)
            FROM     DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  A  --DWF_CSS_���ο�BSS����⺻
            WHERE    1=1
            --AND      A.STD_YM >= DATEFORMAT(DATEADD(MM,-13,P_��������), 'YYYYMMDD')  --�۾��������� ���� �ֱ� 1�� ����
            AND      A.STD_YM <= LEFT(P_��������,6)
            //---------------------------------------------------------------------------------------------------
            AND      A.ACNO IN ( SELECT ���հ��¹�ȣ FROM #�����ڱ�  WHERE ��������  = P_��������)
            //---------------------------------------------------------------------------------------------------
            GROUP BY A.ACNO
            )                                  TA
           ,DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  TB  --DWF_CSS_���ο�BSS����⺻
WHERE       TA.ACNO        = TB.ACNO
AND         TA.RNNO        = TB.RNNO
AND         TA.STD_YM      = TB.STD_YM
GROUP BY    TA.ACNO;

END;

-- �������ں��� ������ Ȯ��
SELECT ��������,COUNT(*) FROM #TEMP_BSS���
GROUP BY ��������
ORDER BY 1

-- �����ߺ����� Ȯ��
SELECT   ��������,���¹�ȣ,COUNT(*) FROM  #TEMP_BSS���
GROUP BY ��������,���¹�ȣ
HAVING COUNT(*) > 1


-- CASE 2
UPDATE      #TEMP_�������  A
SET         A.BSS�ſ���          = B.BSS_CRDT_GD         --BSS�ſ���
           ,A.���������������� = B.CMBN_GD             --����������������
FROM        (
            --20120924 : 20120925�Ϻ��� ����(�������� 20120924���� ����) :
            --DWF_CSS_���ο�BSS����⺻ : �Ŵ� Ȱ�����¿� ���� ��޻���.
            --�߾�ȸ���º� : TB_DWF_CSS_AIO_BSS_RSLT_BC(DWF_CSS_���ο�BSS����⺻)
            --'20120924' ���� �߾�ȸ �����͸�
            -- JOIN ����   ���� : �Ǹ��ȣ, ���¹�ȣ  => ����ȣ, ���¹�ȣ
            -- 20171130 ���̺��濡 ���� ���� (DWF_CSS_���ο�BSS����⺻ => SOR_CSS_�ҸŸ���BSS����⺻)
            -- SOR_CSS_�ҸŸ���BSS����⺻ ���� 201710 ������ ���� �� �ִ�
            SELECT   TA.STD_YM                          --BS������(���س��)
                    ,TA.CUST_NO                         --����ȣ
                    ,TA.ACNO                            --���¹�ȣ
                    ,TB.APC_ASSC_GD  AS BSS_CRDT_GD     --BSS���(��û��������� BSS������� ���)
                    ,TB.CMBN_GD                         --���յ��
            FROM     (--�Ǹ��ȣ, ���¹�ȣ����
                      SELECT   A.CUST_NO                   --����ȣ
                              ,A.ACNO                      --���¹�ȣ
                              ,MAX(A.STD_YM)  AS STD_YM    --BS������(���س��)
                      FROM     DWZOWN.TB_SOR_CSS_RM_BSS_RSLT_BC  A  -- SOR_CSS_�ҸŸ���BSS����⺻
          --          FROM     DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  A  --DWF_CSS_���ο�BSS����⺻
                      WHERE    A.STD_YM BETWEEN '201701'  AND '201801'  -- �������ڷ� ���� �ֱ� 1��ġ �� ������.
                      GROUP BY A.CUST_NO
                              ,A.ACNO
                     )                                  TA
                    ,DWZOWN.TB_SOR_CSS_RM_BSS_RSLT_BC  TB  -- SOR_CSS_�ҸŸ���BSS����⺻
          --        ,DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  TB  --DWF_CSS_���ο�BSS����⺻
            WHERE    TA.ACNO        = TB.ACNO
            AND      TA.CUST_NO     = TB.CUST_NO
            AND      TA.STD_YM      = TB.STD_YM
            ) B
WHERE       A.��������        = '201712'
AND         A.���հ��¹�ȣ    = B.ACNO        --���¹�ȣ
AND         A.����ȣ        = B.CUST_NO     --����ȣ
;

-- �� UPDATE������ �����ص� ���� ���� �־ �����̺��� �̿��Ͽ� �����Ѵ�.
UPDATE      #TEMP_�������  A
SET         A.BSS�ſ���          = B.BSCORE_GRD     --BSS�ſ���
           ,A.���������������� = B.COMBSCORE_GRD  --����������������
FROM        (
              --20120924 : 20120925�Ϻ��� ����(�������� 20120924���� ����)
              --�߾�ȸ���º� : TB_DWF_CSS_AIO_BSS_RSLT_BC(DWF_CSS_���ο�BSS����⺻)
              --'20120924' ���� �߾�ȸ �����͸�  TB_DWF_CSS_AIO_BSS_RSLT_BC(DWF_CSS_���ο�BSS����⺻) �� �̿��Ͽ� ����� ���Ѵ�.
              --DWF_CSS_���ο�BSS����⺻ : �Ŵ� Ȱ�����¿� ���� ��޻���.
              SELECT      TA.STD_YM                          --BS������(���س��)
                         ,TA.CUST_NO                         --����ȣ
                         ,TA.ACNO                            --���¹�ȣ
                         ,TB.APC_ASSC_GD  AS BSCORE_GRD      --BSS���(��û��������� BSS������� ���)
                         ,TB.CMBN_GD      AS COMBSCORE_GRD   --���յ��
              FROM        (
                           --�Ǹ��ȣ, ���¹�ȣ����
                           SELECT   A.CUST_NO                   --����ȣ
                                   ,A.ACNO                      --���¹�ȣ
                                   ,MAX(A.STD_YM)  AS STD_YM    --BS������(���س��)
                           FROM     DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  A  --DWF_CSS_���ο�BSS����⺻
                           WHERE    A.STD_YM BETWEEN '201701'  AND '201801'  --�۾��������� ���� �ֱ� 1�� ����
                           GROUP BY A.CUST_NO
                                   ,A.ACNO
                          )                                  TA
                         ,DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  TB  --DWF_CSS_���ο�BSS����⺻
              WHERE       TA.ACNO        = TB.ACNO
              AND         TA.CUST_NO     = TB.CUST_NO
              AND         TA.STD_YM      = TB.STD_YM
            )  B
WHERE       A.��������        = '201712'
AND         A.���հ��¹�ȣ    = B.ACNO        --���¹�ȣ
AND         A.����ȣ        = B.CUST_NO     --����ȣ
AND         ( A.BSS�ſ��� IS NULL OR A.���������������� IS NULL )


//}

//{ #��ȯ����  #��ȯ
LEFT OUTER JOIN
            (
             SELECT       CLN_ACNO
                         ,CLN_EXE_NO
                         ,LEFT(TR_DT,4)  AS ��ȯ�⵵
                         ,SUM(TR_PCPL)   AS ��ȯ�ݾ�
             FROM         DWZOWN.TB_SOR_LOA_TR_TR     A       --  LOA_�ŷ�����
             WHERE        A.TR_DT   >= '20090101'
             AND          A.TR_STCD    = '1'           --�ŷ������ڵ�:1(����)
             AND          A.TR_PCPL > 0                --�ŷ�����
             AND          A.CLN_TR_KDCD ='300'         --���Űŷ������ڵ�:300(�����ȯ)
--           AND          A.TR_AF_RMD = 0              --�����Ȱ��¸�
             GROUP BY     CLN_ACNO,CLN_EXE_NO,��ȯ�⵵
            )     J

//}

//{  #�űԿ���   #��ȭ�����

-- 1. ��ȭ�����, ����ű�
SELECT      A.STD_DT                               AS ��������
           ,A.BRNO                                 AS ����ȣ
           ,J.BR_NM                                AS ����

           ,CASE WHEN A.FRPP_KDCD   IN ('2')  AND  A.PRD_BRND_CD =  '5025' AND A.LN_SBCD IN ('369','370')  THEN '1. �·���'
--                 WHEN A.FRPP_KDCD   IN ('2')  AND  A.PDCD  IN  ( '20387500100001','20387500200001')        THEN '5. ���ȼ���'
                 WHEN A.FRPP_KDCD   IN ('2')                                                               THEN '3. ��å'

                 WHEN (A.BS_ACSB_CD IN ('17005211',                        --��Ÿ�����ü��ڱݴ���
                                        '17002811')) THEN                  --��Ÿ���������ڱݴ���
                       CASE WHEN A.PRD_BRND_CD IN ('1085',                 --����ش���
                                                   '1026',                 --����ð濵�����ڱݴ���
                                                   '1029',                 --����������ġ��ü�������
                                                   '1116',                 --�߼ұ��������ܴ���
                                                   '1132',                 --��⵵����ü�߼ұ�������ڱݴ���
                                                   '1140',                 --�һ���������ڱݴ���
                                                   '1150',                 --�һ������ȯ����
                                                   '1028',                 --�߰� 2016.08.18
                                                   '1155') THEN '3. ��å'     --�߰� 2016.08.18
                            ELSE                                '2. �����Ϲ�'
                       END
                 WHEN A.BS_ACSB_CD  IN ('17010111','17010211')  THEN  '2. �����Ϲ�'   --�����ؾ��Ϲݽü��ڱݴ���, �����ؾ��Ϲݿ����ڱݴ��� �߰�
                 WHEN A.LN_MKTG_DSCD IS NOT NULL  AND  A.LN_MKTG_DSCD > '0'                                THEN '4. ������'
                 ELSE '1. �Ϲ�'
            END   AS    ����ݱ���


           ,CASE WHEN LEFT(CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN FST_LN_DT ELSE AGR_DT END,6) = LEFT(A.STD_DT,6)
                   THEN  1
                   ELSE  0
            END                                 AS ����űԿ���

           ,CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN LN_EXE_AMT ELSE AGR_AMT END  AS �űԴ��ݾ�

           ,CASE WHEN  ����ݱ��� = '3. ��å' THEN  'D.��å'
                 ELSE  CASE WHEN K.ACSB_CD5   =   '14002501'   THEN   'A.����'
                            WHEN K.ACSB_CD5   =   '14002401'   THEN   'B.���'
                            WHEN K.ACSB_CD5   =   '14002601'   THEN   'C.����'
                            WHEN K.ACSB_CD5   =   '14002511'   THEN   'D.��ȭ����ä'
                            ELSE 'E.��Ÿ'
                       END
            END                                     AS  �ڱݱ���

           ,CASE WHEN K.ACSB_CD5 = '14002401' THEN --���
             CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999'
                    AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014����� 88�� ������� ���Խ�Ų��.
                  THEN CASE WHEN ISNULL(D.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.����'  ELSE '2.�߼ұ��'  END
             ELSE '3.���λ����'
             END
            END                                    AS �������

           ,A.INTG_ACNO                            AS ���հ��¹�ȣ
           ,A.CLN_EXE_NO                           AS ���Ž����ȣ
           ,A.CUST_NO                              AS ����ȣ
           ,A.MRT_CD                               AS �㺸�ڵ�

           ,A.FST_LN_DT                            AS �����������
           ,A.LN_EXE_AMT                           AS �������ݾ�


INTO        #������ --DROP TABLE #������

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A  --DWA_���տ��ű⺻

JOIN        DWZOWN.OT_DWA_DD_BR_BC        J  --DWA_�����⺻
            ON   A.BRNO        = J.BRNO
            AND  A.STD_DT      = J.STD_DT

JOIN        (
                  SELECT   STD_DT
                          ,ACSB_CD
                          ,ACSB_NM
                          ,ACSB_CD4  --��ȭ�����
                          ,ACSB_NM4
                          ,ACSB_CD5  --����ڱݴ����(14002401), �����ڱݴ����(14002501), �����ױ�Ÿ(14002601)
                          ,ACSB_NM5
                          ,ACSB_CD6
                          ,ACSB_NM6
                  FROM     OT_DWA_DD_ACSB_TR
                  WHERE    1=1
                  AND      FSC_SNCD IN ('K','C')
                  AND      ACSB_CD4 IN ('13000801')       --��ȭ�����
            )           K
            ON       A.BS_ACSB_CD   =   K.ACSB_CD
            AND      A.STD_DT       =   K.STD_DT


LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_����Ը�⺻
            ON     A.RNNO      = D.RNNO
            AND    A.STD_DT    = D.STD_DT

WHERE       1=1
AND         A.STD_DT   IN  (
                              SELECT   MAX(STD_DT)  AS ��������
                              FROM     DWZOWN.OT_DWA_INTG_CLN_BC A
                              WHERE    1=1
                              AND      STD_DT BETWEEN '20130101'  AND  '20170831'
                              GROUP BY LEFT(STD_DT,6)
                           )
AND         A.CLN_ACN_STCD  <>  '3'                     -- ��Ұ�����
AND         A.FRPP_KDCD     <> '4'                      --  ��ǥ�����ڵ�(4:����) ����
AND         A.FST_LN_DT IS NOT NULL
AND         A.BR_DSCD  =  '1'                          -- �߾�ȸ
AND         ����űԿ��� =  1
;

//}

//{ #�ű�  #�űԳ��� #���տ���
-- 1. ���տ����� �Ϻ��� ������ �űԺ��� �������� ���

SELECT             A.STD_DT,ACSB_CD5,FRPP_KDCD,INTG_ACNO, CLN_EXE_NO, AGR_DT,FST_LN_DT,A.BS_ACSB_CD,CUST_DSCD,RNNO,FXN_FLX_DSCD,CLN_IRT_DSCD,ENTP_CRGR_JUD_DT,BR_DSCD,ENTP_CREV_GD,LN_RMD,APL_IRRT,MRT_CD,LN_EXE_AMT,AGR_AMT,APRV_AMT,BRNO
                  ,A.EXPI_DT
                  ,A.LN_TRM_MCNT
                  ,A.LN_IRT_FLX_MCNT
INTO               #PRE_������     -- DROP TABLE #PRE_������
FROM               DWZOWN.OT_DWA_INTG_CLN_BC    A
JOIN               (
                          SELECT   STD_DT
                                  ,ACSB_CD
                                  ,ACSB_NM
                                  ,ACSB_CD4  --��ȭ�����
                                  ,ACSB_NM4
                                  ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                                  ,ACSB_NM5
                          FROM     OT_DWA_DD_ACSB_TR
                          WHERE    FSC_SNCD IN ('K','C')
--                                                        AND      ACSB_CD4 = '13000801'                                      -- ��ȭ�����
                          AND      ACSB_CD5 IN ('14002401')   --�������ݰ���
                   )           C
                   ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS���������ڵ�
                   AND      A.STD_DT       =   C.STD_DT
WHERE              CASE WHEN A.FRPP_KDCD = '4' THEN A.AGR_DT ELSE A.FST_LN_DT END  BETWEEN '20110101' AND  '20111231'
AND                A.BR_DSCD      = '1'
AND                A.CLN_ACN_STCD  = '1'
AND                A.STD_DT    BETWEEN '20110101' AND  '20111231'
;


SELECT              F.������            AS ��������
                   ,B.INTG_ACNO         AS ���¹�ȣ
                   ,B.CLN_EXE_NO        AS �����ȣ
                   ,CASE WHEN B.FRPP_KDCD = '4' THEN B.AGR_DT ELSE B.FST_LN_DT END    AS �ű�����
                   ,CASE WHEN B.ACSB_CD5 = '14002401'     THEN            -- ����ڱݴ���ݿ� ���ؼ��� �з�
                         CASE WHEN B.CUST_DSCD  NOT IN ('01','07')  AND B.RNNO < '9999999999' AND SUBSTRING(B.RNNO,4,2) BETWEEN '81' AND '87'  THEN
                                   CASE WHEN D.ENTP_SCL_DTL_DSCD = '01' THEN '1. ����'
                                        ELSE '2. �߼ұ��'
                                   END
                              ELSE '3. ���λ����'
                         END
                         ELSE NULL
                    END                               AS �������
                   ,B.FST_LN_DT                       AS ���ʴ�����
                   ,B.EXPI_DT                         AS ������
                   ,B.AGR_DT                          AS ������
                   ,B.LN_TRM_MCNT                     AS ����Ⱓ������
                   ,B.LN_IRT_FLX_MCNT                 AS ����ݸ�����������

                  ,CASE WHEN (B.CLN_IRT_DSCD  IN ('003','011','008','017')      OR
                             (B.CLN_IRT_DSCD = '024' AND B.FXN_FLX_DSCD = '01') OR
                             (B.CLN_IRT_DSCD = '501' AND B.FXN_FLX_DSCD = '01') )  THEN '1. ����' --���űݸ������ڵ�
                        ELSE '2. ����'
                   END   AS  ���������ݸ������ڵ�1

                   ,CASE WHEN  ����ݸ����������� >= ����Ⱓ������   THEN '1. ����'
                         ELSE                                              '2. ����'
                    END                                    AS ���������ݸ������ڵ�2

                   ,B.CLN_IRT_DSCD                         AS ���űݸ������ڵ�
                   ,B.FXN_FLX_DSCD
                   ,B.LN_RMD                               AS �ܾ�
                   ,B.APL_IRRT                             AS ��������
                   ,CASE WHEN B.ACSB_CD5 = '14002401'     THEN            -- ����ڱݴ���ݿ� ���ؼ��� �з�
                         CASE WHEN B.MRT_CD BETWEEN '501' AND '529'                 THEN '1. ��������'
                              WHEN ( B.MRT_CD < '100' OR B.MRT_CD IN ('601','602')) THEN '2. �ſ����'
                              ELSE                                                       '3. �㺸����'
                         END
                         ELSE NULL
                    END                                    AS ����㺸����

                   ,CASE WHEN B.ACSB_CD5 = '14002501'     THEN            -- �����ڱݴ����
                         CASE WHEN B.MRT_CD < '100' OR B.MRT_CD IN ('601','602')   THEN '2. �ſ����'
                               ELSE                                                     '3. �㺸����'
                         END
                         ELSE NULL
                    END                                     AS ����㺸����

                   ,CASE WHEN B.FRPP_KDCD = '4'  THEN B.AGR_AMT
                         ELSE B.LN_EXE_AMT
                    END                                     AS �����ݾ�
INTO                #������_��޾�              -- DROP TABLE  #������_��޾�
FROM
                  (
                  SELECT             INTG_ACNO
                                    ,CLN_EXE_NO
                                    ,CASE WHEN FRPP_KDCD = '4' THEN AGR_DT
                                          ELSE '99999999'
                                     END                AS ��������_
                                    ,MIN(A.STD_DT)      AS ��������
                    FROM               #PRE_������    A
                    WHERE              STD_DT >  '19000000'
                  GROUP BY           INTG_ACNO,CLN_EXE_NO,��������_

                  )  A

JOIN                #PRE_������       B
                    ON         A.INTG_ACNO  = B.INTG_ACNO
                    AND        A.CLN_EXE_NO = B.CLN_EXE_NO
                    AND        A.��������_  = CASE WHEN B.FRPP_KDCD = '4' THEN B.AGR_DT ELSE '99999999' END
                    AND        A.��������   = B.STD_DT

LEFT OUTER JOIN    (
                        SELECT   STD_DT
                                ,RNNO
                                ,ENTP_SCL_DTL_DSCD
                                ,BZNS_NM
                        FROM     DWZOWN.OT_DWA_ENTP_SCL_BC -- (DWA_����Ը�⺻)
                   )          D
                   ON         B.RNNO       = D.RNNO                                                 -- �Ǹ��ȣ
                   AND        B.STD_DT     = D.STD_DT

JOIN               OT_DWA_DD_BR_BC      E       -- DWA_�����⺻
                   ON         B.STD_DT       = E.STD_DT
                   AND        B.BRNO         = E.BRNO
                   AND        E.BR_DSCD      = '1'   -- �߾�ȸ
                   AND        E.FSC_DSCD     = '1'   -- �ſ�
                   AND        E.BR_KDCD      < '40'  -- 10:���κμ�,20:������,30:������

LEFT OUTER JOIN    (
                        SELECT   LEFT(STD_DT,6) ���س��, MAX(STD_DT) ������
                        FROM     OT_DWA_INTG_CLN_BC   A
                        WHERE    STD_DT BETWEEN  '20110101' AND '20111231'
                        GROUP BY LEFT(STD_DT,6)
                   )                  F
                   ON   LEFT(CASE WHEN B.FRPP_KDCD = '4' THEN B.AGR_DT ELSE B.FST_LN_DT END,6)   =  F.���س��
;

-- �⸻(�����е� ���ԵǾ� ����)���տ����ڷ�� ���ؽűԺ� �����ѰͰ� �� �������� �űԺ� ������ ���� ���ϱ� ���� ����
-- �񱳰�� ����ġ�� ������ �Ǵ� �͵���
-- ���տ��ſ� ��Ұ��µ� �����Ƿ� �Ʒ��� ���� �ϸ� ��ҵ� ���µ� ��ҵǱ��������� ����ִ� ���� �̹Ƿ� �ű԰��·� ���ԵǾ� ���´�
-- ���տ��ſ� ��Ÿ�������� �������·� ������ �͵� ����
-- ���տ��ſ� ��Ÿ������ ��ȭ�����(����ڱݴ���� �Ǵ� �����ڱݴ����) �̾����� �Ŀ� �����ڵ尡 �ٲ� �����ٱ����� ���� ���� ��� ����
-- �ݴ�� �����ٱ��� �������� �ű԰� �߻��Ǿ��ٰ� �Ŀ� ���������� �����ڵ尡 �ٲ�� ��찡 ������ ���������� ����
SELECT  A.*
FROM   OT_DWA_INTG_CLN_BC  A
JOIN               (
                          SELECT   STD_DT
                                  ,ACSB_CD
                                  ,ACSB_NM
                                  ,ACSB_CD4  --��ȭ�����
                                  ,ACSB_NM4
                                  ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                                  ,ACSB_NM5
                          FROM     OT_DWA_DD_ACSB_TR
                          WHERE    FSC_SNCD IN ('K','C')
--                                                        AND      ACSB_CD4 = '13000801'                                      -- ��ȭ�����
                          AND      ACSB_CD5 IN ('14002401')   --�������ݰ���
                   )           C
                   ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS���������ڵ�
                   AND      A.STD_DT       =   C.STD_DT
LEFT OUTER JOIN
         (
            SELECT  ���¹�ȣ, �����ȣ
            FROM    #������_��޾�
            WHERE ��ǥ���� <> '4'
         )   D
         ON   A.INTG_ACNO   =  D.���¹�ȣ
         AND  A.CLN_EXE_NO  =  D.�����ȣ

WHERE   A.STD_DT = '20131231'
AND     A.FRPP_KDCD <> '4'
AND     A.FST_LN_DT BETWEEN  '20130101' AND '20131231'
AND     D.���¹�ȣ IS NULL
;


SELECT   A.*
FROM    #������_��޾�    A

LEFT OUTER JOIN
        (
        SELECT  A.INTG_ACNO, A.CLN_EXE_NO
        FROM   OT_DWA_INTG_CLN_BC  A
        JOIN               (
                      SELECT   STD_DT
                          ,ACSB_CD
                          ,ACSB_NM
                          ,ACSB_CD4  --��ȭ�����
                          ,ACSB_NM4
                          ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                          ,ACSB_NM5
                      FROM     OT_DWA_DD_ACSB_TR
                      WHERE    FSC_SNCD IN ('K','C')
        --                                                        AND      ACSB_CD4 = '13000801'                                      -- ��ȭ�����
                      AND      ACSB_CD5 IN ('14002401')   --�������ݰ���
                   )           C
                   ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS���������ڵ�
                   AND      A.STD_DT       =   C.STD_DT
                 WHERE    1=1
                 AND      A.STD_DT  = '20131231'
                 AND      A.FRPP_KDCD <>  '4'
         )    D
         ON   A.���¹�ȣ  =  D.INTG_ACNO
         AND  A.�����ȣ  =  D.CLN_EXE_NO

WHERE   A.��ǥ���� <> '4'
AND     D.INTG_ACNO IS NULL

-- 2.���տ����� ���������� ������ ����űԺ��� �����Ͽ��� ���

SELECT             A.STD_DT                     AS  ��������
                  ,A.INTG_ACNO                  AS  ���¹�ȣ
                  ,A.CLN_EXE_NO                 AS  ���Ž����ȣ
                  ,C.ACSB_NM6                   AS  �������и�
                  ,A.AGR_DT                     AS  ��������
                  ,A.AGR_AMT                    AS  �����ݾ�
                  ,A.FST_LN_DT                  AS  ��������
                  ,A.EXPI_DT                    AS  ��������
                  ,A.PSTP_ENR_DT                AS  ��������
                  ,A.CLN_IRT_DSCD               AS  ���űݸ������ڵ�
                  ,A.LN_RMD                     AS  �ܾ�
                  ,A.LN_EXE_AMT                 AS  �������ݾ�
                  ,A.STD_IRT                    AS  ���رݸ�
                  ,A.ADD_IRT                    AS  ����ݸ�
                  ,A.APL_IRRT                   AS  ����ݸ�
                  ,A.CLN_RDM_MHCD               AS  ���Ż�ȯ����ڵ�   -- (1:�����Ͻû�ȯ, 2~  :���һ�ȯ)

INTO               #������_���           --  DROP TABLE #������_���
FROM               DWZOWN.OT_DWA_INTG_CLN_BC A   --DWA_���տ��ű⺻

JOIN               (
                 SELECT   STD_DT
                         ,ACSB_CD
                         ,ACSB_NM
                         ,ACSB_CD4  --��ȭ�����
                         ,ACSB_NM4
                         ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                         ,ACSB_NM5
                         ,ACSB_CD6  --��������ڱݴ����(15002001), ����ü��ڱݴ����(15002101)
                         ,ACSB_NM6
                 FROM     OT_DWA_DD_ACSB_TR
                 WHERE    1=1
                 AND      FSC_SNCD      IN ('K','C')
                 AND      ACSB_CD5      = '14002401'     --����ڱݴ����
                   )          C
                   ON    A.BS_ACSB_CD  =  C.ACSB_CD
                   AND   A.STD_DT      =  C.STD_DT

WHERE              A.STD_DT   IN  (
                                     SELECT   MAX(STD_DT)  AS ��������
                                     FROM     DWZOWN.OT_DWA_INTG_CLN_BC A
                                     WHERE    1=1
                                     AND      STD_DT BETWEEN '20120101'  AND  '20140630'
                                     GROUP BY LEFT(STD_DT,6)
                                  )
AND                A.CLN_ACN_STCD     = '1'   --���Ű��»����ڵ�:1(����)
AND                A.BR_DSCD          = '1'   --�߾�ȸ
AND                A.CLN_TSK_DSCD    <> '90'  --���ž��������ڵ�:90(Ư��ä��)
AND                A.INDV_LMT_LN_DSCD = '1' --  �����ѵ����ⱸ���ڵ�(1:�Ǻ��ŷ�����, 2:�ѵ��ŷ�����)
AND                A.FRPP_KDCD       <> '4'     --  ��ǥ�����ڵ�(4:����) ����
AND                (
                         LEFT(A.STD_DT,6) = LEFT(A.AGR_DT,6)  OR                        -- �����̳� ������ �űԷ� ��
                         LEFT(A.STD_DT,6) = LEFT(ISNULL(A.PSTP_ENR_DT,'00000000'),6)
                   )
AND                A.CLN_IRT_DSCD IN ('005','021','026','030','031')  -- CD�ݸ�
;

-- 3. �űԱ��� (�Ϲݿ����� �����ϱ���, ������ ������ �������� �ű��Ǵ�, �űԱݾ׵� ����ݾװ� �����ݾ� �̿�)
SELECT
........
           ,CASE WHEN LEFT(CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN FST_LN_DT ELSE AGR_DT END,6) = LEFT(A.STD_DT,6)
                   THEN  1
                   ELSE  0
            END                                 AS ����űԿ���
           ,CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN LN_EXE_AMT ELSE AGR_AMT END  AS �űԴ��ݾ�
...........

SELECT
           ,CASE WHEN LEFT(CASE WHEN A.FRPP_KDCD = '4'  THEN AGR_DT ELSE FST_LN_DT END,6) = LEFT(A.STD_DT,6)
                   THEN  1
                   ELSE  0
            END                                 AS ����űԿ���
           ,CASE WHEN A.FRPP_KDCD = '4' THEN AGR_AMT  ELSE LN_EXE_AMT END  AS �űԴ��ݾ�
//}

//{ #�ϰ��±ݸ� #�ϰ��±ݸ����� #����ݸ� #�䱸�ұݸ�


-- CASE 1  ���տ����� ���� �ʰ� Ư�������� �ݸ��� �����´�

UPDATE      #TEMP_�⺻����  A
SET         A.���رݸ� =   B.STD_IRT
           ,A.����ݸ� =   B.APL_ADD_IRT
           ,A.����ݸ� =   B.APL_IRRT
FROM
           (          SELECT    A.STD_DT
                               ,A.CLN_ACNO
                               ,A.CLN_EXE_NO
                               ,A.CLN_APL_IRRT_DSCD                --�����������������ڵ�
                               ,A.APL_ADD_IRT                      --���밡��ݸ�
                               ,A.APL_IRRT                         --��������
                               ,A.ADD_IRT                          --����ݸ�
                               ,A.APL_ST_DT                        --�����������
                               ,A.APL_END_DT                       --������������
                       FROM     DWZOWN.TB_SOR_LOA_DDY_ACN_IRT_TZ   A
                               ,(
                                     SELECT   CLN_ACNO, CLN_EXE_NO , MAX(STD_DT)  AS �ֱٱ�����
                                     FROM     DWZOWN.TB_SOR_LOA_DDY_ACN_IRT_TZ
                                     WHERE    CLN_APL_IRRT_DSCD = '1'          --�����������������ڵ�(1:��������,9.��ü����)
                                     GROUP BY CLN_ACNO, CLN_EXE_NO
                                )   B

                       WHERE    1=1
                         AND    A.STD_DT            =  B.�ֱٱ�����
                         AND    A.CLN_ACNO          =  B.CLN_ACNO
                         AND    A.CLN_EXE_NO        =  B.CLN_EXE_NO
                         AND    A.CLN_APL_IRRT_DSCD = '1'          --�����������������ڵ�(1:��������,9.��ü����)
             )   B

WHERE        A.���¹�ȣ      =   B.CLN_ACNO
AND          A.���Ž����ȣ  =   B.CLN_EXE_NO
AND          A.�������� BETWEEN B.APL_ST_DT AND  B.APL_END_DT
--AND          (
--                  (  A.���رݸ� <>  ( B.APL_IRRT - B.APL_ADD_IRT ) )  OR
--                  (  A.����ݸ� <>   B.APL_ADD_IRT )                  OR
--                  (  A.����ݸ� <>   B.APL_IRRT    )
--             )


-- CASE 2  ����ݸ��� ���ڱ����� ���� ���ϸ����� �ݸ��� �������ѳ��Ҵ�

LEFT OUTER JOIN         -- ���������� �ݸ�
            DWZOWN.TB_SOR_LOA_ODMN_IRT_TR    G        -- SOR_LOA_�䱸�ұݸ�����
            ON            A.���հ��¹�ȣ  =   G.CLN_ACNO
            AND           A.���Ž����ȣ  =   G.CLN_EXE_NO
            AND           A.��������      =   G.STD_DT

LEFT OUTER JOIN         -- �������������
            DWZOWN.TB_SOR_LOA_ODMN_IRT_TR    H        -- SOR_LOA_�䱸�ұݸ�����
            ON            A.���հ��¹�ȣ  =   H.CLN_ACNO
            AND           A.���Ž����ȣ  =   H.CLN_EXE_NO
            AND           C.��������      =   H.STD_DT


//}

//{ #�����ݸ� #�����ݸ� #�������� #�ݸ����� #�ݸ������ֱ� #�ݸ��ֱ�

# ALM ���� �ݸ����б��� 1 : �ڵ� 063(2015.04.10) �߰�, �ڵ� 008(2015.08.17) �߰�, 509(ȥ�ձݸ�����,2017.09) �߰�
                  ,CASE WHEN A.CLN_IRT_DSCD IN  ('063')  OR
                             ( A.CLN_IRT_DSCD IN  ('509')  AND A.STD_DT < C.FLX_IRT_STD_DT )  OR
                             (
                                    A.CLN_IRT_DSCD in ('012','503','017','060','016','003','501','024','018','061','019','000','011','015','502','063','008')
                               AND  AA.LN_IRT_FLX_MCNT = 0
                             )                             THEN   '1. �����ݸ�'
                        WHEN  A.CLN_IRT_DSCD = '509'       THEN   '3. ȥ�ձݸ�'
                        ELSE                                      '2. �����ݸ�'
                   END                                             AS   �ݸ�����

                  ,CASE WHEN �ݸ����� = '1. �����ݸ�' THEN 0  ELSE AA.LN_IRT_FLX_MCNT END AS  ����ݸ�����������

FROM               DWZOWN.OT_DWA_INTG_CLN_BC    A

JOIN               DWZOWN.OT_DWA_DD_BR_BC       B              -- DWA_�����⺻
                   ON     A.BRNO         = B.BRNO
                   AND    A.STD_DT       = B.STD_DT

JOIN               DWZOWN.TB_SOR_LOA_ACN_BSC_DL C               --SOR_LOA_���±⺻��
                   ON     A.INTG_ACNO    =  C.CLN_ACNO

JOIN               DWZOWN.TT_SOR_LOA_MM_ACN_BC    AA            --SOR_LOA_�����±⺻
                   ON     LEFT(A.STD_DT,6)  = AA.STD_YM
                   AND    A.INTG_ACNO       = AA.CLN_ACNO

# ALM ���� �ݸ����б��� 2 ( ���ټ���)
             CASE WHEN A.CLN_IRT_DSCD IN  ('000','002','003','008','011','012','013','015','016','017','018','019','024','060','061','501','502','503')
                       AND b.LN_IRT_FLX_MCNT = 0   THEN   '�����ݸ�'
                  WHEN A.CLN_IRT_DSCD IN  ('063')  THEN   '�����ݸ�'
                  WHEN A.CLN_IRT_DSCD IN  ('001')  THEN   '�����ݸ����� �� �����ӷ���Ʈ����'
                  WHEN A.CLN_IRT_DSCD IN  ('017')
                       AND b.LNDS_IRT_DSCD in ('11','12','13','21','22','23','24','25','26','31','41','51','71','72','73')
                                                   THEN   '�����ݸ����� �� ����ݸ�����'
                  WHEN A.CLN_IRT_DSCD IN  ('021','022','025','026','027','30','55','56','601','602','603')  THEN   '�����ݸ����� �� ����ݸ�����'
                  WHEN A.CLN_IRT_DSCD IN  ('501')
                       AND b.LN_IRT_FLX_MCNT <> 0  THEN   '�����ݸ����� �� ����ݸ�����'
                  WHEN A.CLN_IRT_DSCD IN  ('014','023')  THEN   '�����ݸ����� �� ���űݸ�����'
                  WHEN A.CLN_IRT_DSCD IN  ('015')
                       AND b.LN_IRT_FLX_MCNT = 6   THEN   '�����ݸ����� �� ���űݸ�����'
                  WHEN A.CLN_IRT_DSCD IN  ('016')
                       AND b.LN_IRT_FLX_MCNT = 12  THEN   '�����ݸ����� �� ���űݸ�����'
                  WHEN A.CLN_IRT_DSCD IN  ('024')
                       AND b.LN_IRT_FLX_MCNT <> 0  THEN   '�����ݸ����� �� ���űݸ�����'
                  WHEN A.CLN_IRT_DSCD IN  ('004','028','029')  THEN   '�����ݸ����� �� COFIX����'
                  WHEN A.CLN_IRT_DSCD IN  ('015')
                       AND b.LN_IRT_FLX_MCNT = 3   THEN   '��Ÿ�����ݸ�'
                  WHEN A.CLN_IRT_DSCD IN  ('017')
                       AND b.LNDS_IRT_DSCD in ('61','62')
                                                   THEN   '��Ÿ�����ݸ�'
                  WHEN A.CLN_IRT_DSCD IN  ('062')  THEN   '��Ÿ�����ݸ�'
             ELSE '��Ÿ�ݸ�'
             END           AS �ݸ�����

//}

//{ #������ձݸ�  #�������
-- CASE 1  �ܾ��� 0 �ΰ��� �����ϰ� ��������Ѵ�
SELECT
           ,A.MRT_CD                     AS  �㺸�ڵ�
           ,F.MRT_TPCD                   AS  �㺸�����ڵ�
           ,SUM(A.LN_RMD)                AS  �ܾ�
           ,CASE WHEN A.FRPP_KDCD  =  '4' THEN  CONVERT(NUMERIC(7,5),MAX(A.APL_IRRT))
                 ELSE
                   CONVERT(NUMERIC(7,5),
                       CASE WHEN SUM(CASE WHEN A.APL_IRRT <> 0 THEN  A.LN_RMD ELSE 0 END) = 0 THEN 0
                            ELSE
                            SUM(CASE WHEN A.APL_IRRT <> 0 THEN  A.LN_RMD * A.APL_IRRT  ELSE 0 END)
                          / SUM(CASE WHEN A.APL_IRRT <> 0 THEN  A.LN_RMD               ELSE 0 END)
                       END
                   )
            END                                                        AS  ��������

INTO        #����ڱ�   -- DROP TABLE #����ڱ�

GROUP BY    A.FRPP_KDCD
;

//}

//{ #�����ڱ�
--  UP_DWZ_����_N0190_�����ڱݴ�����Ȳ
           ,CASE  WHEN  A.PDCD IN ('20051000800001',
                                   '20051000900001',
                                   '20051103102001',
                                   '20051105703011',
                                   '20051105703021',
                                   '20055000200001',
                                   '20055100202001',
                                   '20055101705001',
                                   '20056000100001',
                                   '20056000200001',
                                   '20056103102001',
                                   '20056105703011',
                                   '20056105703021')   THEN 'Y'
                  ELSE                                      'N'
            END   AS �����ڱݿ���
//}

//{ #�ε���㺸  #�ε���
,CASE WHEN A.MRT_CD BETWEEN '100' AND '199'  THEN  'Y'  ELSE 'N' END  AS �ε���㺸���⿩��
--  �̺���
--(1) �ε���㺸 : �㺸�ڵ� 100����
--��,  �ε���(����) ��з� �ȿ�  200���� �㺸�� �ΰ� ������ ����.
--'���ô㺸���� ��' ���̶�� ���ѿ���� ���ų� ��ȭ����� ��ü�� ���� ������ ��� �Ʒ��� �㺸�� �������� �´� ������ �����˴ϴ�.
--������ �̹� ������� ��ܺ���� ���ν��� ��� �ݿ��� �ȵǾ��ִ� ������ ���̱�� �Ͽ� ������ ������� �帮�� �ʰ� �ֽ��ϴ� �Ф�
--      1. 20��̸��          216
--      2. 20��̸� ��Ÿ����   217

//}

//{ #����Ʈ�㺸  #����Ʈ
CASE WHEN A.MRT_CD IN  ('101','170')        THEN  'Y'  ELSE 'N' END  AS ����Ʈ�㺸���⿩��
//}

//{ #Ư��ä�� #���ΰ���  #���¿���

LEFT OUTER JOIN
--  Ư��ä�ǿ��忡 ���߻��������հ��¹�ȣ�� �����ص� �Ǵµ� ������ ���� ������ ���߻��������հ��¹�ȣ�� ��ȯ��
--  ���¹�ȣ�� �ִ°�쵵 �־ ���¿���⺻�� �̿��ؼ� �����ϴ°� ��Ȯ�� (�̻���)
             (
                  SELECT   A.LNK_CLN_FCNO           AS  ���Ű��¹�ȣ
                          ,MIN(B.SPCT_BND_ADMS_DT)  AS  Ư��ä����������
                          ,MAX(A.CLN_ACNO)          AS  Ư��ä�ǰ��¹�ȣ
                          ,SUM(BDX_PCPL)            AS  �󰢿���
                  FROM     TB_SOR_LOA_ACN_LNK_BC A      -- SOR_LOA_���¿���⺻
                  JOIN     TB_SOR_WOL_SPRC_BC     B
                           ON  A.CLN_ACNO  =  B.CLN_ACNO
                  WHERE    A.CLN_ACN_LNK_KDCD  IN ('411','412','413','414','415','416','417')  -- ���Ű��¿��������ڵ�
                  AND      B.AMR_DSCD IN ('1','2')   --�󰢱����ڵ�(1:�ǹ���,2:�Ϲݻ�,3:�̼�����,4:��Ÿ)
                                   -- 411 ~ 417 Ư��ä�ǿ���
                  GROUP BY A.LNK_CLN_FCNO
             )   E
             ON   A.���հ��¹�ȣ  = E.���Ű��¹�ȣ

--  �Ű�ó���Ǽ���   TB_SOR_WOL_SLN_ACCT_BND_BC(SOR_WOL_�Ű�����ä�Ǳ⺻) �� �Ű����ڰ� �ִ°��� ã�����
--  Ư��ä�ǿ���� ���¹�ȣ,�����ȣ ����
--  ��ŰǼ��� ����������� ����"



-- Ư��ä�ǰ��¹�ȣ�� ���ΰ��¹�ȣ ã��
-- Ư��ä�ǿ��忡�� �ϳ��� Ư��ä�ǰ��¹�ȣ�� �����ȣ�� ������ ������ �־ DISTINCT ����� �Ѵ�
SELECT      DISTINCT
            T.����
           ,T.���¹�ȣ
           ,T.Ư��ä��������
           ,A.CLN_ACNO    AS Ư��ä�ǰ��¹�ȣ
           ,B.CLN_ACNO    AS ���ΰ��¹�ȣ

INTO        #���ΰ��¹�ȣ   -- DROP TABLE #���ΰ��¹�ȣ

FROM        #������   T

LEFT OUTER JOIN
            TB_SOR_WOL_SPRC_BC A
            ON   T.���¹�ȣ  = A.CLN_ACNO

LEFT OUTER JOIN
            TB_SOR_LOA_ACN_BC   B
            ON A.XPS_OCC_CAS_INTG_ACNO    = B.CLN_ACNO
;

--  ���ΰ��¹�ȣ ����� �־ ���¿���⺻���� �����Ѵ�
--  ���¿���⺻������ ���ΰ��¸� ã�ƺ��� ���� ����� �����.
UPDATE    #���ΰ��¹�ȣ  A
SET        A.���ΰ��¹�ȣ =  B.���ΰ��¹�ȣ
FROM       (
                  SELECT    T.����
                           ,T.���¹�ȣ
                           ,A.CLN_ACNO        AS Ư��ä�ǰ��¹�ȣ
                           ,A.LNK_CLN_FCNO    AS ���ΰ��¹�ȣ
                  FROM     #������  T
                  JOIN     TB_SOR_LOA_ACN_LNK_BC A      -- SOR_LOA_���¿���⺻
                           ON   T.���¹�ȣ  = A.CLN_ACNO
                         --  AND  A.CLN_ACN_LNK_KDCD  IN ('411','412','413','414','415','416','417')  -- ���Ű��¿��������ڵ�
                                   -- 411 ~ 417 Ư��ä�ǿ���
            )   B

WHERE       1=1
AND         A.���ΰ��¹�ȣ IS NULL
AND         A.Ư��ä�ǰ��¹�ȣ = B.Ư��ä�ǰ��¹�ȣ
;


//}

//{ #���ʰŷ���  #���ʰŷ� #���ʰ��¹�ȣ #������ #������ް��¹�ȣ #���������

--1. �ŷ��������� ���ʰŷ���(�����ȣ,�ŷ���ȣ�� ���ʰ�),���Ű��±⺻�� �ű�����ȣ(����)
--   ���Űŷ��������� ���ʰŷ�(�űԾ���, �������)���� �������� �����
--   �Ʒ� 2�� ����� ��������� ������ ���� ���;� �Ұ� ���� �ѵ� Ȯ���� ���غ� ����
--   �ε��������̺�(SOR_DAD_���������ʰ��±⺻)�� ��Ȯ�� ����� �˼� ����  �׳� �ϰ� ���� ���ۿ�
 SELECT     A.INTG_ACNO         AS ���¹�ȣ
           ,B.�ŷ�����ȣ        AS ��������ȣ
 INTO       #TEMP���ʰŷ���
 FROM       TB_SOR_DAD_MVT_FST_ACN_BC A    --SOR_DAD_���������ʰ��±⺻ (���������������� ��������ȯ���������� ������)
           ,(SELECT  A.TR_BRNO     AS �ŷ�����ȣ  --���ʰŷ�����ȣ
                    ,A.CLN_ACNO    AS ���¹�ȣ
             FROM    TB_SOR_LOA_TR_TR A   --SOR_LOA_�ŷ�����
                   ,(SELECT   MIN(A.CLN_TR_NO)   AS ���Űŷ���ȣ
                             ,A.CLN_ACNO         AS ���Ű��¹�ȣ
                             ,A.CLN_EXE_NO       AS ���Ž����ȣ
                     FROM     TB_SOR_LOA_TR_TR A   --SOR_LOA_�ŷ�����
                            ,(SELECT    MIN(CLN_EXE_NO)  AS ���Ž����ȣ
                                       ,CLN_ACNO         AS ���Ű��¹�ȣ
                              FROM      TB_SOR_LOA_TR_TR    --SOR_LOA_�ŷ�����
                              WHERE     TR_STCD = '1'       --�ŷ������ڵ�: ����
                              AND       CLN_TR_KDCD IN ('100','200') --���Űŷ������ڵ� : �űԾ��� ,�������
                              GROUP BY  ���Ű��¹�ȣ
                             ) B
                     WHERE    A.TR_STCD     = '1'       --�ŷ������ڵ�: ����
                     AND      A.CLN_TR_KDCD IN ('100','200') --���Űŷ������ڵ� : �űԾ��� ,�������
                     AND      A.CLN_EXE_NO  = B.���Ž����ȣ
                     AND      A.CLN_ACNO    = B.���Ű��¹�ȣ
                     GROUP BY ���Ű��¹�ȣ
                             ,���Ž����ȣ
                    ) B
             WHERE  A.TR_STCD      = '1'       --�ŷ������ڵ�: ����
             AND    A.CLN_TR_KDCD  IN ('100','200') --���Űŷ������ڵ� : �űԾ��� ,�������
             AND    A.CLN_TR_NO    = B.���Űŷ���ȣ
             AND    A.CLN_ACNO     = B.���Ű��¹�ȣ
             AND    A.CLN_EXE_NO   = B.���Ž����ȣ
             ) B
    WHERE    A.FST_INTG_ACNO = B.���¹�ȣ

    UNION ALL

    SELECT   A.���¹�ȣ
            ,CASE WHEN B.��������ȣ  IS NOT NULL  THEN B.��������ȣ
                  ELSE A.�ŷ�����ȣ  END  AS ��������ȣ
    FROM    (SELECT  A.TR_BRNO     AS �ŷ�����ȣ  --���ʰŷ�����ȣ
                    ,A.CLN_ACNO    AS ���¹�ȣ
             FROM    TB_SOR_LOA_TR_TR A   --SOR_LOA_�ŷ�����
                   ,(SELECT   MIN(A.CLN_TR_NO)   AS ���Űŷ���ȣ
                             ,A.CLN_ACNO         AS ���Ű��¹�ȣ
                             ,A.CLN_EXE_NO       AS ���Ž����ȣ
                     FROM     TB_SOR_LOA_TR_TR A   --SOR_LOA_�ŷ�����
                            ,(SELECT    MIN(CLN_EXE_NO)  AS ���Ž����ȣ
                                       ,CLN_ACNO         AS ���Ű��¹�ȣ
                              FROM      TB_SOR_LOA_TR_TR    --SOR_LOA_�ŷ�����
                              WHERE     TR_STCD = '1'       --�ŷ������ڵ�: ����
                              AND       CLN_TR_KDCD IN ('100','200') --���Űŷ������ڵ� : �űԾ��� ,�������
                              AND       CLN_ACNO    NOT IN (SELECT  INTG_ACNO  FROM TB_SOR_DAD_MVT_FST_ACN_BC)
                              GROUP BY  ���Ű��¹�ȣ
                             ) B
                     WHERE    A.TR_STCD     = '1'       --�ŷ������ڵ�: ����
                     AND      A.CLN_TR_KDCD IN ('100','200') --���Űŷ������ڵ� : �űԾ��� ,�������
                     AND      A.CLN_EXE_NO  = B.���Ž����ȣ
                     AND      A.CLN_ACNO    = B.���Ű��¹�ȣ
                     GROUP BY ���Ű��¹�ȣ
                             ,���Ž����ȣ
                    ) B
             WHERE  A.TR_STCD      = '1'       --�ŷ������ڵ�: ����
             AND    A.CLN_TR_KDCD  IN ('100','200') --���Űŷ������ڵ� : �űԾ��� ,�������
             AND    A.CLN_TR_NO    = B.���Űŷ���ȣ
             AND    A.CLN_ACNO     = B.���Ű��¹�ȣ
             AND    A.CLN_EXE_NO   = B.���Ž����ȣ
             ) A
           ,(SELECT   DISTINCT  CLN_ACNO  AS ���¹�ȣ
                     ,MVT_BRNO            AS ��������ȣ
             FROM     TB_SOR_WOL_SPRC_BC
             WHERE    MVT_BRNO IS NOT NULL
             ) B
    WHERE    A.���¹�ȣ *= B.���¹�ȣ

    UNION ALL
    --����
    SELECT   ACNO      AS ���¹�ȣ
            ,NW_BRNO   AS ��������ȣ  --�ű�����ȣ
    FROM     TB_SOR_DEP_DPAC_BC
    WHERE    LN_BS_ACSB_CD  IN (SELECT RLT_ACSB_CD
                                FROM   DWZOWN.OT_DWA_DD_ACSB_BC   -- DWA_�ϰ�������⺻
                                WHERE  ACSB_CD     = '13000801'   -- ��ȭ�����
                                AND    FSC_SNCD IN ('K','C')      -- ȸ������ڵ�       = 'K' (K-GAAP)
                                AND    STD_DT      = '20140930')   -- �������� = '20140930'
;

--2. �̼�������(TB_SOR_LOA_MVN_MVT_HT)�� ������ �����ŷ��� ��ȯ�� �ߵǾ��ִ�(��������)�� ����
--   �̼��������� ������ ���ʰŷ����� ù���¹�ȣ�� �������� ���
--   �Ʒ� 1�� ����� ��������� ������ ���� ���;� �Ұ� ���� �ѵ� Ȯ���� ���غ� ����

LEFT OUTER JOIN   -- �Ϲݿ���
            (
               SELECT   A.��������ȣ
                       ,A.�������¹�ȣ
                       ,CASE WHEN A.������¹�ȣ IS NULL THEN A.�������¹�ȣ ELSE A.������¹�ȣ END AS ������¹�ȣ
                       ,A.��������
               FROM
               (
                    SELECT   MVT_BRNO   AS ��������ȣ
                        ,MVN_BRNO   AS ��������ȣ
                        ,MVT_DT     AS ��������
                        ,MVN_DT     AS ��������
                        ,CLN_ACNO   AS ���Ű��¹�ȣ
                        ,CLN_EXE_NO AS ���Ž����ȣ
                        ,LN_RMD     AS �����ܾ�
                        ,MVT_ACNO   AS ������¹�ȣ
                        ,MVN_ACNO   AS ���԰��¹�ȣ
                        ,CASE WHEN TRIM(LST_ACNO) IS NULL OR LST_ACNO = ''  THEN CLN_ACNO ELSE LST_ACNO END   AS �������¹�ȣ
                        ,ROW_NUMBER() OVER(PARTITION BY CLN_ACNO ORDER BY MVT_DT ASC ,SNO  ASC) AS ����
                    FROM     TB_SOR_LOA_MVN_MVT_HT
                    WHERE    1=1
                    AND      CASE WHEN TRIM(LST_ACNO) IS NULL OR LST_ACNO = ''  THEN CLN_ACNO ELSE LST_ACNO END IN ( SELECT  ���¹�ȣ FROM #������_�ߺ�����)
               )     A
               WHERE       1=1
               AND         A.���� = 1
            )  B
            ON    A.���¹�ȣ  = B.�������¹�ȣ

LEFT OUTER JOIN   -- ����
            (
               SELECT     A.��������ȣ
                         ,A.���¹�ȣ AS �������¹�ȣ
                         ,A.���¹�ȣ AS ������¹�ȣ  -- ������ ���������� �����԰ǿ� ���� ������±��Ҽ� ����
                         ,A.��������
               FROM
               (
                 SELECT    A.ACNO                AS ���¹�ȣ
                          ,B.MVT_MVN_AMT         AS �����Աݾ�
                          ,A.ENR_BRNO            AS ��������ȣ
                          ,B.ENR_BRNO            AS ��������ȣ
                          ,A.ENR_DT              AS ��������
                          ,B.ENR_DT              AS ��������
                          ,ROW_NUMBER() OVER(PARTITION BY A.ACNO ORDER BY A.MVT_MVN_SNO ASC) AS ����
                 FROM      TB_SOR_DEP_MVT_MVN_TR   A
                 JOIN      TB_SOR_DEP_MVT_MVN_TR   B
                           ON  A.ACNO  =  B.ACNO
                           AND A.MVT_MVN_SNO + 1 = B.MVT_MVN_SNO
                           AND B.MVT_MVN_DSCD = '3'       -- ����
                           AND ( B.RLS_DT   IS NULL  OR  B.RLS_DT = ''  )
                 WHERE     ( A.RLS_DT   IS NULL  OR  A.RLS_DT = ''  )
                 AND       A.MVT_MVN_DSCD  = '1'  -- ����
                 AND       A.ENR_BRNO  NOT IN ('0018','0805','0542','0090')   -- �������� �Ϲݿ������ΰ�
                 AND       A.ACNO    IN ( SELECT  ���¹�ȣ FROM #������_�ߺ�����)

               )   A
               WHERE  ���� = 1
            )   C
            ON    A.���¹�ȣ  = C.�������¹�ȣ

//}

//{ #���ñ������� #����ȭ��ȹ�ڵ� #�Ű�ó������ #�ְ�
             ,CASE WHEN H.MGG_TSK_DSCD  = '1011' then 'KHFCMB2004S-06'
                   WHEN H.MGG_TSK_DSCD  = '2021' then 'KHFCMB2005S-05'
                   WHEN H.MGG_TSK_DSCD  = '3031' then 'KHFCMB2006S-01'
                   WHEN H.MGG_TSK_DSCD  = '4041' then 'KHFCMB2007S-01'
                   WHEN H.MGG_TSK_DSCD  = '5051' AND B.OD_FCNO != '50511021203'then 'KHFCMB2008S-01'
                   WHEN B.OD_FCNO = '50511021203' then 'KHFCMB2007L-08'
                   WHEN H.MGG_TSK_DSCD  = '6061' AND B.OD_FCNO != '60511033561'then 'KHFCMB2009S-14'
                   WHEN B.OD_FCNO = '60511033561' then 'KHFCMB2009L-03'
                   WHEN H.MGG_TSK_DSCD  = '7071' THEN 'KHFCMB2010S-16'
                   WHEN H.MGG_TSK_DSCD  = '8081' THEN 'KHFCMB2011S-08'
              ELSE 'KHFCMB2014M-20' END         AS ����ȭ��ȹ�ڵ�
             ,H.SLN_PCS_DT                      AS �Ű�ó������

FROM          TT_SOR_LOA_MM_ACN_BC  B        --  SOR_LOA_���±⺻
JOIN          TT_SOR_LOA_MM_EXE_BC  C        --  SOR_LOA_����⺻
              ON   B.CLN_ACNO     =   C.CLN_ACNO
              AND  C.CLN_ACN_STCD =   '1'      -- ���Ű��»����ڵ�  (1:����)
              AND  C.STD_YM       =   '201409'
JOIN          TB_SOR_LOA_KHFC_LN_DL   H      --  SOR_LOA_�ѱ����ñ�����������
              ON   C.CLN_ACNO    =  H.CLN_ACNO
              AND  C.CLN_EXE_NO  =  H.CLN_EXE_NO
WHERE         1=1
AND           B.PDCD IN ('20081107100001',
                         '20081112301011',
                         '20081112301021',
                         '20081112401011',
                         '20081112401021'
                         )
AND           B.CLN_ACN_STCD = '1'  -- ���Ű��»����ڵ�  (1:����)
AND           B.STD_YM =  '201409'

//}

//{  #�������� #���ּ�

SELECT
           ,CC.ADR_                          AS ��������

JOIN        DWZOWN.OM_DWA_INTG_CUST_BC  B   --DWA_���հ��⺻
            ON    A.CUST_NO  =  B.CUST_NO


LEFT OUTER JOIN   -- ��ü������ ������
            (
              SELECT   DISTINCT
                       A.ZIP
                      ,CASE WHEN TRIM(A.MPSD_NM)  IN ('��걤����','����Ư����','�λ걤����','��õ������','���ֱ�����','�뱸������','����������')
                                 THEN TRIM(A.MPSD_NM)
                            ELSE TRIM(A.MPSD_NM) || ' ' || SUBSTR(A.CCG_NM,1,LOCATE(A.CCG_NM,' '))
                       END      AS  ADR_
              FROM
                       TB_SOR_CMI_ZIP_BC   A
              JOIN   (
                        SELECT ZIP,MAX(ZIP_SNO) MAX_ZIP_SNO
                        FROM TB_SOR_CMI_ZIP_BC
                        WHERE 1=1
                        AND   ZIP_SNO <>  '999'
                        AND   LDGR_STCD       = '1'
                        GROUP BY ZIP
                     )      B
              ON     A.ZIP     =  B.ZIP
              AND    A.ZIP_SNO =  B.MAX_ZIP_SNO
              WHERE  A.LDGR_STCD       = '1'
            )    CC
            ON    B.INFS_ZIP  = CC.ZIP

//}

//{ #�������� #������

-- ����� ������
SELECT      T.���¹�ȣ
           ,TRIM(DD.MPSD_NM) || ' ' || TRIM(DD.CCG_NM) || ' ' || TRIM(DD.EMD_NM)  AS  ���������

FROM        #TEMP                      T

JOIN        TB_SOR_LOA_ACN_BC          A
            ON   T.���¹�ȣ  =  A.CLN_ACNO

JOIN        DWZOWN.OT_DWA_DD_BR_BC           D  --DWA_�����⺻
            ON    A.ACN_ADM_BRNO    =   D.BRNO
            AND   D.STD_DT          =   P_��������

LEFT OUTER JOIN
            (
              SELECT   A.ZIP,A.MPSD_NM,A.CCG_NM,A.EMD_NM
              FROM
                       TB_SOR_CMI_ZIP_BC   A
              JOIN   (
                        SELECT ZIP,MAX(ZIP_SNO) MAX_ZIP_SNO
                        FROM TB_SOR_CMI_ZIP_BC
                        WHERE 1=1
                        AND   ZIP_SNO <>  '999'
                        AND   LDGR_STCD       = '1'
                        GROUP BY ZIP
                     )      B
              ON     A.ZIP     =  B.ZIP
              AND    A.ZIP_SNO =  B.MAX_ZIP_SNO
              WHERE  A.LDGR_STCD       = '1'
            )    DD
            ON    D.ZIP  = DD.ZIP

--ORDER BY    T.����

-- ����� ������ 2
           ,SUM(A.LN_RMD)                     AS �����ܾ�
           ,J.ARCD||'.'||ISNULL(TRIM(X1.CMN_CD_NM),' ')  AS ��������������

INTO        #������_�ܾ�   -- DROP TABLE #������_�ܾ�

FROM        OT_DWA_INTG_CLN_BC A

JOIN        DWZOWN.OT_DWA_DD_BR_BC        J  --DWA_�����⺻
            ON   A.BRNO        = J.BRNO
            AND  A.STD_DT      = J.STD_DT
            
            
//}

//{ #������� #�������� #���⼼�� #���⼼��� #����뵵�ڵ� #����뵵�ڵ�� #��������� #���Ű�����ϱ⺻

LEFT OUTER JOIN
       (
              SELECT   DISTINCT
                         LN_SBCD
                        ,LN_TXIM_CD
                        ,LN_USCD
                        ,LN_SBJ_NM      AS  ��������
                        ,LN_TXIM_CD_NM   AS  ���⼼���ڵ��
                        ,LN_USCD_NM      AS  ����뵵�ڵ��
                FROM    OT_DWA_CLN_HRC_CTL_BC A
                WHERE   STD_DT =  '20140930'
         ) L
         ON     B.LN_SBCD      =   L.LN_SBCD      --��������ڵ�
         AND    B.LN_TXIM_CD  =   L.LN_TXIM_CD   --���⼼���ڵ�
         AND    B.LN_USCD      =   L.LN_USCD      --����뵵�ڵ�

//}

//{ #��ȭ�ѵ�  #���� #��ȯ�ѵ��⺻
-- �ѵ������ ������� join ���
SELECT    A.FRXC_LMT_ACNO                                       AS ��ȯ�ѵ����¹�ȣ
         ,A.CUST_NO                                             AS ����ȣ
         ,CASE WHEN N.ENTP_SCL_DSCD IN ('10','11','14') THEN '����'
               WHEN N.ENTP_SCL_DSCD IN ('20','21','24') THEN '�߼ұ��'
               WHEN N.ENTP_SCL_DSCD IN ('32','33','35') THEN '���λ����'
               WHEN N.ENTP_SCL_DSCD IN ('30','31','34') THEN '����'
               WHEN N.ENTP_SCL_DSCD IN ('40','41','42','43','44') THEN '������ü'
          END                                                   AS ����Ը𱸺�
         ,B.REF_NO                                              AS REF_NO
         ,A.INDV_LMT_LN_DSCD                                    AS �����ѵ����ⱸ���ڵ�  --(1:�Ǻ��ŷ�����,2:�ѵ��ŷ�����)
         ,B.CLN_APRV_NO                                         AS ���Ž��ι�ȣ
-- SOR_FEC_�����ѵ��⺻ �� ���Ž��ι�ȣ�� �������ι�ȣ�� �� ���� ���ι�ȣ�� SOR_FEC_�����ѵ����� ���ι�ȣ�� ����ؾ� �Ѵ�
         ,A.AGR_DT                                              AS �ѵ�������
         ,A.AGR_EXPI_DT                                         AS �ѵ�������������
         ,A.CNCN_DT                                             AS �ѵ�������


FROM      DWZOWN.TB_SOR_FEC_CLN_LMT_BC  A           -- SOR_FEC_�����ѵ��⺻

JOIN      DWZOWN.TB_SOR_FEC_CLN_LMT_DL  B           -- SOR_FEC_�����ѵ���
          ON     A.FRXC_LMT_ACNO = B.FRXC_LMT_ACNO
          AND    B.TR_DT         <=  '20141031'
          AND    B.FRXC_CLN_TR_CD  = '22'           -- ��ȯ���Űŷ��ڵ�(22:����)
          AND    B.FRXC_LDGR_STCD  NOT IN ('4','5') -- ��ȯ��������ڵ�(4:����,5:���)

JOIN      DWZOWN.TB_SOR_EXP_EXP_BC       C          -- SOR_EXP_����⺻
          ON     B.REF_NO    =  C.REF_NO

-- �ѵ������ ���Ž��ο����� JOIN
SELECT    A.FRXC_LMT_ACNO                                       AS ��ȯ�ѵ����¹�ȣ
         ,A.CUST_NO                                             AS ����ȣ
         ,B.REF_NO                                              AS REF_NO
         ,A.INDV_LMT_LN_DSCD                                    AS �����ѵ����ⱸ���ڵ�  --(1:�Ǻ��ŷ�����,2:�ѵ��ŷ�����)
         ,B.CLN_APRV_NO                                         AS ���Ž��ι�ȣ
-- SOR_FEC_�����ѵ��⺻ �� ���Ž��ι�ȣ�� �������ι�ȣ�� �� ���� ���ι�ȣ�� SOR_FEC_�����ѵ����� ���ι�ȣ�� ����ؾ� �Ѵ�
         ,A.AGR_DT                                              AS �ѵ�������
         ,A.AGR_EXPI_DT                                         AS �ѵ�������������
         ,A.CNCN_DT                                             AS �ѵ�������
         ,B.FRXC_CLN_TR_CD                                      AS ��ȯ���Űŷ��ڵ�
         ,C.LST_XCDC_DSCD ||'('||TRIM(D.XCDC_DSCD_NM)||')'      AS �������ᱸ��

FROM      DWZOWN.TB_SOR_FEC_CLN_LMT_BC  A           -- SOR_FEC_�����ѵ��⺻

JOIN      DWZOWN.TB_SOR_FEC_CLN_LMT_DL  B           -- SOR_FEC_�����ѵ���
          ON     A.FRXC_LMT_ACNO = B.FRXC_LMT_ACNO
          AND    B.TR_DT         <=  '20141031'
          AND    B.FRXC_CLN_TR_CD  IN  ('10','30','50','70')  -- ��ȯ���Űŷ��ڵ�(10:����,30:���ѿ���,50:���Ѵ���, 70:���Ǻ���)
          AND    B.FRXC_LDGR_STCD  NOT IN ('4','5') -- ��ȯ��������ڵ�(4:����,5:���)

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APRV_BC   C     -- SOR_CLI_���Ž��α⺻
            ON   B.CLN_APRV_NO  =  C.CLN_APRV_NO

LEFT OUTER JOIN
            TB_SOR_CLI_XCDC_DSCD_BC  D   --SOR_CLI_���ᱸ���ڵ�⺻
            ON   C.LST_XCDC_DSCD  = D.CLN_XCDC_DSCD  --�������ᱸ���ڵ�

ORDER BY    1,7

//}

//{ #�������㺸

-- ��������̿�
SELECT    A.CLN_APC_NO             AS ���Ž�û��ȣ
         ,A.ACN_DCMT_NO            AS ���¹�ȣ
         ,B.MRT_NO                 AS �㺸��ȣ
         ,C.WRGR_NO                AS ��������ȣ
         ,C.PBLC_ISTT_NM           AS ��������
         ,C.EVL_AMT                AS �򰡱ݾ�
INTO       #�������㺸
FROM      DWZOWN.TB_SOR_CLM_CLN_LNK_TR   A                -- SOR_CLM_���ſ��᳻��
         ,DWZOWN.TB_SOR_CLM_STUP_BC      B                -- SOR_CLM_�����⺻
         ,DWZOWN.TB_SOR_CLM_WRGR_MRT_BC  C                -- SOR_CLM_�������㺸�⺻
WHERE    1=1
AND      A.CLN_APC_NO IN ( SELECT CLN_APC_NO FROM #������)
AND      A.CLN_LNK_STCD = '02'                            -- ���ſ�������ڵ�(02:������)
AND      A.ACN_DCMT_NO  > ' '                             -- ���½ĺ���ȣ
AND      B.MRT_TPCD     = '5'                             -- �㺸�����ڵ�(5:������)
AND      C.MRT_STCD     = '02'                            -- �㺸�����ڵ�(02:������)
AND      A.STUP_NO      = B.STUP_NO                       -- ������ȣ
AND      B.MRT_NO       = C.MRT_NO                        -- �㺸��ȣ
;

-- �������̺� �̿�
SELECT      T.��������
           ,A.CLN_APC_NO             AS ���Ž�û��ȣ
           ,A.ACN_DCMT_NO            AS ���¹�ȣ
           ,B.MRT_NO                 AS �㺸��ȣ
           ,B.ENR_DT                 AS �������
           ,C.MRT_CD                 AS �㺸�ڵ�
           ,C.WRGR_NO                AS ��������ȣ
           ,C.GRN_RT                 AS ��������
           ,C.PBLC_ISTT_NM           AS ��������
           ,C.EVL_AMT                AS �򰡱ݾ�
           ,ROW_NUMBER() OVER(PARTITION BY T.��������,A.ACN_DCMT_NO ORDER BY B.ENR_DT DESC,C.GRN_RT ASC) AS ��������
  --�Ѱ��°� �ź�, �⺸ �Ѵٸ� ������ �ִ� ��쵵 �ְ�(20121231�⵵ 1��) �⺸�� �ź��� �㺸�� ������ �پ��ִ� ��찡 ����
  --�ֱټ����Ѱ��� �켱���ϰ� �������ڰ� �����Ұ�� ���������� �����ɷ� �ϳ��� ���ϱ�� �� -- �̺����� ����
  --���������� ������ ���ϴ� ������ 100%, 95% �̸� ���׺����̶�� ���������Ƿ� ���� ���������� ���ϱ����

INTO        #�������㺸 -- DROP TABLE  #�������㺸

FROM        #������_�������    T

JOIN        DWZOWN.TT_SOR_CLM_MM_CLN_LNK_TR   A                    -- SOR_CLM_�����ſ��᳻��
            ON   LEFT(T.��������,6)  =  A.STD_YM
            AND  T.���հ��¹�ȣ      =  A.ACN_DCMT_NO
            AND  A.CLN_LNK_STCD      = '02'                        -- ���ſ�������ڵ�(02:������)
            AND  A.ACN_DCMT_NO       > ' '                         -- ���½ĺ���ȣ

JOIN        DWZOWN.TT_SOR_CLM_MM_STUP_BC      B                   -- SOR_CLM_�����⺻
            ON   A.STD_YM       = B.STD_YM
            AND  A.STUP_NO      = B.STUP_NO                       -- ������ȣ
            AND  B.MRT_TPCD     = '5'                             -- �㺸�����ڵ�(5:������)
            AND  B.STUP_STCD    IN ('02','03')                    --���������ڵ�(02:������,03:��������)

JOIN        DWZOWN.TT_SOR_CLM_MM_WRGR_MRT_BC  C                   -- SOR_CLM_�������㺸�⺻
            ON   B.STD_YM       = C.STD_YM
            AND  B.MRT_NO       = C.MRT_NO                        -- �㺸��ȣ
            AND  C.MRT_STCD     = '02'                            -- �㺸�����ڵ�(02:������)
            AND  C.MRT_CD       IN  ('501','502','503','517','504','505','506')   -- �ſ뺸����ݺ����� �� ����ſ뺸����

WHERE       1=1
;

JOIN         #�������㺸        B
             ON     A.��������        =    B.��������
             AND    A.���հ��¹�ȣ    =    B.���¹�ȣ
             AND    B.��������        =    1

//}

//{ #�濵13
--�濵13�� ���ϸ�����
--������å��(20141103)_��������ּ����¼�.SQL
//}

//{ #�Ϲ� #���� #��å #���ȼ��� #�·��� #���Ż����  #����ݱ���  #�����̰�
           ,CASE WHEN   A.FRPP_KDCD IN ('2')  AND  A.PRD_BRND_CD =  '5025' AND A.LN_SBCD IN ('369','370')  THEN '4. �·���'
--                 WHEN A.FRPP_KDCD   IN ('2')  AND  A.PDCD  IN  ( '20387500100001','20387500200001')        THEN '5. ���ȼ���'
                 WHEN   A.FRPP_KDCD IN ('2')                                                               THEN '3. ��å'
                 WHEN  (A.BS_ACSB_CD IN ('17005211',                        --��Ÿ�����ü��ڱݴ���
                                         '17002811')) THEN                  --��Ÿ���������ڱݴ���
                        CASE WHEN A.PRD_BRND_CD IN ('1085',                 --����ش���
                                                    '1026',                 --����ð濵�����ڱݴ���
                                                    '1029',                 --����������ġ��ü�������
                                                    '1116',                 --�߼ұ��������ܴ���
                                                    '1132',                 --��⵵����ü�߼ұ�������ڱݴ���
                                                    '1140',                 --�һ���������ڱݴ���
                                                    '1150',                 --�һ������ȯ����
                                                    '1028',                 --�߰� 2016.08.18
                                                    '1155') THEN '3. ��å'  --�߰� 2016.08.18
                             ELSE                                '2. ����'
                        END
                 WHEN A.BS_ACSB_CD  IN ('17010111','17010211')   THEN  '2. ����'  -- �����ؾ��Ϲݿ����ڱݴ���, �����ؾ��Ϲݽü��ڱݴ���
                 WHEN A.PDCD        IN ('20001100603001','20803100603001','20001100604001') THEN '2. ����' --��ź�PLUS���� 201807�űԹݿ�
                 WHEN A.LN_MKTG_DSCD IS NOT NULL                 THEN  '6. ������'
                 ELSE '1. �Ϲ�'
            END                                      AS   ����ݱ���

-- �з���� �Ǵٸ� �ϳ� ����
               ,CASE WHEN A.FRPP_KDCD    = '2'  AND A.PRD_BRND_CD ='5025'  AND A.LN_SBCD IN ('369','370')  THEN '�·�������'
                     WHEN A.FRPP_KDCD    = '2'                THEN '4.��å'
                     WHEN A.BS_ACSB_CD   = '14000711'         THEN '6.���ణ�뿩��'
                     WHEN A.LN_MKTG_DSCD IS NOT NULL          THEN '3.����'  --���⸶���ñ����ڵ�
                     WHEN B.ACSB_NM      LIKE '%��Ÿ%'        THEN '5.����'
                     WHEN A.BRNO         IN ('0018','0178','0204','0304','0404','0542','0602','0804','0805','0909')    THEN '2.�̰�'
                     ELSE '1.��'
                     END                    AS ����

-- �̰�ä�� �з�(UP_DWZ_����_N0051_��������Ȳ_�ڱݺ� �� �Ϻ�)
                  WHEN J.LST_MVN_BRNO IN ('0018','0178','0204','0304','0404','0542','0602','0804','0805','0909')  OR  -- ���Ű�����, ���Ű�������
                       ( J.LST_MVN_BRNO = '0090'  AND  A.LN_MKTG_DSCD IS NULL)                                        -- ���Ű�����(���ڱ�������)
                                                            -- �����ο����� �ƴѿ����߿� 0090���� �Ѿ�� ���Ÿ� ���Ż���ο����� ��������
                        THEN '2.�̰�'

//}

//{ #����� #���ΰ���
  AND    A.ACSB_CD  IN  (    SELECT   RLT_ACSB_CD
                                         FROM     DWZOWN.OT_DWA_DD_ACSB_BC            -- (DWA_�ϰ�������⺻)
                                         WHERE    STD_DT  = '20141202'
                                         AND      FSC_SNCD IN ('K','C')
                                         AND      ACSB_CD in ('13001508')                -- ��ȭ�����ݰ���
                                    )

//}

//{ #�űݸ� #���űݸ� #���α⺻
--�űݸ��ý��� �����ʹ� ���Ž�û��ȣ�� Ű �̹Ƿ� ���¹�ȣ�� �����ϱ� ���ؼ� ���Ž��α⺻�� join  �ϸ� ���ϴ�.
--���γ����� �������γ������� ���Ϸ��� �������α׷��� ""���Ż����(20141118)_�����߰�������������ڷ�.SQL""
--�� �����Ұ�.

SELECT    A.CLN_APC_NO
         ,A.APCL_DSCD
         ,A.TOT_STD_IRT
         ,A.TOT_ADD_IRT
         ,C.ACN_DCMT_NO        AS ���¹�ȣ
         ,C.CUST_NO            AS ����ȣ
         ,C.CLN_APRV_NO        AS ���Ž��ι�ȣ
         ,C.APRV_DT            AS ��������
         ,C.CLN_APC_NO         AS ���Ž�û��ȣ
         ,C.CLN_APRV_LDGR_STCD AS ���ο�������ڵ�
         ,C.NFFC_UNN_DSCD      AS �߾�ȸ���ձ���
INTO      #TEMP_�ݸ�����_1    -- DROP TABLE #TEMP_�ݸ�����_1
FROM      TB_SOR_IRL_IRT_CALC_TR A
JOIN      (
              SELECT A.CLN_APC_NO, MAX(A.APCL_DSCD) APCL_DSCD
              FROM (
                      SELECT A.CLN_APC_NO, A.APCL_DSCD
                      FROM   TB_SOR_IRL_IRT_CALC_TR A
                      WHERE  APCL_DSCD IN ('1','2')
                      UNION

                      SELECT A.CLN_APC_NO, '3' APCL_DSCD
                      FROM   TB_SOR_IRL_IRT_CALC_TR A
                      INNER JOIN
                             TB_SOR_IRL_IRT_RNX_APRV_BC B
                             ON A.CLN_APC_NO = B.CLN_APC_NO
                             AND A.APCL_DSCD = '3'
                             AND B.IRT_RNX_PGRS_STCD = '04'
                   ) A
              GROUP BY A.CLN_APC_NO
          ) B
          ON  A.CLN_APC_NO = B.CLN_APC_NO
          AND A.APCL_DSCD  = B.APCL_DSCD

--        ���Ž��α⺻�� ���ι�ȣ�� Ű ������ ��������ڵ�(10:����,20:����,21:����Ϸ�)�� ���ǰɾ��ָ� ���Ž�û��ȣ�� ����ũ �ϴ�
JOIN      TB_SOR_CLI_CLN_APRV_BC      C         --  SOR_CLI_���Ž��α⺻
          ON   A.CLN_APC_NO  =  C.CLN_APC_NO
          AND  C.CLN_APRV_LDGR_STCD IN ('10','20','21')   --���Ž��ο�������ڵ�(10:����,20:����,21:����Ϸ�)
          AND  C.NFFC_UNN_DSCD       = '1'                --�߾�ȸ���ձ����ڵ�(1:�߾�ȸ)
;

//}

//{ #�ڱݿ뵵 #���ο���

-- CASE 1 : �űԽ� �ڱݿ뵵
LEFT OUTER JOIN
           (
             SELECT   DISTINCT
                      A.CLN_ACNO       AS ���¹�ȣ          --������ �ڱݿ뵵�� ã�ƿ´�.
                     ,A.CUST_NO        AS ����ȣ
                     ,A.FND_USCD      AS �ڱݿ뵵�ڵ�
                     ,C.CMN_CD_NM      AS �ڱݿ뵵
             FROM     TB_SOR_PLI_CLN_APC_BC  A             --SOR_PLI_���Ž�û�⺻
                     ,TB_SOR_PLI_SYS_JUD_RSLT_TR  B        --SOR_PLI_�ý��۽ɻ�������
                     ,(
                        SELECT    CMN_CD
                                 ,CMN_CD_NM
                        FROM      OM_DWA_CMN_CD_BC
                        WHERE     TPCD_NO_EN_NM = 'FND_USCD'
                        AND       CMN_CD_US_YN = 'Y'
                       ) C
             WHERE    A.CLN_APC_PGRS_STCD  IN ('03','04')  --���Ž�û��������ڵ�(03:����Ϸ�, 04:����Ϸ�)
             AND      A.CLN_APC_DSCD       = '01'          --���Ž�û�����ڵ�(01:�ű�)
             AND      A.NFFC_UNN_DSCD      = '1'           --�߾�ȸ���ձ����ڵ�
             AND      A.CLN_APC_NO         = B.CLN_APC_NO
             AND      A.CUST_NO            = B.CUST_NO
             AND      A.FND_USCD           *= C.CMN_CD
             AND      A.FND_USCD           IS NOT NULL
            ) C
            ON     A.INTG_ACNO  =  C.���¹�ȣ

-- CASE 2: ���� �ֱ� �ڱݿ뵵�ڵ尡 ���� ��û�ǿ� ���� �ڱݿ뵵
SELECT      DISTINCT
            TA.CLN_ACNO
           ,TA.FND_USCD
INTO        #�ڱݿ뵵    -- DROP TABLE #�ڱݿ뵵
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC     TA
           ,(SELECT   CLN_ACNO                                                  --���Ű��¹�ȣ
                     ,MAX(CLN_APC_NO) AS CLN_APC_NO                             --���Ž�û��ȣ
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC
             WHERE    FND_USCD IS NOT NULL                    -- �ڱݿ뵵�ڵ尡 ��� �ִ� �����ֱ� ��û��
             GROUP BY CLN_ACNO
            )                                TB
WHERE       TA.CLN_APC_NO = TB.CLN_APC_NO
;

SELECT
           ,CASE ISNULL(D.FND_USCD, '10') WHEN '01'  THEN '12'    --���ڱݿ뵵�ڵ�-���ڱݿ뵵�ڵ� ����
                                          WHEN '02'  THEN '16'
                                          WHEN '03'  THEN '21'
                                          WHEN '04'  THEN '23'
                                          WHEN '05'  THEN '10'
                                          WHEN '06'  THEN '19'
                                          WHEN '07'  THEN '22'
                                          WHEN '08'  THEN '10'
                                          WHEN '09'  THEN '10'
                                          ELSE ISNULL(D.FND_USCD, '10')  END    AS �ڱݿ뵵�ڵ庯ȯ

           ,CASE WHEN �ڱݿ뵵�ڵ庯ȯ  = '10'                      THEN  'C. ��Ÿ'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  IN  ('11','12','13','14')   THEN  '1. ���ñ���'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  = '15'   THEN  '2. �����ڱݹ�ȯ��'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  = '16'   THEN  '3. ��������(������)'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  = '17'   THEN  '4. ���ý��� �� ����'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  = '18'   THEN  '5. �����ڱ�'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  = '19'   THEN  '6. �����Һ��� �����ڱ�'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  = '20'   THEN  '7. ���ڱ�'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  = '21'   THEN  '8. ����ڱ�'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  = '22'   THEN  '9. �����ڱ�'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  = '23'   THEN  'A. �����Ա� ��ȯ�ڱ�'
                 WHEN �ڱݿ뵵�ڵ庯ȯ  = '24'   THEN  'B. ������ �� ���ݳ���'
                 ELSE 'C. ��Ÿ'
            END                     AS  �ڱݿ뵵�ڵ�_������

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A       --DWA_���տ��ű⺻

LEFT OUTER JOIN
            #�ڱݿ뵵   D
            ON       A.INTG_ACNO =  D.CLN_ACNO


//}

//{  #�����
SELECT   A.*
INTO     #�����  -- DROP TABLE #�����
FROM    (SELECT   A.KIS_BZNS_CD        AS ��ü�ڵ�
                ,A.SOA_MM             AS ����
                ,A.BRN                AS ����ڵ�Ϲ�ȣ
                ,ISNULL(B.SOA_DT, '00000000')  AS �������
                ,SUM(CASE WHEN B.KIS_REPT_CD = '12' AND B.KIS_FNST_HDN_CD_NM = '1000'  THEN B.KIS_FNST_AMT ELSE 0 END)  AS �����  -- ������ 1000��
                ,ROW_NUMBER() OVER(PARTITION BY  A.BRN ORDER BY B.SOA_DT  DESC) AS ������
        FROM     TB_SOR_CCR_KIS_BZNS_BC   A   --SOR_CCR_KIS��ü����⺻
                ,TB_SOR_CCR_KIS_FNST_TR   B   --SOR_CCR_KIS�繫��ǥ����
        WHERE    A.KIS_BZNS_CD        *= B.KIS_BZNS_CD
        AND      B.KIS_FNST_SOA_DSCD   = 'K'            --�ѱ��ſ����繫��ǥ��걸���ڵ�(K:���)
        AND      B.KIS_REPT_CD         = '12'           --�ѱ��ſ��򰡺����ڵ�(11:BS)
        AND      B.KIS_FNST_HDN_CD_NM  = '1000'         --�ѱ��ſ����繫��ǥ�׸��ڵ��(5000:���ڻ�)
        AND      ISNULL(B.SOA_DT, '00000000') <= '20141231'
        AND      A.BRN     IN (SELECT DISTINCT �Ǹ��ȣ  FROM #TEMP_�⺻����)
        GROUP BY A.KIS_BZNS_CD
                ,A.SOA_MM
                ,A.BRN
                ,B.SOA_DT
        ) A
WHERE    A.������ = 1
;



-- KIS �����͸��� �ſ��򰡼����� �����
SELECT      A.*
           ,B.�������
           ,B.�繫��ǥ�ݾ�

FROM        #������     A

LEFT OUTER JOIN
            (             -- ���ν� �ֱ�2���Ⱓ ����Ȱ���������帧 �������� ����� ����
             SELECT      A.�ſ��򰡹�ȣ
             --           ,B.RNNO
             --           ,B.HIS_SNO
                        ,C.SOA_DT    AS  �������
                        ,C.FNST_AMT  AS  �繫��ǥ�ݾ�
             --           ,C.CMPS_RT   AS  ��������
             --           ,C.INDC_RT   AS  ��������
             --           ,D.CRDT_EVL_MODL_DSCD       AS �ſ��򰡸��������ڵ�
             --           ,E.CRDT_EVL_INDS_CLSF_CD     AS ����з��ڵ�
                        ,ROW_NUMBER() OVER(PARTITION BY  A.�ſ��򰡹�ȣ ORDER BY �������  DESC) AS ������
             FROM
                         ( SELECT  DISTINCT �ſ��򰡹�ȣ FROM  #������  ) A

             JOIN        TB_SOR_CCR_EVL_FNFR_CTL_TR    B           -- SOR_CCR_���繫��ϳ���
                         ON   A.�ſ��򰡹�ȣ   = B.CRDT_EVL_NO

             JOIN        TB_SOR_CCR_FNST_HT            C           -- SOR_CCR_�繫��ǥ�̷�
                         ON   B.RNNO     =   C.RNNO
                         AND  B.HIS_SNO  =   C.HIS_SNO
                         AND  B.SOA_DT   =   C.SOA_DT
                         AND  C.FNST_REPT_CD = '12'                -- 12.1000  �����
                         AND  C.FNST_HDCD = '1000'
            )   B
            ON   A.�ſ��򰡹�ȣ  = B.�ſ��򰡹�ȣ
            AND  B.������   =  1
ORDER BY    1;

//}

//{  #���ͱ⿩�� #EL�ݿ��ļ��� #���� #�������� #�������� #���Լ����� #�������� #���޼�����
--���� ���ͱ⿩�� �򰡰����� ���������� EL�ݿ��ļ����� ����� ��� ���

--  #TEMP_�⺻���� �� ������ ������ ������ ������¸� �ؾ� �ϹǷ� �Ʒ� ������ �߰��ؾ� ��
--  =====================================================
--  AND         LEFT(A.���������ڵ�,1) = '1'
--  =====================================================

SELECT A.����ȣ,SUM(A.���߿���սǱݾ�) AS ���߿���սǱݾ� ,SUM(A.EL�ݿ��ļ���) AS EL�ݿ��ļ���
INTO   #���ͱ⿩��        --  DROP TABLE #���ͱ⿩��
FROM   XOT_BPAT���¼��ͼ�MASTER   A
WHERE  �۾����س�� BETWEEN '201401' AND '201412'
AND    A.����ȣ  IN ( SELECT DISTINCT ����ȣ FROM #TEMP_�⺻����)
GROUP BY A.����ȣ
;

SELECT      CASE WHEN  A.�۾����س�� BETWEEN '201401' AND '201412'  THEN '20141231'
                 WHEN  A.�۾����س�� BETWEEN '201501' AND '201503'  THEN '20150331'
                 ELSE  '99999999'
            END  ��������
           ,A.���¹�ȣ
           ,SUM(A.��������) AS ��������
           ,SUM(A.��������) AS ��������
           ,SUM(A.���޺����� + A.���������� + A.NET������ + A.��ȯ�Ÿ��� + A.�ߵ���ȯ������ + A.�������� + A.��Ź���� + A.��Ÿ�������)  AS ���޼�����
           ,SUM(A.���޼����� + A.������� + A.��Ÿ������)  AS ���Լ�����
           ,SUM(A.���������ݿ�������)   AS ���������ݿ�������
           ,SUM(A.���������ݿ��ļ���)   AS �������������ļ���
INTO        #����        --  DROP TABLE #����
FROM        XOT_BPAT���¼��ͼ�MASTER   A
WHERE       A.�۾����س�� BETWEEN '201401' AND '201503'
AND         A.���¹�ȣ  IN ( SELECT DISTINCT ���հ��¹�ȣ FROM #TEMP)
--  AND         LEFT(A.���������ڵ�,1) = '1'           -- ������ ��� ������� �߻��и� ������ ó��..
GROUP BY    ��������,A.���¹�ȣ
;
//}

//{  #CRS��޸���  #CRS��� #����ſ��򰡵��
--���տ��� �� ������(SOR_CCR_����������) �� CRS����� ����Ϸ��� �����۾��� �ʿ��ϴ�,
--���ŵ��ü��� ������ü�谡 ȥ��Ǿ� �־� ������ü��� �Ͽ�ȭ�ñ�Ű ����
--1. �⺻������
               ,CASE WHEN A.ENTP_CRGR_JUD_DT < '20080728' AND A.BR_DSCD = '1'  --�߾�ȸ
                     THEN CASE TRIM(A.ENTP_CREV_GD) WHEN '1'   THEN '1'         -- 1    1
                                                    WHEN '2'   THEN '3'         -- 2    3
                                                    WHEN '3+'  THEN '3'         -- 3+   3
                                                    WHEN '3'   THEN '4A'        -- 3    4A
                                                    WHEN '3-'  THEN '4A'        -- 3-   4A
                                                    WHEN '4+'  THEN '4A'        -- 4+   4A
                                                    WHEN '4'   THEN '4A'        -- 4    4A
                                                    WHEN '4-'  THEN '4B'        -- 4-   4B
                                                    WHEN '5+'  THEN '4B'        -- 5+   4B
                                                    WHEN '5'   THEN '5A'        -- 5    5A
                                                    WHEN '5-'  THEN '5B'        -- 5-   5B
                                                    WHEN '6+'  THEN '5B'        -- 6+   5B
                                                    WHEN '6'   THEN '6A'        -- 6    6A
                                                    WHEN '6-'  THEN '6A'        -- 6-   6A
                                                    WHEN '7'   THEN '7A'        -- 7    7A
                                                    WHEN '8'   THEN '8'         -- 8    8
                                                    WHEN '9'   THEN '9'         -- 9    9
                                                    WHEN '10'  THEN '10'        -- 10   10
                           END
                     WHEN A.ENTP_CRGR_JUD_DT < '20080728' AND A.BR_DSCD = '2'  --����
                     THEN CASE TRIM(A.ENTP_CREV_GD) WHEN '1'   THEN '1'          -- 1    1
                                                    WHEN '2'   THEN '2'          -- 2    2
                                                    WHEN '3+'  THEN '2'          -- 3+   2
                                                    WHEN '3'   THEN '3'          -- 3    3
                                                    WHEN '3-'  THEN '4'          -- 3-   4
                                                    WHEN '4+'  THEN '5'          -- 4+   5
                                                    WHEN '4'   THEN '5'          -- 4    5
                                                    WHEN '4-'  THEN '5'          -- 4-   5
                                                    WHEN '5+'  THEN '6A'         -- 5+   6A
                                                    WHEN '5'   THEN '7A'         -- 5    7A
                                                    WHEN '5-'  THEN '7A'         -- 5-   7A
                                                    WHEN '6+'  THEN '7B'         -- 6+   7B
                                                    WHEN '6'   THEN '7B'         -- 6    7B
                                                    WHEN '6-'  THEN '7B'         -- 6-   7B
                                                    WHEN '7'   THEN '8A'         -- 7    8A
                                                    WHEN '8'   THEN '9'          -- 8    9
                                                    WHEN '9'   THEN '10A'        -- 9    10A
                                                    WHEN '10'  THEN '10B'        -- 10   10B
                           END
                     WHEN (A.ENTP_CRGR_JUD_DT BETWEEN '20080728' AND '20120812'  OR
                           ISDATE(A.ENTP_CRGR_JUD_DT) = 0)
                           AND A.BR_DSCD = '1'  --�߾�ȸ
                     THEN CASE TRIM(A.ENTP_CREV_GD) WHEN '1'   THEN '1'    -- 1     1
                                                    WHEN '2'   THEN '2'    -- 2     2
                                                    WHEN '3+'  THEN '3'    -- 3+    3
                                                    WHEN '3'   THEN '3'    -- 3     3
                                                    WHEN '3-'  THEN '3'    -- 3-    3
                                                    WHEN '4+'  THEN '4A'   -- 4+    4A
                                                    WHEN '4'   THEN '4A'   -- 4     4A
                                                    WHEN '4-'  THEN '4A'   -- 4-    4A
                                                    WHEN '5+'  THEN '4B'   -- 5+    4B
                                                    WHEN '5'   THEN '4B'   -- 5     4B
                                                    WHEN '5-'  THEN '4B'   -- 5-    4B
                                                    WHEN '6+'  THEN '5A'   -- 6+    5A
                                                    WHEN '6'   THEN '5B'   -- 6     5B
                                                    WHEN '6-'  THEN '6A'   -- 6-    6A
                                                    WHEN '7+'  THEN '6A'   -- 7+    6A
                                                    WHEN '7'   THEN '6B'   -- 7     6B
                                                    WHEN '7-'  THEN '6B'   -- 7-    6B
                                                    WHEN '8'   THEN '7A'   -- 8     7A(7B) --7B����
                                                    WHEN '9'   THEN '8'    -- 9     8
                                                    WHEN '10A' THEN '9'    -- 10A   9
                                                    WHEN '10B' THEN '10'   -- 10B   10
                          END
                     WHEN (A.ENTP_CRGR_JUD_DT BETWEEN '20080728' AND '20120812'  OR
                           ISDATE(A.ENTP_CRGR_JUD_DT) = 0)
                           AND A.BR_DSCD = '2'  --����
                     THEN CASE TRIM(A.ENTP_CREV_GD) WHEN '1'   THEN '1'        -- 1     1
                                                    WHEN '2'   THEN '2'        -- 2     2
                                                    WHEN '3+'  THEN '3'        -- 3+    3
                                                    WHEN '3'   THEN '3'        -- 3     3
                                                    WHEN '3-'  THEN '3'        -- 3-    3
                                                    WHEN '4+'  THEN '4'        -- 4+    4
                                                    WHEN '4'   THEN '4'        -- 4     4
                                                    WHEN '4-'  THEN '4'        -- 4-    4
                                                    WHEN '5+'  THEN '5'        -- 5+    5
                                                    WHEN '5'   THEN '5'        -- 5     5
                                                    WHEN '5-'  THEN '5'        -- 5-    5
                                                    WHEN '6+'  THEN '6A'       -- 6+    6A
                                                    WHEN '6'   THEN '6B'       -- 6     6B
                                                    WHEN '6-'  THEN '7A'       -- 6-    7A
                                                    WHEN '7+'  THEN '7A'       -- 7+    7A
                                                    WHEN '7'   THEN '7B'       -- 7     7B
                                                    WHEN '7-'  THEN '7B'       -- 7-    7B
                                                    WHEN '8'   THEN '8A'       -- 8     8A(8B)
                                                    WHEN '9'   THEN '9'        -- 9     9
                                                    WHEN '10A' THEN '10A'      -- 10A   10A
                                                    WHEN '10B' THEN '10B'      -- 10B   10B
                          END
                     ELSE A.ENTP_CREV_GD --20120813 ����
                END                                    AS ����ſ��򰡵��

-- CRS ����� 15���ü�����ڸ� 'A','B' ���� ���ڵ��� �����ϰ� 10������� �з��� ���ϴ� �����
--2. �⺻�������Ѱ��� 10������� ����ϴ� ���
                  ,CASE WHEN ����ſ��򰡵��  IN  ('1','01','1A','1B')  THEN  '01'
                        WHEN ����ſ��򰡵��  IN  ('2','02','2A','2B')  THEN  '02'
                        WHEN ����ſ��򰡵��  IN  ('3','03','3-','3+','3A','3B')  THEN  '03'
                        WHEN ����ſ��򰡵��  IN  ('4','04','4-','4+','4A','4B')  THEN  '04'
                        WHEN ����ſ��򰡵��  IN  ('5','05','5+','5-','5A','5B')  THEN  '05'
                        WHEN ����ſ��򰡵��  IN  ('6','06','6+','6-','6A','6B')  THEN  '06'
                        WHEN ����ſ��򰡵��  IN  ('7','07','7+','7-','7A','7B')  THEN  '07'
                        WHEN ����ſ��򰡵��  IN  ('8','08','8A','8B')  THEN  '08'
                        WHEN ����ſ��򰡵��  IN  ('9','09','9A','9B')  THEN  '09'
                        WHEN ����ſ��򰡵��  =    '10'                 THEN  '10'
                        WHEN ����ſ��򰡵��  IS NULL OR  ����ſ��򰡵�� IN  ('0','11','')         THEN  '99'
                        ELSE ����ſ��򰡵��
                   END                        AS  ����ſ��򰡵��2


//}

//{  #��ȣ #CRS��� #SOHO  #��������34����

-- 1.  ��ȣ�������� �����Ͽ� �ֱ� crs��� ���ϱ�
LEFT OUTER JOIN
            (
            -- ���տ����� �������� 34(SOHO ����)�� ������ �ֱ� �ſ��򰡵���� ��� �ְ�
            -- ���ι�ȣ�� �̿��Ͽ� �򰡳����� �������� �򰡳����� ����ִ� ��찡 �ټ� �߻���
            -- ��������� �������� 34�� ������ �򰡵���� ���ϹǷ� ���տ��ſ� CRS ��� �����ϴ� �κ��� �����Ͽ�
            -- �������� 34�� ���Խ�Ű�� ���·� �����ۼ���
            -- �� ������ �ణ�� ������ �����ϰ� �ֽ�

                   SELECT   TA.NFFC_UNN_DSCD        AS NFFC_UNN_DSCD
                           ,CASE WHEN TRIM(TA.RPST_RNNO) IS NOT NULL AND
                                      TRIM(TA.RPST_RNNO) <> ''       THEN
                                      TRIM(TA.RPST_RNNO)
                                 ELSE
                                      TRIM(TA.RNNO)
                            END                     AS RNNO
                           ,TA.LST_ADJ_GD           AS ENTP_CREV_GD
                           ,TA.CMPL_DT              AS ENTP_CRGR_JUD_DT
                           ,TA.CRDT_EVL_MODL_DSCD   AS ����ſ��򰡸��������ڵ�  -- �������� �߰� : 20120823 �����
                           ,TC.ENTP_OPPB_DSCD       AS ENTP_OPPB_DSCD      -- ������������ڵ�
                           ,TD.CUST_NO              AS CUST_NO
                           ,TA.ENTP_SCL_DTL_DSCD    AS ENTP_SCL_DTL_DSCD   -- ����Ը�󼼱����ڵ� : 2014.01.24 ������
                           ,TA.EVL_AVL_DT           AS EVL_AVL_DT          -- ����ȿ���� : 2014.01.24 ������
                   FROM     DWZOWN.TB_SOR_CCR_EVL_INF_TR       TA  --SOR_CCR_����������
                           ,(SELECT   NFFC_UNN_DSCD                        -- �߾�ȸ���ձ����ڵ�
                                     ,CASE WHEN TRIM(RPST_RNNO) IS NOT NULL AND
                                                TRIM(RPST_RNNO) <> ''       THEN
                                                TRIM(RPST_RNNO)
                                           ELSE
                                                TRIM(RNNO)
                                      END              AS RNNO
                                     ,MAX(CRDT_EVL_NO) AS CRDT_EVL_NO      -- ���� �ſ��򰡹�ȣ
                             FROM     DWZOWN.TB_SOR_CCR_EVL_INF_TR   --SOR_CCR_����������
                             WHERE    CRDT_EVL_PGRS_STCD  = '2'            -- �ſ�����������ڵ�'2'�򰡿Ϸ�
                             AND      CRDT_EVL_OMT_DSCD   = '02'           -- '01'�������,'02'��������: �� ��� �ʼ�
                             AND      CMPL_DT            <= '20141231'
            --               AND      CRDT_EVL_MODL_DSCD <> '34'           -- �������� 34(CSS���)
                             AND      BRNO               <> '0288'         -- �����ڱݺ� ��޿��� ����
                             GROUP BY NFFC_UNN_DSCD,RNNO)      TB
                           ,DWZOWN.TB_SOR_CCR_EVL_BZNS_OTL_TR  TC  --SOR_CCR_�򰡾�ü���䳻��
                           ,DWZOWN.TB_SOR_CUS_MAS_BC           TD  --SOR_CUS_���⺻
                   WHERE    TA.NFFC_UNN_DSCD      = TB.NFFC_UNN_DSCD
                   AND      TA.BRNO              <> '0288'                 -- �����ڱݺ� ��޿��� ����
                   AND      TA.CRDT_EVL_OMT_DSCD  = '02'                   -- '01'�������,'02'��������(�ſ��򰡻��������ڵ�): �� ��� �ʼ�
                   AND      TA.CMPL_DT            <= '20141231'
                   AND      CASE WHEN TRIM(TA.RPST_RNNO) IS NOT NULL AND
                                      TRIM(TA.RPST_RNNO) <> ''       THEN
                                      TRIM(TA.RPST_RNNO)
                                 ELSE
                                      TRIM(TA.RNNO)
                            END              = TB.RNNO
                   AND      TA.CRDT_EVL_NO   = TB.CRDT_EVL_NO
                   AND      TA.RNNO          = TC.RNNO
                   AND      TA.CRDT_EVL_NO   = TC.CRDT_EVL_NO
                   AND      CASE WHEN TRIM(TA.RPST_RNNO) IS NOT NULL AND
                                      TRIM(TA.RPST_RNNO) <> ''       THEN
                                      TRIM(TA.RPST_RNNO)
                                 ELSE
                                      TRIM(TA.RNNO)
                            END             *= TD.CUST_RNNO

                   AND     TA.NFFC_UNN_DSCD  =  '1'                -- �߾�ȸ  �̰;����� �Ǹ��ȣ���� �ߺ�����.
            )      T
            ON     A.RNNO   =  T.RNNO


-- 2.  ���ؽ����� �ٸ� ���������� �� ������  crs���(��ȣ�������� ����)���ϱ�, ���տ����� soho������ �������� �ʴ´�
SELECT      A.NFFC_UNN_DSCD                        -- �߾�ȸ���ձ����ڵ�
           ,CASE WHEN TRIM(A.RPST_RNNO) IS NOT NULL AND
                      TRIM(A.RPST_RNNO) <> ''       THEN
                      TRIM(A.RPST_RNNO)
                 ELSE
                      TRIM(A.RNNO)
            END                AS RNNO
           ,A.CMPL_DT          AS CMPL_DT
           ,MAX(A.CRDT_EVL_NO) AS CRDT_EVL_NO      -- ���� �ſ��򰡹�ȣ
           ,ROW_NUMBER() OVER (PARTITION BY A.NFFC_UNN_DSCD,RNNO ORDER BY CMPL_DT ASC) AS SEQ
INTO        #�������丮  -- DROP TABLE   #�������丮
FROM        DWZOWN.TB_SOR_CCR_EVL_INF_TR  A      --SOR_CCR_����������
WHERE       A.CRDT_EVL_PGRS_STCD  = '2'            -- �ſ�����������ڵ�'2'�򰡿Ϸ�
AND         A.CRDT_EVL_OMT_DSCD   = '02'           -- '01'�������,'02'��������: �� ��� �ʼ�
--               AND      CRDT_EVL_MODL_DSCD <> '34'           -- �������� 34(CSS���)
AND         A.BRNO               <> '0288'         -- �����ڱݺ� ��޿��� ����
AND         A.NFFC_UNN_DSCD       =  '1'           -- �߾�ȸ  �̰;����� �Ǹ��ȣ���� �ߺ�����.
GROUP BY    NFFC_UNN_DSCD,RNNO,CMPL_DT
;

SELECT      A.*
           ,B.LST_ADJ_GD           AS ENTP_CREV_GD
           ,B.CMPL_DT              AS ENTP_CRGR_JUD_DT
           ,B.CRDT_EVL_MODL_DSCD   AS CRDT_EVL_MODL_DSCD
           ,CASE WHEN B.CMPL_DT < '20080728'
                 THEN CASE TRIM(B.LST_ADJ_GD) WHEN '1'   THEN '1'         -- 1    1
                                                WHEN '2'   THEN '3'         -- 2    3
                                                WHEN '3+'  THEN '3'         -- 3+   3
                                                WHEN '3'   THEN '4A'        -- 3    4A
                                                WHEN '3-'  THEN '4A'        -- 3-   4A
                                                WHEN '4+'  THEN '4A'        -- 4+   4A
                                                WHEN '4'   THEN '4A'        -- 4    4A
                                                WHEN '4-'  THEN '4B'        -- 4-   4B
                                                WHEN '5+'  THEN '4B'        -- 5+   4B
                                                WHEN '5'   THEN '5A'        -- 5    5A
                                                WHEN '5-'  THEN '5B'        -- 5-   5B
                                                WHEN '6+'  THEN '5B'        -- 6+   5B
                                                WHEN '6'   THEN '6A'        -- 6    6A
                                                WHEN '6-'  THEN '6A'        -- 6-   6A
                                                WHEN '7'   THEN '7A'        -- 7    7A
                                                WHEN '8'   THEN '8'         -- 8    8
                                                WHEN '9'   THEN '9'         -- 9    9
                                                WHEN '10'  THEN '10'        -- 10   10
                       END
                 WHEN (B.CMPL_DT BETWEEN '20080728' AND '20120812'  OR
                       ISDATE(B.CMPL_DT) = 0)
                 THEN CASE TRIM(B.LST_ADJ_GD) WHEN '1'   THEN '1'    -- 1     1
                                                WHEN '2'   THEN '2'    -- 2     2
                                                WHEN '3+'  THEN '3'    -- 3+    3
                                                WHEN '3'   THEN '3'    -- 3     3
                                                WHEN '3-'  THEN '3'    -- 3-    3
                                                WHEN '4+'  THEN '4A'   -- 4+    4A
                                                WHEN '4'   THEN '4A'   -- 4     4A
                                                WHEN '4-'  THEN '4A'   -- 4-    4A
                                                WHEN '5+'  THEN '4B'   -- 5+    4B
                                                WHEN '5'   THEN '4B'   -- 5     4B
                                                WHEN '5-'  THEN '4B'   -- 5-    4B
                                                WHEN '6+'  THEN '5A'   -- 6+    5A
                                                WHEN '6'   THEN '5B'   -- 6     5B
                                                WHEN '6-'  THEN '6A'   -- 6-    6A
                                                WHEN '7+'  THEN '6A'   -- 7+    6A
                                                WHEN '7'   THEN '6B'   -- 7     6B
                                                WHEN '7-'  THEN '6B'   -- 7-    6B
                                                WHEN '8'   THEN '7A'   -- 8     7A(7B) --7B����
                                                WHEN '9'   THEN '8'    -- 9     8
                                                WHEN '10A' THEN '9'    -- 10A   9
                                                WHEN '10B' THEN '10'   -- 10B   10
                      END
                 ELSE B.LST_ADJ_GD --20120813 ����
            END                                    AS ����ſ��򰡵��

INTO        #������  -- DROP TABLE #������

FROM        (
             SELECT      A.NFFC_UNN_DSCD
                        ,A.RNNO
                        ,A.SEQ
                        ,A.CMPL_DT                                     AS �����������
                        ,CASE WHEN B.CMPL_DT IS NULL THEN '99999999'
                              ELSE DATEFORMAT(DATE(B.CMPL_DT)-1,'YYYYMMDD')
                         END                                           AS ������������
                        ,A.CRDT_EVL_NO
--             INTO        #�������丮_����  -- DROP TABLE #�������丮_����
             FROM        #�������丮   A
             LEFT OUTER JOIN
                         #�������丮   B
                         ON   A.NFFC_UNN_DSCD  = B.NFFC_UNN_DSCD
                         AND  A.RNNO           = B.RNNO
                         AND  A.SEQ + 1        = B.SEQ
            )      A

JOIN        DWZOWN.TB_SOR_CCR_EVL_INF_TR  B
            ON  A.CRDT_EVL_NO  = B.CRDT_EVL_NO
;

SELECT
           ,CASE WHEN BB.ENTP_CRGR_JUD_DT < '20080728' AND A.BR_DSCD = '1'  --�߾�ȸ
                 THEN CASE TRIM(BB.ENTP_CREV_GD) WHEN '1'   THEN '1'         -- 1    1
                                                WHEN '2'   THEN '3'         -- 2    3
                                                WHEN '3+'  THEN '3'         -- 3+   3
                                                WHEN '3'   THEN '4A'        -- 3    4A
                                                WHEN '3-'  THEN '4A'        -- 3-   4A
                                                WHEN '4+'  THEN '4A'        -- 4+   4A
                                                WHEN '4'   THEN '4A'        -- 4    4A
                                                WHEN '4-'  THEN '4B'        -- 4-   4B
                                                WHEN '5+'  THEN '4B'        -- 5+   4B
                                                WHEN '5'   THEN '5A'        -- 5    5A
                                                WHEN '5-'  THEN '5B'        -- 5-   5B
                                                WHEN '6+'  THEN '5B'        -- 6+   5B
                                                WHEN '6'   THEN '6A'        -- 6    6A
                                                WHEN '6-'  THEN '6A'        -- 6-   6A
                                                WHEN '7'   THEN '7A'        -- 7    7A
                                                WHEN '8'   THEN '8'         -- 8    8
                                                WHEN '9'   THEN '9'         -- 9    9
                                                WHEN '10'  THEN '10'        -- 10   10
                       END
                 WHEN BB.ENTP_CRGR_JUD_DT < '20080728' AND A.BR_DSCD = '2'  --����
                 THEN CASE TRIM(BB.ENTP_CREV_GD) WHEN '1'   THEN '1'          -- 1    1
                                                WHEN '2'   THEN '2'          -- 2    2
                                                WHEN '3+'  THEN '2'          -- 3+   2
                                                WHEN '3'   THEN '3'          -- 3    3
                                                WHEN '3-'  THEN '4'          -- 3-   4
                                                WHEN '4+'  THEN '5'          -- 4+   5
                                                WHEN '4'   THEN '5'          -- 4    5
                                                WHEN '4-'  THEN '5'          -- 4-   5
                                                WHEN '5+'  THEN '6A'         -- 5+   6A
                                                WHEN '5'   THEN '7A'         -- 5    7A
                                                WHEN '5-'  THEN '7A'         -- 5-   7A
                                                WHEN '6+'  THEN '7B'         -- 6+   7B
                                                WHEN '6'   THEN '7B'         -- 6    7B
                                                WHEN '6-'  THEN '7B'         -- 6-   7B
                                                WHEN '7'   THEN '8A'         -- 7    8A
                                                WHEN '8'   THEN '9'          -- 8    9
                                                WHEN '9'   THEN '10A'        -- 9    10A
                                                WHEN '10'  THEN '10B'        -- 10   10B
                       END
                 WHEN (BB.ENTP_CRGR_JUD_DT BETWEEN '20080728' AND '20120812'  OR
                       ISDATE(BB.ENTP_CRGR_JUD_DT) = 0)
                       AND A.BR_DSCD = '1'  --�߾�ȸ
                 THEN CASE TRIM(BB.ENTP_CREV_GD) WHEN '1'   THEN '1'    -- 1     1
                                                WHEN '2'   THEN '2'    -- 2     2
                                                WHEN '3+'  THEN '3'    -- 3+    3
                                                WHEN '3'   THEN '3'    -- 3     3
                                                WHEN '3-'  THEN '3'    -- 3-    3
                                                WHEN '4+'  THEN '4A'   -- 4+    4A
                                                WHEN '4'   THEN '4A'   -- 4     4A
                                                WHEN '4-'  THEN '4A'   -- 4-    4A
                                                WHEN '5+'  THEN '4B'   -- 5+    4B
                                                WHEN '5'   THEN '4B'   -- 5     4B
                                                WHEN '5-'  THEN '4B'   -- 5-    4B
                                                WHEN '6+'  THEN '5A'   -- 6+    5A
                                                WHEN '6'   THEN '5B'   -- 6     5B
                                                WHEN '6-'  THEN '6A'   -- 6-    6A
                                                WHEN '7+'  THEN '6A'   -- 7+    6A
                                                WHEN '7'   THEN '6B'   -- 7     6B
                                                WHEN '7-'  THEN '6B'   -- 7-    6B
                                                WHEN '8'   THEN '7A'   -- 8     7A(7B) --7B����
                                                WHEN '9'   THEN '8'    -- 9     8
                                                WHEN '10A' THEN '9'    -- 10A   9
                                                WHEN '10B' THEN '10'   -- 10B   10
                      END
                 WHEN (BB.ENTP_CRGR_JUD_DT BETWEEN '20080728' AND '20120812'  OR
                       ISDATE(BB.ENTP_CRGR_JUD_DT) = 0)
                       AND A.BR_DSCD = '2'  --����
                 THEN CASE TRIM(BB.ENTP_CREV_GD) WHEN '1'   THEN '1'        -- 1     1
                                                WHEN '2'   THEN '2'        -- 2     2
                                                WHEN '3+'  THEN '3'        -- 3+    3
                                                WHEN '3'   THEN '3'        -- 3     3
                                                WHEN '3-'  THEN '3'        -- 3-    3
                                                WHEN '4+'  THEN '4'        -- 4+    4
                                                WHEN '4'   THEN '4'        -- 4     4
                                                WHEN '4-'  THEN '4'        -- 4-    4
                                                WHEN '5+'  THEN '5'        -- 5+    5
                                                WHEN '5'   THEN '5'        -- 5     5
                                                WHEN '5-'  THEN '5'        -- 5-    5
                                                WHEN '6+'  THEN '6A'       -- 6+    6A
                                                WHEN '6'   THEN '6B'       -- 6     6B
                                                WHEN '6-'  THEN '7A'       -- 6-    7A
                                                WHEN '7+'  THEN '7A'       -- 7+    7A
                                                WHEN '7'   THEN '7B'       -- 7     7B
                                                WHEN '7-'  THEN '7B'       -- 7-    7B
                                                WHEN '8'   THEN '8A'       -- 8     8A(8B)
                                                WHEN '9'   THEN '9'        -- 9     9
                                                WHEN '10A' THEN '10A'      -- 10A   10A
                                                WHEN '10B' THEN '10B'      -- 10B   10B
                      END
                 ELSE BB.ENTP_CREV_GD --20120813 ����
            END                                    AS ����ſ��򰡵��

FROM        #���ʰ�������            A

LEFT OUTER JOIN
            #������     BB
            ON   A.RNNO      =   BB.RNNO
            AND  A.STD_DT   BETWEEN  BB.����������� AND  BB.������������

-- 3.  ������ crs��ް������� �κп� �ణ�� ������ �־� �̸� ������ ����, ������ �׽�Ʈ�� ���� ���ߴ�
-- ��ǥ�Ǹ��ȣ(RPST_RNNO)�� �켱�̿��ϵ����� �� ������ �����ڱ��� ���θ��Ƿ� ������ ������ �������� ����ڹ�ȣ�� ����ִ� ��찡
-- ���Ƽ� �̸� �ذ��ϱ� ���� ��ó�̳�
-- �����ڱ��� ����ڸ��Ƿ� ������ ������� �������� ��ǥ�Ǹ��ȣ(RPST_RNNO) �� �����ϸ� ������ �ȵǴ� ��찡 ����
-- �Ʒ��� ���� �����ܻ����Ŀ� update �������� �򰡵���� �߰��� �������� ����� �̿���

UPDATE      #��ȭ�����   A
SET         A.����ſ��򰡵�� = B.ENTP_CREV_GD
FROM        (
              SELECT      TA.NFFC_UNN_DSCD        AS NFFC_UNN_DSCD
                         ,TA.RNNO                 AS RNNO
                         ,TA.RPST_RNNO            AS RPST_RNNO
                         ,TB.�Ǹ��ȣ             AS �Ǹ��ȣ
                         ,TA.LST_ADJ_GD           AS ENTP_CREV_GD
                         ,TA.CMPL_DT              AS ENTP_CRGR_JUD_DT
                         ,TA.CRDT_EVL_MODL_DSCD   AS ����ſ��򰡸��������ڵ�  -- �������� �߰� : 20120823 �����
                         ,TC.ENTP_OPPB_DSCD       AS ENTP_OPPB_DSCD      -- ������������ڵ�
                         ,TD.CUST_NO              AS CUST_NO
                         ,TA.ENTP_SCL_DTL_DSCD    AS ENTP_SCL_DTL_DSCD   -- ����Ը�󼼱����ڵ� : 2014.01.24 ������
                         ,TA.EVL_AVL_DT           AS EVL_AVL_DT          -- ����ȿ���� : 2014.01.24 ������
              FROM        DWZOWN.TB_SOR_CCR_EVL_INF_TR       TA            --SOR_CCR_����������
                         ,(SELECT   A.NFFC_UNN_DSCD                        -- �߾�ȸ���ձ����ڵ�
                                   ,A.RNNO
                                   ,A.RPST_RNNO
                                   ,B.�Ǹ��ȣ
                                   ,MAX(A.CRDT_EVL_NO) AS CRDT_EVL_NO      -- ���� �ſ��򰡹�ȣ
                           FROM     DWZOWN.TB_SOR_CCR_EVL_INF_TR   A       -- SOR_CCR_����������
                           JOIN     (SELECT  DISTINCT �Ǹ��ȣ FROM #��ȭ�����)   B
                                  ON  CASE WHEN LENGTH(TRIM(B.�Ǹ��ȣ)) < 13 THEN A.RNNO ELSE A.RPST_RNNO END = B.�Ǹ��ȣ

                           WHERE    A.CRDT_EVL_PGRS_STCD  = '2'            -- �ſ�����������ڵ�'2'�򰡿Ϸ�
                           AND      A.CRDT_EVL_OMT_DSCD   = '02'           -- '01'�������,'02'��������: �� ��� �ʼ�
                           AND      A.CMPL_DT            <= '20160331'
--                         AND      A.CRDT_EVL_MODL_DSCD <> '34'             -- �������� 34(CSS���)
                           AND      A.BRNO               <> '0288'         -- �����ڱݺ� ��޿��� ����
                           GROUP BY A.NFFC_UNN_DSCD                        -- �߾�ȸ���ձ����ڵ�
                                   ,A.RNNO
                                   ,A.RPST_RNNO
                                   ,B.�Ǹ��ȣ
                          )      TB
                         ,DWZOWN.TB_SOR_CCR_EVL_BZNS_OTL_TR  TC  --SOR_CCR_�򰡾�ü���䳻��
                         ,DWZOWN.TB_SOR_CUS_MAS_BC           TD  --SOR_CUS_���⺻
              WHERE       TA.NFFC_UNN_DSCD      = TB.NFFC_UNN_DSCD
              AND         TA.BRNO              <> '0288'                 -- �����ڱݺ� ��޿��� ����
              AND         TA.CRDT_EVL_OMT_DSCD  = '02'                   -- '01'�������,'02'��������(�ſ��򰡻��������ڵ�): �� ��� �ʼ�
              AND         TA.CMPL_DT            <= '20160331'
              AND         TA.RNNO                = TB.RNNO
              AND         TA.CRDT_EVL_NO   = TB.CRDT_EVL_NO
              AND         TA.RNNO          = TC.RNNO
              AND         TA.CRDT_EVL_NO   = TC.CRDT_EVL_NO
              AND         TB.�Ǹ��ȣ     *= TD.CUST_RNNO
              AND         TA.NFFC_UNN_DSCD  =  '1'                -- �߾�ȸ  �̰;����� �Ǹ��ȣ���� �ߺ�����.
            )   B
WHERE       1=1
AND         A.�Ǹ��ȣ  = B.�Ǹ��ȣ
;

-- CASE 4
SELECT      CASE WHEN  T.ENTP_CREV_GD IS NOT NULL THEN T.ENTP_CREV_GD           ELSE TT.ENTP_CREV_GD        END AS ����ſ��򰡵��_����
           ,CASE WHEN  T.ENTP_CREV_GD IS NOT NULL THEN T.CRDT_EVL_MODL_DSCD     ELSE TT.CRDT_EVL_MODL_DSCD  END AS ����ſ��򰡸���_����

LEFT OUTER JOIN
            (
            -- �Ϲ������� SOR_CCR_������������ RPST_RNNO �� �켱�������� �������� �����ͼ� ���¿����� ���ֿ� JOIN �Ͽ� �򰡵���� ��������
            -- ������ RPST_RNNO���� ������ �Ǹ��ȣ�� �ְ� RNNO�� JOIN �ؾ� ����� JOIN�� �Ǵ� ��찡 �����Ƿ�
            -- �������� ������ �κп� ���ؼ� �� �������� �����Ѵ�

                   SELECT   TA.NFFC_UNN_DSCD        AS NFFC_UNN_DSCD
                           ,TRIM(TA.RNNO)           AS RNNO
                           ,TA.LST_ADJ_GD           AS ENTP_CREV_GD
                           ,TA.CMPL_DT              AS ENTP_CRGR_JUD_DT
                           ,TA.CRDT_EVL_MODL_DSCD   AS CRDT_EVL_MODL_DSCD  -- �������� �߰� : 20120823 �����
                           ,TC.ENTP_OPPB_DSCD       AS ENTP_OPPB_DSCD      -- ������������ڵ�
                           ,TD.CUST_NO              AS CUST_NO
                           ,TA.ENTP_SCL_DTL_DSCD    AS ENTP_SCL_DTL_DSCD   -- ����Ը�󼼱����ڵ� : 2014.01.24 ������
                           ,TA.EVL_AVL_DT           AS EVL_AVL_DT          -- ����ȿ���� : 2014.01.24 ������
                   FROM     DWZOWN.TB_SOR_CCR_EVL_INF_TR       TA  --SOR_CCR_����������
                           ,(SELECT   NFFC_UNN_DSCD                        -- �߾�ȸ���ձ����ڵ�
                                     ,TRIM(TA.RNNO)    AS RNNO
                                     ,MAX(CRDT_EVL_NO) AS CRDT_EVL_NO      -- ���� �ſ��򰡹�ȣ
                             FROM     DWZOWN.TB_SOR_CCR_EVL_INF_TR   --SOR_CCR_����������
                             WHERE    CRDT_EVL_PGRS_STCD  = '2'            -- �ſ�����������ڵ�'2'�򰡿Ϸ�
                             AND      CRDT_EVL_OMT_DSCD   = '02'           -- '01'�������,'02'��������: �� ��� �ʼ�
                             AND      CMPL_DT            <= '20160630'
            --               AND      CRDT_EVL_MODL_DSCD <> '34'           -- �������� 34(CSS���)
                             AND      BRNO               <> '0288'         -- �����ڱݺ� ��޿��� ����
                             GROUP BY NFFC_UNN_DSCD,RNNO)      TB
                           ,DWZOWN.TB_SOR_CCR_EVL_BZNS_OTL_TR  TC  --SOR_CCR_�򰡾�ü���䳻��
                           ,DWZOWN.TB_SOR_CUS_MAS_BC           TD  --SOR_CUS_���⺻
                   WHERE    TA.NFFC_UNN_DSCD      = TB.NFFC_UNN_DSCD
                   AND      TA.BRNO              <> '0288'                 -- �����ڱݺ� ��޿��� ����
                   AND      TA.CRDT_EVL_OMT_DSCD  = '02'                   -- '01'�������,'02'��������(�ſ��򰡻��������ڵ�): �� ��� �ʼ�
                   AND      TA.CMPL_DT           <= '20160630'
                   AND      TRIM(TA.RNNO)        = TB.RNNO
                   AND      TA.CRDT_EVL_NO       = TB.CRDT_EVL_NO
                   AND      TA.RNNO              = TC.RNNO
                   AND      TA.CRDT_EVL_NO       = TC.CRDT_EVL_NO
                   AND      TRIM(TA.RNNO)       *= TD.CUST_RNNO
                   AND      TA.NFFC_UNN_DSCD  =  '1'                -- �߾�ȸ  �̰;����� �Ǹ��ȣ���� �ߺ�����.
            )      TT
            ON     A.RNNO   =  TT.RNNO


//}

//{  #�㺸  #������  #�㺸������ #������������ #������������ #�����������
--CASE1
               SELECT DISTINCT
                      C.ACN_DCMT_NO AS ���¹�ȣ
                     ,CASE WHEN B.CCG_NM LIKE '%����%'  THEN  '1. ����'
                           WHEN B.CCG_NM LIKE '%����%'  THEN  '2. ����'
                           ELSE '3. ��Ÿ'
                       END   AS �㺸������������
               FROM   TB_SOR_CLM_REST_MRT_BC B  -- SOR_CLM_�ε���㺸�⺻
                     ,TB_SOR_CLM_CLN_LNK_TR  C  -- ���ſ��᳻��
                     ,TB_SOR_CLM_STUP_BC     D  -- SOR_CLM_��������
               WHERE  C.CLN_LNK_STCD = '02'     -- ���ſ�������ڵ� : ����
               AND    C.STUP_NO      = D.STUP_NO
               AND    B.MRT_NO       = D.MRT_NO
               AND    (
                         B.CCG_NM IS NOT NULL AND (  B.CCG_NM LIKE '%����%'  OR  B.CCG_NM LIKE '%����%' )
                       )
--CASE2

      SELECT
           ,TRIM(T9.MPSD_NM) || ' ' || TRIM(T9.CCG_NM) || ' ' || TRIM(T9.EMD_NM) || ' ' || TRIM(T9.LINM) AS �㺸������


      LEFT OUTER JOIN
                (
                   SELECT   A.���Ű��¹�ȣ
                           ,A.MPSD_CD
                           ,A.CCG_CD
                           ,A.EMD_CD
                           ,A.LINM_CD
                           ,A.MPSD_NM          --�����õ���
                           ,A.CCG_NM           --�ñ�����
                           ,A.EMD_NM           --���鵿��
                           ,A.LINM             --����
                           ,A.THG_SIT_DTL_ADR
                           ,ISNULL(B.MIN_SPCT_ARA_TPCD, '00')  AS SPCT_ARA_TPCD
                   FROM    (SELECT   B.CLN_APC_NO   AS ���Ž�û��ȣ
                                    ,A.MRT_NO       AS �㺸��ȣ
                                    ,A.STUP_NO      AS ������ȣ
                                    ,B.ACN_DCMT_NO  AS ���Ű��¹�ȣ
                                    ,C.MPSD_CD
                                    ,C.CCG_CD
                                    ,C.EMD_CD
                                    ,C.LINM_CD
                                    ,C.MPSD_NM          --�����õ���
                                    ,C.CCG_NM           --�ñ�����
                                    ,C.EMD_NM           --���鵿��
                                    ,C.LINM             --����
                                    ,C.THG_SIT_DTL_ADR  --���Ǽ��������ּ�
                                    ,RANK() OVER (PARTITION BY B.ACN_DCMT_NO ORDER BY B.CLN_APC_NO, A.STUP_NO, A.MRT_NO) AS ��ǥ_�㺸
                            FROM     TB_SOR_CLM_STUP_BC     A   --SOR_CLM_�����⺻
                                    ,TB_SOR_CLM_CLN_LNK_TR  B   --SOR_CLM_���ſ��᳻��
                                    ,TB_SOR_CLM_REST_MRT_BC C   --SOR_CLM_�ε���㺸�⺻
                            WHERE    A.NFFC_UNN_DSCD = '1'           --�߾�ȸ���ձ����ڵ�
                            AND      A.STUP_DT       <= P_��������
                            AND      A.STUP_STCD     = '02'            --���������ڵ�(02:������)
                            AND      A.STUP_NO       = B.STUP_NO        --������ȣ
                            AND      B.ENR_DT        <= P_��������
                            AND      B.CLN_LNK_STCD  IN ('02','03')  --���ſ�������ڵ�(02:����,03:��������)
                            AND      A.MRT_NO        = C.MRT_NO
                            AND      C.MPSD_CD       IS NOT NULL
                            ) A
                          ,(SELECT   MPSD_CD
                                    ,CCG_CD
                                    ,EMD_CD
                                    ,LINM_CD
                                    ,MIN(SPCT_ARA_TPCD)  AS MIN_SPCT_ARA_TPCD  --MIN�� ������ �����迡�� ����Ÿ �ݿ��� �߸��Ǿ� �ߺ��߻��� ���������� �����ϱ� ����
                            FROM     TB_SOR_CLM_SPCT_ARA_BC  --SOR_CLM_Ư�������⺻
                            WHERE    US_YN = 'Y'
                            AND      SPCT_ARA_TPCD IN ('01','02','03') --(01.������������ 02.������������ 03.�����������)
                            GROUP BY MPSD_CD
                                    ,CCG_CD
                                    ,EMD_CD
                                    ,LINM_CD
                            ) B
                   WHERE    A.��ǥ_�㺸 = 1
                   AND      A.MPSD_CD   *= B.MPSD_CD
                   AND      A.CCG_CD    *= B.CCG_CD
                   AND      A.EMD_CD    *= B.EMD_CD
                   AND      A.LINM_CD   *= B.LINM_CD
                )                                           T9
                ON   A.INTG_ACNO  = T9.���Ű��¹�ȣ

-- CASE3 ��ȿ�㺸�ݾ� ���� ū���Ѱ�
SELECT      C.STD_DT             AS ��������
           ,C.INTG_ACNO          AS ���հ��¹�ȣ
           ,C.MRT_CD             AS �㺸�ڵ�
           ,C.MRT_NO             AS �㺸��ȣ
           ,MAX(C.APSL_AMT)      AS �����ݾ�
           ,MAX(C.ACWR_AVL_MRAM) AS ���ǰ�ġ��ȿ�㺸�ݾ�
           ,MAX(C.LQWR_AVL_MRAM) AS û�갡ġ��ȿ�㺸�ݾ�
           ,MAX(C.PRRN_AMT)      AS �������ݾ�
           ,MAX(C.ACF_RT)        AS �����
INTO        #�㺸����  -- DROP TABLE #�㺸����           
FROM        TB_SOR_CLM_MRT_APRT_EOM_TZ C -- SOR_CLM_ä���ں��㺸��п�������
JOIN        (
             SELECT   STD_DT           AS  ��������
                     ,INTG_ACNO        AS  ���հ��¹�ȣ
                     ,MRT_NO           AS  �㺸��ȣ
                     ,MRT_CD           AS  �㺸�ڵ�
                     ,MAX(STUP_NO)     AS  ������ȣ
             FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ --SOR_CLM_ä���ں��㺸��п�������
             WHERE   1=1
             AND     MRT_APRT_TPCD  = '01' --�㺸��������ڵ�
             AND     MRT_NO <> '999999999999'
             AND     STUP_NO <> '999999999999'
             ---------------------------------------------------------------------------------
             AND     STD_DT     =  '20180731'     -- 9���� �ڷḸ �ʿ��ϹǷ�
             AND     MRT_CD NOT IN ('601','602')  -- �κ���(601), �����ſ�(602) ����
             AND     NFM_YN     = 'N'             -- �����㺸����
             AND     INTG_ACNO  IN (SELECT  ���հ��¹�ȣ  FROM  #������)
             ---------------------------------------------------------------------------------
             GROUP BY ��������, ���հ��¹�ȣ, �㺸��ȣ, �㺸�ڵ�
            ) D
            ON    C.STD_DT    = D.��������
            AND   C.INTG_ACNO = D.���հ��¹�ȣ --AND C.INTG_ACNO = '101008338879'
            AND   C.MRT_NO    = D.�㺸��ȣ
            AND   C.STUP_NO   = D.������ȣ
            AND   C.MRT_CD    = D.�㺸�ڵ�
WHERE       1=1
AND         C.MRT_APRT_TPCD   = '01'
GROUP BY    C.STD_DT, C.INTG_ACNO, C.MRT_CD, C.MRT_NO
;

LEFT OUTER JOIN
            (
             SELECT      A.���հ��¹�ȣ
                        ,TRIM(B.MPSD_NM) || ' ' || TRIM(B.CCG_NM) || ' ' || TRIM(B.EMD_NM) || ' ' || TRIM(B.LINM) AS �㺸������                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
             FROM        (           
                          SELECT      A.��������
                                     ,A.���հ��¹�ȣ
                                     ,A.�㺸�ڵ�
                                     ,A.�㺸��ȣ
                                     ,ROW_NUMBER(*) OVER(PARTITION BY  A.���հ��¹�ȣ ORDER BY A.���ǰ�ġ��ȿ�㺸�ݾ� DESC) AS RNUM
                          FROM        #�㺸����   A
                         )   A
             JOIN        TB_SOR_CLM_REST_MRT_BC B  -- SOR_CLM_�ε���㺸�⺻       
                         ON   A.�㺸��ȣ  = B.MRT_NO      
             WHERE       A.RNUM = 1
            )  C
            ON A.���հ��¹�ȣ  = C.���հ��¹�ȣ 

//}

//{  #ASS��� #���νſ��򰡵��  #����ASS���  #DAD
--ASS����� ��û�ܿ��� ���º��� ����� ���Ҽ� �ִ� ���տ��ſ��� ���º��� ����� �� �ִ�
--���º��� ����� �ʿ��� ��쿡�� ���տ����� ����ϸ� �ǳ� ������ ����� ���ϴ� ��쿡�� �ε������� �ִ�
--TB_SOR_DAD_ISD_CRGR_TR(DAD_���νſ��޳���)�� ASS ����� ����� �� �ִ�

--1.���տ��ſ��� ASS ��� �������� ���
--���º��� ��������� �����´�

             SELECT  TBB.CLN_ACNO, TBB.CLN_APC_NO, TBB.CUST_NO, TBB.HSGR_GRN_DSCD
                  --,CASE WHEN TRIM(TBA.FSR_ASS_GD) > '00' THEN
                  --           TRIM(TBA.FSR_ASS_GD)   --�����ASS���
                  --      ELSE TRIM(TBA.ASS_CRDT_GD)  --ASS�ſ���
                  -- END  AS ASS_CRDT_GD
                    ,TRIM(TBA.ASS_CRDT_GD) AS ASS_CRDT_GD
                    ,TBA.DWUP_STD_DT                  --�ۼ���������
             FROM    TB_SOR_PLI_SYS_JUD_RSLT_TR  TBA              --SOR_PLI_�ý��۽ɻ�������
                    ,(--���Ž�û�����ڵ�'01'�ű�,'07'��ǰƯȭ����(�ű�),'08'���ν���Ưȭ����(�ű�),'09'���ν���(�ű�),'51'(ä���μ�), '02'(��ȯ),'04'(�Ұ���ä�Ǵ�ȯ)
                      --'21'(����)�� �ϴ� ��󿡼� ����
                      --���¹�ȣ, ����ȣ�� ���� : TB_PLI_SYS_JUD_RSLT_TR �� �Ѱ���,�ѽ�û��ȣ�� ����ȣ 2�� ����
                      SELECT   TA.CLN_ACNO, TA.CLN_APC_NO, TB.CUST_NO, TB.HSGR_GRN_DSCD  --��������� �ߺ�����
                      FROM     (--
                                SELECT   A.CLN_ACNO
                                        ,MAX(B.CLN_APC_NO) AS CLN_APC_NO
                                FROM     TB_SOR_PLI_CLN_APC_BC       A   --SOR_PLI_���Ž�û�⺻
                                        ,TB_SOR_PLI_SYS_JUD_RSLT_TR  B   --SOR_PLI_�ý��۽ɻ�������
                                WHERE    ((A.CLN_APC_PGRS_STCD = '04' AND A.CLN_APC_DSCD IN ('01','07','08','09', '02','04')) OR  --20120820
                                          (A.CLN_APC_PGRS_STCD = '13' AND A.CLN_APC_DSCD = '51'))  --ä���μ�
                                --20121017 : B.CSS_MODL_DSCD IS NULL ���� �ʼ�
                                AND      (B.CSS_MODL_DSCD IS NULL OR B.CSS_MODL_DSCD IN ('31','32','34'))    -- CSS���������ڵ� 30(CRS����)���� 20120824 �����
                                AND      A.CLN_APC_NO        = B.CLN_APC_NO
                                AND      A.CUST_NO = B.CUST_NO  --20121017 : �߰�
                                --AND      B.DWUP_STD_DT <= '20120827'  --TEST 20120827�Ϻ��� ������. 20120827 ~ 20121016���� UPDATE �ʿ� ��
                                --AND     (B.APC_ASSC > 0 OR B.FSR_APC_ASSC > 0) : ���������Ұ� -> TOBE������ �������� ����(������-�Ż�K�亯)
                                GROUP BY A.CLN_ACNO
                               )                         TA
                              ,TB_SOR_PLI_CLN_APC_BC     TB   --SOR_PLI_���Ž�û�⺻
                      WHERE    1=1
                      --AND      TA.CLN_ACNO          = TB.CLN_ACNO  --20121017 : ���¹�ȣ JOIN �ʿ� ����. �Ʒ� ��û��ȣ�� JOIN �� ��(�Ż�)
                      AND      TA.CLN_APC_NO        = TB.CLN_APC_NO
                      AND      ((TB.CLN_APC_PGRS_STCD = '04' AND TB.CLN_APC_DSCD IN ('01','07','08','09', '02','04')) OR  --20120820
                                (TB.CLN_APC_PGRS_STCD = '13' AND TB.CLN_APC_DSCD = '51'))  --ä���μ�
                     )                           TBB
             WHERE    TBA.CLN_APC_NO        = TBB.CLN_APC_NO
             AND      TBA.CUST_NO           = TBB.CUST_NO


--2.DAD_���νſ��޳���  ���� ASS ��� �������� ���
-- ���� ������û��ȣ�� �ش��ϴ� ����� ������
       SELECT  V_��������
              ,C.CUST_RNNO                                       /* �Ǹ��ȣ             */
              ,B.NFFC_UNN_DSCD                                   /* �������ڵ�           */
              ,'00000000'                                        /* �ſ�������         */
              ,' '                                               /* �ſ��򰡸��������ڵ� */
              ,'0'                                               /* �����������         */
              ,'0'                                               /* ����ſ��򰡵��     */
              ,'00000000'                                        /* ����ſ�����ȿ���� */
              ,MAX(CASE WHEN A.DWUP_STD_DT IS NULL THEN A.DWUP_STD_DT
                        ELSE B.APC_DT1
                   END)  AS CLN_ASS_EVL_DT                        /* ����ASS������      */
              --,CASE WHEN cast(FSR_ASS_GD as int) > 0 THEN FSR_ASS_GD   /*  2012.02.09 �̱���, �̼��� ���� ��û��.  */
              --      ELSE ASS_CRDT_GD                                   /*  NEXTRO ���� ASS�ſ��� ����� ���� FSR_ASS_GD(�����ASS���)��  */
              -- END CLN_ASS_CRDT_GD                                     /*  '00'���� �����鼭  FSR_ASS_GD ���� �ݿ���  */
              , A.ASS_CRDT_GD AS CLN_ASS_CRDT_GD                    --20130628 : ����ε�޿��ο� ������� ASS_CRDT_GD�� �����Ѵ�.
              ,'00000000'     AS CLN_BSS_EVL_DT
              ,'0'            AS CLN_BSS_CRDT_GD
              ,'00000000'     AS CRD_ASS_EVL_DT
              ,'0'            AS CRD_ASS_CRDT_GD
              ,'0'            AS CRD_BSS_CRDT_GD
              ,'00000000'     AS CRD_BSS_EVL_DT
              ,'0'            AS CB_CRDT_GD
              ,'00000000'     AS ENTP_CREV_SVY_DT
              ,'0'            AS ENTP_CREV_NE_GD
              ,'0'            AS CMBN_GD
       FROM    TB_SOR_PLI_SYS_JUD_RSLT_TR A  --SOR_PLI_�ý��۽ɻ�������
              ,(SELECT CUST_NO
                      ,NFFC_UNN_DSCD
                      ,MAX(APC_DT)     AS APC_DT1
                      ,MAX(CLN_APC_NO) AS CLN_APC_NO1
                FROM   TB_SOR_PLI_CLN_APC_BC A  --SOR_PLI_���Ž�û�⺻
                WHERE  APC_DT <= V_��������
                AND    CLN_APC_PGRS_STCD ='04'
                GROUP  BY CUST_NO, NFFC_UNN_DSCD
               ) B
               ,TB_SOR_CUS_MAS_BC C
       WHERE    A.CLN_APC_NO = B.CLN_APC_NO1
       AND      A.CUST_NO = B.CUST_NO
       AND      A.CUST_NO = C.CUST_NO
       AND      ISNULL(A.CSS_MODL_DSCD,'00') NOT IN ('30','31','32')  -- ��״� �����ε� ����ɻ� Ÿ�� �ֵ��� �ſ���
       GROUP BY B.NFFC_UNN_DSCD
               ,C.CUST_RNNO
               ,CLN_ASS_CRDT_GD

//}

//{  #ROW_NUMBER #RANK #PARTITION
JOIN              (
                        SELECT A.��������
                              ,A.����ȣ
                              ,A.����ȣ
                              ,A.����
                              ,ROW_NUMBER() OVER (PARTITION BY A.����ȣ ORDER BY �����ܾ� DESC) AS SEQ
                        FROM   #�������������ܾ�  A
                  )     B
                  ON    A.��������  = B.��������
                  AND   A.����ȣ  = B.����ȣ
                  AND   B.SEQ       = 1

//}

//{  #ǥ�ػ���з� #ǥ�ػ���з��ڵ� #��з�

-- CASE 1.
JOIN        -- ����з��ڵ� I55(���ھ�) �� ��
            (
               SELECT   A.CUST_NO
                       ,A.STDD_INDS_CLCD
                       ,B.STDD_INDS_LCCD
                       ,B.STDD_INDS_MCCD
               FROM     #TEMP_��������з��ڵ�        A
                       ,DWZOWN.TB_SOR_CMI_STDD_INDS_BC  B  --CMI_ǥ�ػ���⺻
               WHERE    A.STDD_INDS_CLCD = B.STDD_INDS_CLCD
               AND      B.STDD_INDS_LCCD = 'I'
               AND      B.STDD_INDS_MCCD = '55'
            ) Z2
            ON    A.CUST_NO   = Z2.CUST_NO

-- CASE 2.   ��з��ڵ� ���
SELECT
           ,A.ǥ�ػ���з��ڵ�
           ,C.STDD_INDS_LCCD    AS  ǥ�ػ����з��ڵ�
........
LEFT OUTER JOIN
            DWZOWN.TB_SOR_CMI_STDD_INDS_BC  C  --CMI_ǥ�ػ���⺻
            ON  A.ǥ�ػ���з��ڵ�  =  C.STDD_INDS_CLCD
;

-- CASE 3.  ��з��ڵ�(��) ���
SELECT      TRIM(A.STDD_INDS_LCCD)||'.'||
            LEFT(TRIM(B.STDD_INDS_CLSF_NM),CHARINDEX('(',B.STDD_INDS_CLSF_NM)-1) AS ��з���
           ,A.STDD_INDS_CLCD                                                     AS ���з��ڵ�
INTO        #TEMP_ǥ�ػ���з�
FROM        (SELECT   STDD_INDS_CLCD                          -- ���з��ڵ�
                     ,STDD_INDS_LCCD                          -- ��з��ڵ�
                     ,STDD_INDS_MCCD                          -- �ߺз��ڵ�
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_ǥ�ػ���⺻)
             WHERE    STDD_INDS_CLSF_DSCD = '4'               -- ǥ�ػ���з������ڵ�(4:���з�)
            ) A
           ,(SELECT   STDD_INDS_CLCD                          -- ǥ�ػ���з��ڵ�
                     ,STDD_INDS_CLSF_NM                       -- ǥ�ػ���з���
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_ǥ�ػ���⺻)
             WHERE    STDD_INDS_CLSF_DSCD = '1'               -- ǥ�ػ���з������ڵ�(1:��з�)
            ) B
WHERE       A.STDD_INDS_LCCD *= B.STDD_INDS_CLCD              -- ��з��ڵ�
;


SELECT      ................
           ,B.��з���              AS   ����

FROM        #���λ����  A
LEFT OUTER JOIN
            #TEMP_ǥ�ػ���з�  B  --CMI_ǥ�ػ���⺻
            ON  LEFT(A.ǥ�ػ���з��ڵ�,4) = B.���з��ڵ�

-- CASE 4.  �ܼ��� ����з��ڵ� ���з��� ���
SELECT
           ,ISNULL(A.STDD_INDS_CLCD, '')     AS �����ڵ�
           ,TRIM(ISNULL(Z2.STDD_INDS_CLSF_NM, ''))    AS ������

LEFT OUTER JOIN
            DWZOWN.TB_SOR_CMI_STDD_INDS_BC      Z2    -- (SOR_CMI_ǥ�ػ���⺻)
            ON  A.STDD_INDS_CLCD = Z2.STDD_INDS_CLCD


-- CASE 5 20170701 �η� ����з��ڵ尡 �ٲ� ���� �� �з��ڵ带 ����ϰ� ������� �ӽ����̺� �ε��ؼ� ����ϴ� ���

SELECT  '20170701'  AS  STD_DT       -- �� ����з��ڵ�� �������ڸ� ���������� ����
       ,*
INTO    #OT_SOR_CMI_STDD_INDS_BC  -- DROP TABLE #OT_SOR_CMI_STDD_INDS_BC
FROM    TB_SOR_CMI_STDD_INDS_BC   -- SOR_CMI_ǥ�ػ���⺻
;

--SELECT * FROM  #OT_SOR_CMI_STDD_INDS_BC

LOAD TABLE #OT_SOR_CMI_STDD_INDS_BC (
        STD_DT DEFAULT '20170630',              -- �� ����з��ڵ�� �������ڸ� 20170630 �� ����
        STDD_INDS_CLCD '|!' NULL(ZEROS),
        INFS_CHG_DTTM DEFAULT NOW(*),
        ORG_C '|!' NULL(ZEROS),
        LAST_CHNG_MN_USID '|!' NULL(ZEROS),
        LAST_CHNG_DT '|!' NULL(ZEROS),
        FW_LOG_NO '|!' NULL(ZEROS),
        LST_AMN_TS '|!' NULL(ZEROS),
        LDGR_STCD '|!' NULL(ZEROS),
        STDD_INDS_CLSF_DSCD '|!' NULL(ZEROS),
        STDD_INDS_LCCD '|!' NULL(ZEROS),
        STDD_INDS_MCCD '|!' NULL(ZEROS),
        STDD_INDS_SCCD '|!' NULL(ZEROS),
        STDD_INDS_DTCL_CD '|!' NULL(ZEROS),
        STDD_INDS_FDC_CD '|!' NULL(ZEROS),
        STDD_INDS_CLSF_NM '|!' NULL(ZEROS),
        STDD_INDS_CLSF_EN_NM '|!' NULL(ZEROS)
)
FROM '/ettdata/init/com/tb_cmi_stdd_inds_bc_20170619.dat'
DEFAULTS ON
ROW DELIMITED BY '@@\n'
LOG DELIMITED BY '|'
WITH CHECKPOINT OFF
NOTIFY 1000000
ESCAPES OFF
QUOTES OFF
ON FILE ERROR ROLLBACK ;
;

SELECT * FROM  #OT_SOR_CMI_STDD_INDS_BC
ORDER BY 1,2
;

SELECT      A.STD_DT                  AS ��������
           ,A.INTG_ACNO               AS ���¹�ȣ
           ,A.STDD_INDS_CLCD          AS ����з��ڵ�
           ,C.��з��ڵ�
           ,C.��з���

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A       --DWA_���տ��ű⺻
LEFT OUTER JOIN
            (
              SELECT   A.STD_DT                                                             AS ��������
                      ,A.STDD_INDS_LCCD                                                     AS ��з��ڵ�
                      ,TRIM(A.STDD_INDS_LCCD)||'.'||
                       LEFT(TRIM(B.STDD_INDS_CLSF_NM),CHARINDEX('(',B.STDD_INDS_CLSF_NM)-1) AS ��з���
                      ,A.STDD_INDS_CLCD                                                     AS ���з��ڵ�
              
              FROM     (SELECT   STD_DT
                                ,STDD_INDS_CLCD                          -- ���з��ڵ�
                                ,STDD_INDS_LCCD                          -- ��з��ڵ�
                                ,STDD_INDS_MCCD                          -- �ߺз��ڵ�
                        FROM     #OT_SOR_CMI_STDD_INDS_BC                -- �ӽ����̺�(ǥ�ػ���⺻)
                        WHERE    STDD_INDS_CLSF_DSCD = '4'               -- ǥ�ػ���з������ڵ�(4:���з�)
                       ) A
              JOIN    (SELECT   STD_DT
                                ,STDD_INDS_CLCD                          -- ǥ�ػ���з��ڵ�
                                ,STDD_INDS_CLSF_NM                       -- ǥ�ػ���з���
                        FROM     #OT_SOR_CMI_STDD_INDS_BC                -- �ӽ����̺�(ǥ�ػ���⺻)
                        WHERE    STDD_INDS_CLSF_DSCD = '1'               -- ǥ�ػ���з������ڵ�(1:��з�)
                       ) B
                       ON    A.STDD_INDS_LCCD  = B.STDD_INDS_CLCD              -- ��з��ڵ�
                       AND   A.STD_DT          = B.STD_DT
            ) C
            ON    LEFT(A.STDD_INDS_CLCD, 4) = C.���з��ڵ�
            AND   CASE WHEN A.STD_DT >= '20170701' THEN '20170701' ELSE '20170630' END  = C.��������
                -- 20170701 10�� ǥ�ػ���з��ڵ� ����

-- CASE 6 ��з�, �ߺз�, �Һз� ���
SELECT      TRIM(A.STDD_INDS_LCCD)||'.'|| LEFT(TRIM(B.STDD_INDS_CLSF_NM),CHARINDEX('(',B.STDD_INDS_CLSF_NM)-1) AS ��з���
           ,TRIM(A.STDD_INDS_MCCD)||'.'|| TRIM(C.STDD_INDS_CLSF_NM) AS �ߺз���
           ,TRIM(A.STDD_INDS_SCCD)||'.'|| TRIM(D.STDD_INDS_CLSF_NM) AS �Һз���
           ,A.STDD_INDS_CLCD                                        AS ���з��ڵ�
INTO        #TEMP_ǥ�ػ���з�  -- DROP TABLE #TEMP_ǥ�ػ���з�
FROM        (SELECT   STDD_INDS_CLCD                          -- ���з��ڵ�
                     ,STDD_INDS_LCCD                          -- ��з��ڵ�
                     ,STDD_INDS_MCCD                          -- �ߺз��ڵ�
                     ,STDD_INDS_SCCD                          -- �Һз��ڵ�
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_ǥ�ػ���⺻)
             WHERE    STDD_INDS_CLSF_DSCD = '4'               -- ǥ�ػ���з������ڵ�(4:���з�)
            ) A
LEFT OUTER JOIN
            (SELECT   STDD_INDS_CLCD                          -- ǥ�ػ���з��ڵ�
                     ,STDD_INDS_CLSF_NM                       -- ǥ�ػ���з���
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_ǥ�ػ���⺻)
             WHERE    STDD_INDS_CLSF_DSCD = '1'               -- ǥ�ػ���з������ڵ�(1:��з�)
            ) B
            ON        A.STDD_INDS_LCCD = B.STDD_INDS_CLCD              -- ��з��ڵ�
LEFT OUTER JOIN
            (SELECT   STDD_INDS_CLCD                          -- ǥ�ػ���з��ڵ�
                     ,STDD_INDS_CLSF_NM                       -- ǥ�ػ���з���
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_ǥ�ػ���⺻)
             WHERE    STDD_INDS_CLSF_DSCD = '2'               -- ǥ�ػ���з������ڵ�(2:�ߺз�)
            ) C
            ON        LEFT(TRIM(A.STDD_INDS_CLCD),2) = TRIM(C.STDD_INDS_CLCD)
LEFT OUTER JOIN
            (SELECT   STDD_INDS_CLCD                          -- ǥ�ػ���з��ڵ�
                     ,STDD_INDS_CLSF_NM                       -- ǥ�ػ���з���
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_ǥ�ػ���⺻)
             WHERE    STDD_INDS_CLSF_DSCD = '3'               -- ǥ�ػ���з������ڵ�(3:�Һз�)
            ) D
            ON        LEFT(TRIM(A.STDD_INDS_CLCD),3) = TRIM(D.STDD_INDS_CLCD)
;

//}

//{  #������ #â���� #â���������
--SOR_CCR_��ü���䳻�� �Ǵ� �������� �����Ϻ��� KIS�������� �������� �� �� �������
--������ >> KIS������ >> ��ü������ ������ ���彺ĵ�ؼ� �������� ��������
-- ������ ������ ������ ���ü� ������ Ȯ���� �������ڴ� MIN OR MAX �ؼ� ����ؾ� �Ѵ�.

SELECT      A.����ȣ
           ,MIN(
                 CASE WHEN ISDATE(B.ESTB_DT)  = 1  THEN B.ESTB_DT
                      WHEN ISDATE(C.ESTB_DT)  = 1  THEN C.ESTB_DT
                      WHEN ISDATE(D.��������) = 1  THEN D.��������
                      WHEN ISDATE(E.��������) = 1  THEN E.��������
                      WHEN ISDATE(F.��������) = 1  THEN F.��������
                 END
              )  AS ��������
--         ,CONVERT(CHAR(8), DATEADD(YY, 7, ��������), 112)   AS â��7����

INTO        #TEMP_������  -- DROP TABLE #TEMP_������

FROM        #����ڱ�  A

JOIN        DWZOWN.OM_DWA_INTG_CUST_BC  B   --DWA_���հ��⺻
            ON    A.����ȣ  =  B.CUST_NO

LEFT OUTER JOIN
            DWZOWN.OM_DWA_INTG_CUST_BC  C   --DWA_���հ��⺻
            ON    A.���λ���ڹ�ȣ = C.CUST_RNNO

LEFT OUTER JOIN
            (SELECT   BRN            AS ����ڵ�Ϲ�ȣ
                     ,MIN(ESTB_DT)   AS ��������
             FROM     TB_SOR_CCR_KIS_BZNS_BC  --SOR_CCR_KIS��ü����⺻
             WHERE    ESTB_DT > '00000000'
             GROUP BY BRN
            ) D
            ON   A.�Ǹ��ȣ  =  D.����ڵ�Ϲ�ȣ

LEFT OUTER JOIN
            (SELECT   BRN            AS ����ڵ�Ϲ�ȣ
                     ,MIN(ESTB_DT)   AS ��������
             FROM     TB_SOR_CCR_KIS_BZNS_BC  --SOR_CCR_KIS��ü����⺻
             WHERE    ESTB_DT > '00000000'
             GROUP BY BRN
            ) E
            ON   A.���λ���ڹ�ȣ  = E.����ڵ�Ϲ�ȣ

LEFT OUTER JOIN
            (SELECT   CASE WHEN B.RPST_RNNO  IS NOT NULL  OR B.RPST_RNNO > ' '  THEN B.RPST_RNNO
                           ELSE A.RNNO END    AS �Ǹ��ȣ
                     ,MIN(A.ESTB_DT)               AS ��������
             FROM     TB_SOR_CCR_EVL_BZNS_OTL_TR A        --SOR_CCR_�򰡾�ü���䳻��
                     ,TB_SOR_CCR_EVL_INF_BC      B        --SOR_CCR_�������⺻
             WHERE    A.RNNO          = B.RNNO
             AND      A.CRDT_EVL_NO   = B.CRDT_EVL_NO
             AND      B.NFFC_UNN_DSCD = '1'      --�߾�ȸ���ձ����ڵ�(1:�߾�ȸ, 2:����)
             AND      B.CRDT_EVL_PGRS_STCD ='2'  --�ſ�����������ڵ�(1:������, 2:�򰡿Ϸ�)
             AND      A.ESTB_DT > '00000000'
             GROUP BY �Ǹ��ȣ
            ) F
            ON   A.�Ǹ��ȣ =  F.�Ǹ��ȣ

WHERE       1=1
GROUP BY    A.����ȣ
;


//}

//{  #B2401 #�ݰ�������

--PROCEDURE DWZPRC.UP_DWZ_�濵_N0058_�ݰ�����������  �� �Ϻκ�

    /************************************************************************
    --�� �ڱݹ����� �����Ѵ�.
    ************************************************************************/
    SELECT    STD_DT          AS ��������
             ,'�������'      AS ����1
             ,CASE WHEN ACSB_CD  IN ('15011211','15011011')
                     OR ACSB_CD5   ='14004308'                        THEN '��Ÿä��'
                   WHEN ACSB_CD2  = '93000101'                        THEN 'Ȯ�����޺���'
                   ELSE                                                    '����ä��'
                   END        AS ����2
             ,CASE WHEN ACSB_CD4  = '13000801'                         THEN '��ȭ�����'
                   WHEN ACSB_CD4 IN ('13001108','13001308','13001408') THEN '��ȭ�����'             --�����������꽺����,���ܿ�ȭ����ݰ���  ����
                   WHEN ACSB_CD4  = '13001601'                         THEN '���޺��������'
                   WHEN ACSB_CD4 IN ('13001508','13001001')            THEN '���Կ�ȯ'               --���Ծ���(CP����) ����
                   WHEN ACSB_CD4  = '13001701'                         THEN '�ſ�ī��'
                   WHEN ACSB_CD4  = '13001901'                         THEN '����ä'
                   ELSE '0'
                   END        AS ����3
             ,CASE WHEN ACSB_CD5 = '14002401'  THEN '���'
                   WHEN ACSB_CD5 = '14002501'  THEN '����'
                   WHEN ACSB_CD5 = '14002601'  THEN '����'
                   ELSE '0'
                   END        AS �ڱݱ���
             ,ACSB_CD10       AS �����ڵ�
    INTO     #TEMP_�ڱݹ���                 -- DROP TABLE #TEMP_�ڱݹ���
    FROM     DWZOWN.OT_DWA_DD_ACSB_TR       --DWA_�ϰ������񳻿�
    WHERE    STD_DT     = P_��������
    AND      FSC_SNCD  IN ('K', 'C')
    AND     (ACSB_CD4  IN ('13000801'     --��ȭ�����
                          ,'13001108'     --��ȭ����
                          ,'13001308'     --(�����������꽺����)
                          ,'13001408'     --(���ܿ�ȭ����ݰ���)
                          ,'13001601'     --���޺��������ޱ�
                          ,'13001508'     --���Կ�ȯ
                          ,'13001001'     --(���Ծ���(CP����))
                          ,'13001701'     --�ſ�ī��ä��
                          ,'13001901')    --����ä
          OR ACSB_CD2   = '93000101'      --�������Ȯ�����޺���
          OR ACSB_CD   IN ('15011211'     --��Ÿä��(���ż������ޱ�)
                          ,'15011011')    --��Ÿä��(�ſ�ī�尡���ޱ�)
          OR ACSB_CD5   ='14004308'       --��Ÿä��(��ȭ�����ޱ�)
             )
    AND      ACSB_CD  <> '14000711' ;      --���ణ�뿩������




    /************************************************************************
    --�� ����ݾ� �� ������ �ݾ��� ���к��� �ۼ��Ѵ�.
    ************************************************************************/
    SELECT   A.*
            ,B.����
            ,B.������
            ,B.����
            ,B.ȸ���ǹ�
            ,B.�����ս�
    INTO     #TEMP_�⺻����         -- DROP TABLE #TEMP_�⺻����
    FROM    (SELECT   A.STD_DT          AS ��������
                     ,B.����1
                     ,B.����2
                     ,B.����3
                     ,B.�ڱݱ���
                     ,CASE WHEN B.�ڱݱ��� = '����' THEN
                                CASE WHEN A.STD_DT < '20120101'  THEN
                                     CASE WHEN (A.BS_ACSB_CD IN ('15005811','15006211','15006311','16006011','16006111')
                                          AND A.MRT_CD IN ('101','102','103','104','105','170','109','111')) OR
                                              A.BS_ACSB_CD = '14000611'  THEN '���ô㺸'
                                          WHEN  A.MRT_CD < '100' OR A.MRT_CD IN ('601','602') THEN '�ſ�'
                                          ELSE  '��Ÿ'  END
                                     WHEN A.STD_DT >= '20120101'  THEN
                                     CASE WHEN (A.BS_ACSB_CD  IN ('15005811','15006211','15006311','16006011','16006111')
                                          AND A.MRT_CD  IN ('101','102','103','104','105','170','109','420','421','422','423','512','521')) OR
                                              A.BS_ACSB_CD = '14000611'  THEN '���ô㺸'
                                          WHEN  A.MRT_CD < '100' OR A.MRT_CD IN ('601','602') THEN '�ſ�'
                                          ELSE  '��Ÿ'  END
                                     END
                           WHEN B.����3 = '�ſ�ī��'  THEN
                                CASE WHEN A.FRPP_KDCD =  '6' AND F.PREN_DSCD = '1'            THEN '����'
                                     WHEN A.FRPP_KDCD <> '6' AND A.CUST_DSCD IN ('01','07')   THEN '����'
                                     ELSE '���' END
                           WHEN B.�ڱݱ��� = '����'      THEN  '����'
                           WHEN B.����2    = '��Ÿä��'  THEN '0'
                           ELSE CASE WHEN A.CUST_DSCD  NOT IN ('01','07')   AND A.RNNO < '9999999999'
                                      AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014����� 88�� ������� ���Խ�Ų��.
                                     THEN CASE WHEN ISNULL(E.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '����'  ELSE '�߼ұ��'  END
                                     ELSE '�߼ұ��' /*���λ����*/  END
                           END   AS �������
                     ,CASE WHEN ������� = '�߼ұ��'  THEN
                                CASE WHEN A.CUST_DSCD  NOT IN ('01','07')   AND A.RNNO < '9999999999'
                                      AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014����� 88�� ������� ���Խ�Ų��.
                                     THEN '' ELSE '���λ����'  END
                           END          AS ���λ���ڿ���
                     ,A.RNNO            AS �Ǹ��ȣ
                     ,A.INTG_ACNO       AS ���¹�ȣ
                     ,CASE WHEN B.����3 = '�ſ�ī��' AND A.BS_ACSB_CD  NOT IN ('15009111','15009011')  THEN A.AVL_CRD_NO  --�ſ�ī��ä���� ��ȿī���ȣ���(��, ī���(15009111)�� ���հ��¹�ȣ ���)
                            ELSE A.INTG_ACNO     END  AS ���������¹�ȣ
                     ,A.BS_ACSB_CD      AS �����ڵ�
                     ,A.STDD_INDS_CLCD  AS ����з��ڵ�
                     ,SUM(A.LN_RMD)     AS �ܾ�
                     ,SUM(CASE WHEN A.CRCD <> 'KRW'  THEN A.OVD_AMT * C.DLN_STD_EXRT
                                    ELSE A.OVD_AMT
                               END)     AS ��ü�ݾ�
                     ,SUM(CASE WHEN A.PCPL_OVD_MCNT >= 3 THEN
                                    CASE WHEN A.CRCD <> 'KRW'  THEN A.OVD_AMT * C.DLN_STD_EXRT
                                         ELSE A.OVD_AMT END
                               ELSE 0
                               END)     AS �ﰳ����ü�ݾ�
                     ,SUM(CASE WHEN ISDATE(A.FSS_OVD_ST_DT ) = 1  THEN
                                    CASE WHEN A.CRCD <> 'KRW'  THEN A.OVD_AMT * C.DLN_STD_EXRT
                                         ELSE A.OVD_AMT END
                               ELSE 0
                               END)     AS �ݰ�����ü�ݾ�
                     ,D.ARCD            AS �����ڵ�
             FROM     DWZOWN.OT_DWA_INTG_CLN_BC     A       --DWA_���տ��ű⺻
                     ,#TEMP_�ڱݹ���                B
                     ,DWZOWN.OT_DWA_EXRT_BC         C       --DWA_ȯ���⺻
                     ,DWZOWN.OT_DWA_DD_BR_BC        D       --DWA_�����⺻
                     ,DWZOWN.OT_DWA_ENTP_SCL_BC     E       --DWA_����Ը�⺻
                     ,DWZOWN.TB_SOR_CLT_CRD_BC      F       --SOR_CLT_ī��⺻
             WHERE    A.STD_DT       = P_��������
             AND      A.BR_DSCD      = '1'
             AND      A.CLN_ACN_STCD = '1'    --Ȱ��
             AND      A.STD_DT       = B.��������
             AND      A.BS_ACSB_CD   = B.�����ڵ�
             AND      A.STD_DT       = C.STD_DT
             AND      A.CRCD        *= C.CRCD
             AND      C.EXRT_TO      = 1
             AND      A.STD_DT       = D.STD_DT
             AND      A.BRNO         = D.BRNO
             AND      D.BR_DSCD      = '1'
             AND      D.FSC_DSCD     = '1'
             AND      A.STD_DT       = E.STD_DT
             AND      A.RNNO        *= E.RNNO
             AND      A.INTG_ACNO   *= F.CRD_NO
             GROUP BY ��������
                     ,B.����1
                     ,B.����2
                     ,B.����3
                     ,B.�ڱݱ���
                     ,�������
                     ,���λ���ڿ���
                     ,�Ǹ��ȣ
                     ,���¹�ȣ
                     ,���������¹�ȣ
                     ,�����ڵ�
                     ,����з��ڵ�
                     ,�����ڵ�
             ) A
           ,(SELECT   A.STD_DT        AS ��������
                     ,A.BS_ACSB_CD    AS �����ڵ�
                     ,A.INTG_ACNO     AS ���¹�ȣ
                     ,SUM(CASE WHEN A.ACN_SDNS_GDCD = '1' THEN A.ACN_RMD  ELSE 0 END)   AS ����
                     ,SUM(CASE WHEN A.ACN_SDNS_GDCD = '2' THEN A.ACN_RMD  ELSE 0 END)   AS ������
                     ,SUM(CASE WHEN A.ACN_SDNS_GDCD = '3' THEN A.ACN_RMD  ELSE 0 END)   AS ����
                     ,SUM(CASE WHEN A.ACN_SDNS_GDCD = '4' THEN A.ACN_RMD  ELSE 0 END)   AS ȸ���ǹ�
                     ,SUM(CASE WHEN A.ACN_SDNS_GDCD = '5' THEN A.ACN_RMD  ELSE 0 END)   AS �����ս�
             FROM     DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL  A   --SOR_LCF_���������¿����߾�ȸ��
                     ,#TEMP_�ڱݹ���                    B
             WHERE    A.STD_DT       = P_��������
             AND      A.BR_DSCD      = '1'
             AND      A.CLN_ACN_STCD = '1'    --Ȱ��
             AND      A.STD_DT       = B.��������
             AND      A.BS_ACSB_CD   = B.�����ڵ�
             GROUP BY ��������
                     ,�����ڵ�
                     ,���¹�ȣ
             ) B
    WHERE    A.��������        = B.��������
    AND      A.�����ڵ�       *= B.�����ڵ�
    AND      A.���������¹�ȣ *= B.���¹�ȣ;




SELECT      ����1, ����2, ����3, �ڱݱ���,�������, SUM(�ܾ�)
FROM        #TEMP_�⺻����
GROUP BY    ����1, ����2, ����3, �ڱݱ���, �������
ORDER BY    1,2,3,4



//}

//{  #�����ܻ����ŷ����� #�����ܰŷ�
-- �����ܻ����ŷ��������� �����ڵ带 �������� ���
-- ���ŷ��ܿ� ���庯��� ����REF�� �������� �ŷ��� ������� ��ȿ�� �������ڵ带 �������� ���
    ,(
        SELECT  A.REF_NO,A.INTD_RSCD,A.NE_INTD_RSCD
        FROM    DWZOWN.TB_SOR_INX_INTD_RSN_TR_TR    A
        JOIN    (  -- �����ܻ����ڵ尡 ������ �����ŷ������� �����´�
                  SELECT   AA.REF_NO, MAX(AA.RSN_SNO) AS MAX_RSN_SNO
                  FROM     DWZOWN.TB_SOR_INX_INTD_RSN_TR_TR   AA
                  WHERE    AA.FRXC_LDGR_STCD = '1'   -- ����
                  AND      (
                            AA.INTD_RSCD IS NOT NULL  OR
                            AA.NE_INTD_RSCD IS NOT NULL
                           )
                  GROUP BY AA.REF_NO
                 )     B
                 ON    A.REF_NO  = B.REF_NO
                 AND   A.RSN_SNO = B.MAX_RSN_SNO
        WHERE    A.FRXC_LDGR_STCD = '1'   -- ����
     )        D

//}

//{  #���ʽ���ݸ� #����ݸ� #�ϰ��±ݸ����� #���±ݸ�
LEFT OUTER JOIN
            (
             SELECT    A.STD_DT
                      ,A.CLN_ACNO
                      ,A.CLN_EXE_NO
                      ,A.CLN_APL_IRRT_DSCD                --�����������������ڵ�
                      ,A.APL_ADD_IRT                      --���밡��ݸ�
                      ,A.STD_IRT                          --���رݸ�
                      ,A.APL_IRRT                         --��������
                      ,A.ADD_IRT                          --����ݸ�
                      ,A.APL_ST_DT                        --�����������
                      ,A.APL_END_DT                       --������������
                      ,ROW_NUMBER() OVER(PARTITION BY A.CLN_ACNO ORDER BY A.APL_ST_DT ASC,A.CLN_EXE_NO ASC) AS ���ʽ���ݸ�
-- ��������� ������ ���ʱݸ��� �����ȣ 1���̶�� ���������� ������ �����͸� ���� �ٸ� �����ȣ��
-- �ݸ�����������ڰ� ������찡 �־ ���¹�ȣ���� �ݸ�����������ڰ� ����������� ���ؼ� �ش� �ݸ��� �̿��Ѵ�
             FROM      DWZOWN.TB_SOR_LOA_DDY_ACN_IRT_TZ   A
                      ,(
                            SELECT   CLN_ACNO, CLN_EXE_NO , MAX(STD_DT)  AS ����������
                            FROM     DWZOWN.TB_SOR_LOA_DDY_ACN_IRT_TZ
                            WHERE    CLN_APL_IRRT_DSCD = '1'          --�����������������ڵ�(1:��������,9.��ü����)
                            GROUP BY CLN_ACNO, CLN_EXE_NO
                       )   B
                      
             WHERE     1=1
               AND     A.STD_DT            =  B.����������
               AND     A.CLN_ACNO          =  B.CLN_ACNO
               AND     A.CLN_EXE_NO        =  B.CLN_EXE_NO
               AND     A.CLN_APL_IRRT_DSCD = '1'          --�����������������ڵ�(1:��������,9.��ü����)
            )   D
            ON  C.INTG_ACNO   =  D.CLN_ACNO
            AND D.���ʽ���ݸ� = 1
//}

//{  #�����ȣ #�ñ��� #�ּ�
-- �ּҸ� �����ô� �ø� ���� ��/�� ������ ����ϰ� �ϴ� ���
LEFT OUTER JOIN
            (
              SELECT   DISTINCT
                       A.ZIP
                      ,CASE WHEN TRIM(A.MPSD_NM)  IN ('��걤����','����Ư����','�λ걤����','��õ������','���ֱ�����','�뱸������','����������')
                                 THEN TRIM(A.MPSD_NM)
                            ELSE TRIM(A.MPSD_NM) || ' ' || SUBSTR(A.CCG_NM,1,LOCATE(A.CCG_NM,' '))
                       END      AS  ADR_
              FROM
                       TB_SOR_CMI_ZIP_BC   A
              JOIN   (
                        SELECT ZIP,MAX(ZIP_SNO) MAX_ZIP_SNO
                        FROM TB_SOR_CMI_ZIP_BC
                        WHERE 1=1
                        AND   ZIP_SNO <>  '999'
                        AND   LDGR_STCD       = '1'
                        GROUP BY ZIP
                     )      B
              ON     A.ZIP     =  B.ZIP
              AND    A.ZIP_SNO =  B.MAX_ZIP_SNO
              WHERE  A.LDGR_STCD       = '1'
            )    DD
            ON    D.ZIP  = DD.ZIP
//}

//{  #�űԽõ��  #ASS��� #�ű�ASS #�űԽ���
LEFT OUTER JOIN
            (

            SELECT      T.������¹�ȣ       AS   ���¹�ȣ
                       ,E.CSS_MODL_DSCD      AS   CSS���������ڵ�
                       ,TRIM(E.ASS_CRDT_GD)  AS   ASS���
                       ,ROW_NUMBER() OVER(PARTITION BY B.CLN_ACNO ORDER BY B.APC_DT ASC) AS ����
                         -- �Ѱ��°� ��û�����ڵ�(01:�ű�) �� ������ �����°�� ���� ���߿� ���ʲ��� ������

            FROM        #������_������            T
            JOIN        TB_SOR_LOA_ACN_BC          A
                        ON   T.������¹�ȣ  =  A.CLN_ACNO

            JOIN        TB_SOR_PLI_CLN_APC_BC      B  -- SOR_PLI_���Ž�û�⺻
                        ON   A.CLN_ACNO        = B.CLN_ACNO
                        AND  B.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- ���Ž�û�����ڵ�(01:�ű�,02:��ȯ)

            JOIN        TB_SOR_PLI_SYS_JUD_RSLT_TR      E     -- SOR_PLI_�ý��۽ɻ�������
                        ON   B.CLN_APC_NO        = E.CLN_APC_NO
                        AND  B.CUST_NO           = E.CUST_NO

            )           D
            ON       A.������¹�ȣ  = D.���¹�ȣ
            AND      D.����          = 1      -- ������ ��� ���� ���¹�ȣ�� ������ ������ ��� ����

//}

//{  #����ſ��򰡵��  #CRS��� #�űԽõ�� #�űԽ���

--CRS���
UPDATE      #������  A
SET         A.����ſ��򰡵��     = B.����ſ��򰡵��
           ,A.�ſ��򰡸��������ڵ� = B.�ſ��򰡸��������ڵ�
FROM        (
              SELECT      T.���հ��¹�ȣ
                         ,D.LST_ADJ_GD          AS ����ſ��򰡵��
                         ,D.CRDT_EVL_MODL_DSCD  AS �ſ��򰡸��������ڵ�

              FROM        #������   T

              JOIN        TB_SOR_LOA_ACN_BC          A
                          ON   T.���հ��¹�ȣ  =  A.CLN_ACNO

              JOIN        TB_SOR_CLI_CLN_APC_BC      B    -- SOR_CLI_���Ž�û�⺻
                          ON  A.CLN_ACNO        = B.ACN_DCMT_NO
                          AND B.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- ���Ž�û�����ڵ�(01:�ű�,02:��ȯ)
                          AND B.NFFC_UNN_DSCD   = '1'     -- �߾�ȸ
                          AND B.APC_LDGR_STCD   = '10'    -- ��û��������ڵ�(01:�ۼ���,02:������,10:�Ϸ�,99:���)
                          AND B.CLN_APC_CMPL_DSCD IN ('20','21') -- ���Ž�û�Ϸᱸ���ڵ�
                                                                 -- 09:�ΰ�, 10:���� 18:�����Ĺ����, 20:����, 21:����,17:öȸ
              JOIN        TB_SOR_CLI_CLN_APC_RPST_BC C  -- SOR_CLI_���Ž�û��ǥ�⺻
                          ON  B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO

              JOIN        TB_SOR_CCR_EVL_INF_TR      D     -- SOR_CCR_����������
                          ON   C.CRDT_EVL_NO =    D.CRDT_EVL_NO

            )    B
WHERE       A.���հ��¹�ȣ  = B.���հ��¹�ȣ
;

//}

//{  #�㺸��  #�㺸�ڵ��  #�㺸�����ڵ�

-- CASE 1  �㺸�ڵ�, �㺸�ڵ��
SELECT      A.MRT_CD           AS  �㺸�ڵ�
             ,Z1.MRT_CD_NM       AS  �㺸�ڵ��
            ,A.MRT_CD  || '.' ||  TRIM(Z1.MRT_CD_NM)  AS �㺸�ڵ��2

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A  --DWA_���տ��ű⺻

LEFT OUTER JOIN
            DWZOWN.TB_SOR_CLM_MRT_CD_BC  Z1  --CLM_�㺸�ڵ�⺻
            ON    A.MRT_CD = Z1.MRT_CD

-- CASE 2  �㺸�����ڵ�
SELECT      ,A.MRT_CD                     AS  �㺸�ڵ�
           ,F.MRT_TPCD                   AS  �㺸�����ڵ�
FROM        OT_DWA_INTG_CLN_BC   A
LEFT OUTER JOIN
            TB_SOR_CLM_MRT_CD_BC       F             -- (SOR_CLM_�㺸�ڵ�⺻)
            ON     A.MRT_CD    = F.MRT_CD

//-------------------------------------------------------------------
,CASE WHEN   A.�㺸�����ڵ� = '6'  THEN   '1 �ſ�'
      WHEN   A.�㺸�����ڵ� = '5'  THEN   '2 ����'
      ELSE    '3 �㺸'
 END    AS   �㺸����
//-------------------------------------------------------------------


//}

//{  #����  #������  #����
-- CASE 1
SELECT

            CASE WHEN  SUBSTR(A.RNNO,7,1) IN ('0','9') THEN '18'  --1800��� ����,����
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('1','2') THEN '19'  --1900��� ����,����
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('3','4') THEN '20'  --2000��� ����,����
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('5','6') THEN '19'  --1900��� �ܱ��γ���,����
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('7','8') THEN '20'  --2000��� �ܱ��γ���,����
            END  ||    SUBSTR(A.RNNO,1,6)      AS    �������

           ,CASE WHEN  SUBSTR(A.RNNO,7,1) IN ('1','3','5','7','9')   THEN  '1.����'
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('2','4','6','8','0')   THEN  '2.����'
                 ELSE  '3.��Ÿ'
            END                  AS   ��������

           ,CONVERT(INT,LEFT(A.STD_DT,4)) - CONVERT(INT,LEFT(�������,4)) + CASE WHEN CONVERT(INT,RIGHT(�������,4)) > CONVERT(INT,RIGHT(A.STD_DT,4)) THEN -1 ELSE 0 END  AS ������

           ,CASE WHEN A.������ <  20                     THEN '1.20�� �̸�'
                 WHEN A.������ >= 20  AND A.������ < 30  THEN '2.20���̻� ~ 30���̸�'
                 WHEN A.������ >= 30  AND A.������ < 40  THEN '3.30���̻� ~ 40���̸�'
                 WHEN A.������ >= 40  AND A.������ < 50  THEN '4.40���̻� ~ 50���̸�'
                 WHEN A.������ >= 50  AND A.������ < 60  THEN '5.50���̻� ~ 60���̸�'
                 WHEN A.������ >= 60                     THEN '6.60�� �̻�'
                 END  AS ���̱���

//}

//{  #����ڱݽűԱ��ظ����� #����ڱ� #����ڱݸ����� #�űԿ���

SELECT      A.STD_DT              AS   ��������
           ,A.INTG_ACNO           AS   ���հ��¹�ȣ
           ,A.CUST_NO             AS   ����ȣ

           ,CASE WHEN C.ACSB_CD5 = '14002401' THEN --���
             CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999'
                    AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014����� 88�� ������� ���Խ�Ų��.
                  THEN CASE WHEN ISNULL(D.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.����'  ELSE '2.�߼ұ��'  END
             ELSE '3.���λ����'
             END
            END                               AS �������

           ,CASE WHEN LEFT(CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN FST_LN_DT ELSE AGR_DT END,6) = LEFT(A.STD_DT,6)
                   THEN  1
                   ELSE  0
            END                                 AS ����űԿ���
           ,CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN LN_EXE_AMT ELSE AGR_AMT END  AS �űԴ��ݾ�

           ,A.LN_RMD              AS  �����ܾ�

INTO        #TEMP_�ű�  -- DROP TABLE #TEMP_�ű�

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A       --DWA_���տ��ű⺻

JOIN        (
                SELECT   STD_DT
                        ,ACSB_CD
                        ,ACSB_NM
                        ,ACSB_CD4  --��ȭ�����
                        ,ACSB_NM4
                        ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                        ,ACSB_NM5
                FROM     OT_DWA_DD_ACSB_TR
                WHERE    FSC_SNCD IN ('K','C')
--              AND      ACSB_CD4 = '13000801'        --��ȭ�����
                AND      ACSB_CD5 IN ('14002401')     --����ڱݴ����
            )           C
            ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS���������ڵ�
            AND      A.STD_DT       =   C.STD_DT

LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_����Ը�⺻
            ON     A.RNNO      = D.RNNO
            AND    A.STD_DT    = D.STD_DT

JOIN        OM_DWA_INTG_CUST_BC          T     -- DWA_���հ��⺻
            ON     A.CUST_NO    =  T.CUST_NO

JOIN        OT_DWA_DD_BR_BC               F       --DWA_�����⺻
            ON         A.BRNO    =   F.BRNO
            AND        A.STD_DT  =   F.STD_DT

WHERE       1=1
AND         A.STD_DT   IN  (
                              SELECT   MAX(STD_DT)  AS ��������
                              FROM     DWZOWN.OT_DWA_INTG_CLN_BC A
                              WHERE    1=1
                              AND      STD_DT BETWEEN '20130101'  AND  '20141231'
                              GROUP BY LEFT(STD_DT,6)
                           )
AND         A.CLN_ACN_STCD <>  '3'                     -- ��Ұ�����
AND         A.BR_DSCD  =  '1'                          -- �߾�ȸ
AND         ����űԿ��� =  1
;
//}

//{  #�űԽ��� #�ſ��� #CRS��� #ASS���

-- �űԽ��� �ſ���


-- CRS���
SELECT      T.����
           ,A.CLN_ACNO
           ,E.LST_ADJ_GD   AS   CRDT_CD

INTO        #�űԽſ��� --  DROP TABLE #�űԽſ���

FROM        #������                  T
JOIN        TB_SOR_LOA_ACN_BC          A
            ON   T.���¹�ȣ  =  A.CLN_ACNO

JOIN        TB_SOR_CLI_CLN_APC_BC      B  -- SOR_CLI_���Ž�û�⺻
            ON   A.CLN_ACNO        = B.ACN_DCMT_NO
            AND  B.CLN_APC_DSCD    = '01'    -- ���Ž�û�����ڵ�(01:�ű�)

JOIN        TB_SOR_CLI_CLN_APC_RPST_BC C  -- SOR_CLI_���Ž�û��ǥ�⺻
            ON   B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO

JOIN        TB_SOR_CCR_EVL_BZNS_OTL_TR D  -- SOR_CCR_�򰡾�ü���䳻��
            ON   C.CRDT_EVL_NO     = D.CRDT_EVL_NO

JOIN        TB_SOR_CCR_EVL_INF_TR      E     -- SOR_CCR_����������
            ON   C.CRDT_EVL_NO =    E.CRDT_EVL_NO

UNION  ALL

-- ASS ���
SELECT      T.����
           ,A.CLN_ACNO
           ,TRIM(E.ASS_CRDT_GD) AS  CRDT_GD

FROM        #������                  T
JOIN        TB_SOR_LOA_ACN_BC          A
            ON   T.���¹�ȣ  =  A.CLN_ACNO

JOIN        TB_SOR_PLI_CLN_APC_BC      B  -- SOR_PLI_���Ž�û�⺻
            ON   A.CLN_ACNO        = B.CLN_ACNO
            AND  B.CLN_APC_DSCD    = '01'    -- ���Ž�û�����ڵ�(01:�ű�)

JOIN        TB_SOR_PLI_SYS_JUD_RSLT_TR      E     -- SOR_PLI_�ý��۽ɻ�������
            ON   B.CLN_APC_NO        = E.CLN_APC_NO
            AND  B.CUST_NO           = E.CUST_NO
;

//}

//{  #���������泻�� #������ #�ڻ������

SELECT  INTG_ACNO ���¹�ȣ,
b.ACN_SDNS_GDCD ���°���������ڵ� ,
b. APMN_NDS_RSVG_AMT ���ݿ䱸�����ݾ� ,
a.ACN_SDNS_GDCD �����İ��°���������ڵ� ,
a. APMN_NDS_RSVG_AMT ���������ݿ䱸�����ݾ�

FROM   TB_sor_LCF_SDNS_ACN_MN_DL a , TB_sor_LCF_SDNS_ACN_DN_DL b
WHERE a.STD_DT ='20150731'
and   b.STD_DD = substr(a.STD_DT,7,2)
and   a.STD_DT  =b.STD_DT
and   a.BRNO =b.BRNO
and   a.BS_ACSB_CD= b.BS_ACSB_CD
and   a.INTG_ACNO =b.INTG_ACNO
and   a.CLN_EXE_NO =b.CLN_EXE_NO
and   a.FRXC_TSK_DSCD =b.FRXC_TSK_DSCD
and   a.MRT_NO = b.MRT_NO
and   a.STUP_NO =b.STUP_NO
and   a.NUS_LMT_DSCD =b.NUS_LMT_DSCD
and   a.SDNS_EPRC_CD ='3'   -- ����������ó���ڵ�

//}

//{  #���ּ� #�������ּ�  #������

-- ���� �ּҸ� ��������...������ּҴ� �������� �ּҸ� �켱�ϵ��� ó��
SELECT      T.���¹�ȣ

           ,B.OOH_ZADR    ���ÿ����ȣ�ּ�
           ,B.OOH_BZADR   ���ÿ����ȣ���ּ�

           ,B.WKPL_ZADR   ��������ȣ�ּ�
           ,B.WKPL_BZADR  ��������ȣ���ּ�

           ,B.BZPL_ZADR   ���������ȣ�ּ�
           ,B.BZPL_BZADR  ���������ȣ���ּ�

INTO        #���ּ�  -- DROP TABLE #���ּ�

FROM        #TEMP                  T

JOIN        TB_SOR_LOA_ACN_BC          A
            ON   T.���¹�ȣ  =  A.CLN_ACNO

JOIN        OM_DWA_INTG_CUST_BC  B  --DWA_���հ��⺻
            ON   A.CUST_NO = B.CUST_NO
;

-- �������� �ִ� ���ü �ּҸ� �켱����
UPDATE      #���ּ�   A

SET         A.���������ȣ�ּ�     =  B.���������ȣ�ּ�
           ,A.���������ȣ���ּ�   =  B.���������ȣ���ּ�

FROM        (
               SELECT      A.CLN_ACNO               AS  ���¹�ȣ
                          ,CC.ADR_                  AS  ���������ȣ�ּ�
                          ,TRIM(D.HDFC_DTL_ADR)     AS  ���������ȣ���ּ�

               FROM        #TEMP                      T
               JOIN        TB_SOR_LOA_ACN_BC          A
                           ON   T.���¹�ȣ  =  A.CLN_ACNO

               JOIN        TB_SOR_CLI_CLN_APC_BC      B  -- SOR_CLI_���Ž�û�⺻
                           ON   A.CLN_ACNO        = B.ACN_DCMT_NO
                           AND  B.CLN_APC_DSCD    = '01'    -- ���Ž�û�����ڵ�(01:�ű�)

               JOIN        TB_SOR_CLI_CLN_APC_RPST_BC C  -- SOR_CLI_���Ž�û��ǥ�⺻
                           ON   B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO

               JOIN        TB_SOR_CCR_EVL_BZNS_OTL_TR D  -- SOR_CCR_�򰡾�ü���䳻��
                           ON   C.CRDT_EVL_NO     = D.CRDT_EVL_NO

               LEFT OUTER JOIN   -- ��ü������ ������
                           (
                             SELECT   DISTINCT
                                      A.ZIP
                                     ,TRIM(A.MPSD_NM) || ' ' || TRIM(A.CCG_NM) || ' ' ||
                                      TRIM(A.EMD_NM)  || ' ' || TRIM(A.LINM)   AS  ADR_
                             FROM
                                      TB_SOR_CMI_ZIP_BC   A
                             JOIN   (
                                       SELECT ZIP,MAX(ZIP_SNO) MAX_ZIP_SNO
                                       FROM TB_SOR_CMI_ZIP_BC
                                       WHERE 1=1
                                       AND   ZIP_SNO <>  '999'
                                       AND   LDGR_STCD       = '1'
                                       GROUP BY ZIP
                                    )      B
                             ON     A.ZIP     =  B.ZIP
                             AND    A.ZIP_SNO =  B.MAX_ZIP_SNO
                             WHERE  A.LDGR_STCD       = '1'
                           )    CC
                           ON    D.HDFC_ZIP  = CC.ZIP
            )        B

WHERE       1=1
AND         A.���¹�ȣ  = B.���¹�ȣ
--  ORDER BY 1
;


//}

//{  #CB��� #�űԽ��� #���ҵ� #�ý��۽ɻ�

-- CASE1 : �űԽ��� ���� CB��ް� ���ҵ�
           ,TRIM(E.CB_CRDT_GD) AS  CB���
           ,F.FRYR_ICM_AMT     AS  ���ҵ�
           ,CASE WHEN TRIM(E.CB_CRDT_GD) IN ('007','008','009','010')  THEN  'O' ELSE 'X' END AS ���ſ뿩��
           ,CASE WHEN F.FRYR_ICM_AMT <= 20000                          THEN  'O' ELSE 'X' END AS ���ҵ濩��

INTO        #TEMP      -- DROP TABLE #TEMP

FROM        #������   T

JOIN        TB_SOR_LOA_ACN_BC          A
            ON   T.INTG_ACNO  =  A.CLN_ACNO

JOIN        TB_SOR_PLI_CLN_APC_BC      B  -- SOR_PLI_���Ž�û�⺻
            ON   A.CLN_ACNO        = B.CLN_ACNO
            AND  B.CLN_APC_DSCD    = '01'    -- ���Ž�û�����ڵ�(01:�ű�)

JOIN        TB_SOR_PLI_SYS_JUD_RSLT_TR      E     -- SOR_PLI_�ý��۽ɻ�������
            ON   B.CLN_APC_NO        = E.CLN_APC_NO
            AND  B.CUST_NO           = E.CUST_NO

JOIN        TB_SOR_PLI_APC_POT_CUST_TR      F     --SOR_PLI_��û����������
            ON   B.CLN_APC_NO        = F.CLN_APC_NO
            AND  B.CUST_NO           = F.CUST_NO


-- CASE2 : �������� ������ db���  (���տ��Ź��)
           --���º��� ���ؽ������� ��������� �����´�. ���º��̹Ƿ� �����δ� �ٸ��� �ִ�
           --���ϰ��̸� �Ѱ��� ��ް��� ���ϸ� OT_ECRT���Ű����� ���̺��� �̿��ؾ� �Ѵ�.
           ,(-- ũ������νſ��� SET : ���¹�ȣ�� MAX(���Ž�û��ȣ) ���� ���Ž�û��ȣ ������ SET, 20120813 : RANK()�� ����
             -- ���Ű��¹�ȣ, ���Ž��ι�ȣ, ���Ž�û��ȣ, ����ȣ, ũ������νſ���
             SELECT   TA.CLN_ACNO, TA.CLN_APRV_NO, TA.CLN_APC_NO, TA.CUST_NO, TB.CB_CRDT_GD --ũ������νſ���
             FROM     (--SOR_PLI_���Ž�û�⺻ �� ���¹�ȣ�� MAX(CLN_APC_NO)
                       SELECT   TA.*   --���Ű��¹�ȣ, ���Ž��ι�ȣ, ���Ž�û��ȣ MAX, ����ȣ
                       FROM     (SELECT  CLN_ACNO, CLN_APRV_NO, CLN_APC_NO, CUST_NO
                                        ,RANK() OVER (PARTITION BY CLN_ACNO ORDER BY CLN_APC_NO DESC) AS SEQ
                                 FROM    DWZOWN.TB_SOR_PLI_CLN_APC_BC  --SOR_PLI_���Ž�û�⺻
                                 WHERE   CLN_ACNO  IS NOT NULL) TA
                       WHERE    TA.SEQ = 1)             TA   --SOR_PLI_���Ž�û�⺻
                     ,DWZOWN.TB_SOR_PLI_SYS_JUD_RSLT_TR TB   --SOR_PLI_�ý��۽ɻ�������
             WHERE    TA.CLN_APC_NO   = TB.CLN_APC_NO
             AND      TA.CUST_NO      = TB.CUST_NO
            )                                          T23  --SOR_PLI_�ý��۽ɻ�������


   /*--------------------------------------------------------------------------------*/
   /* 20120828 : CB(ũ������νſ��� UPDATE ó��(20120828�����Ϻ��� ����)          */
   /* T23.CB_CRDT_GD AS ũ������νſ���(SOR_PLI_�ý��۽ɻ�������.ũ������νſ���) */
   /* �����ҽ����� SOR_PLI_�ý��۽ɻ��������� CB����� SET : ���λ���� ��� ����  */
   /* SOR_PLI_���Ž�û�⺻�� ���´���, SOR_PLI_�ý��۽ɻ��������� ����ȣ����     */
   /* TB_SOR_PLI_EOM_CB_SCR_TR(SOR_PLI_����ũ���������������) ���λ���� ��� ����  */
   /* ��, ���� ���ظ� �����Ƿ� ���� ������ UPDATE �Ѵ�                               */
   /* SOR_PLI_����ũ��������������� �� �Ǹ��ȣ������. �������� ����                */
   /* 20121019 : 05,06�ҽ� �ſ�ī��� �ſ�ī���� CB����� ��� �ϴµ�(DWF_CSM_���ο�BSS����⺻.CB���(�ѱ��ſ������ſ���)) */
   /* 20120828 ~ 20121018���ڱ��� SOR_PLI_����ũ��������������� �� CB������� UPDATE �Ǿ���(���ֽǸ��ȣ=ī��Ǹ��ȣ �� ���*/
   /* �ſ�ī�带 ������ ���ֿ� ���ؼ� ����ǵ��� ����                                */
   /*--------------------------------------------------------------------------------*/
   UPDATE   OT_DWA_INTG_CLN_BC T1                               --DWA_���տ��ű⺻
   SET      T1.CB_CRDT_GD      = T2.CRDT_GD
   FROM     TB_SOR_PLI_EOM_CB_SCR_TR  T2  --SOR_PLI_����ũ���������������
   WHERE    T1.STD_DT          = v_�۾���������
   AND      T1.CB_CRDT_GD      IS NULL       --���λ���ڵ� SOR_PLI_�ý��۽ɻ������� ���� ���� ������ SET
   AND      T1.RNNO            = T2.RNNO
   AND      T2.STD_DT          = (SELECT MAX(STD_DT) FROM TB_SOR_PLI_EOM_CB_SCR_TR WHERE STD_DT <= v_�۾���������)
   AND      T2.CRDT_GD         <> '000'
   AND      T1.CLN_TSK_DSCD NOT IN ('30','50','17','18')
   --17,18����ī��� �ſ������� ��� NULL�̹Ƿ� UPDATE ���� �ʵ��� �Ѵ�.
   --���ֽǸ��ȣ=ī��Ǹ��ȣ �� ��� �ѽ�������� �����ؼ� ������ ���� �� ����.
   ;

-- CASE 3 ���տ����� CB����� ���º��̹Ƿ� ���ϰ��� ���������� ����� ���ü� �ִ�.
UPDATE      #�����ڱ�1  T1
SET         T1.CB���      =  CONVERT(INT,ISNULL(T2.ũ������νſ���,'0'))
FROM        OT_ECRT���Ű�����      T2
WHERE       LEFT(T1.��������,6)  = T2.���س��
AND         T1.����ȣ          = T2.����ȣ
AND         T2.�������ڵ�        = '1'


CB���(ũ������ε��)

-- ������� ��������
���� ���ؽ��� CB����� ���������� TB_DWF_CSM_AIO_BSS_RSLT_BC(DWF_CSM_���ο�BSS����⺻) �� CB����� ��������
(CASE 3�� ���� ��������) ������� TB_SOR_PLI_SYS_JUD_RSLT_TR(SOR_PLI_�ý��۽ɻ�������) �� ������ ������
�����ϴ� ������ �Ǿ�� �ϰڴ�.
DWF_CSM_���ο�BSS����⺻ ���̺��� DAD_���νſ��޳����� ���鶧 �����ϴ� ���̺�� �ش絥���ʹ� TB_ECRT���νſ���,
OT_ECRT���Ű����� ������ ���� ���ǰ� �ִ�.

-- ���º���� ��������
���տ����� �⺻������ ���º��� ������û�ǿ� �پ��ִ� CB����� ������ �����Ƿ� ���տ����� ����ϸ�ȴ�.
���տ����� ���μҽ��� ���� TB_SOR_PLI_SYS_JUD_RSLT_TR(SOR_PLI_�ý��۽ɻ�������) ���� �����͸� ��������
SOR_PLI_����ũ��������������� �����ͷ� �����͸� �����ϴ� �������� �Ǿ� �ִ�.

-- �������̺�

-- ���º� (�Ʒ� ���̺� �ִ� cb����� �¶��ο��� �߻�, ������(�ڰ���))
TB_SOR_PLI_SYS_JUD_RSLT_TR TB   --SOR_PLI_�ý��۽ɻ�������
TB_SOR_PLI_AIO_ASS_APC_BC --SOR_PLI_���ο�����ASS��û�⺻
TB_SOR_PLI_AIO_ASS_ASSC_TR  --SOR_PLI_���ο�����ASS��������

-- ����
TB_SOR_PLI_EOM_CB_SCR_TR    --SOR_PLI_����ũ���������������, bss���� ���� ���ؼ� ���� CB����� ���س��� �� (������������ ����, ���信 ������ �����Ŀ��� ����)

-- ���ο��� ���� ���̺��� 201208 ~ 201710 ������ ������ �����Ƿ� 201710���Ĵ� �����̺�(CLT_�ҸŸ���BSS����⺻ ) �� ����ؾ��ϸ�
-- 201208������ �� �ٸ����̺��� �����ؾ� �Ѵ�

//}

//{  #��ü�ϼ�

-- 20140801 ������ ���ڿ�ü�� �ɷ��־ ��ü�ϼ��� 20140801���ĺ��� �����
-- �������� ������߿� �Ѱ��̶� ���ڿ�ü�� �ɷ������� �׳��� ��ü�ϼ��� ����
SELECT      A.INTG_ACNO                  AS   ���հ��¹�ȣ
           ,A.CUST_NO                    AS   ����ȣ
           ,A.CUST_NM                    AS   ����
           ,A.BSS_CRDT_GD                AS   BSS���
           ,COUNT(DISTINCT B.STD_DT)     AS   ��ü�ϼ�

FROM        #������    A

JOIN        DWZOWN.OT_DWA_INTG_CLN_BC   B   --DWA_���տ��ű⺻
            ON   A.INTG_ACNO  = B.INTG_ACNO
            AND  B.STD_DT   BETWEEN '20140801'  AND  '20150731'
            AND  B.INT_OVD_ST_DT IS NOT NULL

WHERE       1=1
GROUP BY    A.INTG_ACNO
           ,A.CUST_NO
           ,A.CUST_NM
           ,A.BSS_CRDT_GD
;

//}

//{  #���������� #������� #����

-- �̿ϼ� ����..
-- ���뿬������� �ſ��� ���ϱ�
-- �� �۾��� ������� ���������� �űԽ�û(���Ž�û�����ڵ� 01~09)�ǵ� ã���� ���°ǵ��� ����
-- ������ ��� �����Ͻ����� �ֱٿ���� ����� �ʿ��ϴٴ� ��û�� ���� �Ʒ� ������ �̿��ؼ�
-- ����� update  �� �ʿ䰡 �־ ��������� �̹� �ڷῡ�� �������� �ʾҴ�
SELECT      T.��������
           ,T.���հ��¹�ȣ
           ,B.CLN_APC_DSCD  AS  ���Ž�û�����ڵ�
           ,B.AGR_EXPI_DT   AS  ������������
           ,B.ENR_DT        AS  �������
           ,C.CLN_APRV_NO   AS  ���Ž��ι�ȣ
           ,E.ASS_CRDT_GD

--INTO        #TEMP         -- DROP TABLE #TEMP
FROM        #������   T

JOIN        (
                SELECT  A.CLN_ACNO
                       ,A.AGR_TR_SNO
                       ,A.CLN_APC_DSCD
                       ,A.AGR_EXPI_DT
                       ,A.ENR_DT
                       ,A.CLN_APRV_NO
                FROM    TB_SOR_LOA_AGR_HT   A
                JOIN    (
                          SELECT CLN_ACNO
                                ,AGR_TR_SNO
                                ,ROW_NUMBER() OVER(PARTITION BY  CLN_ACNO  ORDER BY AGR_EXPI_DT ASC) AS SEQ
                          FROM   TB_SOR_LOA_AGR_HT   A
                          WHERE  1=1
                          AND    A.CLN_ACNO IN ( SELECT  ���հ��¹�ȣ
                                                 FROM    #������
                                                 WHERE   �������� = '20150731'
                                                 AND     ��ǥ�����ڵ� = '4'
                                               )
                          AND    A.CLN_APC_DSCD    IN ('11','12','13')    -- ���Ž�û�����ڵ�(11~ 13 ����)
                          AND    A.TR_STCD          = '1'
                          AND    A.AGR_EXPI_DT  > '20150731'
                       )  B
                       ON  A.CLN_ACNO     = B.CLN_ACNO
                       AND A.AGR_TR_SNO   = B.AGR_TR_SNO
                       AND B.SEQ          = 1
            )   B
            ON   T.���հ��¹�ȣ = B.CLN_ACNO

JOIN        TB_SOR_CLI_CLN_APRV_BC   C --SOR_CLI_���Ž��α⺻
            ON  B.CLN_APRV_NO   =  C.CLN_APRV_NO

JOIN        TB_SOR_PLI_SYS_JUD_RSLT_TR      E     -- SOR_PLI_�ý��۽ɻ�������
            ON   C.CLN_APC_NO        = E.CLN_APC_NO
            AND  C.CUST_NO           = E.CUST_NO


WHERE       1=1
AND         T.�������� = '20150731'

//}

//{  #����  #ä���⺻

SELECT      A.TCB��
           ,CASE WHEN B.SNO  = 1  THEN
                 CASE WHEN A.����ſ���  IN ('A','A+','A-')  THEN 'A'
                      WHEN A.����ſ���  IN ('AA','AA+','AA-')  THEN 'AA'
                      WHEN A.����ſ���  IN ('AAA','AAA+','AAA-')  THEN 'AAA'
                      WHEN A.����ſ���  IN ('B','B+','B-')  THEN 'B'
                      WHEN A.����ſ���  IN ('BB','BB+','BB-')  THEN 'BB'
                      WHEN A.����ſ���  IN ('BBB','BBB+','BBB-')  THEN 'BBB'
                      WHEN A.����ſ���  IN ('C','C+','C-')  THEN 'C'
                      WHEN A.����ſ���  IN ('CC','CC+','CC-')  THEN 'CC'
                      WHEN A.����ſ���  IN ('CCC','CCC+','CCC-')  THEN 'CCC'
                      WHEN A.����ſ���  IN ('D','D+','D-')  THEN 'D'
                      WHEN A.����ſ���  IN ('DD','DD+','DD-')  THEN 'DD'
                      WHEN A.����ſ���  IN ('DDD','DDD+','DDD-')  THEN 'DDD'
                      ELSE 'KKK'
                 END
                 ELSE 'Z.�Ұ�'
            END                  AS ����ſ���

           ,COUNT(CASE WHEN ��ǰ���� = '�⺸'       THEN   ���հ��¹�ȣ ELSE NULL END)  AS �⺸_�Ǽ�
           ,SUM  (CASE WHEN ��ǰ���� = '�⺸'       THEN   �����ܾ�     ELSE NULL END)  AS �⺸_�ܾ�

           ,COUNT(CASE WHEN ��ǰ���� = '�·�������' THEN   ���հ��¹�ȣ ELSE NULL END)  AS �·���_�Ǽ�
           ,SUM  (CASE WHEN ��ǰ���� = '�·�������' THEN   �����ܾ�     ELSE NULL END)  AS �·���_�ܾ�

           ,COUNT(CASE WHEN ��ǰ���� = '�ź�' THEN   ���հ��¹�ȣ ELSE NULL END)        AS �ź�_�Ǽ�
           ,SUM  (CASE WHEN ��ǰ���� = '�ź�' THEN   �����ܾ�     ELSE NULL END)        AS �ź�_�ܾ�

           ,COUNT(CASE WHEN ��ǰ���� = '�Ϲ�' THEN   ���հ��¹�ȣ ELSE NULL END)        AS �Ϲ�_�Ǽ�
           ,SUM  (CASE WHEN ��ǰ���� = '�Ϲ�' THEN   �����ܾ�     ELSE NULL END)        AS �Ϲ�_�ܾ�

FROM        #������   A
CROSS JOIN  (
             SELECT   SNO  FROM  OM_DWA_GVNO_BC  WHERE SNO BETWEEN 1 AND 2
            )    B         -- DWA_ä���⺻

WHERE       1=1
AND         A.�������� =  '20150731'
GROUP BY    A.TCB��
           ,����ſ��

//}

//{  #��޽����ݸ�  #�ݸ� #�űԽ����ݸ�


-- ��޽����ݸ� �Ϲݿ��ŵ�
UPDATE      #������   A
SET         ��޽����ݸ�  =  B.��������

FROM        (
              SELECT      A.��������
                         ,A.���հ��¹�ȣ
                         ,A.���Ž����ȣ
                         ,ISNULL(B.APL_IRRT,0)  AS ��������

              FROM        #������     A

              JOIN        OM_DWA_DT_BC  T     --  DWA_���ڱ⺻
                          ON   A.���ʴ������� =  T.STD_DT

              JOIN        OT_DWA_INTG_CLN_BC  B     -- DWA_���տ��ű⺻
                          ON   A.���հ��¹�ȣ   = B.INTG_ACNO
                          AND  A.���Ž����ȣ   = B.CLN_EXE_NO
                          AND  T.EOTM_DT        = B.STD_DT
                      --- '330000615843' �����Ѱ� ������..

            )    B

WHERE       1=1
AND         A.��������      = B.��������
AND         A.���հ��¹�ȣ  = B.���հ��¹�ȣ
AND         A.���Ž����ȣ  = B.���Ž����ȣ
;

-- ��޽����ݸ� ����
UPDATE      #������   A
SET         ��޽����ݸ�  =  B.��������

FROM        (
              SELECT      A.��������
                         ,A.���հ��¹�ȣ
                         ,A.���Ž����ȣ
                         ,ISNULL(B.APL_IRRT,0)  AS ��������

              FROM        #������     A

              JOIN        OM_DWA_DT_BC  T     --  DWA_���ڱ⺻
                          ON   A.�������� =  T.STD_DT

              JOIN        OT_DWA_INTG_CLN_BC  B     -- DWA_���տ��ű⺻
                          ON   A.���հ��¹�ȣ   = B.INTG_ACNO
                          AND  T.EOTM_DT        = B.STD_DT
                      --- '330000615843' �����Ѱ� ������..

              WHERE       A.��ǥ�����ڵ� = '4'       -- ������ ���

            )    B

WHERE       1=1
AND         A.��������      = B.��������
AND         A.���հ��¹�ȣ  = B.���հ��¹�ȣ
AND         A.��ǥ�����ڵ� = '4'       -- ������ ���
;


//}

//{  #TCB   #TCB������

-- ���ν��� UP_DWZ_����_N0255_TCB������Ȳ ���� ������ ������ �ٸ�����
-- ���ν��������� ���տ��Ű� EQUAL ������ �ϰ� �Ǿ� �����Ƿ�
-- ���س�¥�� ���տ��ſ� ���°���(�������� 1���� �������� �Ǵ� �������� ���Ŀ� �űԹ߻��� ����)
-- �� ��¾ȵ�
--
-- ��� ��������� ��ü tcb������ "2. ���¿��忡�� ������ ������" ���� �����(������ �Ǵ� ������)
-- �� ���ؽ��� �����ΰ͸� ������� �ϴ� ���� ����
--
-- 1.���ν��������� ����ϰ� �ִ� ������  *��Ұǿ� ���� ���ǹ��� ��� 2. ���� ���� �����ܰ� ���̰� ���� ������ ������..
--              SELECT
--                     A.*, B.TCH_EVL_ISN_NO,B.TCH_EVL_TCH_CRDT_GD
--                    ,J.BR_NM
--                    ,C.TCH_EVL_EVSH_DSCD      AS ������򰡼������ڵ�
--                    ,C.TCH_EVL_EVSH_ISN_DT    AS ������򰡼��߱�����
--                    ,C.TCH_EVL_EVL_RQST_DT    AS ��������Ƿ�����
--                    ,C.TCH_EVL_GD_AVL_DT      AS ����򰡵����ȿ����
--                    ,C.TCH_EVL_TCH_CRDT_GD    AS ����򰡱���ſ���
--                    ,C.TCH_EVL_TCH_GD         AS ����򰡱�����
--                    ,C.TCH_EVL_CRDT_GD        AS ����򰡽ſ���
--              FROM   OT_DWA_INTG_CLN_BC      A
--                    ,TB_SOR_LOA_ACN_BSC_DL   B  --LOA_���±⺻��
--                    ,TB_SOR_CLI_TCH_EVL_RSLT_BC  C   -- SOR_CLI_����򰡰���⺻
--                    ,TB_SOR_CMI_BR_BC         J  -- �����⺻
--              WHERE  A.STD_DT  = '20150831'
--              AND    A.BR_DSCD = '1'
--              AND    A.INTG_ACNO = B.CLN_ACNO
--              AND    A.BRNO      = J.BRNO
--              //===============================================================
--              AND    B.TCH_EVL_ISN_NO <> ''           -- ����򰡹߱޹�ȣ�� �ִ°�
--              //===============================================================
--              AND    B.TCH_EVL_ISN_NO  *= C.TCH_EVL_ISN_NO
--              AND    CASE WHEN A.FST_LN_DT IS NOT NULL AND A.FST_LN_DT > '19000000'  THEN A.FST_LN_DT ELSE A.AGR_DT END  > '20140701'
--                      -- TCB������ 2014.07.01 ������ �űԵȰ��´� ����
--                      -- (���Ŀ� �����ϸ鼭 TCB�� �̿��� ���̽� �̹Ƿ� ��κ��� �������� �����ϰ� ������ ����)



--  1  �ð迭���忡�� ������ TCB����
--  CASE2�� CURRENT������ �̿��ϸ� �űԽ������� TCB������ �ƴϴٰ� ������ϸ鼭 TCB�򰡼���ȣ�� ���� ��찡 �־
--          �ش�������� �ڷḦ �����ϴ°ͺ��� ũ�� ���´�..
SELECT      A.STD_YM                          AS  ���س��
           ,A.CUST_NO                         AS  ����ȣ
           ,T.CUST_NM                         AS  ����
           ,A.CLN_ACNO                        AS  ���հ��¹�ȣ
           ,T4.STDD_INDS_CLCD                 AS  �����ڵ�
           ,T4.��з���                       AS  ������
           ,T4.ESTB_DT                        AS  ��������

           ,ISNULL(C.CLN_EXE_NO,0)            AS  ���Ž����ȣ
           ,A.CLN_TSK_DSCD                    AS  ���ž��������ڵ� --(20:����)
           ,A.AGR_DT                          AS  ��������
           ,A.AGR_EXPI_DT                     AS  ������������
           ,A.AGR_AMT                         AS  �����ݾ�
           ,A.CLN_ACN_STCD                    AS  ���Ű��»����ڵ�
           ,A.ACN_ADM_BRNO                    AS  ���°�������ȣ
           ,CASE WHEN SUBSTR(A.PDCD, 6, 4) ='5025'  AND A.LN_SBCD IN ('369','370')  THEN '�·�������'  --�·����� ������å�� �ڷ����� �������
                 WHEN A.MNMG_MRT_CD IN ('504', '505') THEN '�⺸'
                 WHEN A.MNMG_MRT_CD IN ('501', '502', '503', '517', '535') THEN '�ź�'
                 ELSE '�Ϲ�'
            END                               AS  ��ǰ����

           ,A.MNMG_MRT_CD                     AS  �㺸�ڵ�
           ,C.BS_ACSB_CD                      AS  BS���������ڵ�
           ,C.CLN_ACN_STCD                    AS  ���Ž�������ڵ�
           ,C.LN_DT                           AS  ��������
           ,C.EXPI_DT                         AS  ��������
           ,C.CRCD                            AS  ��ȭ�ڵ�
           ,C.LN_EXE_AMT                      AS  �������ݾ�
           ,C.LN_RMD                          AS  �����ܾ�
           ,SUBSTR(B.TCH_EVL_ISN_NO,1,3)      AS  TCB��
           ,D.TCH_EVL_EVSH_ISN_DT             AS  ������򰡼��߱�����
           ,D.TCH_EVL_TCH_GD                  AS  ������

INTO        #TEMP        -- DROP TABLE #TEMP

FROM        TT_SOR_LOA_MM_ACN_BC        A     -- SOR_LOA_�����±⺻

JOIN        TT_SOR_LOA_MM_ACN_BSC_DL    B     -- SOR_LOA_�����±⺻��
            ON   A.CLN_ACNO   = B.CLN_ACNO
            AND  A.STD_YM     = B.STD_YM
            AND  B.TCH_EVL_ISN_NO  <>  ''   -- ����򰡹߱޹�ȣ

LEFT OUTER JOIN
            TT_SOR_LOA_MM_EXE_BC     C     -- SOR_LOA_������⺻
            ON   A.CLN_ACNO  =  C.CLN_ACNO
            AND  A.STD_YM    =  C.STD_YM
            AND  C.CLN_ACN_STCD <> '3'        --�������

JOIN        TB_SOR_CLI_TCH_EVL_RSLT_BC  D   -- SOR_CLI_����򰡰���⺻
            ON   B.TCH_EVL_ISN_NO  = D.TCH_EVL_ISN_NO

JOIN        DWZOWN.OM_DWA_INTG_CUST_BC   T   -- DWA_���հ��⺻
            ON   A.CUST_NO   =  T.CUST_NO

JOIN        #TEMP_�����ڵ�        T4
            ON   A.CUST_NO    = T4.CUST_NO

WHERE       A.STD_YM   IN  ('201406','201412','201506','201512','201606','201612','201706','201708')
AND         A.NFFC_UNN_DSCD  =  '1'    -- �߾�ȸ���ձ����ڵ� 1:�߾�ȸ
AND         A.CLN_ACN_STCD    <> '3'   -- ��Ұ�������
AND         A.AGR_DT >= '20140701'         -- ������
            -- �ű�(�����̳� ����) �̿ܿ� �Ⱓ����� tcb �򰡼��� ����� ��찡 �ִµ� �̷� ���´� ������� 20140701 �����ϼ� �ۿ�����
            -- �������� �̷����´� �������ÿ��� �����Ѵٰ� �ϴ� �ɷ����� �۾��Ѵ�.
            -- 20140701 �����ű����� �����ϰ� �۾����� �������� ��а��� ����� �۾��ؾ� ��
;


-- 2. ���¿��忡�� ������ ������
SELECT      A.CLN_ACNO                        AS  ���¹�ȣ
           ,ISNULL(C.CLN_EXE_NO,0)            AS  ���Ž����ȣ
           ,A.CLN_TSK_DSCD                    AS  ���ž��������ڵ� --(20:����)
           ,A.AGR_DT                          AS  ��������
           ,A.AGR_EXPI_DT                     AS  ������������
           ,A.AGR_AMT                         AS  �����ݾ�
           ,A.CLN_ACN_STCD                    AS  ���Ű��»����ڵ�
           ,A.ACN_ADM_BRNO                    AS  ���°�������ȣ
           ,A.MNMG_MRT_CD                     AS  �㺸�ڵ�
           ,C.BS_ACSB_CD                      AS  BS���������ڵ�
           ,C.CLN_ACN_STCD                    AS  ���Ž�������ڵ�
           ,C.LN_DT                           AS  ��������
           ,C.EXPI_DT                         AS  ��������
           ,C.CRCD                            AS  ��ȭ�ڵ�
           ,C.LN_EXE_AMT                      AS  �������ݾ�
           ,C.LN_RMD                          AS  �����ܾ�
           ,SUBSTR(B.TCH_EVL_ISN_NO,1,3)      AS  TCB��

INTO        #TCB����

FROM        TB_SOR_LOA_ACN_BC         A

JOIN        TB_SOR_LOA_ACN_BSC_DL     B       --SOR_LOA_���±⺻��
            ON   A.CLN_ACNO   = B.CLN_ACNO

LEFT OUTER JOIN
            TB_SOR_LOA_EXE_BC         C       --SOR_LOA_����⺻
            ON   A.CLN_ACNO  =  C.CLN_ACNO
            AND  C.CLN_ACN_STCD <> '3'        --�������

JOIN        TB_SOR_CLI_TCH_EVL_RSLT_BC  D   -- SOR_CLI_����򰡰���⺻
            ON   B.TCH_EVL_ISN_NO  = D.TCH_EVL_ISN_NO

WHERE       A.NFFC_UNN_DSCD  =  '1'    -- �߾�ȸ���ձ����ڵ� 1:�߾�ȸ
AND         A.CLN_ACN_STCD    <> '3'   -- ��Ұ�������
AND         B.TCH_EVL_ISN_NO  <>  ''   -- ����򰡹߱޹�ȣ
AND         CASE WHEN C.LN_DT IS NOT NULL AND C.LN_DT > '19000000' THEN C.LN_DT ELSE A.AGR_DT END >= '20140701'
            -- �ű�(�����̳� ����) �̿ܿ� �Ⱓ����� tcb �򰡼��� ����� ��찡 �ִµ� �̷� ���´� ������� 20140701 �����ϼ� �ۿ�����
            -- �������� �̷����´� �������ÿ��� �����Ѵٰ� �ϴ� �ɷ����� �۾��Ѵ�.
            -- 20140701 �����ű����� �����ϰ� �۾����� �������� ��а��� ����� �۾��ؾ� ��
ORDER BY    1,2
;

--3. ���ν��� ������� TCB������ �����

SELECT      ���հ��¹�ȣ
           ,���Ž����ȣ
           ,��ó
           ,������������
           ,����򰡱���ſ���
           ,����
           ,����ȣ
           ,������
           ,�����
           ,��������
           ,�ſ���
           ,������
           ,����ſ��򰡵��_�������ι�ȣ
           ,��������
           ,�����ݾ�
           ,���ʴ�������
           ,�������ݾ�
           ,�����ܾ�
           ,��������
           ,�߱�����
INTO        #TEMP            -- DROP TABLE #TEMP
FROM        DWZPRC.UP_DWZ_����_N0255_TCB������Ȳ(1,'','20150831','20150831')
;

SELECT   COUNT(*) FROM #TEMP;          -- 119



//-- TCB �űԴ��� ���¸� �߸���
SELECT      A.����ȣ
           ,A.���հ��¹�ȣ
           ,A.���Ž����ȣ
           ,A.������
           ,A.��ó                            AS TCB��
           ,A.������������                    AS ������������
           ,A.����ſ��򰡵��_�������ι�ȣ   AS ����ſ��򰡵��
           ,A.����򰡱���ſ���            AS ����ſ���

INTO        #������     -- DROP TABLE #������
FROM        #TEMP       A
WHERE        CASE WHEN A.���ʴ������� IS NOT NULL AND A.���ʴ������� > '19000000'  THEN A.���ʴ������� ELSE A.�������� END  > '20140701'
;
SELECT   COUNT(*) FROM #������;          -- 113


//}

//{  #���Ž�û  #���Ž�û����   #�������Ž�û  #�㺸����  #�����㺸����


-- �㺸�������� �⵵�� �ӽ����̺� ����
CREATE TABLE  #���Ž�û
(
  ��������            CHAR(8),
  ���Ž�û��ȣ        CHAR(14),
  �㺸��ȣ            CHAR(12),
  ������ȣ            CHAR(12),
  ���Ű��¹�ȣ        CHAR(20),
  �����õ��ڵ�        CHAR(2),
  �ñ����ڵ�          CHAR(3),
  ���鵿�ڵ�          CHAR(3),
  �����ڵ�            CHAR(2),
  �����õ���          CHAR(100),
  �ñ�����            CHAR(100),
  ���鵿��            CHAR(100),
  ����                CHAR(3),
  ���Ǽ��������ּ�  CHAR(200),
  ����                INT
)
;

BEGIN   --  TRUNCATE TABLE #���Ž�û;


  DECLARE   V_BASEDAY    CHAR(8);
  DECLARE   V_BASEMON    CHAR(6);

--SET       V_BASEDAY  = '20111231';
--SET       V_BASEDAY  = '20121231';
--SET       V_BASEDAY  = '20131231';
--SET       V_BASEDAY  = '20141231';
  SET       V_BASEDAY  = '20150731';

  SELECT    LEFT(V_BASEDAY,6)  INTO   V_BASEMON;

  INSERT INTO #���Ž�û
  SELECT      V_BASEDAY      AS ��������
             ,B.CLN_APC_NO   AS ���Ž�û��ȣ
             ,A.MRT_NO       AS �㺸��ȣ
             ,A.STUP_NO      AS ������ȣ
             ,B.ACN_DCMT_NO  AS ���Ű��¹�ȣ
             ,C.MPSD_CD
             ,C.CCG_CD
             ,C.EMD_CD
             ,C.LINM_CD
             ,C.MPSD_NM          --�����õ���
             ,C.CCG_NM           --�ñ�����
             ,C.EMD_NM           --���鵿��
             ,C.LINM             --����
             ,C.THG_SIT_DTL_ADR  --���Ǽ��������ּ�
             ,RANK() OVER (PARTITION BY B.ACN_DCMT_NO ORDER BY B.CLN_APC_NO, A.STUP_NO, A.MRT_NO) AS ��ǥ_�㺸
  FROM        TT_SOR_CLM_MM_STUP_BC     A   --SOR_CLM_�������⺻
             ,TT_SOR_CLM_MM_CLN_LNK_TR  B   --SOR_CLM_�����ſ��᳻��
             ,TT_SOR_CLM_MM_REST_MRT_BC C   --SOR_CLM_���ε���㺸�⺻
  WHERE       A.NFFC_UNN_DSCD = '1'           --�߾�ȸ���ձ����ڵ�
  AND         A.STUP_STCD     = '02'            --���������ڵ�(02:������)
  AND         A.STUP_NO       = B.STUP_NO        --������ȣ
  AND         B.CLN_LNK_STCD  IN ('02','03')  --���ſ�������ڵ�(02:����,03:��������)
  AND         A.MRT_NO        = C.MRT_NO
  AND         C.MPSD_CD       IS NOT NULL
  AND         A.STD_YM         = V_BASEMON
  AND         B.STD_YM         = V_BASEMON
  AND         C.STD_YM         = V_BASEMON
  ;

END
;

//}

//{  #���ǰ�ġ��ȿ�㺸�ݾ� #��ȿ�㺸 #�����ݾ�

-- 1������  ( ���º� �����ݾ� �� ���ǰ�ġ��ȿ�㺸�ݾ��� ���ϴ� �����ε� Ʋ���� ����)
LEFT OUTER JOIN
            (
             SELECT    C.STD_DT             AS ��������
                      ,C.INTG_ACNO          AS ���հ��¹�ȣ
                      --,D.MRT_NO             AS �㺸��ȣ
                      ,SUM(C.APSL_AMT)      AS �����ݾ�
                      ,SUM(C.ACWR_AVL_MRAM) AS ���ǰ�ġ��ȿ�㺸�ݾ�
             FROM      TB_SOR_CLM_MRT_APRT_EOM_TZ C
             JOIN      (
                        SELECT   STD_DT           AS  ��������
                                ,INTG_ACNO        AS  ���հ��¹�ȣ
                                ,MRT_NO           AS  �㺸��ȣ
                                ,MRT_CD           AS  �㺸�ڵ�
                                ,MAX(STUP_NO)     AS  ������ȣ
                        FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ --SOR_CLM_ä���ں��㺸��п�������
                        WHERE   1=1
                        AND     STD_DT = '20150831'
                        AND     MRT_APRT_TPCD  = '01' --�㺸��������ڵ�
                        AND     MRT_NO <> '999999999999'
                        AND     STUP_NO <> '999999999999'
                        GROUP BY ��������, ���հ��¹�ȣ, �㺸��ȣ, �㺸�ڵ�
                       ) D
                       ON    C.STD_DT    = D.��������
                       AND   C.INTG_ACNO = D.���հ��¹�ȣ --AND C.INTG_ACNO = '101008338879'
                       AND   C.MRT_NO    = D.�㺸��ȣ
                       AND   C.STUP_NO   = D.������ȣ
                       AND   C.MRT_CD    = D.�㺸�ڵ�
             WHERE     1=1
             AND       C.MRT_APRT_TPCD   = '01'
             GROUP BY  C.STD_DT, C.INTG_ACNO       --, C.MRT_CD
            ) B
            ON    A.STD_DT     =  B.��������
            AND   A.INTG_ACNO  =  B.���հ��¹�ȣ


-- 2������
LEFT OUTER JOIN
            (
               SELECT    A.��������
                        ,A.���հ��¹�ȣ
                        ,SUM(A.�����ݾ�)             AS �����ݾ�
                        ,SUM(A.���ǰ�ġ��ȿ�㺸�ݾ�) AS ���ǰ�ġ��ȿ�㺸�ݾ�
               FROM
               (      -- ���º� �㺸�� SUB
                 SELECT    C.STD_DT             AS ��������
                          ,C.INTG_ACNO          AS ���հ��¹�ȣ
                          ,C.MRT_CD             AS �㺸�ڵ�
                          ,C.MRT_NO             AS �㺸��ȣ
                          ,MAX(C.APSL_AMT)      AS �����ݾ�
                          ,MAX(C.ACWR_AVL_MRAM) AS ���ǰ�ġ��ȿ�㺸�ݾ�
                          ,MAX(C.LQWR_AVL_MRAM) AS û�갡ġ��ȿ�㺸�ݾ�
                          ,MAX(C.PRRN_AMT)      AS �������ݾ�
                          ,MAX(C.ACF_RT)        AS �����

                 FROM      TB_SOR_CLM_MRT_APRT_EOM_TZ C -- SOR_CLM_ä���ں��㺸��п�������
                 JOIN      (
                            SELECT   STD_DT           AS  ��������
                                    ,INTG_ACNO        AS  ���հ��¹�ȣ
                                    ,MRT_NO           AS  �㺸��ȣ
                                    ,MRT_CD           AS  �㺸�ڵ�
                                    ,MAX(STUP_NO)     AS  ������ȣ
                            FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ --SOR_CLM_ä���ں��㺸��п�������
                            WHERE   1=1
                            AND     MRT_APRT_TPCD  = '01' --�㺸��������ڵ�
                            AND     MRT_NO <> '999999999999'
                            AND     STUP_NO <> '999999999999'
                            ---------------------------------------------------------------------------------
                            AND     STD_DT     =  '20150930'     -- 9���� �ڷḸ �ʿ��ϹǷ�
                            AND     MRT_CD NOT IN ('601','602')  -- �κ���(601), �����ſ�(602) ����
                            AND     NFM_YN     = 'N'             -- �����㺸����
                            ---------------------------------------------------------------------------------
                            GROUP BY ��������, ���հ��¹�ȣ, �㺸��ȣ, �㺸�ڵ�
                           ) D
                           ON    C.STD_DT    = D.��������
                           AND   C.INTG_ACNO = D.���հ��¹�ȣ --AND C.INTG_ACNO = '101008338879'
                           AND   C.MRT_NO    = D.�㺸��ȣ
                           AND   C.STUP_NO   = D.������ȣ
                           AND   C.MRT_CD    = D.�㺸�ڵ�
                 WHERE     1=1
                 AND       C.MRT_APRT_TPCD   = '01'
                 GROUP BY  C.STD_DT, C.INTG_ACNO, C.MRT_CD, C.MRT_NO
               )     A
               GROUP BY  A.��������
                        ,A.���հ��¹�ȣ
            ) B
            ON    A.STD_DT     =  B.��������
            AND   A.INTG_ACNO  =  B.���հ��¹�ȣ


--          SOR_CLM_ä���ں��㺸��п������� ���̺��� ����������ȣ�� �ش��ϴ� ���ڵ带 �����ϸ�
--          �����ȣ���� ������ ���´�. �Ʒ� ������ DISTINCT ���� COUNT �غ��� 2���̻� �����°��� �Ѱǵ� �����Ƿ�
--          �� �����ȣ���� �����ݾ�,���ǰ�ġ��ȿ�㺸�ݾ�,û�갡ġ��ȿ�㺸�ݾ�,�������ݾ�,����� ����
--          �����ϰ� �� ������ �˼��ִ�
--          ��� �ٱ��������� MAX ���� ���ؼ� �����͵� �����ϴ�.
--          1�� ������ ���º��� �����ݾ׵��� ���ϴ� �����ε� SUM�� ���ѹ����� �����ȣ���� �ݾ��� �ߺ��ɼ��ִ�
--          2�� ������ �̿��ؼ� �㺸���� �����ݾ׵��� ���ѵڿ� SUM�� ���Ѿ� �Ұ��̴�.
--
--           SELECT    C.STD_DT, C.INTG_ACNO, C.MRT_CD, C.MRT_NO
--                    ,COUNT(DISTINCT C.APSL_AMT)
--                    ,COUNT(DISTINCT C.ACWR_AVL_MRAM)
--                    ,COUNT(DISTINCT C.LQWR_AVL_MRAM)
--                    ,COUNT(DISTINCT C.PRRN_AMT)
--                    ,COUNT(DISTINCT C.ACF_RT)
--           FROM      TB_SOR_CLM_MRT_APRT_EOM_TZ C -- SOR_CLM_ä���ں��㺸��п�������
--           JOIN      (
--                      SELECT   STD_DT           AS  ��������
--                              ,INTG_ACNO        AS  ���հ��¹�ȣ
--                              ,MRT_NO           AS  �㺸��ȣ
--                              ,MRT_CD           AS  �㺸�ڵ�
--                              ,MAX(STUP_NO)     AS  ������ȣ
--                      FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ --SOR_CLM_ä���ں��㺸��п�������
--                      WHERE   1=1
--                      AND     STD_DT = '20150630'
--                      AND     MRT_APRT_TPCD  = '01' --�㺸��������ڵ�
--                      AND     MRT_NO <> '999999999999'
--                      AND     STUP_NO <> '999999999999'
--                      GROUP BY ��������, ���հ��¹�ȣ, �㺸��ȣ, �㺸�ڵ�
--                     ) D
--                     ON    C.STD_DT    = D.��������
--                     AND   C.INTG_ACNO = D.���հ��¹�ȣ --AND C.INTG_ACNO = '101008338879'
--                     AND   C.MRT_NO    = D.�㺸��ȣ
--                     AND   C.STUP_NO   = D.������ȣ
--                     AND   C.MRT_CD    = D.�㺸�ڵ�
--           WHERE     1=1
--           AND       C.MRT_APRT_TPCD   = '01'
--           GROUP BY  C.STD_DT, C.INTG_ACNO, C.MRT_CD, C.MRT_NO
--           HAVING    COUNT(DISTINCT C.APSL_AMT) > 1 OR COUNT(DISTINCT C.ACWR_AVL_MRAM) > 1 OR COUNT(DISTINCT C.LQWR_AVL_MRAM) > 1 OR
--                     COUNT(DISTINCT C.PRRN_AMT) > 1 OR COUNT(DISTINCT C.ACF_RT) > 1
--

//}

//{  #����ȯ�� #���ռ۱� #��ȣ������

SELECT      '1.ȯ��'      AS ��������
           ,A.TR_BRNO     AS �ŷ�����ȣ
           ,A.RNNO        AS �Ǹ��ȣ
           ,A.TR_DT       AS �ŷ���

INTO        #TEMP            -- DROP TABLE #TEMP
FROM        TB_SOR_INX_EFM_BC    A
WHERE       1=1
AND         A.TR_DT  BETWEEN '20130101' AND '20150630'    -- �ŷ�����
AND         A.FRXC_LDGR_STCD NOT IN ('4','5','6','7','8') -- �����������
AND         A.NFFC_UNN_DSCD ='2'
AND         A.REF_NO LIKE 'EJ%'

UNION ALL

SELECT      '2.�۱�'     AS  ��������
           ,SUBSTRING(A.REF_NO,3,4)   AS  �ŷ�����ȣ
           ,RMPR_RNNO                 AS  �Ǹ��ȣ
           ,A.TR_DT �ŷ���

FROM        DWZOWN.TB_SOR_INX_OWMN_BC   A  -- SOR_INX_��߼۱ݱ⺻
WHERE       1=1
AND         A.NFFC_UNN_DSCD =  '2'          --  �߾�ȸ���ձ����ڵ� (2:����)
AND         A.TR_DT  BETWEEN '20130101' AND '20150630'    -- �ŷ�����
AND         A.FRXC_LDGR_STCD   IN  ('7','8','9')   -- �ܽ��������οϷ�� (7: ���,8:�������, 9:����)
              -- 8 ������� �� ����Ǿ��� ���� ���������࿡�� ���������� ���� ���ϰ� ���ƿ��� ���
              --   �۱��ο��� �ٽ� �����ִ°����� �ϴ� ����Ǿ��� �۱ݰ��� �����Ƿ� ��� ������.
;


//}

//{  #���뺸����  #������ #�����δ㺸

-- �������̺� �̿뿹
SELECT      T.��������
           ,A.ACN_DCMT_NO      AS ���¹�ȣ
           ,B.DBR_RLT_DSCD     AS ä���ڰ���
           ,C.GRNR_CUST_NO     AS ������
           ,B.MRT_NO           AS �㺸��ȣ
           ,B.ENR_DT           AS �������
           ,ROW_NUMBER() OVER(PARTITION BY T.��������,A.ACN_DCMT_NO ORDER BY B.ENR_DT DESC) AS ��������

INTO        #������ -- DROP TABLE  #������

FROM        #������_�������    T

JOIN        TT_SOR_CLM_MM_CLN_LNK_TR          A          --SOR_CLM_�����ſ��᳻��
            ON   LEFT(T.��������,6)  =  A.STD_YM
            AND  T.���հ��¹�ȣ      =  A.ACN_DCMT_NO
            AND  A.CLN_LNK_STCD      = '02'             --���ſ�������ڵ�(02:����,03:��������)
            AND  A.ACN_DCMT_NO       > ' '              -- ���½ĺ���ȣ

JOIN        TT_SOR_CLM_MM_STUP_BC             B         --SOR_CLM_�������⺻
            ON   A.STD_YM            =  B.STD_YM
            AND  A.STUP_NO           = B.STUP_NO        --������ȣ
            AND  B.MRT_TPCD          = '6'              -- �㺸�����ڵ�(6:������)
            AND  B.STUP_STCD        IN ('02','03')      --���������ڵ�(02:������,03:��������)


JOIN        TT_SOR_CLM_MM_GRNR_MRT_BC          C         --SOR_CLM_�������δ㺸�⺻
            ON   B.STD_YM           =   C.STD_YM
            AND  B.MRT_NO           =   C.MRT_NO
            AND  C.MRT_STCD         =   '02'             --�㺸�����ڵ�(02:������)

WHERE       1=1
;



LEFT OUTER JOIN
             #������            C
             ON    A.��������         =    C.��������
             AND   A.���հ��¹�ȣ     =    C.���¹�ȣ
             AND   C.��������         =    1


-- case2 ���뺸������ ���̵� ���ϱ�, ���뺸������ �������ϰ�� ��ǥ ������ �Ѹ� ���ϱ�.

SELECT      DISTINCT
            A.��������
           ,A.���հ��¹�ȣ
           ,A.�Ǹ��ȣ
           ,A.���Ž�û��ȣ
           ,E.GRNR_CUST_NO     AS  �����ΰ���ȣ
           ,F.CUST_NM          AS  �����ΰ���
           ,F.DTH_DT           AS  �������
           ,CASE WHEN  SUBSTR(F.CUST_RNNO,7,1) IN ('0','9') THEN '18'  --1800��� ����,����
                 WHEN  SUBSTR(F.CUST_RNNO,7,1) IN ('1','2') THEN '19'  --1900��� ����,����
                 WHEN  SUBSTR(F.CUST_RNNO,7,1) IN ('3','4') THEN '20'  --2000��� ����,����
                 WHEN  SUBSTR(F.CUST_RNNO,7,1) IN ('5','6') THEN '19'  --1900��� �ܱ��γ���,����
                 WHEN  SUBSTR(F.CUST_RNNO,7,1) IN ('7','8') THEN '20'  --2000��� �ܱ��γ���,����
            END  ||    SUBSTR(F.CUST_RNNO,1,6)   AS   �������

           ,CONVERT(INT,LEFT(A.��������,4)) - CONVERT(INT,LEFT(�������,4)) + CASE WHEN CONVERT(INT,RIGHT(�������,4)) > CONVERT(INT,RIGHT(A.��������,4)) THEN -1 ELSE 0 END   AS   ������

           ,CASE WHEN ������ <  30                   THEN '1.29������'
                 WHEN ������ >= 30  AND ������ < 40  THEN '2.30���̻� ~ 39������'
                 WHEN ������ >= 40  AND ������ < 50  THEN '3.40���̻� ~ 49������'
                 WHEN ������ >= 50  AND ������ < 60  THEN '4.50���̻� ~ 59������'
                 WHEN ������ >= 60  AND ������ < 70  THEN '5.60���̻� ~ 69������'
                 WHEN ������ >= 70                     THEN '6.70�� �̻�'
            END              AS  ���̱���

--           ,ROW_NUMBER() OVER(PARTITION BY A.���հ��¹�ȣ ORDER BY D.STUP_AMT DESC) AS ��ǥ������
           ,ROW_NUMBER() OVER(PARTITION BY A.���հ��¹�ȣ ORDER BY ������ DESC) AS ��ǥ������

INTO        #TEMP_���뺸��         -- DROP TABLE #TEMP_���뺸��

FROM        ( SELECT  DISTINCT ��������,���հ��¹�ȣ,�Ǹ��ȣ,���Ž�û��ȣ  FROM  #��üä��)     A

JOIN        DWZOWN.TB_SOR_CLM_CLN_LNK_TR   C  -- SOR_CLM_���ſ��᳻��
            ON   A.���Ž�û��ȣ      = C.CLN_APC_NO
--            AND  C.CLN_LNK_STCD      = '02'    -- ���ſ�������ڵ�(02:������) ������¿��� ������°� ���������� �����ϰ� ���

JOIN        DWZOWN.TB_SOR_CLM_STUP_BC       D  -- SOR_CLM_�����⺻
            ON   C.STUP_NO   =  D.STUP_NO

JOIN        DWZOWN.TB_SOR_CLM_GRNR_MRT_BC        E        --SOR_CLM_�����δ㺸�⺻
            ON   D.MRT_NO           =   E.MRT_NO
--            AND  C.MRT_STCD         =   '02'            --�㺸�����ڵ�(02:������)

JOIN        DWZOWN.OM_DWA_INTG_CUST_BC   F
            ON    E.GRNR_CUST_NO   =  F.CUST_NO          -- �����ΰ���ȣ
;
//}

//{  #������ #å����


-- 1. ���տ��ſ��� ���� ������,å����,������ ���ϴ� ����,..�� �̻��ѵ�
--    ����������� ���� �⿩���� �������� �������°��� �����ε�..
           ,( -- �⿩�������� ���� ���� ������ ����
             SELECT   TA.CLN_ACNO                                --
                     ,TA.CLN_EXE_NO                              --
                     ,MAX(CASE WHEN TA.LN_HDL_PTCP_DSCD = '01' THEN TA.USR_NO END) AS USR_NO1        -- ������
                     ,MAX(CASE WHEN TA.LN_HDL_PTCP_DSCD = '02' THEN TA.USR_NO END) AS USR_NO2        -- ���å����
                     ,MAX(CASE WHEN TA.LN_HDL_PTCP_DSCD = '03' THEN TA.USR_NO END) AS USR_NO3        -- ���������
             FROM     DWZOWN.TB_SOR_LOA_HDL_PTCP_DL  TA
                     ,(SELECT   CLN_ACNO                         --
                               ,CLN_EXE_NO                       --
                               ,SNO                              --�Ϸù�ȣ
                               ,LN_HDL_PTCP_DSCD
                               ,MAX(CNDG_RT) AS CNDG_RT          --�⿩������
                       FROM     DWZOWN.TB_SOR_LOA_HDL_PTCP_DL
                       WHERE    LN_HDL_PTCP_DSCD IN ('01','02','03')         --������ް����±����ڵ�('01':������)
                       GROUP BY CLN_ACNO                         --
                               ,CLN_EXE_NO                       --
                               ,SNO
                               ,LN_HDL_PTCP_DSCD)    TB
             WHERE    1=1
             AND      TA.CLN_ACNO         = TB.CLN_ACNO                --
             AND      TA.CLN_EXE_NO       = TB.CLN_EXE_NO              --
             AND      TA.SNO              = TB.SNO                     --�Ϸù�ȣ
             AND      TA.LN_HDL_PTCP_DSCD = TB.LN_HDL_PTCP_DSCD        --�Ϸù�ȣ
             GROUP BY TA.CLN_ACNO, TA.CLN_EXE_NO
            )                                          T7  --SOR_LOA_��ް����ڻ�(������)

--2. ���� �������ȣ�� �˰����ϴ� ���
-- ���� ������� �������ο� ������� ������޽� �������� �������� ����
SELECT      TA.CLN_ACNO        AS   ���հ��¹�ȣ
           ,TA.CLN_EXE_NO      AS   ���Ž����ȣ
           ,TA.USR_NO          AS   �ŷ��������ڹ�ȣ
           ,C1.���            AS   �ŷ��������ڸ�
           ,ROW_NUMBER() OVER(PARTITION BY TA.CLN_ACNO ORDER BY TA.CLN_EXE_NO ASC) AS ����
INTO        #TEMP  -- DROP TABLE #TEMP
FROM        DWZOWN.TB_SOR_LOA_HDL_PTCP_DL  TA
JOIN        (
             SELECT   CLN_ACNO                         --
                     ,CLN_EXE_NO                       --
                     ,SNO                              --�Ϸù�ȣ
                     ,LN_HDL_PTCP_DSCD
                     ,MAX(CNDG_RT) AS CNDG_RT          --�⿩������
             FROM     DWZOWN.TB_SOR_LOA_HDL_PTCP_DL
             WHERE    LN_HDL_PTCP_DSCD = '03'    -- ������
             GROUP BY CLN_ACNO                         --
                     ,CLN_EXE_NO                       --
                     ,SNO
                     ,LN_HDL_PTCP_DSCD
            )    TB
            ON     TA.CLN_ACNO         = TB.CLN_ACNO
            AND    TA.CLN_EXE_NO       = TB.CLN_EXE_NO              --
            AND    TA.LN_HDL_PTCP_DSCD = TB.LN_HDL_PTCP_DSCD        --�Ϸù�ȣ
            AND    TA.CNDG_RT          = TB.CNDG_RT

JOIN        TB_MDWT�λ�  C1
            ON    TA.USR_NO  =  C1.���
            AND   C1.�ۼ�������     =  '20170630'

WHERE       1=1
;

--3. ���� ������ �� å���� ��ȣ�� �˰����ϴ� ���
--  ���� å���ڿ� ������ ���ϱ� ���� �ӽ����̺� ����
--  ����ν�� �� ������ ���� ��Ȯ�ѵ�..
SELECT      TA.CLN_ACNO          AS   ���հ��¹�ȣ
           ,TA.CLN_EXE_NO        AS   ���Ž����ȣ
           ,TA.LN_HDL_PTCP_DSCD  AS   ������ް����ڱ����ڵ�
           ,TA.CNDG_RT           AS   �⿩��
           ,TA.USR_NO            AS   ����ڹ�ȣ
           ,C1.����              AS   ����ڼ���
           ,ROW_NUMBER() OVER(PARTITION BY TA.CLN_ACNO,TA.LN_HDL_PTCP_DSCD ORDER BY TA.CNDG_RT DESC) AS �⿩����
INTO        #TEMP    -- DROP TABLE #TEMP
FROM        DWZOWN.TB_SOR_LOA_HDL_PTCP_DL  TA
JOIN        TB_MDWT�λ�  C1
            ON    TA.USR_NO  =  C1.���
            AND   C1.�ۼ�������     =  '20170731'
WHERE       1=1
AND         TA.CLN_EXE_NO IN (0,1)  -- �����ȣ�� ��������� �����̸� 0 �ϰ��̰� ���డ���� �����̸� 1�� ���̴�
;



LEFT OUTER JOIN
            #TEMP    D1
            ON    A.INTG_ACNO   =  D1.���հ��¹�ȣ
            AND   D1.������ް����ڱ����ڵ�  =  '02'  -- å����
            AND   D1.�⿩���� = 1

LEFT OUTER JOIN
            #TEMP    D2
            ON    A.INTG_ACNO   =  D2.���հ��¹�ȣ
            AND   D2.������ް����ڱ����ڵ�  =  '03'  -- ������
            AND   D2.�⿩���� = 1
//}

//{ #�������ȣ #�ſ����ȣ #�����̺�

SELECT A.BRNO ����ȣ
     , CASE WHEN A.UNN_ABV_NM = '��������' THEN NULL ELSE  A.UNN_ABV_NM END ���ո�
     , A.BR_NM ������
     , A.GRCD �����ڵ�
     , ISNULL(A.TL_ARCD, A.TL_ARCD || '-' || A.TL_TONO || '-' || A.TL_SNO) ��ȭ
     , ISNULL(A.FAX_TL_ARCD, A.FAX_TL_ARCD || '-' || A.FAX_TL_TONO || '-' || A.FAX_TL_SNO) �ѽ�
     , SUBSTR(A.ZIP,1,3) || '-' || SUBSTR(A.ZIP,4,3) �����ȣ
     , D.ZIP         AS �������ȣ
  FROM TB_SOR_CMI_BR_BC        A
      ,TB_SOR_CMI_RD_NM_ADR_BC D
 WHERE A.BRNO < '1000'
   AND A.BR_DSCD = '2' --
   AND A.BR_STCD = '01' -- ���󿵾���
   AND A.BR_KDCD = '20' -- ������
   AND SUBSTR(A.ZIP_SNO, 1, 12) = D.RD_NM_CD
   AND SUBSTR(A.ZIP_SNO, 13, 3) = D.EMD_CD
   AND (  ( (D.BLD_MNNO || CASE WHEN D.BLD_SBNO = '0' THEN NULL ELSE  '-' || D.BLD_SBNO END) = SUBSTR(A.BZADR,1,LOCATE(A.BZADR,'(')-1) ) OR
          ( (D.BLD_MNNO || CASE WHEN D.BLD_SBNO = '0' THEN NULL ELSE  '-' || D.BLD_SBNO END) = SUBSTR(A.BZADR,1,LOCATE(A.BZADR,',')-1) ) OR
          ( (D.BLD_MNNO || CASE WHEN D.BLD_SBNO = '0' THEN NULL ELSE  '-' || D.BLD_SBNO END) = A.BZADR                                 )
       )
 ORDER BY BRNO;


0684  �׺�����   �������� 0076843 054   054   767-863 767863  4793033250070200012200000


DBA.DESC_TABLE DWZOWN,TB_SOR_CMI_RD_NM_ADR_BC

SELECT ZIP_SNO,BZADR,SUBSTR(BZADR,1,LOCATE(BZADR,'(')-1)
FROM  TB_SOR_CMI_BR_BC
WHERE  BRNO = '0684'
-- 479303325007002

SELECT D.RD_NM_CD,D.EMD_CD,BLD_MNNO,BLD_SBNO,D.BLD_MNNO || CASE WHEN D.BLD_SBNO = '0' THEN NULL ELSE  '-' || D.BLD_SBNO END
FROM   TB_SOR_CMI_RD_NM_ADR_BC D
WHERE  UNQ_BLD_ADM_SNO = '4793033250070200012200000'


//}

//{ #���ʽ��� #ù����

JOIN
            (
             SELECT  A.CLN_ACNO
                    ,A.CLN_ACN_STCD
                    ,A.AGR_DT
                    ,B.CLN_EXE_NO
                    ,B.LN_DT
                    ,ROW_NUMBER() OVER(PARTITION BY B.CLN_ACNO ORDER BY B.LN_DT ASC) AS �������
             FROM    TB_SOR_LOA_ACN_BC  A        --  SOR_LOA_���±⺻
             LEFT OUTER JOIN
                     TB_SOR_LOA_EXE_BC  B
                     ON  A.CLN_ACNO   = B.CLN_ACNO
                     AND B.CLN_ACN_STCD <> '3'
             WHERE   1=1
             AND     A.CLN_ACNO IN ( SELECT ���¹�ȣ FROM #������ )
            )    B
            ON    A.���¹�ȣ  =  B.CLN_ACNO
            AND   B.�������  =  1

//}

//{ #�����ű� #���� #����ű�
-- ���տ��� ������ ��� ���� �����ǿ� ���� �������� ���տ��ſ� ������
-- ��찡 �־ ������ ���� �������� �� �����͵��� �����Ƿ� �����ؾ� �Ѵ�

AND         (
                  LEFT(A.AGR_DT,6)      = LEFT(A.STD_DT,6)  OR     -- �����ű� �Ǵ�
                  (
                     A.AGR_DT              < A.PSTP_ENR_DT     AND
                     LEFT(A.PSTP_ENR_DT,6) = LEFT(A.STD_DT,6)            -- ����
                   )
            )

//}

//{ #�ɻ�� #���ν��� #���ᱸ��

-- CASE 1
-- ��û���忡�� ���νɻ�� ���������Ῡ�� ������
CREATE  TABLE  #TEMP_���ν���      --  DROP TABLE  #TEMP_���ν���
(
            ��������             CHAR(8)
           ,���¹�ȣ             CHAR(20)
           ,����                 CHAR(100)
           ,�ɻ籸��             CHAR(10)
           ,��������             CHAR(8)
           ,���ι�ȣ             CHAR(14)
           ,���ɻ翪����ڹ�ȣ CHAR(10)
           ,���Ž�û�����ڵ�     CHAR(2)
           ,�������ᱸ��         CHAR(100)
           ,��û��               CHAR(5)
);


--#TEMP_���ν���
--�ɻ��(0627) ���ΰ� ����
--�� ������ ������û�ǿ� ���� �������� �ɻ���ΰ͵鸸 ���
--���迩���� ��� �ɻ�� �������� ��
BEGIN
DECLARE     V_BASEDAY   CHAR(8);

SET         V_BASEDAY = '20151031';

--�������
SELECT      A.ACN_DCMT_NO         AS ���¹�ȣ
           --,B.APRV_BRNO           AS ��������ȣ
           ,TRIM(D.BR_NM)         AS ������
           ,'����ɻ�'            AS �ɻ籸��
           ,B.HDQ_APRV_DT         AS ��������
           ,A.CLN_APRV_NO         AS ���ι�ȣ
           ,B.RSBL_XMRL_USR_NO    AS ���ɻ翪����ڹ�ȣ
           ,A.CLN_APC_DSCD        AS ��û����
           ,B.CSLT_BRNO           AS ��û��
INTO        #TEMP
FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
           ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
           ,(SELECT   A.ACN_DCMT_NO         AS ���¹�ȣ
                     ,MAX(B.HDQ_APRV_DT)    AS ��������
             FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
                     ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
             WHERE    A.ACN_DCMT_NO       IS NOT NULL
             AND      A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
             AND      A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
             AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
             AND      B.APCL_DSCD         = '2'               -- ���ο��ű����ڵ�(1:����������,2:���ν���)
             AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
             AND      B.HDQ_APRV_DT       BETWEEN '20120101' AND V_BASEDAY   -- ��������
             GROUP BY A.ACN_DCMT_NO
            ) C
           ,OT_DWA_DD_BR_BC D  --DWA_�����⺻
WHERE       A.ACN_DCMT_NO       IS NOT NULL
AND         A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
AND         B.APCL_DSCD         = '2'               -- ���ο��ű����ڵ�(1:����������,2:���ν���)
AND         A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
AND         B.HDQ_APRV_DT       BETWEEN '20120101' AND V_BASEDAY   -- ��������
AND         A.ACN_DCMT_NO       = C.���¹�ȣ
AND         B.HDQ_APRV_DT       = C.��������
AND         B.APRV_BRNO         *= D.BRNO
AND         D.STD_DT            = V_BASEDAY
AND         B.APRV_BRNO         =  '0627'           -- �ɻ�ν���
AND         D.BRNO              <> 'XXXX'

UNION ALL

--���ο����� ��� ��� �ɻ�ν���
SELECT      A.CLN_ACNO         AS ���¹�ȣ
           ,'�ɻ��'           AS ��������ȣ
           ,'���νɻ�'         AS �ɻ籸��
           ,A.CLN_APRV_DT      AS ��������
           ,A.CLN_APRV_NO        AS ���ι�ȣ
           ,A.RSBL_XMRL_USR_NO   AS ���ɻ翪����ڹ�ȣ
           ,A.CLN_APC_DSCD       AS ��û����
           ,A.ADM_BRNO           AS ��û��
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
           ,(SELECT   A.CLN_ACNO         AS ���¹�ȣ
                     ,MAX(A.CLN_APRV_DT) AS ��������
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
             WHERE    A.CLN_ACNO          IS NOT NULL
             AND      A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
             AND      A.CSS_XCDC_DSCD     = '22'              -- CSS���ᱸ���ڵ�(11:������-����,21:����-�߾�ȸ,22:�μ���(�߾�ȸ))
             AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
             AND      A.CLN_APRV_DT       BETWEEN '20120101' AND V_BASEDAY   -- ��������
             GROUP BY A.CLN_ACNO
            ) B
WHERE       A.CLN_ACNO          IS NOT NULL
AND         A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
AND         A.CSS_XCDC_DSCD     = '22'              -- CSS���ᱸ���ڵ�(11:������-����,21:����-�߾�ȸ,22:�μ���(�߾�ȸ))
AND         A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
AND         A.CLN_APRV_DT       BETWEEN '20120101' AND V_BASEDAY   -- ��������
AND         A.CLN_ACNO          = B.���¹�ȣ
AND         A.CLN_APRV_DT       = B.��������
;

INSERT INTO #TEMP_���ν���
SELECT      V_BASEDAY
           ,A.���¹�ȣ
           ,A.������
           ,A.�ɻ籸��
           ,A.��������
           ,A.���ι�ȣ
           ,A.���ɻ翪����ڹ�ȣ
           ,A.��û����
           ,C.LST_XCDC_DSCD ||'('||TRIM(D.XCDC_DSCD_NM)||')'  AS �������ᱸ��
           ,A.��û��

FROM        #TEMP A

JOIN        (
             SELECT   A.���¹�ȣ
                     ,A.��������
                     ,MAX(A.���ι�ȣ)   AS �������ι�ȣ
             FROM     #TEMP A
                     ,(SELECT   ���¹�ȣ
                               ,MAX(��������)   AS ������������
                       FROM     #TEMP
                       GROUP BY ���¹�ȣ
                       ) B
             WHERE    A.���¹�ȣ = B.���¹�ȣ
             AND      A.�������� = B.������������
             GROUP BY A.���¹�ȣ
                     ,A.��������
            ) B
            ON   A.���¹�ȣ    = B.���¹�ȣ
            AND  A.��������    = B.��������
            AND  A.���ι�ȣ    = B.�������ι�ȣ

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APRV_BC   C     -- SOR_CLI_���Ž��α⺻
            ON   A.���ι�ȣ  =  C.CLN_APRV_NO

LEFT OUTER JOIN
            TB_SOR_CLI_XCDC_DSCD_BC  D   --SOR_CLI_���ᱸ���ڵ�⺻
            ON   C.LST_XCDC_DSCD  = D.CLN_XCDC_DSCD  --�������ᱸ���ڵ�
;

END;



-- CASE 2   �ɻ�� ���� ���Ž�û���� ��� �������� ���
--
  SELECT      A.ACN_DCMT_NO         AS ���¹�ȣ
             ,B.CSLT_BRNO           AS ǰ������ȣ
             ,E.BR_NM               AS ǰ������
             ,A.CLN_APC_DSCD        AS ���Ž�û�����ڵ�
             ,B.CUST_NO             AS ����ȣ
             ,C.CUST_NM             AS ����
             ,B.HDQ_APRV_DT         AS ��������
             ,D.APRV_AMT            AS ���αݾ�
             ,D.APRV_WNA            AS ���ο�ȭ�ݾ�
             ,B.CRDT_EVL_NO         AS �ſ��򰡹�ȣ
             ,B.CRDT_EVL_MODL_DSCD  AS �ſ��򰡸��������ڵ�
             ,B.STDD_INDS_CLCD      AS ǥ�ػ���з��ڵ�
             ,B.RSBL_XMRL_USR_NO    AS ���ɻ翪����ڹ�ȣ
             ,A.MNMG_MRT_CD         AS �ִ㺸�ڵ�
  INTO        #TEMP      -- DROP TABLE #TEMP
  FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- SOR_CLI_���Ž�û�⺻
             ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- SOR_CLI_���Ž�û��ǥ�⺻
             ,DWZOWN.OM_DWA_INTG_CUST_BC         C -- DWA_���հ��⺻
             ,DWZOWN.TB_SOR_CLI_CLN_APRV_BC      D -- SOR_CLI_���Ž��α⺻
             ,DWZOWN.OT_DWA_DD_BR_BC             E -- DWA_�����⺻
  WHERE       A.ACN_DCMT_NO       IS NOT NULL
  AND         A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
  AND         A.CLN_APC_DSCD      BETWEEN  '01'   AND '21'   -- �ű�, ����, ����
  AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
  AND         A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
  AND         B.APCL_DSCD         = '2'               -- ���ο��ű����ڵ�(1:����������,2:���ν���)
  AND         A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
  AND         B.HDQ_APRV_DT       BETWEEN '20120101' AND '20151030'
  AND         B.APRV_BRNO         =  '0627'           -- �ɻ�ν���
  AND         B.CUST_NO          *=  C.CUST_NO
  AND         A.CLN_APRV_NO      *=  D.CLN_APRV_NO
  AND         B.CSLT_BRNO        *= E.BRNO
  AND         E.STD_DT            = '20151031'

  ;



-- CASE 3   ���������� �ش��ϴ� ���ι�ȣ�� ���������� �������� ���
--
LEFT OUTER JOIN         -- ���ʾ����ŷ�����
            (
             SELECT      TA.CLN_ACNO                     AS  ���Ű��¹�ȣ
                        ,TA.AGR_EXPI_DT                  AS  ������������
                        ,TA.AGR_DT                       AS  ��������
                        ,TA.AGR_AMT                      AS  �����ݾ�
                        ,TA.TR_BF_ADD_IRT                AS  �ŷ�������ݸ�
                        ,TA.ADD_IRT                      AS  ����ݸ�
                        ,TC.CRDT_EVL_GD                  AS  �ſ��򰡵��
                        ,TD.XCDC_ATR_DSCD                AS  ����Ӽ������ڵ�  --'01' ��������, '02' ����������
                        ,TE.ASS_CRDT_GD                  AS  ASS�ſ���

             FROM       DWZOWN.TB_SOR_LOA_AGR_HT       TA
             JOIN        (
                           SELECT   CLN_ACNO
                                   ,MAX(AGR_TR_SNO) AS AGR_TR_SNO    --�����ŷ��Ϸù�ȣ(�������ѿ����� �����ŷ��Ϸù�ȣ)
                           FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                           WHERE    CLN_APC_DSCD IN ('01','02','04','07','08','09') --���Ž�û�����ڵ� <10 �� �ű԰�
                           AND      TR_STCD       =  '1'             --�ŷ������ڵ�(1:����)
                           AND      ENR_DT       <=  '20160630'
                           GROUP BY CLN_ACNO
                         )            TB
                         ON    TA.CLN_ACNO   = TB.CLN_ACNO
                         AND   TA.AGR_TR_SNO = TB.AGR_TR_SNO

             LEFT OUTER JOIN
                         TB_SOR_CLI_CLN_APRV_BC     TC     -- SOR_CLI_���Ž��α⺻
                         ON   TA.CLN_APRV_NO  =  TC.CLN_APRV_NO

             LEFT OUTER JOIN
                         TB_SOR_CLI_XCDC_DSCD_BC  TD   --SOR_CLI_���ᱸ���ڵ�⺻
                         ON   TC.LST_XCDC_DSCD  = TD.CLN_XCDC_DSCD  --�������ᱸ���ڵ�

             LEFT OUTER JOIN
                          TB_SOR_PLI_SYS_JUD_RSLT_TR TE          --SOR_PLI_�ý��۽ɻ�������
                          ON   TC.CUST_NO        = TE.CUST_NO
                          AND  TC.CLN_APC_NO     = TE.CLN_APC_NO

             WHERE       1=1
             AND         TA.CLN_ACNO  IN ( SELECT DISTINCT ���հ��¹�ȣ FROM #��ȭ�����_���º� )
            )     D
            ON            A.���հ��¹�ȣ  = D.���Ű��¹�ȣ
            AND           A.�������      = 1
            AND           A.��������      = D.��������     -- �űԾ������� �������� ���̹Ƿ� �������ڰ� �翬�� ������������ Ȯ���� ���ؼ� �ʿ�

//}

//{  #PLAN  #QUERYPLAN #�����÷� #�÷� #NESTED  #DB1


-- CASE 1 : �����÷� ������
SET TEMPORARY OPTION QUERY_PLAN_AS_HTML = 'ON';

-- Query_Plan_As_HTML_Directory �� dba�� �ٲܼ�����
-- SET TEMPORARY OPTION Query_Plan_As_HTML_Directory  = '/sybaseiq/IQPLN';

SELECT COUNT(*)
         FROM     OT_DWA_INTG_DPS_BC         A    -- DWA_���ռ��ű⺻
         LEFT OUTER
         JOIN     OM_DWA_INTG_CUST_BC        B    -- DWA_���հ��⺻
                                             ON     A.CUST_NO       = B.CUST_NO

         LEFT OUTER
         JOIN     OT_DWA_DD_BR_BC            C    -- DWA_�����⺻
                                              ON     A.ADM_BRNO      = C.BRNO        -- ����ȣ   = ����ȣ      (JOIN����)
                                              AND    C.BR_DSCD       = '2'           -- �������ڵ� = '2' (����)
                                              AND    C.FSC_DSCD      = '3'           -- ��ȣ
                                              AND    C.BR_KDCD       < '40'          -- 10:���κμ�, 20:������, 30:������
                                              AND    C.STD_DT        = '20151130'    -- �������� = P_��������

CROSS   JOIN     ( SELECT SNO FROM OM_DWA_GVNO_BC WHERE SNO <= 2 )           Z    -- DWA_ä���⺻

         WHERE    1 = 1
           AND    A.STD_DT        IN (SELECT DISTINCT EOTM_DT
                                      FROM   OM_DWA_DT_BC
                                      WHERE  STD_DT  BETWEEN '20120101' AND '20121231'
                                     )
           AND    A.DPS_ACN_STCD   = '01'      -- ���Ű��»����ڵ�
           AND    A.DP_BS_ACSB_CD IN (SELECT RLT_ACSB_CD
                                      FROM   OT_DWA_DD_ACSB_BC             -- DWA_�ϰ�������⺻
                                      WHERE  ACSB_CD     = '23000303'      -- �����ڵ� = '23000303'(�䱸�ҿ�Ź�ݰ���)
                                        AND  FSC_SNCD   IN ('K','C')       -- ȸ������ڵ�  = 'K' (K-GAAP), C(:����)
                                        AND  STD_DT      = '20151130'      -- �������� = P_��������
                                     )
;

SET TEMPORARY OPTION QUERY_PLAN_AS_HTML = 'OFF';

-- CASE2 : DB1������ �����߻�

�����Ͼ�� ������ �� ��� ���ν��� ���� ��,
Ȥ�� sql������ ����Ǹ� sql �������� �Ʒ� ������
�����ϰ� �� �Ŀ� ������ ����� �մϴ�.

set temporary option Join_Preference = '-3'

�� �޽����� ������ ����� �� Plan�� �߸� �����Ǿ�
nested-loop push down join ���� join �Ǵ� ���� �����ϴ� �����̶�� �մϴ�.


//}

//{  #�Ҹ�  #��Ҹ�


--CASE1 : �ſ븮��ũ���̺��� �о ����Ѵ�.
--        TB_SOR_DAD_RSK_CLN_TR(SOR_DAD_�ſ����迩�Ű��³���) �� �Ϸ�ʰԾ� �����Ͱ� �����Ƿ� �ſ븮��ũ ���̺��� �����̿��ϴ°��� ����

           ,CASE WHEN  V.RTSL_NRTSL_DSCD   = '01'  THEN '1. ��Ҹ�'
                 WHEN  V.RTSL_NRTSL_DSCD   = '02'  THEN '2. �Ҹ�'
                 ELSE  '9. UNKNOWN'
            END                                    AS �Ҹź�Ҹű���   -- ���ִ� 5���̻� ��Ҹű���

LEFT OUTER JOIN
/*            TB_CDR_RSK_CLN_TR    V                        -- CDR_�ſ����迩�Ű��³���, RTSL_NRTSL_DSCD  �Ҹź�Ҹű����ڵ�
            ON      A.INTG_ACNO   =  V.INTG_ACNO
            AND     A.CLN_EXE_NO  =  V.INTG_EXE_NO
            AND     V.DWUP_STD_DT =  P_��������
*/
            (
                SELECT   DISTINCT
                         DWUP_STD_DT
                        ,INTG_ACNO
                        ,INTG_EXE_NO
                        ,RTSL_NRTSL_DSCD
                FROM     DWROWN.TB_CDR_RSK_CLN_TR  	--CDR_�ſ����迩�Ű��³��� RTSL_NRTSL_DSCD  �Ҹź�Ҹű����ڵ�
                WHERE    DWUP_STD_DT = (
                                     SELECT   MAX(DWUP_STD_DT)
                                     FROM     DWROWN.TB_CDR_RSK_CLN_TR
                                     WHERE    DWUP_STD_DT <= P_��������
                                   )
            )       V
            ON      A.INTG_ACNO   =  V.INTG_ACNO
            AND     A.CLN_EXE_NO  =  V.INTG_EXE_NO



-- csae 2
/***********************************************************************************/
--�Ҹ�/��Ҹű���  ����
--�����򰡽� ����ϴ� ����(��������)  BY�����
--���Ҹź�Ҹű��� : ���ֺ� 10���̻󿩽� ��Ҹſ������� ���� ����
--�Ҹź�Ҹű����ڵ� : ���ֺ� 5���̻󿩽� ��Ҹſ������� ���� ����
/***********************************************************************************/
--�ӽ����̺� ���� ( #TEMP_���Ű������� )
--����
IF EXISTS (SELECT TOP 1 ���س��  FROM OT_ECRT���Ű�������  WHERE �������ڵ� = '1' AND ���س�� = LEFT(P_��������, 6))  THEN

    SELECT   A.���س��
            ,A.���ֹ�ȣ
            ,A.���հ��¹�ȣ
            ,A.���Ž����ȣ
            ,A.���Ҹź�Ҹű���
            ,A.�Ҹź�Ҹű����ڵ�
            ,CASE WHEN (B.���ֱ����ڵ� = '07' OR B.�ſ��򰡸��������ڵ�  = '51') AND
                        A.���⼼���ڵ� NOT IN ('1076','1091')                              THEN 'Y'
             ELSE 'N' END                    AS ��ȸ���⿩��
            ,B.�������ڵ�
            ,B.���ֱ����ڵ�
            ,B.BIS���ֱ����ڵ�
            ,B.��BIS���ֱ���
            ,B.����
            ,B.�ſ��򰡸��������ڵ� ���������ڵ�
            ,B.�����������
            ,ISNULL(C.�ְſ�ε���㺸��,0) ���ô㺸
            ,'00'  AS ǥ�ؼҸź�Ҹű����ڵ�
    INTO     #TEMP_���Ű�������
    FROM     OT_ECRT���Ű������� A,
             (
                     SELECT   STD_DT
                             ,ACSB_CD
                             ,ACSB_NM
                             ,ACSB_CD4  --��ȭ�����
                             ,ACSB_NM4
                             ,ACSB_CD5  --����ڱݴ����(14002401), �����ڱݴ����(14002501), �����ױ�Ÿ(14002601)
                             ,ACSB_NM5
                             ,ACSB_CD6
                             ,ACSB_NM6
                     FROM     OT_DWA_DD_ACSB_TR
                     WHERE    1=1
                     AND      FSC_SNCD IN ('K','C')
                     AND      ACSB_CD4 IN ('13000801','13001901')       --��ȭ�����,����ä
                     AND      STD_DT   = P_��������
             )       K,
             OT_ECRT���Ű����� B,
            (SELECT  SUBSTR(STD_DT,1,6)                      AS ���س��
                    ,INTG_ACNO                               AS ���հ��¹�ȣ
                    ,CLN_EXE_NO                              AS ���Ž����ȣ
                    ,BS_ACSB_CD                              AS BS���������ڵ�
                    ,FRXC_TSK_DSCD                           AS ��ȯ���������ڵ�
                    ,SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) AS �ְſ�ε���㺸��
             FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ  A   -- SOR_CLM_ä���ں��㺸��п�������
             WHERE   STD_DT             = P_��������
               AND   NFFC_UNN_DSCD      = '1'    -- �߾�ȸ���ձ����ڵ�
               AND   MRT_APRT_TPCD      = '01' -- �㺸��������ڵ�
               AND   LQWR_APRT_MRAM     > 0    -- û�갡ġ��д㺸�ݾ� > 0
               AND   MRT_CD             IN ('101','102','103','104','105','109','111','170')
             GROUP   BY SUBSTR(STD_DT,1,6),INTG_ACNO,CLN_EXE_NO,BS_ACSB_CD,FRXC_TSK_DSCD
             HAVING  SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) > 0
             ) C
    WHERE   A.���س��           = LEFT(P_��������, 6)
      AND   A.�������ڵ�         = '1'
      AND   A.��ǥ�����ڵ�      IN ('1','2','3','4','5','6','7')
      AND   A.BS���������ڵ�     = K.ACSB_CD
      AND   A.���س��          *= B.���س��
      AND   A.�������ڵ�        *= B.�������ڵ�
      AND   A.�Ǹ��ȣ          *= B.���Ǹ��ȣ
      AND   A.���س��          *= C.���س��
      AND   A.���հ��¹�ȣ      *= C.���հ��¹�ȣ
      AND   A.���Ž����ȣ      *= C.���Ž����ȣ
      AND   A.BS���������ڵ�    *= C.BS���������ڵ�
      AND   A.��ȯ���������ڵ�  *= C.��ȯ���������ڵ�
    ;


    SELECT  ���س��
           ,���ֹ�ȣ
           ,�������ڵ�
           ,���ֱ����ڵ�
           ,��BIS���ֱ���
           ,CASE WHEN ��BIS���ֱ��� IN ('72','73','80','90') THEN
                 CASE WHEN �ְſ����ܿ��űݾ� > 1000000000    THEN '01' -- 10���ʰ�
                      WHEN �������ڵ� IN ('01','03','07')   THEN '02' -- 01:�������ֹι�ȣ, 03:���λ����, 07:�ܱ����ֹι�ȣ
                      WHEN ���ֱ����ڵ� IN ('02','03','07')        THEN '02' -- 02:�߼ҿܰ�, 03:�߼Һ�ܰ�
                      ELSE '01'
                 END
            ELSE '01'
            END                           AS ǥ�ؼҸź�Ҹű����ڵ�
    INTO    #TEMP
    FROM   (
            SELECT  A.���س��
                   ,A.�������ڵ�
                   ,A.���ֹ�ȣ
                   ,A.�������ڵ�
                   ,A.���ֱ����ڵ�
                   ,A.��BIS���ֱ���
                   ,SUM(ISNULL(B.��ȭ�����ݾ�,0))                      AS ��ȭ�����ݾ�
                   ,SUM(A.�����ܾ�)                                    AS �ܾ�
                   ,SUM(ISNULL(A.�ְſ�ε���㺸��,0))                AS �ְſ�ε���㺸�� -- A.������ȿ�㺸�ݾ� �÷��� IRB�����θ� ����ϰ� SA�� ǥ�ش㺸��а�����.
                   ,SUM(CASE WHEN ISNULL(B.��ȭ�����ݾ�,0) > A.�����ܾ� THEN ISNULL(B.��ȭ�����ݾ�,0)
                       ELSE A.�����ܾ� END)                           AS �ѵ����ؿ��űݾ�
                   ,SUM(CASE WHEN ISNULL(B.��ȭ�����ݾ�,0) > A.�����ܾ� THEN ISNULL(B.��ȭ�����ݾ�,0)
                       ELSE A.�����ܾ� END - ISNULL(A.�ְſ�ε���㺸��,0)) AS �ְſ����ܿ��űݾ�
            FROM   (SELECT  A.���س��
                           ,A.�������ڵ�
                           ,A.���ֹ�ȣ
                           ,B.�������ڵ�
                           ,B.���ֱ����ڵ�
                           ,B.��BIS���ֱ���
                           ,CASE WHEN A.ī��ȸ����ȣ     > '0' THEN A.ī��ȸ����ȣ
                                  WHEN A.��ȯ�ѵ����¹�ȣ > '0' THEN A.��ȯ�ѵ����¹�ȣ
                           ELSE A.���հ��¹�ȣ END         AS ���հ��¹�ȣ
                           ,SUM(A.�����ܾ�)                 AS �����ܾ�
                           ,SUM(C.�ְſ�ε���㺸��)       AS �ְſ�ε���㺸��
                    FROM    OT_ECRT���Ű������� A,
                            OT_ECRT���Ű����� B,
                           (SELECT  SUBSTR(STD_DT,1,6)                      AS ���س��
                                   ,INTG_ACNO                              AS ���հ��¹�ȣ
                                   ,CLN_EXE_NO                               AS ���Ž����ȣ
                                   ,BS_ACSB_CD                               AS BS���������ڵ�
                                   ,FRXC_TSK_DSCD                          AS ��ȯ���������ڵ�
                                   ,SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) AS �ְſ�ε���㺸��
                            FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ   A   -- SOR_CLM_ä���ں��㺸��п�������
                            WHERE   STD_DT             = P_��������
                              AND   NFFC_UNN_DSCD     = '1'    -- �߾�ȸ���ձ����ڵ�
                              AND   MRT_APRT_TPCD     = '01' -- �㺸��������ڵ�
                              AND   LQWR_APRT_MRAM     > 0    -- û�갡ġ��д㺸�ݾ� > 0
                              AND   MRT_CD             IN ('101','102','103','104','105','109','111','170')
                            GROUP   BY SUBSTR(STD_DT,1,6),INTG_ACNO,CLN_EXE_NO,BS_ACSB_CD,FRXC_TSK_DSCD
                            HAVING  SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) > 0
                            ) C
                    WHERE   A.���س��           = LEFT(P_��������, 6)
                      AND   A.�������ڵ�         = '1'
                      AND   B.��BIS���ֱ��� IN ('72','73','80','90')
                      AND   A.���س��           = B.���س��
                      AND   A.�������ڵ�         = B.�������ڵ�
                      AND   A.�Ǹ��ȣ           = B.���Ǹ��ȣ
                      AND   A.���س��          *= C.���س��
                      AND   A.���հ��¹�ȣ      *= C.���հ��¹�ȣ
                      AND   A.���Ž����ȣ      *= C.���Ž����ȣ
                      AND   A.BS���������ڵ�    *= C.BS���������ڵ�
                      AND   A.��ȯ���������ڵ�  *= C.��ȯ���������ڵ�
                    GROUP   BY A.���س��
                           ,A.�������ڵ�
                           ,A.���ֹ�ȣ
                           ,B.�������ڵ�
                           ,B.���ֱ����ڵ�
                           ,B.��BIS���ֱ���
                           ,CASE WHEN A.ī��ȸ����ȣ     > '0' THEN A.ī��ȸ����ȣ
                                 WHEN A.��ȯ�ѵ����¹�ȣ > '0' THEN A.��ȯ�ѵ����¹�ȣ
                           ELSE A.���հ��¹�ȣ END
                    ) A
                 , (-- �ѵ����⸸ ����
                    SELECT  ���س��
                           ,���հ��¹�ȣ
                           ,�������ڵ�
                           ,��ǥ�����ڵ�
                           ,���ž��������ڵ�
                           ,ISNULL(��ȭ�ڵ�,'KRW')         ��ȭ
                           ,�����ѵ����ⱸ���ڵ�
                           ,�����ݾ�
                           ,CASE WHEN ISNULL(��ȭ�ڵ�,'KRW') = 'KRW' THEN �����ݾ�
                            ELSE CASE WHEN SUM(��ȭ�ܾ�) > 0 THEN �����ݾ� * (SUM(�����ܾ�)/SUM(��ȭ�ܾ�))
                                 ELSE �����ݾ� * (SUM(�̻���ѵ��ݾ�)/SUM(��ȭ�̻���ѵ��ݾ�))
                                 END
                            END                         ��ȭ�����ݾ�
                    FROM    OT_ECRT���Ű�������
                    WHERE   ���س��             = LEFT(P_��������, 6)
                      AND   �������ڵ�           = '1'
                      AND   �����ѵ����ⱸ���ڵ� > '1'
                      AND  (��ǥ�����ڵ�     IN ('1','3','4','5') OR
                            ���ž��������ڵ� IN ('14','42') OR                             -- ��ȭ����, ��������
                            BS���������ڵ�   IN ('96003511','95001918')                    -- �ſ�ī��,��ȯ�ѵ�����
                           )
                            -- �ü����ڱݴ��� ����
                      AND   BS���������ڵ� NOT IN ('17004411','16006711','17002511'
                                                  ,'17002711','17004911','15007118'
                                                  ,'16007418','16007518')
                      AND   ���⼼���ڵ� NOT IN ('1053','1064')                            -- ���������ڱݴ���,�����о��ڱݴ���
                    GROUP   BY ���س��
                           ,���հ��¹�ȣ
                           ,�������ڵ�
                           ,��ǥ�����ڵ�
                           ,���ž��������ڵ�
                           ,ISNULL(��ȭ�ڵ�,'KRW')
                           ,�����ѵ����ⱸ���ڵ�
                           ,�����ݾ�
                   ) B
            WHERE  A.���س��     *= B.���س��
              AND  A.���հ��¹�ȣ *= B.���հ��¹�ȣ
            GROUP  BY A.���س��
                   ,A.�������ڵ�
                   ,A.���ֹ�ȣ
                   ,A.�������ڵ�
                   ,A.���ֱ����ڵ�
                   ,A.��BIS���ֱ���
            ) S;

      UPDATE   #TEMP_���Ű�������
      SET      ���Ҹź�Ҹű��� = '00'
      ;

      UPDATE   #TEMP_���Ű�������
      SET      ���Ҹź�Ҹű��� = CASE WHEN B.ǥ�ؼҸź�Ҹű����ڵ�='02' THEN '02'
                                       WHEN A.�Ҹź�Ҹű����ڵ�='02'     THEN '02'
                                   ELSE '01' END
      FROM     #TEMP_���Ű�������   A,
               #TEMP B
      WHERE    A.���س�� *= B.���س��
        AND    A.���ֹ�ȣ *= B.���ֹ�ȣ
      ;


ELSE

    --�Ϻ�
    SELECT   A.��������
            ,A.���ֹ�ȣ
            ,A.���հ��¹�ȣ
            ,A.���Ž����ȣ
            ,A.���Ҹź�Ҹű���
            ,A.�Ҹź�Ҹű����ڵ�
            ,CASE WHEN (B.���ֱ����ڵ� = '07' OR B.�ſ��򰡸��������ڵ�  = '51') AND
                        A.���⼼���ڵ� NOT IN ('1076','1091')                              THEN 'Y'
             ELSE 'N' END                    AS ��ȸ���⿩��
            ,B.�������ڵ�
            ,B.���ֱ����ڵ�
            ,B.BIS���ֱ����ڵ�
            ,B.��BIS���ֱ���
            ,B.����
            ,B.�ſ��򰡸��������ڵ� ���������ڵ�
            ,B.�����������
            ,ISNULL(C.�ְſ�ε���㺸��,0) ���ô㺸
            ,'00'  AS ǥ�ؼҸź�Ҹű����ڵ�
    INTO     #TEMP_���Ű�������
    FROM     OT_ECRT���Ű��������Ϻ� A,
             (
                     SELECT   STD_DT
                             ,ACSB_CD
                             ,ACSB_NM
                             ,ACSB_CD4  --��ȭ�����
                             ,ACSB_NM4
                             ,ACSB_CD5  --����ڱݴ����(14002401), �����ڱݴ����(14002501), �����ױ�Ÿ(14002601)
                             ,ACSB_NM5
                             ,ACSB_CD6
                             ,ACSB_NM6
                     FROM     OT_DWA_DD_ACSB_TR
                     WHERE    1=1
                     AND      FSC_SNCD IN ('K','C')
                     AND      ACSB_CD4 IN ('13000801','13001901')       --��ȭ�����,����ä
                     AND      STD_DT   = P_��������
             )       K        ,
             OT_ECRT���Ű������Ϻ� B,
            (SELECT  STD_DT                                  AS ��������
                    ,INTG_ACNO                               AS ���հ��¹�ȣ
                    ,CLN_EXE_NO                              AS ���Ž����ȣ
                    ,BS_ACSB_CD                              AS BS���������ڵ�
                    ,FRXC_TSK_DSCD                           AS ��ȯ���������ڵ�
                    ,SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) AS �ְſ�ε���㺸��
             FROM    TB_SOR_CLM_PDBT_MRT_APRT_TZ  A  --SOR_CLM_ä���ں��㺸�������

             WHERE   STD_DT             = P_��������
               AND   NFFC_UNN_DSCD      = '1'    -- �߾�ȸ���ձ����ڵ�
               AND   MRT_APRT_TPCD      = '01' -- �㺸��������ڵ�
               AND   LQWR_APRT_MRAM     > 0    -- û�갡ġ��д㺸�ݾ� > 0
               AND   MRT_CD             IN ('101','102','103','104','105','109','111','170')
             GROUP   BY STD_DT,INTG_ACNO,CLN_EXE_NO,BS_ACSB_CD,FRXC_TSK_DSCD
             HAVING  SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) > 0
             ) C
    WHERE   A.��������           = P_��������
      AND   A.�������ڵ�         = '1'
      AND   A.��ǥ�����ڵ�      IN ('1','2','3','4','5','6','7')
      AND   A.BS���������ڵ�     = K.ACSB_CD
      AND   A.��������          *= B.�ۼ�������
      AND   A.�������ڵ�        *= B.�������ڵ�
      AND   A.�Ǹ��ȣ          *= B.���Ǹ��ȣ
      AND   A.��������          *= C.��������
      AND   A.���հ��¹�ȣ      *= C.���հ��¹�ȣ
      AND   A.���Ž����ȣ      *= C.���Ž����ȣ
      AND   A.BS���������ڵ�    *= C.BS���������ڵ�
      AND   A.��ȯ���������ڵ�  *= C.��ȯ���������ڵ�
    ;


    SELECT  ��������
           ,���ֹ�ȣ
           ,�������ڵ�
           ,���ֱ����ڵ�
           ,��BIS���ֱ���
           ,CASE WHEN ��BIS���ֱ��� IN ('72','73','80','90') THEN
                 CASE WHEN �ְſ����ܿ��űݾ� > 1000000000    THEN '01' -- 10���ʰ�
                      WHEN �������ڵ� IN ('01','03','07')   THEN '02' -- 01:�������ֹι�ȣ, 03:���λ����, 07:�ܱ����ֹι�ȣ
                      WHEN ���ֱ����ڵ� IN ('02','03','07')   THEN '02' -- 02:�߼ҿܰ�, 03:�߼Һ�ܰ�
                      ELSE '01'
                 END
            ELSE '01'
            END                           AS ǥ�ؼҸź�Ҹű����ڵ�
    INTO    #TEMP
    FROM   (
            SELECT  A.��������
                   ,A.�������ڵ�
                   ,A.���ֹ�ȣ
                   ,A.�������ڵ�
                   ,A.���ֱ����ڵ�
                   ,A.��BIS���ֱ���
                   ,SUM(ISNULL(B.��ȭ�����ݾ�,0))                      AS ��ȭ�����ݾ�
                   ,SUM(A.�����ܾ�)                                    AS �ܾ�
                   ,SUM(ISNULL(A.�ְſ�ε���㺸��,0))                AS �ְſ�ε���㺸�� -- A.������ȿ�㺸�ݾ� �÷��� IRB�����θ� ����ϰ� SA�� ǥ�ش㺸��а�����.
                   ,SUM(CASE WHEN ISNULL(B.��ȭ�����ݾ�,0) > A.�����ܾ� THEN ISNULL(B.��ȭ�����ݾ�,0)
                       ELSE A.�����ܾ� END)                           AS �ѵ����ؿ��űݾ�
                   ,SUM(CASE WHEN ISNULL(B.��ȭ�����ݾ�,0) > A.�����ܾ� THEN ISNULL(B.��ȭ�����ݾ�,0)
                       ELSE A.�����ܾ� END - ISNULL(A.�ְſ�ε���㺸��,0)) AS �ְſ����ܿ��űݾ�
            FROM   (SELECT  A.��������
                           ,A.�������ڵ�
                           ,A.���ֹ�ȣ
                           ,B.�������ڵ�
                           ,B.���ֱ����ڵ�
                           ,B.��BIS���ֱ���
                           ,CASE WHEN A.ī��ȸ����ȣ     > '0' THEN A.ī��ȸ����ȣ
                                  WHEN A.��ȯ�ѵ����¹�ȣ > '0' THEN A.��ȯ�ѵ����¹�ȣ
                           ELSE A.���հ��¹�ȣ END         AS ���հ��¹�ȣ
                           ,SUM(A.�����ܾ�)                 AS �����ܾ�
                           ,SUM(C.�ְſ�ε���㺸��)       AS �ְſ�ε���㺸��
                    FROM    OT_ECRT���Ű��������Ϻ� A,
                            OT_ECRT���Ű������Ϻ� B,
                           (SELECT  STD_DT                                 AS ��������
                                   ,INTG_ACNO                              AS ���հ��¹�ȣ
                                   ,CLN_EXE_NO                               AS ���Ž����ȣ
                                   ,BS_ACSB_CD                               AS BS���������ڵ�
                                   ,FRXC_TSK_DSCD                          AS ��ȯ���������ڵ�
                                   ,SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) AS �ְſ�ε���㺸��
                            FROM    TB_SOR_CLM_PDBT_MRT_APRT_TZ   --SOR_CLM_ä���ں��㺸�������
                            WHERE   STD_DT             = P_��������
                              AND   NFFC_UNN_DSCD     = '1'    -- �߾�ȸ���ձ����ڵ�
                              AND   MRT_APRT_TPCD     = '01' -- �㺸��������ڵ�
                              AND   LQWR_APRT_MRAM     > 0    -- û�갡ġ��д㺸�ݾ� > 0
                              AND   MRT_CD             IN ('101','102','103','104','105','109','111','170')
                            GROUP   BY STD_DT,INTG_ACNO,CLN_EXE_NO,BS_ACSB_CD,FRXC_TSK_DSCD
                            HAVING  SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) > 0
                            ) C
                    WHERE   A.��������           = P_��������
                      AND   A.�������ڵ�         = '1'
                      AND   B.��BIS���ֱ��� IN ('72','73','80','90')
                      AND   A.��������           = B.�ۼ�������
                      AND   A.�������ڵ�         = B.�������ڵ�
                      AND   A.�Ǹ��ȣ           = B.���Ǹ��ȣ
                      AND   A.��������          *= C.��������
                      AND   A.���հ��¹�ȣ      *= C.���հ��¹�ȣ
                      AND   A.���Ž����ȣ      *= C.���Ž����ȣ
                      AND   A.BS���������ڵ�    *= C.BS���������ڵ�
                      AND   A.��ȯ���������ڵ�  *= C.��ȯ���������ڵ�
                    GROUP   BY A.��������
                           ,A.�������ڵ�
                           ,A.���ֹ�ȣ
                           ,B.�������ڵ�
                           ,B.���ֱ����ڵ�
                           ,B.��BIS���ֱ���
                           ,CASE WHEN A.ī��ȸ����ȣ     > '0' THEN A.ī��ȸ����ȣ
                                 WHEN A.��ȯ�ѵ����¹�ȣ > '0' THEN A.��ȯ�ѵ����¹�ȣ
                           ELSE A.���հ��¹�ȣ END
                    ) A
                 , (-- �ѵ����⸸ ����
                    SELECT  ��������
                           ,���հ��¹�ȣ
                           ,�������ڵ�
                           ,��ǥ�����ڵ�
                           ,���ž��������ڵ�
                           ,ISNULL(��ȭ�ڵ�,'KRW')         ��ȭ
                           ,�����ѵ����ⱸ���ڵ�
                           ,�����ݾ�
                           ,CASE WHEN ISNULL(��ȭ�ڵ�,'KRW') = 'KRW' THEN �����ݾ�
                            ELSE CASE WHEN SUM(��ȭ�ܾ�) > 0 THEN �����ݾ� * (SUM(�����ܾ�)/SUM(��ȭ�ܾ�))
                                 ELSE �����ݾ� * (SUM(�̻���ѵ��ݾ�)/SUM(��ȭ�̻���ѵ��ݾ�))
                                 END
                            END                         ��ȭ�����ݾ�
                    FROM    OT_ECRT���Ű��������Ϻ�
                    WHERE   ��������             = P_��������
                      AND   �������ڵ�           = '1'
                      AND   �����ѵ����ⱸ���ڵ� > '1'
                      AND  (��ǥ�����ڵ�     IN ('1','3','4','5') OR
                            ���ž��������ڵ� IN ('14','42') OR                             -- ��ȭ����, ��������
                            BS���������ڵ�   IN ('96003511','95001918')                    -- �ſ�ī��,��ȯ�ѵ�����
                           )
                            -- �ü����ڱݴ��� ����
                      AND   BS���������ڵ� NOT IN ('17004411','16006711','17002511'
                                                  ,'17002711','17004911','15007118'
                                                  ,'16007418','16007518')
                      AND   ���⼼���ڵ� NOT IN ('1053','1064')                            -- ���������ڱݴ���,�����о��ڱݴ���
                    GROUP   BY ��������
                           ,���հ��¹�ȣ
                           ,�������ڵ�
                           ,��ǥ�����ڵ�
                           ,���ž��������ڵ�
                           ,ISNULL(��ȭ�ڵ�,'KRW')
                           ,�����ѵ����ⱸ���ڵ�
                           ,�����ݾ�
                   ) B
            WHERE  A.��������     *= B.��������
              AND  A.���հ��¹�ȣ *= B.���հ��¹�ȣ
            GROUP  BY A.��������
                   ,A.�������ڵ�
                   ,A.���ֹ�ȣ
                   ,A.�������ڵ�
                   ,A.���ֱ����ڵ�
                   ,A.��BIS���ֱ���
            ) S;

      UPDATE   #TEMP_���Ű�������
      SET      ���Ҹź�Ҹű��� = '00'
      ;

      UPDATE   #TEMP_���Ű�������
      SET      ���Ҹź�Ҹű��� = CASE WHEN B.ǥ�ؼҸź�Ҹű����ڵ�='02' THEN '02'
                                       WHEN A.�Ҹź�Ҹű����ڵ�='02'     THEN '02'
                                   ELSE '01' END
      FROM     #TEMP_���Ű�������   A,
               #TEMP B
      WHERE    A.�������� *= B.��������
        AND    A.���ֹ�ȣ *= B.���ֹ�ȣ
      ;

END IF;


-- ����


SELECT      A.INTG_ACNO                  AS    ���հ��¹�ȣ
 ...
 ...
           ,CASE WHEN  V.���Ҹź�Ҹ� = '02'  THEN '1. �Ҹ�' ELSE  '2. ��Ҹ�' END AS �Ҹź�Ҹű���_10�����  -- ���ִ� 10���̻� ��Ҹű���
           ,CASE WHEN  V.�Ҹź�Ҹ�   = '02'  THEN '1. �Ҹ�' ELSE  '2. ��Ҹ�' END AS �Ҹź�Ҹű���_5�����    -- ���ִ� 5���̻� ��Ҹű���

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A  --DWA_���տ��ű⺻
 ...
 ...
LEFT OUTER JOIN
            (
                SELECT   DISTINCT A.���հ��¹�ȣ,A.���Ҹź�Ҹű��� AS ���Ҹź�Ҹ�, A.�Ҹź�Ҹű����ڵ�  AS  �Ҹź�Ҹ�
                FROM     #TEMP_���Ű�������   A
                WHERE    A.���Ҹź�Ҹű��� <>  '01'  OR A.�Ҹź�Ҹű����ڵ� <>  '01'    -- �����ضǴ� �ű������� �Ҹſ����ΰŸ� (������ �ּ�ȭ, ���ʿ��� ���ǹ��ƴ�)
            ) V
            ON   A.INTG_ACNO  =  V.���հ��¹�ȣ



//}

//{  #MESSAGE #�޼���
MESSAGE p_���� TYPE ACTION TO CLIENT;
//}

//{  #�Ű�  #�絵
���Ű����ڵ� 081

//========================================================================================
//
//                       �絵���� ������ ����
//
//=========================================================================================

SELECT      A.CLN_ACNO       AS  ���¹�ȣ
           ,A.ACN_ADM_BRNO   AS  ���°�������ȣ
           ,B.CLN_EXE_NO     AS  �����ȣ
           ,C.SLN_PCS_DT     AS  �Ű�ó������
           ,C.SLN_AMT        AS  �Ű��ݾ�

INTO        #�絵             -- DROP TABLE #�絵

FROM        TB_SOR_LOA_ACN_BC       A   -- SOR_LOA_���±⺻

JOIN        TB_SOR_LOA_EXE_BC       B   -- SOR_LOA_����⺻
            ON   A.CLN_ACNO      =  B.CLN_ACNO
            AND  B.CLN_ACN_STCD  =  '1'

JOIN        TB_SOR_LOA_KHFC_LN_DL   C   --LOA_�ѱ����ñ�����������
            ON  B.CLN_ACNO    = C.CLN_ACNO
            AND B.CLN_EXE_NO  = C.CLN_EXE_NO

WHERE       1=1
AND         A.AGR_DT      BETWEEN P_������  AND P_������
AND         A.LN_SBCD     =  '081'      -- ��������ڵ�(081:�絵����)
AND         A.PDCD NOT IN ('20011113701011','20012113701011','20051105304011','20051105304021',
                           '20051108202001','20051113701011','20055000800001','20055101704001',
                           '20056105303011','20056105303021','20056113701011','20056113701021',
                           '20052105304011','20053105304011','20122103303001','20122103307001',
                           '20125103303001','20125103307001')                                    -- �ߵ��ݴ��� ����
AND         A.MNMG_MRT_CD      IN  ('101','102','103','104','105','109','170')
;


//}

//{  #���ͳ� #����Ʈ�� #��������

SELECT

           ,CASE WHEN D.�Ǹ��ȣ IS NOT NULL AND D.������   < '2' THEN 'O' ELSE 'X' END ���ͳݹ�ŷ��������
           ,CASE WHEN E.�Ǹ��ȣ IS NOT NULL AND E.����ϻ��� < '9' THEN 'O' ELSE 'X' END ����Ʈ����ŷ��������

LEFT OUTER JOIN
            (-- ���ͳݹ�ŷ ��������
             SELECT   RMN_NO     AS �Ǹ��ȣ
                     ,CUST_STCD  AS ������
             FROM     TB_PB_CUST_INF       -- PB_������
             WHERE    TSK_DC_CD = '3'    -- 3:���ͳݹ�ŷ
            )    D
            ON   A.RNNO  = D.�Ǹ��ȣ

LEFT OUTER JOIN
            (-- ����Ϲ�ŷ ��������
             SELECT   RMN_NO    AS �Ǹ��ȣ
                     ,MBL_STCD  AS ����ϻ���
             FROM     TB_PB_MBL_CUST_INF  -- PB_����ϰ�����
             WHERE    MBL_DC_CD = '3'    -- 3:����Ʈ��
            ) E
            ON   A.RNNO  = E.�Ǹ��ȣ
//}

//{  #DTI
-- UP_DWZ_����_N0254_���ô㺸�������θ�� �Ϻ�
           ,ISNULL(T10.DTI_RT,0)         AS DTI����

LEFT OUTER JOIN
            (
              SELECT    A.CLN_ACNO
                       ,D.DTI_RT
              FROM      DWZOWN.TB_SOR_PLI_CLN_APC_BC       A --PLI_���Ž�û�⺻
                       ,(SELECT   A.CLN_ACNO        AS ���Ű��¹�ȣ
                                 ,MAX(A.CLN_APC_NO) AS ���Ž�û��ȣ_MAX
                         FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          --PLI_���Ž�û�⺻
                         WHERE    A.CLN_APC_PGRS_STCD = '04'              --���Ž�û��������ڵ�:04(����Ϸ�)
                         AND      A.CLN_ACNO          > '0'               --���Ű��¹�ȣ
                         AND      A.CLN_APC_DSCD NOT IN ('11','12','13')  --���Ž�û�����ڵ�:��������
                         AND      A.CLN_APRV_DT       <= P_��������
                         GROUP BY A.CLN_ACNO
                        ) B
                       ,DWZOWN.TB_SOR_PLI_HMRT_APC_TR      D              --PLI_���ô㺸��û����
              WHERE     A.CLN_APC_NO    = B.���Ž�û��ȣ_MAX
              AND       A.CLN_APC_NO    = D.CLN_APC_NO
            )     T10
            ON    A.���հ��¹�ȣ    =  T10.CLN_ACNO


//}

//{  #LTV
-- UP_DWZ_����_N0254_���ô㺸�������θ��
           ,CASE WHEN T7.CLN_ACNO IS NULL  THEN ISNULL(T8.�űԽ�LTV, 0)
                 ELSE CASE WHEN A.�����ѵ����ⱸ���ڵ� = '1' THEN ISNULL(T7.RMD_STD_RT, 0)
                           ELSE ISNULL(T7.LMT_STD_RT, 0)  END
            END                        AS ���ô㺸�������


LEFT OUTER JOIN
            ( -- ���Ű��¹�ȣ�� MAX(���Ž����ȣ)�� ����Ÿ ����
               SELECT   TA.*
               FROM    (
                        SELECT  STD_YM                                                     --���س��
                               ,CLN_ACNO                                                   --���Ű��¹�ȣ
                               ,RMD_STD_RT
                               ,LMT_STD_RT
                               ,RANK() OVER(PARTITION BY STD_YM, CLN_ACNO ORDER BY STD_YM, CLN_ACNO, CLN_EXE_NO DESC) AS CLN_EXE_NO  --���Ž����ȣ
                        FROM    DWZOWN.TB_SOR_CLM_LTV_PSST_TZ
                        WHERE   STD_YM  = (SELECT   MAX(STD_YM)
                                           FROM     DWZOWN.TB_SOR_CLM_LTV_PSST_TZ
                                           WHERE    STD_YM <= LEFT('20160314', 6))
                       ) TA
               WHERE    TA.CLN_EXE_NO = 1
            )                                                T7                      --SOR_CLM_���ô㺸���������Ȳ����
            ON   A.���հ��¹�ȣ  =  T7.CLN_ACNO

LEFT OUTER JOIN
            (
               SELECT   A.���¹�ȣ                                   --�űԽ�
                       ,CASE WHEN A.LTV����  IS NULL  THEN 0
                             ELSE A.LTV���� * 100
                             END  AS �űԽ�LTV
               FROM    (SELECT   A.CLN_ACNO              AS ���¹�ȣ
                                ,A.CLN_APC_NO            AS ���Ž�û��ȣ
                                ,B.LTV                   AS LTV����
                        FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC   A          --SOR_PLI_���Ž�û�⺻ --> ���νɻ�
                                ,DWZOWN.TB_SOR_PLI_LTV_CALC_TR  B          --SOR_PLI_���ô㺸����������⳻��
                        WHERE    A.CLN_APC_DSCD      < '10'     --�ű�
                        AND      A.CLN_ACNO          IS NOT NULL
                        AND      A.CLN_APC_PGRS_STCD IN ('03','04','13')     --���Ž�û��������ڵ�(04:����Ϸ� ,13:�����Ϸ�)
                        AND      A.NFFC_UNN_DSCD     = '1'               --�߾�ȸ���ձ����ڵ�
                        AND      A.CLN_APC_NO        *= B.CLN_APC_NO
                        ) A
                      ,(SELECT   A.CLN_ACNO              AS ���¹�ȣ
                                ,MAX(A.CLN_APC_NO)       AS ���Ž�û��ȣ
                        FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC   A          --SOR_PLI_���Ž�û�⺻ --> ���νɻ�
                                ,DWZOWN.TB_SOR_PLI_LTV_CALC_TR  B          --SOR_PLI_���ô㺸����������⳻��
                        WHERE    A.CLN_APC_DSCD      < '10'       --�ű�
                        AND      A.APC_DT            <= '20160314'
                        AND      A.CLN_ACNO          IS NOT NULL
                        AND      A.CLN_APC_PGRS_STCD IN ('03','04','13')     --���Ž�û��������ڵ�(04:����Ϸ� ,13:�����Ϸ�)
                        AND      A.NFFC_UNN_DSCD     = '1'                   --�߾�ȸ���ձ����ڵ�
                        AND      A.CLN_APC_NO        *= B.CLN_APC_NO
                        GROUP BY ���¹�ȣ
                        ) B
               WHERE    A.���¹�ȣ     = B.���¹�ȣ
               AND      A.���Ž�û��ȣ = B.���Ž�û��ȣ
            )                                               T8                    --SOR_PLI_���ô㺸����������⳻��
            ON    A.���հ��¹�ȣ  =  T8.���¹�ȣ


//}

//{  #�ϰ����ܾ�  #�ܾ׺���


CREATE TABLE #����
(
    ����          INT,
    ���հ��¹�ȣ  CHAR(35),
    ����ȣ        CHAR(4),
    ���������ڵ�  CHAR(8),
    ������        NUMERIC(20,2)
);


LOAD   TABLE  #����
(
    ����          '|',
    ���հ��¹�ȣ  '|',
    ����ȣ        '|',
    ���������ڵ�  '|',
    ������        '\x0a'
)   FROM '/nasdat/edw/in/etc/�����ݾ�.dat'
QUOTES OFF
ESCAPES OFF
--SKIP 1   -- Ÿ��Ʋ ����
--BLOCK FACTOR 3000
FORMAT ASCII
;

UPDATE      OT_DWA_DD_ACN_RMD_TZ   A
SET         A.FC_RMD = A.FC_RMD + B.������

--SELECT      A.*, B.����,B.������
--FROM        OT_DWA_DD_ACN_RMD_TZ   A


UPDATE      OT_DWA_DD_ACN_RMD_TZ   A
SET         A.FC_RMD   =  A.FC_RMD + B.������

FROM
            (
              SELECT      A.STD_DT                    -- PK
                         ,A.INTG_CNTT_NO              -- PK
                         ,A.INTG_CNTT_TSK_DSCD        -- PK
                         ,A.ACSB_CD                   -- PK
                         ,A.ACCT_PCS_BRNO             -- PK
                         ,A.CUST_NO                   -- PK
                         ,A.JONT_CD                   -- PK
                         ,A.CRCD                      -- PK
                         ,A.FRXC_TSK_DSCD             -- PK
                         ,A.INTG_ACNO
                         ,A.ACN_SNO
                         ,A.FC_RMD
                         ,B.����
                         ,B.������

              FROM        OT_DWA_DD_ACN_RMD_TZ   A

              JOIN        #����         B
                          ON     A.INTG_ACNO       = B.���հ��¹�ȣ
                          AND    A.ACCT_PCS_BRNO   = B.����ȣ
                          AND    A.ACSB_CD         = B.���������ڵ�
              WHERE       1=1
              AND         A.STD_DT = '20160314'
            )     B

WHERE       1=1
AND         A.STD_DT                  =  B.STD_DT
AND         A.INTG_CNTT_NO            =  B.INTG_CNTT_NO
AND         A.INTG_CNTT_TSK_DSCD      =  B.INTG_CNTT_TSK_DSCD
AND         A.ACSB_CD                 =  B.ACSB_CD
AND         A.ACCT_PCS_BRNO           =  B.ACCT_PCS_BRNO
AND         A.CUST_NO                 =  B.CUST_NO
AND         A.JONT_CD                 =  B.JONT_CD
AND         A.CRCD                    =  B.CRCD
AND         A.FRXC_TSK_DSCD           =  B.FRXC_TSK_DSCD
;

//}

//{ #���̺�SIZE
 declare local temporary table iq_tablesize_temp (
                Ownername       varchar(128),
                Tablename       varchar(128),
                Columns         char(20),
                KBytes          char(20),
                Pages           char(20),
                CompressedPages char(20),
                NBlocks         char(20)
        ) in SYSTEM on commit preserve rows;

truncate table iq_tablesize_temp;

iq utilities main into iq_tablesize_temp table size OT_DWA_DD_ACN_RMD_TZ_BAK;
//}

//{ #SOR_FEC_��ȯ�ŷ�����  #��ȯ�ŷ�����  #�۱� #ȯ��
-- �۱ݹ� ȯ�������� TB_SOR_FEC_FRXC_TR_TR(SOR_FEC_��ȯ�ŷ�����) �� �����Ҷ� ���ŷ��� ���εǾ� �Ǽ��� �����ǰ� �ʰ� �����ؾ���
-- �۱ݰ� ȯ���� �ŷ��������� REF ���� ù�ŷ��� ���ŷ���� ���� �ȴ�
--  ù�ŷ��� ���ŷ��� ���°� ������ ���ͳݰŷ�, ATM�ŷ���� �پ��� ä�ο��� �����Ƿ� ��ǿ� ���� �ɷ����� �Ѵ�

-- 1.ȯ�� : INP_SCRN_ID �� �ܱ���ȭ ���ŷ��� �μ��ŷ�(���庯���) �� �����ϴ� ���, Ȯ���� ���غ����� TR_SNO   =  1 �� �����͵� �ɰ� ����
--     - 5351SC00(�������),5352SC00(����ŵ�),5353SC00(���뵿�ø��Ըŵ�) �Ǵ� ��������� ���ŷ�, ���������� ���庯��� ���ŷ��� �ƴ϶�� �����

SELECT      A.REF_NO                   AS  REF��ȣ
           ,A.TR_BRNO                  AS  ����ȣ
           ,A.CRCD                     AS  ��ȭ�ڵ�
           ,A.EFM_AMT                  AS  ȯ���ݾ�

INTO        #TEMP  -- DROP TABLE #TEMP

FROM        DWZOWN.TB_SOR_INX_EFM_BC A              -- SOR_INX_ȯ���⺻
JOIN        DWZOWN.TB_SOR_FEC_FRXC_TR_TR   H          --SOR_FEC_��ȯ�ŷ�����
            ON     A.REF_NO = H.REF_NO
            --AND         H.TR_SNO   =  1                                  -- �ű԰ŷ��� �ŷ��Ϸù�ȣ�� 1�ΰ����� (�ڰ���) -- CASE  1
            AND    (  H.INP_SCRN_ID IS NULL OR H.INP_SCRN_ID = '' OR H.INP_SCRN_ID IN ('5351SC00','5352SC00','5353SC00')   )  -- CASE 2

WHERE       1=1
AND         A.TR_DT BETWEEN '20160101' AND '20160331'
AND         A.EFM_DSCD IN ('FS','FB')  -- �ŵ�,����
AND         A.NFFC_UNN_DSCD  = '1'     -- 1:�߾�ȸ
AND         A.FRXC_LDGR_STCD = '1'



-- 2.��߼۱� : TR_SNO   =  1  �ΰ��� �������� �� (����ŷ� ���ͳݼ۱ݵ ���� ����)
--     - �ܸ��ŷ��� �۷ι�����ī��۱ݰǸ� �������� ������ �Ʒ�ó�� ����
--            H.TR_SNO   =  1                                  -- �ű԰ŷ��� �ŷ��Ϸù�ȣ�� 1�ΰ����� (�ڰ���)
--       AND  (     H.INP_SCRN_ID = '5401SC00'
--               OR H.CHNL_TPCD   = 'SIBT'                     -- �۷ι�����ī��۱ݵ� ����
--            )

SELECT      A.REF_NO                               AS REF��ȣ
           ,A.TR_BRNO                              AS ����ȣ
           ,A.CRCD                                 AS ��ȭ�ڵ�
           ,A.OWMN_AMT                             AS ��߼۱ݱݾ�

INTO        #TEMP  -- DROP TABLE #TEMP

FROM        DWZOWN.TB_SOR_INX_OWMN_BC      A          -- SOR_INX_��߼۱ݱ⺻

JOIN        DWZOWN.TB_SOR_FEC_FRXC_TR_TR   H          --SOR_FEC_��ȯ�ŷ�����
            ON    A.REF_NO = H.REF_NO
            AND   H.TR_SNO   =  1                                  -- �ű԰ŷ��� �ŷ��Ϸù�ȣ�� 1�ΰ����� (�ڰ���)
            --AND (     H.INP_SCRN_ID = '5401SC00'
            --       OR H.CHNL_TPCD   = 'SIBT'                     -- �۷ι�����ī��۱ݵ� ����
            --    )
WHERE       1=1
AND         A.TR_DT BETWEEN '20160101' AND '20160331'
AND         A.FRXC_LDGR_STCD   IN ('1','9')      -- ��ȯ��������ڵ�(1:����,3:����,4:����,5:���,6:����,9:����,7:���,8:�������,2:����)




-- 3.Ÿ�߼۱� : TSK_PGM_NM      = 'INXO413102'    -- �����ް� (�̰����� �� �����ŷ��� ���ܽ�Ű�� ���� ,�����  �̰�����: INXO413302)

SELECT      A.REF_NO                               AS REF��ȣ
           ,A.RCV_BRNO                             AS ����ȣ
           ,A.CRCD                                 AS ��ȭ�ڵ�
           ,A.INMY_AMT                             AS Ÿ�߼۱ݱݾ�

INTO        #TEMP  -- DROP TABLE #TEMP

FROM        DWZOWN.TB_SOR_INX_INMY_BC          A           -- SOR_INX_Ÿ�߼۱ݱ⺻

JOIN        DWZOWN.TB_SOR_FEC_FRXC_TR_TR       H           --SOR_FEC_��ȯ�ŷ�����
            ON    A.REF_NO = H.REF_NO
            AND   H.TSK_PGM_NM      = 'INXO413102'          -- �����ް� (�̰����� �� �����ŷ��� ���ܽ�Ű�� ���� , �̰�����: INXO413302)
            AND   H.FRXC_LDGR_STCD  = '1'

WHERE       1=1
AND         A.DFRY_DT BETWEEN '20160101' AND '20160331'
AND         A.FRXC_LDGR_STCD  = '9'                        --��ȯ��������ڵ� 9:����
AND         A.RMT_KDCD IN ('1','3')                        --�۱������ڵ� AS IS : a.���� in (1,3)
AND         A.HNB_DSCD = '1'                               --�����ܱ����ڵ�=���� AS IS : a.�����ܱ���  = 0

//}

//{ #�������ڵ� #�����ܻ����ڵ� #��ȯ�ŷ�����
-- �۱ݹ� ȯ���� �����ܻ����ڵ尡 ��ȯ�ŷ������� ������ ���庯������� �����ܻ����ڵ尡 �ٲ�Ƿ� �������� �����;� �Ѵ�

SELECT

FROM        DWZOWN.TB_SOR_INX_OWMN_BC A               -- SOR_INX_��߼۱ݱ⺻

LEFT OUTER JOIN
            (
               SELECT  A.REF_NO,A.TR_DT,A.INTD_RSCD,A.NE_INTD_RSCD
               FROM    DWZOWN.TB_SOR_INX_INTD_RSN_TR_TR    A
               JOIN    (
                         SELECT   AA.REF_NO, MAX(AA.RSN_SNO) AS MAX_RSN_SNO
                         FROM     DWZOWN.TB_SOR_INX_INTD_RSN_TR_TR   AA
                         WHERE    AA.FRXC_LDGR_STCD = '1'   -- ����
                         AND      (
                                   AA.INTD_RSCD IS NOT NULL  OR
                                   AA.NE_INTD_RSCD IS NOT NULL
                                  )
                         GROUP BY AA.REF_NO
                        )     B
                        ON    A.REF_NO  = B.REF_NO
                        AND   A.RSN_SNO = B.MAX_RSN_SNO
               WHERE    A.FRXC_LDGR_STCD = '1'   -- ����
            )        D
            ON       A.REF_NO   = D.REF_NO


WHERE       1=1

AND         (                 -- �����ܰŷ����
              (
                     D.TR_DT <= '20150331'
                AND  ( D.INTD_RSCD IS NULL OR D.INTD_RSCD NOT IN ('011','012','013','014','015','016','017','019') )
              )     OR
              (      D.TR_DT >= '20150401'
                AND  ( D.NE_INTD_RSCD IS NULL OR LEFT(D.NE_INTD_RSCD,1) NOT IN ('1','2') )
              )
            )

//}


//{  #�ŷ��������ڵ�

select CLN_TR_DTL_KDCD      as  ���Űŷ��������ڵ�
      ,CLN_TR_DTL_KD_CD_NM  as  ���Űŷ��������ڵ��
      ,CLN_TR_KDCD          as   ���Űŷ������ڵ�
from TB_SOR_LOA_TR_DTL_KDCD_BC  a      --  SOR_LOA_�ŷ��������ڵ�⺻
 where  A.CLN_TR_DTL_KDCD IN ('3001','3002','3003','3004','3101','3102','3103','3201','3202','3301','3302','3601')


//}

//{   #���ʾ�����
-- ������� + ��ȯ�ѵ����� + �ſ�ī��ȸ������ (GPC ���¿���, KPS���¿���) ������ ����������

SELECT      A.*
INTO        #���¾���  -- DROP TABLE #���¾���
FROM
            (
             SELECT      A.����
                        ,A.����ȣ
                        ,B.���¹�ȣ
                        ,B.����ȣ
                        ,B.��������
                        ,ROW_NUMBER() OVER(PARTITION BY B.����ȣ ORDER BY B.�������� ASC) AS ����
             FROM        #����    A
             LEFT OUTER JOIN
                         ( -- ����
                           SELECT      A.����                     AS   ����
                                      ,A.����ȣ                 AS   ����ȣ
                                      ,B.CLN_ACNO                 AS   ���¹�ȣ
                                      ,B.ACN_ADM_BRNO             AS   ����ȣ
                                      ,B.AGR_DT                   AS   ��������
                           FROM        #����    A
                           JOIN        TB_SOR_LOA_ACN_BC  B        --  SOR_LOA_���±⺻
                                       ON   A.����ȣ     = B.CUST_NO
                                       AND  B.CLN_ACN_STCD <> '3'  -- ��Ұ��� ����

                           UNION ALL
                           -- ��ȯ  (���տ����� �����ϰ� �ٸ�)
                           SELECT      A.����                     AS   ����
                                      ,A.����ȣ                 AS   ����ȣ
                                      ,B.FRXC_LMT_ACNO            AS   ���¹�ȣ
                                      ,B.ENR_BRNO                 AS   ����ȣ
                                      ,B.AGR_DT                   AS   ��������

                           FROM        #����    A
                           JOIN        TB_SOR_FEC_CLN_LMT_BC  B        --  SOR_FEC_�����ѵ��⺻
                                       ON   A.����ȣ     = B.CUST_NO
                                       AND  B.FRXC_LDGR_STCD NOT IN ('4','5') -- ����,��Ұ��� ����

                           UNION ALL
                           -- �ſ�ī��
                           SELECT      A.����                     AS   ����
                                      ,A.����ȣ                 AS   ����ȣ
                                      ,B.CRD_MBR_NO               AS   ���¹�ȣ
                                      ,B.CRD_MBR_ADM_BRNO         AS   ����ȣ
                                      ,B.MBR_NW_DT                AS   ��������

                           FROM        #����    A
                           JOIN        TB_SOR_CLT_MBR_BC    B          -- SOR_CLT_ȸ���⺻
                                       ON   A.����ȣ     = B.CUST_NO

                           UNION ALL
                           -- GPC
                           SELECT      A.����                     AS   ����
                                      ,A.����ȣ                 AS   ����ȣ
                                      ,B.ī���ȣ                 AS   ���¹�ȣ
                                      ,B.��������ȣ               AS   ����ȣ
                                      ,SUBSTR(B.�ű��Ͻ�,1,8)     AS   ��������

                           FROM        #����    A
                           JOIN        TB_SOR_CUS_MAS_BC    AA          --SOR_CUS_���⺻
                                       ON   A.����ȣ    = AA.CUST_NO
                           JOIN        TB_CCCMGPCī������   B
                                       ON   AA.CUST_RNNO  = B.�Ǹ��ȣ

                           UNION ALL
                           -- KPS
                           SELECT      A.����                     AS   ����
                                      ,A.����ȣ                 AS   ����ȣ
                                      ,B.ī���ȣ                 AS   ���¹�ȣ
                                      ,B.�ű�����ȣ               AS   ����ȣ
                                      ,SUBSTR(B.�ű��Ͻ�,1,8)     AS   ��������

                           FROM        #����    A
                           JOIN        TB_SOR_CUS_MAS_BC    AA          --SOR_CUS_���⺻
                                       ON   A.����ȣ    = AA.CUST_NO
                           JOIN        TB_CCCMKPSī������   B
                                       ON   AA.CUST_RNNO     = B.�Ǹ��ȣ

                         )       B
                         ON      A.����  =  B.����
            )       A

WHERE       1=1
AND         ����  = 1
;

//}

//{  #�űԽ� ������ #�����򰡱�� #�㺸�������� #�űԽ� �ε���㺸


-- CASE 1  �űԽ�û�� �پ��ִ� �ε���㺸(���迩��)
SELECT   A.����
        ,A.���¹�ȣ

        ,C.MRT_RCG_RT     �㺸��������
        ,D.MRT_NO         �㺸��ȣ
        ,D.APSL_NO        ������ȣ

        ,F.APSL_SMTL_AMT  �����հ�ݾ�
        ,CASE WHEN E.EVL_MTH_DSCD IN('03','04') THEN TRIM(Y.ADM_HDCD_NM) || '('  || TRIM(ISNULL(Y.ADM_HDCD,'')) || ')'
              ELSE '��ü����'
         END    �����򰡱��

--        ,H.MRT_NO         �㺸��ȣ_
--        ,H.MRT_EVL_AMT    �㺸�򰡱ݾ�
--        ,H.MRT_RCG_RT     �㺸��������_

        ,TRIM(E.MPSD_NM) || ' ' || TRIM(E.CCG_NM) || ' ' || TRIM(E.EMD_NM) || ' ' || TRIM(E.LINM) || ' ' ||  TRIM(E.THG_SIT_DTL_ADR) AS   ���Ǽ�����

FROM     #������          A

JOIN     TB_SOR_PLI_CLN_APC_BC      B   -- SOR_PLI_���Ž�û�⺻
         ON  A.���¹�ȣ        = B.CLN_ACNO
         AND B.CLN_APC_DSCD    = '01'    -- ���Ž�û�����ڵ�(01:�ű�)

JOIN     DWZOWN.TB_SOR_CLM_CLN_LNK_TR   C  -- SOR_CLM_���ſ��᳻��
         ON   B.CLN_APC_NO  = C.CLN_APC_NO
         AND  C.CLN_LNK_STCD      = '02'    -- ���ſ�������ڵ�(02:������) ������¿��� ������°� ���������� �����ϰ� ���

JOIN     TB_SOR_CLM_STUP_BC       D  -- SOR_CLM_�����⺻
         ON   C.STUP_NO   =  D.STUP_NO

JOIN     TB_SOR_CLM_REST_MRT_BC     E   --SOR_CLM_�ε���㺸�⺻
         ON   D.MRT_NO  = E.MRT_NO

LEFT OUTER JOIN
         TB_SOR_CLM_APSL_BC   F   -- SOR_CLM_�����⺻
         ON   D.APSL_NO  = F.APSL_NO

LEFT OUTER JOIN
         TB_SOR_CLM_MRT_CMN_CD_BC   Y   -- SOR_CLM_�㺸�����ڵ�⺻
         ON     E.NFFC_UNN_DSCD =  Y.NFFC_UNN_DSCD
         AND    E.APSL_EVL_ORCD =  Y.ADM_HDCD
         AND    Y.ADM_TGT_CD    = '100001'

-- �򰡱ݾװ� �㺸���������� �Ʒ��� ���� SOR_PLI_��û�����㺸������ �̿��ϸ� ������ ���Ҽ��ִ�
--LEFT OUTER JOIN
--         TB_SOR_PLI_APC_POT_MRT_TR  H   -- SOR_PLI_��û�����㺸����
--         ON  B.CLN_APC_NO = H.CLN_APC_NO
--         AND H.MRT_TPCD  = '1'   -- �ε���

WHERE    1=1
ORDER BY 1,2
;


-- CASE 2 ������� �з����, �ð迭���̺��� �̿��� �ε���㺸��������
SELECT      A.STD_YM           AS ���س��
           ,A.MRT_NO           AS �㺸��ȣ
           ,B.ACN_DCMT_NO      AS ���Ű��¹�ȣ
           ,C.JUD_SMTL_AMT     AS �ɻ��հ�ݾ�
           ,C.EVL_MTH_DSCD     AS �򰡹�������ڵ�
           ,CASE D.EVL_RSRC_DSCD  WHEN '01' THEN  '1'    -- 'KB�ü�_��������'
                                  WHEN '02' THEN  '2'    -- 'TECH�ü�_�ѱ�������'
                                  WHEN '09' THEN  '3'    -- '�ܺΰ����򰡱��'
                                  ELSE '7'       -- '��Ÿ'
            END                AS �����򰡱��

           ,ROW_NUMBER() OVER (PARTITION BY LEFT(A.STD_YM,4), B.ACN_DCMT_NO ORDER BY A.STUP_AMT DESC) AS ��ǥ_�㺸

INTO        #�������  -- DROP TABLE #�������

FROM        TT_SOR_CLM_MM_STUP_BC     A    --SOR_CLM_�������⺻

JOIN        TT_SOR_CLM_MM_CLN_LNK_TR  B    --SOR_CLM_�����ſ��᳻��
            ON   A.STD_YM   =  B.STD_YM
            AND  A.STUP_NO  =  B.STUP_NO       --������ȣ
            AND  B.ACN_DCMT_NO   IN (SELECT DISTINCT ���հ��¹�ȣ  FROM #�������)
            AND  B.CLN_LNK_STCD  IN ('02','03')     --���ſ�������ڵ�(02:����,03:��������)
            AND  B.NFFC_UNN_DSCD = '1'

JOIN        TT_SOR_CLM_MM_REST_MRT_BC  C        --SOR_CLM_���ε���㺸�⺻
            ON    A.STD_YM        = C.STD_YM
            AND   A.MRT_NO        = C.MRT_NO
            AND   C.MRT_STCD      = '02'

JOIN        TB_SOR_CLM_BLD_MRT_APSL_DL      D   -- SOR_CLM_�ǹ��㺸������
            ON    C.APSL_NO       = D.APSL_NO

WHERE       A.STD_YM        IN (  SELECT     LEFT(MAX(STD_DT),6)
                                   FROM      OT_DWA_INTG_CLN_DT_BC
                                   WHERE     1=1
                                   AND       STD_DT  BETWEEN '20120101' AND '20160831'
                                   GROUP BY  LEFT(STD_DT,6)
                                )
AND         A.NFFC_UNN_DSCD = '1'             --�߾�ȸ���ձ����ڵ�
AND         A.STUP_STCD     = '02'            --���������ڵ�(02:������)
;


-- CASE 2-1 ���ſ������̺��� �ð迭���̺�� �������̺��� ���ļ� ����Ҷ�
SELECT      DISTINCT
            A.STD_YM  AS ���س��
           ,A.MRT_NO           AS �㺸��ȣ
           ,B.ACN_DCMT_NO      AS ���Ű��¹�ȣ
           ,C.JUD_SMTL_AMT     AS �ɻ��հ�ݾ�
           ,C.EVL_MTH_DSCD     AS �򰡹�������ڵ�
           --,RANK() OVER (PARTITION BY A.STD_YM, B.ACN_DCMT_NO ORDER BY C.JUD_SMTL_AMT  DESC, B.CLN_APC_NO, A.STUP_NO, A.MRT_NO) AS ��ǥ_�㺸
FROM        TT_SOR_CLM_MM_STUP_BC     A    --SOR_CLM_�������⺻
           ,(SELECT   STD_YM
                     ,STUP_NO
                     ,CLN_APC_NO
                     ,ACN_DCMT_NO
             FROM     #TEMP_���ſ���
             UNION ALL
             SELECT   STD_YM
                     ,STUP_NO
                     ,CLN_APC_NO
                     ,ACN_DCMT_NO
             FROM     TT_SOR_CLM_MM_CLN_LNK_TR       --SOR_CLM_�����ſ��᳻��
             WHERE    STD_YM        IN ('201212','201312','201408')
             AND      CLN_LNK_STCD  IN ('02','03')     --���ſ�������ڵ�(02:����,03:��������)
             AND      NFFC_UNN_DSCD = '1'
            )   B   --SOR_CLM_���ſ��᳻��
           ,TT_SOR_CLM_MM_REST_MRT_BC  C    --SOR_CLM_���ε���㺸�⺻
WHERE       A.STD_YM        IN ('201112','201212','201312','201408')
AND         A.NFFC_UNN_DSCD = '1'             --�߾�ȸ���ձ����ڵ�
AND         A.STUP_STCD     = '02'            --���������ڵ�(02:������)
AND         A.STD_YM        = B.STD_YM
AND         A.STUP_NO       = B.STUP_NO       --������ȣ
AND         A.STD_YM        = C.STD_YM
AND         A.MRT_NO        = C.MRT_NO
AND         B.ACN_DCMT_NO   IN (SELECT DISTINCT ���¹�ȣ  FROM #TEMP_�⺻����)


-- CASE 3  �㺸�������� �� ����㺸�������� ���ϱ�
-- �㺸���������� ������ �����̰� ������ ����� �㺸���������� ����㺸�������� �����
-- �ϳ��� �㺸�ȿ� ���ð� �󰡰� �Բ� �ִ� ���� ��ü������ ��� ���� ���ð����򰡱ݾ�, �󰡰����򰡱ݾ��� ������ ��������㺸���������� ������㺸���������� �ջ�
-- �ϳ��� ���¿� �㺸�� �������̸� �Ʒ��� ���� ���� ����㺸���������� MAX ������ �ϴ��� ..���ؼ� ����ؾ� �Ѵ�.

SELECT      A.���հ��¹�ȣ
           ,B.MRT_NO             AS   �㺸��ȣ

           ,CASE WHEN B.EVL_AMT = 0 THEN 0 ELSE (B.HS_APSL_EVL_AMT / B.EVL_AMT)  * B.MRT_RCG_RT END
           +CASE WHEN B.EVL_AMT = 0 THEN 0 ELSE (B.DTWN_APSL_EVL_AMT / B.EVL_AMT) * B.DTWN_MRT_RCG_RT END AS �㺸��������

           ,CASE WHEN B.EVL_AMT = 0 THEN 0 ELSE (B.HS_APSL_EVL_AMT / B.EVL_AMT)  * B.APL_MRT_RCG_RT END
           +CASE WHEN B.EVL_AMT = 0 THEN 0 ELSE (B.DTWN_APSL_EVL_AMT / B.EVL_AMT) * B.DTWN_APL_MRT_RCG_RT END AS ����㺸��������

           ,ROW_NUMBER() OVER(PARTITION BY A.���հ��¹�ȣ, B.MRT_NO ORDER BY B.ENR_DT DESC, B.CLN_APC_NO DESC) AS ��ȣ --���߿� ��ȣ 1�� ��û��ȣ�͸� �����ϸ� �ȴ�

INTO        #TEMP_�㺸��������  -- DROP TABLE #TEMP_�㺸��������

FROM        (
            SELECT        DISTINCT
                          A.���հ��¹�ȣ
                         ,B.ACN_DCMT_NO
                         ,B.CLN_APC_NO
                         ,B.ENR_DT
            FROM          #������     A

            JOIN          TT_SOR_CLM_MM_CLN_LNK_TR  B  -- SOR_CLM_�����ſ��᳻��
                          ON   A.���հ��¹�ȣ    =  B.ACN_DCMT_NO
                          AND  B.STD_YM          =  '201606'

            JOIN          TT_SOR_CLM_MM_STUP_BC   C  --SOR_CLM_�������⺻
                          ON   B.STUP_NO         =  C.STUP_NO
                          AND  C.MRT_TPCD        = '1'
                          AND  C.STD_YM          = '201606'
            ) A

JOIN        TB_SOR_CLM_MRT_ENNR_CALC_TR B --SOR_CLM_�㺸���»��⳻��
            ON    A.CLN_APC_NO     = B.CLN_APC_NO

ORDER BY    A.���հ��¹�ȣ
           ,B.MRT_NO
;


-- CASE 4  �űԽ�û���� ���Ž�û��ȣ�� �ε���㺸 ��������, �����ݾ��� 'CLM_�ǹ��㺸������' ���� �������°Ͱ� 'SOR_CLM_�����⺻' ���� �������� ������
--         �����(20171012)_����ڱݴ���űԳ���_�̹��� ���α׷������� ����
SELECT      A.���հ��¹�ȣ
           ,A.���Ž�û��ȣ
           ,E.MRT_CD         AS  �㺸�ڵ�
           ,Z1.MRT_CD_NM     AS  �㺸�ڵ��
           ,E.OWNR_CUST_NO   AS  �����ڰ���ȣ
           ,F.CUST_NM        AS  �����ڼ���
           ,TRIM(E.MPSD_NM) || ' ' || TRIM(E.CCG_NM) || ' ' || TRIM(E.EMD_NM) || ' ' || TRIM(E.LINM) || ' ' ||  TRIM(E.THG_SIT_DTL_ADR) AS   ���Ǽ�����
           ,D.STUP_DT        AS  ��������     -- �����缳������ ���� �ִ��׸��� �ƴ϶� �����⺻�� �������� �����缳������ (����)
--           ,F.APSL_AMT       AS  �����ݾ�
           ,D1.APSL_SMTL_AMT AS  �����հ�ݾ�  -- �ε���㺸���庸�� ���������� �������� �־ �̰� �̿���
                                               -- ������ ����Ǿ� �����Ƿ� ���������� �������� ���� �ǰ�, ������ ���þ��� ������ ������ �̷�� ���� �ε�����忡 �������� �ٲ�� �ִ�
                                               -- �׷��Ƿ� ������������ �ε���㺸���忡 ���� �̿��ϰ� ���������� �������� �̿��Ϸ��� ���������� �̿��ϴ� ���� �Ǵ�
           ,E.TROW_RGS_DT    AS  �����������������

INTO        #�������_�㺸��    -- DROP TABLE  #�������_�㺸��

FROM        #�������_�űԽ�û��ȣ  A

JOIN        DWZOWN.TB_SOR_CLM_CLN_LNK_TR   C  -- SOR_CLM_���ſ��᳻��
            ON   A.���Ž�û��ȣ      = C.CLN_APC_NO
            AND  C.CLN_LNK_STCD      = '02'    -- ���ſ�������ڵ�(02:������) ������¿��� ������°� ���������� �����ϰ� ���

JOIN        DWZOWN.TB_SOR_CLM_STUP_BC       D  -- SOR_CLM_�����⺻
            ON   C.STUP_NO   =  D.STUP_NO

LEFT OUTER JOIN
            TB_SOR_CLM_APSL_BC     D1   --SOR_CLM_�����⺻
            ON  D.APSL_NO  = D1.APSL_NO

JOIN        DWZOWN.TB_SOR_CLM_REST_MRT_BC     E   --SOR_CLM_�ε���㺸�⺻
            ON   D.MRT_NO  = E.MRT_NO
//=========================================================================================
            AND  E.MRT_CD  IN  ('101','102','103','104','105','111','170')   -- �ְŹ� �ְſ���ǽ���
            AND  ( E.NFM_YN      IS NULL  OR   E.NFM_YN   = 'N')         -- �����㺸 �ƴҰ�
            AND  ( E.AFCP_MRT_YN IS NULL  OR   E.AFCP_MRT_YN  = 'N')     -- ����㺸 �ƴҰ�
//=========================================================================================
--LEFT OUTER JOIN
--            DWZOWN.TB_SOR_CLM_BLD_MRT_APSL_DL   F -- CLM_�ǹ��㺸������
--            ON   D.APSL_NO  = F.APSL_NO

JOIN        OM_DWA_INTG_CUST_BC    F     --DWA_���հ��⺻
            ON   E.OWNR_CUST_NO     =  F.CUST_NO

LEFT OUTER JOIN
            DWZOWN.TB_SOR_CLM_MRT_CD_BC  Z1  --CLM_�㺸�ڵ�⺻
            ON   E.MRT_CD = Z1.MRT_CD
;



//}

//{   #���ݴ���
SELECT      STD_YM    AS  ���س��
           ,CLN_ACNO  AS  ���¹�ȣ
           ,AGR_AMT   AS  �����ݾ�
           ,LN_SBCD ��������ڵ�

INTO        #SH���ݴ���           -- DROP TABLE #SH���ݴ���
FROM        TT_SOR_LOA_MM_ACN_BC  A        --  SOR_LOA_���±⺻
WHERE       1=1
AND         A.STD_YM  IN  ('201312','201412','201512','201605')
AND         SUBSTR(A.PDCD, 6, 4)    =     '1123'        -- ���ݴ���
AND         LEFT(AGR_DT,4) =  LEFT(STD_YM,4)            -- ���س⵵ �űԾ�����
AND         A.CLN_ACN_STCD  <> '3'                      --  ��Ұ�����
;

--- ����
SELECT      DISTINCT
            SBJ_NFFC_UNN_DSCD
           ,LN_SBCD
           ,LN_TXIM_CD
           ,LN_USCD
           ,LN_SBJ_NM      AS  ��������
           ,LN_TXIM_CD_NM   AS  ���⼼���ڵ��
           ,LN_USCD_NM      AS  ����뵵�ڵ��
FROM        OT_DWA_CLN_HRC_CTL_BC A
WHERE       STD_DT =  '20160531'
AND         LN_SBCD IN ('056','081')
;
//}

//{  #��ȯ��ȹ  #��ȯ���� #���һ�ȯ

SELECT
--            A.INTG_ACNO     AS ���¹�ȣ
--           ,SUM(A.LN_RMD)   AS �����ܾ�
            SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201607'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS ���һ�ȯ��������_201607
           ,SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201608'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS ���һ�ȯ��������_201608
           ,SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201609'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS ���һ�ȯ��������_201609
           ,SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201610'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS ���һ�ȯ��������_201610
           ,SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201611'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS ���һ�ȯ��������_201611
           ,SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201612'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS ���һ�ȯ��������_201612

FROM        OT_DWA_INTG_CLN_BC            A       -- DWA_���տ��ű⺻
JOIN        TB_SOR_LOA_EXE_RDM_PLAN_TR    C       -- LOA_�����ȯ��ȹ����
            ON    A.INTG_ACNO      = C.CLN_ACNO
            AND   A.CLN_EXE_NO     = C.CLN_EXE_NO
            AND   C.EXE_RDM_PLAN_DSCD = '1'        -- �����ȯ��ȹ�����ڵ�(1:��ȯ��ȹ  2:�����ȹ)
WHERE       1=1
AND         A.STD_DT       =  '20160619'
AND         A.CLN_ACN_STCD = '1'                           -- ����
AND         A.BR_DSCD      =  '1'                          -- �߾�ȸ
AND         A.INDV_LMT_LN_DSCD  <>   '2'                   -- �ѵ���������
AND         A.CLN_RDM_MHCD   IN ('2','3','4')              -- ���Ż�ȯ����ڵ�(2:���ݱյ�,3:�����ݱյ�,4:���ݺұյ�)
AND         A.BRNO NOT IN ('0018','0178','0204','0304','0404','0542','0602','0804','0805','0909')     -- �����̰��� ����
AND         CASE WHEN   A.FRPP_KDCD IN ('2')  AND  A.PRD_BRND_CD =  '5025' AND A.LN_SBCD IN ('369','370')  THEN '4. �·���'
--                 WHEN A.FRPP_KDCD   IN ('2')  AND  A.PDCD  IN  ( '20387500100001','20387500200001')        THEN '5. ���ȼ���'
                 WHEN   A.FRPP_KDCD IN ('2')                                                               THEN '3. ��å'
                 WHEN  (A.BS_ACSB_CD IN ('17005211',                        --��Ÿ�����ü��ڱݴ���
                                         '17002811')) THEN                  --��Ÿ���������ڱݴ���
                        CASE WHEN A.PRD_BRND_CD IN ('1085',                 --����ش���
                                                    '1026',                 --����ð濵�����ڱݴ���
                                                    '1029',                 --����������ġ��ü�������
                                                    '1116',                 --�߼ұ��������ܴ���
                                                    '1132',                 --��⵵����ü�߼ұ�������ڱݴ���
                                                    '1140',                 --�һ���������ڱݴ���
                                                    '1150') THEN '3. ��å'     --�һ������ȯ����
                             ELSE                                '2. ����'
                        END
                 WHEN A.BS_ACSB_CD  IN ('17010111','17010211')   THEN  '2. ����'  -- �����ؾ��Ϲݿ����ڱݴ���, �����ؾ��Ϲݽü��ڱݴ���
                 WHEN A.LN_MKTG_DSCD IS NOT NULL                 THEN  '6. ������'
                 ELSE '1. �Ϲ�'
            END        IN   ('1. �Ϲ�','4. �·���')                          -- �Ϲݴ���(�·�������)
--GROUP BY    A.INTG_ACNO
;
//}

//{  #���տ������� #������ #������  #����������  #�Ϳ�������
SELECT      STD_DT
           ,(
              SELECT MIN(B.STD_DT)
              FROM   OT_DWA_INTG_CLN_DT_BC    B    --   DWA_���տ������ڱ⺻
              WHERE  1=1
              AND    B.STD_DT  > A.STD_DT
            )                                      AS �Ϳ�������
           ,(
              SELECT A.STD_DT
              FROM   (
                       SELECT B.STD_DT,
                              RANK() OVER(ORDER BY B.STD_DT DESC) AS �����ϼ���
                       FROM   OT_DWA_INTG_CLN_DT_BC   B    --   DWA_���տ������ڱ⺻
                       WHERE  1=1
                       AND    B.STD_DT >= DATEFORMAT(DATEADD(MM, -2, A.STD_DT), 'YYYYMMDD')
                       AND    B.STD_DT < A.STD_DT
                     ) A
              WHERE  A.�����ϼ��� = 1
            )                                     AS ����������
INTO        #���տ�����������     -- DROP TABLE #���տ�����������
FROM        OT_DWA_INTG_CLN_DT_BC   A    --   DWA_���տ������ڱ⺻
WHERE       1=1
AND         A.STD_DT   BETWEEN  '20151201' AND '20160620'     -- ���������ڸ� ����� �����Ҽ��ֵ���
;

-- ���տ������ڱ⺻���� �����ڸ� ��������
AND         A.STD_DT  IN  (
                           SELECT    MAX(STD_DT)
                           FROM      OT_DWA_INTG_CLN_DT_BC
                           WHERE     1=1
                           AND       STD_DT  BETWEEN '20111201' AND '20161130'
                           GROUP BY  LEFT(STD_DT,6)
                          )
-- ���տ������ڱ⺻����  �б⸻�� ��������
 SELECT    MAX(STD_DT)
                           FROM      OT_DWA_INTG_CLN_DT_BC
                           WHERE     1=1
                           AND       STD_DT  BETWEEN '20100101' AND '20161231'
                           AND       SUBSTR(STD_DT,5,2) IN ('03','06','09','12')
                           GROUP BY  LEFT(STD_DT,6)
ORDER BY 1


//}

//{  #���庯��  #���ุ��  #���ุ���� #���ุ���Ϻ��� #���庯���̷�


--���庯�濡�� ����Ǻ��� �������� �������ִ°�� ������ �������� �����̷��� �߸� ���̰� �־ ���� �ʿ� ������ �ߴµ�
--�ܱ��ȭ �ѵ������� ������ ������ ���� TB_LOA_LDGR_CHG_HIS_DL ���� ����� ���̰� �־ TB_LOA_LDGR_CHG_HIS_DL ���̺��� �����ؾ� �Ұ� �����ϴ�.
--�������ڿ� �Բ� �����ô°Ÿ� ���±⺻, ���庯���̷�, ���庯���̷»󼼸� ���� �����ؾ� �Ұ� �����ϴ�.
--���庯���̷¿��� �� �� ���̰� �־��� ���� �Է��׸񳻿�1 �� ������ ������ ���̰� �־�� ������ ������ �����ϴ�.  -- ������

SELECT      A.*
           ,B.LDGR_CHG_SNO       AS  ���庯���Ϸù�ȣ
           ,B.CHG_DT             AS  ��������
--           ,B.INP_HDN_CTS1       AS  �Է³���
           ,C.CHB_LTR_HDN_CTS    AS  �����������׸񳻿�
           ,C.CHA_LTR_HDN_CTS    AS  �����Ĺ����׸񳻿�
--           ,C.CHG_LDGR_HDN_NM    AS  ��������׸��
--           ,C.CHG_LDGR_TBL_NM    AS  ����������̺��

INTO        #���泻��   -- DROP TABLE #���泻��
FROM        #������   A

JOIN        TB_SOR_LOA_LDGR_CHG_HT     B    --SOR_LOA_���庯���̷�
            ON   A.���¹�ȣ  = B.CLN_ACNO
            AND  A.�����ȣ  = B.CLN_EXE_NO
            AND  B.CLN_TR_DTL_KDCD  = '5072'     --  ���Űŷ��������ڵ�
--            AND  B.CLN_TR_DTL_KDCD  = '5005'     --  ���Űŷ��������ڵ�(�������ͻ�ǵ�� �� ����)
--            AND  B.CLN_TR_DTL_KDCD  = '5055'     --  ���Űŷ��������ڵ�( �ִ㺸�ڵ� ����)

JOIN        TB_SOR_LOA_LDGR_CHG_HIS_DL    C   --SOR_LOA_���庯���̷»�
            ON   B.CLN_ACNO   = C.CLN_ACNO
            AND  B.CLN_EXE_NO = C.CLN_EXE_NO
            AND  B.LDGR_CHG_SNO =  C.LDGR_CHG_SNO
--ORDER BY   3,4,20;


//}

//{  #�����ּ� #���� #�κ��ּ� #�ּ�ó��
=LEFT(C7,1) & REPT("*",LEN(C7)-2) & RIGHT(TRIM(C7),1)
//}

//{  #��ȯ����  #��ȯ���
--CASE 1
           ,--�Ͻû�ȯ/���һ�ȯ
            CASE WHEN A.CLN_RDM_MHCD = '1'                 THEN '�縸���Ͻ�'  --���Ż�ȯ����ڵ�
                 WHEN ISDATE(A.DFR_EXPI_DT) = 1  THEN --'��ġ��'
                      CASE WHEN A.DFR_EXPI_DT < A.STD_DT   THEN '����ݻ�ȯ��' ELSE '���ġ�Ⱓ��'  END
                 ELSE '����ġ��'  END  AS ��ȯ����

-- CASE 2
           ,CASE WHEN A.CLN_RDM_MHCD = '1'       THEN '1. �Ͻû�ȯ'  --���Ż�ȯ����ڵ�
                 WHEN ISDATE(A.DFR_EXPI_DT) = 0  THEN '3. ���ġ�� ���һ�ȯ'
                 ELSE '2. ��ġ�� ���һ�ȯ'
            END                             AS ��ȯ�������

//}

//{  #�ε��� #INDEX

-- ���¸� ã�� �ӵ��� ������ �ϱ� ���ؼ� INDEX �� �����ϴ� ���

SELECT      DISTINCT ���հ��¹�ȣ
INTO        #��ȭ�����_���º�  -- DROP TABLE #��ȭ�����_���º�
FROM        #��ȭ�����
;

COMMIT;

CREATE HG INDEX C1_HG ON #��ȭ�����_���º�(���հ��¹�ȣ);

SELECT      ......
WHERE       1=1
AND         INTG_ACNO  IN ( SELECT DISTINCT ���հ��¹�ȣ FROM #��ȭ�����_���º� )


//}

//{ #����  #�ſ�

SELECT       NUMBER(*) ����,��������
INTO         #TEMP_���� -- DROP TABLE #TEMP_����  SELECT * FROM #TEMP_����
FROM
            (
             SELECT  MAX(STD_DT)  ��������
             FROM    OT_DWA_INTG_CLN_BC
             WHERE   1=1
             AND     STD_DT  BETWEEN  '20080131' AND '20151031'
             --AND     STD_DT = '20120131'
             GROUP BY LEFT(STD_DT,6)
            )  A
ORDER BY     ��������
;

SELECT      A.��������
           ,A1.��������        AS    M1
           ,A2.��������        AS    M2
           ,A3.��������        AS    M3
           ,A4.��������        AS    M4
           ,A5.��������        AS    M5
           ,A6.��������        AS    M6
           ,A7.��������        AS    M7
           ,A8.��������        AS    M8
           ,A9.��������        AS    M9
           ,A10.��������       AS    M10
           ,A11.��������       AS    M11
           ,A12.��������       AS    M12
           ,A13.��������       AS    M13
           ,A14.��������       AS    M14

INTO        #TEMP_���ڸ�Ʈ���� --DROP TABLE #TEMP_���ڸ�Ʈ����  SELECT * FROM #TEMP_���ڸ�Ʈ����
FROM        #TEMP_����  A

LEFT OUTER JOIN
            #TEMP_����  A1
            ON    A.���� + 1 = A1.����

LEFT OUTER JOIN
            #TEMP_����  A2
            ON    A.���� + 2 = A2.����

LEFT OUTER JOIN
            #TEMP_����  A3
            ON    A.���� + 3 = A3.����

LEFT OUTER JOIN
            #TEMP_����  A4
            ON    A.���� + 4 = A4.����

LEFT OUTER JOIN
            #TEMP_����  A5
            ON    A.���� + 5 = A5.����

LEFT OUTER JOIN
            #TEMP_����  A6
            ON    A.���� + 6 = A6.����

LEFT OUTER JOIN
            #TEMP_����  A7
            ON    A.���� + 7 = A7.����

LEFT OUTER JOIN
            #TEMP_����  A8
            ON    A.���� + 8 = A8.����

LEFT OUTER JOIN
            #TEMP_����  A9
            ON    A.���� + 9 = A9.����

LEFT OUTER JOIN
            #TEMP_����  A10
            ON    A.���� + 10 = A10.����

LEFT OUTER JOIN
            #TEMP_����  A11
            ON    A.���� + 11 = A11.����

LEFT OUTER JOIN
            #TEMP_����  A12
            ON    A.���� + 12 = A12.����

LEFT OUTER JOIN
            #TEMP_����  A13
            ON    A.���� + 13 = A13.����

LEFT OUTER JOIN
            #TEMP_����  A14
            ON    A.���� + 14 = A14.����

ORDER BY    1
;

SELECT       A.STD_DT
            ,A.����3
            ,SUM(CASE WHEN B.�������� = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS �ش����ü�ܾ�
            ,SUM(CASE WHEN B.M1 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+1'
            ,SUM(CASE WHEN B.M2 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+2'
            ,SUM(CASE WHEN B.M3 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+3'
            ,SUM(CASE WHEN B.M4 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+4'
            ,SUM(CASE WHEN B.M5 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+5'
            ,SUM(CASE WHEN B.M6 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+6'
            ,SUM(CASE WHEN B.M7 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+7'
            ,SUM(CASE WHEN B.M8 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+8'
            ,SUM(CASE WHEN B.M9 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M9'
            ,SUM(CASE WHEN B.M10 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+10'
            ,SUM(CASE WHEN B.M11 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+11'
            ,SUM(CASE WHEN B.M12 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+12'
            ,SUM(CASE WHEN B.M13 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+13'
            ,SUM(CASE WHEN B.M14 = C.�������� THEN C.�ݰ�����ü�ݾ� ELSE 0 END) AS 'M+14'
FROM        #TEMP_�űԿ���                 A
           ,#TEMP_���ڸ�Ʈ����  B
           ,#TEMP_��ü�ݾ�      C
WHERE        A.STD_DT         =  B.��������
AND          A.INTG_ACNO     *=  C.���հ��¹�ȣ
GROUP BY     A.STD_DT
            ,A.����3
ORDER BY     2,1
;
//}

//{ #�㺸���� #��ü�㺸 #�㺸 #�ε���㺸 #�����ǰ�㺸 #�������㺸 #ä�Ǵ㺸 #�������Ǵ㺸 #�����δ㺸  #���㺸

-- CASE 1
             --�ε���
             SELECT   DISTINCT A.MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO -- ������¹�ȣ
             FROM     TT_SOR_CLM_MM_REST_MRT_BC   A --SOR_CLM_���ε���㺸�⺻
                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_�������⺻

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_�����ſ��᳻��

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'
             UNION ALL
             --���ݴ㺸
             SELECT   DISTINCT A.MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO
              FROM    TT_SOR_CLM_MM_TBK_PRD_MRT_BC   A --SOR_CLM_�������ǰ�㺸�⺻

                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_�������⺻

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_�����ſ��᳻��

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'
             UNION ALL
             --������
             SELECT   DISTINCT A.MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO -- ������¹�ȣ
             FROM     TT_SOR_CLM_MM_WRGR_MRT_BC A --SOR_CLM_���������㺸�⺻

                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_�������⺻

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_�����ſ��᳻��

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'
             UNION ALL
             --ä�Ǵ㺸����
             SELECT   DISTINCT A.MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO -- ������¹�ȣ
             FROM     TT_SOR_CLM_MM_BND_MRT_BC    A --SOR_CLM_��ä�Ǵ㺸�⺻

                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_�������⺻

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_�����ſ��᳻��

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'
             UNION ALL
              --��������
             SELECT   DISTINCT A.MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO -- ������¹�ȣ
             FROM     TT_SOR_CLM_MM_MKSC_MRT_BC A --SOR_CLM_���������Ǵ㺸�⺻

                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_�������⺻

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_�����ſ��᳻��

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'
             UNION ALL
              --������
             SELECT   DISTINCT '601' AS MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO -- ������¹�ȣ
             FROM     TT_SOR_CLM_MM_GRNR_MRT_BC   A --SOR_CLM_�������δ㺸�⺻

                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_�������⺻

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_�����ſ��᳻��

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'


-- CASE 2

SELECT      A.ACN_DCMT_NO        AS ���¹�ȣ
           ,A.STUP_NO            AS ������ȣ
           ,B.MRT_TPCD           AS �㺸�����ڵ�
           ,B.MRT_NO             AS �㺸��ȣ
           ,B.APSL_NO            AS ������ȣ
           ,B.STUP_DT            AS ��������
           ,B.STUP_AMT           AS �����ݾ�

INTO        #���ſ���    -- DROP TABLE #���ſ���
FROM        DWZOWN.TT_SOR_CLM_MM_CLN_LNK_TR  A --SOR_CLM_�����ſ��᳻��
JOIN        DWZOWN.TT_SOR_CLM_MM_STUP_BC     B --SOR_CLM_�������⺻
            ON    A.STUP_NO  = B.STUP_NO
            AND   B.NFFC_UNN_DSCD = '1'
            AND   B.STUP_STCD     = '02'       --���������ڵ�:02(����)

WHERE       A.STD_YM        = '201612'      --���س��        VVV
AND         A.STD_YM        = B.STD_YM        --����
AND         A.NFFC_UNN_DSCD = '1'             --�߾�ȸ���ձ����ڵ�:2(����)
AND         A.CLN_LNK_STCD  = '02'            --���ſ�������ڵ�:02(����)
AND         A.ACN_DCMT_NO   IN  (  SELECT ���հ��¹�ȣ  FROM #��ȭ����� )
;



SELECT      AA.OWNR_CUST_NO            AS  �����ڰ���ȣ
           ,D.CUST_NM                  AS  �����ڰ���
           ,D.MBTL_DSCD || D.MBTL_TONO  || D.MBTL_SNO  AS �޴���ȭ��ȣ
           ,AA.MRT_CD                  AS   �㺸�ڵ�
           ,B.MRT_CD_NM                AS   �㺸�ڵ��
           ,A.���¹�ȣ
           ,A.������ȣ
           ,A.�㺸��ȣ
           ,A.������ȣ
           ,A.��������
           ,A.�����ݾ�
           ,A.�㺸�����ڵ�
INTO        #�㺸����  -- DROP TABLE #�㺸����
FROM        #���ſ���    A
JOIN        (
             SELECT  MRT_NO
                   , OWNR_CUST_NO
                   , MRT_CD
              FROM TB_SOR_CLM_REST_MRT_BC      -- CLM_�ε���㺸�⺻
              WHERE  MRT_STCD      = '02'
              UNION ALL
              SELECT  MRT_NO
                    , OWNR_CUST_NO
                    , MRT_CD
              FROM TB_SOR_CLM_TBK_PRD_MRT_BC   -- CLM_�����ǰ�㺸�⺻
              WHERE  MRT_STCD      = '02'
              UNION ALL
              SELECT   MRT_NO
                    , OWNR_CUST_NO
                    , MRT_CD
              FROM TB_SOR_CLM_BND_MRT_BC       -- CLM_ä�Ǵ㺸�⺻
              WHERE  MRT_STCD      = '02'
              //----------------------�������� ����----------------------------------
--              UNION ALL
--              SELECT  MRT_NO
--                    , GRNR_CUST_NO    AS OWNR_CUST_NO
--                    , '601'
--              FROM TB_SOR_CLM_GRNR_MRT_BC      -- CLM_�����δ㺸�⺻
--              WHERE  MRT_STCD      = '02'
             //--------------------------------------------------------------------
              UNION ALL
              SELECT   MRT_NO
                    , OWNR_CUST_NO
                    , MRT_CD
              FROM TB_SOR_CLM_WRGR_MRT_BC      -- CLM_�������㺸�⺻
              WHERE  MRT_STCD      = '02'
              UNION ALL
              SELECT   MRT_NO
                    , OWNR_CUST_NO
                    , MRT_CD
              FROM TB_SOR_CLM_MKSC_MRT_BC       -- CLM_�������Ǵ㺸�⺻
              WHERE  MRT_STCD      = '02'
            ) AA
            ON     A.�㺸��ȣ       = AA.MRT_NO

JOIN        TB_SOR_CLM_MRT_CD_BC B               -- CLM_�㺸�ڵ�⺻
            ON     AA.MRT_CD       = B.MRT_CD

JOIN        OM_DWA_INTG_CUST_BC      D            -- DWA_���հ��⺻
            ON     AA.OWNR_CUST_NO = D.CUST_NO
;

//}

//{  #�ݱ�����   #����

SELECT      BEOM_DT                                       --  ����������
           ,CASE WHEN RIGHT(P_��������,4) > '0731'  THEN LEFT(P_��������,4) || '0701' ELSE LEFT(P_��������,4) ||'0101' END
INTO        V_��������
           ,V_�������������
FROM        OM_DWA_DT_BC        --  DWA_���ڱ⺻
WHERE       STD_DT =  P_��������
;

SELECT      A.INTG_ACNO
           ,SUM(A.MNDR_WN_ACMN) /  (DAYS(DATE(V_�������������), DATE(V_��������)) + 1)  AS �ݱ�����
INTO        #�ݱ�����        -- DROP TABLE #�ݱ�����
FROM        OT_DWA_MM_ACN_RMD_TZ   A
JOIN        TB_SOR_LOA_ACN_BSC_DL   B       --SOR_LOA_���±⺻��
            ON   A.INTG_ACNO  = B.CLN_ACNO
            //===============================================================
            AND  B.TCH_EVL_ISN_NO <> ''   -- ����򰡹߱޹�ȣ�� �ִ°�
            //===============================================================
JOIN        TB_SOR_CMI_BR_BC         J      --�����⺻
            ON   A.ACCT_PCS_BRNO  =  J.BRNO
            AND  J.BR_DSCD        = '1'      -- �߾�ȸ

WHERE       1=1
AND         A.STD_YM  BETWEEN  LEFT(V_�������������,6)  AND  LEFT(V_��������,6)
GROUP BY    A.INTG_ACNO
;

//}

//{  #������� #�������� #����õ�� #�����õ��


LEFT OUTER JOIN         -- �ֱٿ���ŷ�����
                        -- �������ڰ� ������ �����ΰ�� ��޹� ����� ���Ҽ� ����
            (
             SELECT       TA.CLN_ACNO                     AS  ���Ű��¹�ȣ
                         ,TA.ENR_DT                       AS  ��������
                         ,TA.AGR_AMT                      AS  ����ݾ�
                         ,TA.TR_BF_ADD_IRT                AS  �ŷ�������ݸ�
                         ,TA.ADD_IRT                      AS  ����ݸ�
                         ,TC.CRDT_EVL_GD                  AS  �ſ��򰡵��
                         ,TD.XCDC_ATR_DSCD                AS  ����Ӽ������ڵ�
                         ,TE.ASS_CRDT_GD                  AS  ASS�ſ���
             FROM         DWZOWN.TB_SOR_LOA_AGR_HT       TA
             JOIN         (
                            SELECT   CLN_ACNO
                                    ,MAX(AGR_TR_SNO) AS AGR_TR_SNO    --�����ŷ��Ϸù�ȣ(�������ѿ����� �����ŷ��Ϸù�ȣ)
                            FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                            WHERE    CLN_APC_DSCD IN ('11','12','13') --���Ž�û�����ڵ�(11:���ѿ���,12:���ѿ��������,13:���ѿ�������Ǻ���)
                            AND      TR_STCD       =  '1'             --�ŷ������ڵ�(1:����)
                            AND      ENR_DT       <=  '20160630'
                            GROUP BY CLN_ACNO
                          )            TB
                          ON    TA.CLN_ACNO   = TB.CLN_ACNO
                          AND   TA.AGR_TR_SNO = TB.AGR_TR_SNO

             LEFT OUTER JOIN
                          TB_SOR_CLI_CLN_APRV_BC     TC     -- SOR_CLI_���Ž��α⺻
                          ON   TA.CLN_APRV_NO  =  TC.CLN_APRV_NO

             LEFT OUTER JOIN
                          TB_SOR_CLI_XCDC_DSCD_BC  TD   --SOR_CLI_���ᱸ���ڵ�⺻
                          ON   TC.LST_XCDC_DSCD  = TD.CLN_XCDC_DSCD  --�������ᱸ���ڵ�

             LEFT OUTER JOIN
                          TB_SOR_PLI_SYS_JUD_RSLT_TR TE          --SOR_PLI_�ý��۽ɻ�������
                          ON   TC.CUST_NO        = TE.CUST_NO
                          AND  TC.CLN_APC_NO     = TE.CLN_APC_NO

             WHERE        1=1
             AND          TA.CLN_ACNO  IN ( SELECT DISTINCT ���հ��¹�ȣ FROM #��ȭ�����_���º� )
            )      C
            ON            A.���հ��¹�ȣ  = C.���Ű��¹�ȣ
            AND           A.�������      = 1
            AND           A.��������      <  C.��������           -- ������ ��� ������ص� ���¹�ȣ �ȹٲ�Ƿ� �������ڰ� �������ں��� ������ ������ ��쵵����

LEFT OUTER JOIN         -- ���ʾ����ŷ�����
            (
             SELECT      TA.CLN_ACNO                     AS  ���Ű��¹�ȣ
                        ,TA.AGR_EXPI_DT                  AS  ������������
                        ,TA.AGR_DT                       AS  ��������
                        ,TA.AGR_AMT                      AS  �����ݾ�
                        ,TA.TR_BF_ADD_IRT                AS  �ŷ�������ݸ�
                        ,TA.ADD_IRT                      AS  ����ݸ�
                        ,TC.CRDT_EVL_GD                  AS  �ſ��򰡵��
                        ,TD.XCDC_ATR_DSCD                AS  ����Ӽ������ڵ�  --'01' ��������, '02' ����������
                        ,TE.ASS_CRDT_GD                  AS  ASS�ſ���

             FROM        DWZOWN.TB_SOR_LOA_AGR_HT       TA
             JOIN        (
                           SELECT   CLN_ACNO
                                   ,MAX(AGR_TR_SNO) AS AGR_TR_SNO    --�����ŷ��Ϸù�ȣ(�������ѿ����� �����ŷ��Ϸù�ȣ)
                           FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                           WHERE    CLN_APC_DSCD IN ('01','02','04','07','08','09') --���Ž�û�����ڵ� <10 �� �ű԰�
                           AND      TR_STCD       =  '1'             --�ŷ������ڵ�(1:����)
                           AND      ENR_DT       <=  '20160630'
                           GROUP BY CLN_ACNO
                         )            TB
                         ON    TA.CLN_ACNO   = TB.CLN_ACNO
                         AND   TA.AGR_TR_SNO = TB.AGR_TR_SNO

             LEFT OUTER JOIN
                         TB_SOR_CLI_CLN_APRV_BC     TC     -- SOR_CLI_���Ž��α⺻
                         ON   TA.CLN_APRV_NO  =  TC.CLN_APRV_NO

             LEFT OUTER JOIN
                         TB_SOR_CLI_XCDC_DSCD_BC  TD   --SOR_CLI_���ᱸ���ڵ�⺻
                         ON   TC.LST_XCDC_DSCD  = TD.CLN_XCDC_DSCD  --�������ᱸ���ڵ�

             LEFT OUTER JOIN
                          TB_SOR_PLI_SYS_JUD_RSLT_TR TE          --SOR_PLI_�ý��۽ɻ�������
                          ON   TC.CUST_NO        = TE.CUST_NO
                          AND  TC.CLN_APC_NO     = TE.CLN_APC_NO

             WHERE       1=1
             AND         TA.CLN_ACNO  IN ( SELECT DISTINCT ���հ��¹�ȣ FROM #��ȭ�����_���º� )
            )     D
            ON            A.���հ��¹�ȣ  = D.���Ű��¹�ȣ
            AND           A.�������      = 1
            AND           A.��������      = D.��������     -- �űԾ������� �������� ���̹Ƿ� �������ڰ� �翬�� ������������ Ȯ���� ���ؼ� �ʿ�


//}

//{  #��ȯ������  #��ȯ�����ݾ�

SELECT      A.STD_DT
           ,A.CUST_NO
           ,A.INTG_ACNO
           ,A.CLN_EXE_NO
           ,A.FRXC_TSK_DSCD
           ,MAX(CASE WHEN A.CRCD <> 'KRW'  THEN A.AGR_AMT * B.DLN_STD_EXRT ELSE A.AGR_AMT END)     AS �����ݾ�

INTO        #TEMP2  -- DROP TABLE #TEMP2
FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A       --

JOIN        DWZOWN.OT_DWA_EXRT_BC         B       --DWA_ȯ���⺻
            ON   A.CRCD       =  B.CRCD
            AND  A.STD_DT     =  B.STD_DT
            AND  B.EXRT_TO    = 1

JOIN        #�������Ͽ���    C
            ON   A.INTG_ACNO   =   C.INTG_ACNO

WHERE       1=1
AND         A.STD_DT  =  '20161206'
AND         A.BR_DSCD      = '1'     --�������ڵ�
AND         A.AGR_DT       >=  '20120101'
AND         A.CLN_ACN_STCD =  '1'              -- ���»��� ����
AND         A.FRXC_TSK_DSCD IN ('11','12','21','22','23','41','42') -- ��ȯ���������ڵ�(11:����⺻,12:��ȭ��ǥ����,21:���԰���,22:����BL����,23:����LG�߱�,41:��������,42:��������)

GROUP BY    A.STD_DT
           ,A.CUST_NO
           ,A.INTG_ACNO
           ,A.CLN_EXE_NO
           ,A.FRXC_TSK_DSCD
;

SELECT      A.STD_DT
           ,A.CUST_NO
           ,A.INTG_ACNO
           ,SUM(A.�����ݾ�)        AS   �����ݾ�
INTO        #TEMP3        -- DROP TABLE #TEMP3
FROM        #TEMP2  A
GROUP BY    A.STD_DT
           ,A.CUST_NO
           ,A.INTG_ACNO
;
//}

//{  #�ε�����  #���ݺε����� #���ںε�����

LEFT OUTER JOIN
            (
                 SELECT   INTG_ACNO, MAX(PCPL_DSH_DT) MAX_PCPL_DSH_DT ,MAX(INT_DSH_DT) MAX_INT_DSH_DT  -- MAX�� ����ϱ� ������ ���º��� ���ϰ��� �ִµ�.
                 FROM     TB_SOR_DAD_CLN_DSH_INF_TR             --SOR_DAD_���źε���������
                 WHERE    1=1
                 AND      DWUP_STD_DT = '20161206'
                 AND      INTG_ACNO IN ( SELECT DISTINCT INTG_ACNO  FROM #�������Ͽ���)
                 GROUP BY INTG_ACNO
                 /*   DISTINCT �غ����� �Ѱ��´� �������� ������ �ʴ��� Ȯ��
                 SELECT INTG_ACNO, COUNT(*)
                 FROM
                 (
                  SELECT   DISTINCT INTG_ACNO, PCPL_DSH_DT,INT_DSH_DT
                                  FROM     TB_SOR_DAD_CLN_DSH_INF_TR              --SOR_DAD_���źε���������
                                  WHERE    1=1
                                  AND      DWUP_STD_DT = '20161205'
                                  AND      INTG_ACNO IN ( SELECT DISTINCT INTG_ACNO  FROM #�������Ͽ���)
                 ) A
                 GROUP BY INTG_ACNO
                 HAVING COUNT(*) > 1
                 */
            )     D
            ON   A.INTG_ACNO  =  D.INTG_ACNO
//}

//{  #�㺸����


SELECT      NUMBER(*)                AS   ����
           ,A.CLN_ACNO               AS   �����¹�ȣ  -- 112�϶��� �ڰ���, 113�϶��� ����°� ����
           ,A.CLN_ACN_LNK_KDCD       AS   ���Ű��¿��������ڵ�
           ,A.ENR_DT                 AS   �������
           ,CASE WHEN  A.CLN_ACN_LNK_KDCD = '112'  THEN   A.LNK_CLN_FCNO ELSE  A.CLN_ACNO     END   AS �����
           ,CASE WHEN  A.CLN_ACN_LNK_KDCD = '112'  THEN   A.CLN_ACNO     ELSE  A.LNK_CLN_FCNO END   AS �ڰ���
INTO        #������    -- DROP TABLE #������
FROM        TB_SOR_LOA_ACN_LNK_BC A      -- SOR_LOA_���¿���⺻
-----------------------------------------------------------------------------------------------
WHERE       A.CLN_ACN_LNK_KDCD  IN ('112','113')
-----------------------------------------------------------------------------------------------
--ORDER BY    3,4
;


//}

//{  #����   #CROSS  #ũ�ν�

SELECT      A.CLN_ACNO               AS   �����¹�ȣ  -- 112�϶��� �ڰ���, 113�϶��� ����°� ����
           ,A.CLN_ACN_LNK_KDCD       AS   ���Ű��¿��������ڵ�
           ,A.ENR_DT                 AS   �������
           ,CASE WHEN  A.CLN_ACN_LNK_KDCD = '112'  THEN   A.LNK_CLN_FCNO ELSE  A.CLN_ACNO     END   AS �����
           ,CASE WHEN  A.CLN_ACN_LNK_KDCD = '112'  THEN   A.CLN_ACNO     ELSE  A.LNK_CLN_FCNO END   AS �ڰ���
INTO        #�㺸����    -- DROP TABLE #�㺸����
FROM        TB_SOR_LOA_ACN_LNK_BC A      -- SOR_LOA_���¿���⺻
WHERE       A.CLN_ACN_LNK_KDCD  IN ('112','113')
;

--  SELECT COUNT(*) FROM #�㺸����  --  1303

SELECT      STD_DT
INTO        #��������  -- DROP TABLE #��������
FROM        OM_DWA_DT_BC
WHERE       STD_DT  IN ('20111231',
                        '20120331','20120630','20120930','20121231',
                        '20130331','20130630','20130930','20131231',
                        '20140331','20140630','20140930','20141231',
                        '20150331','20150630','20150930','20151231',
                        '20160331','20160630','20160930','20161130'
                       );


SELECT      A.STD_DT          AS   ��������
           ,B.�����¹�ȣ    AS   ���¹�ȣ
           ,B.�������

INTO        #�㺸����_�������ں�       -- DROP TABLE #�㺸����_�������ں�
FROM        #��������   A
CROSS JOIN  #�㺸����   B

WHERE       1=1
AND         A.STD_DT  >=  B.�������
;


//}

//{  #������ #�����ܾ����� #��������

--  �������������ؼ� ���ܱ��ϱ�
SELECT      A.INTG_ACNO                AS   ���հ��¹�ȣ
           ,SUM(A.WN_RMD)              AS   ��ȭ�ܾ�
           ,SUM(A.MNDR_WN_AVBL)        AS   ���߿�ȭ����
           ,SUM(A.IMT_WN_AVBL)         AS   ���߿�ȭ����
INTO        #��������    -- DROP TABLE #��������
FROM        DWZOWN.OT_DWA_MM_ACN_RMD_TZ        A
WHERE       A.STD_YM   ='201611'
AND         A.INTG_CNTT_TSK_DSCD <> '01'    -- ������ ���� (������ ��� ���ϰ��°� ���� �������� �ߺ��ȴ�)
AND         A.INTG_ACNO IN ( SELECT  DISTINCT ���հ��¹�ȣ FROM  #TEMP_�⺻����)
GROUP BY    A.INTG_ACNO
;

//}

//{   #B2410 #N0058  #�ݰ������� #�ſ�  #����ſ�

AND         CASE WHEN A.STD_DT  < '20120101'  THEN
              CASE WHEN (A.BS_ACSB_CD IN ('15005811','15006211','15006311','16006011','16006111') AND A.MRT_CD IN ('101','102','103','104','105','170','109','111')) OR
                         A.BS_ACSB_CD = '14000611'  THEN '���ô㺸'
                   WHEN  A.MRT_CD < '100' OR A.MRT_CD IN ('601','602') THEN '�ſ�'
                   ELSE  '��Ÿ'  END
              WHEN A.STD_DT  >= '20120101'  THEN
              CASE WHEN (A.BS_ACSB_CD IN ('15005811','15006211','15006311','16006011','16006111') AND A.MRT_CD IN ('101','102','103','104','105','170','109','420','421','422','423','512','521')) OR
                         A.BS_ACSB_CD = '14000611'  THEN '���ô㺸'
                   WHEN  A.MRT_CD < '100' OR A.MRT_CD IN ('601','602') THEN '�ſ�'
                   ELSE  '��Ÿ'  END
            END   = '�ſ�'                    --  b2410 (UP_DWZ_�濵_N0058_�ݰ�����������) �� '����ſ�'�� ���Ͽ��

//}

//{   #���庯�� #������ #������

--SELECT      A.CLN_ACNO
--           ,A.CLN_EXE_NO
--           ,B.CHB_LTR_HDN_CTS      AS  �����������׸񳻿�
--           ,B.CHA_LTR_HDN_CTS      AS  �����Ĺ����׸񳻿�

--  �ѱ����� �����ڱ������ڵ尡 1050(���庯��ȭ��) ���� 02~04[c2�ڱ�] �� �ϳ��� ������ �̷��� �ִ� ����
SELECT      DISTINCT   A.CLN_ACNO

INTO        #������                --  DROP TABLE #������

FROM        TB_SOR_LOA_LDGR_CHG_HT       A    --  SOR_LOA_���庯���̷�
JOIN        TB_SOR_LOA_LDGR_CHG_HIS_DL   B    --  SOR_LOA_���庯���̷»�
            ON  A.CLN_ACNO      =  B.CLN_ACNO
            AND A.CLN_EXE_NO    =  B.CLN_EXE_NO
            AND A.LDGR_CHG_SNO  =  B.LDGR_CHG_SNO

WHERE       1=1
AND         A.CLN_TR_DTL_KDCD='5051'
AND         A.INP_HDN_CTS1 in ('02','03','04')
AND         A.CHG_DT >= '20160101'
AND         A.CHG_DT <= '20161231'
;

//}

//{  #��ȯ�ѵ��㺸  #�ѵ��㺸 #��ȯ�ѵ�

   -- ��������� ���������㺸���� ����
SELECT      DISTINCT
            A.CLN_APC_NO             AS ���Ž�û��ȣ
           ,A.ACN_DCMT_NO            AS ���¹�ȣ
           ,B.MRT_NO                 AS �㺸��ȣ
           ,B.MRT_TPCD               AS �㺸�����ڵ�
           ,C.WRGR_NO                AS ��������ȣ
           ,C.PBLC_ISTT_NM           AS ��������
           ,C.EVL_AMT                AS �򰡱ݾ�
INTO         #�������㺸 -- DROP TABLE #�������㺸
FROM        DWZOWN.TB_SOR_CLM_CLN_LNK_TR   A                -- SOR_CLM_���ſ��᳻��
           ,DWZOWN.TB_SOR_CLM_STUP_BC      B                -- SOR_CLM_�����⺻
           ,DWZOWN.TB_SOR_CLM_WRGR_MRT_BC  C                -- SOR_CLM_�������㺸�⺻
WHERE       1=1
AND         A.CLN_LNK_STCD = '02'                            -- ���ſ�������ڵ�(02:������)
AND         A.ACN_DCMT_NO  > ' '                             -- ���½ĺ���ȣ
AND         B.MRT_TPCD     = '5'                             -- �㺸�����ڵ�(5:������)
AND         C.MRT_STCD     = '02'                            -- �㺸�����ڵ�(02:������)
AND         A.STUP_NO      = B.STUP_NO                       -- ������ȣ
AND         B.MRT_NO       = C.MRT_NO                        -- �㺸��ȣ
//=======================================================================================
AND         A.CLN_TSK_DSCD  =  '49'                          -- ���ž��������ڵ� 49:��ȯ�ѵ�
AND         C.PBLC_ISTT_NM = '�ѱ������������'              -- ��������
//=======================================================================================
;

SELECT      DISTINCT
            A.CLN_APC_NO             AS ���Ž�û��ȣ
           ,A.ACN_DCMT_NO            AS ���¹�ȣ
           ,B.MRT_NO                 AS �㺸��ȣ
           ,B.MRT_TPCD               AS �㺸�����ڵ�
INTO        #��ȯ�ѵ��㺸     -- DROP TABLE #��ȯ�ѵ��㺸
FROM        DWZOWN.TB_SOR_CLM_CLN_LNK_TR   A                -- SOR_CLM_���ſ��᳻��
           ,DWZOWN.TB_SOR_CLM_STUP_BC      B                -- SOR_CLM_�����⺻
WHERE       1=1
AND         A.CLN_LNK_STCD = '02'                            -- ���ſ�������ڵ�(02:������)
AND         A.ACN_DCMT_NO  > ' '                             -- ���½ĺ���ȣ
AND         A.STUP_NO      = B.STUP_NO                       -- ������ȣ
//==============================================================================================
AND         A.CLN_TSK_DSCD  =  '49'                          -- ���ž��������ڵ� 49:��ȯ�ѵ�
//==============================================================================================
;

--CASE3 ��ȯ�ѵ����� ������ �ѵ����ΰ��� �������� ���
JOIN
            (
                SELECT  A.FRXC_LMT_ACNO,ISNULL(B.CLN_APRV_NO,A.CLN_APRV_NO) AS CLN_APRV_NO
                FROM    DWZOWN.TB_SOR_FEC_CLN_LMT_BC  A           -- SOR_FEC_�����ѵ��⺻
                LEFT OUTER JOIN
                        (
                         SELECT    A.FRXC_LMT_ACNO, A.CLN_APRV_NO
                         FROM      DWZOWN.TB_SOR_FEC_CLN_LMT_DL  A
                         JOIN      (
                                    SELECT A.FRXC_LMT_ACNO,MAX(A.SNO) AS MAX_SNO
                                    FROM   DWZOWN.TB_SOR_FEC_CLN_LMT_DL  A           -- SOR_FEC_�����ѵ���
                                    WHERE  1=1
                                    AND    A.FRXC_CLN_TR_CD =  '22'                  -- ��ȯ���Űŷ��ڵ�(22:����)
                                    AND    A.FRXC_LDGR_STCD  NOT IN ('4','5') -- ��ȯ��������ڵ�(4:����,5:���)
                                    GROUP BY A.FRXC_LMT_ACNO
                                   )    B
                                   ON      A.FRXC_LMT_ACNO = B.FRXC_LMT_ACNO
                                   AND     A.SNO           = B.MAX_SNO
                        )   B
                        ON  A.FRXC_LMT_ACNO  = B.FRXC_LMT_ACNO
            )    B
            ON     A.��ȯ�ѵ����¹�ȣ  = B.FRXC_LMT_ACNO

LEFT OUTER JOIN
            DWZOWN.TB_SOR_CLI_CLN_APRV_BC  C          -- SOR_CLI_���Ž��α⺻
            ON     B.CLN_APRV_NO   =  C.CLN_APRV_NO

//}

//{  #��ȭ�Ѱ��� #��ȭBS  #��ȭ�ܾ�

SELECT
--        A.BRNO                   AS ����ȣ
--       ,B.BR_NM                  AS ����
        A.ACSB_CD              AS ���������ڵ�
       ,A.CRCD                   AS ��ȭ�ڵ�
       ,SUM(A.TD_FC_RMD)       AS ���Ͽ�ȭ�ܾ�
       ,SUM(A.TD_WN_RMD)       AS���Ͽ�ȭ�ܾ�
  FROM  OT_DWA_FC_FLST_BC      A                --   DWA_��ȭ�Ѱ����⺻ */
       ,OT_DWA_DD_BR_BC        B                --   DWA_�����⺻
 WHERE  A.FSC_DT  =   '20111231'
   AND  A.FSC_SNCD = 'K'              /* ȸ������ڵ� : 'K'(GAAP)      */
   AND  A.BRNO <> 'XXXX'              /* ����ȣ : 'XXXX' ����          */
   AND  A.SMTL_ACCT_YN = 'N'          /* �հ�������� : 'N' (�հ�������) */
   AND  A.ACSB_CD     IN  ('14001818','14001918','14002018','96000418','96001018')
   AND  B.STD_DT  = '20111231'
   AND  A.BRNO    = B.BRNO         /* ����ȣ             */
   AND  B.BR_STCD  <> '09'           --�������ڵ�=<>'���'
   AND  B.BR_KDCD  < '40'           --10:���κμ�, 20:������, 30:������
   AND  B.BRNO NOT IN ('XXXX','0022','0023','0025','0234')  --��������ȣ
 GROUP BY
--         A.BRNO
--        ,B.BR_NM
           A.ACSB_CD
          ,A.CRCD
 ORDER BY 1

 //}

 //{  #��ȭ���ܿ���  #���ܿ���
--  ������ �̿������� ���� ���� ������ �Ϻκ�,����Ŭ ������

          SELECT B.ASP_ACNO
                ,B.CUST_NO
                ,DECODE (
                                  C.ASP_TR_KDCD
                                , 1
                                , C.CSH_AMT
                                + C.GNL_ALT_AMT
                                + C.LKG_ALT_AMT
                                + C.BNCH_AMT
                                + C.PCHK_AMT
                                , 5
                                , C.CSH_AMT
                                + C.GNL_ALT_AMT
                                + C.LKG_ALT_AMT
                                + C.BNCH_AMT
                                + C.PCHK_AMT
                                , -
                                  ( C.CSH_AMT
                                  + C.GNL_ALT_AMT
                                  + C.LKG_ALT_AMT
                                  + C.BNCH_AMT
                                  + C.PCHK_AMT
                                  )
                                )   * D.DLN_STD_EXRT  AS   DFRY_PSB_RMD    -- ���ް��ɱݾ�(����)
                ,E.CUR_UNT_CD         AS   CUR_UNT_CD
            FROM TB_CMI_BR_BC        A
               , TB_SDM_ASP_DP_BC    B
               , TB_SDM_ASP_DP_TR_TR C
               , TB_FEC_EXRT_BC      D
               , TB_CMI_CUR_BC       E
           WHERE A.BRNO                 = B.ASP_ADM_BRNO
             AND B.ASP_ACNO             = C.ASP_ACNO
             AND C.ENR_DT              <= '20130731'
             AND B.CRCD                 = D.CRCD
             AND D.CRCD                 = E.CRCD
             AND D.STD_DT               = '20130731'
             AND D.EXRT_TO              =  '1'
             -- ��������ΰǸ�
             AND C.TR_STCD              = '1'
             -- ������������
             AND C.ASP_TR_KDCD   NOT IN ( '3', '4' )
             AND B.ASP_TXIM_KDCD = '51'
             and A.lst_mvn_brno IS NOT NULL
             AND NVL ( C.ASP_DP_DFRY_DSCD, '1' ) != '2'
             and a.fsc_dscd in ( '1' )
             AND A.UNN_CD NOT IN ( '037' )
 //}

//{   #��û�㺸  #������û  #�ֱٽ�û  #��û�㺸
-- � �������ڿ��� ���� �ֱٽ�û�ǿ� �پ� �ִ� �㺸�� �㺸�� ��ȿ�㺸������ �������� ���

-- CASE1    ����ɻ�
SELECT      A.���հ��¹�ȣ
           ,A.����ȣ
           ,A.�����ܾ�
           ,B.���Ž�û��ȣ
           ,C.MRT_NO            AS  �㺸��ȣ
           ,C.AVL_WRT_MRAM      AS  ��ȿ��ġ�㺸�ݾ�
           ,ROW_NUMBER() OVER(PARTITION BY C.CLN_APC_NO,C.MRT_NO ORDER BY STUP_NO DESC) AS �ֱټ�����  -- ������ȣ�� ���� ��ȿ��ġ�㺸�ݾ��� �޶������ִ�

JOIN        (
             SELECT      A.ACN_DCMT_NO            AS  ���¹�ȣ
                        ,MAX(A.CLN_APC_NO)        AS  ���Ž�û��ȣ  -- ���������Ͽ� �������� ���Ž�û���� ������ �����Ƿ� ������û������
             FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
             JOIN        DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
                         ON  A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
             JOIN        (
                           SELECT   A.ACN_DCMT_NO         AS ���¹�ȣ
                                   ,MAX(B.HDQ_APRV_DT)    AS ��������
                           FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
                                   ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
                           WHERE    A.ACN_DCMT_NO       IN  ( SELECT DISTINCT ���հ��¹�ȣ FROM #������� WHERE �������   = '3.���λ����' )
                           AND      A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
                           AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
                           AND      A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
                           AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
                           AND      B.HDQ_APRV_DT       <= '20161231'   -- ��������
                           GROUP BY A.ACN_DCMT_NO
                          )   C
                          ON     A.ACN_DCMT_NO       = C.���¹�ȣ
                          AND    B.HDQ_APRV_DT       = C.��������
             WHERE       1=1
             AND         A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
             AND         A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
             AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
             GROUP BY    A.ACN_DCMT_NO
            )  B
            ON     A.���հ��¹�ȣ   =  B.���¹�ȣ

JOIN        TT_SOR_CLM_MM_APC_MRT_EVL_TR   C   --  SOR_CLM_����û�㺸�򰡳���
            ON     B.���Ž�û��ȣ  = C.CLN_APC_NO
            AND    C.STD_YM        = '201612'
;


-- CASE2
SELECT      A.���հ��¹�ȣ
           ,A.����ȣ
           ,A.�����ܾ�
           ,B.���Ž�û��ȣ
           ,C.MRT_NO            AS  �㺸��ȣ
           ,C.AVL_WRT_MRAM      AS  ��ȿ��ġ�㺸�ݾ�
           ,ROW_NUMBER() OVER(PARTITION BY C.CLN_APC_NO,C.MRT_NO ORDER BY C.STUP_NO DESC) AS �ֱټ�����  -- ������ȣ�� ���� ��ȿ��ġ�㺸�ݾ��� �޶������ִ�

JOIN        (
             SELECT      A.CLN_ACNO         AS ���¹�ȣ
                        ,MAX(A.CLN_APC_NO)  AS ���Ž�û��ȣ  -- ���������Ͽ� �������� ���Ž�û���� ������ �����Ƿ� ������û������
             FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
                        ,(SELECT   A.CLN_ACNO         AS ���¹�ȣ
                                  ,MAX(A.CLN_APRV_DT) AS ��������
                          FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_���Ž�û�⺻) --> ���νɻ�
                          WHERE    A.CLN_ACNO          IS NOT NULL
                          AND      A.CLN_APC_PGRS_STCD IN ( '03','04','13')  --���Ž�û��������ڵ�(03:����Ϸ�,04:����Ϸ�,13:�����Ϸ�)
                          AND      A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
                          AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
                          AND      A.CLN_APRV_DT       <= '20161231'
                          GROUP BY A.CLN_ACNO
                         ) B
             WHERE       A.CLN_ACNO          IS NOT NULL
             AND         A.JUD_APRV_DCD_RLCD = '01'              -- �ɻ���ΰ������ڵ�(01:����/����)
             AND         A.CSS_XCDC_DSCD     = '22'              -- CSS���ᱸ���ڵ�(11:������-����,21:����-�߾�ȸ,22:�μ���(�߾�ȸ))
             AND         A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
             AND         A.CLN_APRV_DT       <= '20161231'
             AND         A.CLN_ACNO          = B.���¹�ȣ
             AND         A.CLN_APRV_DT       = B.��������
             GROUP BY    A.CLN_ACNO
            )   B
            ON     A.���հ��¹�ȣ   =  B.���¹�ȣ

JOIN        TT_SOR_CLM_MM_APC_MRT_EVL_TR   C   --  SOR_CLM_����û�㺸�򰡳���
            ON     B.���Ž�û��ȣ  = C.CLN_APC_NO
            AND    C.STD_YM        = '201612'

--������ ��� SOR_PLI_�ý��۽ɻ������� �� �����ѵ��ݾ��� �㺸�����ѵ� �� �ſ�����ѵ��� �и� �س��� �ִ�
--TB_SOR_PLI_SYS_JUD_RSLT_TR (SOR_PLI_�ý��۽ɻ�������)
--
--CRLN_SMTL_AMT  (�ſ��ѵ��հ�ݾ�) ==> ���ֽſ��ѵ��հ�ݾ�:�ſ��ѵ�
--RL_MRT_AMT (�Ǵ㺸�ݾ�)  => ��û�㺸�����: �㺸�ѵ�(�Ǵ㺸�ݾ�)
--LN_LMT_AMT (�����ѵ��ݾ�) => �Ѵ��Ⱑ���ѵ�
--
--�Ϲ�������
--CSS�㺸������ 3 (�Ϻδ㺸��)�� ���..
--
--LN_LMT_AMT = RL_MRT_AMT + CRLN_SMTL_AMT
--�����ѵ��ݾ� = �Ǵ㺸�ݾ� + �ſ��ѵ��հ�ݾ�

//}

//{  #�ſ��򰡼�   #������

SELECT                 ,CC.ADR_                         AS  �������
..............
LEFT OUTER JOIN  -- ��ü��, ǥ�ػ���з��ڵ�, �������, ����ڹ�ȣ, ����ſ��򰡵�� �׸��� �ſ��򰡼����� ������ ����
            (    -- ������ �ſ��򰡼����� ������ �űԿ��Ž�û������ �������� ������
                    -- �����߰��������� �ü��ڱݴ��� ��� ** FROM ������
                    -- ���������δ�  �űԸ� �������Ƿ� 1�Ǹ� �����°� �翬������
                    -- ���������� ���¹�ȣ���� �ټ����� �����Ҽ� �����Ƿ� Ȯ���� �۾��ʿ�
                    -- SELECT CLN_ACNO, COUNT(*) FROM #TEMP GROUP BY #TEMP HAVING COUNT(*) > 1
                    -- ���º� �ټ����� �����ϴ� ���´� ���������忡�� ���� �Ұ�
                    SELECT   A.CLN_ACNO
                            ,MAX(B.CLN_APC_NO) MAX_CLN_APC_NO
                            ,C.CRDT_EVL_NO
                            ,D.CREV_RPSR_NM
                            ,D.HDFC_MLSV_ADR
                            ,D.BZNS_NM
                            ,CASE WHEN D.BRN IS NOT NULL THEN D.BRN   ELSE D.RNNO END BRN
                            ,D.CRDT_EVL_INDS_CLSF_CD
                            ,D.HDFC_ZIP
                            ,D.FTRY_ZIP
                            ,D.FTRY_ZADR
                            ,D.BSBR_ZIP
                            ,D.BSBR_ZADR
                    -- INTO     #TEMP  -- DROP TABLE #TEMP
                    FROM     TB_SOR_LOA_ACN_BC          A
                            ,TB_SOR_CLI_CLN_APC_BC      B  -- SOR_CLI_���Ž�û�⺻
                            ,TB_SOR_CLI_CLN_APC_RPST_BC C  -- SOR_CLI_���Ž�û��ǥ�⺻
                            ,TB_SOR_CCR_EVL_BZNS_OTL_TR D  -- SOR_CCR_�򰡾�ü���䳻��
                    WHERE    A.CLN_ACNO        = B.ACN_DCMT_NO
                    AND      B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO
                    AND      C.CRDT_EVL_NO     = D.CRDT_EVL_NO
                    AND      B.CLN_APC_DSCD    = '01'    -- ���Ž�û�����ڵ�(01:�ű�)
                    AND      A.CLN_TSK_DSCD    = '11'
                    --AND      SUBSTR(D.CRDT_EVL_INDS_CLSF_CD,1,2) NOT IN ('55','56','45','46','47','68','69')  -- ���ܾ���
                    -- ���������ڱ� ������δ� �ʿ��� ����������
                    -- �־��� ���¿� ����з��ڵ带 ä���ֱ⸸ �ϸ�Ǵ� �Ͷ� �ϴ� ���� �����Ͽ� �۾�: �����
                    GROUP BY A.CLN_ACNO
                            ,C.CRDT_EVL_NO
                            ,D.CREV_RPSR_NM
                            ,D.HDFC_MLSV_ADR
                            ,D.BZNS_NM
                            ,BRN
                            ,D.RNNO
                            ,D.CRDT_EVL_INDS_CLSF_CD
                            ,D.HDFC_ZIP
                            ,D.FTRY_ZIP
                            ,D.FTRY_ZADR
                            ,D.BSBR_ZIP
                            ,D.BSBR_ZADR
            )      C
            ON     B.INTG_ACNO =  C.CLN_ACNO


LEFT OUTER JOIN   -- ��ü������ ������
            (
              SELECT   DISTINCT
                       A.ZIP
                      ,CASE WHEN TRIM(A.MPSD_NM)  IN ('��걤����','����Ư����','�λ걤����','��õ������','���ֱ�����','�뱸������','����������')
                                 THEN TRIM(A.MPSD_NM)
                            ELSE TRIM(A.MPSD_NM) || ' ' || SUBSTR(A.CCG_NM,1,LOCATE(A.CCG_NM,' '))
                       END      AS  ADR_
              FROM
                       TB_SOR_CMI_ZIP_BC   A
              JOIN   (
                        SELECT ZIP,MAX(ZIP_SNO) MAX_ZIP_SNO
                        FROM TB_SOR_CMI_ZIP_BC
                        WHERE 1=1
                        AND   ZIP_SNO <>  '999'
                        AND   LDGR_STCD       = '1'
                        GROUP BY ZIP
                     )      B
              ON     A.ZIP     =  B.ZIP
              AND    A.ZIP_SNO =  B.MAX_ZIP_SNO
              WHERE  A.LDGR_STCD       = '1'
            )    CC
            ON    C.HDFC_ZIP  = CC.ZIP

//}

//{�Ϻδ㺸��㺸�ݾ� ������ ����
-- case1 �������
SELECT      A.���հ��¹�ȣ
           ,A.�㺸�ڵ�
           ,A.�����ܾ�
           ,B.���Ž�û��ȣ
           ,C.MRT_NO            AS  �㺸��ȣ
           ,C.AVL_WRT_MRAM      AS  ��ȿ��ġ�㺸�ݾ�
           ,ROW_NUMBER() OVER(PARTITION BY C.CLN_APC_NO,C.MRT_NO ORDER BY STUP_NO DESC) AS �ֱټ�����  -- ��������̳Ŀ� ���� ��ȿ��ġ�㺸�ݾ��� �޶������ִ�

INTO        #�Ϻδ㺸��㺸�ݾ�    -- DROP TABLE   #�Ϻδ㺸��㺸�ݾ�
FROM        (
             SELECT      A.���հ��¹�ȣ
                        ,A.�㺸�ڵ�
                        ,SUM(A.�ܾ�)     AS   �����ܾ�
             FROM        #�������   A
             WHERE       1=1
             AND         A.������� = '3.���λ����'           -- ���λ����
             AND         LEFT(A.ǥ�ػ���з��ڵ�,4) = '6811'   -- �ε����Ӵ����
             AND         A.�㺸�ڵ� BETWEEN '001' AND '199'    -- �㺸�ڵ� �ε�����
             GROUP BY    A.���հ��¹�ȣ
                        ,A.�㺸�ڵ�
            )            A

JOIN        (
             SELECT      A.ACN_DCMT_NO            AS  ���¹�ȣ
                        ,MAX(A.CLN_APC_NO)        AS  ���Ž�û��ȣ
             FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
             JOIN        DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
                         ON  A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
             JOIN        (
                           SELECT   A.ACN_DCMT_NO         AS ���¹�ȣ
                                   ,MAX(B.HDQ_APRV_DT)    AS ��������
                           FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_���Ž�û�⺻) -- ����ɻ�
                                   ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
                           WHERE    A.ACN_DCMT_NO       IN  ( SELECT DISTINCT ���հ��¹�ȣ FROM #������� WHERE �������   = '3.���λ����' AND LEFT(ǥ�ػ���з��ڵ�,4) = '6811')
                           AND      A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
                           AND      A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
                           AND      A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
                           AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ
                           AND      B.HDQ_APRV_DT       <= '20161231'   -- ��������
                           GROUP BY A.ACN_DCMT_NO
                          )   C
                          ON     A.ACN_DCMT_NO       = C.���¹�ȣ
                          AND    B.HDQ_APRV_DT       = C.��������
             WHERE       1=1
             AND         A.APC_LDGR_STCD     = '10'              -- ��û��������ڵ�(10:�Ϸ�)
             AND         A.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�
             AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- ���Ž�û�Ϸᱸ���ڵ�(20:����,21:����)
             //-------------------------------------------------------------------------------------------------
             AND         A.APC_MRT_DSCD     = '03'               --��û�㺸�����ڵ�(03:�Ϻδ㺸��)
                                                                 --�����Ͻ��� ������û���� �Ϻδ㺸�� �� ���¸� ������� �Ѵ�.
             //-------------------------------------------------------------------------------------------------
             GROUP BY    A.ACN_DCMT_NO
            )  B
            ON     A.���հ��¹�ȣ   =  B.���¹�ȣ

JOIN        TT_SOR_CLM_MM_APC_MRT_EVL_TR   C   --  SOR_CLM_����û�㺸�򰡳���
            ON     B.���Ž�û��ȣ  = C.CLN_APC_NO
            AND    C.STD_YM        = '201612'
;

-- case 2 �������

CSS_MRT_DSCD  CSS�㺸�����ڵ�
01  �㺸��
02  �㺸/�����νſ��
03  �Ϻδ㺸��  <=====
04  �����νſ��
05  �������ſ��

TB_SOR_PLI_APC_POT_MRT_TR SOR_PLI_��û�����㺸����  AVL_MRT_AMT ��ȿ�㺸�ݾ�

��ȿ�㺸����

�ȳ��ϼ���~ �����...������ �����̴ּ� �����Դϴ�..

TB_SOR_PLI_SYS_JUD_RSLT_TR (SOR_PLI_�ý��۽ɻ�������)

CRLN_SMTL_AMT  (�ſ��ѵ��հ�ݾ�) ==> ���ֽſ��ѵ��հ�ݾ�:�ſ��ѵ�
RL_MRT_AMT (�Ǵ㺸�ݾ�)  => ��û�㺸�����: �㺸�ѵ�(�Ǵ㺸�ݾ�)
LN_LMT_AMT (�����ѵ��ݾ�) => �Ѵ��Ⱑ���ѵ�

�Ϲ�������
CSS�㺸������ 3 (�Ϻδ㺸��)�� ���..

LN_LMT_AMT = RL_MRT_AMT + CRLN_SMTL_AMT

�����ѵ��ݾ� = �Ǵ㺸�ݾ� + �ſ��ѵ��հ�ݾ�

//}


//{ #���׻�ȯ  #���º����� #����
SELECT      A.MIN_STD_DT                   AS  STD_DT
           ,A.INTG_ACNO
           ,A.CLN_EXE_NO
           ,A.AGR_DT
           ,A.LN_EXE_AMT
           ,MAX(B.TR_DT)                   AS  �ߵ���ȯ����
           ,SUM(B.TR_PCPL)                 AS  ���ݻ�ȯ�ݾ�

INTO        #�ߵ���ȯ����     -- DROP TABLE #�ߵ���ȯ����

FROM        #TEMP                     A

JOIN        DWZOWN.TB_SOR_LOA_TR_TR     B       --  LOA_�ŷ�����
            ON     A.INTG_ACNO  = B.CLN_ACNO
            AND    A.CLN_EXE_NO  = B.CLN_EXE_NO
            AND    B.TR_DT  BETWEEN  A.AGR_DT AND
                                CASE WHEN CONVERT(CHAR(8), DATEADD(MM, 2, A.AGR_DT), 112) > '20170131' THEN  '20170131'
                                     ELSE CONVERT(CHAR(8), DATEADD(MM, 2, A.AGR_DT), 112)
                                END -- �����Ϸ� ���� 2�����̳� ��ȯ�ȳ���,�ִ� 20170131������ ������� ��
            AND    B.TR_STCD    = '1'           --�ŷ������ڵ�:1(����)
            AND    B.TR_PCPL > 0                --�ŷ�����
            AND    B.CLN_TR_KDCD ='300'         --���Űŷ������ڵ�:300(�����ȯ)

GROUP BY    A.MIN_STD_DT
           ,A.INTG_ACNO
           ,A.CLN_EXE_NO
           ,A.AGR_DT
           ,A.LN_EXE_AMT

HAVING      A.LN_EXE_AMT  - ���ݻ�ȯ�ݾ� <= 0   -- ����ݾ��� ���� ��ȯ�Ȱ�
;

//}

//{  #���ͳݹ�ŷ  #����Ϲ�ŷ #SH���� #���ͳ� #�����  #����

LEFT OUTER JOIN
            (-- ���ͳݹ�ŷ ��������
             SELECT   RMN_NO     AS �Ǹ��ȣ
                     ,CUST_STCD  AS ������
             FROM     TB_PB_CUST_INF       -- PB_������
             WHERE    TSK_DC_CD = '3'    -- 3:���ͳݹ�ŷ
            )    D
            ON   A.RNNO  = D.�Ǹ��ȣ

LEFT OUTER JOIN
            (-- ����Ϲ�ŷ ��������
             SELECT   RMN_NO    AS �Ǹ��ȣ
                     ,MBL_STCD  AS ����ϻ���
             FROM     TB_PB_MBL_CUST_INF  -- PB_����ϰ�����
             WHERE    MBL_DC_CD = '3'    -- 3:����Ʈ��
            ) E
            ON   A.RNNO  = E.�Ǹ��ȣ

LEFT OUTER JOIN
            TB_DWF_UMS_Ǫ�ð��⺻    F
            ON   A.CUST_NO   = F.����ȣ
            AND  F.Ǫ�ð��Կ��� = 'Y'

//}

//{  #��ȯ #���Ž�û�����ڵ� #�űԴ�ȯ

-- CASE1 ��û���忡 �� ��ȯ������ ���ϱ�
SELECT      DISTINCT
            A.STD_DT                     AS  ��������
           ,A.BRNO                       AS  ����ȣ
           ,A.CUST_NO                    AS  ����ȣ
           ,A.INTG_ACNO                  AS  ���հ��¹�ȣ
           ,CASE WHEN   D.CLN_APC_DSCD IS NOT NULL  THEN
                        CASE WHEN D.CLN_APC_DSCD = '02'  THEN   '02.��ȯ' ELSE '01.�ű�'  END
                 ELSE   CASE WHEN E.CLN_APC_DSCD = '02'  THEN   '02.��ȯ' ELSE '01.�ű�'  END
            END           AS �űԴ�ȯ����
--           ,D.CLN_APC_DSCD               AS  ���Ž�û�����ڵ�1
--           ,E.CLN_APC_DSCD               AS  ���Ž�û�����ڵ�2
           ,A.AGR_DT                     AS  ��������
           ,A.AGR_AMT                    AS  �����ݾ�
           ,A.LN_SBCD                    AS  ��������ڵ�
           ,A.PDCD                       AS  ��ǰ�ڵ�
           ,ISNULL(TRIM(Z3.PRD_KR_NM),' ')         AS ��ǰ�ڵ��

           ,CASE WHEN   LEFT(A.AGR_DT,6) = LEFT(A.STD_DT,6)   THEN  'O' ELSE 'X' END AS �űԾ�������

INTO        #������           -- DROP TABLE #������

FROM        DWZOWN.OT_DWA_INTG_CLN_BC A   -- DWA_���տ��ű⺻

LEFT OUTER JOIN
            TB_SOR_PLI_CLN_APC_BC      D  -- SOR_PLI_���Ž�û�⺻
            ON   A.INTG_ACNO        = D.CLN_ACNO
            AND  D.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- ���Ž�û�����ڵ�(01:�ű�,02:��ȯ)
            AND  D.NFFC_UNN_DSCD     = '1'               -- �߾�ȸ���ձ����ڵ�

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APC_BC      E    -- SOR_CLI_���Ž�û�⺻
            ON  A.INTG_ACNO        = E.ACN_DCMT_NO
            AND E.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- ���Ž�û�����ڵ�(01:�ű�,02:��ȯ)
            AND E.NFFC_UNN_DSCD   = '1'     -- �߾�ȸ
            AND E.APC_LDGR_STCD   = '10'    -- ��û��������ڵ�(01:�ۼ���,02:������,10:�Ϸ�,99:���)
            AND E.CLN_APC_CMPL_DSCD IN ('20','21') -- ���Ž�û�Ϸᱸ���ڵ�

-- CASE2 ���¿���⺻�� �� ���������� ��ȯ���±��ϱ�
-- ��ȯ���¿��� UPDATE
UPDATE      #����ڱ�  A
SET         A.��ȯ���¿���  = 'Y'
FROM        (
             -- �ϳ��� ���°� �������·� ��ȯ�Ǵ°�� ����
             -- �������� ���°� �ϳ��� ���·� ��ȯ�Ǵ°�� ����
             -- ��ȯ�����¶� �ϴ��� ��ȯ�Ŀ� �������·� �ݵ�� ���ϴ°� �ƴѰ� ����
             -- ������ �ΰ� ������ ��ȯ�İ��°� ���ü�����
             -- ������ ��ȯ���̶� CLN_ACN_LNK_KDCD(���Ű��¿��������ڵ�)  �� 121,122 �� ���� �ߺ��ؼ� ��Ÿ���� ��쵵 �ְ�
             -- �ѹ��� ��Ÿ���� ��쵵 ����
             SELECT      DISTINCT A.��ȯ�İ���,A.�ŷ�����
             FROM
                         (
                          SELECT   A.CLN_ACN_LNK_KDCD
                                  ,A.ENR_DT                 AS  �ŷ�����
                                  ,CASE WHEN A.CLN_ACN_LNK_KDCD = '121' THEN A.LNK_CLN_FCNO ELSE  A.CLN_ACNO      END  AS  ��ȯ������
                                  ,CASE WHEN A.CLN_ACN_LNK_KDCD = '121' THEN A.CLN_ACNO     ELSE  A.LNK_CLN_FCNO  END  AS  ��ȯ�İ���
                          FROM     TB_SOR_LOA_ACN_LNK_BC A      -- SOR_LOA_���¿���⺻
                          WHERE    A.CLN_ACN_LNK_KDCD  IN ('121','122')  -- 121 ��ȯ����(��ȯ������), 122 ��ȯ����(��ȯ�İ���)
                         )   A
            )   D
WHERE       1=1
AND         A.���հ��¹�ȣ      = D.��ȯ�İ���
AND         A.��������         >= D.�ŷ�����
;
//}

//{  #IF  #IF�� #ELSE

//--------------------------------------------------------------------------------------
IF  P_���� = 1  THEN
//--------------------------------------------------------------------------------------
......
//-------------------------------------------------------------------------------
ELSEIF    P_���� = 2   THEN
//-------------------------------------------------------------------------------
.......
//-------------------------------------------------------------------------------
END IF;
//-------------------------------------------------------------------------------
//}

//{  #��ü�� #�ܺ��� #������� #�㺸��  #�ε���㺸  #������� #�����򰡱��

--1. �򰡹�������ڵ� (��ü����,�ܺΰ��� �з� ���)
-- ������ȣ��(APSL_NO)�� �����⺻���� �ְ� �ε���㺸�⺻���� �ִ�, �̵��� ���� ���� �ٸ��� �ִ�.
-- �����⺻�� ������ȣ�� ���������� ����������ȣ��� ����ǰ� �ε���㺸�⺻�� ������ȣ�� �׳ĸ��� �׽����� ����������ȣ��� ����ȴ�
-- ��ü�����̳� �ܺΰ����̳ĸ� �����ϴ�                     ,C.EVL_MTH_DSCD   AS  �򰡹�������ڵ�_�ε������
                       ,D.EVL_MTH_DSCD   AS  �򰡹�������ڵ�_��������
                       ,D.APSL_MTH_DSCD  AS  ������������ڵ�_��������

JOIN        (  -- EQUAL JOIN�Ѵ�. �ε��� �㺸�򰡹�� ������ �����ѰǸ� ���ڷ��� ���������� �Ѵ�
              SELECT    A.STD_YM
                       ,A.ACN_DCMT_NO
                       ,COUNT(DISTINCT CASE WHEN C.EVL_MTH_DSCD IN ('01','02')       THEN C.MRT_NO  ELSE NULL END)  AS ��ü�򰡴㺸�Ǽ�
                       -- 01���� KB����Ʈ �ü��� ���Ѱ� ���Ե�
                       ,COUNT(DISTINCT CASE WHEN C.EVL_MTH_DSCD IN ('03','04','05')  THEN C.MRT_NO  ELSE NULL END)  AS �ܺ��򰡴㺸�Ǽ�
               FROM     TT_SOR_CLM_MM_CLN_LNK_TR  A   --SOR_CLM_�����ſ��᳻��
                       ,TT_SOR_CLM_MM_STUP_BC     B   --SOR_CLM_�������⺻
                       ,TT_SOR_CLM_MM_REST_MRT_BC C   --SOR_CLM_���ε���㺸�⺻

              WHERE     1=1
              AND       A.STD_YM  BETWEEN '201301'  AND  '201706'
--              AND       A.STD_YM  IN  ('201312','201412','201512','201612','201706')
              AND       A.STD_YM         = B.STD_YM
              AND       A.STUP_NO        = B.STUP_NO
              AND       B.STD_YM         = C.STD_YM
              AND       B.MRT_NO         = C.MRT_NO
              AND       A.NFFC_UNN_DSCD  = '1'
             //=================================================================================
              AND       C.EVL_MTH_DSCD  IN ('01','02','03','04','05') -- �ε��� �㺸�򰡹�� ������ �����ѰǸ� ���ڷ��� ���������� �Ѵ�, �Ҽ����� ���� ���°�쵵����
              AND       A.CLN_LNK_STCD  IN ('02','03')     -- ���ſ�������ڵ�(02:����,03:��������,04:����)
              AND       B.STUP_STCD     IN ('02','03')     -- ���������ڵ�(����)(02:����,03:��������,04:����)
              AND       C.MRT_STCD      IN ('02')          -- �㺸����(02:������,04:�㺸����)
--              AND       ( C.NFM_YN      IS NULL  OR   C.NFM_YN   = 'N')         -- �����㺸 �ƴҰ�,1���ڷῡ�� ���Ծȵ� ���ǹ�
--              AND       ( C.AFCP_MRT_YN IS NULL  OR   C.AFCP_MRT_YN  = 'N')     -- ����㺸 �ƴҰ�,1���ڷῡ�� ���Ծȵ� ���ǹ�
              //=================================================================================
              AND       A.ENR_DT        >= '20100101'
              GROUP BY  A.STD_YM
                       ,A.ACN_DCMT_NO
            )            G
            ON   LEFT(A.STD_DT,6) = G.STD_YM
            AND  A.INTG_ACNO      = G.ACN_DCMT_NO

--2. �򰡹�������ڵ�� ������� ���ϱ�
--    ������å��(20170830)_�ű�����ִ����Ȳ_�ֿ�ǿ�_�ӿ���.sql �� �Ϻ�
SELECT      A.STD_YM           AS ���س��
           ,A.MRT_NO           AS �㺸��ȣ
           ,B.ACN_DCMT_NO      AS ���Ű��¹�ȣ
           ,C.JUD_SMTL_AMT     AS �ɻ��հ�ݾ�
           ,C.EVL_MTH_DSCD     AS �򰡹�������ڵ�
           ,CASE D.EVL_RSRC_DSCD  WHEN '01' THEN  '1'    -- 'KB�ü�_��������'
                                  WHEN '02' THEN  '2'    -- 'TECH�ü�_�ѱ�������'
                                  WHEN '09' THEN  '3'    -- '�ܺΰ����򰡱��'
                                  ELSE '7'       -- '��Ÿ'
            END                AS �����򰡱��

           ,ROW_NUMBER() OVER (PARTITION BY LEFT(A.STD_YM,4), B.ACN_DCMT_NO ORDER BY A.STUP_AMT DESC) AS ��ǥ_�㺸

INTO        #�������  -- DROP TABLE #�������

FROM        TT_SOR_CLM_MM_STUP_BC     A    --SOR_CLM_�������⺻

JOIN        TT_SOR_CLM_MM_CLN_LNK_TR  B    --SOR_CLM_�����ſ��᳻��
            ON   A.STD_YM   =  B.STD_YM
            AND  A.STUP_NO  =  B.STUP_NO       --������ȣ
            AND  B.ACN_DCMT_NO   IN (SELECT DISTINCT ���հ��¹�ȣ  FROM #�������)
            AND  B.CLN_LNK_STCD  IN ('02','03')     --���ſ�������ڵ�(02:����,03:��������)
            AND  B.NFFC_UNN_DSCD = '1'

JOIN        TT_SOR_CLM_MM_REST_MRT_BC  C        --SOR_CLM_���ε���㺸�⺻
            ON    A.STD_YM        = C.STD_YM
            AND   A.MRT_NO        = C.MRT_NO
            AND   C.MRT_STCD      = '02'

JOIN        TB_SOR_CLM_BLD_MRT_APSL_DL      D   -- SOR_CLM_�ǹ��㺸������
            ON    C.APSL_NO       = D.APSL_NO

WHERE       A.STD_YM        IN (  SELECT     LEFT(MAX(STD_DT),6)
                                   FROM      OT_DWA_INTG_CLN_DT_BC
                                   WHERE     1=1
                                   AND       STD_DT  BETWEEN '20160101' AND '20170630'
                                   GROUP BY  LEFT(STD_DT,6)
                                )
AND         A.NFFC_UNN_DSCD = '1'             --�߾�ȸ���ձ����ڵ�
AND         A.STUP_STCD     = '02'            --���������ڵ�(02:������)
;
//}

//{  #��ȭ���� #��ȭ������� #�̻���ѵ�

SELECT      CASE WHEN K.ACSB_CD5  IN ('95001111','14002501','14002601')                               THEN '1. ��ȭ����������'
                 WHEN K.ACSB_CD5  IN ('96003411','14002401','96000211') OR A.BS_ACSB_CD = '95000211'  THEN '2. ��ȭ����������'
                 WHEN K.ACSB_CD5  IN ('96003511')                                                     THEN '3. ��ȭ�ſ�ī�����'
                 ELSE A.BS_ACSB_CD || '(' || TRIM(ACSB_NM) || ')'
            END   ����
           ,SUM(NUS_LMT_AMT)  AS �ܾ�
FROM        TB_SOR_LOC_DDY_NUSE_LMT_TR   A -- SOR_LOC_�Ϻ��̻���ѵ�����

JOIN        (
                  SELECT   STD_DT
                          ,ACSB_CD
                          ,ACSB_NM
                          ,ACSB_CD4  --��ȭ�����
                          ,ACSB_NM4
                          ,ACSB_CD5  --����ڱݴ����(14002401), �����ڱݴ����(14002501), �����ױ�Ÿ(14002601)
                          ,ACSB_NM5
                          ,ACSB_CD6
                          ,ACSB_NM6
                  FROM     OT_DWA_DD_ACSB_TR
                  WHERE    1=1
                  AND      FSC_SNCD IN ('I','C')
            )           K
            ON       A.BS_ACSB_CD   =   K.ACSB_CD
            AND      A.DWUP_STD_DT       =   K.STD_DT

WHERE       A.DWUP_STD_DT = '20170831'
AND         A.NFFC_UNN_DSCD = '1'
GROUP BY    ����
ORDER BY     1
;
//}


//{  #���տ����� #���տ�

SELECT      A.����
           ,A.����ȣ
           ,B.UNN_CD ||'.'||ISNULL(TRIM(X1.CMN_CD_NM),' ')    AS  �����ڵ�
           ,B.UNNR_DSCD ||'.'||ISNULL(TRIM(X2.CMN_CD_NM),' ') AS  ���տ�����

FROM        #����   A

LEFT OUTER JOIN
            TB_SOR_CUS_UNN_BC   B
            ON   A.����ȣ   = B.CUST_NO

 LEFT OUTER JOIN
            OM_DWA_CMN_CD_BC       X1                  -- DWA_�����ڵ�⺻
            ON    B.UNN_CD  = X1.CMN_CD                -- �����ڵ�
            AND   X1.TPCD_NO_EN_NM = 'UNN_CD'          -- �����ڵ��ȣ������

 LEFT OUTER JOIN
            OM_DWA_CMN_CD_BC       X2                  -- DWA_�����ڵ�⺻
            ON    B.UNNR_DSCD  = X2.CMN_CD             -- �����ڵ�
            AND   X2.TPCD_NO_EN_NM = 'UNNR_DSCD'       -- �����ڵ��ȣ������
;
//}

//{  #������ #�ſ�  #�ſ�ȸ��

SELECT      A.���հ��¹�ȣ

           ,CASE WHEN C2.��� IS NOT NULL THEN '�ſ�������' ELSE NULL END   AS �ſ�����������

INTO        #�����ڵ�  -- DROP TABLE #�����ڵ�
FROM

LEFT OUTER JOIN  -- ���ְ� �ſ��������� Ȯ���Ѵ�
            TB_MDWT�λ�  C2
            ON    A.�Ǹ��ȣ  =  C2.�ֹι�ȣ
            AND   C2.�ۼ�������  = ( SELECT STD_DT FROM  OM_DWA_DT_BC  WHERE STD_DT_YN = 'Y' )
            AND   �������� üũ�Ұ�
            AND   C2.ȸ���ڵ�� = '�ſ�ȸ��'
//}

//{  #UP_DWZ_����_N0093_�㺸��������Ȳ  #�㺸����

-- UP_DWZ_����_N0093_�㺸��������Ȳ ���� ����ϴ� �ſ�/�㺸/���� �㺸���� ���
    INSERT INTO #TEMP_����������
    SELECT   '.'                      AS �鿩����
            ,�Ǹ��ȣ
            ,�����ڵ�
            ,�������ڵ�
            ,CASE WHEN �㺸�����ڵ� = '5' THEN 'B'
                  WHEN �㺸�����ڵ� = '6' THEN 'C'
                  ELSE 'A'
             END                    AS �ڵ�
            ,CASE WHEN �㺸�����ڵ� = '5' THEN '����'
                  WHEN �㺸�����ڵ� = '6' THEN '�ſ�'
                  ELSE '�㺸'
             END                    AS �ڵ��
            ,MAX(����ſ��򰡵��)  AS �ſ��򰡵��
            ,SUM(�����ܾ�)          AS �����ܾ�
            ,ISNULL(�������, '0')  AS ��������ڵ�
            ,ISNULL(��������, '0')  AS ���������ڵ�
    FROM     #TEMP_�����������Ϻ� A  --SELECT * FROM #TEMP_���������� WHERE �ڵ� = 'C'
--SELECT * FROM #TEMP_�����������Ϻ� WHERE ���¹�ȣ = '101000135468'
    GROUP BY �����ڵ�
            ,�Ǹ��ȣ
            ,�������ڵ�
            ,�ڵ�
            ,�ڵ��
            ,��������ڵ�
            ,���������ڵ�
    ;

--  ������å��(20170926)_��ȭ����ݴ㺸����Ȳ_�ӿ���.SQL
-- �ִ㺸�ڵ�� �з��� ��
           ,CASE WHEN F.MRT_TPCD   = '5'              THEN 'A. ����'
                 WHEN F.MRT_TPCD   = '6'              THEN
                      CASE WHEN F.MRT_CD  IN ('602','603')  THEN  'B.1 �����ſ�'
                           WHEN F.MRT_CD  IN ('601')        THEN  'B.2 ��������'
                           ELSE 'B.9 UNKOWN'
                      END
                 WHEN F.MRT_TPCD  = '1'  THEN
                      CASE WHEN  F.REST_CLCD = '1'   THEN
                                 CASE WHEN F.MRT_CD  IN ('101')   THEN 'C.1.1 ����Ʈ'
                                      ELSE                             'C.1.2 ��Ÿ'
                                 END
                           ELSE                                  'C.2 �Ϲݺε���'
                      END
                 WHEN F.MRT_TPCD  IN  ('2','3','4')  THEN   'C.3 ��Ÿ����'
                 ELSE 'Z. UNKNOWN'
            END                          AS  �㺸����


//}

//{  #MCI  #MCG
SELECT      T.���¹�ȣ
--           ,C.HSGR_GRN_DSCD  AS  ���ú������������ڵ�
           ,B.�㺸��ȣ
           ,B.�㺸�ڵ�
           ,CASE WHEN B.�����������ڵ� = '11' THEN '11.���ýſ뺸����'
                 WHEN B.�����������ڵ� = '51' THEN '51.MCI��������'
            END           AS ����������
           ,C.HSGR_GRN_DSCD     AS  ���ú��������ڵ�
--           ,CASE WHEN C.HSGR_GRN_DSCD IS NOT NULL THEN 'MCG' ELSE 'MCI' END AS MCI����
INTO        #TEMP_�������⺻   --DROP TABLE #TEMP_�������⺻
FROM        (SELECT   DISTINCT ���¹�ȣ  FROM #������_�ܾ� )      T
JOIN        (
             SELECT   DISTINCT        -- ���ϴ㺸�� �������� ������ �����ϹǷ� �ϳ��� �������� ����
                      A.ACN_DCMT_NO AS ���հ��¹�ȣ
                     ,C.MRT_NO      AS �㺸��ȣ
                     ,C.MRT_CD      AS �㺸�ڵ�
                     ,D.WRGR_DSCD   AS �����������ڵ�
                     ,C.WRGR_NO     AS ��������ȣ
                     --,C.GRN_RT      AS ��������
                     --,D.GRMN        AS ������
                     --,SUBSTRING(D.WRGR_ISN_DT,1,4)   AS  �������߱޳⵵
                     --,D.GRMN                         AS  ���Աݾ�
                     --,D.GRN_FEE                      AS  ������
             FROM     DWZOWN.TB_SOR_CLM_CLN_LNK_TR   A --SOR_CLM_���ſ��᳻��
                     ,DWZOWN.TB_SOR_CLM_STUP_BC      B --SOR_CLM_�����⺻
                     ,DWZOWN.TB_SOR_CLM_WRGR_MRT_BC  C --SOR_CLM_�������㺸�⺻
                     ,DWZOWN.TB_SOR_LOE_INTG_WRGR_BC D --SOR_LOE_���պ������⺻
             WHERE    A.CLN_LNK_STCD IN ('02','03','04')       --���ſ�������ڵ�:02(����)
             AND      A.STUP_NO       = B.STUP_NO              --������ȣ
             AND      B.MRT_NO        = C.MRT_NO               -- �㺸��ȣ
             AND      C.WRGR_NO       = D.WRGR_NO
             AND      D.WRGR_DSCD    IN ('51','11')      -- �����������ڵ�(51:MCI��������), 11:���ýſ뺸����)
             AND      D.WRGR_STCD    IN ('04','05','09') -- MCI-04, MCG-05 AND 09�� ��ȿ
            )     B
            ON   T.���¹�ȣ  =   B.���հ��¹�ȣ
LEFT OUTER JOIN
            TB_SOR_LOE_HFG_WRGR_BC  C -- SOR_LOE_���ñ��������������⺻
            ON   B.��������ȣ  =  C.WRGR_NO
            AND  C.HSGR_GRN_DSCD  IN ('08')   --���ú������������ڵ� 08:���ຸ��
WHERE       1=1
//----------MCI���������� ����, ���ýſ뺸������ ���ú��������ڵ� 08�ΰ�츸 ���--------------------
AND         (          --
             B.�����������ڵ� = '51'  OR
             ( B.�����������ڵ� = '11'  AND C.WRGR_NO IS NOT NULL)
            )
//--------------------------------------------------------------------------------------------
;

//}

//{  #��û����  #��û����
-- CASE1 ���迩��
SELECT      A.CLN_APC_NO
           ,A.CLN_APC_DSCD
           ,A.CLN_APC_PGRS_STCD
           ,A.APC_DT
           ,A.CLN_APC_AMT
           ,A.PDCD
           ,A.ADM_BRNO
           ,A.CUST_NO
           ,C.JB_CD

INTO        #TEMP_��û   --DROP TABLE #TEMP_��û
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC   A            --SOR_PLI_���Ž�û�⺻ --> ���νɻ�

JOIN        DWZOWN.TB_SOR_CMI_BR_BC        B            --SOR_CMI_���⺻
            ON      A.ADM_BRNO     = B.BRNO

JOIN        DWZOWN.OM_DWA_INTG_CUST_BC    C     --DWA_���հ��⺻
            ON      A.CUST_NO      =  C.CUST_NO

WHERE       A.CLN_APC_DSCD      < '10'       --�ű�
--AND         A.CSS_MRT_DSCD      = '05'    -- 05:�������ſ��
--AND         A.CLN_APC_PGRS_STCD IN ('03','04','13')     --���Ž�û��������ڵ�(03:����Ϸ�, 04:����Ϸ� ,13:�����Ϸ�)
AND         A.NFFC_UNN_DSCD     = '1'                   --�߾�ȸ���ձ����ڵ�
AND         A.APC_DT      BETWEEN '20130101' AND '20170630'
;

-- 1. ��û
SELECT      CASE WHEN LEFT(A.JB_CD,2) =  '10'  THEN '10. �޿��ҵ���'
                 WHEN LEFT(A.JB_CD,2) =  '20'  THEN '20. ������'
                 WHEN LEFT(A.JB_CD,2) =  '30'  THEN '30. �ڿ�����'
                 WHEN LEFT(A.JB_CD,2) =  '31'  THEN '31. ���λ����'
                 WHEN LEFT(A.JB_CD,2) =  '40'  THEN '40. �󸲾����'
                 WHEN LEFT(A.JB_CD,2) =  '50'  THEN '50. ������'
                 WHEN LEFT(A.JB_CD,2) =  '60'  THEN '60. �ֺ�(����������)'
                 WHEN LEFT(A.JB_CD,2) =  '61'  THEN '61. �л�'
                 WHEN LEFT(A.JB_CD,2) =  '62'  THEN '62. ����'
                 WHEN LEFT(A.JB_CD,2) =  '90'  THEN '90. ����'
                 ELSE                               '99. UNKNOWN'
            END               AS  ����

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2013'  THEN A.CLN_APC_NO ELSE NULL END) AS �Ǽ�_2013
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2013'  THEN A.CLN_APC_AMT ELSE NULL END)           AS �ݾ�_2013

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2014'  THEN A.CLN_APC_NO ELSE NULL END) AS �Ǽ�_2014
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2014'  THEN A.CLN_APC_AMT ELSE NULL END)           AS �ݾ�_2014

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2015'  THEN A.CLN_APC_NO ELSE NULL END) AS �Ǽ�_2015
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2015'  THEN A.CLN_APC_AMT ELSE NULL END)           AS �ݾ�_2015

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2016'  THEN A.CLN_APC_NO ELSE NULL END) AS �Ǽ�_2016
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2016'  THEN A.CLN_APC_AMT ELSE NULL END)           AS �ݾ�_2016

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2017'  THEN A.CLN_APC_NO ELSE NULL END) AS �Ǽ�_2017
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2017'  THEN A.CLN_APC_AMT ELSE NULL END)           AS �ݾ�_2017

FROM        #TEMP_��û A

GROUP BY    ����
ORDER BY    1
;

-- 2. ��û & ����
SELECT      CASE WHEN LEFT(A.JB_CD,2) =  '10'  THEN '10. �޿��ҵ���'
                 WHEN LEFT(A.JB_CD,2) =  '20'  THEN '20. ������'
                 WHEN LEFT(A.JB_CD,2) =  '30'  THEN '30. �ڿ�����'
                 WHEN LEFT(A.JB_CD,2) =  '31'  THEN '31. ���λ����'
                 WHEN LEFT(A.JB_CD,2) =  '40'  THEN '40. �󸲾����'
                 WHEN LEFT(A.JB_CD,2) =  '50'  THEN '50. ������'
                 WHEN LEFT(A.JB_CD,2) =  '60'  THEN '60. �ֺ�(����������)'
                 WHEN LEFT(A.JB_CD,2) =  '61'  THEN '61. �л�'
                 WHEN LEFT(A.JB_CD,2) =  '62'  THEN '62. ����'
                 WHEN LEFT(A.JB_CD,2) =  '90'  THEN '90. ����'
                 ELSE                               '99. UNKNOWN'
            END               AS  ����

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2013'  THEN A.CLN_APC_NO ELSE NULL END) AS �Ǽ�_2013
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2013'  THEN A.CLN_APC_AMT ELSE NULL END)           AS �ݾ�_2013

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2014'  THEN A.CLN_APC_NO ELSE NULL END) AS �Ǽ�_2014
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2014'  THEN A.CLN_APC_AMT ELSE NULL END)           AS �ݾ�_2014

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2015'  THEN A.CLN_APC_NO ELSE NULL END) AS �Ǽ�_2015
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2015'  THEN A.CLN_APC_AMT ELSE NULL END)           AS �ݾ�_2015

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2016'  THEN A.CLN_APC_NO ELSE NULL END) AS �Ǽ�_2016
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2016'  THEN A.CLN_APC_AMT ELSE NULL END)           AS �ݾ�_2016

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2017'  THEN A.CLN_APC_NO ELSE NULL END) AS �Ǽ�_2017
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2017'  THEN A.CLN_APC_AMT ELSE NULL END)           AS �ݾ�_2017

FROM        #TEMP_��û  A

WHERE       1=1
AND         A.CLN_APC_PGRS_STCD NOT IN ('01','02','05','07')

GROUP BY    ����
ORDER BY    1
;
/*
01  �ۼ���
02  ������
03  ����Ϸ�
13  �����Ϸ�
04  ����Ϸ�
05  ��û���
06  ���ο�û�Ϸ�
07  ���ν��ΰ�����
09  ��������
*/

-- CASE2 �������

SELECT      LEFT(B.CSLT_DT,4)  AS  ��û�⵵
           ,CASE WHEN   F.MRT_TPCD = '6'  THEN   '1.�ſ�'
                 WHEN   F.MRT_TPCD = '5'  THEN   '2.����'
                 ELSE    '3.�㺸'
            END    AS   �㺸����

           ,CASE WHEN  A.CLN_APC_DSCD      < '10'  THEN '1. �ű�'
                 ELSE '2. ����'
            END             AS �űԿ��屸��
           ,COUNT( A.CLN_APC_NO)  AS  ���Ž�û�Ǽ�

FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC   A            --SOR_CLI_���Ž�û�⺻

JOIN        DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_���Ž�û��ǥ�⺻)
            ON     A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- ���Ž�û��ǥ��ȣ

JOIN        TB_SOR_LOA_ACN_BC       D
            ON     A.ACN_DCMT_NO  = D.CLN_ACNO

LEFT OUTER JOIN
            TB_SOR_CLM_MRT_CD_BC       F             -- (SOR_CLM_�㺸�ڵ�⺻)
            ON     D.MNMG_MRT_CD    = F.MRT_CD

WHERE       ( A.CLN_APC_DSCD      < '10'  OR  A.CLN_APC_DSCD  IN  ('11','12','13') )    --�ű�  OR ����
//----------------------------------------------------------------------------------
AND         A.CLN_APC_CMPL_DSCD NOT IN ('09','17')  -- ���Ž�û�Ϸᱸ���ڵ�,���εȰǸ�
//----------------------------------------------------------------------------------
AND         A.NFFC_UNN_DSCD     = '1'                   --�߾�ȸ���ձ����ڵ�
AND         B.CSLT_DT     BETWEEN '20150101' AND '20170630'
GROUP BY    ��û�⵵
           ,�㺸����
           ,�űԿ��屸��
ORDER BY    1,2,3
;
*CLN_APC_CMPL_DSCD(���Ž�û�Ϸᱸ���ڵ�)
*09 �ΰ�
*10 ����
*18 �����Ĺ����
*20 ����
*21 ����
*17 öȸ

//}

//{  #��ü����  #�ݰ�����ü   #��ü����ݸ�  #����ݸ� #����

-- ��ü����Ʈ (�ݰ�����ü��� �⸻���� ��ü���¸���Ʈ)
SELECT      A.STD_DT                     AS  ��������
           ,A.CUST_NO                    AS  ����ȣ
           ,A.INTG_ACNO                  AS  ���հ��¹�ȣ
           ,A.CLN_EXE_NO                 AS  ���Ž����ȣ    -- �߰�
           ,A.MRT_CD                     AS  �㺸�ڵ�
           ,A.AGR_DT                     AS  ��������
           ,AA.AGR_EXPI_DT               AS  ����������
           ,C.ACSB_NM5                   AS  �ڱݱ���
           ,A.LN_RMD                     AS  �ܾ�
           ,A.OVD_OCC_DT                 AS  ��ü�߻�����
           ,A.OVD_DCNT                   AS  ��ü�ϼ�
           ,A.FSS_OVD_ST_DT              AS  �ݰ�����ü������

INTO        #��ȭ�����_��ü   -- DROP TABLE #��ȭ�����_��ü

FROM        OT_DWA_INTG_CLN_BC   A

JOIN        DWZOWN.TT_SOR_LOA_MM_ACN_BC    AA            --SOR_LOA_�����±⺻
            ON     LEFT(A.STD_DT,6)  = AA.STD_YM
            AND    A.INTG_ACNO       = AA.CLN_ACNO

JOIN        (
              SELECT   STD_DT
                      ,ACSB_CD
                      ,ACSB_NM
                      ,ACSB_CD4  --��ȭ�����
                      ,ACSB_NM4
                      ,ACSB_CD5  --����ڱݴ����(14002401), �����ڱݴ����(14002501), �����ױ�Ÿ(14002601)
                      ,ACSB_NM5
                      ,ACSB_CD6  --��������ڱݴ����(15002001), ����ü��ڱݴ����(15002101)
                      ,ACSB_NM6
              FROM     OT_DWA_DD_ACSB_TR
              WHERE    1=1
              AND      FSC_SNCD      IN ('K','C')
              AND      ACSB_CD4 IN ('13000801')       --��ȭ�����
            )          C
            ON    A.BS_ACSB_CD  =  C.ACSB_CD
            AND   A.STD_DT      =  C.STD_DT

LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_����Ը�⺻
            ON     A.RNNO      = D.RNNO
            AND    A.STD_DT    = D.STD_DT

WHERE       1=1
AND         A.STD_DT        IN ('20131231','20141231','20151231','20161231','20170630')
AND         A.BR_DSCD       = '1'   --�߾�ȸ
AND         A.CLN_ACN_STCD  = '1'           --���Ű��»����ڵ�:1 ����
//=====================================================================================
AND         A.FSS_OVD_ST_DT IS NOT NULL AND  A.FSS_OVD_ST_DT > '19000000'   -- �ݰ�����ü����
//=====================================================================================
;

/*
��44��(��ü�������� ����) �� ��ü�������� ��ü�����, ���޺��� �����ޱ� � ���ؼ� �����Ѵ�.

�� ��ü�������� �ش� ���ſ� ���� �������ڼ����Ͽ� ������ ���űݸ��� ������ ��ü�Ⱓ�� ����ݸ��� ���Ͽ� �����Ѵ�.

1. ��ü�Ⱓ�� ����ݸ�

��. ��ü�ϼ� 1���� ���� : �� 6.0%

��. ��ü�ϼ� 1���� �ʰ� 3���� ���� : �� 7.0%

��. ��ü�ϼ� 3���� �ʰ� : �� 8.0%

 2. ��ü�Ⱓ�� ����ݸ� ���

 ��. ��ü�Ⱓ�� ����ݸ��� ��ü�߻��Ϸκ��� ��ü���� �����ϱ��� ��1ȣ�� ���� ��ü�ϼ� �������� �����Ͽ� �����Ѵ�.

��. ��ü����ݿ� ���ؼ� ��ü���ڸ� �κ� ������ ��쿡�� �����ϼ� �������� ���Ա����� ���� ����

�� ��2�׿� �ұ��ϰ� ��ü�������� ��33��(���űݸ��� ����)��3���� �ְ�ݸ��� �ʰ��� �� ����.

�� ��1�׺��� ��3�ױ����� �ұ��ϰ� �����ݴ㺸������ ��쿡�� ��ü������ ������ �����ϰ� ���������� �����Ѵ�.
*/


//}

//{  #���ο�   #CSS  #���
�ҸŸ������� ���� �� ī�� DW ���̺� ���� (201711�������� ���� ����., 201208 ~ 201710 ������ ASIS ���̺� �̿�)

����
PLI_���ο�����ASS��û�⺻(TB_PLI_AIO_ASS_APC_BC)  ->   CSS_�Ҹſ���ASS��û�⺻(TB_CSS_RM_ASS_RSLT_BC)
PLI_���ο�����ASS����⺻(TB_PLI_AIO_ASS_RSLT_BC)  ->  CSS_�Ҹſ���ASS��������⺻(TB_CSS_RM_CLN_ASS_MR_BC)
PLI_���ο�����ASS����⺻(TB_PLI_AIO_ASS_RSLT_BC)  ->  CSS_�Ҹſ���ASS��������⺻(TB_CSS_RM_CLN_ASS_SR_BC)
PLI_���ο�����ASS��������(TB_PLI_AIO_ASS_ASSC_TR)  ->  CSS_�Ҹſ���ASS��������(TB_CSS_RM_ASS_ASSC_TR)
PLI_���ο�����ASS���͸�����(TB_PLI_AIO_ASS_FLTR_TR)  ->   CSS_�Ҹſ���ASS���͸�����(TB_CSS_RM_ASS_FLTR_TR)
CSS_���ο�BSS����⺻(TB_CSS_AIO_BSS_RSLT_BC) ->  CSS_�ҸŸ���BSS����⺻(TB_CSS_RM_BSS_RSLT_BC)
CSS_���ο�BSS����⺻(TB_CSS_AIO_BSS_RSLT_BC) ->  CSS_�ҸŸ���BSS����⺻(TB_CSS_RM_BSS_RSLT_BC)
CSS_���ο�BSS������(TB_CSS_AIO_BSS_ASSC_DL)  ->  CSS_�ҸŸ���BSS��������(TB_CSS_RM_BSS_ASSC_TR)

ī��
CLT_���ο�ī��ASS��û�⺻(TB_CLT_AIO_ASS_APC_BC)  ->  CLT_�ҸŸ���ī��ASS��û�⺻(TB_CLT_RM_ASS_APC_BC)
CLT_���ο�ī��ASS����⺻(TB_CLT_AIO_ASS_RSLT_BC) ->  CLT_�ҸŸ���ī��ASS��������⺻(TB_CLT_RM_ASS_RSLT_BC)
CLT_���ο�ī��ASS����⺻(TB_CLT_AIO_ASS_RSLT_BC)  ->  CLT_�ҸŸ���ī��ASS��������⺻(TB_CLT_RM_ASS_STGY_BC)
CSM_���ο�BSS����⺻(TB_CSM_AIO_BSS_RSLT_BC)  ->  CLT_�ҸŸ���BSS����⺻(TB_CLT_RM_BSS_RSLT_BC)

//}


//{   #ä���μ�

SELECT      A.CLN_ACNO       AS  ���¹�ȣ
           ,MAX(A.ENR_DT)    AS  �������

INTO        #ä���μ�  -- DROP TABLE #ä���μ�

FROM        TB_SOR_LOA_AGR_HT   A  -- SOR_LOA_�����̷�

WHERE       1=1
AND         A.CLN_APC_DSCD  = '51'  --  ���Ž�û�����ڵ�(51: ä���μ�)
AND         A.CLN_ACNO  IN ( SELECT ���Ű��¹�ȣ FROM #TEMP )
GROUP BY    A.CLN_ACNO
;

//}

//{ ��üȽ��

SELECT      CLN_ACNO                   AS ���¹�ȣ
           ,COUNT(DISTINCT OVD_OCC_DT) AS ��üȽ��

INTO        #��ü   -- DROP TABLE #��ü
FROM        OT_DWA_LOA_OVD_TR   A  -- DWA_���ſ�ü����

WHERE       1=1
AND         A.CLN_ACNO  IN ( SELECT ���Ű��¹�ȣ FROM #TEMP )
GROUP BY    A.CLN_ACNO
;
-- SELECT COUNT(*) FROM #��ü  -- 86

//}

//{   #IFRS  #����

LEFT OUTER JOIN
            (
             SELECT    A.���հ��¹�ȣ
                      ,A.���������ڵ�
                      ,SUM(A.����ä������)  AS ����ä������
                      ,SUM(A.�̼���������)  AS �̼���������
                      ,SUM(A.�����ޱ�����)  AS �����ޱ�����
             FROM      DIM_IFRS���º�����   A
             WHERE     1=1
             AND       A.��������  = '20161231'
             AND       A.���հ��¹�ȣ  IN ( SELECT DISTINCT ���¹�ȣ FROM #������ )
             GROUP BY  A.���հ��¹�ȣ,A.���������ڵ�
            )     C
            ON     A.���¹�ȣ      = C.���հ��¹�ȣ
            AND    A.���������ڵ�  = C.���������ڵ�

//}

//{  #������  #��������  #������ #������ #�ֱ���

SELECT      A.RNNO
           ,A.SMPR_RNNO
           ,A.CMPL_DT
           ,A.CRDT_EVL_NO
INTO        #����������  -- DROP TABLE #����������
FROM        (
             SELECT   A.*
                     ,ROW_NUMBER() OVER(PARTITION BY A.SMPR_RNNO ORDER BY CMPL_DT DESC,CRDT_EVL_NO DESC) AS ����1
                     ,ROW_NUMBER() OVER(PARTITION BY A.RNNO ORDER BY CMPL_DT DESC,CRDT_EVL_NO DESC) AS ����2
                            -- �����ʷ����� �����ϸ� ����1�� ������ ������ ���¿���� �����Ҷ��� RNNOĮ���� ���µ�
                            -- �ߺ��Ǵ� ��찡 �־� �ϳ��� �����ϱ� ���Ͽ� ����2�� ���� ����� ����
             FROM     TB_SOR_CCR_EVL_INF_BC A /* CCR_�������⺻ */
             WHERE    1=1
             AND      CRDT_EVL_PGRS_STCD = '2'
             AND      NFFC_UNN_DSCD = '1'
             AND      CRDT_EVL_MODL_DSCD != '34'
             AND      BRNO <>'0288'
             --AND  RNNO ='2048634391'
            )  A
WHERE       1=1
AND         A.����1 = 1
AND         A.����2 = 1
;

SELECT      *
INTO        #����Ϻ��Ϸù�ȣ  -- DROP TABLE #����Ϻ��Ϸù�ȣ
FROM
            (
             SELECT A.RNNO
                   ,A.CRDT_EVL_NO
                   ,A.SOA_DT
                   ,A.HIS_SNO
                   ,ROW_NUMBER() OVER(PARTITION BY A.RNNO,A.CRDT_EVL_NO,A.SOA_DT ORDER BY A.HIS_SNO DESC) AS ����
             FROM   TB_SOR_CCR_EVL_FNFR_CTL_TR A  -- SOR_CCR_���繫��ϳ���
             JOIN   (
                      SELECT   RNNO
                              ,CRDT_EVL_NO
                              ,MAX(SOA_DT) AS MAX_SOA_DT
                      FROM     TB_SOR_CCR_EVL_FNFR_CTL_TR -- SOR_CCR_���繫��ϳ���
                      WHERE    LEFT(SOA_DT,4) IN ('2014','2015','2016','2017')
                      GROUP BY RNNO, CRDT_EVL_NO,LEFT(SOA_DT,4)
                    )   B
                    ON      A.RNNO         =  B.RNNO
                    AND     A.CRDT_EVL_NO  =  B.CRDT_EVL_NO
                    AND     A.SOA_DT       =  B.MAX_SOA_DT
            )  A
WHERE  ����  = 1
;

-- �������� FSC_SNCD ='K' �ΰ�쿡�� �ش����̺� ���� FSC_SNCD ='I' �� ���� IFRS���̺��� �����ϳ�
-- ���� DW�� ���̺��� ���°��� �־ �Ұ�����
SELECT      A.RNNO
           ,A.SMPR_RNNO
           ,A.CMPL_DT
           ,A.CRDT_EVL_NO
           ,A1.SOA_DT
           ,MAX(CASE WHEN B.FNST_REPT_CD =  '11' AND B.FNST_HDCD = '5000'  THEN FNST_AMT  ELSE NULL END) AS ���ڻ�
           ,MAX(CASE WHEN B.FNST_REPT_CD =  '12' AND B.FNST_HDCD = '1000'  THEN FNST_AMT  ELSE NULL END) AS �����
           ,MAX(CASE WHEN B.FNST_REPT_CD =  '12' AND B.FNST_HDCD = '5000'  THEN FNST_AMT  ELSE NULL END) AS ��������
           ,MAX(CASE WHEN B.FNST_REPT_CD =  '12' AND B.FNST_HDCD = '9000'  THEN FNST_AMT  ELSE NULL END) AS ��������

FROM        #����������   A

JOIN        #����Ϻ��Ϸù�ȣ  A1
            ON  A.RNNO           = A1.RNNO
            AND A.CRDT_EVL_NO    = A1.CRDT_EVL_NO

LEFT OUTER JOIN
            TB_SOR_CCR_FNST_HT  B  --  SOR_CCR_�繫��ǥ�̷�
            ON      A.RNNO          = B.RNNO
            AND     A1.SOA_DT       = B.SOA_DT
            AND     A1.HIS_SNO      = B.HIS_SNO
            AND     B.FNST_SOA_DSCD = 'K'
            AND     (
                      B.FNST_REPT_CD =  '11' AND B.FNST_HDCD = '5000'   OR
                      B.FNST_REPT_CD =  '12' AND B.FNST_HDCD = '1000'   OR
                      B.FNST_REPT_CD =  '12' AND B.FNST_HDCD = '5000'   OR
                      B.FNST_REPT_CD =  '12' AND B.FNST_HDCD = '9000'
                    )
WHERE       1=1
GROUP BY    A.RNNO
           ,A.SMPR_RNNO
           ,A.CMPL_DT
           ,A.CRDT_EVL_NO
           ,A1.SOA_DT
;

SELECT      A.RNNO
           ,A.SMPR_RNNO
           ,A.CMPL_DT
           ,A.CRDT_EVL_NO
           ,A1.SOA_DT
           ,MAX(CASE WHEN B.FNST_REPT_CD =  '19' AND B.FNST_HDCD = '4060'  THEN CALC_FNST_RT  ELSE NULL END) AS ��ä����

FROM        #����������   A

JOIN        #����Ϻ��Ϸù�ȣ  A1
            ON  A.RNNO           = A1.RNNO
            AND A.CRDT_EVL_NO    = A1.CRDT_EVL_NO
LEFT OUTER JOIN
            TB_SOR_CCR_FNFR_RT_HT  B -- SOR_CCR_�繫�����̷�
            ON      A.RNNO          = B.RNNO
            AND     A1.SOA_DT       = B.SOA_DT
            AND     A1.HIS_SNO      = B.HIS_SNO
            AND     B.FNST_SOA_DSCD = 'K'
            AND     (
                      B.FNST_REPT_CD =  '19' AND B.FNST_HDCD = '4060'
                    )
WHERE       1=1
GROUP BY    A.RNNO
           ,A.SMPR_RNNO
           ,A.CMPL_DT
           ,A.CRDT_EVL_NO
           ,A1.SOA_DT
;
//}

//{ #��������Ʈ
-- ������ ��� ��������Ʈ
SELECT CUST_NO      AS ����ȣ
      ,PNT_TPCD     AS ����Ʈ�����ڵ�
      ,TOT_CMTT_PNT AS �ѹ߻�����Ʈ
      ,TOT_US_PNT   AS �ѻ������Ʈ
      ,TOT_EXT_PNT  AS �ѼҸ�����Ʈ
      ,TOT_RMN_PNT  AS ���ܿ�����Ʈ
FROM   TB_SOR_PNT_PNT_TZ
WHERE  CUST_NO = 101093721
  AND  PNT_TPCD = 'SW0001'
//}

//{  #�������� #TEMPORARY
--6
SET TEMPORARY OPTION Temp_Extract_Name1 = '/nasdat/edw/out/etc/DWZOWN_TB_SOR_CCR_FNFR_RT_TR.dat';
SET TEMPORARY OPTION Temp_Extract_Column_Delimiter = '|';
SET TEMPORARY OPTION Temp_Extract_NULL_As_Zero = 'ON';
SET TEMPORARY OPTION Temp_Extract_NULL_As_Empty = 'ON';
SELECT
			 RNNO	�Ǹ��ȣ
			,FNST_SOA_DSCD	�繫��ǥ��걸���ڵ�
			,SOA_DT	�������
			,FNST_REPT_CD	�繫��ǥ�����ڵ�
			,FNST_HDCD	�繫��ǥ�׸��ڵ�
			,CALC_FNST_RT	�����繫��ǥ����
			,ACTL_FNST_RT	�����繫��ǥ����
FROM   TB_SOR_CCR_FNFR_RT_TR    -- SOR_CCR_�繫��������
WHERE  LEFT(SOA_DT,4) IN  ('2010','2011','2012','2013','2014')
;
SET TEMPORARY OPTION Temp_Extract_Name1 = '';


//}

//{  #B2401  #�����ڱݹ��� 

SELECT      '����'        AS ���α������
           ,A.���հ��¹�ȣ   AS ���¹�ȣ
           ,SUM(A.���޺���������бݾ�  + A.�����ܾ׹�бݾ�)  AS �ݾ�
INTO        #TEMP_�ſ�ī��  -- DROP TABLE #TEMP_�ſ�ī��
FROM        TB_DWF_LAQ_���������¿�����  A
WHERE       A.��������       = V_���б⸻����
AND         A.�������ڵ�      = '1'
AND         A.BS���������ڵ�  IN (SELECT   ACSB_CD
                              FROM     OT_DWA_DD_ACSB_TR
                              WHERE    STD_DT = V_���б⸻����
                              AND      FSC_SNCD IN ('K','C')
                              AND      ACSB_CD4 = '13001701')
AND         A.��ǥ�����ڵ� <> '6'
GROUP BY    A.���հ��¹�ȣ

UNION ALL

SELECT      CASE WHEN B.PREN_DSCD = '1'     THEN '����'
                 ELSE '���'
               END   AS ���α������
           ,A.���հ��¹�ȣ
           ,SUM(A.���޺���������бݾ�  + A.�����ܾ׹�бݾ�) AS �ݾ�
FROM        TB_DWF_LAQ_���������¿�����  A
           ,TB_SOR_CLT_CRD_BC  B --  SOR_CLT_ī��⺻
WHERE       A.��������       = V_���б⸻����
AND         A.�������ڵ�      = '1'
AND         A.BS���������ڵ�  IN (SELECT   ACSB_CD
                              FROM     OT_DWA_DD_ACSB_TR
                              WHERE    STD_DT = V_���б⸻����
                              AND      FSC_SNCD IN ('K','C')
                              AND      ACSB_CD4 = '13001701')
AND         A.��ǥ�����ڵ� = '6'
AND         A.���հ��¹�ȣ *= B.CRD_NO
--AND         B.PREN_DSCD = '1'
GROUP BY    ���α������
           ,A.���հ��¹�ȣ
;

    
-- ���������̺�� ���տ����� �̿��Ͽ� ������ ���̺��� ����
-- �� �ӽ����̺��� ���¹�ȣ,�����ڵ�,�������з��ڵ� �� ��Ű��Ȱ
SELECT      A.��������                AS  STD_DT
           ,A.����ȣ                AS  CUST_NO   --���ż��������� ��� �����Ǹ��� �־��ش�
           ,C.CUST_RNNO               AS  RNNO
           ,C.CUST_NM                 AS  CUST_NM
           ,A.��ǥ�����ڵ�            AS  FRPP_KDCD
           ,A.���հ��¹�ȣ            AS  INTG_ACNO
           ,A.����ȣ                  AS  BRNO
           ,ISNULL(A.�����ѵ����ⱸ���ڵ�, '2')    AS INDV_LMT_LN_DSCD   --��뱸��          --1:�Ǻ��ŷ�����, 2:�ѵ��ŷ�����
           //-----------------------------------------------------------------
           ,MAX(A.��������)           AS  AGR_DT
           //-----------------------------------------------------------------
           ,MAX(ROUND(ISNULL(A.���αݾ�,0) * 0.000001,0))  AS AGR_AMT      --�����ݾ�
           ,MAX(ROUND(ISNULL(A.���αݾ�,0) * 0.000001,0))  AS APRV_AMT     --�����ݾ�
           ,SUM(ROUND(( A.���޺���������бݾ� + A.�����ܾ׹�бݾ�) * 0.000001,0))   AS LN_RMD       --�����ܾ�
           ,SUM(A.���޺���������бݾ�  + A.�����ܾ׹�бݾ�)                         AS LN_RMD_WON   --�����ܾ�_�������ܾ�
           ,SUM(ROUND((A.���޺������� + A.����ä������) * 0.000001,0))            AS APMN_NDS_RSVG_AMT   --���ݿ䱸�����ݾ�
           ,A.���°���������ڵ�       AS  ACN_SDNS_GDCD                                    --���°���������ڵ�
           //--------------------------------------------------
           ,A.������������ڵ�       AS  CUST_SDNS_GDCD
           //--------------------------------------------------
           ,A.����ſ��򰡵��         AS  ENTP_CREV_GD
           ,A.BS���������ڵ�           AS  BS_ACSB_CD
           ,A.��ȯ���������ڵ�         AS  FRXC_TSK_DSCD
           ,CASE WHEN A.��ǥ�����ڵ�  = '7'  AND  A.��ȯ���������ڵ�  IN ('12',             --��ȭ��ǥ
                                                                   '21','22','23',   --����
                                                                   '11',             --����
                                                                   '41','42')  THEN  'Y'
                 ELSE 'N'
            END                  AS ��ȯ����

INTO        #TEMP0    -- DROP TABLE #TEMP0

FROM        TB_DWF_LAQ_���������¿����� A
           ,OM_DWA_INTG_CUST_BC       C
WHERE       A.��������       = V_���б⸻����
AND         A.�������ڵ�     = '1'

AND         ( A.��ǥ�����ڵ�  IN ('1','2','4')  OR
              (A.��ǥ�����ڵ�  = '7'  AND  A.���ž��������ڵ�  IN ('14','42') ) OR  -- ��ȭ����, ��������
              (A.��ǥ�����ڵ�  = '8' AND A.BS���������ڵ�  IN ('15011411','15011811','15011811','15013411','13000511')) OR
                                       -- ���� �ҽ��� ���� �������� �־�� �����δ� ������ �������� ����
                                       -- 15011811(��Ÿ�����ޱ�),15011411(�������������ޱ�),13000511(��ȭ������ȯä��),15013411(��Ÿ�̼���)
                                       -- 201712������ �����������Ϳ��� 15011811(��Ÿ�����ޱ�),15013411(��Ÿ�̼���),13000511(��ȭ������ȯä��) ���������� ����������
                                       -- ���ĵ�����(IFRS������)������ �ش� ������ ����

              (A.��ǥ�����ڵ�  = '7'  AND  A.��ȯ���������ڵ�  IN ('12',             --��ȭ��ǥ
                                                                   '21','22','23',   --����
                                                                   '11',             --����
                                                                   '41','42'))  OR    --��������
              //----------------------------------------------------------------------------------------------------
              -- ,3,4,5,A �����ܿ��� ī�� ���ԾȵǾ� ����
              (A.���հ��¹�ȣ  IN (SELECT  ���¹�ȣ FROM  #TEMP_�ſ�ī�� WHERE ���α������ = '���' ))
              --(A.���հ��¹�ȣ  IN (SELECT  ���¹�ȣ FROM  #TEMP_�ſ�ī��))  -- bs�� ����Ҷ�
              //----------------------------------------------------------------------------------------------------
            )
AND         A.BS���������ڵ�  NOT IN (SELECT  RLT_ACSB_CD                   -- �����ڱݴ����� ����
                                      FROM    DWZOWN.OT_DWA_DD_ACSB_BC
                                      WHERE   STD_DT        = V_���б⸻����
                                      AND     ACSB_CD       = '14002501'
                                      AND     ACSB_HRC_INF <> RLT_ACSB_HRC_INF
                                      AND     ACCT_STCD     = '1'
                                      AND     RLT_ACCT_STCD = '1')
AND         A.BS���������ڵ�  NOT IN ('14000611','96003611','10690011','15009011','15009111','0')
AND         RIGHT(TRIM(A.BS���������ڵ�), 1) <> '6'
AND         A.���հ��¹�ȣ  NOT IN (SELECT   INTG_ACNO
                                    FROM     OT_DWA_INTG_CLN_BC
                                    WHERE    STD_DT = V_���б⸻����
                                    AND      RIGHT(BS_ACSB_CD, 1) = '9'
                                    AND      BR_DSCD = '1'
                                    AND      FRPP_KDCD  IN ('1','2','4')
                                    AND      LN_USCD  IN ('31','32'))
AND         A.BS���������ڵ�  NOT IN (SELECT  RLT_ACSB_CD
                                      FROM    DWZOWN.OT_DWA_DD_ACSB_BC
                                      WHERE   STD_DT        = V_���б⸻����
                                      AND     LEFT(RLT_ACSB_CD, 1) = '9'
                                      AND     RLT_ACSB_CD  NOT IN (SELECT  RLT_ACSB_CD
                                                                   FROM    DWZOWN.OT_DWA_DD_ACSB_BC
                                                                   WHERE   STD_DT  = V_���б⸻����
                                                                   AND     ACSB_CD = '93000101'
                                                                   AND     ACCT_STCD     = '1'
                                                                   )
                                      AND     ACSB_HRC_INF  <> RLT_ACSB_HRC_INF
                                      AND     ACCT_STCD     = '1'
                                      AND     RLT_ACCT_STCD = '1')
AND         A.����ȣ     =  C.CUST_NO
GROUP BY    A.��������
           ,A.����ȣ
           ,C.CUST_RNNO
           ,C.CUST_NM
           ,A.��ǥ�����ڵ�
           ,A.���հ��¹�ȣ
           ,A.����ȣ
           ,INDV_LMT_LN_DSCD
           ,A.���°���������ڵ�
           ,A.������������ڵ�
           ,A.����ſ��򰡵��
           ,A.BS���������ڵ�
           ,A.��ȯ���������ڵ�
           ,��ȯ����

UNION ALL

SELECT      AA.STD_DT                                        AS STD_DT
           ,CASE WHEN AA.CUST_NO = 0  THEN C.CUST_NO ELSE AA.CUST_NO END  AS CUST_NO
           ,CASE WHEN AA.RNNO IS NULL THEN C.BRN     ELSE AA.RNNO    END  AS RNNO
           ,CASE WHEN AA.CUST_NO = 0  THEN '���ż������ޱ�' ELSE AA.CUST_NM END  AS  CUST_NM
           ,AA.FRPP_KDCD                                     AS FRPP_KDCD
           ,AA.INTG_ACNO                                     AS INTG_ACNO
           ,AA.BRNO                                          AS BRNO
           ,ISNULL(AA.INDV_LMT_LN_DSCD, '2')                 AS INDV_LMT_LN_DSCD   --��뱸��          --1:�Ǻ��ŷ�����, 2:�ѵ��ŷ�����
           //-----------------------------------------------------------------
           ,MAX(A.��������)                                  AS AGR_DT
           //-----------------------------------------------------------------
           ,0                                                AS AGR_AMT     --�����ݾ�
           ,0                                                AS APRV_AMT    --�����ݾ�
           ,SUM(ROUND(A.�����ޱݹ�бݾ� * 0.000001,0))      AS LN_RMD
           ,SUM(A.�����ޱݹ�бݾ�)                          AS LN_RMD_WON
           ,SUM(ROUND(A.�����ޱ����� * 0.000001,0))        AS APMN_NDS_RSVG_AMT   --���ݿ䱸�����ݾ�
           ,A.���°���������ڵ�                             AS ACN_SDNS_GDCD
           //--------------------------------------------------
           ,A.������������ڵ�                             AS  CUST_SDNS_GDCD
           //--------------------------------------------------
           ,AA.ENTP_CREV_GD                                  AS ENTP_CREV_GD
           ,AA.BS_ACSB_CD                                    AS BS_ACSB_CD
           ,AA.FRXC_TSK_DSCD                                 AS FRXC_TSK_DSCD
           ,'N'                                              AS ��ȯ����

FROM        TB_DWF_LAQ_���������¿�����   A
JOIN        (
             SELECT      A.STD_DT                 AS  STD_DT
                        ,A.CUST_NO                AS  CUST_NO
                        ,C.CUST_RNNO              AS  RNNO
                        ,C.CUST_NM                AS  CUST_NM
                        ,A.INTG_ACNO              AS  INTG_ACNO
                        ,A.INDV_LMT_LN_DSCD       AS  INDV_LMT_LN_DSCD
                        ,A.FRXC_TSK_DSCD          AS  FRXC_TSK_DSCD
                        ,A.ENTP_CREV_GD           AS  ENTP_CREV_GD
--                        ,MAX(ROUND(A.AGR_AMT * B.DLN_STD_EXRT * 0.000001,0))       AS AGR_AMT     --���αݾ�
                        ,SUM(ROUND(A.LN_EXE_AMT * B.DLN_STD_EXRT * 0.000001,0))    AS AGR_AMT     --���αݾ�
                        -- �����ݾ��� �ܾ׺��� �����͵� �ְ� �̻��ؼ� �������ݾ����� �����ݾ��� ����Ѵ�.
                        ,SUM(ROUND(A.LN_EXE_AMT * B.DLN_STD_EXRT * 0.000001,0))    AS LN_EXE_AMT   --�������ݾ�
                        ,SUM(ROUND(A.LN_RMD * 0.000001,0))       AS LN_RMD       --�����ܾ�
                        ,SUM(A.LN_RMD)                           AS LN_RMD_WON   --�����ܾ�_�������ܾ�
                        ,A.FRPP_KDCD           AS  FRPP_KDCD
                        ,A.BRNO                AS  BRNO
                        ,A.BS_ACSB_CD          AS  BS_ACSB_CD

             FROM        OT_DWA_INTG_CLN_BC        A
                        ,OT_DWA_EXRT_BC            B
                        ,OM_DWA_INTG_CUST_BC       C
             WHERE       A.STD_DT          = V_���б⸻����
             AND         A.BR_DSCD         = '1'
             AND         A.CLN_ACN_STCD    = '1'    -- �����ڵ� ����
             AND         A.BS_ACSB_CD     IN ('15011011','15011211')  -- 15011211 ���ż������ޱ�, 15011011 �ſ�ī�尡���ޱ�
             AND         A.CRCD             = B.CRCD
             AND         B.STD_DT           = V_���б⸻����
             AND         B.EXRT_TO          = 1
             AND         A.CUST_NO         *=  C.CUST_NO
             GROUP BY    A.STD_DT
                        ,A.CUST_NO
                        ,C.CUST_RNNO
                        ,C.CUST_NM
                        ,A.INTG_ACNO
                        ,A.INDV_LMT_LN_DSCD
                        ,A.FRXC_TSK_DSCD
                        ,A.ENTP_CREV_GD
                        ,A.FRPP_KDCD
                        ,A.BRNO
                        ,A.BS_ACSB_CD
            )           AA
            ON   CASE WHEN A.BS���������ڵ� IN ('15011011','15011211') THEN A.���հ��¹�ȣ ELSE A.���Ῡ�ű���������¹�ȣ END  =   AA.INTG_ACNO

LEFT OUTER JOIN
            OM_DWA_INTG_CUST_BC       B
            ON   AA.CUST_NO         = B.CUST_NO

LEFT OUTER JOIN
            (SELECT   A.BRNO
                     ,A.BR_NM
                     ,A.BRN
                     ,B.CUST_NO
                     ,B.CUST_NM
             FROM     OT_DWA_DD_BR_BC   A  --DWA_�����⺻
                     ,TB_SOR_CUS_MAS_BC B  --SOR_CUS_���⺻
             WHERE    A.STD_DT = V_���б⸻����
             AND      A.BRNO <> 'XXXX'
             AND      A.BRN  *= B.CUST_RNNO
            ) C
            ON   AA.BRNO            = C.BRNO

WHERE       A.��������       = V_���б⸻����
AND         A.�������ڵ�     = '1'
//------------------------------------------ �����ݱ�
AND         A.�����ޱݹ�бݾ� > 0
//----------------------------------------------------
GROUP BY    AA.STD_DT
           ,CUST_NO
           ,RNNO
           ,CUST_NM
           ,AA.FRPP_KDCD
           ,AA.INTG_ACNO
           ,AA.BRNO
           ,ISNULL(AA.INDV_LMT_LN_DSCD, '2')
           ,A.���°���������ڵ�
           ,A.������������ڵ�
           ,AA.ENTP_CREV_GD
           ,AA.BS_ACSB_CD
           ,AA.FRXC_TSK_DSCD

//-------��Ÿ�����ޱ�(15011811), ��Ÿ�̼���(15013411)
UNION ALL           

SELECT      A.STD_DT                 AS  STD_DT
           ,A.CUST_NO                AS  CUST_NO
           ,C.CUST_RNNO              AS  RNNO
           ,C.CUST_NM                AS  CUST_NM
           ,A.FRPP_KDCD              AS  FRPP_KDCD
           ,A.INTG_ACNO              AS  INTG_ACNO
           ,A.BRNO                   AS  BRNO                        
           ,A.INDV_LMT_LN_DSCD       AS  INDV_LMT_LN_DSCD
           ,A.AGR_DT                 AS  AGR_DT
           ,0                        AS  AGR_AMT     --���αݾ�
           ,0                        AS  APRV_AMT     --���αݾ�
           ,SUM(ROUND(A.LN_RMD * 0.000001,0))       AS LN_RMD       --�����ܾ�
           ,SUM(A.LN_RMD)                           AS LN_RMD_WON   --�����ܾ�_�������ܾ�
           ,0                        AS APMN_NDS_RSVG_AMT   --���ݿ䱸�����ݾ�
           ,'1'                      AS ACN_SDNS_GDCD   --���ݿ䱸�����ݾ�                        
           ,'1'                      AS CUST_SDNS_GDCD
           ,'0'                      AS ENTP_CREV_GD
           ,A.BS_ACSB_CD             AS BS_ACSB_CD
           ,A.FRXC_TSK_DSCD          AS  FRXC_TSK_DSCD
           ,'N'                      AS  ��ȯ����

FROM        OT_DWA_INTG_CLN_BC        A
           ,OT_DWA_EXRT_BC            B
           ,OM_DWA_INTG_CUST_BC       C
WHERE       A.STD_DT          = V_���б⸻����
AND         A.BR_DSCD         = '1'
AND         A.CLN_ACN_STCD    = '1'    -- �����ڵ� ����
AND         A.BS_ACSB_CD     IN ('15011811','15013411')  -- ��Ÿ�����ޱ�(15011811), ��Ÿ�̼���(15013411)
AND         A.CRCD             = B.CRCD
AND         B.STD_DT           = V_���б⸻����
AND         B.EXRT_TO          = 1
AND         A.CUST_NO         *=  C.CUST_NO
GROUP BY    A.STD_DT
           ,A.CUST_NO
           ,C.CUST_RNNO
           ,C.CUST_NM
           ,A.FRPP_KDCD
           ,A.INTG_ACNO
           ,A.BRNO
           ,A.INDV_LMT_LN_DSCD
           ,A.AGR_DT
           ,A.BS_ACSB_CD
           ,A.FRXC_TSK_DSCD
;



SELECT      CASE  WHEN ACSB_CD5 IN ('14002401')  THEN  '1. F1'     -- ����ڱݴ����
                  WHEN ACSB_CD4 IN ('13001108','13001308','13001408')  THEN  '1. F1'  -- ��ȭ�����
                  WHEN ACSB_CD4 IN ('13001601')  THEN  '1. F1'  -- ���޺��������ޱ�
                  WHEN ACSB_CD4 IN ('13001508','13001001') THEN '1. F1'  -- ���Կ�ȯ
                  WHEN ACSB_CD4 IN ('13001901') THEN  '1. F1'  -- ����ä
                  WHEN ACSB_CD2 IN ('93000101') THEN  '1. F1'  -- Ȯ�����޺���
                  WHEN ACSB_CD4 IN ('13001701') THEN  '1. F1'  -- �ſ�ī��ä��(���)
                  WHEN ACSB_CD5 IN ('14002601')  THEN  '2. F3'  -- �����ױ�Ÿ�ڱݴ����
                  WHEN ACSB_CD6 IN ('15011011','15011211')  THEN  '2. F3'  -- ��Ÿä��
                  WHEN ACSB_CD  IN ('15011811','15013411')  THEN  '3. G'  -- ��Ÿ���ż�ä��
                  WHEN ACSB_CD  IN ('15011811','15013411')  THEN  '3. G'  -- ��Ÿ���ż�ä��
            END   AS  ��������      
           ,CASE  WHEN ACSB_CD5 IN ('14002401')  THEN  '1.����ڱݴ����'
                  WHEN ACSB_CD5 IN ('14002601')  THEN  '2.�����ױ�Ÿ�ڱݴ����'
                  WHEN ACSB_CD4 IN ('13001108','13001308','13001408')  THEN '3.��ȭ�����(�����������꽺,���ܿ�ȭ���������)'
                  WHEN ACSB_CD4 IN ('13001601') THEN '4.���޺��������ޱ�'
                  WHEN ACSB_CD4 IN ('13001508','13001001') THEN '5.���Կ�ȯ(���Ծ�����������)'
                  WHEN ACSB_CD4 IN ('13001701') THEN '6.�ſ�ī��ä��(���)'
                  WHEN ACSB_CD4 IN ('13001901') THEN '7.����ä'
                  WHEN ACSB_CD2 IN ('93000101') THEN '8.Ȯ�����޺���'
                  WHEN ACSB_CD4 IN ('13001701') THEN  '1. F1'  -- �ſ�ī��ä��(���)
                  WHEN ACSB_CD6 IN ('15011011','15011211')   THEN '8.��Ÿä��'
                  WHEN ACSB_CD  IN ('15011811','15013411')   THEN '9.��Ÿ���ż�ä��(�̼��װ����ޱ�)'
            END   AS  ��������
           ,SUM(LN_RMD_WON)  AS �����ܾ�
FROM        #TEMP0   A
JOIN        (
                   SELECT   STD_DT
                           ,ACSB_CD
                           ,ACSB_NM
                           ,ACSB_CD2
                           ,ACSB_NM2
                           ,ACSB_CD4  --��ȭ�����
                           ,ACSB_NM4
                           ,ACSB_CD5  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                           ,ACSB_NM5
                           ,ACSB_CD6  --����ڱݴ����, �����ڱݴ����, �����ױ�Ÿ
                           ,ACSB_NM6
                   FROM     OT_DWA_DD_ACSB_TR
                   WHERE    FSC_SNCD IN ('K','C')
                   AND      (
                              ACSB_CD5 IN ('14002401') OR    --����ڱݴ����
                              ACSB_CD5 IN ('14002601') OR    --�����ױ�Ÿ�����
                              ACSB_CD4 IN ('13001108','13001308','13001408') OR    --��ȭ�����,�����������꽺,���ܿ�ȭ�����
                              ACSB_CD4 IN ('13001601') OR    --���޺��������ޱ�
                              ACSB_CD4 IN ('13001701') OR    --�ſ�ī��ä��
                              ACSB_CD4 IN ('13001508','13001001') OR    --���Կ�ȯ,���Ծ�������
                              ACSB_CD4 IN ('13001901') OR    --����ä
                              ACSB_CD2 IN ('93000101') OR   --Ȯ�����޺���
                              ACSB_CD6 IN ('15011011','15011211') OR     --�ſ�ī�尡���ޱ�(15011011),���ż������ޱ�(15011211)
                              ACSB_CD  IN ('15011811','15013411')      --��Ÿ�̼���(15013411), ��Ÿ�����ޱ�(15011811)
                            )
                   AND      STD_DT = '20180331'
            )           C
            ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS���������ڵ�
GROUP BY    ��������,��������

UNION ALL

SELECT      '3. G'  AS ��������
            ,'9.��Ÿ���ż�ä��(�ݷе�)'  AS ��������
           ,SUM(A.TD_RMD)   AS �����ܾ�
FROM        OT_DWA_DD_GLM_FLST_BC  A      --DWA_���Ѱ����⺻
           ,OT_DWA_DD_BR_BC        B      --DWA_�����⺻
WHERE       A.FSC_DT   = '20180331'
AND         A.ACSB_CD  IN ( '13000901'      --�ݷ�
                           ,'14003801'      --RP
                           ,'14000711')     --���ణ�뿩��
AND         A.FSC_DSCD = '1'              --ȸ�豸���ڵ�(1:�ſ�)
AND         A.JONT_CD  = '11'             --�յ��ڵ�(11:�ſ���)
AND         A.FSC_SNCD IN ('K','C')       --ȸ������ڵ�(K:GAAP, C:����)
AND         A.BRNO     = B.BRNO
AND         A.FSC_DT   = B.STD_DT
AND         B.STD_DT   = '20180331'
AND         B.BR_DSCD  = '1'               --�߾�ȸ
AND         B.FSC_DSCD = '1'              --�ſ�
AND         B.BR_KDCD  < '40'              --10:���κμ�, 20:������, 30:������

UNION ALL
SELECT     '4. I'    AS  ��������
           ,'B. ��Ÿ�������з��ڻ�'  AS ��������
           ,8795859000000 + 57889000000 + 2698000000 + 2768000000 + 000000  AS �����ܾ�

ORDER BY 1,2
;
//}


//{  #���λ���� #NICE  #CB���
-- 29189818 ��¥���� ������ ���̺� �볻��...
CREATE TABLE #TEMP_CB��� -- DROP TABLE #TEMP_CB���
(
  ���Ž�û��ǥ��ȣ   CHAR(14),
  NICE_CB���        CHAR(4)
);

LOAD TABLE #TEMP_CB���
(
���Ž�û��ǥ��ȣ    ',',
NICE_CB���         '\x0a'      
)
FROM '/nasdat/edw/temp/���ѳ�/��ũ�ƿ����.csv'
     
QUOTES OFF
ESCAPES OFF
--BLOCK FACTOR 3000
FORMAT ASCII;
commit;

//}


//{  #EXECUTE  #UPDATE

-- �ܾ� UPDATE(�������ݿ�)
BEGIN
EXECUTE IMMEDIATE
'
UPDATE      #����ڱ�   A
SET         A.�ܾ� =  A.�ܾ� - ISNULL(O.�������ݾ�, 0)
FROM        (
              SELECT   A.��������
                      ,A.���հ��¹�ȣ
                      ,SUM(A.���簡ġ��������)    AS �������ݾ�
              FROM     DWZOWN.TB_DWF_LAQ_���������¿����� A 
              WHERE    A.��������  = ''20180630''
              AND      A.���հ��¹�ȣ  IN ( SELECT ���հ��¹�ȣ FROM  #����ڱ� )
              GROUP BY A.��������,A.���հ��¹�ȣ
            ) O
WHERE       A.���հ��¹�ȣ   =   O.���հ��¹�ȣ
AND         A.��������       =   O.��������
;
'
;
END;

//}

