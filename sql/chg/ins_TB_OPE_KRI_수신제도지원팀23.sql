/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀23
  타켓테이블 : TB_OPE_KRI_수신제도지원팀23
  KRI 지표명 : 고객정보 변경 후 당일 고액출금 건수
  협      조 : 임현선과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-23 고객정보 변경 후 당일 고액출금 건수
       A: 전월 전액 3백만원이상 출금 건 중 당일 휴대전화번호 변경이 있었던 건수
       B: 전월 전액 3백만원이상 출금 건 중 당일 전화 및 문자 수신거부등록이 있었던 건수
*/
DECLARE
  P_BASEDAY  VARCHAR2(8);  -- 기준일자
  P_SOTM_DT  VARCHAR2(8);  -- 당월초일
  P_EOTM_DT  VARCHAR2(8);  -- 당월말일
  P_LD_CN    NUMBER;  -- 로딩건수

BEGIN
  SELECT  STD_DT,EOTM_DT,SUBSTR(EOTM_DT,1,6) || '01'
  INTO    P_BASEDAY
         ,P_EOTM_DT
         ,P_SOTM_DT
  FROM    OPEOWN.TB_OPE_DT_BC
  WHERE   STD_DT_YN  = 'Y';

  IF P_EOTM_DT = P_BASEDAY  THEN

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀23
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀23
    SELECT   /*+ FULL(B) FULL(C) FULL(PD)   */
             P_BASEDAY
            ,C.TR_BRNO
            ,D.BR_NM
            ,A.CHNL_TPCD
            ,A.CUST_NO
            ,B.ACNO
            ,PD.PRD_KR_NM
            ,C.CRCD
            ,C.TR_AMT
            ,C.TR_DT
            ,A.MBTL_NO_CHG_YN
            ,A.MBTL_NO_CHG_DTTM
            ,A.RCV_DEN_YN
            ,A.RCV_DEN_ENR_DTTM
            ,C.TR_USR_NO 
    FROM
             (
              SELECT   /*+ FULL(A)  */
                       A.CUST_NO
                      ,A.CHNL_TPCD
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0001' THEN 'Y' ELSE NULL END  MBTL_NO_CHG_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0001' THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS MBTL_NO_CHG_DTTM
                      ,CASE WHEN A.CUST_INF_CHG_DSCD IN ('0039','0040') THEN 'Y' ELSE NULL END  RCV_DEN_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD IN ('0039','0040') THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS RCV_DEN_ENR_DTTM
                      ,TO_CHAR(A.ENR_DTTM,'YYYYMMDD') AS ENR_DT
                      ,A.ENR_USR_NO
              FROM     TB_SOR_CUS_CHG_TR A    --SOR_CUS_고객변경내역
              WHERE    1=1
              AND      TO_CHAR(A.ENR_DTTM , 'YYYYMMDD')   BETWEEN  P_SOTM_DT AND   P_EOTM_DT
              AND      (
                         ( A.CHNL_TPCD LIKE 'E%' AND A.CUST_INF_CHG_DSCD = '0001' AND A.CHB_DAT_CTS != '   ' )  OR  -- 휴대폰번호변경
                         ( A.CUST_INF_CHG_DSCD = '0039' AND A.CHB_DAT_CTS NOT IN ('  ','00  ') )  OR  -- 전화수신거부유형코드
                         ( A.CUST_INF_CHG_DSCD = '0040' AND A.CHB_DAT_CTS  =  'Y' )                   -- SMS수신거부여부
                       )
             )  A

    JOIN     TB_SOR_DEP_DPAC_BC   B    -- SOR_DEP_수신계좌기본
             ON  A.CUST_NO   =  B.CUST_NO
             AND B.ACNO  LIKE  '1%'
             AND B.DPS_DP_DSCD  =  '1'

    JOIN     TB_SOR_DEP_TR_TR     C    -- SOR_DEP_거래내역
             ON  B.ACNO      =  C.ACNO
             AND A.ENR_DT    =  C.TR_DT
             AND C.DPS_TR_STCD  =  '1'  -- 수신거래상태코드(1:정상)
             AND C.RMDF_DSCD    =  '2'  -- 입금지급구분코드(1:입금, 2:지급, 3:예정신규)
             AND C.TR_AMT  >= 3000000

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD   -- SOR_PDF_상품기본
             ON     B.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    JOIN     TB_SOR_CMI_BR_BC D    -- SOR_CMI_점기본
             ON   C.TR_BRNO = D.BRNO
             AND  D.BR_DSCD  = '1'

    WHERE    1=1
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀23',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

