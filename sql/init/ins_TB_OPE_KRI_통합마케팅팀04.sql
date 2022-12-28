/*
  프로그램명 : ins_TB_OPE_KRI_통합마케팅팀04
  타켓테이블 : TB_OPE_KRI_통합마케팅팀04
  KRI 지표명 : 초우량 고객 이탈 건수
  협      조 : 노성환차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 통합마케팅팀-04: 초우량 고객 이탈 건수
       A: 전월중 발생한 초우량 고객 이탈 수
*/
DECLARE
  P_BASEDAY  VARCHAR2(8);  -- 기준일자
  P_SOTM_DT  VARCHAR2(8);  -- 당월초일
  P_EOTM_DT  VARCHAR2(8);  -- 당월말일
  P_LD_CN    NUMBER;       -- 로딩건수
BEGIN
  SELECT  STD_DT,EOTM_DT,SUBSTR(EOTM_DT,1,6) || '01'
  INTO    P_BASEDAY
         ,P_EOTM_DT
         ,P_SOTM_DT
  FROM   DWZOWN.OM_DWA_DT_BC
  WHERE   STD_DT = '&1';
  
  IF P_EOTM_DT = P_BASEDAY  THEN
  
    DELETE OPEOWN.TB_OPE_KRI_통합마케팅팀04
    WHERE  STD_DT = P_EOTM_DT;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_통합마케팅팀04
    -- 전월 초우량 -> 당월 등급이탈
    SELECT   /*+ FULL(A) */
             A.기준일자
            ,A.주거래점번호
            ,A.주거래점명
            ,A.고객번호
            ,A.CRM등급코드
    FROM     CRM.TB_SFAT고객통합실적 A
    WHERE    1=1
    AND      A.기준일자     = P_EOTM_DT
    AND      A.CRM등급코드 != '01'
    AND      EXISTS (SELECT  /*+ FULL(X) */
                             1
                     FROM    CRM.TB_SFAT고객통합실적 X
                     WHERE   X.고객번호 = A.고객번호
                     AND     X.기준일자 = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(P_EOTM_DT, 'YYYYMMDD'), -1)), 'YYYYMMDD')  -- 전월
                     AND     X.CRM등급코드 = '01'
                    )
    UNION ALL

    -- 전월 초우량 -> 당월 실적없음
    SELECT   /*+ FULL(A) */
             P_EOTM_DT
            ,A.주거래점번호
            ,A.주거래점명
            ,A.고객번호
            ,''  CRM등급코드
    FROM     CRM.TB_SFAT고객통합실적 A
    WHERE    1=1
    AND      A.기준일자    = TO_CHAR(LAST_DAY(ADD_MONTHS(TO_DATE(P_EOTM_DT, 'YYYYMMDD'), -1)), 'YYYYMMDD')
    AND      A.CRM등급코드 = '01'
    AND      NOT EXISTS (SELECT /*+ FULL(X) */
                                1
                         FROM   CRM.TB_SFAT고객통합실적 X
                         WHERE  X.고객번호 = A.고객번호
                         AND    X.기준일자 = P_EOTM_DT
                        )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_통합마케팅팀04',P_EOTM_DT,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
