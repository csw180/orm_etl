/*
  프로그램명 : ins_TB_OPE_KRI_소비자보호팀01
  타켓테이블 : TB_OPE_KRI_소비자보호팀01
  KRI 지표명 : 전기통신금융사기 사기이용계좌 전부지급 정지건수
  협      조 : 김정은
  최조작성자 : 최상원
  KRI 지표명 :
     - 전기통신금융사기 사기이용계좌 전부 지급정지 건수
       A: 전월중 전기통신금융사기 피해금 환급 관련 입지급 정지계좌(당,타행)수
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

    DELETE OPEOWN.TB_OPE_KRI_소비자보호팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_소비자보호팀01

    SELECT   /*+ FULL(A) FULL(B) FULL(J1) FULL(J2)  */
             P_BASEDAY
            ,A.ENR_BRNO  등록점번호
            ,J2.BR_NM    등록점명
            ,A.ACNO      계좌번호
            ,A.CUST_NO   고객번호
            ,A.TR_DT     거래일자
            ,A.BFTR_CMM_ACD_DCL_DSCD   전기통신사고신고구분코드
            --BFTR_CMM_ACD_DCL_DSCD 전기통신사고신고구분코드
            --01  피해자 신고,02  타은행요청,03 수사기관 요청,04  금융감독원 요청,05  금융회사 자체점검,06  일부지급정지 등록
            ,A.FNN_DCP_TPCD    금융사기유형코드
            --FNN_DCP_TPCD 금융사기유형코드
            --1 보이스피싱,2  파밍,3  일반대출사기,4  정책자금대출사기,5  마이너스통장대출사기
            ,A.ENR_USR_NO      등록사용자번호

    FROM     TB_SOR_CUS_FNN_DCP_TR   A  -- SOR_CUS_전기통신금융사기내역

    JOIN     TB_SOR_DEP_DPAC_BC    B   -- SOR_DEP_수신계좌기본
             ON  ( A.ACNO   = B.ACNO  OR   -- 신계좌번호
                   A.ACNO   = B.OD_ACNO OR  -- 구계좌번호
                   A.ACNO   = B.CSMD_ACNO   -- 맞춤계좌번호
                 )

    JOIN     TB_SOR_CMI_BR_BC     J1   -- SOR_CMI_점기본
             ON  B.ADM_BRNO = J1.BRNO
             AND J1.BR_DSCD = 1

    LEFT OUTER JOIN
             TB_SOR_CMI_BR_BC     J2   -- SOR_CMI_점기본
             ON  A.ENR_BRNO = J2.BRNO

    WHERE    1=1
    AND      A.TR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT

    ;
    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_소비자보호팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

