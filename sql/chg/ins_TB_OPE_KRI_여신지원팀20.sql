/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀20
  타켓테이블 : TB_OPE_KRI_여신지원팀20
  KRI 지표명 : 고객정보 변경 후 신용대출 신청 건수
  협      조 : 이상민/이천수
  최초작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-20 고객정보 변경 후 신용대출 신청 건수
       A: 전월 전행 20백만원 이상 신용대출 신청 건 중 당일 휴대전화번호 변경이 있었던 건수
       B: 전월 전행 20백만원 이상 신용대출 신청 건 중 당일 전화 및 문자수신거부 등록이 있었던 건수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀20
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀20
    SELECT    P_BASEDAY
             ,A.ADM_BRNO                AS   점번호
             ,J1.BR_NM                  AS   점명
             ,A.CHNL_TPCD               AS   채널유형코드
             ,A.CUST_NO                 AS   고객번호
             ,A.CLN_ACNO                AS   계좌번호
             ,PD.PRD_KR_NM              AS   상품명
             ,'KRW'                     AS   통화코드
             ,A.CLN_APC_AMT             AS   여신신청금액
             ,A.APC_DT                  AS   여신신청일
             ,DECODE(C.변경일1,NULL,'N','Y')  AS 휴대전화번호변경여부
             ,C.변경일1                 AS   휴대전화변경등록일
             ,CASE WHEN C.변경일2 IS NOT NULL OR C.변경일3 IS NOT NULL THEN  'Y'
                   ELSE 'N'
              END                       AS  전화문자수신거부여부
             ,CASE WHEN C.변경일2 IS NULL THEN
                   CASE WHEN C.변경일3 IS NULL THEN  NULL
                        ELSE C.변경일3
                   END
                   ELSE C.변경등록일2
              END                       AS  거부등록일
    FROM      TB_SOR_PLI_INET_TR A          -- SOR_PLI_인터넷대출내역
    JOIN      TB_SOR_PLI_APC_POT_CUST_TR B  -- SOR_PLI_신청시점고객내역
              ON   A.CLN_APC_NO  =  B.CLN_APC_NO
              AND  A.CUST_NO     =  B.CUST_NO
    JOIN      (
                SELECT   CUST_NO
                        ,휴대전화변경일           AS 변경일1
                        ,문자수신변경일           AS 변경일2
                        ,문자수신변경등록일       AS 변경등록일2
                        ,전화수신변경일           AS 변경일3
                FROM     (
                            -- 휴대전화번호변경
                            -- 대상기간안에 한고객이 휴대전화번호 변경이 여러번 일어 날수도 있다.
                            SELECT   CUST_NO
                                    ,TO_CHAR(ENR_DTTM,'YYYYMMDD')  AS 휴대전화변경일
                                    ,NULL                          AS 문자수신변경일
                                    ,NULL                          AS 문자수신변경등록일
                                    ,NULL                          AS 전화수신변경일
                            from     TB_SOR_CUS_CHG_TR A    --SOR_CUS_고객변경내역
                            WHERE    1=1
                            AND      TO_CHAR(ENR_DTTM , 'YYYYMMDD')   BETWEEN  P_SOTM_DT AND   P_EOTM_DT
                            AND      CUST_INF_CHG_DSCD = '0001'     -- 휴대폰번호변경
                            AND      CHNL_TPCD IN ('EIRB' , 'ERIB' , 'ESRB' , 'ESRM' )
                            AND      TRIM(CHB_DAT_CTS) IS NOT NULL  -- 변경전에 없는 경우는 등록한 경우일수 있어서..

                            UNION ALL

                            select   CUST_NO
                                    ,NULL                           AS 휴대전화변경일
                                    ,TO_CHAR(CHG_DTTM , 'YYYYMMDD') AS 문자수신변경일
                                    ,TO_CHAR(ENR_DTTM , 'YYYYMMDD') AS 문자수신변경등록일
                                    ,NULL                           AS 전화수신변경일
                            FROM     TB_SOR_CUS_CTN_INF_DL A    --SOR_CUS_주의정보상세
                            WHERE    1=1
                            AND      TO_CHAR(CHG_DTTM,'YYYYMMDD') BETWEEN  P_SOTM_DT AND   P_EOTM_DT
                            AND      CUST_CTN_INF_CD = '15'     --   고객주의정보코드 (15:SMS수신거부)
                            AND      SUBSTR(CHG_USR_NO ,1,4) IN ('EIRB' , 'ERIB' , 'ESRB' , 'ESRM' )

                            UNION ALL

                            SELECT   CUST_NO
                                    ,NULL                           AS  휴대전화변경일
                                    ,NULL                           AS  문자수신변경일
                                    ,NULL                           AS  문자수신변경등록일
                                    ,ENR_DT                         AS  전화수신변경일
                            FROM    TB_SOR_CUS_DONC_CUST_BC A      -- SOR_CUS_두낫콜고객기본
                            WHERE   1=1
                            AND     ENR_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT
                            AND     DONC_STCD = '1'
                         )  A
              )   C
              ON  A.CUST_NO  = C.CUST_NO
              AND (
                      A.APC_DT   = C.변경일1  OR
                      A.APC_DT   = C.변경일2  OR
                      A.APC_DT   = C.변경일3
                  )

    JOIN     TB_SOR_CMI_BR_BC     J1   -- SOR_CMI_점기본
             ON     A.ADM_BRNO  =  J1.BRNO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD   -- SOR_PDF_상품기본
             ON     A.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE     1=1
    AND       A.APC_DT BETWEEN  P_SOTM_DT AND   P_EOTM_DT
    AND       A.INET_CLN_APC_PGRS_STCD = '41'  -- 41:대출실행완료
    AND       A.CLN_APC_AMT > '20000000';

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀20',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
