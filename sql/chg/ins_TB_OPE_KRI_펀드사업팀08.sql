/*
  프로그램명 : ins_TB_OPE_KRI_펀드사업팀08
  타켓테이블 : TB_OPE_KRI_펀드사업팀08
  KRI 지표명 : 펀드 별단예금 미지급 잔액 보유 건수
  협      조 : 원하연
  최조작성자 : 최상원
  KRI 지표명 :
     - 펀드사업팀-08: 펀드 별단예금 미지급 잔액 보유 건수
       A: 전월말 중 펀드별단계정[위탁판매유가증권수납금]에 입금 발생된 계좌 건수
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

    DELETE OPEOWN.TB_OPE_KRI_펀드사업팀08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_펀드사업팀08

    SELECT   P_BASEDAY                         --기준년월
            ,A.ASP_ADM_BRNO                    --별단관리점번호
            ,J1.BR_NM
            ,A.ASP_ACNO                        --별단계좌번호
            ,A.ASP_TXIM_KDCD                   --세목코드
            ,A.ASP_DFRY_PSB_RMD                --별단지급가능잔액
            ,B.TR_RCFM_DT ROM_DT               --입금일자
            ,B.ENR_USR_NO                      --조작자번호

    FROM     TB_SOR_SDM_ASP_DP_BC A     -- SOR_SDM_별단예금기본
    JOIN     TB_SOR_SDM_ASP_DP_TR_TR B  -- SOR_SDM_별단예금거래내역
             ON   A.ASP_ACNO    = B.ASP_ACNO
             AND  B.ASP_TR_KDCD = '1'     -- 입금
             AND  B.TR_STCD     = '1'
             AND  B.TR_RCFM_DT  BETWEEN P_SOTM_DT AND  P_EOTM_DT
    /*
    JOIN     TB_SOR_SDM_ASP_TXIM_BC  CD   -- SOR_SDM_별단세목기본
             ON   A.ASP_TXIM_KDCD  = CD.ASP_TXIM_KDCD
    */
    JOIN     TB_SOR_CMI_BR_BC     J1       -- SOR_CMI_점기본
             ON   A.ASP_ADM_BRNO  =  J1.BRNO
    WHERE    1=1
    AND      A.ASP_TXIM_KDCD = '28'  -- 펀드고객미지급금
    AND      A.ASP_DP_ACN_STCD = '1' -- 입금정상
    AND      A.ASP_ACNO LIKE '1%'    -- 은행만
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_펀드사업팀08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT


