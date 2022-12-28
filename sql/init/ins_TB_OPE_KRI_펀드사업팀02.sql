/*
  ���α׷��� : ins_TB_OPE_KRI_�ݵ�����02
  Ÿ�����̺� : TB_OPE_KRI_�ݵ�����02
  KRI ��ǥ�� : �����ݼ���'���Űź�' ������ �ű԰��Աݾ�(�ݵ�)
  ��      �� : �������븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ݵ�����-02 : ������ ���� '���Űź�' ���� �� �ű԰��Աݾ�
       A: ������ ���񽺸� '���Űź�' ������ �ű� �ݵ� ���±ݾ�
     - �ݵ�����-03 : ������/�������� �űԵ� ��Ź ���� �� 
       A: ������ ���񽺸� '���Űź�' ������ ��Ź ���� ��
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

    DELETE OPEOWN.TB_OPE_KRI_�ݵ�����02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ݵ�����02
		SELECT   P_BASEDAY
		        ,T1.ADM_BRNO
		        ,J1.BR_NM
		        ,T1.NW_DT
		        ,T1.ACNO
		        ,T1.CUST_NO
		        ,CASE WHEN  T1.PDSL_MNTG_MTH_DSCD  = '8' THEN 'Y'
		              ELSE  'N'
		         END              -- ���Űźμ��ÿ���
		        ,T1.NW_DT
		        ,T2.TR_AMT
		        
		FROM     TB_SOR_BCM_BNAC_BC    T1     -- SOR_BCM_�������ǰ��±⺻
		JOIN     (
		          SELECT   ACNO
		                  ,SUM(TR_AMT)  TR_AMT
		          FROM     TB_SOR_BCM_TR_TR   -- SOR_BCM_�ŷ�����
		          WHERE    1=1
		          AND      TR_SNO =  '1'
		          AND      CNCL_YN =  'N'
		          GROUP BY ACNO
		         )   T2
		         ON    T1.ACNO  =  T2.ACNO
				 
		JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_���⺻
		         ON    T1.ADM_BRNO  =  J1.BRNO         
		         
		WHERE    1=1
		AND      T1.DPS_ACN_STCD  NOT IN ('98','99') -- �ű�����, �ű���� ����
		AND      T1.NW_DT  BETWEEN P_SOTM_DT  AND   P_EOTM_DT
		AND      T1.RTPN_DSCD  =  '00'
		AND      T1.PDSL_MNTG_MTH_DSCD  = '8'
      ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ݵ�����02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT



