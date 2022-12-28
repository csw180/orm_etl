/*
  ���α׷��� : ins_TB_OPE_KRI_�ݵ�����07
  Ÿ�����̺� : TB_OPE_KRI_�ݵ�����07
  KRI ��ǥ�� : �ݵ���ͷ��뺸 �̵�� ���� �Ǽ�
  ��      �� : �������븮
  �����ۼ��� : �ֻ��
  KRI ��ǥ�� :
     - �ݵ�����-07 : �ݵ���ͷ��뺸 �̵�� ���� �Ǽ�
       A: ������ ������ �ű԰��� �� �ݵ���ͷ��뺸����, ��ǥ���ͷ�, ������ͷ�,
          �������ڼ��ͷ� �˸����� ���� ������� ���� ���°Ǽ�
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

    DELETE OPEOWN.TB_OPE_KRI_�ݵ�����07
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_�ݵ�����07
		SELECT   P_BASEDAY
		        ,T1.ADM_BRNO
		        ,J1.BR_NM
		        ,T1.NW_DT
		        ,T1.ACNO
		        ,PD2.PRD_KR_NM
		        ,T1.CUST_NO
		--        ,ROUND(T1.BLN_ACNT * T2.STD_PRC / 1000, 0)  -- �򰡱ݾ�
		--        ,GL_ERN_RT
		--        ,RSK_ERN_RT
		--        ,FUND_BLN_DPC_DSCD
		
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
		
		JOIN     TB_SOR_PDF_FND_BC     PD1  -- SOR_PDF_�ݵ�⺻
		         ON   T1.PDCD  =  PD1.PDCD
		         AND  PD1.ELF_FUND_YN  =  'N'
		         AND  PD1.INVM_TGT_DSCD  NOT IN ('01')
		         AND  PD1.APL_STCD  = '10'  -- ��������ڵ�: Ȱ��(10)
		
		LEFT OUTER JOIN
		         TB_SOR_PDF_PRD_BC    PD2   -- SOR_PDF_��ǰ�⺻
		         ON   T1.PDCD  =  PD2.PDCD
		         AND  PD2.APL_STCD  = '10'  -- ��������ڵ�: Ȱ��(10)
		         AND  PD2.PRD_DSCD  = '01'  -- ��ǰ�����ڵ� : �ݵ�⺻(01)
		
		JOIN     TB_SOR_BCM_STD_PRC_TR   T2  -- SOR_BCM_�ݵ���ذ��ݳ���
		         ON   T1.PDCD  =  T2.PDCD
		         AND  T2.STD_DT = ( SELECT MAX(STD_DT) FROM TB_SOR_BCM_STD_PRC_TR WHERE STD_DT <= P_BASEDAY )
		                -- STD_DT�� ��糯¥�� ���� �ʾƼ� �ֱ��Ϸ� �ݿ���
		
		WHERE    1=1
		AND      T1.DPS_ACN_STCD  NOT IN ('98','99') -- �ű�����, �ű���� ����
		AND      T1.NW_DT  BETWEEN P_SOTM_DT  AND   P_EOTM_DT
		AND      T1.RTPN_DSCD  =  '00'
		AND      T1.FUND_BLN_DPC_DSCD = '0'  -- 0:������ ����, 4:�̸���, 5:����
		AND      T1.GL_ERN_RT =  0
		AND      T1.RSK_ERN_RT = 0
		AND      T1.SVN_TPCD  NOT IN ('12')
		AND      ROUND(T1.BLN_ACNT * T2.STD_PRC / 1000, 0) > 100000
		;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_�ݵ�����07',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT





