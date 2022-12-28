/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀05
  타켓테이블 : TB_OPE_KRI_여신지원팀05
  KRI 지표명 : 취급직원 지점으로 이관한 차주 수
  협      조 : 최현정차장
  최조작성자 : 최상원
  KRI 지표명 :
   - 여신지원팀-05 취급직원 지점으로 이관한 차주 수
     A: 대출전입된 차주 중 전입 영업점/지점의 직원이 취급 및 결재한 차주 수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀05
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀05
    SELECT   P_BASEDAY       AS   기준일자
            ,A.CUST_NO        AS   고객번호
            ,A.ACNO           AS   계좌번호
            ,D.PDCD            AS   상품코드
            ,PD.PRD_KR_NM      AS   상품명
            ,A.CRCD            AS   통화코드
            ,A.MIMO_AMT        AS   여신잔액
            ,A.MVT_BRNO        AS   이관점번호
            ,J1.BR_NM          AS   이관점명
            ,A.MVT_TR_USR_NO   AS   이관조작자직원번호
            ,A.MVN_BRNO        AS   수관점번호
            ,J2.BR_NM          AS   수관점명
            ,A.MVN_TR_USR_NO   AS   수관조작자직원번호
            ,A.TR_DT           AS   이수관조작일자
--            'Y'                AS   승인대상여부
--            '0000'             AS   승인부서
            ,C.APRV_TGT_YN     AS   승인대상여부
            ,C.APRV_BRNO       AS   승인부서
    FROM     (

              SELECT  TR_DT                 -- 거래일자
                     ,CHG_DT                -- 변경일자
                     ,CHG_TM                -- 변경시각
                     ,CHG_BRNO              -- 변경점번호
                     ,CHG_USR_NO            -- 변경사용자번호
                     ,ENR_BRNO              -- 등록점번호
                     ,CUST_NO               -- 고객번호
                     ,ACNO                  -- 계좌번호
                     ,CRCD                  -- 통화코드
                     ,MIMO_AMT              -- 전입전출금액
                     ,MVT_BRNO              -- 전출점번호
                     ,MVT_TR_USR_NO         -- 전출거래사용자번호
                     ,MVN_BRNO              -- 전입점번호
                     ,MVN_TR_USR_NO         -- 전입거래사용자번호
              FROM    TB_SOR_CMP_MVN_MVT_TR A -- SOR_CMP_전입전출내역
              WHERE   1=1
              AND     TR_DT  BETWEEN  P_SOTM_DT  AND  P_EOTM_DT
              AND     CMN_SPPT_TSK_DSCD = '2'  -- 공통지원업무구분코드(2:여신업무)
              AND     MIMO_DSCD =  '2'   -- 전입전출구분코드(2:전입실행)
              AND     MVT_BRNO IN  ( SELECT BRNO
                                     FROM   TB_SOR_CMI_BR_BC  -- CMI_점기본
                                     WHERE   FSC_DSCD = '1'   -- 회계구분코드(1:은행)
                                    )
             )  A
    JOIN     (
                SELECT  TR_DT              -- 거래일자
                       ,MIMO_SNO           -- 전입전출일련번호
                       ,CHG_DT             -- 변경일자
                       ,CHG_TM             -- 변경시각
                       ,CHG_BRNO           -- 변경점번호
                       ,CHG_USR_NO         -- 변경사용자번호
                       ,ACNO               -- 계좌번호
                FROM    TB_SOR_CMP_MVN_MVT_TR A -- SOR_CMP_전입전출내역
                WHERE   1=1
                AND     TR_DT  BETWEEN  P_SOTM_DT  AND  P_EOTM_DT
                AND     MIMO_DSCD =  '3'   -- 전입전출구분코드(3:전입등록)
                AND     CMN_SPPT_TSK_DSCD = '2'  -- 공통지원업무구분코드(2:여신업무)
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
                FROM     TB_SOR_CMP_MVT_APRV_TR -- SOR_CMP_전출등록본부승인내역
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

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀05',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT