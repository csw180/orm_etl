/*
  프로그램명 : ins_TB_OPE_KRI_수신제도지원팀27
  타켓테이블 : TB_OPE_KRI_수신제도지원팀27
  KRI 지표명 : 1개월이상 미정리된 별단예금 일시예수금세목의 건수
  협      조 : 원하연사원
  최조작성자 : 최상원
  KRI 지표명 :
     - 수신제도지원팀-27 :1개월이상 미정리된 별단예금 일시예수금세목의 건수
       A: 별단예금 일시예수금세목의 건수
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

    DELETE OPEOWN.TB_OPE_KRI_수신제도지원팀27
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_수신제도지원팀27
    SELECT   P_BASEDAY
            ,A.ASP_ADM_BRNO                    --별단관리점번호
            ,J.BR_NM
            ,A.ASP_ACNO                        --별단계좌번호
            ,A.ASP_TXIM_KDCD                   --세목코드
            ,B.TR_RCFM_DT                      --입금일자
            ,C.MAX_TR_RCFM_DT                  --지급일자(지급이 여러번일때는 최근날짜)
            ,B.ENR_USR_NO                     --조작자번호

    FROM     TB_SOR_SDM_ASP_DP_BC A        -- SOR_SDM_별단예금기본

    JOIN     TB_SOR_CMI_BR_BC   J       -- SOR_CMI_점기본
             ON    A.ASP_ADM_BRNO  = J.BRNO

    JOIN     TB_SOR_SDM_ASP_DP_TR_TR B     -- SOR_SDM_별단예금거래내역
             ON    A.ASP_ACNO = B.ASP_ACNO
             AND   B.ASP_TR_KDCD = '1'     -- 입금
             AND   B.TR_STCD = '1'
             AND   TO_CHAR(ADD_MONTHS(TO_DATE(B.TR_RCFM_DT,'YYYYMMDD'), 1), 'YYYYMMDD')  <= P_BASEDAY
                -- 입금된지 1개월이 지난건

    LEFT OUTER JOIN
             (
               SELECT   ASP_ACNO, MAX(TR_RCFM_DT)  MAX_TR_RCFM_DT
               FROM     TB_SOR_SDM_ASP_DP_TR_TR  -- SOR_SDM_별단예금거래내역
               WHERE    1=1
               AND      ASP_TR_KDCD  = '2'   -- 지급
               AND      TR_STCD = '1'
               GROUP BY ASP_ACNO
             )  C
             ON   A.ASP_ACNO = C.ASP_ACNO

    WHERE    1=1
    AND      A.ASP_TXIM_KDCD IN ('05','08','10','11','12','13','16','23','25','28')
    AND      A.ASP_DP_ACN_STCD = '1' -- 별단예금계좌상태코드(1:정상, 2:정정, 3:전출등록, 4: 해지)
    AND      A.ASP_ACNO LIKE '1%'    -- 은행만
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_수신제도지원팀27',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT








