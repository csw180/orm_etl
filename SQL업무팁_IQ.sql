//{ #TEMP테이블

CREATE TABLE  #대상계좌
(
  순번           INT,
  계좌번호       CHAR(12)
  -- 고객번호   NUMERIC(9)
);


LOAD   TABLE  #대상계좌
(
순번   '|',
계좌번호 '\x0a'
)   FROM '/nasdat/edw/in/etc/대상계좌.dat'
QUOTES OFF
ESCAPES OFF
--SKIP 1   -- 타이틀 제외
--BLOCK FACTOR 3000
FORMAT ASCII
;

temp table create 사용예

declare local temporary table temp1
(
 구분코드 numeric(1),
 실명번호 numeric(15),
 점번호 numeric(5)
) on commit preserve rows;


//}

//{ #암호화  #암복호

-- CASE 1

CREATE TABLE  #대상고객
(
     순번           int,
     평문           CHAR(13),
     암호문         CHAR(13)
);

LOAD   TABLE  #대상고객
(
순번   '|',
평문   '|',
암호문 '\x0a'
)   FROM '/ettapp/common/crypt/대상고객.out'
QUOTES OFF
ESCAPES OFF
--SKIP 1   -- 타이틀 제외
--BLOCK FACTOR 3000
FORMAT ASCII;

/*   암호화SET 후에 활성화시킬것
UPDATE TB_MDWT인사  A
SET   A.주민번호  = B.암호문
FROM   #대상고객  B
WHERE  A.작성기준일 = '$$WRT_DATE1'  --작성기준일 = $기준일자
AND    A.주민번호  = B.평문
;
*/

TRUNCATE TABLE TB_SOR_CUS_ALT_RRNO_BC;   -- SOR_CUS_대체주민등록번호기본

INSERT INTO TB_SOR_CUS_ALT_RRNO_BC
SELECT 순번,NOW(),'EDW','931436','','',NOW(),암호문,평문
FROM   #대상고객
;

-- CASE 2
단건 암복호화 조회는 오라클에서만 함수를 이용하여 할수있다
  - 배치서버나 후처리 서버에서  다음과 같이

  select ENCRYPT_FL('DBSEC.KEY.RRNO', '6910211684712') FROM DUAL
  select DECRYPT_FL('DBSEC.KEY.RRNO', '6910211AUGGMA') FROM DUAL

//}


//{ #잔액모집단  #기업자금  #가계자금 #원화대출금  #모집단

-- 1. 잔액모집단 기업자금
SELECT      A.STD_DT                     AS  기준일자
           ,A.CUST_NO                    AS  고객번호
           ,A.CUST_NM                    AS  고객명

           ,CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999'
                   AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014년부터 88도 기업으로 포함시킨다.
                 THEN CASE WHEN ISNULL(D.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.대기업'  ELSE '2.중소기업'  END
            ELSE '3.개인사업자'
            END                          AS  기업구분
           ,A.BRNO                       AS  점번호
           ,E.BR_NM                      AS  점명
           ,A.INTG_ACNO                  AS  통합계좌번호
           ,A.CLN_EXE_NO                 AS  여신실행번호
           ,A.FRPP_KDCD                  AS  장표종류
           ,A.AGR_DT                     AS  약정일자
           ,A.AGR_AMT                    AS  약정금액
           ,A.FST_LN_DT                  AS  대출일자
           ,A.LN_EXE_AMT                 AS  대출실행금액
           ,A.LN_RMD                     AS  잔액
           ,A.MRT_CD                     AS  담보코드
           ,A.INDV_LMT_LN_DSCD           AS  개별한도대출구분코드

INTO        #기업대출   -- DROP TABLE #기업대출

FROM        OT_DWA_INTG_CLN_BC   A
JOIN        (
              SELECT   STD_DT
                      ,ACSB_CD
                      ,ACSB_NM
                      ,ACSB_CD4  --원화대출금
                      ,ACSB_NM4
                      ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                      ,ACSB_NM5
                      ,ACSB_CD6  --기업운전자금대출금(15002001), 기업시설자금대출금(15002101)
                      ,ACSB_NM6
              FROM     OT_DWA_DD_ACSB_TR
              WHERE    1=1
              AND      FSC_SNCD      IN ('K','C')
              AND      ACSB_CD5 IN ('14002401')     --기업자금대출금
            )          C
            ON    A.BS_ACSB_CD  =  C.ACSB_CD
            AND   A.STD_DT      =  C.STD_DT

LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_기업규모기본
            ON     A.RNNO      = D.RNNO
            AND    A.STD_DT    = D.STD_DT

JOIN        OT_DWA_DD_BR_BC      E       -- DWA_일점기본
            ON     A.STD_DT    = E.STD_DT
            AND    A.BRNO      = E.BRNO

WHERE       1=1
AND         A.STD_DT        IN ('20101231','20111231','20121231','20131231','20141231','20151231','20161031')
AND         A.BR_DSCD       = '1'   --중앙회
AND         A.CLN_ACN_STCD  = '1'           --여신계좌상태코드:1 정상
;

-- 2. 잔액모집단 가계자금
SELECT      A.STD_DT             AS   기준일자
           ,CASE WHEN  SUBSTR(A.RNNO,7,1) IN ('0','9') THEN '18'  --1800년대 남성,여성
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('1','2') THEN '19'  --1900년대 남성,여성
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('3','4') THEN '20'  --2000년대 남성,여성
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('5','6') THEN '19'  --1900년대 외국인남성,여성
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('7','8') THEN '20'  --2000년대 외국인남성,여성
            END  ||    SUBSTR(A.RNNO,1,6)      AS    생년월일

--            생년월일중에 남여 및 외국인구분 디짓이 이상한건들이 있어서 때에 따라서 병행하여 사용, 100세 넘으면 문제생김, 18이라는 숫자는 작업년도(2018)기준으로 임의로 정한 숫자임
           ,CASE WHEN  LEFT(A.RNNO,2) < '18'   THEN  CONVERT(CHAR(2),'20')
                 WHEN  LEFT(A.RNNO,2) >= '18'  THEN  CONVERT(CHAR(2),'19')
                 ELSE  'XX'
            END  ||   SUBSTR(A.RNNO,1,6)      AS    생년월일2
            
           ,CONVERT(INT,LEFT(A.STD_DT,4)) - CONVERT(INT,LEFT(생년월일,4)) + CASE WHEN CONVERT(INT,RIGHT(생년월일,4)) > CONVERT(INT,RIGHT(A.STD_DT,4)) THEN -1 ELSE 0 END  AS 만나이

           ,CASE WHEN 만나이 <  20                     THEN '1.20세 미만'
                 WHEN 만나이 >= 20  AND 만나이 < 30  THEN '2.20세이상 ~ 30세미만'
                 WHEN 만나이 >= 30  AND 만나이 < 40  THEN '3.30세이상 ~ 40세미만'
                 WHEN 만나이 >= 40  AND 만나이 < 50  THEN '4.40세이상 ~ 50세미만'
                 WHEN 만나이 >= 50  AND 만나이 < 60  THEN '5.50세이상 ~ 60세미만'
                 WHEN 만나이 >= 60                     THEN '6.60세 이상'
                 ELSE '7.기타'
                 END  AS 나이구분

           ,A.INTG_ACNO                       AS 통합계좌번호
           ,A.CLN_EXE_NO                      AS 실행번호
           ,A.CUST_NO                         AS 고객번호
           ,A.LN_RMD                          AS 대출잔액
           ,CASE WHEN ISDATE(A.FSS_OVD_ST_DT ) = 1  THEN 'Y'           ELSE NULL    END     AS 금감원연체여부
           ,CASE WHEN ISDATE(A.FSS_OVD_ST_DT ) = 1  THEN A.OVD_AMT     ELSE 0       END     AS 금감원연체금액

INTO        #가계  -- DROP TABLE #가계

FROM        OT_DWA_INTG_CLN_BC   A

JOIN        OT_DWA_DD_BR_BC      B       -- DWA_일점기본
            ON         A.STD_DT       = B.STD_DT
            AND        A.BRNO         = B.BRNO

JOIN        (
              SELECT   STD_DT
                      ,ACSB_CD
                      ,ACSB_NM
                      ,ACSB_CD4  --원화대출금
                      ,ACSB_NM4
                      ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                      ,ACSB_NM5
                      ,ACSB_CD6  --기업운전자금대출금(15002001), 기업시설자금대출금(15002101)
                      ,ACSB_NM6
              FROM     OT_DWA_DD_ACSB_TR
              WHERE    1=1
              AND      FSC_SNCD      IN ('K','C')
              AND      ACSB_CD5      IN ('14002501')     --가계자금대출금

            )       C
            ON    A.BS_ACSB_CD  =  C.ACSB_CD
            AND   A.STD_DT      =  C.STD_DT

WHERE       1=1
AND         A.STD_DT        = '20180531'
AND         A.BR_DSCD       = '1'   --은행
AND         A.CLN_ACN_STCD  = '1'   --여신계좌상태코드:1 정상
;

//}


//{ #상품기본  #상품코드  #상품코드명 #브랜드코드 #브랜드코드명 #여신상품구조

  ,SUBSTR(A.PDCD, 6, 4)              AS 브랜드코드

SELECT
           ,A.PRD_BRND_CD       AS 상품브랜드코드
           ,ISNULL(TRIM(H.PRD_BRND_CD_NM),' ')    AS 상품브랜드코드명
           ,A.PDCD              AS   상품코드
           ,ISNULL(TRIM(G.PRD_KR_NM),' ')    AS 상품코드명
...........
LEFT OUTER JOIN
            TB_SOR_PDF_PRD_BC G                       -- SOR_PDF_상품기본
            ON     A.PDCD  = G.PDCD
            AND    G.APL_STCD  =  '10'                -- 이거빠지면 데이터 증폭됨

LEFT OUTER JOIN
            DWZOWN.OT_DWA_CLN_PRD_STRC_BC H           --여신상품
            ON     A.PDCD     = H.PDCD
            AND    H.STD_DT   = '20151031'
//}

//{ #이자수입 #거래이자

-- 거래내역의 거래이자
SELECT      A.CLN_ACNO                   AS 여신계좌번호
           ,A.GRLN_ADM_NO                AS 집단대출승인번호
           ,B.CLN_EXE_NO                 AS 여신실행번호
           ,E.CLN_TR_NO                  AS 여신거래번호
           ,ISNULL(E.TR_INT,0)           AS 거래이자1          -- 거래내역의 거래이자
           ,E.TR_DT                      AS 거래일자
           ,ISNULL(SUM(F.LN_INT),0)      AS 거래이자2          -- 이자계산내역의 대출이자
                                                               -- 거래내역의 거래이자와 비교하기 위해서 같이 산출해봄..
INTO        #TEMP           -- DROP TABLE #TEMP
FROM        TB_SOR_LOA_ACN_BC      A     --SOR_LOA_계좌기본
JOIN        TB_SOR_LOA_EXE_BC      B     --SOR_LOA_실행기본
            ON      A.CLN_ACNO     =  B.CLN_ACNO

JOIN        OM_DWA_INTG_CUST_BC    C     --DWA_통합고객기본
            ON      A.CUST_NO      =  C.CUST_NO

JOIN        TB_SOR_LOA_TR_TR        E     --SOR_LOA_거래내역
            ON      B.CLN_ACNO     =   E.CLN_ACNO
            AND     B.CLN_EXE_NO   =   E.CLN_EXE_NO
            AND     E.TR_STCD      =   '1' --정상
            AND     E.CLN_TR_DTL_KDCD IN ('3001','3002','3003','3004',
                                          '3101','3102','3103','3201','3202','3301','3302','3601')
            AND     E.TR_DT BETWEEN  '20130701'  AND '20160523'

LEFT OUTER JOIN
            TB_SOR_LOA_INT_CAL_DL    F    --  SOR_LOA_이자계산상세
            ON      E.CLN_ACNO     =   F.CLN_ACNO
            AND     E.CLN_EXE_NO   =   F.CLN_EXE_NO
            AND     E.CLN_TR_NO    =   F.CLN_TR_NO
            AND     F.CLN_INT_CAL_TPCD  IN ('11','13','16','19')
            --  여신이자계산유형코드 (11:정상이자,13:원금연체이자,16:이자연체이자,19:미수이자(회수))
            --  19:미수이자(회수), 20:미수이자(발생) 은 예외거래시 발생하는 항목으로
            --  예외거래시 임의로 등록한대로 받고(미수거래회수), 등록한 만큼 남겨놓을수(미수거래발생) 있다
            --  이 미수이자의 자금이 정상이자성격인지 연체이자성격인지는 판단할수 없다.
            --  LOA_거래내역에 거래이자와 같은 금액이 나오려면 정상이자, 원금연체이자, 이자연체이자을 포함시켜야 한다
            --  어쩌면 12:환출이자만 제외하면 될지도 모른다.ㅠㅠ

WHERE       1=1
AND         A.GRLN_ADM_NO IN ('G1201300000013','G1201300000024')

--AND         E.TR_DT >=  '20160101'
GROUP BY    A.CLN_ACNO
           ,A.GRLN_ADM_NO
           ,B.CLN_EXE_NO
           ,E.CLN_TR_NO
           ,E.TR_INT
           ,E.TR_DT
--HAVING      거래이자1 <> 거래이자2    -- 거래내역의 거래이자와 이자계산상세의 대출이자가 같은지 비교하기 위해서 임시로 추가
ORDER BY    1,3,5
;


-- 종통의 대출이자 구하는 법
SELECT      A.기준일자
           ,A.통합계좌번호
           ,A.여신실행번호
           ,LEFT(E.TR_DT,6)                          AS 거래연월
           ,ISNULL(SUM(E.LN_INT + E.OVD_INT + E.NNPR_INT + E.NNPR_DLY_INT),0)      AS 거래이자  -- 대출이자 + 연체이자 + 미원가이자 + 미원가지연이자
-- 미원가이자 : 결산시 한도부족으로 이자수납이 안된이자(미원가이자) 나중에 입금들어오면 이자가 빠진다. 미원가지연이자는 미원가이자에 대한 이자 이다
-- TB_SOR_DEP_TR_DL(SOR_DEP_거래상세) 이 테이블에는 정정/취소건은 없고 정상거래건만 들어오므로 상태 체크없이 구할수있다
FROM        #원화대출금   A

JOIN        TB_SOR_DEP_TR_DL    E     --SOR_DEP_거래상세
            ON      A.통합계좌번호     =   E.CLN_ACNO
            AND     LEFT(A.기준일자,6) =  LEFT(E.TR_DT,6)
            AND     E.TR_DT BETWEEN  '20110101'  AND '20160331'

WHERE       1=1
GROUP BY    A.기준일자
           ,A.통합계좌번호
           ,A.여신실행번호
           ,LEFT(E.TR_DT,6)
;

-- 연체기간동안 정상이자 및 연체이자 수입금액
-- 여신관리부(20171030)_주택담보대출연체내역_조홍석.SQL  참고
SELECT      A.기준일자
           ,A.계좌번호
           ,A.여신실행번호
           ,A.약정금액
           ,A.여신실행금액
           ,A.연체발생일자
           ,A.금감원연체시작일자
           ,A.원금연체금액
           ,A.할부연체금액
           ,A.원금연체이자
           ,A.할부연체이자
           ,A.이자연체이자

           ,E.TR_DT             AS  거래일자
           ,CASE WHEN F.CLN_INT_CAL_TPCD  IN ('11')      THEN F.LN_INT ELSE NULL END   AS 정상이자
           ,CASE WHEN F.CLN_INT_CAL_TPCD  IN ('13','14','15','16') THEN F.LN_INT ELSE NULL END   AS 연체이자

INTO        #주담연체내역_이자수입   --  DROP TABLE #주담연체내역_이자수입

FROM        #주담연체내역   A

JOIN        TB_SOR_LOA_TR_TR        E     --SOR_LOA_거래내역
            ON      A.계좌번호       =   E.CLN_ACNO
            AND     A.여신실행번호   =   E.CLN_EXE_NO
            AND     E.TR_DT           >  A.연체발생일자
            AND     E.TR_DT          <=  A.기준일자
            AND     E.TR_STCD        =   '1' --정상

JOIN        TB_SOR_LOA_INT_CAL_DL    F    --  SOR_LOA_이자계산상세
            ON      E.CLN_ACNO     =   F.CLN_ACNO
            AND     E.CLN_EXE_NO   =   F.CLN_EXE_NO
            AND     E.CLN_TR_NO    =   F.CLN_TR_NO
//-----------------------------------------------------------------------------
            AND     F.CLN_INT_CAL_TPCD  IN ('11','13','14','15','16')   --
            --  여신이자계산유형코드 (11:정상이자,13:원금연체이자,16:이자연체이자,19:미수이자(회수))
            --  LOA_거래내역에 거래이자와 같은 금액이 나오려면 정상이자, 원금연체이자, 이자연체이자을 포함시켜야 한다
            --  어쩌면 12:환출이자만 제외하면 될지도 모른다.
//-----------------------------------------------------------------------------
WHERE       1=1

UNION ALL

SELECT      A.기준일자
           ,A.계좌번호
           ,A.여신실행번호
           ,A.약정금액
           ,A.여신실행금액
           ,A.연체발생일자
           ,A.금감원연체시작일자
           ,A.원금연체금액
           ,A.할부연체금액
           ,A.원금연체이자
           ,A.할부연체이자
           ,A.이자연체이자

           ,E.TR_DT             AS  거래일자
           ,E.LN_INT            AS  정상이자
           ,E.OVD_INT           AS  연체이자
--           ,ISNULL(SUM(E.LN_INT + E.OVD_INT + E.NNPR_INT + E.NNPR_DLY_INT),0)      AS 거래이자  -- 대출이자 + 연체이자 + 미원가이자 + 미원가지연이자
-- 미원가이자 : 결산시 한도부족으로 이자수납이 안된이자(미원가이자) 나중에 입금들어오면 이자가 빠진다. 미원가지연이자는 미원가이자에 대한 이자 이다
-- TB_SOR_DEP_TR_DL(SOR_DEP_거래상세) 이 테이블에는 정정/취소건은 없고 정상거래건만 들어오므로 상태 체크없이 구할수있다
FROM        #주담연체내역   A

JOIN        TB_SOR_DEP_TR_DL    E     --SOR_DEP_거래상세
            ON      A.계좌번호         =   E.ACNO
            AND     E.TR_DT           >  A.연체발생일자
            AND     E.TR_DT          <=  A.기준일자

WHERE       1=1
AND         ( E.LN_INT <> 0 OR E.OVD_INT <> 0 )  -- 정상이자와 연체이자
;

//}

//{ #원화대출금 #기업자금 #가계자금대출금 #외화대출금  #지급보증

-- CASE 1 : 원화대출금
JOIN        (
                  SELECT   STD_DT
                          ,ACSB_CD
                          ,ACSB_NM
                          ,ACSB_CD4  --원화대출금
                          ,ACSB_NM4
                          ,ACSB_CD5  --기업자금대출금(14002401), 가계자금대출금(14002501), 공공및기타(14002601)
                          ,ACSB_NM5
                          ,ACSB_CD6
                          ,ACSB_NM6
                  FROM     OT_DWA_DD_ACSB_TR
                  WHERE    1=1
                  AND      FSC_SNCD IN ('K','C')
                  AND      ACSB_CD4 IN ('13000801')       --원화대출금
            )           K
            ON       A.BS_ACSB_CD   =   K.ACSB_CD
            AND      A.STD_DT       =   K.STD_DT


-- CASE 2 : 기업대출금계정, 가계자금대출금
JOIN        (
                   SELECT   STD_DT
                           ,ACSB_CD
                           ,ACSB_NM
                           ,ACSB_CD4  --원화대출금
                           ,ACSB_NM4
                           ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                           ,ACSB_NM5
                   FROM     OT_DWA_DD_ACSB_TR
                   WHERE    FSC_SNCD IN ('K','C')
--                AND       ACSB_CD4 = '13000801'                      --원화대출금
                  AND      ACSB_CD5 IN ('14002401','14002501')     --기업대출금계정,가계자금대출금
            )           C
            ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS계정과목코드
            AND      A.STD_DT       =   C.STD_DT

-- CASE3 : 원화대출금,외화대출금
JOIN        (
              SELECT   STD_DT
                      ,ACSB_CD
                      ,ACSB_NM
                      ,ACSB_CD4  --원화대출금
                      ,ACSB_NM4
                      ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                      ,ACSB_NM5
              FROM     OT_DWA_DD_ACSB_TR
              WHERE    FSC_SNCD IN ('K','C')
              AND       ACSB_CD4 IN ( '13000801','13001108')         --원화대출금, 외화대출금
            )           C
            ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS계정과목코드
            AND      A.STD_DT       =   C.STD_DT

-- CASE4 지급보증
              AND      FSC_SNCD      IN ('K','C')
              AND      (    ACSB_CD5   IN ('14002401','14002601')   OR -- 기업자금대출금,공공및기타자금
                            ACSB_CD2    ='93000201'                 OR -- 미확정지급보증
                            ACSB_CD3   IN ('94000208','94000101')      -- 외화확정지급보증, 원화확정지급보증
                       )
//}

//{ #외환고객한도 #외환한도 #한도사용액

참고프로시져  :  UP_DWZ_외환_N0012_외환고객한도
참고프로그램  :  외환사업팀(20131108)_외환업체한도및관련실적_건별.sql

//}

//{ #본부승인  #전결 #전결승인 #전결여신  #승인여신

-- CASE 1
CREATE  TABLE  #TEMP_본부승인      --  DROP TABLE  #TEMP_본부승인
(
             기준일자             CHAR(8)
            ,계좌번호             CHAR(20)
            ,점명                 CHAR(100)
            ,심사구분             CHAR(10)
            ,승인일자             CHAR(8)
);


BEGIN
DECLARE   V_BASEDAY   CHAR(8);

SET    V_BASEDAY = '20141231';
--  SET    V_BASEDAY = '20150630';
--  SET    V_BASEDAY = '20150831';

INSERT INTO #TEMP_본부승인
--기업여신
SELECT      V_BASEDAY             AS 기준일자
           ,A.ACN_DCMT_NO         AS 계좌번호
           --,B.APRV_BRNO           AS 승인점번호
           ,TRIM(D.BR_NM)         AS 승인점
           ,'기업심사'            AS 심사구분
           ,MAX(B.HDQ_APRV_DT)    AS 승인일자
INTO        #TEMP_본부승인
FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
           ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
           ,(SELECT   A.ACN_DCMT_NO         AS 계좌번호
                     ,MAX(B.HDQ_APRV_DT)    AS 승인일자
             FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
                     ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
             WHERE    A.ACN_DCMT_NO       IS NOT NULL
             AND      A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
             AND      A.CLN_APC_CMPL_DSCD IN ('20','21')              -- 여신신청완료구분코드(20:약정,21:실행)
             AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드

             AND      B.APCL_DSCD         = '2'               -- 승인여신구분코드(1:영업점승인,2:본부승인)
             AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
             AND      B.HDQ_APRV_DT      <= V_BASEDAY
             GROUP BY A.ACN_DCMT_NO
             ) C
           ,OT_DWA_DD_BR_BC D  --DWA_일점기본
WHERE       A.ACN_DCMT_NO       IS NOT NULL
AND         A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정, 21:실행)
AND         B.APCL_DSCD         = '2'               -- 승인여신구분코드(1:영업점승인,2:본부승인)
AND         A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
AND         B.HDQ_APRV_DT       <= V_BASEDAY      -- 승인일자
AND         A.ACN_DCMT_NO       = C.계좌번호
AND         B.HDQ_APRV_DT       = C.승인일자
AND         B.APRV_BRNO         *= D.BRNO
AND         D.STD_DT            = V_BASEDAY
AND         D.BRNO              <> 'XXXX'
GROUP BY    A.ACN_DCMT_NO
           ,승인점

UNION ALL

--개인여신의 경우 모두 심사부승인
SELECT      V_BASEDAY          AS 기준일자
           ,A.CLN_ACNO         AS 계좌번호
           ,'심사부'           AS 승인점
           ,'개인심사'         AS 심사구분
           ,MAX(A.CLN_APRV_DT) AS 승인일자
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
           ,(SELECT   A.CLN_ACNO         AS 계좌번호
                     ,MAX(A.CLN_APRV_DT) AS 승인일자
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
             WHERE    A.CLN_ACNO          IS NOT NULL
             AND      A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
             AND      A.CSS_XCDC_DSCD     = '22'              -- CSS전결구분코드(11:지소장-조합,21:점장-중앙회,22:부서장(중앙회))
             AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
             AND      A.CLN_APRV_DT       <= V_BASEDAY
             GROUP BY A.CLN_ACNO
            ) B
WHERE       A.CLN_ACNO          IS NOT NULL
AND         A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
AND         A.CSS_XCDC_DSCD     = '22'              -- CSS전결구분코드(11:지소장-조합,21:점장-중앙회,22:부서장(중앙회))
AND         A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
AND         A.CLN_APRV_DT       <= V_BASEDAY
AND         A.CLN_ACNO          = B.계좌번호
AND         A.CLN_APRV_DT       = B.승인일자
GROUP BY    A.CLN_ACNO;

END;


-- CASE 2

CREATE  TABLE  #TEMP_본부승인      --  DROP TABLE  #TEMP_본부승인
(
            기준일자             CHAR(8)
           ,계좌번호             CHAR(20)
           ,점명                 CHAR(100)
           ,심사구분             CHAR(10)
           ,승인일자             CHAR(8)
           ,승인번호             CHAR(14)
           ,담당심사역사용자번호 CHAR(10)
           ,여신신청구분코드     CHAR(2)
           ,여신전결구분         CHAR(100)
           ,신청점               CHAR(5)
);


--#TEMP_본부승인

BEGIN
DECLARE     V_BASEDAY   CHAR(8);

SET         V_BASEDAY = '20161130';
--SET         V_BASEDAY = '20141231';
--SET         V_BASEDAY = '20151130';

--기업여신
SELECT      A.ACN_DCMT_NO         AS 계좌번호
           --,B.APRV_BRNO           AS 승인점번호
           ,TRIM(D.BR_NM)         AS 승인점
           ,'기업심사'            AS 심사구분
           ,B.HDQ_APRV_DT         AS 승인일자
           ,A.CLN_APRV_NO         AS 승인번호
           ,B.RSBL_XMRL_USR_NO    AS 담당심사역사용자번호
           ,A.CLN_APC_DSCD        AS 신청구분
           ,B.CSLT_BRNO           AS 신청점
INTO        #TEMP
FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
           ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
           ,(SELECT   A.ACN_DCMT_NO         AS 계좌번호
                     ,MAX(B.HDQ_APRV_DT)    AS 승인일자
             FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
                     ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
             WHERE    A.ACN_DCMT_NO       IS NOT NULL
             -------------------------------------------------------------------------------
             AND      A.CLN_APC_DSCD       < '10'             -- 신규 ( 이거 없으면 연장같은것도 대상으로 들어간다.)
             -------------------------------------------------------------------------------
             AND      A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
             AND      A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
             AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
             AND      B.APCL_DSCD         = '2'               -- 승인여신구분코드(1:영업점승인,2:본부승인)
             AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
             AND      B.HDQ_APRV_DT       <= V_BASEDAY   -- 승인일자
             GROUP BY A.ACN_DCMT_NO
            ) C
           ,OT_DWA_DD_BR_BC D  --DWA_일점기본
WHERE       A.ACN_DCMT_NO       IS NOT NULL
AND         A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
AND         B.APCL_DSCD         = '2'               -- 승인여신구분코드(1:영업점승인,2:본부승인)
AND         A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
AND         B.HDQ_APRV_DT       <= V_BASEDAY   -- 승인일자
AND         A.ACN_DCMT_NO       = C.계좌번호
AND         B.HDQ_APRV_DT       = C.승인일자
AND         B.APRV_BRNO         *= D.BRNO
AND         D.STD_DT            = V_BASEDAY
AND         D.BRNO              <> 'XXXX'

UNION ALL

--개인여신의 경우 모두 심사부승인
SELECT      A.CLN_ACNO         AS 계좌번호
           ,'심사부'           AS 승인점
           ,'개인심사'         AS 심사구분
           ,A.CLN_APRV_DT      AS 승인일자
           ,A.CLN_APRV_NO        AS 승인번호
           ,A.RSBL_XMRL_USR_NO   AS 담당심사역사용자번호
           ,A.CLN_APC_DSCD       AS 신청구분
           ,A.ADM_BRNO           AS 신청점
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
           ,(SELECT   A.CLN_ACNO         AS 계좌번호
                     ,MAX(A.CLN_APRV_DT) AS 승인일자
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
             WHERE    A.CLN_ACNO          IS NOT NULL
             -------------------------------------------------------------------------------
             AND      A.CLN_APC_DSCD       < '10'             -- 신규
             -------------------------------------------------------------------------------
             AND      A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
             AND      A.CSS_XCDC_DSCD     = '22'              -- CSS전결구분코드(11:지소장-조합,21:점장-중앙회,22:부서장(중앙회))
             AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
             AND      A.CLN_APRV_DT       <= V_BASEDAY   -- 승인일자
             GROUP BY A.CLN_ACNO
            ) B
WHERE       A.CLN_ACNO          IS NOT NULL
AND         A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
AND         A.CSS_XCDC_DSCD     = '22'              -- CSS전결구분코드(11:지소장-조합,21:점장-중앙회,22:부서장(중앙회))
AND         A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
AND         A.CLN_APRV_DT       <= V_BASEDAY   -- 승인일자
AND         A.CLN_ACNO          = B.계좌번호
AND         A.CLN_APRV_DT       = B.승인일자
;

INSERT INTO #TEMP_본부승인
SELECT      V_BASEDAY
           ,A.계좌번호
           ,A.승인점
           ,A.심사구분
           ,A.승인일자
           ,A.승인번호
           ,A.담당심사역사용자번호
           ,A.신청구분
           ,C.LST_XCDC_DSCD ||'('||TRIM(D.XCDC_DSCD_NM)||')'  AS 여신전결구분
           ,A.신청점

FROM        #TEMP A

JOIN        (
             SELECT   A.계좌번호
                     ,A.승인일자
                     ,MAX(A.승인번호)   AS 최종승인번호
             FROM     #TEMP A
                     ,(SELECT   계좌번호
                               ,MAX(승인일자)   AS 최종승인일자
                       FROM     #TEMP
                       GROUP BY 계좌번호
                       ) B
             WHERE    A.계좌번호 = B.계좌번호
             AND      A.승인일자 = B.최종승인일자
             GROUP BY A.계좌번호
                     ,A.승인일자
            ) B
            ON   A.계좌번호    = B.계좌번호
            AND  A.승인일자    = B.승인일자
            AND  A.승인번호    = B.최종승인번호

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APRV_BC   C     -- SOR_CLI_여신승인기본
            ON   A.승인번호  =  C.CLN_APRV_NO

/*
LEFT OUTER JOIN
                        ,(SELECT   CRDT_EVL_NO        AS 신용평가번호
                      ,CRDT_EVL_MODL_DSCD AS 신용평가모형
                      ,LST_ADJ_GD         AS 최종조정등급
              FROM     TB_SOR_CCR_EVL_INF_TR              --SOR_CCR_평가정보내역
              WHERE    CRDT_EVL_PGRS_STCD = '2'           --신용평가진행상태코드(2:평가완료)
              AND      NFFC_UNN_DSCD      = '1'           --중앙회조합구분코드(1:중앙회)
              AND      CMPL_DT           <= V_BASEDAY    --완료일자
              )  C
                  AND      A.기업신용평가번호 *= C.신용평가번호
*/


LEFT OUTER JOIN
            TB_SOR_CLI_XCDC_DSCD_BC  D   --SOR_CLI_전결구분코드기본
            ON   C.LST_XCDC_DSCD  = D.CLN_XCDC_DSCD  --여신전결구분코드
;

END;

-- CASE3
-- CASE2는 신규신청건들을 찾아서 해당 신청건에 붙어 있는 승인부서가 본부인지를 판단하는 로직
-- 그러나 CASE3 는 신청건전체(31금리승인만 제외하고 신규,조건변경,연장,증액,채무인수등 모든 신청건을 대상으로 가장최근신청건이 본부승인지를 판단하는 로직임

CREATE  TABLE  #TEMP_본부승인      --  DROP TABLE  #TEMP_본부승인
(
            기준일자             CHAR(8)
           ,계좌번호             CHAR(20)
           ,점명                 CHAR(100)
           ,심사구분             CHAR(10)
           ,승인일자             CHAR(8)
           ,승인번호             CHAR(14)
           ,담당심사역사용자번호 CHAR(10)
           ,여신신청구분코드     CHAR(2)
           ,여신전결구분         CHAR(100)
           ,신청점               CHAR(5)
);

--#TEMP_본부승인
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

--기업여신
SELECT      A.ACN_DCMT_NO         AS 계좌번호
           --,B.APRV_BRNO           AS 승인점번호
           ,TRIM(D.BR_NM)         AS 승인점
           ,'기업심사'            AS 심사구분
           ,B.HDQ_APRV_DT         AS 승인일자
           ,A.CLN_APRV_NO         AS 승인번호
           ,B.RSBL_XMRL_USR_NO    AS 담당심사역사용자번호
           ,A.CLN_APC_DSCD        AS 신청구분
           ,B.CSLT_BRNO           AS 신청점
INTO        #TEMP
FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- SOR_CLI_여신신청기본
           ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- SOR_CLI_여신신청대표기본
           ,(-- 본부승인 영업점승인 구분없이 각 신청건별로 승인일과 승인번호 최근순으로 번호를 붙인다. 나중에 최근것을 가져올것이다.
             SELECT   A.ACN_DCMT_NO         AS 계좌번호
                     ,A.CLN_APC_NO          AS 여신신청번호
                     ,ROW_NUMBER() OVER(PARTITION BY A.ACN_DCMT_NO ORDER BY 
                                        CASE WHEN B.HDQ_APRV_DT  IS NOT NULL AND B.HDQ_APRV_DT >  '19000000' THEN B.HDQ_APRV_DT
                                             ELSE B.SLS_BR_APRV_DT
                                        END DESC, A.CLN_APRV_NO DESC ) AS 순서
             FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
                     ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
             WHERE    A.ACN_DCMT_NO       IS NOT NULL
            --------------------------------------------------------------------------------
            --- 금번자료는 신규건에 국한하지 않고 기한연장, 조건변경, 채무인수 등 모두 포함한다.
             AND      A.CLN_APC_DSCD    <> '31'            -- 31(금리승인) 만 제외하고 모든 신청건이 대상임
            ---AND      A.CLN_APC_DSCD       < '10'             -- 신규 ( 이거 없으면 연장같은것도 대상으로 들어간다.)
            --------------------------------------------------------------------------------
             AND      A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
             AND      A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
             AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
--             AND      B.APCL_DSCD         = '2'             -- 승인여신구분코드(1:영업점승인,2:본부승인)
             AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
             AND      CASE WHEN B.HDQ_APRV_DT  IS NOT NULL AND B.HDQ_APRV_DT >  '19000000' THEN B.HDQ_APRV_DT
                           ELSE B.SLS_BR_APRV_DT
                      END    <= V_BASEDAY   -- 승인일자
            ) C
           ,OT_DWA_DD_BR_BC D  --DWA_일점기본
WHERE       A.ACN_DCMT_NO       IS NOT NULL
AND         A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
AND         B.APCL_DSCD         = '2'               -- 승인여신구분코드(1:영업점승인,2:본부승인)
AND         A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
//----------------------------------------------------------------------------
AND         A.ACN_DCMT_NO       = C.계좌번호
AND         A.CLN_APC_NO        = C.여신신청번호
AND         C.순서              = 1
//-------------------------------------------------------------------------------
AND         B.APRV_BRNO        *= D.BRNO
AND         D.STD_DT            = V_BASEDAY
AND         D.BRNO              <> 'XXXX'

UNION ALL

--개인여신의 경우 모두 심사부승인
SELECT      A.CLN_ACNO         AS 계좌번호
           ,'심사부'           AS 승인점
           ,'개인심사'         AS 심사구분
           ,A.CLN_APRV_DT      AS 승인일자
           ,A.CLN_APRV_NO        AS 승인번호
           ,A.RSBL_XMRL_USR_NO   AS 담당심사역사용자번호
           ,A.CLN_APC_DSCD       AS 신청구분
           ,A.ADM_BRNO           AS 신청점
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
           ,(SELECT   A.CLN_ACNO         AS 계좌번호
                     ,MAX(A.CLN_APRV_DT) AS 승인일자
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
             WHERE    A.CLN_ACNO          IS NOT NULL
            --------------------------------------------------------------------------------
            --- 금번자료는 신규건에 국한하지 않고 기한연장, 조건변경, 금리승인, 채무인수 등 모두 포함한다.
             AND       A.CLN_APC_DSCD    <> '31'            -- 31(금리승인) 만 제외하고 모든 신청건이 대상임
            ---AND      A.CLN_APC_DSCD       < '10'             -- 신규
            --------------------------------------------------------------------------------
             AND      A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
--             AND      A.CSS_XCDC_DSCD     = '22'              -- CSS전결구분코드(11:지소장-조합,21:점장-중앙회,22:부서장(중앙회))
             AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
             AND      A.CLN_APRV_DT       <= V_BASEDAY   -- 승인일자
             GROUP BY A.CLN_ACNO
            ) B
WHERE       A.CLN_ACNO          IS NOT NULL
AND         A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
AND         A.CSS_XCDC_DSCD     = '22'              -- CSS전결구분코드(11:지소장-조합,21:점장-중앙회,22:부서장(중앙회))
AND         A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
AND         A.CLN_APRV_DT       <= V_BASEDAY   -- 승인일자
AND         A.CLN_ACNO          = B.계좌번호
AND         A.CLN_APRV_DT       = B.승인일자
;


INSERT INTO #TEMP_본부승인
SELECT      V_BASEDAY
           ,A.계좌번호
           ,A.승인점
           ,A.심사구분
           ,A.승인일자
           ,A.승인번호
           ,A.담당심사역사용자번호
           ,A.신청구분
           ,C.LST_XCDC_DSCD ||'('||TRIM(D.XCDC_DSCD_NM)||')'  AS 여신전결구분
           ,A.신청점

FROM        #TEMP A

JOIN        (
             SELECT   A.계좌번호
                     ,A.승인일자
                     ,MAX(A.승인번호)   AS 최종승인번호
             FROM     #TEMP A
                     ,(SELECT   계좌번호
                               ,MAX(승인일자)   AS 최종승인일자
                       FROM     #TEMP
                       GROUP BY 계좌번호
                       ) B
             WHERE    A.계좌번호 = B.계좌번호
             AND      A.승인일자 = B.최종승인일자
             GROUP BY A.계좌번호
                     ,A.승인일자
            ) B
            ON   A.계좌번호    = B.계좌번호
            AND  A.승인일자    = B.승인일자
            AND  A.승인번호    = B.최종승인번호

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APRV_BC   C     -- SOR_CLI_여신승인기본
            ON   A.승인번호  =  C.CLN_APRV_NO

/*
LEFT OUTER JOIN
                        ,(SELECT   CRDT_EVL_NO        AS 신용평가번호
                      ,CRDT_EVL_MODL_DSCD AS 신용평가모형
                      ,LST_ADJ_GD         AS 최종조정등급
              FROM     TB_SOR_CCR_EVL_INF_TR              --SOR_CCR_평가정보내역
              WHERE    CRDT_EVL_PGRS_STCD = '2'           --신용평가진행상태코드(2:평가완료)
              AND      NFFC_UNN_DSCD      = '1'           --중앙회조합구분코드(1:중앙회)
              AND      CMPL_DT           <= V_BASEDAY    --완료일자
              )  C
                  AND      A.기업신용평가번호 *= C.신용평가번호
*/


LEFT OUTER JOIN
            TB_SOR_CLI_XCDC_DSCD_BC  D   --SOR_CLI_전결구분코드기본
            ON   C.LST_XCDC_DSCD  = D.CLN_XCDC_DSCD  --여신전결구분코드
;

END;

//}

//{ #신용평가등급 #소호등급 #SOHO등급 #소기업 #CRS등급 #CSS등급 #ASS등급

-- 기업신용평가모형이지만 10등급을 따르는 모형에 대한 처리
-- 개인신용평가모형이지만 15등급을 따르는 모형에 대한 처리

--2. 월별 모형별 대출금리 현황(기업CRS 모형)
SELECT      기준일
           ,CASE WHEN 기업신용평가등급 IS NULL OR 기업신용평가모형구분코드 IN ('31','32','33','34')  THEN '기타'
                 ELSE 기업신용평가등급
            END           신용등급
            -- 소호모형 ('31','32','33','34') 은 10등급체계로 CRS등급(15등급체계) 와 다르므로
            -- 같이 출력이 불가하여 '기타' 로 분류함
           ,SUM(대출잔액)          잔액
           ,CASE WHEN SUM(대출잔액) > 0 THEN
                    CONVERT(NUMERIC(7,5),
                              SUM(대출잔액 * 시스템산출금리)
                             /SUM(대출잔액)
                            )
                 ELSE   0
            END                              AS  시스템금리

           ,CASE WHEN SUM(대출잔액) > 0 THEN
                    CONVERT(NUMERIC(7,5),
                              SUM(대출잔액 * 적용이율)
                             /SUM(대출잔액)
                            )
                 ELSE   0
            END                              AS  적용금리

FROM        #TEMP
WHERE       1=1
-- AND         월중신규여부 = 1
AND         월중연장여부 = 1
AND         자금구분 = '기업자금대출금'
GROUP BY    기준일
           ,신용등급
ORDER BY    1,2
;

--3. 월별 모형별 대출금리 현황 (CSS개인모형)
SELECT      기준일
           ,CONVERT(INT,CASE WHEN ASS신용등급 IS NULL OR ASS신용등급 IN ('0','00','11')  OR
                                  CSS모형구분코드 IN ('10','20','30','40','41','50','51','52','53','54','70','80')
                                  THEN  '99'
                             ELSE ASS신용등급
                             END
                   )                 AS 신용등급
            -- 개인신용등급 10등급 체계가 아니라 15등급체계로 분류되는 '소기업' 등 모형구분코드 ('10','20','30','40','41','50','51','52','53','54','70','80')
            -- 는 CSS등급과 같이 출력불가하여 '99' 로 분류함
           ,SUM(대출잔액)  AS  잔액
           ,CASE WHEN SUM(대출잔액) > 0 THEN
                    CONVERT(NUMERIC(7,5),
                              SUM(대출잔액 * 시스템산출금리)
                             /SUM(대출잔액)
                            )
                 ELSE   0
            END                              AS  시스템금리

           ,CASE WHEN SUM(대출잔액) > 0 THEN
                    CONVERT(NUMERIC(7,5),
                              SUM(대출잔액 * 적용이율)
                             /SUM(대출잔액)
                            )
                 ELSE   0
            END                              AS  적용금리

FROM        #TEMP
WHERE       1=1
--AND         월중신규여부 = 1
AND         월중연장여부 = 1
AND         자금구분 = '가계자금대출금'
GROUP BY    기준일
           ,신용등급
ORDER BY    1,2
;

//}

//{ #여신금리시스템 #시스템산출금리  #시스템금리 #최초약정 #승인번호

-- CASE1
UPDATE      #TEMP   A
--SET         A.시스템산출금리  = B.AGCS_APL_IRT                 -- 대고객적용금리  *계좌의 실적용금리와 너무 비슷하게 나옴
SET         A.시스템산출금리  = B.TOT_STD_IRT  + B.TOT_ADD_IRT  -- 총가산금리 + 총기준금리
            
FROM        (
                SELECT A.*
                FROM          TB_SOR_IRL_IRT_CALC_TR A
                INNER JOIN (
                              SELECT A.CLN_APC_NO, MAX(A.APCL_DSCD) APCL_DSCD
                              FROM (
                        SELECT A.CLN_APC_NO, A.APCL_DSCD
                        FROM   TB_SOR_IRL_IRT_CALC_TR A
                        WHERE  APCL_DSCD IN ('1','2')  -- 승인여신구분코드(1:영업점전결,2:본부승인,3:금리승인)
            
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
WHERE       A.여신신청번호  = B.CLN_APC_NO
;

-- CASE1-2 이게 더 정확한 새버젼

UPDATE      #TEMP   A
--SET         A.시스템산출금리  = B.AGCS_APL_IRT                 -- 대고객적용금리  *계좌의 실적용금리와 너무 비슷하게 나옴
SET         A.시스템산출금리  = B.TOT_STD_IRT  + B.TOT_ADD_IRT  -- 총가산금리 + 총기준금리
            
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
WHERE       A.여신신청번호  = B.CLN_APC_NO
;

-- CASE2
--20170329_주신보출연금대상계좌약정내역_이종환 소스참조함
SELECT      A.CLN_ACNO
           ,A.AGR_DT
           ,A.TR_STCD
           ,A.CLN_APRV_NO   AS 여신승인번호
           ,C.CLN_APC_NO    AS 여신신청번호
           ,C.APCL_DSCD     AS 승인여신구분코드
           ,C.TOT_STD_IRT   AS 총기준금리
           ,C.MKT_PCMN_IRT  AS 시장조달금리
           ,C.PLCY_ADJ_IRT  AS 정책조정금리
           ,C.TALM_ADJ_IRT  AS 총액한도대출조정금리
           ,C.MKT_ADJ_IRT   AS 시장조정금리
           ,C.FC_BRW_SPRD   AS 외화차입스프레드
           ,C.TOT_ADD_IRT   AS 총가산금리
           ,C.LQT_PRMM_IRT  AS 유동성프리미엄금리
           ,C.INXP_ADD_RT   AS 부대비용가산율
           ,C.EDU_TXRT      AS 교육세율
           ,C.HS_KCGF_GRFE_RT AS 주택신용보증기금출연료율
           ,C.NGSA_GRFE_RT  AS 농림수산업자신용보증기금출연료율
           ,C.TSK_PCST_ADD_IRT AS 업무원가가산금리
           ,C.DRCT_TSK_PCST_RT AS 직접업무원가율
           ,C.INDR_TSK_PCST_RT AS 간접업무원가율
           ,C.CRDT_PCST_ADD_IRT AS 신용원가가산금리
           ,C.ANT_LOSS_RT   AS 예상손실율
           ,C.NANT_LOSS_RT  AS 비예상손실율
           ,C.GL_MRGN_ADD_IRT AS 목표마진가산금리
           ,C.PRD_TP_ADD_IRT AS 상품유형가산금리
           ,C.LMT_LN_ADD_IRT AS 한도대출가산금리
           ,C.INDV_NTC_ADD_IRT AS 개별고시가산금리
           ,C.DNNS_MRT_ADD_IRT AS 예적금담보가산금리
           ,C.SYS_CALC_PCST_IRT AS 시스템산출원가금리
           ,C.TOT_ADD_PRM_IRT AS 총가산우대금리
           ,C.SLS_BR_ADD_IRT AS 영업점가산금리  --전결가산금리
           ,C.BRNO          AS 점번호
           ,C.APL_ST_DT     AS 적용시작일자
           ,C.APL_END_DT    AS 적용종료일자
           ,C.SLS_BR_PRM_BSC_IRT AS 영업점우대기본금리
           ,C.SLS_BR_GRDN_MXM_IRT AS 영업점차등최대금리
           ,C.SLS_BR_GRDN_APL_IRT AS 영업점차등적용금리
           ,C.SLS_BR_PRM_IRT AS 영업점우대금리 --전결감면금리
           ,C.HDQ_APRV_IRT  AS 본부승인금리
           ,C.INDV_ADJ_IRT  AS 개별조정금리
           ,C.AGCS_LN_IRT   AS 대고객대출금리
           ,C.CLN_APL_LWST_IRT AS 여신적용최저금리
           ,C.CLN_APL_HGST_IRT AS 여신적용최고금리
           ,C.AGCS_APL_IRT  AS 대고객적용금리
           ,C.SLS_BR_MRGN_IRT AS 영업점마진금리
           ,C.FTP_IRT       AS FTP금리
           ,C.ENR_USR_NO    AS 등록사용자번호
           ,C.ENR_DT        AS 등록일자
           ,C.EDTX_ICD_AGCS_APL_IRT AS 교육세포함대고객적용금리
           ,C.IRT_RNX_APL_YN AS 금리감면적용여부
           ,C.CRDT_CLN_GL_MRGN_ADD_IRT AS 신용여신목표마진가산금리
           ,C.MRT_CLN_GL_MRGN_ADD_IRT AS 담보여신목표마진가산금리
           ,C.GRN_PART_GL_MRGN_ADD_IRT AS 보증부분목표마진가산금리
           ,C.NGRN_PART_GL_MRGN_ADD_IRT AS 비보증부분목표마진가산금리
           ,C.IRT_ADJ_CFC   AS 금리조정계수
           ,C.GRN_PART_CRDT_PCST_ADD_IRT AS 보증부분신용원가가산금리
           ,C.GRN_PART_ANT_LOSS_RT AS 보증부분예상손실율
           ,C.GRN_PART_NANT_LOSS_RT AS 보증부분비예상손실율
           ,C.NGRN_PART_CRDT_PCST_ADD_IRT AS 비보증부분신용원가가산금리
           ,C.NGRN_PART_ANT_LOSS_RT AS 비보증부분예상손실율
           ,C.NGRN_PART_NANT_LOSS_RT AS 비보증부분비예상손실율
           ,C.GRN_PART_ADD_IRT AS 보증부분가산금리
           ,C.NGRN_PART_ADD_IRT AS 비보증부분가산금리
           ,ISNULL(C.APL_PRM_IRT,0) AS 부수거래감면금리
INTO        #TEMP_여신금리 --DROP TABLE #TEMP_여신금리
FROM
            (          -- 대상계좌의 최초약정건 구하기
             SELECT  A.CLN_ACNO
                    ,B.CLN_APRV_NO
                    ,B.AGR_DT
                    ,B.TR_STCD
             FROM    TB_SOR_LOA_ACN_BC A
             INNER JOIN
                     TB_SOR_LOA_AGR_HT   B
                     ON         A.CLN_ACNO = B.CLN_ACNO
                     AND        B.CLN_TR_KDCD NOT IN ('130','131')  --채무인수 제외
                     AND        B.CLN_TR_KDCD IN ('100')            -- 여신신청구분코드 신규약정
                     AND        B.CLN_APRV_NO IS NOT NULL
                     AND        A.NFFC_UNN_DSCD = '1'
             INNER JOIN
                     (
                      SELECT    A.CLN_ACNO
                               ,MAX(A.AGR_TR_SNO) AS MAX_SNO
                      FROM      TB_SOR_LOA_AGR_HT A
                      WHERE     A.CLN_TR_KDCD NOT IN ('130','131')  --채무인수 제외
                      AND       A.CLN_TR_KDCD IN ('100')            -- 여신신청구분코드 신규약정
                      AND       A.CLN_APRV_NO IS NOT NULL
                      AND       A.ENR_DT <=   '20170831'
                      GROUP BY  A.CLN_ACNO
                     ) C
                     ON  B.CLN_ACNO   = C.CLN_ACNO
                     AND B.AGR_TR_SNO = C.MAX_SNO
              WHERE  1=1
              //=========================================================================
              AND    A.CLN_ACNO IN  (SELECT   DISTINCT 계좌번호  FROM #모집단_잔액 )
              //=========================================================================
            ) A

INNER JOIN              -- 최초약정건의 신청번호를 가져오기 위하여 승인원장을 읽는다
            TB_SOR_CLI_CLN_APRV_BC B --SELECT CLN_APC_DSCD, CLN_APRV_LDGR_STCD, CLN_APC_NO FROM TB_SOR_CLI_CLN_APRV_BC WHERE CLN_APRV_NO = 'P1201600179215'
            ON       A.CLN_APRV_NO = B.CLN_APRV_NO
            AND      B.CLN_APC_DSCD != '51'
            AND      B.CLN_APRV_LDGR_STCD IN ('20','21') --AND A.CLN_ACNO = '321006763199'

INNER JOIN
            (
             SELECT  A.*
                     --LQT_PRMM_IRT  AS 유동성프리미엄금리
                     --INXP_ADD_RT   AS 부대비용가산율 ,
                     --EDU_TXRT      AS 교육세율 ,
                     --HS_KCGF_GRFE_RT AS 주택신용보증기금출연료율 ,
                     --NGSA_GRFE_RT  AS 농림수산업자신용보증기금출연료율 ,
                     --TSK_PCST_ADD_IRT AS 업무원가가산금리 ,
                     --DRCT_TSK_PCST_RT AS 직접업무원가율 ,
                     --INDR_TSK_PCST_RT AS 간접업무원가율 ,
                     --CRDT_PCST_ADD_IRT AS 신용원가가산금리 ,
                     --ANT_LOSS_RT   AS 예상손실율 ,
                     --NANT_LOSS_RT  AS 비예상손실율 ,
                     --GL_MRGN_ADD_IRT AS 목표마진가산금리
                    ,C.APL_PRM_IRT
             FROM    TB_SOR_IRL_IRT_CALC_TR A
             INNER JOIN
                     (
                      SELECT  A.CLN_APC_NO, MAX(A.APCL_DSCD) APCL_DSCD
                      FROM    (
                                SELECT A.CLN_APC_NO, A.APCL_DSCD
                                FROM   TB_SOR_IRL_IRT_CALC_TR  A
                                WHERE  APCL_DSCD IN ('1','2') --1영업점전결 2본부승인
                                UNION
                                SELECT A.CLN_APC_NO, '3' APCL_DSCD
                                FROM   TB_SOR_IRL_IRT_CALC_TR A
                                INNER JOIN
                                       TB_SOR_IRL_IRT_RNX_APRV_BC B
                                       ON A.CLN_APC_NO = B.CLN_APC_NO
                                       AND A.APCL_DSCD = '3'  --3 금리승인
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
                     FROM     TB_SOR_IRL_IRT_CALC_PRM_DL A --SOR_IRL_금리산출우대상세
                     WHERE    ADD_PRM_IRT_DSCD = '2' --가산우대금리구분코드 2 우대금리
                     AND      ADD_PRM_IRT_GRP_CD = '21' --가산우대금리그룹코드
                     AND      CHC_YN = 'Y' --선택여부
                     GROUP BY CLN_APC_NO, APCL_DSCD
                    ) C
                    ON        A.CLN_APC_NO = C.CLN_APC_NO
                    AND       A.APCL_DSCD  = C.APCL_DSCD
            ) C
            ON B.CLN_APC_NO = C.CLN_APC_NO
;
//}

//{ #점테이블 #중앙회신용점
JOIN        OT_DWA_DD_BR_BC             J
            ON      A.STD_DT       = J.STD_DT
            AND     A.BRNO         = J.BRNO
            AND     J.BR_DSCD      = '1'   -- 중앙회
            AND     J.FSC_DSCD     = '1'   -- 신용
            AND     J.BR_KDCD      < '40'  -- 10:본부부서,20:영업점,30:관리점
//}

//{ #여신금리구분코드 #공통코드

-- CASE 1 : 공통코드 와 공통코드명을 붙여찍는 방법
,A.GRLN_SIT_DSCD|| CASE WHEN X1.CMN_CD_NM IS NULL THEN '' ELSE '.' || TRIM(X1.CMN_CD_NM) END AS  집단대출소재지구분


SELECT     ,A.CLN_IRT_DSCD||'.'||ISNULL(TRIM(X1.CMN_CD_NM),' ')         AS 여신금리구분코드명
......
LEFT OUTER JOIN
            OM_DWA_CMN_CD_BC       X1                  -- DWA_공통코드기본
            ON    A.CLN_IRT_DSCD  = X1.CMN_CD          -- 공통코드
            AND   X1.TPCD_NO_EN_NM = 'CLN_IRT_DSCD'    -- 유형코드번호영문명



SELECT     ,CASE WHEN A.CLN_RDM_MHCD IS NOT NULL THEN A.CLN_RDM_MHCD || '.' || ISNULL(TRIM(X1.CMN_CD_NM),' ') ELSE '' END    AS   여신상환방법구분코드
LEFT OUTER JOIN
            OM_DWA_CMN_CD_BC   X1
            ON    A.CLN_RDM_MHCD  = X1.CMN_CD          -- 공통코드
            AND   X1.TPCD_NO_EN_NM = 'CLN_RDM_MHCD'    -- 유형코드번호영문명

//}


//{  #직업직위코드
-- CASE 1  직업직위코드
SELECT JB_PSTN_CD,JB_PSTN_NM FROM TB_SOR_CUS_JB_PSTN_CD_BC
//}

//{ #신용평가등급 #승인번호  #TEMP_신용평가  #평가정보

-- CASE 1 특정기준일로 부터 가장 최근의 평가정보를 가져오는 방식임
-- 참고프로그램 : 여신사업부(20140325)_대출금리현황.SQL 참고
-- 승인건을 가지고 신용등급을 찾는 로직이나 모든 승인건에 신용등급이 제대로 나오는지는 의문..

CREATE  TABLE  #TEMP_신용평가
(
             기준일자             CHAR(8)
            ,계좌번호             CHAR(20)
            ,고객번호             NUMERIC(9)
            ,여신승인번호         CHAR(14)
            ,여신신청대표번호     CHAR(14)
            ,여신신청번호         CHAR(14)
            ,여신신청구분코드     CHAR(2)
            ,승인일자             CHAR(8)
            ,기업신용평가모형구분코드     CHAR(2)
            ,기업신용평가등급     CHAR(3)
            ,CSS모형구분코드      CHAR(2)
            ,ASS신용등급          CHAR(3)
            ,승인여신구분_영업점전결 INT
            ,승인여신구분_본부승인   INT
            ,승인여신구분_금리승인   INT
            ,본부승인여부_신청       INT
);
-- DROP  TABLE #TEMP_신용평가

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

INSERT  INTO   #TEMP_신용평가
(
             기준일자
            ,계좌번호
            ,고객번호
            ,여신승인번호
            ,여신신청대표번호
            ,여신신청번호
            ,여신신청구분코드
            ,승인일자
            ,기업신용평가모형구분코드
            ,기업신용평가등급
            ,CSS모형구분코드
            ,ASS신용등급
            ,승인여신구분_영업점전결
            ,승인여신구분_본부승인
            ,승인여신구분_금리승인
            ,본부승인여부_신청
)

SELECT       V_BASEDAY  AS 기준일자
            ,A.계좌번호
            ,A.고객번호
            ,A.여신승인번호
            ,A.여신신청대표번호
            ,A.여신신청번호
            ,A.여신신청구분코드
            ,A.승인일자
            ,C.신용평가모형      AS 기업신용평가모형
            ,A.기업신용평가등급
            ,B.CSS_MODL_DSCD     AS 개인신용평가모형
            ,B.ASS_CRDT_GD       AS ASS신용등급
            ,ISNULL(D.승인여신구분_영업점전결,0) AS 승인여신구분_영업점전결
            ,ISNULL(D.승인여신구분_본부승인,0)  AS 승인여신구분_본부승인
            ,ISNULL(D.승인여신구분_금리승인,0)  AS 승인여신구분_금리승인
            ,CASE WHEN E.여신신청번호 IS NOT NULL THEN 1 ELSE 0 END   AS 본부승인여부_신청
            --,C.최종조정등급      --기업신용평가등급이랑 같다
FROM        (SELECT   A.ACN_DCMT_NO       AS 계좌번호
                     ,A.CUST_NO           AS 고객번호
                     ,A.CLN_APRV_NO       AS 여신승인번호
                     ,A.APRV_DT           AS 승인일자
                     ,A.CRDT_EVL_GD       AS 기업신용평가등급
                     ,A.CRDT_EVL_NO       AS 기업신용평가번호
                     ,A.CLN_APC_RPST_NO   AS 여신신청대표번호
                     ,A.CLN_APC_NO        AS 여신신청번호
                     ,A.CLN_APC_DSCD      AS 여신신청구분코드

             FROM     TB_SOR_CLI_CLN_APRV_BC  A
                    ,(SELECT   A.ACN_DCMT_NO       AS 계좌번호
                              ,MAX(A.CLN_APRV_NO)  AS 여신승인번호
                      FROM     TB_SOR_CLI_CLN_APRV_BC A  --SOR_CLI_여신승인기본
                             ,(SELECT   ACN_DCMT_NO
                                       ,MAX(APRV_DT)   AS MAX_APRV_DT
                               FROM     TB_SOR_CLI_CLN_APRV_BC  --SOR_CLI_여신승인기본
                               WHERE    APRV_DT            <= V_BASEDAY        --승인일자
                               AND      CLN_APRV_LDGR_STCD IN ('10','20','21')   --여신승인원장상태코드(10:승인,20:약정,21:실행완료)
                               AND      NFFC_UNN_DSCD       = '1'                --중앙회조합구분코드(1:중앙회)
                               GROUP BY ACN_DCMT_NO
                               ) B
                      WHERE    A.APRV_DT            <=  V_BASEDAY        --승인일자
                      AND      A.CLN_APRV_LDGR_STCD IN ('10','20','21')   --여신승인원장상태코드(10:승인,20:약정,21:실행완료)
                      AND      A.NFFC_UNN_DSCD       = '1'                --중앙회조합구분코드(1:중앙회)
                      AND      A.ACN_DCMT_NO         = B.ACN_DCMT_NO
                      AND      A.APRV_DT             = B.MAX_APRV_DT
                      GROUP BY 계좌번호
                      ) B
             WHERE    A.ACN_DCMT_NO        = B.계좌번호
             AND      A.CLN_APRV_NO        = B.여신승인번호
             AND      A.APRV_DT            <=  V_BASEDAY        --승인일자
             AND      A.CLN_APRV_LDGR_STCD IN ('10','20','21')   --여신승인원장상태코드(10:승인,20:약정,21:실행완료)
             AND      A.NFFC_UNN_DSCD      = '1'
             ) A
            ,TB_SOR_PLI_SYS_JUD_RSLT_TR B          --SOR_PLI_시스템심사결과내역
            ,(SELECT   CRDT_EVL_NO        AS 신용평가번호
                      ,CRDT_EVL_MODL_DSCD AS 신용평가모형
                      ,LST_ADJ_GD         AS 최종조정등급
              FROM     TB_SOR_CCR_EVL_INF_TR              --SOR_CCR_평가정보내역
              WHERE    CRDT_EVL_PGRS_STCD = '2'           --신용평가진행상태코드(2:평가완료)
              AND      NFFC_UNN_DSCD      = '1'           --중앙회조합구분코드(1:중앙회)
              AND      CMPL_DT           <= V_BASEDAY    --완료일자
              )  C
            ,(SELECT   A.CLN_APC_NO
                      ,MAX(CASE WHEN A.APCL_DSCD = '1'  THEN 1 ELSE 0 END) AS  승인여신구분_영업점전결
                      ,MAX(CASE WHEN A.APCL_DSCD = '2'  THEN 1 ELSE 0 END) AS  승인여신구분_본부승인
                      ,MAX(CASE WHEN A.APCL_DSCD = '3'  THEN 1 ELSE 0 END) AS  승인여신구분_금리승인
              FROM    (SELECT   CLN_APC_NO
                               ,APCL_DSCD
                       FROM     TB_SOR_IRL_IRT_CALC_TR         --SOR_IRL_금리산출내역  --SELECT * FROM TB_SOR_IRL_IRT_CALC_TR WHERE  CLN_APC_NO = 'A1201300157709'
                       WHERE    APCL_DSCD IN ('1','2')         --승인여신구분코드(1:영업점전결,2:본부승인)
                       UNION ALL
                       SELECT   A.CLN_APC_NO
                               ,A.APCL_DSCD
                       FROM     TB_SOR_IRL_IRT_CALC_TR     A   --SOR_IRL_금리산출내역
                               ,TB_SOR_IRL_IRT_RNX_APRV_BC B   --SOR_IRL_금리감면승인기본  --SELECT * FROM TB_SOR_IRL_IRT_RNX_APRV_BC
                       WHERE    A.CLN_APC_NO        = B.CLN_APC_NO
                       AND      A.APCL_DSCD         = '3'      --승인여신구분코드(3:금리승인)
                       AND      B.IRT_RNX_PGRS_STCD = '04'     --금리감면진행상태코드(04:승인완료)
                      ) A
              GROUP BY A.CLN_APC_NO
             ) D
            ,(
                SELECT   CLN_APC_NO            AS 여신신청번호
                FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
                        ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
                WHERE    1=1
                AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
                AND      B.APCL_DSCD         = '2'               -- 승인여신구분코드(1:영업점승인,2:본부승인)

                UNION ALL

                -- 개인여신은 모두 심사부 승인
                SELECT   CLN_APC_NO            AS 여신신청번호
                FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
                WHERE    1=1
              )  E

    WHERE    A.고객번호         *= B.CUST_NO
    AND      A.여신신청번호     *= B.CLN_APC_NO
    AND      A.기업신용평가번호 *= C.신용평가번호
    AND      A.여신신청번호     *= D.CLN_APC_NO
    AND      A.여신신청번호     *= E.여신신청번호
;
END;


-- CASE 2 신규시점의 평가정보 가져오는 방법
/********************************************************************************
*                     기업여신 신규시점 평가정보 가져오기                       *
********************************************************************************/
SELECT      T.통합계좌번호
           ,B.CLN_APC_NO         AS  여신신청번호
           ,B.CLN_APRV_NO        AS  여신승인번호
           ,D.CRDT_EVL_NO        AS  신용평가번호
           ,D.CRDT_EVL_GD        AS  신용평가등급
           ,D.STDD_INDS_CLCD     AS  표준산업분류코드
           ,F.대분류명           AS  업종명
           ,E.CMPL_DT            AS  평가완료일자
           ,E.CRDT_EVL_MODL_DSCD AS  신용평가모형
           ,E.LST_ADJ_GD         AS  최종조정등급  --   D.CRDT_EVL_GD 와 일치함, 확인해볼려고 출력해봄

INTO        #기업대출_신규신청번호    -- DROP TABLE #기업대출_신규신청번호

FROM        ( SELECT DISTINCT 통합계좌번호,약정일자 FROM  #기업대출)   T

JOIN
            TB_SOR_CLI_CLN_APC_BC      B    -- SOR_CLI_여신신청기본
            ON  T.통합계좌번호      = B.ACN_DCMT_NO
            AND T.약정일자          = B.AGR_DT             -- 종통때문에 이거 걸어줘야 계좌가 중복안된다.
            AND B.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- 여신신청구분코드(01:신규,02:대환)
            AND B.NFFC_UNN_DSCD   = '1'     -- 중앙회
            AND B.APC_LDGR_STCD   = '10'    -- 신청원장상태코드(01:작성중,02:결재중,10:완료,99:취소)
            AND B.CLN_APC_CMPL_DSCD IN ('20','21') -- 여신신청완료구분코드 -- 09:부결, 10:승인 18:승인후미취급, 20:약정, 21:실행,17:철회
--
--JOIN        TB_SOR_CLI_CLN_APC_RPST_BC C  -- SOR_CLI_여신신청대표기본
--            ON  B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO

JOIN
            TB_SOR_CLI_CLN_APRV_BC  D   --SOR_CLI_여신승인기본
            ON  B.CLN_APRV_NO  =  D.CLN_APRV_NO

LEFT OUTER JOIN
            TB_SOR_CCR_EVL_INF_TR  E   --SOR_CCR_평가정보내역
            ON    D.CRDT_EVL_NO  =  E.CRDT_EVL_NO
            AND   E.CRDT_EVL_PGRS_STCD = '2'           --신용평가진행상태코드(2:평가완료)
            AND   E.NFFC_UNN_DSCD      = '1'           --중앙회조합구분코드(1:중앙회)

LEFT OUTER JOIN
            #TEMP_표준산업분류     F
            ON   LEFT(D.STDD_INDS_CLCD, 4) = F.세분류코드
;

-- CASE 3 최근평가정보를 가져오는 방법
-- CASE1은 가장최근 승인내역에서 평가번호를 가져와서 평가정보를 가져오는 방법
-- 그에 반해서 이소스는 승인내역을 참조하지 않고 평가정보중 가장 최근 평가정보를 가져오는 방법
-- 두 방법에 미세한 차이점이 있을것으로 본다.
-- UP_DWZ_여신_N0149_기업신용등급평가운영실적 소스중 일부

SELECT      P_기준일자  AS  기준일자
           ,A.실명번호
           ,A.기업형태코드
           ,A.기업규모상세구분코드
           ,A.모형구분
           ,A.최종조정등급
           ,A.평가완료일
           ,A.신용평가구분코드             --  92:정기(수시)평가
           ,A.상향하향선택코드
INTO        #TEMP_신용평가모형      -- DROP TABLE #TEMP_신용평가모형
FROM        (SELECT   CASE WHEN B.RPST_RNNO > ' ' THEN B.RPST_RNNO
                           ELSE A.RNNO
                      END                  AS 실명번호
                     ,A.ENTP_FRCD	         AS 기업형태코드
                     ,A.ENTP_SCL_DTL_DSCD  AS 기업규모상세구분코드
                     ,B.CRDT_EVL_MODL_DSCD AS 모형구분                     -- 신용평가모형구분코드
                     ,B.LST_ADJ_GD         AS 최종조정등급
                     ,B.CMPL_DT            AS 평가완료일
                     ,B.CRDT_EVL_DSCD      AS 신용평가구분코드
                     ,B.UPW_DWTR_CHC_CD	   AS 상향하향선택코드
                     ,ROW_NUMBER(*) OVER(PARTITION BY  실명번호 ORDER BY B.CMPL_DT DESC,B.CRDT_EVL_NO DESC) AS RNUM
                        -- 실명번호가 동일한건들이 생기기 때문에 필요하다
             FROM     DWZOWN.TB_SOR_CCR_EVL_BZNS_OTL_TR A        --SOR_CCR_평가업체개요내역
                     ,DWZOWN.TB_SOR_CCR_EVL_INF_BC B      --SOR_CCR_평가정보기본
                     ,(SELECT   RNNO             AS 실명번호
                               ,CRDT_EVL_NO      AS 신용평가번호
                               ,ROW_NUMBER(*) OVER(PARTITION BY  RNNO ORDER BY CMPL_DT DESC,CRDT_EVL_NO DESC) AS RNUM
                                 -- 평가완료일이 가장 나중것을 우선, 평가완료일이 동일하면 평가번호가 큰것을 나중것으로 본다
                       FROM     DWZOWN.TB_SOR_CCR_EVL_INF_BC               -- (SOR_CCR_평가정보기본)
                       WHERE    1=1
                       AND      CRDT_EVL_PGRS_STCD = '2'                   -- 신용평가진행상태코드(2:평가완료)
                       AND      NFFC_UNN_DSCD      = '1'                   -- 중앙회조합구분코드(1:중앙회)
                       AND      CRDT_EVL_MODL_DSCD  IS NOT NULL  AND CRDT_EVL_MODL_DSCD <> '34'
                       AND      CRDT_EVL_OMT_DSCD  = '02'
                       AND      ST_DT >  '20120813'
                       AND      SMPR_RNNO IS NOT NULL
                         //------------------------------------------------------------------
                         AND    CMPL_DT  <=  P_기준일자
                         //------------------------------------------------------------------
                      ) C
             WHERE    1=1
               AND    C.RNUM          = 1 -- 평가내역중 가장최근평가건 가져오기
               AND    A.RNNO          = B.RNNO
               AND    A.CRDT_EVL_NO   = B.CRDT_EVL_NO
               AND    B.RNNO          = C.실명번호
               AND    B.CRDT_EVL_NO   = C.신용평가번호
            ) A
WHERE       1=1
AND         A.RNUM = 1
//}


//{   #신규신청번호  #최초약정 #약정이력 #최초약정승인번호
-- 처음약정건에 붙어 있는 승인번호로 신청번호 가져오는 방법이 신규신청번호가져오는 가장 정확한 방법이다.
-- 하지만 이런방식으로는 차세대이전 신규신청건은 구해올수 없어서 보충하는 로직을 추가한다.
SELECT      A.*
           ,ISNULL(D.CLN_APC_NO,E.CLN_APC_NO)  AS  여신신청번호

INTO        #연체채권    -- DROP TABLE #연체채권
FROM        #TEMP_연체채권 A

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
                                   ,MIN(AGR_TR_SNO) AS AGR_TR_SNO    --계좌번호별 약정일자별로 신규약정건은 1건이라야 맞지만 2건씩 나오는게 있음
                           FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                           WHERE    CLN_APC_DSCD IN ('01','02','04','07','08','09') --여신신청구분코드 <10 는 신규건
                           --AND      TR_STCD       =  '1'             --거래상태코드(1:정상) 이거걸면 새는건 생김
                           GROUP BY CLN_ACNO,AGR_DT
                         )            TB
                         ON    TA.CLN_ACNO   = TB.CLN_ACNO
                         AND   TA.AGR_TR_SNO = TB.AGR_TR_SNO
            )  B
            ON    A.통합계좌번호  =  B.CLN_ACNO
            AND   A.약정일자      =  B.AGR_DT

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APRV_BC   C     -- SOR_CLI_여신승인기본
            ON   B.CLN_APRV_NO  =  C.CLN_APRV_NO

LEFT OUTER JOIN
            TB_SOR_PLI_CLN_APC_BC      D   -- SOR_PLI_여신신청기본
            ON  C.CLN_APC_NO        = D.CLN_APC_NO

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APC_BC       E   -- SOR_CLI_여신신청기본
            ON  C.CLN_APC_NO        = E.CLN_APC_NO
;

-- 차세대 이전신청건은 승인원장을 통해서 찾아들어가면 유효한 신청번호를 찾을수 없다.
-- 아래 로직으로 빈값이 많을것을 보충을 해준다.

SELECT      A.CLN_ACNO         AS 계좌번호
           ,A.LN_AGR_DT        AS 약정일자
           ,MAX(A.CLN_APC_NO)  AS 신청번호
INTO        #TEMP_신규신청번호  --DROP TABLE  #TEMP_신규신청번호
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
WHERE       A.CLN_ACNO          IS NOT NULL
AND         A.CLN_APC_DSCD   BETWEEN  '01' AND '09'         -- 신규
AND         A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
GROUP BY    A.CLN_ACNO,A.LN_AGR_DT

UNION ALL

SELECT      A.ACN_DCMT_NO      AS 계좌번호
           ,A.AGR_DT           AS 약정일자
           ,MAX(A.CLN_APC_NO)  AS 신청번호
FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC      A    -- SOR_CLI_여신신청기본
WHERE       A.ACN_DCMT_NO IS NOT NULL
AND         A.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- 여신신청구분코드(01:신규,02:대환)
AND         A.NFFC_UNN_DSCD   = '1'     -- 중앙회
AND         A.APC_LDGR_STCD   = '10'    -- 신청원장상태코드(01:작성중,02:결재중,10:완료,99:취소)
AND         A.CLN_APC_CMPL_DSCD IN ('20','21') -- 여신신청완료구분코드 -- 09:부결, 10:승인 18:승인후미취급, 20:약정, 21:실행,17:철회
GROUP BY    A.ACN_DCMT_NO,A.AGR_DT
;

-- 여신신청번호 비어 있는것들 보충
UPDATE      #연체채권  A
SET         A.여신신청번호  =  B.신청번호
FROM        #TEMP_신규신청번호  B
WHERE       A.통합계좌번호   = B.계좌번호
AND         A.약정일자       = B.약정일자
AND         A.여신신청번호 IS NULL
;

-- CASE2 약정까지발생한 여신신청 + 승인까지만 이루어진 여신신청 + 승인도 이루어지지 은 여신신청 모두   -- 검증이 필요한 로직
SELECT      CLN_ACNO      AS   약정_여신계좌번호
           ,AGR_DT        AS   약정_약정일자
           ,AGR_TR_SNO    AS   약정_약정거래일련번호
           ,CLN_APC_DSCD  AS   약정_여신신청구분코드

           ,CLN_APRV_NO   AS   승인_여신승인번호
           ,ACN_DCMT_NO   AS   승인_계좌번호
           ,CLN_APC_NO    AS   승인_여신신청번호
           ,CLN_APC_DSCD  AS   승인_여신신청구분코드

           ,CASE WHEN LEFT(B.CLN_APC_NO,2) = 'A1' THEN C.CLN_APC_NO
                 WHEN LEFT(B.CLN_APC_NO,2) = 'A2' THEN D.CLN_APC_NO
                 ELSE NULL
            END           AS    신청_여신신청번호

           ,CASE WHEN LEFT(B.CLN_APC_NO,2) = 'A1' THEN C.CLN_APC_DSCD
                 WHEN LEFT(B.CLN_APC_NO,2) = 'A2' THEN D.CLN_APC_DSCD
                 ELSE NULL
            END           AS    신청_여신신청구분코드

INTO        #TEMP   -- DROP TABLE #TEMP

FROM        TB_SOR_LOA_AGR_HT    A   -- SOR_LOA_약정이력

JOIN        TB_SOR_CLI_CLN_APRV_BC  B   --SOR_CLI_여신승인기본
            ON  A.CLN_APRV_NO  =  B.CLN_APRV_NO

LEFT OUTER JOIN
            TB_SOR_PLI_CLN_APC_BC    C   -- SOR_PLI_여신신청기본
            ON  B.CLN_APC_NO        = C.CLN_APC_NO

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APC_BC     D   -- SOR_CLI_여신신청기본
            ON  B.CLN_APC_NO        = D.CLN_APC_NO
;


SELECT      NULL      AS   약정_여신계좌번호
           ,NULL      AS   약정_약정일자
           ,NULL      AS   약정_약정거래일련번호
           ,NULL      AS   약정_여신신청구분코드

           ,CLN_APRV_NO   AS   승인_여신승인번호
           ,ACN_DCMT_NO   AS   승인_계좌번호
           ,CLN_APC_NO    AS   승인_여신신청번호
           ,CLN_APC_DSCD  AS   승인_여신신청구분코드

           ,CASE WHEN LEFT(B.CLN_APC_NO,2) = 'A1' THEN C.CLN_APC_NO
                 WHEN LEFT(B.CLN_APC_NO,2) = 'A2' THEN D.CLN_APC_NO
                 ELSE NULL
            END           AS    신청_여신신청번호

           ,CASE WHEN LEFT(B.CLN_APC_NO,2) = 'A1' THEN C.CLN_APC_DSCD
                 WHEN LEFT(B.CLN_APC_NO,2) = 'A2' THEN D.CLN_APC_DSCD
                 ELSE NULL
            END           AS    신청_여신신청구분코드

FROM        TB_SOR_CLI_CLN_APRV_BC  B   --SOR_CLI_여신승인기본

LEFT OUTER JOIN
            TB_SOR_PLI_CLN_APC_BC    C   -- SOR_PLI_여신신청기본
            ON  B.CLN_APC_NO        = C.CLN_APC_NO

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APC_BC     D   -- SOR_CLI_여신신청기본
            ON  B.CLN_APC_NO        = D.CLN_APC_NO

WHERE       1=1
AND         승인_여신승인번호  NOT IN ( SELECT  승인_여신승인번호 FROM  #TEMP)
;

SELECT      NULL      AS   약정_여신계좌번호
           ,NULL      AS   약정_약정일자
           ,NULL      AS   약정_약정거래일련번호
           ,NULL      AS   약정_여신신청구분코드

           ,NULL      AS   승인_여신승인번호
           ,NULL      AS   승인_계좌번호
           ,NULL      AS   승인_여신신청번호
           ,NULL      AS   승인_여신신청구분코드

           ,C.CLN_APC_NO    AS    신청_여신신청번호
           ,C.CLN_APC_DSCD  AS    신청_여신신청구분코드
           ,C.CLN_ACNO      AS    신청_여신계좌번호

FROM        TB_SOR_PLI_CLN_APC_BC    C   -- SOR_PLI_여신신청기본
WHERE       1=1
AND         신청_여신신청번호  NOT IN ( SELECT  신청_여신신청번호 FROM  #TEMP)



UNION  ALL

SELECT      NULL      AS   약정_여신계좌번호
           ,NULL      AS   약정_약정일자
           ,NULL      AS   약정_약정거래일련번호
           ,NULL      AS   약정_여신신청구분코드

           ,NULL      AS   승인_여신승인번호
           ,NULL      AS   승인_계좌번호
           ,NULL      AS   승인_여신신청번호
           ,NULL      AS   승인_여신신청구분코드

           ,D.CLN_APC_NO       AS    신청_여신신청번호
           ,D.CLN_APC_DSCD     AS    신청_여신신청구분코드
           ,D.ACN_DCMT_NO      AS    신청_여신계좌번호

FROM        TB_SOR_CLI_CLN_APC_BC     D   -- SOR_CLI_여신신청기본
WHERE       1=1
AND         신청_여신신청번호  NOT IN ( SELECT  신청_여신신청번호 FROM  #TEMP)
;
//}


//{  #최초약정 #승인원장
FROM
            (          -- 대상계좌의 최초약정건 구하기
             SELECT  A.CLN_ACNO
                    ,B.CLN_APRV_NO
                    ,B.AGR_DT
                    ,B.TR_STCD
             FROM    TB_SOR_LOA_ACN_BC A
             INNER JOIN
                     TB_SOR_LOA_AGR_HT   B
                     ON         A.CLN_ACNO = B.CLN_ACNO
                     AND        B.CLN_TR_KDCD NOT IN ('130','131')  --채무인수 제외
                     AND        B.CLN_TR_KDCD IN ('100')            -- 여신신청구분코드 신규약정
                     AND        B.CLN_APRV_NO IS NOT NULL
                     AND        A.NFFC_UNN_DSCD = '1'
             INNER JOIN
                     (
                      SELECT    A.CLN_ACNO
                               ,MAX(A.AGR_TR_SNO) AS MAX_SNO
                      FROM      TB_SOR_LOA_AGR_HT A
                      WHERE     A.CLN_TR_KDCD NOT IN ('130','131')  --채무인수 제외
                      AND       A.CLN_TR_KDCD IN ('100')            -- 여신신청구분코드 신규약정
                      AND       A.CLN_APRV_NO IS NOT NULL
                      AND       A.ENR_DT <=   '20170831'
                      GROUP BY  A.CLN_ACNO
                     ) C
                     ON  B.CLN_ACNO   = C.CLN_ACNO
                     AND B.AGR_TR_SNO = C.MAX_SNO
              WHERE  1=1
              //=========================================================================
              AND    A.CLN_ACNO IN  (SELECT   DISTINCT 계좌번호  FROM #모집단_잔액 )
              //=========================================================================
            ) A

INNER JOIN              -- 최초약정건의 신청번호를 가져오기 위하여 승인원장을 읽는다
            TB_SOR_CLI_CLN_APRV_BC B --SELECT CLN_APC_DSCD, CLN_APRV_LDGR_STCD, CLN_APC_NO FROM TB_SOR_CLI_CLN_APRV_BC WHERE CLN_APRV_NO = 'P1201600179215'
            ON       A.CLN_APRV_NO = B.CLN_APRV_NO
            AND      B.CLN_APC_DSCD != '51'
            AND      B.CLN_APRV_LDGR_STCD IN ('20','21') --AND A.CLN_ACNO = '321006763199'

//}

//{ #신용도판단 #신용도판단정보통보
SELECT          A.CUST_NO
                   ,B.CRIN_ENR_RSCD     AS 신용정보등록사유코드      ,TRIM(C.코드명) AS 신용정보등록사유코드명
FROM           DWZOWN.TB_SOR_CUS_MAS_BC                   A
JOIN             TT_SOR_LOE_MM_CDJI_DPC_DL                  B   --  SOR_LOE_월신용도판단정보통보상세
                    ON  A.CUST_RNNO   =   B.RNNO
-- 개인사업자와 법인사업자는 은행연합회에서 개인사업자의 경우 사업자번호와 개인주민번호, 법인사업자의 경우
-- 법인번호와 사업자번호로 각각 이중으로 데이터가 들어오므로 개인실명번호와 사업자번호기준으로 만들어진 우리 고객원장과
-- 이런식으로 죠인을 하여 사용하는데 문제가 없다
                    AND B.STD_YM ='201403'
                    AND B.UNN_CD = '999'                -- 999:중앙회+조합, 998:조합  999만써야 중복안됨
                    AND (        B.RLS_ACP_DT  IS NULL
                             OR  B.RLS_ACP_DT = '00000000'
                        )  -- 해제접수일자
JOIN                (
                         SELECT   CMN_CD
                                 ,TRIM(CMN_CD_NM)    AS 코드명
                         FROM     OM_DWA_CMN_CD_BC
                         WHERE    TPCD_NO_EN_NM = 'CRIN_ENR_RSCD'  -- 신용정보등록사유코드
                         AND      CMN_CD_US_YN = 'Y'
                         ORDER BY CMN_CD
                    )    C
                    ON   B.CRIN_ENR_RSCD =  C.CMN_CD
//}

//{ #고객상태  #유효고객 #고객원장
FROM                DWZOWN.TB_SOR_CUS_MAS_BC                   A
WHERE               1=1
AND                 A.CUST_AVL_CD   = '1' -- 고객유효코드 1: 거래고객
                     -- 개인,법인,외국인은 그 실명으로 거래가 될수 있기때문에 거래고객이고
                     -- 개인사업자, 법인등록번호 , BIC코드등은 그 번호로 거래가 안되기때문에 거래고객이 아님
AND                 A.CUST_INF_STCD = '1' -- 고객정보상태코드 1: 정상, 2.오류실명, 3.해제
//}

//{ #약정이력  #최종약정
-- CASE 1   계좌별 최종연장약정건 추출
JOIN
            ( -- 최종 기한연장일자 추출
             SELECT   TA.CLN_ACNO
                     ,TA.ENR_DT      AS 약정일
                     ,TA_AGR_EXPI_DT AS 약정만기일
             FROM     DWZOWN.TB_SOR_LOA_AGR_HT       TA
                     ,(SELECT   CLN_ACNO
                               ,MAX(AGR_TR_SNO) AS AGR_TR_SNO    --약정거래일련번호(최종기한연장의 약정거래일련번호)
                       FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                       WHERE    CLN_APC_DSCD IN ('11','12','13') --여신신청구분코드(11:기한연장,12:기한연장및증액,13:기한연장및조건변경)
                       AND      TR_STCD       =  '1'             --거래상태코드(1:정상)
                       GROUP BY CLN_ACNO)            TB
             WHERE    TA.CLN_ACNO   = TB.CLN_ACNO
             AND      TA.AGR_TR_SNO = TB.AGR_TR_SNO
            )                                          B
            ON   A.CLN_ACNO  = B.CLN_ACNO

-- CASE 2  계좌별 신규약정건 가져오기, 신규약정시 만기일 가져오기
LEFT OUTER JOIN
            (
             SELECT      TA.CLN_ACNO
                        ,TA.AGR_DT
                        ,TA.AGR_EXPI_DT

             FROM        DWZOWN.TB_SOR_LOA_AGR_HT       TA
             JOIN        (
                           SELECT   CLN_ACNO
                                   ,AGR_DT
                                   ,MAX(AGR_TR_SNO) AS AGR_TR_SNO    --계좌번호별 약정일자별로 신규약정건은 1건이라야 맞지만 2건씩 나오는게 있음
                           FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                           WHERE    CLN_APC_DSCD IN ('01','02','04','07','08','09') --여신신청구분코드 <10 는 신규건
                           AND      TR_STCD       =  '1'             --거래상태코드(1:정상)
                           GROUP BY CLN_ACNO,AGR_DT
                         )            TB
                         ON    TA.CLN_ACNO   = TB.CLN_ACNO
                         AND   TA.AGR_TR_SNO = TB.AGR_TR_SNO
            )  B
            ON    A.INTG_ACNO   =  B.CLN_ACNO
            AND   A.AGR_DT      =  B.AGR_DT
//}

//{ #전입전출  #전출입 #전입 #전출

-- CASE 1 종통 이수관내역 뽑는법
-- 참고프로그램 : 양재동(20140715)_양재동지점이관채권명세.SQL
-- 종통은 전출과 전입이 별도의 레코드로 쌍으로 이루어져있음 한건으로 묶어 보기를 구현한 SQL
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
                  ,CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  AS 전출점
                  ,CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  AS 전입점
                  ,CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_DT ELSE B.ENR_DT END      AS 전출일자
                  ,CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_DT ELSE B.ENR_DT END      AS 전입일자
         FROM      TB_SOR_DEP_MVT_MVN_TR   A
         JOIN      TB_SOR_DEP_MVT_MVN_TR   B
                   ON  A.ACNO  =  B.ACNO
                   AND A.MVT_MVN_SNO + 1 = B.MVT_MVN_SNO
         WHERE     (  A.RLS_DT   IS NULL  OR  A.RLS_DT = ''  )
         AND       CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  = '0058'  -- 전출점 양재동지점
         AND       CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  = '0018'  -- 전입점 수도권여신관리센터
         AND       A.ENR_DT   BETWEEN  '20120630'  AND  '20140711'     -- 대상 전출일자
)        A

--  통합여신을 이용해서 뽑은경우와 일치함
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


-- CASE 2   최초계좌점을 전출입내역을 꺼꾸로 올라가서 찾는 방법
--  1. 일반여신
LEFT OUTER JOIN
            (
               SELECT   A.전출점번호
                       ,A.최종계좌번호
                       ,CASE WHEN A.전출계좌번호 IS NULL THEN A.최종계좌번호 ELSE A.전출계좌번호 END AS 전출계좌번호
                       ,A.전출일자
               FROM
               (
                    SELECT   MVT_BRNO   AS 전출점번호
                        ,MVN_BRNO   AS 전입점번호
                        ,MVT_DT     AS 전출일자
                        ,MVN_DT     AS 전입일자
                        ,CLN_ACNO   AS 여신계좌번호
                        ,CLN_EXE_NO AS 여신실행번호
                        ,LN_RMD     AS 대출잔액
                        ,MVT_ACNO   AS 전출계좌번호
                        ,MVN_ACNO   AS 전입계좌번호
                        ,CASE WHEN TRIM(LST_ACNO) IS NULL OR LST_ACNO = ''  THEN CLN_ACNO ELSE LST_ACNO END   AS 최종계좌번호
                        ,ROW_NUMBER() OVER(PARTITION BY CLN_ACNO ORDER BY MVT_DT ASC ,SNO  ASC) AS 순서
                    FROM     TB_SOR_LOA_MVN_MVT_HT
                    WHERE    1=1
                    AND      CASE WHEN TRIM(LST_ACNO) IS NULL OR LST_ACNO = ''  THEN CLN_ACNO ELSE LST_ACNO END IN ( SELECT  계좌번호 FROM #대상계좌_중복제거)
               )     A
               WHERE       1=1
               AND         A.순서 = 1
            )  B
            ON    A.계좌번호  = B.최종계좌번호

--  2. 종통
LEFT OUTER JOIN
            (
               SELECT     A.전출점번호
                         ,A.계좌번호 AS 최종계좌번호
                         ,A.계좌번호 AS 전출계좌번호  -- 차세대이전 전출입건에 대한 전출계좌는 구할수가 없어서 현재계좌로 사용함 2건
                         ,A.전출일자
               FROM
               (
                 SELECT    A.ACNO                AS 계좌번호
                          ,B.MVT_MVN_AMT         AS 전출입금액
                          ,A.ENR_BRNO            AS 전출점번호
                          ,B.ENR_BRNO            AS 전입점번호
                          ,A.ENR_DT              AS 전출일자
                          ,B.ENR_DT              AS 전입일자
                          ,ROW_NUMBER() OVER(PARTITION BY A.ACNO ORDER BY A.MVT_MVN_SNO ASC) AS 순서
                 FROM      TB_SOR_DEP_MVT_MVN_TR   A
                 JOIN      TB_SOR_DEP_MVT_MVN_TR   B
                           ON  A.ACNO  =  B.ACNO
                           AND A.MVT_MVN_SNO + 1 = B.MVT_MVN_SNO
                           AND B.MVT_MVN_DSCD = '3'       -- 전입
                           AND ( B.RLS_DT   IS NULL  OR  B.RLS_DT = ''  )
                 WHERE     ( A.RLS_DT   IS NULL  OR  A.RLS_DT = ''  )
                 AND       A.MVT_MVN_DSCD  = '1'  -- 전출
                 AND       A.ENR_BRNO  NOT IN ('0018','0805','0542','0090')   -- 전출점이 일반영업점
                 AND       A.ACNO    IN ( SELECT  계좌번호 FROM #대상계좌_중복제거)

               )   A
               WHERE  순서 = 1
            )   C
            ON    A.계좌번호  = C.최종계좌번호


-- CASE 3 업무별 이수관 전입전출 뽑는법

-- 1. 종통 전출입
SELECT      A.ACNO     AS   계좌번호
           ,CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  AS 전출점
           ,CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  AS 전입점
--           ,CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_DT ELSE B.ENR_DT END      AS 전출일자
           ,CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_DT ELSE B.ENR_DT END      AS 전입일자
FROM        TB_SOR_DEP_MVT_MVN_TR   A
JOIN        TB_SOR_DEP_MVT_MVN_TR   B
            ON  A.ACNO  =  B.ACNO
            AND A.MVT_MVN_SNO + 1 = B.MVT_MVN_SNO
WHERE       (  A.RLS_DT   IS NULL  OR  A.RLS_DT = ''  )
AND         CASE WHEN A.MVT_MVN_DSCD = '1' THEN A.ENR_BRNO ELSE B.ENR_BRNO END IN ('0610','0818')  -- 전출점 기업금융센터
--AND         CASE WHEN A.MVT_MVN_DSCD = '3' THEN A.ENR_BRNO ELSE B.ENR_BRNO END  = '0018'  -- 전입점 수도권여신관리센터
AND         A.ENR_DT   BETWEEN  '20150101'  AND  '20161130'     -- 대상 전출일자

관리센터 이관내역은 없음
select * from OT_DWA_DD_BR_BC
where   brno in ('0872','0070')  -- 0070 서울중앙지점, 0872 종로5가역지점
and std_dt = '20161220'


-- 2.일반여신 전출입
SELECT      CLN_ACNO    AS 계좌번호
           ,MVT_BRNO    AS 전출점
--           ,MVT_DT     AS 전출일자
           ,MVN_BRNO    AS 전입점
           ,MAX(MVN_DT) AS 전입일자
--           ,CLN_ACNO   AS 여신계좌번호
--           ,CLN_EXE_NO AS 여신실행번호
--           ,LN_RMD     AS 대출잔액
--           ,MVT_ACNO   AS 전출계좌번호
--           ,MVN_ACNO   AS 전입계좌번호
--           ,CASE WHEN TRIM(LST_ACNO) IS NULL OR LST_ACNO = ''  THEN CLN_ACNO ELSE LST_ACNO END   AS 최종계좌번호
--           ,ROW_NUMBER() OVER(PARTITION BY CLN_ACNO ORDER BY MVT_DT ASC ,SNO  ASC) AS 순서
INTO        #TEMP         -- DROP TABLE #TEMP
FROM        TB_SOR_LOA_MVN_MVT_HT
WHERE       1=1
AND         MVT_BRNO IN  ('0610','0818')
AND         MVN_DT   BETWEEN  '20150101'  AND  '20161130'
GROUP  BY   CLN_ACNO
           ,MVT_BRNO
           ,MVN_BRNO


-- 3. 신용카드

SELECT      A.CRD_MBR_NO    AS   카드회원번호
           ,A.MVT_APC_BRNO  AS   전출점
           ,A.MVN_PCS_BRNO  AS   전입점
           ,A.MVT_APC_DT    AS   전출일
           ,A.MVN_PCS_DT    AS   전입일

INTO        #TEMP            -- DROP TABLE #TEMP

FROM        DWZOWN.TB_SOR_MBR_ADM_BR_MVN_TR   A
WHERE       1=1
AND         A.MIMO_PGRS_STCD   = '2'            -- 전입전출진행상태코드 : '2'(전입등록)
AND         A.MVN_PCS_YN       = 'Y'            -- 전입처리여부
AND         A.MVN_PCS_DT      BETWEEN  '20150101'  AND  '20161130'     -- 대상 전출일자
AND         A.MVT_APC_BRNO  IN  ('0610','0818')

-- 4  KPS

SELECT      카드번호
           ,LEFT(수관등록일시, 8)
           ,이관점번호
           ,수관점번호
FROM        TB_CCCMKPS이수관내역
WHERE       이수관상태     = '4'
  AND       이수관단위구분 = '1'
  AND       이관점번호 IN  ('0610','0818')
  AND       수관등록일시  BETWEEN  '20150101'  AND  '20161130'

UNION ALL

SELECT      B.카드번호
           ,LEFT(A.수관등록일시, 8)
           ,A.이관점번호
           ,A.수관점번호
FROM        TB_CCCMKPS이수관내역     A
           ,TB_CCCMKPS이수관보정내역 B
WHERE       A.이수관등록일자 = B.이수관등록일자
AND         A.등록순번       = B.등록순번
AND         A.계약코드       = B.계약코드
AND         A.이수관상태     = '4'
AND         A.이수관단위구분 = '0'
AND         B.보정상태       = '2'
AND         A.이관점번호 IN  ('0610','0818')
AND         A.수관등록일시  BETWEEN  '20150101'  AND  '20161130'


--  5  GPC

SELECT      A.카드번호                       AS 카드번호
           ,LEFT(A.수관등록일시, 8)          AS 수관일자
           ,A.이관점번호                     AS 이관점번호
           ,A.수관점번호                     AS 수관점번호
FROM        TB_CCCMGPC이수관내역        A
WHERE       1=1
AND         A.이수관상태    = '4'
AND         A.이관점번호  IN  ('0610','0818')
AND         LEFT(A.수관등록일시, 8)  BETWEEN  '20150101'  AND  '20161130'


-- 6  외환
SELECT      REF_NO
           ,MVT_DT    전출일자
           ,MVT_BRNO  전출점번호
           ,MVN_DT    전입일자
           ,MVN_BRNO  전입점번호

FROM        TB_SOR_FEC_FRXC_REF_FLX_TR   A  -- SOR_FEC_외환REF변동내역
WHERE       1=1
AND         A.REF_FLX_DSCD =  '1'  -- REF변동구분코드(1:전입전출)
AND         A.MVT_BRNO  IN  ('0610','0818')
AND         A.MVN_DT  BETWEEN  '20150101'  AND  '20161130'
;


//}

//{ #주택담보 #신용대출 #가계자금대출
SELECT
......
           ,CASE WHEN A.STD_DT < '20120101'  THEN
                      CASE WHEN ((A.BS_ACSB_CD IN ('15005811','15006211','15006311','16006011','16006111','16010811') AND
                                  A.MRT_CD IN ('101','102','103','104','105','170','109','111')) OR
                                  A.BS_ACSB_CD = '14000611')
                                 THEN '1. 주택담보대출'
                           WHEN  (A.MRT_CD < '100' OR A.MRT_CD IN ('601','602')) THEN '2. 신용대출'
                           ELSE '3. 기타'
                      END
                 ELSE
                      CASE WHEN ((A.BS_ACSB_CD IN ('15005811','15006211','15006311','16006011','16006111','16010811') AND
                                  A.MRT_CD IN ('101','102','103','104','105','170','109','420','421','422','423','512','521')) OR
                                  A.BS_ACSB_CD = '14000611')
                           THEN '1. 주택담보대출'
                           WHEN  (A.MRT_CD < '100' OR A.MRT_CD IN ('601','602')) THEN '2. 신용대출'
                           ELSE '3. 기타'
                      END
                 END                               AS 가계담보구분
..........
FROM        OT_DWA_INTG_CLN_BC A

JOIN        (
              SELECT   STD_DT
                      ,ACSB_CD
                      ,ACSB_NM
                      ,ACSB_CD4  --원화대출금
                      ,ACSB_NM4
                      ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                      ,ACSB_NM5
              FROM     OT_DWA_DD_ACSB_TR
              WHERE    FSC_SNCD IN ('K','C')
--            AND      ACSB_CD4 = '13000801'                      --원화대출금
              AND      ACSB_CD5 IN ('14002501')     --가계자금대출금
           )           C
           ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS계정과목코드
           AND      A.STD_DT       =   C.STD_DT

//}

//{ #기업자금대출 #대기업 #중소기업 #개인사업자 #중견기업
SELECT
...........

           ,CASE WHEN C.ACSB_CD5 = '14002401' THEN --기업
             CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999'
                    AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014년부터 88도 기업으로 포함시킨다.
                  THEN CASE WHEN ISNULL(D.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.대기업'  ELSE '2.중소기업'  END
             ELSE '3.개인사업자'
             END
            END                               AS 기업구분
...........


FROM          OT_DWA_INTG_CLN_BC A
JOIN          (
                SELECT   STD_DT
                        ,ACSB_CD
                        ,ACSB_NM
                        ,ACSB_CD4  --원화대출금
                        ,ACSB_NM4
                        ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                        ,ACSB_NM5
                FROM     OT_DWA_DD_ACSB_TR
                WHERE    FSC_SNCD IN ('K','C')
--              AND      ACSB_CD4 = '13000801'        --원화대출금
                AND      ACSB_CD5 IN ('14002401')     --기업자금대출금
             )           C
             ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS계정과목코드
             AND      A.STD_DT       =   C.STD_DT

LEFT OUTER JOIN
             DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_기업규모기본
             ON     A.RNNO      = D.RNNO
             AND    A.STD_DT    = (  SELECT  MAX(STD_DT) FROM DWZOWN.OT_DWA_ENTP_SCL_BC WHERE STD_DT <= '20160301' )


--CASE2 중견기업요건
           ,CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999' AND
                      SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014년부터 88도 기업으로 포함시킨다.
                   THEN CASE WHEN   ISNULL(D.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.대기업'
                             WHEN   D1.BRN IS NOT NULL THEN '2.중견기업'
                             ELSE   '3.중소기업'
                        END
                 ELSE '4.개인사업자'
            END                          AS  기업구분


LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_기업규모기본
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

//{ #개인사업자  #산업분류코드  #법인대표자  #대표자

<UP_DWZ_여신_N0051_고객대출현황_자금별>
-- 가계자금대출금일때는 아래 임시테이블의 산업분류코드를 쓰지 않도록 해야한다
-- 개인의 산업분류코드는 '99999' 가 나와야 한다
SELECT      A.CUST_NO        AS 개인고객번호
           ,A.CUST_RNNO      AS 개인실명번호
           ,C.CUST_RNNO      AS 개인사업자실명번호
           ,A.PRV_BRN        AS 개인사업자등록번호
           ,B.CUST_NO        AS 사업자고객번호
           ,A.STDD_INDS_CLCD AS 개인산업분류코드
           ,C.STDD_INDS_CLCD AS 개인사업자산업분류코드
INTO        #TEMP_개인사업자산업분류코드
FROM        OM_DWA_INTG_CUST_BC  A  --DWA_통합고객기본
           ,TB_SOR_CUS_RLT_BC    B  --SOR_CUS_고객관계기본
           ,OM_DWA_INTG_CUST_BC  C
WHERE       B.CUST_INF_STCD = '1'   --정상
AND         B.CUST_RLT_DSCD = '03'  --개인사업자
AND         B.CUST_RLT_DTL_CD = '09' -- 고객관계상세코드(09:대표자)
AND         B.MNBD_BZPL_YN = 'Y'   --주체사업장여부
-- 하나의 고객이 여러사업장을 영위를 할때 그중 주된 사업장을 선택한다, 이거 y 걸지 않으면 하나의 고객에 개인사업자번호가 여러개 나온다
--    AND     B.MNBD_RPST_YN = 'Y'   --주체대표여부
-- 하나의 사업장에 여러명의 댚표가 존재할때 '대표자중 대표자'인것을 표시하기 위함, 이 조건은 걸지 않아도 개인고객번호별로 여러건 나오는 현상은 없다
-- 다만 Y 로 걸어놓으면 개인사업자의 산업분류코드를 가져오는 대상이 줄어든다.
-- 통합여신에는 이 조건이 안걸려있고 'UP_DWZ_여신_N0051_고객대출현황_자금별' 에는 조건이 걸려있어서 51번 프로시져의 결과와 통합여신의 결과가 서로 다르다.
AND         A.CUST_NO       = B.RLT_CUST_NO
AND         B.CUST_NO       = C.CUST_NO
;

--산업별분류코드를 가져올때 개인사업자때문에 여러단계를 거쳐야한다.
SELECT      CUST_NO
           ,STDD_INDS_CLCD
INTO        #TEMP_고객산업별분류코드
FROM        OM_DWA_INTG_CUST_BC
WHERE       CUST_NO  NOT IN (SELECT 개인고객번호   FROM #TEMP_개인사업자산업분류코드)

UNION ALL

SELECT      개인고객번호
           ,개인사업자산업분류코드
FROM        #TEMP_개인사업자산업분류코드

</UP_DWZ_여신_N0051_고객대출현황_자금별>


<여신사업부(20160520)_기업여신10억이상신규여신거래처명세>

-- 개인사업자 임시테이블
SELECT      A.CUST_NO        AS 개인고객번호
           ,A.CUST_RNNO      AS 개인실명번호
           ,A.CUST_NM        AS 개인성명
           ,C.CUST_NM        AS 개인사업자상호명
           ,C.CUST_RNNO      AS 개인사업자실명번호
           ,A.PRV_BRN        AS 개인사업자등록번호
           ,B.CUST_NO        AS 사업자고객번호
           ,A.MBTL_DSCD || A.MBTL_TONO || A.MBTL_SNO   AS 개인고객휴대전화
           ,C.BZPL_TL_ARCD  || C.BZPL_TL_TONO || C.BZPL_TL_SNO   AS 개인사업자사업장전화
INTO        #TEMP_개인사업자매핑    --DROP TABLE #TEMP_개인사업자매핑
FROM        OM_DWA_INTG_CUST_BC  A  --DWA_통합고객기본
           ,TB_SOR_CUS_RLT_BC    B  --SOR_CUS_고객관계기본
           ,OM_DWA_INTG_CUST_BC  C  --DWA_통합고객기본
WHERE       B.CUST_INF_STCD = '1'   --정상
AND         B.CUST_RLT_DSCD = '03'  --개인사업자
AND         B.CUST_RLT_DTL_CD = '09' -- 고객관계상세코드(09:대표자)
AND         B.MNBD_BZPL_YN = 'Y'   --주체사업장여부
-- 하나의 고객이 여러사업장을 영위를 할때 그중 주된 사업장을 선택한다, 이거 y 걸지 않으면 하나의 고객에 개인사업자번호가 여러개 나온다
--    AND     B.MNBD_RPST_YN = 'Y'   --주체대표여부
-- 하나의 사업장에 여러명의 댚표가 존재할때 '대표자중 대표자'인것을 표시하기 위함, 이 조건은 걸지 않아도 개인고객번호별로 여러건 나오는 현상은 없다
-- 다만 Y 로 걸어놓으면 개인사업자의 산업분류코드를 가져오는 대상이 줄어든다.
-- 통합여신에는 이 조건이 안걸려있고 'UP_DWZ_여신_N0051_고객대출현황_자금별' 에는 조건이 걸려있어서 51번 프로시져의 결과와 통합여신의 결과가 서로 다르다.
AND         A.CUST_NO       = B.RLT_CUST_NO
AND         B.CUST_NO       = C.CUST_NO
;

-- 법인대표자 임시테이블
SELECT      A.CUST_NO         AS 법인고객번호
           ,A.CUST_RNNO       AS 법인실명번호
           ,A.CUST_NM         AS 법인명

           ,C.CUST_NO         AS 법인대표자고객번호
           ,C.CUST_RNNO       AS 법인대표자실명번호
           ,C.CUST_NM         AS 법인대표자성명
           ,A.BZPL_TL_ARCD || A.BZPL_TL_TONO || A.BZPL_TL_SNO  AS 사업장전화번호
           ,D.MBTL_DSCD||D.MBTL_TONO||D.MBTL_SNO               AS 대표자휴대전화번호
INTO        #법인대표자매핑           --DROP TABLE #법인대표자매핑
FROM        OM_DWA_INTG_CUST_BC    A  --DWA_통합고객기본
           ,TB_SOR_CUS_RLT_BC      B  --SOR_CUS_고객관계기본
           ,OM_DWA_INTG_CUST_BC    C
           ,TB_SOR_CUS_ETC_TL_DL D
WHERE       B.CUST_INF_STCD = '1'   --정상
AND         B.CUST_RLT_DSCD = '02'  --법인사업자
AND         B.CUST_RLT_DTL_CD = '09' -- 대표자
AND         B.MNBD_RPST_YN = 'Y'   --주체대표여부
AND         A.CUST_NO       = B.CUST_NO
AND         B.RLT_CUST_NO   = C.CUST_NO
AND         B.RLT_CUST_NO  *= D.CUST_NO
AND         A.CUST_DSCD     = '02'            --고객구분코드:법인사업자
;

SELECT      A.개인고객번호          AS   고객번호
           ,A.개인사업자상호명      AS   업체명
           ,A.개인성명              AS   대표자명
           ,A.개인고객휴대전화      AS   휴대폰번호
           ,A.개인사업자사업장전화  AS   사무실전화

INTO        #고객임시  -- DROP TABLE #고객임시

FROM        #TEMP_개인사업자매핑  A

UNION ALL

SELECT      A.법인고객번호          AS   고객번호
           ,A.법인명                AS   업체명
           ,A.법인대표자성명        AS   대표자명
           ,A.대표자휴대전화번호    AS   휴대폰번호
           ,A.사업장전화번호        AS   사무실전화
FROM        #법인대표자매핑       A

UNION ALL

SELECT      A.CUST_NO               AS   고객번호
           ,A.CUST_NM               AS   업체명
           ,A.CUST_NM               AS   대표자명
           ,A.MBTL_DSCD || A.MBTL_TONO || A.MBTL_SNO             AS 휴대폰번호
           ,A.BZPL_TL_ARCD  || A.BZPL_TL_TONO || A.BZPL_TL_SNO   AS 사무실전화
FROM        OM_DWA_INTG_CUST_BC  A
WHERE       CUST_NO NOT IN ( SELECT  개인고객번호     FROM #TEMP_개인사업자매핑
                             UNION
                             SELECT  법인고객번호     FROM #법인대표자매핑
                            )
;
</여신사업부(20160520)_기업여신10억이상신규여신거래처명세>
//}

//{ #연소득
--CASE 1  UP_DWZ_여신_N0051_고객대출현황_자금별 에서 사용하는 방식
--최종신청건에 등록된 연소득 가져오는 로직
    SELECT   A.CLN_ACNO          AS 계좌번호
            ,B.CUST_NO           AS 고객번호      -- 한계좌에 여러사람의 소득이 등록되어 있을수 있어서 차주와 고객번호도 죠인해야함
            ,MAX(B.FRYR_ICM_AMT) AS 연소득금액
    INTO     #TEMP연소득
    FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC      A     --SOR_PLI_여신신청기본
            ,DWZOWN.TB_SOR_PLI_APC_POT_CUST_TR B     --SOR_PLI_신청시점고객내역
    WHERE    A.CLN_ACNO > ' '
      AND    A.CLN_APC_PGRS_STCD  ='04'       --여신신청진행상태코드(04:실행완료)
      AND    A.NFFC_UNN_DSCD      = '1'       --중앙회조합구분코드
      -------JOIN  A:B
      AND    A.CLN_APC_NO = B.CLN_APC_NO
      AND    B.FRYR_ICM_AMT > 0         -- 연소득이 들어오는 신청건만 대상으로
    GROUP BY A.CLN_ACNO
            ,B.CUST_NO
    ;


--CASE 2  신규신청건에 등록되어 있는 연소득 가져오기
SELECT   B.기준일자
        ,A.CLN_ACNO
        ,C.CUST_RNNO
        ,C.CUST_NO
        ,B.여신신청번호MAX
        ,ISNULL(F.FRYR_ICM_AMT , 0) * 1000 AS 신청_연소득
INTO     #TEMP_신청소득
--DROP TABLE #TEMP_신청소득
FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC       A --PLI_여신신청기본
       ,(SELECT   B.기준일자
                 ,A.CLN_ACNO        AS 여신계좌번호
                 ,MAX(A.CLN_APC_NO) AS 여신신청번호MAX
         FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A               --PLI_여신신청기본
                 ,#TEMP_기준일자               B
         WHERE    A.CLN_APC_PGRS_STCD  IN ('03','04','13')     --여신신청진행상태코드(03:결재완료, 04:실행완료,13:약정완료)
         AND      A.CLN_ACNO           > '0'                   --여신계좌번호
         AND      A.CLN_APC_DSCD       < '10'                  --여신신청구분코드:신규
         AND      A.NFFC_UNN_DSCD      = '1'                   --중앙회조합구분코드
         AND      A.APC_DT             <= B.기준일자
        GROUP BY B.기준일자, A.CLN_ACNO
         ) B
        ,DWZOWN.TB_SOR_CUS_MAS_BC           C --CUS_고객기본
        ,DWZOWN.TB_SOR_PLI_APC_POT_CUST_TR  F --SOR_PLI_신청시점고객내역

WHERE    A.CLN_ACNO      = B.여신계좌번호
AND      A.CLN_APC_NO    = B.여신신청번호MAX
---------JOIN A:C(CUS_고객기본)
AND      A.CUST_NO       = C.CUST_NO
AND      A.CLN_APC_NO   *= F.CLN_APC_NO
AND      A.CUST_NO       *= F.CUST_NO
;

--CASE 3  고객별 연소득 가져오기
-- CASE1, CASE2 는 계좌별이므로 동일고객의 연소득이 계좌별로 다르게 나올수 있다
-- 연소득이 천단위인데 단단위에 영업점에서 등록한 건도 있고 등록이 누락된건도 있고  데이터가 엉망이다
-- 데이터 정제로직도 포함한다

CREATE  TABLE  #TEMP_신청소득      --  DROP TABLE  #TEMP_신청소득
(
            기준일자             CHAR(8)
--           ,계좌번호             CHAR(12)
--           ,실명번호             CHAR(20)
           ,고객번호             NUMERIC(9)
           ,신청번호             CHAR(14)
           ,연소득               NUMERIC(18,2)
);
-- 기준일자별로 반복적으로 연소득조사해서 가져오기 위하여 기준일자만  바꿔가면서 반복해서 돌린다.
INSERT INTO #TEMP_신청소득
SELECT      B.기준일자
           ,A.CUST_NO
           ,A.CLN_APC_NO
           ,ISNULL(F.FRYR_ICM_AMT , 0) * 1000 AS 신청_연소득 -- 1000곱해서 원단위

FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC       A             --PLI_여신신청기본

JOIN
            (
            -------------------------------------------------------------------------------
             SELECT   '20121231'        AS 기준일자
             SELECT   '20131231'        AS 기준일자
             SELECT   '20141231'        AS 기준일자
             SELECT   '20150630'        AS 기준일자
             SELECT   '20151231'        AS 기준일자
             SELECT   '20160630'        AS 기준일자
            -------------------------------------------------------------------------------
                     ,A.CUST_NO         AS 고객번호
                     ,MAX(A.CLN_APC_NO) AS 여신신청번호MAX
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A               --PLI_여신신청기본
             JOIN     DWZOWN.TB_SOR_PLI_APC_POT_CUST_TR  B         --SOR_PLI_신청시점고객내역
                      ON   A.CLN_APC_NO  = B.CLN_APC_NO
                      AND  A.CUST_NO     = B.CUST_NO
             WHERE    A.CLN_APC_PGRS_STCD  IN ('03','04','13')     --여신신청진행상태코드(03:결재완료, 04:실행완료,13:약정완료)
             AND      A.CLN_ACNO           > '0'                   --여신계좌번호
             AND      A.CLN_APC_DSCD       < '10'                  --여신신청구분코드:신규
             AND      A.NFFC_UNN_DSCD      = '1'                   --중앙회조합구분코드
             -----------------------------------------------------------------------------
             AND      B.FRYR_ICM_AMT * 1000  >= 500000             -- 연소득 50만원미만 이나 10억이상으로 입력되어 있는 경우는
             AND      B.FRYR_ICM_AMT * 1000  <  1000000000         -- 잘못입력된 값으로 치부한다
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
            ON  A.CLN_APC_NO  =  B.여신신청번호MAX

JOIN        DWZOWN.TB_SOR_PLI_APC_POT_CUST_TR  F --SOR_PLI_신청시점고객내역
            ON      A.CLN_APC_NO  =  F.CLN_APC_NO
            AND     A.CUST_NO     =  F.CUST_NO
;
//}

//{ #RM번호 #성과관리
-- UP_DWZ_여신_N0051_고객대출현황_자금별

    --RM은 계좌별로 하나씩밖에 없다.
    SELECT   DISTINCT A.CLN_ACNO                            AS 여신계좌번호
            ,RIGHT('0000000000'+RIGHT(A.RM사용자번호,7),10) AS RM사용자번호 -- 사용자번호가 0001079117인 것도 있고 8071079117도 있음 : 0001079117로 7자리로 통일
            ,B.성명                                         AS RM명
    INTO     #TEMP_RM사용자번호              -- DROP TABLE #TEMP_RM사용자번호
    FROM     (SELECT DISTINCT A.CLN_ACNO, A.CLN_EXE_NO, B.RM사용자번호
              FROM   TB_SOR_LOA_HDL_PTCP_DL A,
                    (
                     SELECT DISTINCT A.CLN_ACNO, A.USR_NO AS RM사용자번호
                     FROM   TB_SOR_LOA_HDL_PTCP_DL A,
                            (
                             SELECT A.CLN_ACNO, MAX(A.CLN_EXE_NO)  AS CLN_EXE_NO_MAX
                             FROM   TB_SOR_LOA_HDL_PTCP_DL A, TB_SOR_LOA_ACN_BC B
                             WHERE  A.LN_HDL_PTCP_DSCD = '04'
                             AND    A.CLN_ACNO = B.CLN_ACNO
                             AND    B.INDV_LMT_LN_DSCD = '2' -- 한도대출
                             GROUP  BY A.CLN_ACNO
                            ) B

                    WHERE  A.LN_HDL_PTCP_DSCD = '04' ---AND CLN_ACNO = '322000045724'
                    AND A.CLN_ACNO = B.CLN_ACNO
                    AND A.CLN_EXE_NO = B.CLN_EXE_NO_MAX
                   ) B
              WHERE A.CLN_ACNO = B.CLN_ACNO) A
             ,TB_MDWT인사  B
    WHERE     RM사용자번호 *= B.사번
    AND       B.작성기준일 = P_기준일자

    UNION

    --한도대출외
    SELECT DISTINCT A.CLN_ACNO                      AS 여신계좌번호
          ,RIGHT('0000000000'+RIGHT(A.USR_NO,7),10) AS RM사용자번호 -- 사용자번호가 0001079117인 것도 있고 8071079117도 있음 : 0001079117로 7자리로 통일
          ,C.성명                                   AS RM명
    FROM   TB_SOR_LOA_HDL_PTCP_DL A
          ,(SELECT A.CLN_ACNO, MAX(A.CLN_EXE_NO)  AS CLN_EXE_NO_MAX
            FROM   TB_SOR_LOA_HDL_PTCP_DL A, TB_SOR_LOA_ACN_BC B
            WHERE  A.LN_HDL_PTCP_DSCD = '04'
            AND    A.CLN_ACNO = B.CLN_ACNO
            AND    B.INDV_LMT_LN_DSCD <> '2'
            GROUP  BY A.CLN_ACNO
           ) B
          ,TB_MDWT인사 C

    WHERE  A.LN_HDL_PTCP_DSCD = '04'
    AND    A.CLN_ACNO = B.CLN_ACNO
    AND    A.CLN_EXE_NO = B.CLN_EXE_NO_MAX
    AND    RM사용자번호 *= C.사번
    AND    C.작성기준일 = P_기준일자

...........
LEFT OUTER JOIN   (
                       -- 성과관리기준 및 'UP_DWZ_경영_N0055_RMC여수신실적현황'와 일치요건
                       -- SOR_LOA_취급관계자상세에 등록된 RM사용자중 최종실행건에 등록된 RM사용자를
                       -- 계좌대표 RM번호로 인식
                       SELECT DISTINCT A.CLN_ACNO                               AS 여신계좌번호
                                      ,RIGHT('0000000000'+RIGHT(A.USR_NO,7),10) AS RM사용자번호
                                      ,C.성명                                   AS RM명
                       FROM   TB_SOR_LOA_HDL_PTCP_DL A
                             ,(SELECT A.CLN_ACNO, MAX(A.CLN_EXE_NO)  AS CLN_EXE_NO_MAX
                               FROM   TB_SOR_LOA_HDL_PTCP_DL A, TB_SOR_LOA_ACN_BC B
                               WHERE  A.LN_HDL_PTCP_DSCD = '04'
                               AND    A.CLN_ACNO = B.CLN_ACNO
                               GROUP  BY A.CLN_ACNO
                              ) B
                             ,TB_MDWT인사 C

                       WHERE  A.LN_HDL_PTCP_DSCD = '04' ---AND CLN_ACNO = '322000045724'
                       AND    A.CLN_ACNO = B.CLN_ACNO
                       AND    A.CLN_EXE_NO = B.CLN_EXE_NO_MAX
                       AND    RM사용자번호 *= C.사번
                       AND    C.작성기준일 = P_기준일자
                   )      P
                   ON    A.INTG_ACNO  =  P.여신계좌번호
//}

//{ #순수신용  #신용담보만
-- 여신정책실(20140924)_신용대출이자율관련현황.SQL
SELECT   A.STD_DT       AS 기준일자
        ,A.INTG_ACNO    AS 계좌번호
        ,SUM(CASE WHEN NOT ( A.MRT_CD < '100' OR A.MRT_CD IN ('601','602'))   THEN  1  ELSE 0 END)  AS 신용외담보건수
        ,SUM(CASE WHEN ( A.MRT_CD < '100' OR A.MRT_CD IN ('601','602'))       THEN  1  ELSE 0 END)  AS 신용담보건수

FROM     DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL A   -- SOR_LCF_건전성계좌월별중앙회상세

JOIN     (                                   -- 기업자금대출금 및 가계자금대출금만 대상
          SELECT   STD_DT
                  ,ACSB_CD
                  ,ACSB_NM
                  ,ACSB_CD4  --원화대출금
                  ,ACSB_NM4
                  ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                  ,ACSB_NM5
          FROM     OT_DWA_DD_ACSB_TR
          WHERE    1=1
          AND      FSC_SNCD      IN ('K','C')
          AND      ACSB_CD5      IN ('14002401','14002501')  -- 기업자금대출금, 가계자금대출금
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
HAVING   신용담보건수 > 0   AND  신용외담보건수 = 0



-- CASE 2 신용담보대출( UP_DWZ_여신_N0093_담보별대출현황 와 동일기준)
-- 배분담보기준으로 601,602,603 담보가 있으면 신용담보라고 봄
-- 신용담보중 601이외에는 다른담보가 전혀 없는 계좌는 인보증으로 분류
SELECT      A.STD_DT       AS 기준일자
           ,A.INTG_ACNO    AS 계좌번호
           ,A.CRDT_EVL_MODL_DSCD AS 신용평가모형구분코드

           ,CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999'
                   AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014년부터 88도 기업으로 포함시킨다.
                 THEN CASE WHEN ISNULL(E.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.대기업'  ELSE '2.중소기업'  END
            ELSE '3.개인사업자'
            END                          AS  기업구분

           ,SUM(A.ACN_RMD )                                                 AS  대출잔액
           ,SUM(CASE WHEN D.MRT_TPCD = '6' THEN  A.ACN_RMD  ELSE NULL END)  AS  신용담보잔액

           ,SUM(CASE WHEN A.MRT_CD = '601' THEN A.ACN_RMD ELSE 0 END)       AS  인적보증
           ,SUM(CASE WHEN A.MRT_CD = '602' THEN A.ACN_RMD ELSE 0 END)       AS  순수신용보증
           ,SUM(CASE WHEN A.MRT_CD = '603' THEN A.ACN_RMD ELSE 0 END)       AS  신용보증

           ,MAX(CASE WHEN D.MRT_TPCD  = '6'  THEN '0' ELSE '1' END)         AS 담보여부
           ,CASE WHEN  담보여부 = '0' AND 순수신용보증 = 0 AND 신용보증 = 0  THEN 신용담보잔액 ELSE 0 END  AS 인보증대출잔액

INTO        #TEMP       -- DROP TABLE #TEMP

FROM        DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL A   -- SOR_LCF_건전성계좌월별중앙회상세

JOIN        (                                   -- 기업자금대출금 및 가계자금대출금만 대상
             SELECT   STD_DT
                     ,ACSB_CD
                     ,ACSB_NM
                     ,ACSB_CD4  --원화대출금
                     ,ACSB_NM4
                     ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                     ,ACSB_NM5
             FROM     OT_DWA_DD_ACSB_TR
             WHERE    1=1
             AND      FSC_SNCD      IN ('K','C')
             AND      ACSB_CD5      IN ('14002401') -- 기업자금대출금
            )          C
            ON    A.BS_ACSB_CD  =  C.ACSB_CD
            AND   A.STD_DT      =  C.STD_DT

LEFT OUTER JOIN
            TB_SOR_CLM_MRT_CD_BC    D   -- SOR_CLM_담보코드기본
            ON   A.MRT_CD      = D.MRT_CD

LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   E   --DWA_기업규모기본
            ON     A.RNNO      = E.RNNO
            AND    A.STD_DT    = E.STD_DT

WHERE       1=1
AND         A.STD_DT      IN  ( '20101231','20111231','20121231','20131231','20141231','20151231','20161231','20171031')
--AND         A.STD_DT      IN  ('20161231','20171031')
AND         A.CLN_ACN_STCD = '1'
AND         A.BR_DSCD      = '1'  --점구분코드(1:중앙회)
//---------------------------------------------------------
AND         기업구분  <>  '1.대기업'       -- 중소기업(개인사업자포함)
//---------------------------------------------------------
GROUP BY    A.STD_DT
           ,A.INTG_ACNO
           ,기업구분
           ,A.CRDT_EVL_MODL_DSCD
//---------------------------------------------------------
HAVING      신용담보잔액 > 0               -- 신용담보대출
//---------------------------------------------------------
;

//}

//{ #집단대출 #중도금대출 #이주비 #잔금대출
--201301월까지는 이주비도 집단대출로 보고 금감원에 보고 하였으나
--201302월부터는 이주비도 집단대출에서 제외하고 보고 하고 있음
--기 보고한 내용과 일관성 유지하여야 함
--잔금대출은 집단대출에서 처음부터 제외되어 왔음

    AND     (
--                (
--                   (A.LN_SBCD      =  '052' AND  A.LN_TXIM_CD  IN ('0002','0003')) OR                        --가계시장금리연동대출(기본,추가이주비대출)
--                   (A.LN_SBCD      =  '051' AND  A.LN_TXIM_CD   =  '1082' AND A.LN_USCD      =  '01') OR     --에센스대출(이주비-가계일반자금대출)-20110401추가
--                   (A.LN_SBCD      =  '056' AND  A.LN_TXIM_CD   =  '0006')                                   --가계주택자금대출(이주비(임차)대출)-20110401추가
--                )             OR                                                                             -- 이주비

                (
                   (A.LN_SBCD    IN ('201','203') AND  A.LN_TXIM_CD  =  '1054')    OR                          --공동주택중도금집단대출
                   (A.LN_SBCD    IN ('051','052','053') AND A.LN_TXIM_CD  =  '1053' AND A.LN_USCD = '04')  OR --집단주택자금대출(중도금납입자금)
                   (A.LN_SBCD     =  '056'  AND A.LN_TXIM_CD  =  '1053' AND A.LN_USCD     =  '03')    OR      --집단주택자금대출(중도금납입자금)
                   (A.LN_SBCD     =  '051'  AND A.LN_TXIM_CD  =  '1082' AND A.LN_USCD     =  '02')            --에센스대출 (중도금-가계일반자금대출)-20110401추가
                )             OR                                                                              -- 중도금

                (  A.BS_ACSB_CD  =  '14000611' AND
                       (
                       (A.LN_SBCD = '055' AND A.LN_TXIM_CD  =  '0008')            OR       --근로자주택자금대출(주신보연계중도금대출)
                       (A.LN_SBCD = '055' AND A.LN_TXIM_CD  =  '1017' AND A.LN_USCD     =  '04')
                   )                            AND                                        --주택신용보증서담보대출(중도금-근로자주택자금대출)
                   A.MRT_CD      =  '512'                                                                    -- 주택보증서대출_중도금
                )
--                                     OR
--
--                A.PDCD     IN ('20052105301011','20053105301011','20056105301011','20056105301021')          -- 잔금대출
            )

-- CASE 2
           ,CASE WHEN (A.LN_SBCD      =  '052' AND
                       A.LN_TXIM_CD  IN ('0002','0003')) OR         --가계시장금리연동대출(기본,추가이주비대출)
                      (A.LN_SBCD      =  '051' AND
                       A.LN_TXIM_CD   =  '1082' AND
                       A.LN_USCD      =  '01') OR                   --에센스대출(이주비-가계일반자금대출)-20110401추가
                      (A.LN_SBCD      =  '056' AND
                       A.LN_TXIM_CD   =  '0006')                    --가계주택자금대출(이주비(임차)대출)-20110401추가
                                                        THEN '이주비'
                 WHEN (A.LN_SBCD    IN ('201','203') AND
                       A.LN_TXIM_CD  =  '1054')            OR       --공동주택중도금집단대출
                      (A.LN_SBCD    IN ('051','052','053') AND
                       A.LN_TXIM_CD  =  '1053' AND
                       A.LN_USCD     =  '04')              OR       --집단주택자금대출(중도금납입자금)
                      (A.LN_SBCD     =  '056'  AND
                       A.LN_TXIM_CD  =  '1053' AND
                       A.LN_USCD     =  '03')              OR       --집단주택자금대출(중도금납입자금)
                      (A.LN_SBCD     =  '051'  AND
                       A.LN_TXIM_CD  =  '1082' AND
                       A.LN_USCD     =  '02')                       --에센스대출 (중도금-가계일반자금대출)-20110401추가
                                                        THEN '중도금'
                 WHEN  A.BS_ACSB_CD  =  '14000611' AND
                     ((A.LN_SBCD     =  '055'  AND
                       A.LN_TXIM_CD  =  '0008')            OR       --근로자주택자금대출(주신보연계중도금대출)
                      (A.LN_SBCD     =  '055'  AND
                       A.LN_TXIM_CD  =  '1017' AND
                       A.LN_USCD     =  '04')) AND                  --주택신용보증서담보대출(중도금-근로자주택자금대출)
                       A.MRT_CD      =  '512'
                                                        THEN '주택보증서대출_중도금'
            END       AS 주택담보대출종류명
            
-- CASE 3  2018년도중 DWA_일주택담보대출내역 에 새로 반영된 요건
           ,CASE WHEN AA.GRLN_ADM_NO IS NOT NULL AND  --집단대출관리번호
                      A.PDCD IN ('20056113701021','20056113701011','20056105303011','20055000800001','20055101704001','20051108202001')
                                                                     THEN '중도금' 
                 WHEN AA.GRLN_ADM_NO IS NOT NULL AND  --집단대출관리번호
                      A.PDCD IN ('20056000600001','20051108201001')  THEN '이주비'
                 WHEN AA.GRLN_ADM_NO IS NOT NULL AND  --집단대출관리번호
                      A.PDCD IN ('20056113702011','20056113702021','20056105301031','20056105301011',
                                  '20056116702011','20056116702021') THEN '잔금'
                 WHEN AA.GRLN_ADM_NO IS NOT NULL AND  --집단대출관리번호
                      A.PRD_BRND_CD = '1123'                         THEN '잔금'
                 ELSE 'X'
            END                                                    AS 집단대출여부

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A --DWA_통합여신기본

JOIN        DWZOWN.TB_SOR_LOA_ACN_BC    AA            --SOR_LOA_계좌기본
            ON     A.INTG_ACNO       = AA.CLN_ACNO


-- 집단대출
               ,CASE WHEN 주택담보대출종류명 IN ('중도금',
                                                 '이주비',
                                                 '잔금') THEN '집단'
                     ELSE '개별'
                END                                                    AS 주택담보대출형태명
                
               ,CASE WHEN 주택담보대출형태명 = '집단' THEN 'Y'
                     ELSE 'N'
                END                                                    AS 집단대출여부                                     
//}

//{ #수수료
      FROM                TB_SOR_FEE_FEE_TR         A
      JOIN                TB_SOR_FEE_FEE_BC         B
                          ON  A.FEE_CD   = B.FEE_CD
                          AND B.FEE_APL_STCD = '10'   -- 수수료적용상태코드 10:활동
                          AND DATEFORMAT(B.APL_END_DTTM,'YYYYMMDD') = '99991231'  -- 이거없으니깐 중복되는경우도 생김

//}

//{ #월계좌잔액 #통합여신 #매입외환 #내국수입유산스  #계좌잔액과통합여신죠인
FROM       DWZOWN.OT_DWA_MM_ACN_RMD_TZ        A          --  DWA_월계좌잔액집계
               ,DWZOWN.OM_DWA_INTG_CUST_BC         B          --  DWA_통합고객
               ,DWZOWN.TB_SOR_CMI_STDD_INDS_BC     BB         --  SOR_CMI_표준산업기본
               ,DWZOWN.OT_DWA_INTG_CLN_BC          C          --  DWA_통합여신

WHERE
..........
         (
             A.ACSB_CD     IN  ('13001508','14003208','15007518','15007618','15007718','15007818','14002218','14002318','14002418') -- 매입외환
        OR A.ACSB_CD     IN  ('13001308','14001818','14001918','14002018') -- 내국수입유산스
         )
        AND
        AND     C.STD_DT  = V_BASEDAY
        AND     A.INTG_ACNO       = C.INTG_ACNO
        AND     A.ACSB_CD         = C.BS_ACSB_CD
        AND     CASE WHEN A.ACSB_CD     IN  ('15007018','15007118')  THEN '61'
                     WHEN A.ACSB_CD     IN  ('13001508','14003208','15007518','15007618','15007718','15007818','14002318')  THEN '11' -- 수출환어음
                     WHEN A.ACSB_CD     IN  ('14002418')  THEN  '12'                              -- 기타매입외환 (외화수표)
                     WHEN A.ACSB_CD     IN  ('14002218')  THEN  '42'                              -- 내국신용장어음매입
                     ELSE A.FRXC_TSK_DSCD
                END               = C.FRXC_TSK_DSCD
        AND     A.ACN_SNO         = C.CLN_EXE_NO
        AND     A.STD_YM          = SUBSTRING(C.STD_DT,1,6)

//}

//{ #예적금담보  #당행예적금
--  여신정책실(20140819)_당타행질권설정현황.SQL
--  조합여신에서 중앙회 수신계좌를 담보로 취득하는 경우도 있으므로 중앙회/조합 모두의 담보설정내역을
--  가져와야 함
SELECT      B.CLN_APC_NO          AS 여신신청번호
           ,A.MRT_NO              AS 담보번호
           ,A.STUP_NO             AS 설정번호
           ,A.STUP_DT             AS 설정일자
           ,A.STUP_AMT            AS 설정금액
           ,B.ACN_DCMT_NO         AS 여신계좌번호
           ,B.CLN_TSK_DSCD        AS 여신업무구분코드
           ,C.PBLC_ISTT_BRDP_NM   AS 발행기관부점명
           ,C.OWNR_CUST_NO        AS 소유자고객번호
           ,C.DPS_ACNO            AS 수신계좌번호
           ,C.PDCD                AS 상품코드
           ,C.BND_RMD             AS 채권잔액
           ,C.NW_DT               AS 신규일자
           ,C.EXPI_DT             AS 만기일자
           ,C.CNTT_AMT            AS 계약금액
           ,C.MM_PYM_AMT          AS 월납입금액
           ,C.PYM_NOT             AS 납입횟수
           ,C.OD_ACNO             AS 구계좌번호
INTO        #당행예적금담보설정  -- DROP TABLE #당행예적금담보설정
FROM        TT_SOR_CLM_MM_STUP_BC        A   --SOR_CLM_월설정기본
JOIN        TT_SOR_CLM_MM_CLN_LNK_TR     B   --SOR_CLM_월여신연결내역
            ON    A.STUP_NO       = B.STUP_NO
            AND   B.STD_YM        = '201406'
            AND   B.CLN_LNK_STCD  IN ('02','03')   --여신연결상태코드(01:예정등록,02:정상,03:해지예정
                                                   --                 04:해지,05:취소)

JOIN        TT_SOR_CLM_MM_TBK_PRD_MRT_BC C   --SOR_CLM_월당행상품담보기본
            ON    A.MRT_NO        = C.MRT_NO
            AND   C.STD_YM        = '201406'
            AND   C.MRT_STCD      IN ('02')  -- 담보상태코드(01:예정등록,02:정상등록,
                                             -- 04:담보해지,05:등록취소,06:재감정진행중)

WHERE       1=1
-- AND         A.NFFC_UNN_DSCD  =  '1'          -- 중앙회조합구분 1: 중앙회
AND         A.STUP_STCD     IN ('02','03')   --설정상태코드(01:예정등록,02:정상,03:해지예정
                                             --             04:해지,05:취소)
AND         A.STD_YM = '201406'
;

//}

//{ #약정만기일  #장단기
                  ,CASE WHEN CONVERT(CHAR(8), DATEADD(YY, 1, D.AGR_DT), 112) >= D.AGR_EXPI_DT THEN '1.단기대출'
                        ELSE '2.장기대출'
                   END                            AS 장단기구분


--  시계열테이블(월계좌기본)과 죠인하여 약정만기일 가져오기
FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A       --DWA_통합여신기본

JOIN        (
                SELECT   STD_DT
                        ,ACSB_CD
                        ,ACSB_NM
                        ,ACSB_CD4  --원화대출금
                        ,ACSB_NM4
                        ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                        ,ACSB_NM5
                FROM     OT_DWA_DD_ACSB_TR
                WHERE    FSC_SNCD IN ('K','C')
                AND      ACSB_CD4 = '13000801'        --원화대출금
--                AND      ACSB_CD5 IN ('14002401')     --기업자금대출금
            )           C
            ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS계정과목코드
            AND      A.STD_DT       =   C.STD_DT

JOIN        DWZOWN.TT_SOR_LOA_MM_ACN_BC    AA            --SOR_LOA_월계좌기본
            ON     LEFT(A.STD_DT,6)  = AA.STD_YM
            AND    A.INTG_ACNO       = AA.CLN_ACNO

JOIN        DWZOWN.TB_SOR_LOA_ACN_BC    AA            --SOR_LOA_계좌기본
            ON     A.INTG_ACNO       = AA.CLN_ACNO
//}

//{ #건전성  #계좌건전성 #충당금 #건전성등급  #LAQ  #IFRS
-- IFRS건전성 데이터의 금액들은 원칙적으로 원화로 환산한 금액임, 외화금액은 '외화' 라는 말이 붙어 있음(예외 승인금액은 통화별금액임)

-- CASE5  IFRS버젼2
-- 기준일자에 따라 다른 건전성테이블 읽기
-- 재작업등으로 일별테이블 보다 월별테이블이 일단 가장 정확
-- 월별이 없으면 일별을 사용하고
-- 그래도 없으면 대상일자말일자의 월말데이터를 활용한다( CASE2 와 다른요건)

IF  EXISTS(SELECT TOP 1 기준일자 FROM DWZOWN.TB_DWF_LAQ_건전성계좌월별상세 WHERE 기준일자 = P_기준일자) THEN  -- 월별기준이면 월별원장에서

       -- 원장잔액은 계좌의 총잔액이고..계좌잔액은 담보배분된 잔액입니다
       -- 계좌잔액은 대출채권,미수이자,미사용,지급보증,가지급금배분금액의 합
       -- BS와 일치하는 값을 사용하려면 대출잔액배분금액..
        SELECT   A.통합계좌번호                                                              AS 계좌번호
                ,A.BS계정과목코드                                                            AS 계정코드
                ,A.여신실행번호                                                              AS 실행번호
                ,A.상품코드                                                                  AS 상품코드
                ,MAX(계좌건전성등급코드)                                                     AS 건전성등급
                ,SUM(A.지급보증약정배분금액  + A.대출잔액배분금액)                           AS 잔액
                ,MAX(A.승인금액)                                                             AS 승인금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '1' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 정상금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '2' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 요주의금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '3' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 고정금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '4' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 회수의문금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '5' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 추정손실금액
                ,SUM(A.지급보증충당금 + A.대출채권충당금)                                    AS 충당금
                ,'N'       AS 인터넷대출여부
        INTO     #TEMP_건전성계좌
        FROM     DWZOWN.TB_DWF_LAQ_건전성계좌월별상세  A
        WHERE    기준일자           = P_기준일자
          AND    장표종류코드       IN ('1','2','3','4','7')       -- 신용카드 제외
          AND    BS계정과목코드  NOT IN ('15009111','15009011')     -- 계정코드(카드대환론,카드론 제외)
          AND    SUBSTR(상품코드,5,4) <> '1019'                      -- 상품브랜드코드대신(1019:개인워크아웃대출)
          AND    LEFT(상품코드,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  서민금융상품 제외
        GROUP BY 계좌번호
                ,계정코드
                ,실행번호
                ,상품코드
        ;

ELSEIF EXISTS(SELECT TOP 1 기준일자 FROM DWZOWN.TB_DWF_LAQ_건전성계좌일별상세 WHERE 기준일자 = P_기준일자) THEN  -- 월말이 아니면 일별원장에서

       -- 원장잔액은 계좌의 총잔액이고..계좌잔액은 담보배분된 잔액입니다
       -- 계좌잔액은 대출채권,미수이자,미사용,지급보증,가지급금배분금액의 합
       -- BS와 일치하는 값을 사용하려면 대출잔액배분금액..

        SELECT   A.통합계좌번호                                                              AS 계좌번호
                ,A.BS계정과목코드                                                            AS 계정코드
                ,A.여신실행번호                                                              AS 실행번호
                ,A.상품코드                                                                  AS 상품코드
                ,MAX(계좌건전성등급코드)                                                     AS 건전성등급
                ,SUM(A.지급보증약정배분금액  + A.대출잔액배분금액)                           AS 잔액
                ,MAX(A.승인금액)                                                             AS 승인금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '1' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 정상금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '2' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 요주의금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '3' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 고정금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '4' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 회수의문금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '5' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 추정손실금액
                ,SUM(A.지급보증충당금 + A.대출채권충당금)                                    AS 충당금
                ,'N'       AS 인터넷대출여부
        INTO     #TEMP_건전성계좌
        FROM     DWZOWN.TB_DWF_LAQ_건전성계좌일별상세  A
        WHERE    기준일자           = P_기준일자
          AND    장표종류코드       IN ('1','2','3','4','7')       -- 신용카드 제외
          AND    BS계정과목코드  NOT IN ('15009111','15009011')     -- 계정코드(카드대환론,카드론 제외)
          AND    SUBSTR(상품코드,5,4) <> '1019'                      -- 상품브랜드코드대신(1019:개인워크아웃대출)
          AND    LEFT(상품코드,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  서민금융상품 제외
        GROUP BY 계좌번호
                ,계정코드
                ,실행번호
                ,상품코드
        ;

ELSE                                                   -- 월말이 아닌데 일별원장에도 없으면 해당월말걸 가지고 온다

       -- 원장잔액은 계좌의 총잔액이고..계좌잔액은 담보배분된 잔액입니다
       -- 계좌잔액은 대출채권,미수이자,미사용,지급보증,가지급금배분금액의 합
       -- BS와 일치하는 값을 사용하려면 대출잔액배분금액..

        SELECT   A.통합계좌번호                                                              AS 계좌번호
                ,A.BS계정과목코드                                                            AS 계정코드
                ,A.여신실행번호                                                              AS 실행번호
                ,A.상품코드                                                                  AS 상품코드
                ,MAX(계좌건전성등급코드)                                                     AS 건전성등급
                ,SUM(A.지급보증약정배분금액  + A.대출잔액배분금액)                           AS 잔액
                ,MAX(A.승인금액)                                                             AS 승인금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '1' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 정상금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '2' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 요주의금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '3' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 고정금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '4' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 회수의문금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '5' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 추정손실금액
                ,SUM(A.지급보증충당금 + A.대출채권충당금)                                    AS 충당금
                ,'N'       AS 인터넷대출여부
        INTO     #TEMP_건전성계좌
        FROM     DWZOWN.TB_DWF_LAQ_건전성계좌월별상세  A
        WHERE    SUBSTR(기준일자,1,6) = SUBSTR(P_기준일자,1,6)
          AND    RIGHT(기준일자,2) <>  '15'
          AND    장표종류코드       IN ('1','2','3','4','7')       -- 신용카드 제외
          AND    BS계정과목코드  NOT IN ('15009111','15009011')     -- 계정코드(카드대환론,카드론 제외)
          AND    SUBSTR(상품코드,5,4) <> '1019'                      -- 상품브랜드코드대신(1019:개인워크아웃대출)
          AND    LEFT(상품코드,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  서민금융상품 제외
        GROUP BY 계좌번호
                ,계정코드
                ,실행번호
                ,상품코드
        ;

END IF;


-- CASE 1: 계좌건전성등급, 충당금
LEFT OUTER JOIN
            (
             SELECT   STD_DT
                     ,INTG_ACNO
                     ,MAX(ACN_SDNS_GDCD)          AS   계좌건전성등급
                     ,SUM(APMN_NDS_RSVG_AMT)      AS   충당금요구적립금액
             FROM     DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL     -- (SOR_LCF_건전성계좌월별중앙회상세)
             WHERE    1=1
             AND      STD_DT  IN   ('20111231','20121231','20131231','20140630')
             GROUP BY STD_DT
                     ,INTG_ACNO
            )          D
            ON    A.STD_DT    =  D.STD_DT
            AND   A.INTG_ACNO =  D.INTG_ACNO
-- CASE 1: 계좌건전성등급, 충당금 (ifrs버젼)
BEGIN
  UPDATE       OT_DWA_DD_HSMR_LN_TR             T1
  SET          BDDB_APMN_AMT  =   T3.APMN_NDS_RSVG_AMT               -- 대손충당금금액
              ,SDNS_GDCD      =   T3.ACN_SDNS_GDCD                   -- 건전성등급코드
  FROM         ( -- 계좌별 충당금요구적립금액, 계좌건전성등급코드 추출
                SELECT   통합계좌번호                                       --통합계좌번호
                        ,SUM(충당금요구적립금액)     AS APMN_NDS_RSVG_AMT   --충당금요구적립금액
                        -- 충당금요구적립금액=(대출채권충당금+미수이자충당금+가지급금충당금+지급보증충당금+미사용약정충당금)
                        ,MAX(계좌건전성등급코드)     AS ACN_SDNS_GDCD       --계좌건전성등급코드
                FROM     DWZOWN.TB_DWF_LAQ_건전성계좌일별상세  -- DWF_LAQ_건전성계좌일별상세
                WHERE    기준일자        = '$$WORK_DATE'                                     --기준일자
                AND     (BS계정과목코드     IN ( -- 특정계정과목(14002501:가계자금대출금)하위계정 AND 14000611:주택자금대출금계정 추출
                                            SELECT   RLT_ACSB_CD                             --관계계정과목코드
                                            FROM     DWZOWN.OT_DWA_DD_ACSB_BC           --DWA_일계정과목기본
                                            WHERE    STD_DT        = '$$WORK_DATE'
                                            AND      ACSB_CD       = '14002501'              --계정과목코드
                                            AND      ACSB_HRC_INF  <> RLT_ACSB_HRC_INF       --계정과목계층정보 <> 관계계정과목계층정보
                                            AND      ACCT_STCD     = '1'                     --계정상태코드(0:확정전,1:정상,2:사용중지)
                                            AND      RLT_ACCT_STCD = '1'                     --관계계정상태코드(0:확정전,1:정상,2:사용중지)
                                           )
                         OR      BS계정과목코드      = '14000611')
                GROUP BY 통합계좌번호
               )                                                T3                      --SOR_LCF_건전성계좌일별중앙회상세
   WHERE       1=1
   AND         T1.ACNO    = T3.통합계좌번호
   AND         T1.STD_DT  = '$$WORK_DATE'
   ;
END

-- CASE 2 : 고정이하, 고객건전성등급 등.
LEFT OUTER JOIN
            (
              SELECT   A.STD_DT              AS 기준일자
                      ,A.INTG_ACNO           AS 통합계좌번호
                      ,MAX(A.CUST_SDNS_GDCD) AS 고객건전성등급코드
                      ,MAX(A.ACN_SDNS_GDCD)  AS 계좌건전성등급코드
                      ,SUM(CASE WHEN A.ACN_SDNS_GDCD  IN ('3','4','5')  THEN A.ACN_RMD  ELSE 0 END)   AS 고정이하잔액  --계좌건전성등급코드
                      ,SUM(A.PSVL_DC_DPM)    AS 현할차금액
              FROM     DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL A --SOR_LCF_건전성계좌월별중앙회상세
              WHERE    A.STD_DT    =  V_기준일자
              AND      A.CLN_ACN_STCD  = '1'    --활동
              AND      A.BR_DSCD       = '1'
              GROUP BY A.STD_DT,A.INTG_ACNO
            ) O
            ON     A.통합계좌번호   =   O.통합계좌번호
            AND    A.기준일자       =   O.기준일자

-- CSAE 3 : 건전성코드별로 잔액구하기.
LEFT OUTER JOIN          -- 건전성정보
            (
             SELECT       STD_DT
                         ,INTG_ACNO
                         ,SUM(CASE WHEN ACN_SDNS_GDCD =  '1'  THEN ACN_RMD  ELSE NULL END)  AS 정상
                         ,SUM(CASE WHEN ACN_SDNS_GDCD =  '2'  THEN ACN_RMD  ELSE NULL END)  AS 요주의
                         ,SUM(CASE WHEN ACN_SDNS_GDCD =  '3'  THEN ACN_RMD  ELSE NULL END)  AS 고정
                         ,SUM(CASE WHEN ACN_SDNS_GDCD =  '4'  THEN ACN_RMD  ELSE NULL END)  AS 회수의문
                         ,SUM(CASE WHEN ACN_SDNS_GDCD =  '5'  THEN ACN_RMD  ELSE NULL END)  AS 추정손실
                         ,SUM(ACN_RMD)   AS  합계
                         ,SUM(CASE WHEN A.ACN_SDNS_GDCD  IN ('3','4','5')  THEN A.ACN_RMD  ELSE 0 END)   AS 고정이하
                         ,SUM(APMN_NDS_RSVG_AMT)      AS   충당금

             FROM         DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL  A   -- (SOR_LCF_건전성계좌월별중앙회상세)
             WHERE        1=1
             AND          STD_DT  =  '20160630'
             AND          INTG_ACNO  IN ( SELECT DISTINCT 통합계좌번호 FROM #원화대출금_계좌별 )
             GROUP BY     STD_DT
                         ,INTG_ACNO
            )       B
            ON            A.통합계좌번호  = B.INTG_ACNO

-- CSAE 3 : 건전성코드별로 잔액구하기.(IFRS버젼)
       -- 원장잔액은 계좌의 총잔액이고..계좌잔액은 담보배분된 잔액입니다
       -- 계좌잔액은 대출채권,미수이자,미사용,지급보증,가지급금배분금액의 합
       -- BS와 일치하는 값을 사용하려면 대출잔액배분금액..
        SELECT   A.통합계좌번호                                                              AS 계좌번호
                ,A.BS계정과목코드                                                            AS 계정코드
                ,A.여신실행번호                                                              AS 실행번호
                ,A.상품코드                                                                  AS 상품코드
                ,MAX(계좌건전성등급코드)                                                     AS 건전성등급
                ,SUM(A.지급보증약정배분금액  + A.대출잔액배분금액)                           AS 잔액
                ,MAX(A.승인금액)                                                             AS 승인금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '1' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 정상금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '2' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 요주의금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '3' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 고정금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '4' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 회수의문금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '5' THEN A.지급보증약정배분금액  + A.대출잔액배분금액 ELSE 0 END)  AS 추정손실금액
                ,SUM(A.지급보증충당금 + A.대출채권충당금)                                    AS 충당금
        INTO     #TEMP_건전성계좌
        FROM     DWZOWN.TB_DWF_LAQ_건전성계좌월별상세  A
        WHERE    기준일자           = P_기준일자
          AND    장표종류코드       IN ('1','2','3','4','7')       -- 신용카드 제외
          AND    BS계정과목코드  NOT IN ('15009111','15009011')     -- 계정코드(카드대환론,카드론 제외)
          AND    SUBSTR(상품코드,5,4) <> '1019'                      -- 상품브랜드코드대신(1019:개인워크아웃대출)
          AND    LEFT(상품코드,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  서민금융상품 제외
        GROUP BY 계좌번호
                ,계정코드
                ,실행번호
                ,상품코드
        ;

-- CASE4
-- 기준일자에 따라 다른 건전성테이블 읽기
-- 재작업등으로 일별테이블 보다 월별테이블이 일단 가장 정확
-- 월별이 없으면 일별을 사용하고
-- 이때 오래전 데이터는 일별이 없으므로 해당월말에 해당하는 월말테이블을 읽는다

IF  EXISTS(SELECT TOP 1 STD_DT FROM DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL WHERE STD_DT = P_기준일자) THEN  -- 월별기준이면 월별원장에서

             SELECT       STD_DT
                         ,INTG_ACNO
                         ,MAX(ACN_SDNS_GDCD)          AS   계좌건전성등급
                         ,SUM(APMN_NDS_RSVG_AMT)      AS   충당금요구적립금액
             INTO         #건전성계좌중앙회상세
             FROM         DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL     -- (SOR_LCF_건전성계좌월별중앙회상세)
             WHERE        STD_DT = P_기준일자
             GROUP BY     STD_DT
                         ,INTG_ACNO
             ;

ELSEIF EXISTS(SELECT TOP 1 STD_DT FROM DWZOWN.TB_SOR_LCF_SDNS_ACN_DN_DL WHERE STD_DT = P_기준일자) THEN  -- 월말이 아니면 일별원장에서

             SELECT       STD_DT
                         ,INTG_ACNO
                         ,MAX(ACN_SDNS_GDCD)          AS   계좌건전성등급
                         ,SUM(APMN_NDS_RSVG_AMT)      AS   충당금요구적립금액
             INTO         #건전성계좌중앙회상세
             FROM         DWZOWN.TB_SOR_LCF_SDNS_ACN_DN_DL     -- (SOR_LCF_건전성계좌일별중앙회상세)
             WHERE        STD_DT  = P_기준일자
             GROUP BY     STD_DT
                         ,INTG_ACNO

             ;
ELSE                                                   -- 월말이 아닌데 일별원장에도 없으면 해당일자 월말일 기준으로
             SELECT       STD_DT
                         ,INTG_ACNO
                         ,MAX(ACN_SDNS_GDCD)          AS   계좌건전성등급
                         ,SUM(APMN_NDS_RSVG_AMT)      AS   충당금요구적립금액
             INTO         #건전성계좌중앙회상세
             FROM         DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL     -- (SOR_LCF_건전성계좌월별중앙회상세)
             WHERE        SUBSTR(STD_DT,1,6) = SUBSTR(P_기준일자,1,6)
             AND          RIGHT(STD_DT,2) <>  '15'
             GROUP BY     STD_DT
                         ,INTG_ACNO

             ;
END IF;


-- CASE5  IFRS버젼
-- 기준일자에 따라 다른 건전성테이블 읽기
-- 재작업등으로 일별테이블 보다 월별테이블이 일단 가장 정확
-- 월별이 없으면 일별을 사용하고
-- 그래도 없으면 일별중 가장 최근것을 읽어온다

IF  EXISTS(SELECT TOP 1 기준일자 FROM DWZOWN.TB_DWF_LAQ_건전성계좌월별상세 WHERE 기준일자 = P_기준일자) THEN  -- 월별기준이면 월별원장에서

        -- 원장잔액은 계좌의 총잔액이고..계좌잔액은 담보배분된 잔액입니다
       -- 계좌잔액은 대출채권,미수이자,미사용,지급보증,가지급금배분금액의 합
       -- BS와 일치하는 값을 사용하려면 대출잔액배분금액..
        SELECT   A.통합계좌번호                                                              AS 계좌번호
                ,A.BS계정과목코드                                                            AS 계정코드
                ,A.여신실행번호                                                              AS 실행번호
                ,MAX(CASE WHEN  원장잔액 >= 0  THEN  계좌건전성등급코드  END)                AS 건전성등급
                ,SUM(ISNULL(대출잔액배분금액,0))                                             AS 잔액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '1' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 정상금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '2' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 요주의금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '3' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 고정금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '4' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 회수의문금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '5' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 추정손실금액
                ,SUM(대출채권충당금)                                                     AS 충당금
        INTO     #TEMP_건전성계좌
        FROM     DWZOWN.TB_DWF_LAQ_건전성계좌월별상세  A
        WHERE    기준일자           = P_기준일자
          AND    장표종류코드       IN ('1','2','3','4','7')       -- 신용카드 제외
          AND    BS계정과목코드  NOT IN ('15009111','15009011')     -- 계정코드(카드대환론,카드론 제외)
          AND    SUBSTR(상품코드,5,4) <> '1019'                      -- 상품브랜드코드대신(1019:개인워크아웃대출)
          AND    LEFT(상품코드,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  서민금융상품 제외
        GROUP BY 계좌번호
                ,계정코드
                ,실행번호
        ;

ELSEIF EXISTS(SELECT TOP 1 기준일자 FROM DWZOWN.TB_DWF_LAQ_건전성계좌일별상세 WHERE 기준일자 = P_기준일자) THEN  -- 월말이 아니면 일별원장에서

       -- 원장잔액은 계좌의 총잔액이고..계좌잔액은 담보배분된 잔액입니다
       -- 계좌잔액은 대출채권,미수이자,미사용,지급보증,가지급금배분금액의 합
       -- BS와 일치하는 값을 사용하려면 대출잔액배분금액..
        SELECT   A.통합계좌번호                                                              AS 계좌번호
                ,A.BS계정과목코드                                                            AS 계정코드
                ,A.여신실행번호                                                              AS 실행번호
                ,MAX(CASE WHEN  원장잔액 >= 0  THEN  계좌건전성등급코드  END)                AS 건전성등급
                ,SUM(ISNULL(대출잔액배분금액,0))                                             AS 잔액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '1' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 정상금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '2' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 요주의금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '3' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 고정금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '4' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 회수의문금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '5' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 추정손실금액
                ,SUM(대출채권충당금)                                                     AS 충당금
        INTO     #TEMP_건전성계좌
        FROM     DWZOWN.TB_DWF_LAQ_건전성계좌일별상세  A -- DWF_LAQ_건전성계좌일별상세
        WHERE    기준일자           = P_기준일자
          AND    장표종류코드       IN ('1','2','3','4','7')       -- 신용카드 제외
          AND    BS계정과목코드  NOT IN ('15009111','15009011')     -- 계정코드(카드대환론,카드론 제외)
          AND    SUBSTR(상품코드,5,4) <> '1019'                      -- 상품브랜드코드대신(1019:개인워크아웃대출)
          AND    LEFT(상품코드,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  서민금융상품 제외
        GROUP BY 계좌번호
                ,계정코드
                ,실행번호
        ;
ELSE               -- 월말이 아닌데 일별원장에도 없으면 일별원장에서 가장최근 일자꺼 사용

       -- 원장잔액은 계좌의 총잔액이고..계좌잔액은 담보배분된 잔액입니다
       -- 계좌잔액은 대출채권,미수이자,미사용,지급보증,가지급금배분금액의 합
       -- BS와 일치하는 값을 사용하려면 대출잔액배분금액..
        SELECT   A.통합계좌번호                                                              AS 계좌번호
                ,A.BS계정과목코드                                                            AS 계정코드
                ,A.여신실행번호                                                              AS 실행번호
                ,MAX(CASE WHEN  원장잔액 >= 0  THEN  계좌건전성등급코드  END)                AS 건전성등급
                ,SUM(ISNULL(대출잔액배분금액,0))                                             AS 잔액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '1' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 정상금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '2' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 요주의금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '3' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 고정금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '4' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 회수의문금액
                ,SUM(CASE WHEN 계좌건전성등급코드 = '5' THEN ISNULL(대출잔액배분금액,0) ELSE 0 END)  AS 추정손실금액
                ,SUM(대출채권충당금)                                                     AS 충당금
        INTO     #TEMP_건전성계좌
        FROM     DWZOWN.TB_DWF_LAQ_건전성계좌일별상세  A -- DWF_LAQ_건전성계좌일별상세
        WHERE    기준일자           = ( SELECT MAX(기준일자) FROM DWZOWN.TB_DWF_LAQ_건전성계좌일별상세 WHERE 기준일자 <= P_기준일자 )
          AND    장표종류코드       IN ('1','2','3','4','7')       -- 신용카드 제외
          AND    BS계정과목코드  NOT IN ('15009111','15009011')     -- 계정코드(카드대환론,카드론 제외)
          AND    SUBSTR(상품코드,5,4) <> '1019'                      -- 상품브랜드코드대신(1019:개인워크아웃대출)
          AND    LEFT(상품코드,9) NOT IN ('200011085'
                                         ,'200041085'
                                         ,'200511085'
                                         ,'200511094'
                                         )                            --  서민금융상품 제외
        GROUP BY 계좌번호
                ,계정코드
                ,실행번호
        ;

END IF;


//}

//{ #현할차

-- 현할차금액 차감.

UPDATE      #원화대출금    A
SET         A.잔액 =  A.잔액 - ISNULL(O.현할차금액, 0)
FROM        (
              SELECT   A.기준일자
                      ,A.통합계좌번호
                      ,SUM(A.현재가치할인차금)    AS 현할차금액
              FROM     DWZOWN.TB_DWF_LAQ_건전성계좌월별상세 A
              WHERE    A.기준일자   IN ('20171231','20180331')
              AND      A.점구분코드       = '1'
              AND      A.통합계좌번호  IN ( SELECT 통합계좌번호 FROM  #원화대출금 )
              GROUP BY A.기준일자,A.통합계좌번호
            ) O
WHERE       A.통합계좌번호   =   O.통합계좌번호
AND         A.기준일자       =   O.기준일자
;

//}

//{ #CRS등급 #기업신용평가등급
-- 기업신용평가등급 10등급으로 분류
             -- 은행연합회 공시기준 기업평가등급 10등급체계
           ,CASE WHEN 기업신용평가등급  IN  ('1','01','1A','1B')  THEN  '01'
                 WHEN 기업신용평가등급  IN  ('2','02','2A','2B')  THEN  '02'
                 WHEN 기업신용평가등급  IN  ('3','03','3-','3+','3A','3B')  THEN  '03'
                 WHEN 기업신용평가등급  IN  ('4','04','4-','4+','4A','4B')  THEN  '04'
                 WHEN 기업신용평가등급  IN  ('5','05','5+','5-','5A')  THEN  '05'
                 WHEN 기업신용평가등급  IN  ('5B','6','06','6+','6-','6A','6B')  THEN  '06'
                 WHEN 기업신용평가등급  IN  ('7','07','7+','7-','7A','7B')  THEN  '07'
                 WHEN 기업신용평가등급  IN  ('8','08','8A','8B')  THEN  '08'
                 WHEN 기업신용평가등급  IN  ('9','09','9A','9B')  THEN  '09'
                 WHEN 기업신용평가등급  =    '10'                 THEN  '10'
                 WHEN 기업신용평가등급  IS NULL OR  기업신용평가등급 IN  ('0','11','')         THEN  '99'
                 ELSE 기업신용평가등급
            END                        AS  기업신용평가등급2
//}

//{ #연체이자
           -- 1. 일반여신 연체이자금액
              SELECT   A.CLN_ACNO
                      ,A.CLN_EXE_NO
                      ,A.TR_DT
                      ,SUM(B.LN_INT)      AS 연체이자금액
                      ,COUNT(CASE WHEN B.LN_INT > 0 THEN 1 ELSE NULL END)  AS 연체이자거래건수
              FROM     DWZOWN.TB_SOR_LOA_TR_TR       A
              JOIN     DWZOWN.TB_SOR_LOA_INT_CAL_DL  B
                       ON   A.CLN_ACNO    =  B.CLN_ACNO
                       AND  A.CLN_EXE_NO  =  B.CLN_EXE_NO
                       AND  A.CLN_TR_NO   =  B.CLN_TR_NO
                       AND  B.CLN_INT_CAL_TPCD IN ('13','14','15','16')  -- 이자계산유형코드
                                                                    -- 13:원금연체이자,14:분할상환금연체이자
                                                                    -- 15:할부금연체이자 16:이자연체이자
              WHERE    1=1
              AND      A.CLN_TR_KDCD   IN ('300','310')          --여신거래종류코드(300:대출상환,310:대출이자수입)
              AND      A.TR_STCD        = '1'                    --거래상태코드(1:정상)
              AND      A.TR_DT  BETWEEN   '20110101'  AND  '20140831'
              AND      A.CLN_ACNO IN  ( SELECT INTG_ACNO FROM #모집단1)
              GROUP BY A.CLN_ACNO,A.CLN_EXE_NO,A.TR_DT


              UNION ALL

            --2. 종통 연체이자금액
        -- 차세대 전환시 연체이자와 대출이자를 통으로 전환을 해서 구분이 안됨
        -- 고로 연체이자만 구하는것은 차세대 이후 데이터에서만 가능함
        -- 2011년도는 연체이자누락된다고 현업에 통보후 자료활용토록 함

              SELECT   A.ACNO
                      ,0
                      ,A.TR_DT
                      ,SUM(OVD_INT)         AS 연체이자금액
                      ,COUNT(CASE WHEN OVD_INT > 0 THEN 1 ELSE NULL END) AS  연체이자거래건수
              FROM     TB_SOR_DEP_TR_DL      A  --SOR_DEP_거래상세
              WHERE    1=1
              AND      TR_DT  BETWEEN   '20110101'  AND  '20140831'
              AND      A.ACNO  IN  ( SELECT INTG_ACNO FROM #모집단1)
              GROUP BY A.ACNO,A.TR_DT

//}

//{  #연체금리
-- 연체금리가 원장에 있는 금리와는 별개로 실업무에는 적용한 금리의 상한선이 있었다.
-- 원장대로 찍어주면 감사같은데서 문제가 될수있으므로 보정작업을 한다
           ,CASE WHEN A.OVD_IRT IS NOT NULL THEN
                 CASE WHEN A.STD_DT <= '20111231' AND  A.OVD_IRT > 21.00 THEN 21.00 -- 2011년이전
                      WHEN A.STD_DT >= '20120101' AND                               -- 2012 ~ 2014년
                           A.STD_DT <= '20141231' AND
                           A.OVD_IRT > 17.00                             THEN 17.00
                      WHEN A.STD_DT >= '20150101' AND  A.OVD_IRT > 15.00 THEN 15.00 -- 2015년이후
                      ELSE A.OVD_IRT
                 END
                 ELSE A.OVD_IRT
            END                  AS   연체금리
//}

//{ #ASS등급 #CSS등급 #신용등급

-- CASE 1 :   ASS등급 만들기
-- 통합여신의 ASS 등급은 아래 케이스에만 만들어지기 때문에 등급이 안나오는 계좌도 발생하게 된다
   WHERE    ((A.CLN_APC_PGRS_STCD = '04' AND A.CLN_APC_DSCD IN ('01','07','08','09', '02','04')) OR  --20120820
            (A.CLN_APC_PGRS_STCD = '13' AND A.CLN_APC_DSCD = '51'))  --채무인
-- 아래 로직으로 빈등급이 없도록 한다 ( UP_DWZ_여신_N0051_고객대출현황_자금별 프로시져 로직과 동일)

CREATE TABLE  #TEMP_ASS등급
(
  기준일자     CHAR(8),
  계좌번호     CHAR(12),
  여신신청번호 CHAR(14),
  고객번호     NUMERIC(9),
  주택보증보증구분코드  CHAR(2),
  ASS신용등급     CHAR(3)
);

BEGIN
DECLARE   P_기준일자  CHAR(8);

--SET       P_기준일자  = '20130630';
--SET       P_기준일자  = '20131231';
--SET       P_기준일자  = '20140630';
--SET       P_기준일자  = '20141231';
--SET       P_기준일자  = '20150630';
--SET       P_기준일자  = '20151231';
--SET       P_기준일자  = '20160630';
SET       P_기준일자  = '20161231';

DELETE   #TEMP_ASS등급  WHERE  기준일자  = P_기준일자;

INSERT INTO #TEMP_ASS등급
SELECT      P_기준일자
           ,TBB.CLN_ACNO
           ,TBB.CLN_APC_NO
           ,TBB.CUST_NO
           ,TBB.HSGR_GRN_DSCD
           ,TRIM(TBA.ASS_CRDT_GD) AS ASS_CRDT_GD
FROM        TB_SOR_PLI_SYS_JUD_RSLT_TR  TBA              --SOR_PLI_시스템심사결과내역
           ,(SELECT   TA.CLN_ACNO
                     ,TA.CLN_APC_NO
                     ,TB.CUST_NO
                     ,TB.HSGR_GRN_DSCD  --여기까지는 중복없음
             FROM    (SELECT   A.CLN_ACNO
                              ,MAX(B.CLN_APC_NO) AS CLN_APC_NO
                      FROM     TB_SOR_PLI_CLN_APC_BC       A   --SOR_PLI_여신신청기본
                              ,TB_SOR_PLI_SYS_JUD_RSLT_TR  B   --SOR_PLI_시스템심사결과내역
                      WHERE    A.CLN_APC_PGRS_STCD IN ( '03','04','13')  --여신신청진행상태코드(03:결재완료,04:실행완료,13:약정완료)
                      AND      A.NFFC_UNN_DSCD     = '1'       --중앙회조합구분코드
                      AND     (B.CSS_MODL_DSCD IS NULL OR B.CSS_MODL_DSCD IN ('31','32','34'))    --  CSS모형구분코드 30(CRS모형)제외 20120824 장상진
                      AND      A.CLN_APC_NO        = B.CLN_APC_NO
                      AND      A.CUST_NO           = B.CUST_NO  --20121017 : 추가
                      AND     (A.APC_DT    <= P_기준일자 OR A.CLN_APRV_DT <= P_기준일자)  --신청일자 OR 여신승인일자
                      AND      A.CLN_ACNO IN ( SELECT 통합계좌번호 FROM #가계자금  WHERE 기준일자  = P_기준일자)
                      GROUP BY A.CLN_ACNO
                      )                         TA
                     ,TB_SOR_PLI_CLN_APC_BC     TB   --SOR_PLI_여신신청기본
             WHERE    1=1
             AND      TA.CLN_APC_NO         = TB.CLN_APC_NO
             AND      TB.CLN_APC_PGRS_STCD IN ( '03','04','13')
             AND      TB.NFFC_UNN_DSCD      = '1'       --중앙회조합구분코드
            )   TBB
WHERE       TBA.CLN_APC_NO        = TBB.CLN_APC_NO
AND         TBA.CUST_NO           = TBB.CUST_NO;
;
END

-- 기준일자별로 데이터 확인
SELECT 기준일자,COUNT(*) FROM #TEMP_ASS등급
GROUP BY 기준일자
ORDER BY 1

-- 계좌중복여부 확인
SELECT   기준일자,계좌번호,COUNT(*) FROM  #TEMP_ASS등급
GROUP BY 기준일자,계좌번호
HAVING COUNT(*) > 1


-- CASE 2 ASS등급을 10등급 체계로 만들기
           ,CASE WHEN E.ASS신용등급  IN  ('1','01','1A','1B')  THEN  '01'
                 WHEN E.ASS신용등급  IN  ('2','02','2A','2B')  THEN  '02'
                 WHEN E.ASS신용등급  IN  ('3','03','3A','3B')  THEN  '03'
                 WHEN E.ASS신용등급  IN  ('4','04','4A','4B')  THEN  '04'
                 WHEN E.ASS신용등급  IN  ('5','05','5A','5B')  THEN  '05'
                 WHEN E.ASS신용등급  IN  ('6','06','6A','6B')  THEN  '06'
                 WHEN E.ASS신용등급  IN  ('7','07','7A','7B')  THEN  '07'
                 WHEN E.ASS신용등급  IN  ('8','08','8A','8B')  THEN  '08'
                 WHEN E.ASS신용등급  IN  ('9','09','9A','9B')  THEN  '09'
                 WHEN E.ASS신용등급  =    '10'                 THEN  '10'
                 WHEN E.ASS신용등급  IS NULL OR  E.ASS신용등급 IN  ('0','11','')         THEN  '99'
                 ELSE ASS신용등급
            END                        AS  ASS신용등급2


-- 2.  기준시점이 다른 여러계좌의 각 시점별  crs등급(소호모형까지 포함)구하기, 통합여신은 soho모형은 포함하지 않는다
SELECT      B.CLN_ACNO
           ,A.CLN_APC_NO
           ,B.CUST_NO
           ,B.APC_DT
           ,A.ASS_CRDT_GD
           ,ROW_NUMBER() OVER (PARTITION BY A.NFFC_UNN_DSCD,B.CLN_ACNO,B.CUST_NO ORDER BY B.APC_DT ASC) AS SEQ
INTO        #ASS평가히스토리  -- DROP TABLE   #ASS평가히스토리
FROM        DWZOWN.TB_SOR_PLI_SYS_JUD_RSLT_TR  A      --SOR_PLI_시스템심사결과내역
JOIN        DWZOWN.TB_SOR_PLI_CLN_APC_BC    B
            ON     A.CLN_APC_NO   = B.CLN_APC_NO
            AND    A.CUST_NO      = B.CUST_NO
WHERE      (
              (B.CLN_APC_PGRS_STCD = '04' AND B.CLN_APC_DSCD IN ('01','07','08','09', '02','04')) OR  --20120820
              (B.CLN_APC_PGRS_STCD = '13' AND B.CLN_APC_DSCD = '51')  -- 채무인수
            )  --채무인수
;


SELECT      A.*
INTO        #ASS평가정보  -- DROP TABLE #ASS평가정보
FROM        (
             SELECT      A.CLN_ACNO
                        ,A.CUST_NO
                        ,A.SEQ
                        ,A.APC_DT                                      AS 평가적용시작일
                        ,A.ASS_CRDT_GD
                        ,CASE WHEN B.APC_DT IS NULL THEN '99999999'
                              ELSE DATEFORMAT(DATE(B.APC_DT)-1,'YYYYMMDD')
                         END                                           AS 평가적용종료일
                        ,A.CRDT_EVL_NO
--             INTO      #평가히스토리_구간  -- DROP TABLE #평가히스토리_구간
             FROM        #ASS평가히스토리   A
             LEFT OUTER JOIN
                         #ASS평가히스토리   B
                         ON   A.CUST_NO  = B.CUST_NO
                         AND  A.CLN_ACNO = B.CLN_ACNO
                         AND  A.SEQ + 1  = B.SEQ
            )      A
;



//}

//{ #BSS등급 #신용등급  #대출고객통합평점등급 #통합평점

--CASE 2 :  BSS등급 만들기
--통합여신의 BSS등급은 전월자기준이라 당월에 신규한 계좌들은 BSS등급이 안나온다.
--아래 로직으로 BSS등급을 조사해 온다

CREATE TABLE  #TEMP_BSS등급 -- DROP TABLE #TEMP_BSS등급
(
  기준일자     CHAR(8),
--  실명번호     CHAR(20),
  계좌번호     CHAR(12),
  결합등급     CHAR(3)
);

BEGIN
DECLARE   P_기준일자  CHAR(8);

--SET       P_기준일자  = '20130630';
--SET       P_기준일자  = '20131231';
--SET       P_기준일자  = '20140630';
--SET       P_기준일자  = '20141231';
--SET       P_기준일자  = '20150630';
--SET       P_기준일자  = '20151231';
--SET       P_기준일자  = '20160630';
SET       P_기준일자  = '20161231';

DELETE   #TEMP_BSS등급  WHERE  기준일자  = P_기준일자;

INSERT INTO #TEMP_BSS등급
SELECT      P_기준일자                         --기준일자
           ,TA.ACNO                            --계좌번호
           ,MAX(TB.CMBN_GD)   AS CMBN_GD       --결합등급
FROM       (--실명번호, 계좌번호별임
            SELECT   A.ACNO                      --계좌번호
                    ,MAX(A.STD_YM)  AS STD_YM    --BS산출일(기준년월)
            FROM     DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  A  --DWF_CSS_올인원BSS결과기본
            WHERE    1=1
            --AND      A.STD_YM >= DATEFORMAT(DATEADD(MM,-13,P_기준일자), 'YYYYMMDD')  --작업기준일자 이전 최근 1년 월말
            AND      A.STD_YM <= LEFT(P_기준일자,6)
            //---------------------------------------------------------------------------------------------------
            AND      A.ACNO IN ( SELECT 통합계좌번호 FROM #가계자금  WHERE 기준일자  = P_기준일자)
            //---------------------------------------------------------------------------------------------------
            GROUP BY A.ACNO
            )                                  TA
           ,DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  TB  --DWF_CSS_올인원BSS결과기본
WHERE       TA.ACNO        = TB.ACNO
AND         TA.RNNO        = TB.RNNO
AND         TA.STD_YM      = TB.STD_YM
GROUP BY    TA.ACNO;

END;

-- 기준일자별로 데이터 확인
SELECT 기준일자,COUNT(*) FROM #TEMP_BSS등급
GROUP BY 기준일자
ORDER BY 1

-- 계좌중복여부 확인
SELECT   기준일자,계좌번호,COUNT(*) FROM  #TEMP_BSS등급
GROUP BY 기준일자,계좌번호
HAVING COUNT(*) > 1


-- CASE 2
UPDATE      #TEMP_가계대출  A
SET         A.BSS신용등급          = B.BSS_CRDT_GD         --BSS신용등급
           ,A.대출고객통합평점등급 = B.CMBN_GD             --대출고객통합평점등급
FROM        (
            --20120924 : 20120925일부터 적용(기준일자 20120924부터 적용) :
            --DWF_CSS_올인원BSS결과기본 : 매달 활동계좌에 대한 등급산출.
            --중앙회계좌별 : TB_DWF_CSS_AIO_BSS_RSLT_BC(DWF_CSS_올인원BSS결과기본)
            --'20120924' 이후 중앙회 데이터만
            -- JOIN 조건   변경 : 실명번호, 계좌번호  => 고객번호, 계좌번호
            -- 20171130 테이블변경에 따른 수정 (DWF_CSS_올인원BSS결과기본 => SOR_CSS_소매모형BSS결과기본)
            -- SOR_CSS_소매모형BSS결과기본 에는 201710 데이터 부터 들어가 있다
            SELECT   TA.STD_YM                          --BS산출일(기준년월)
                    ,TA.CUST_NO                         --고객번호
                    ,TA.ACNO                            --계좌번호
                    ,TB.APC_ASSC_GD  AS BSS_CRDT_GD     --BSS등급(신청평점등급을 BSS등급으로 사용)
                    ,TB.CMBN_GD                         --결합등급
            FROM     (--실명번호, 계좌번호별임
                      SELECT   A.CUST_NO                   --고객번호
                              ,A.ACNO                      --계좌번호
                              ,MAX(A.STD_YM)  AS STD_YM    --BS산출일(기준년월)
                      FROM     DWZOWN.TB_SOR_CSS_RM_BSS_RSLT_BC  A  -- SOR_CSS_소매모형BSS결과기본
          --          FROM     DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  A  --DWF_CSS_올인원BSS결과기본
                      WHERE    A.STD_YM BETWEEN '201701'  AND '201801'  -- 기준일자로 부터 최근 1년치 다 뒤진다.
                      GROUP BY A.CUST_NO
                              ,A.ACNO
                     )                                  TA
                    ,DWZOWN.TB_SOR_CSS_RM_BSS_RSLT_BC  TB  -- SOR_CSS_소매모형BSS결과기본
          --        ,DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  TB  --DWF_CSS_올인원BSS결과기본
            WHERE    TA.ACNO        = TB.ACNO
            AND      TA.CUST_NO     = TB.CUST_NO
            AND      TA.STD_YM      = TB.STD_YM
            ) B
WHERE       A.기준일자        = '201712'
AND         A.통합계좌번호    = B.ACNO        --계좌번호
AND         A.고객번호        = B.CUST_NO     --고객번호
;

-- 위 UPDATE문장을 수행해도 빈값이 많이 있어서 구테이블을 이용하여 보충한다.
UPDATE      #TEMP_가계대출  A
SET         A.BSS신용등급          = B.BSCORE_GRD     --BSS신용등급
           ,A.대출고객통합평점등급 = B.COMBSCORE_GRD  --대출고객통합평점등급
FROM        (
              --20120924 : 20120925일부터 적용(기준일자 20120924부터 적용)
              --중앙회계좌별 : TB_DWF_CSS_AIO_BSS_RSLT_BC(DWF_CSS_올인원BSS결과기본)
              --'20120924' 이후 중앙회 데이터만  TB_DWF_CSS_AIO_BSS_RSLT_BC(DWF_CSS_올인원BSS결과기본) 를 이용하여 등급을 구한다.
              --DWF_CSS_올인원BSS결과기본 : 매달 활동계좌에 대한 등급산출.
              SELECT      TA.STD_YM                          --BS산출일(기준년월)
                         ,TA.CUST_NO                         --고객번호
                         ,TA.ACNO                            --계좌번호
                         ,TB.APC_ASSC_GD  AS BSCORE_GRD      --BSS등급(신청평점등급을 BSS등급으로 사용)
                         ,TB.CMBN_GD      AS COMBSCORE_GRD   --결합등급
              FROM        (
                           --실명번호, 계좌번호별임
                           SELECT   A.CUST_NO                   --고객번호
                                   ,A.ACNO                      --계좌번호
                                   ,MAX(A.STD_YM)  AS STD_YM    --BS산출일(기준년월)
                           FROM     DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  A  --DWF_CSS_올인원BSS결과기본
                           WHERE    A.STD_YM BETWEEN '201701'  AND '201801'  --작업기준일자 이전 최근 1년 월말
                           GROUP BY A.CUST_NO
                                   ,A.ACNO
                          )                                  TA
                         ,DWZOWN.TB_DWF_CSS_AIO_BSS_RSLT_BC  TB  --DWF_CSS_올인원BSS결과기본
              WHERE       TA.ACNO        = TB.ACNO
              AND         TA.CUST_NO     = TB.CUST_NO
              AND         TA.STD_YM      = TB.STD_YM
            )  B
WHERE       A.기준일자        = '201712'
AND         A.통합계좌번호    = B.ACNO        --계좌번호
AND         A.고객번호        = B.CUST_NO     --고객번호
AND         ( A.BSS신용등급 IS NULL OR A.대출고객통합평점등급 IS NULL )


//}

//{ #상환내역  #상환
LEFT OUTER JOIN
            (
             SELECT       CLN_ACNO
                         ,CLN_EXE_NO
                         ,LEFT(TR_DT,4)  AS 상환년도
                         ,SUM(TR_PCPL)   AS 상환금액
             FROM         DWZOWN.TB_SOR_LOA_TR_TR     A       --  LOA_거래내역
             WHERE        A.TR_DT   >= '20090101'
             AND          A.TR_STCD    = '1'           --거래상태코드:1(정상)
             AND          A.TR_PCPL > 0                --거래원금
             AND          A.CLN_TR_KDCD ='300'         --여신거래종류코드:300(대출상환)
--           AND          A.TR_AF_RMD = 0              --완제된계좌만
             GROUP BY     CLN_ACNO,CLN_EXE_NO,상환년도
            )     J

//}

//{  #신규여신   #원화대출금

-- 1. 원화대출금, 실행신규
SELECT      A.STD_DT                               AS 기준일자
           ,A.BRNO                                 AS 점번호
           ,J.BR_NM                                AS 점명

           ,CASE WHEN A.FRPP_KDCD   IN ('2')  AND  A.PRD_BRND_CD =  '5025' AND A.LN_SBCD IN ('369','370')  THEN '1. 온렌딩'
--                 WHEN A.FRPP_KDCD   IN ('2')  AND  A.PDCD  IN  ( '20387500100001','20387500200001')        THEN '5. 연안선박'
                 WHEN A.FRPP_KDCD   IN ('2')                                                               THEN '3. 정책'

                 WHEN (A.BS_ACSB_CD IN ('17005211',                        --기타금융시설자금대출
                                        '17002811')) THEN                  --기타금융운전자금대출
                       CASE WHEN A.PRD_BRND_CD IN ('1085',                 --사랑해대출
                                                   '1026',                 --서울시경영안정자금대출
                                                   '1029',                 --정부지방자치단체협약대출
                                                   '1116',                 --중소기업진흥공단대출
                                                   '1132',                 --경기도지자체중소기업육성자금대출
                                                   '1140',                 --소상공인지원자금대출
                                                   '1150',                 --소상공인전환대출
                                                   '1028',                 --추가 2016.08.18
                                                   '1155') THEN '3. 정책'     --추가 2016.08.18
                            ELSE                                '2. 수산일반'
                       END
                 WHEN A.BS_ACSB_CD  IN ('17010111','17010211')  THEN  '2. 수산일반'   --수산해양일반시설자금대출, 수산해양일반운전자금대출 추가
                 WHEN A.LN_MKTG_DSCD IS NOT NULL  AND  A.LN_MKTG_DSCD > '0'                                THEN '4. 해투부'
                 ELSE '1. 일반'
            END   AS    대출금구분


           ,CASE WHEN LEFT(CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN FST_LN_DT ELSE AGR_DT END,6) = LEFT(A.STD_DT,6)
                   THEN  1
                   ELSE  0
            END                                 AS 당월신규여부

           ,CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN LN_EXE_AMT ELSE AGR_AMT END  AS 신규대상금액

           ,CASE WHEN  대출금구분 = '3. 정책' THEN  'D.정책'
                 ELSE  CASE WHEN K.ACSB_CD5   =   '14002501'   THEN   'A.가계'
                            WHEN K.ACSB_CD5   =   '14002401'   THEN   'B.기업'
                            WHEN K.ACSB_CD5   =   '14002601'   THEN   'C.공공'
                            WHEN K.ACSB_CD5   =   '14002511'   THEN   'D.원화사모사채'
                            ELSE 'E.기타'
                       END
            END                                     AS  자금구분

           ,CASE WHEN K.ACSB_CD5 = '14002401' THEN --기업
             CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999'
                    AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014년부터 88도 기업으로 포함시킨다.
                  THEN CASE WHEN ISNULL(D.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.대기업'  ELSE '2.중소기업'  END
             ELSE '3.개인사업자'
             END
            END                                    AS 기업구분

           ,A.INTG_ACNO                            AS 통합계좌번호
           ,A.CLN_EXE_NO                           AS 여신실행번호
           ,A.CUST_NO                              AS 고객번호
           ,A.MRT_CD                               AS 담보코드

           ,A.FST_LN_DT                            AS 대출실행일자
           ,A.LN_EXE_AMT                           AS 대출실행금액


INTO        #모집단 --DROP TABLE #모집단

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A  --DWA_통합여신기본

JOIN        DWZOWN.OT_DWA_DD_BR_BC        J  --DWA_일점기본
            ON   A.BRNO        = J.BRNO
            AND  A.STD_DT      = J.STD_DT

JOIN        (
                  SELECT   STD_DT
                          ,ACSB_CD
                          ,ACSB_NM
                          ,ACSB_CD4  --원화대출금
                          ,ACSB_NM4
                          ,ACSB_CD5  --기업자금대출금(14002401), 가계자금대출금(14002501), 공공및기타(14002601)
                          ,ACSB_NM5
                          ,ACSB_CD6
                          ,ACSB_NM6
                  FROM     OT_DWA_DD_ACSB_TR
                  WHERE    1=1
                  AND      FSC_SNCD IN ('K','C')
                  AND      ACSB_CD4 IN ('13000801')       --원화대출금
            )           K
            ON       A.BS_ACSB_CD   =   K.ACSB_CD
            AND      A.STD_DT       =   K.STD_DT


LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_기업규모기본
            ON     A.RNNO      = D.RNNO
            AND    A.STD_DT    = D.STD_DT

WHERE       1=1
AND         A.STD_DT   IN  (
                              SELECT   MAX(STD_DT)  AS 기준일자
                              FROM     DWZOWN.OT_DWA_INTG_CLN_BC A
                              WHERE    1=1
                              AND      STD_DT BETWEEN '20130101'  AND  '20170831'
                              GROUP BY LEFT(STD_DT,6)
                           )
AND         A.CLN_ACN_STCD  <>  '3'                     -- 취소건제외
AND         A.FRPP_KDCD     <> '4'                      --  장표종류코드(4:종통) 제외
AND         A.FST_LN_DT IS NOT NULL
AND         A.BR_DSCD  =  '1'                          -- 중앙회
AND         당월신규여부 =  1
;

//}

//{ #신규  #신규내역 #통합여신
-- 1. 통합여신을 일별로 뒤져서 신규분을 가져오는 방법

SELECT             A.STD_DT,ACSB_CD5,FRPP_KDCD,INTG_ACNO, CLN_EXE_NO, AGR_DT,FST_LN_DT,A.BS_ACSB_CD,CUST_DSCD,RNNO,FXN_FLX_DSCD,CLN_IRT_DSCD,ENTP_CRGR_JUD_DT,BR_DSCD,ENTP_CREV_GD,LN_RMD,APL_IRRT,MRT_CD,LN_EXE_AMT,AGR_AMT,APRV_AMT,BRNO
                  ,A.EXPI_DT
                  ,A.LN_TRM_MCNT
                  ,A.LN_IRT_FLX_MCNT
INTO               #PRE_모집단     -- DROP TABLE #PRE_모집단
FROM               DWZOWN.OT_DWA_INTG_CLN_BC    A
JOIN               (
                          SELECT   STD_DT
                                  ,ACSB_CD
                                  ,ACSB_NM
                                  ,ACSB_CD4  --원화대출금
                                  ,ACSB_NM4
                                  ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                                  ,ACSB_NM5
                          FROM     OT_DWA_DD_ACSB_TR
                          WHERE    FSC_SNCD IN ('K','C')
--                                                        AND      ACSB_CD4 = '13000801'                                      -- 원화대출금
                          AND      ACSB_CD5 IN ('14002401')   --기업대출금계정
                   )           C
                   ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS계정과목코드
                   AND      A.STD_DT       =   C.STD_DT
WHERE              CASE WHEN A.FRPP_KDCD = '4' THEN A.AGR_DT ELSE A.FST_LN_DT END  BETWEEN '20110101' AND  '20111231'
AND                A.BR_DSCD      = '1'
AND                A.CLN_ACN_STCD  = '1'
AND                A.STD_DT    BETWEEN '20110101' AND  '20111231'
;


SELECT              F.월말일            AS 기준일자
                   ,B.INTG_ACNO         AS 계좌번호
                   ,B.CLN_EXE_NO        AS 실행번호
                   ,CASE WHEN B.FRPP_KDCD = '4' THEN B.AGR_DT ELSE B.FST_LN_DT END    AS 신규일자
                   ,CASE WHEN B.ACSB_CD5 = '14002401'     THEN            -- 기업자금대출금에 대해서만 분류
                         CASE WHEN B.CUST_DSCD  NOT IN ('01','07')  AND B.RNNO < '9999999999' AND SUBSTRING(B.RNNO,4,2) BETWEEN '81' AND '87'  THEN
                                   CASE WHEN D.ENTP_SCL_DTL_DSCD = '01' THEN '1. 대기업'
                                        ELSE '2. 중소기업'
                                   END
                              ELSE '3. 개인사업자'
                         END
                         ELSE NULL
                    END                               AS 기업구분
                   ,B.FST_LN_DT                       AS 최초대출일
                   ,B.EXPI_DT                         AS 만기일
                   ,B.AGR_DT                          AS 약정일
                   ,B.LN_TRM_MCNT                     AS 대출기간개월수
                   ,B.LN_IRT_FLX_MCNT                 AS 대출금리변동개월수

                  ,CASE WHEN (B.CLN_IRT_DSCD  IN ('003','011','008','017')      OR
                             (B.CLN_IRT_DSCD = '024' AND B.FXN_FLX_DSCD = '01') OR
                             (B.CLN_IRT_DSCD = '501' AND B.FXN_FLX_DSCD = '01') )  THEN '1. 고정' --여신금리구분코드
                        ELSE '2. 변동'
                   END   AS  고정변동금리구분코드1

                   ,CASE WHEN  대출금리변동개월수 >= 대출기간개월수   THEN '1. 고정'
                         ELSE                                              '2. 변동'
                    END                                    AS 고정변동금리구분코드2

                   ,B.CLN_IRT_DSCD                         AS 여신금리구분코드
                   ,B.FXN_FLX_DSCD
                   ,B.LN_RMD                               AS 잔액
                   ,B.APL_IRRT                             AS 적용이율
                   ,CASE WHEN B.ACSB_CD5 = '14002401'     THEN            -- 기업자금대출금에 대해서만 분류
                         CASE WHEN B.MRT_CD BETWEEN '501' AND '529'                 THEN '1. 보증대출'
                              WHEN ( B.MRT_CD < '100' OR B.MRT_CD IN ('601','602')) THEN '2. 신용대출'
                              ELSE                                                       '3. 담보대출'
                         END
                         ELSE NULL
                    END                                    AS 기업담보구분

                   ,CASE WHEN B.ACSB_CD5 = '14002501'     THEN            -- 가계자금대출금
                         CASE WHEN B.MRT_CD < '100' OR B.MRT_CD IN ('601','602')   THEN '2. 신용대출'
                               ELSE                                                     '3. 담보대출'
                         END
                         ELSE NULL
                    END                                     AS 가계담보구분

                   ,CASE WHEN B.FRPP_KDCD = '4'  THEN B.AGR_AMT
                         ELSE B.LN_EXE_AMT
                    END                                     AS 보고서금액
INTO                #모집단_취급액              -- DROP TABLE  #모집단_취급액
FROM
                  (
                  SELECT             INTG_ACNO
                                    ,CLN_EXE_NO
                                    ,CASE WHEN FRPP_KDCD = '4' THEN AGR_DT
                                          ELSE '99999999'
                                     END                AS 약정일자_
                                    ,MIN(A.STD_DT)      AS 기준일자
                    FROM               #PRE_모집단    A
                    WHERE              STD_DT >  '19000000'
                  GROUP BY           INTG_ACNO,CLN_EXE_NO,약정일자_

                  )  A

JOIN                #PRE_모집단       B
                    ON         A.INTG_ACNO  = B.INTG_ACNO
                    AND        A.CLN_EXE_NO = B.CLN_EXE_NO
                    AND        A.약정일자_  = CASE WHEN B.FRPP_KDCD = '4' THEN B.AGR_DT ELSE '99999999' END
                    AND        A.기준일자   = B.STD_DT

LEFT OUTER JOIN    (
                        SELECT   STD_DT
                                ,RNNO
                                ,ENTP_SCL_DTL_DSCD
                                ,BZNS_NM
                        FROM     DWZOWN.OT_DWA_ENTP_SCL_BC -- (DWA_기업규모기본)
                   )          D
                   ON         B.RNNO       = D.RNNO                                                 -- 실명번호
                   AND        B.STD_DT     = D.STD_DT

JOIN               OT_DWA_DD_BR_BC      E       -- DWA_일점기본
                   ON         B.STD_DT       = E.STD_DT
                   AND        B.BRNO         = E.BRNO
                   AND        E.BR_DSCD      = '1'   -- 중앙회
                   AND        E.FSC_DSCD     = '1'   -- 신용
                   AND        E.BR_KDCD      < '40'  -- 10:본부부서,20:영업점,30:관리점

LEFT OUTER JOIN    (
                        SELECT   LEFT(STD_DT,6) 기준년월, MAX(STD_DT) 월말일
                        FROM     OT_DWA_INTG_CLN_BC   A
                        WHERE    STD_DT BETWEEN  '20110101' AND '20111231'
                        GROUP BY LEFT(STD_DT,6)
                   )                  F
                   ON   LEFT(CASE WHEN B.FRPP_KDCD = '4' THEN B.AGR_DT ELSE B.FST_LN_DT END,6)   =  F.기준년월
;

-- 년말(해지분도 포함되어 있음)통합여신자료로 당해신규분 발췌한것과 위 로직으로 신규분 발췌한 것을 비교하기 위한 쿼리
-- 비교결과 불일치의 원인이 되는 것들은
-- 통합여신에 취소계좌도 들어오므로 아래와 같이 하면 취소된 계좌도 취소되기전까지는 살아있는 계좌 이므로 신규계좌로 포함되어 나온다
-- 통합여신에 나타날때부터 해지상태로 들어오는 것도 있음
-- 통합여신에 나타날때는 원화대출금(기업자금대출금 또는 가계자금대출금) 이었지만 후에 계정코드가 바뀌어서 범위바깥으로 벗어 나는 경우 있음
-- 반대로 범위바깥의 계정으로 신규가 발생되었다가 후에 범위안으로 계정코드가 바뀌는 경우가 있을수 있을것으로 보임
SELECT  A.*
FROM   OT_DWA_INTG_CLN_BC  A
JOIN               (
                          SELECT   STD_DT
                                  ,ACSB_CD
                                  ,ACSB_NM
                                  ,ACSB_CD4  --원화대출금
                                  ,ACSB_NM4
                                  ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                                  ,ACSB_NM5
                          FROM     OT_DWA_DD_ACSB_TR
                          WHERE    FSC_SNCD IN ('K','C')
--                                                        AND      ACSB_CD4 = '13000801'                                      -- 원화대출금
                          AND      ACSB_CD5 IN ('14002401')   --기업대출금계정
                   )           C
                   ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS계정과목코드
                   AND      A.STD_DT       =   C.STD_DT
LEFT OUTER JOIN
         (
            SELECT  계좌번호, 실행번호
            FROM    #모집단_취급액
            WHERE 장표종류 <> '4'
         )   D
         ON   A.INTG_ACNO   =  D.계좌번호
         AND  A.CLN_EXE_NO  =  D.실행번호

WHERE   A.STD_DT = '20131231'
AND     A.FRPP_KDCD <> '4'
AND     A.FST_LN_DT BETWEEN  '20130101' AND '20131231'
AND     D.계좌번호 IS NULL
;


SELECT   A.*
FROM    #모집단_취급액    A

LEFT OUTER JOIN
        (
        SELECT  A.INTG_ACNO, A.CLN_EXE_NO
        FROM   OT_DWA_INTG_CLN_BC  A
        JOIN               (
                      SELECT   STD_DT
                          ,ACSB_CD
                          ,ACSB_NM
                          ,ACSB_CD4  --원화대출금
                          ,ACSB_NM4
                          ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                          ,ACSB_NM5
                      FROM     OT_DWA_DD_ACSB_TR
                      WHERE    FSC_SNCD IN ('K','C')
        --                                                        AND      ACSB_CD4 = '13000801'                                      -- 원화대출금
                      AND      ACSB_CD5 IN ('14002401')   --기업대출금계정
                   )           C
                   ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS계정과목코드
                   AND      A.STD_DT       =   C.STD_DT
                 WHERE    1=1
                 AND      A.STD_DT  = '20131231'
                 AND      A.FRPP_KDCD <>  '4'
         )    D
         ON   A.계좌번호  =  D.INTG_ACNO
         AND  A.실행번호  =  D.CLN_EXE_NO

WHERE   A.장표종류 <> '4'
AND     D.INTG_ACNO IS NULL

-- 2.통합여신을 월말원장을 가지고 당월신규분을 발췌하여는 방법

SELECT             A.STD_DT                     AS  기준일자
                  ,A.INTG_ACNO                  AS  계좌번호
                  ,A.CLN_EXE_NO                 AS  여신실행번호
                  ,C.ACSB_NM6                   AS  계정구분명
                  ,A.AGR_DT                     AS  약정일자
                  ,A.AGR_AMT                    AS  약정금액
                  ,A.FST_LN_DT                  AS  대출일자
                  ,A.EXPI_DT                    AS  만기일자
                  ,A.PSTP_ENR_DT                AS  연장등록일
                  ,A.CLN_IRT_DSCD               AS  여신금리구분코드
                  ,A.LN_RMD                     AS  잔액
                  ,A.LN_EXE_AMT                 AS  대출실행금액
                  ,A.STD_IRT                    AS  기준금리
                  ,A.ADD_IRT                    AS  가산금리
                  ,A.APL_IRRT                   AS  적용금리
                  ,A.CLN_RDM_MHCD               AS  여신상환방법코드   -- (1:만기일시상환, 2~  :분할상환)

INTO               #모집단_기업           --  DROP TABLE #모집단_기업
FROM               DWZOWN.OT_DWA_INTG_CLN_BC A   --DWA_통합여신기본

JOIN               (
                 SELECT   STD_DT
                         ,ACSB_CD
                         ,ACSB_NM
                         ,ACSB_CD4  --원화대출금
                         ,ACSB_NM4
                         ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                         ,ACSB_NM5
                         ,ACSB_CD6  --기업운전자금대출금(15002001), 기업시설자금대출금(15002101)
                         ,ACSB_NM6
                 FROM     OT_DWA_DD_ACSB_TR
                 WHERE    1=1
                 AND      FSC_SNCD      IN ('K','C')
                 AND      ACSB_CD5      = '14002401'     --기업자금대출금
                   )          C
                   ON    A.BS_ACSB_CD  =  C.ACSB_CD
                   AND   A.STD_DT      =  C.STD_DT

WHERE              A.STD_DT   IN  (
                                     SELECT   MAX(STD_DT)  AS 기준일자
                                     FROM     DWZOWN.OT_DWA_INTG_CLN_BC A
                                     WHERE    1=1
                                     AND      STD_DT BETWEEN '20120101'  AND  '20140630'
                                     GROUP BY LEFT(STD_DT,6)
                                  )
AND                A.CLN_ACN_STCD     = '1'   --여신계좌상태코드:1(정상)
AND                A.BR_DSCD          = '1'   --중앙회
AND                A.CLN_TSK_DSCD    <> '90'  --여신업무구분코드:90(특수채권)
AND                A.INDV_LMT_LN_DSCD = '1' --  개별한도대출구분코드(1:건별거래대출, 2:한도거래대출)
AND                A.FRPP_KDCD       <> '4'     --  장표종류코드(4:종통) 제외
AND                (
                         LEFT(A.STD_DT,6) = LEFT(A.AGR_DT,6)  OR                        -- 약정이나 연장을 신규로 봄
                         LEFT(A.STD_DT,6) = LEFT(ISNULL(A.PSTP_ENR_DT,'00000000'),6)
                   )
AND                A.CLN_IRT_DSCD IN ('005','021','026','030','031')  -- CD금리
;

-- 3. 신규기준 (일반여신은 실행일기준, 종통은 약정일 기준으로 신규판단, 신규금액도 실행금액과 약정금액 이용)
SELECT
........
           ,CASE WHEN LEFT(CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN FST_LN_DT ELSE AGR_DT END,6) = LEFT(A.STD_DT,6)
                   THEN  1
                   ELSE  0
            END                                 AS 당월신규여부
           ,CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN LN_EXE_AMT ELSE AGR_AMT END  AS 신규대상금액
...........

SELECT
           ,CASE WHEN LEFT(CASE WHEN A.FRPP_KDCD = '4'  THEN AGR_DT ELSE FST_LN_DT END,6) = LEFT(A.STD_DT,6)
                   THEN  1
                   ELSE  0
            END                                 AS 당월신규여부
           ,CASE WHEN A.FRPP_KDCD = '4' THEN AGR_AMT  ELSE LN_EXE_AMT END  AS 신규대상금액
//}

//{ #일계좌금리 #일계좌금리집계 #종통금리 #요구불금리


-- CASE 1  통합여신을 읽지 않고 특정시점의 금리를 가져온다

UPDATE      #TEMP_기본여신  A
SET         A.기준금리 =   B.STD_IRT
           ,A.가산금리 =   B.APL_ADD_IRT
           ,A.적용금리 =   B.APL_IRRT
FROM
           (          SELECT    A.STD_DT
                               ,A.CLN_ACNO
                               ,A.CLN_EXE_NO
                               ,A.CLN_APL_IRRT_DSCD                --여신적용이율구분코드
                               ,A.APL_ADD_IRT                      --적용가산금리
                               ,A.APL_IRRT                         --적용이율
                               ,A.ADD_IRT                          --가산금리
                               ,A.APL_ST_DT                        --적용시작일자
                               ,A.APL_END_DT                       --적용종료일자
                       FROM     DWZOWN.TB_SOR_LOA_DDY_ACN_IRT_TZ   A
                               ,(
                                     SELECT   CLN_ACNO, CLN_EXE_NO , MAX(STD_DT)  AS 최근기준일
                                     FROM     DWZOWN.TB_SOR_LOA_DDY_ACN_IRT_TZ
                                     WHERE    CLN_APL_IRRT_DSCD = '1'          --여신적용이율구분코드(1:대출이율,9.연체이율)
                                     GROUP BY CLN_ACNO, CLN_EXE_NO
                                )   B

                       WHERE    1=1
                         AND    A.STD_DT            =  B.최근기준일
                         AND    A.CLN_ACNO          =  B.CLN_ACNO
                         AND    A.CLN_EXE_NO        =  B.CLN_EXE_NO
                         AND    A.CLN_APL_IRRT_DSCD = '1'          --여신적용이율구분코드(1:대출이율,9.연체이율)
             )   B

WHERE        A.계좌번호      =   B.CLN_ACNO
AND          A.여신실행번호  =   B.CLN_EXE_NO
AND          A.기준일자 BETWEEN B.APL_ST_DT AND  B.APL_END_DT
--AND          (
--                  (  A.기준금리 <>  ( B.APL_IRRT - B.APL_ADD_IRT ) )  OR
--                  (  A.가산금리 <>   B.APL_ADD_IRT )                  OR
--                  (  A.적용금리 <>   B.APL_IRRT    )
--             )


-- CASE 2  종통금리는 일자구간이 없고 매일매일의 금리를 누적시켜놓았다

LEFT OUTER JOIN         -- 약정시점의 금리
            DWZOWN.TB_SOR_LOA_ODMN_IRT_TR    G        -- SOR_LOA_요구불금리내역
            ON            A.통합계좌번호  =   G.CLN_ACNO
            AND           A.여신실행번호  =   G.CLN_EXE_NO
            AND           A.약정일자      =   G.STD_DT

LEFT OUTER JOIN         -- 연장시점이자율
            DWZOWN.TB_SOR_LOA_ODMN_IRT_TR    H        -- SOR_LOA_요구불금리내역
            ON            A.통합계좌번호  =   H.CLN_ACNO
            AND           A.여신실행번호  =   H.CLN_EXE_NO
            AND           C.연장일자      =   H.STD_DT


//}

//{ #고정금리 #변동금리 #고정변동 #금리구분 #금리변동주기 #금리주기

# ALM 기준 금리구분기준 1 : 코드 063(2015.04.10) 추가, 코드 008(2015.08.17) 추가, 509(혼합금리구분,2017.09) 추가
                  ,CASE WHEN A.CLN_IRT_DSCD IN  ('063')  OR
                             ( A.CLN_IRT_DSCD IN  ('509')  AND A.STD_DT < C.FLX_IRT_STD_DT )  OR
                             (
                                    A.CLN_IRT_DSCD in ('012','503','017','060','016','003','501','024','018','061','019','000','011','015','502','063','008')
                               AND  AA.LN_IRT_FLX_MCNT = 0
                             )                             THEN   '1. 고정금리'
                        WHEN  A.CLN_IRT_DSCD = '509'       THEN   '3. 혼합금리'
                        ELSE                                      '2. 변동금리'
                   END                                             AS   금리구분

                  ,CASE WHEN 금리구분 = '1. 고정금리' THEN 0  ELSE AA.LN_IRT_FLX_MCNT END AS  대출금리변동개월수

FROM               DWZOWN.OT_DWA_INTG_CLN_BC    A

JOIN               DWZOWN.OT_DWA_DD_BR_BC       B              -- DWA_일점기본
                   ON     A.BRNO         = B.BRNO
                   AND    A.STD_DT       = B.STD_DT

JOIN               DWZOWN.TB_SOR_LOA_ACN_BSC_DL C               --SOR_LOA_계좌기본상세
                   ON     A.INTG_ACNO    =  C.CLN_ACNO

JOIN               DWZOWN.TT_SOR_LOA_MM_ACN_BC    AA            --SOR_LOA_월계좌기본
                   ON     LEFT(A.STD_DT,6)  = AA.STD_YM
                   AND    A.INTG_ACNO       = AA.CLN_ACNO

# ALM 기준 금리구분기준 2 ( 지근성작)
             CASE WHEN A.CLN_IRT_DSCD IN  ('000','002','003','008','011','012','013','015','016','017','018','019','024','060','061','501','502','503')
                       AND b.LN_IRT_FLX_MCNT = 0   THEN   '고정금리'
                  WHEN A.CLN_IRT_DSCD IN  ('063')  THEN   '고정금리'
                  WHEN A.CLN_IRT_DSCD IN  ('001')  THEN   '변동금리조건 중 프라임레이트연동'
                  WHEN A.CLN_IRT_DSCD IN  ('017')
                       AND b.LNDS_IRT_DSCD in ('11','12','13','21','22','23','24','25','26','31','41','51','71','72','73')
                                                   THEN   '변동금리조건 중 시장금리연동'
                  WHEN A.CLN_IRT_DSCD IN  ('021','022','025','026','027','30','55','56','601','602','603')  THEN   '변동금리조건 중 시장금리연동'
                  WHEN A.CLN_IRT_DSCD IN  ('501')
                       AND b.LN_IRT_FLX_MCNT <> 0  THEN   '변동금리조건 중 시장금리연동'
                  WHEN A.CLN_IRT_DSCD IN  ('014','023')  THEN   '변동금리조건 중 수신금리연동'
                  WHEN A.CLN_IRT_DSCD IN  ('015')
                       AND b.LN_IRT_FLX_MCNT = 6   THEN   '변동금리조건 중 수신금리연동'
                  WHEN A.CLN_IRT_DSCD IN  ('016')
                       AND b.LN_IRT_FLX_MCNT = 12  THEN   '변동금리조건 중 수신금리연동'
                  WHEN A.CLN_IRT_DSCD IN  ('024')
                       AND b.LN_IRT_FLX_MCNT <> 0  THEN   '변동금리조건 중 수신금리연동'
                  WHEN A.CLN_IRT_DSCD IN  ('004','028','029')  THEN   '변동금리조건 중 COFIX연동'
                  WHEN A.CLN_IRT_DSCD IN  ('015')
                       AND b.LN_IRT_FLX_MCNT = 3   THEN   '기타변동금리'
                  WHEN A.CLN_IRT_DSCD IN  ('017')
                       AND b.LNDS_IRT_DSCD in ('61','62')
                                                   THEN   '기타변동금리'
                  WHEN A.CLN_IRT_DSCD IN  ('062')  THEN   '기타변동금리'
             ELSE '기타금리'
             END           AS 금리구분

//}

//{ #가중평균금리  #가중평균
-- CASE 1  잔액이 0 인건은 제외하고 가중평균한다
SELECT
           ,A.MRT_CD                     AS  담보코드
           ,F.MRT_TPCD                   AS  담보유형코드
           ,SUM(A.LN_RMD)                AS  잔액
           ,CASE WHEN A.FRPP_KDCD  =  '4' THEN  CONVERT(NUMERIC(7,5),MAX(A.APL_IRRT))
                 ELSE
                   CONVERT(NUMERIC(7,5),
                       CASE WHEN SUM(CASE WHEN A.APL_IRRT <> 0 THEN  A.LN_RMD ELSE 0 END) = 0 THEN 0
                            ELSE
                            SUM(CASE WHEN A.APL_IRRT <> 0 THEN  A.LN_RMD * A.APL_IRRT  ELSE 0 END)
                          / SUM(CASE WHEN A.APL_IRRT <> 0 THEN  A.LN_RMD               ELSE 0 END)
                       END
                   )
            END                                                        AS  적용이율

INTO        #기업자금   -- DROP TABLE #기업자금

GROUP BY    A.FRPP_KDCD
;

//}

//{ #전세자금
--  UP_DWZ_여신_N0190_전세자금대출현황
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
            END   AS 전세자금여부
//}

//{ #부동산담보  #부동산
,CASE WHEN A.MRT_CD BETWEEN '100' AND '199'  THEN  'Y'  ELSE 'N' END  AS 부동산담보대출여부
--  이병복
--(1) 부동산담보 : 담보코드 100번대
--단,  부동산(선박) 대분류 안에  200번대 담보가 두개 있음에 유의.
--'주택담보대출 중' 등이라는 제한요건이 없거나 원화대출금 전체에 대한 보고서인 경우 아래의 담보도 적용함이 맞는 것으로 생각됩니다.
--하지만 이미 사용중인 대외보고용 프로시저 등에서 반영이 안되어있는 것으로 보이기는 하여 따로이 요건으로 드리지 않고 있습니다 ㅠㅠ
--      1. 20톤미만어선          216
--      2. 20톤미만 기타선박   217

//}

//{ #아파트담보  #아파트
CASE WHEN A.MRT_CD IN  ('101','170')        THEN  'Y'  ELSE 'N' END  AS 아파트담보대출여부
//}

//{ #특수채권 #원인계좌  #계좌연결

LEFT OUTER JOIN
--  특수채권원장에 비용발생원인통합계좌번호로 죠인해도 되는데 차세대 이전 내역중 비용발생원인통합계좌번호에 전환전
--  계좌번호가 있는경우도 있어서 계좌연결기본을 이용해서 죠인하는게 정확함 (이상진)
             (
                  SELECT   A.LNK_CLN_FCNO           AS  여신계좌번호
                          ,MIN(B.SPCT_BND_ADMS_DT)  AS  특수채권편입일자
                          ,MAX(A.CLN_ACNO)          AS  특수채권계좌번호
                          ,SUM(BDX_PCPL)            AS  상각원금
                  FROM     TB_SOR_LOA_ACN_LNK_BC A      -- SOR_LOA_계좌연결기본
                  JOIN     TB_SOR_WOL_SPRC_BC     B
                           ON  A.CLN_ACNO  =  B.CLN_ACNO
                  WHERE    A.CLN_ACN_LNK_KDCD  IN ('411','412','413','414','415','416','417')  -- 여신계좌연결종류코드
                  AND      B.AMR_DSCD IN ('1','2')   --상각구분코드(1:의무상각,2:일반상각,3:미수이자,4:기타)
                                   -- 411 ~ 417 특수채권연결
                  GROUP BY A.LNK_CLN_FCNO
             )   E
             ON   A.통합계좌번호  = E.여신계좌번호

--  매각처리건수는   TB_SOR_WOL_SLN_ACCT_BND_BC(SOR_WOL_매각계정채권기본) 에 매각일자가 있는것을 찾으면됨
--  특수채권원장과 계좌번호,실행번호 죠인
--  경매건수는 전산관리되지 않음"



-- 특수채권계좌번호로 원인계좌번호 찾기
-- 특수채권원장에는 하나의 특수채권계좌번호에 실행번호가 여러개 있을수 있어서 DISTINCT 해줘야 한다
SELECT      DISTINCT
            T.순번
           ,T.계좌번호
           ,T.특수채권편입일
           ,A.CLN_ACNO    AS 특수채권계좌번호
           ,B.CLN_ACNO    AS 원인계좌번호

INTO        #원인계좌번호   -- DROP TABLE #원인계좌번호

FROM        #대상계좌   T

LEFT OUTER JOIN
            TB_SOR_WOL_SPRC_BC A
            ON   T.계좌번호  = A.CLN_ACNO

LEFT OUTER JOIN
            TB_SOR_LOA_ACN_BC   B
            ON A.XPS_OCC_CAS_INTG_ACNO    = B.CLN_ACNO
;

--  원인계좌번호 빈것이 있어서 계좌연결기본으로 보강한다
--  계좌연결기본만으로 원인계좌를 찾아봐도 역시 빈곳이 생긴다.
UPDATE    #원인계좌번호  A
SET        A.원인계좌번호 =  B.원인계좌번호
FROM       (
                  SELECT    T.순번
                           ,T.계좌번호
                           ,A.CLN_ACNO        AS 특수채권계좌번호
                           ,A.LNK_CLN_FCNO    AS 원인계좌번호
                  FROM     #대상계좌  T
                  JOIN     TB_SOR_LOA_ACN_LNK_BC A      -- SOR_LOA_계좌연결기본
                           ON   T.계좌번호  = A.CLN_ACNO
                         --  AND  A.CLN_ACN_LNK_KDCD  IN ('411','412','413','414','415','416','417')  -- 여신계좌연결종류코드
                                   -- 411 ~ 417 특수채권연결
            )   B

WHERE       1=1
AND         A.원인계좌번호 IS NULL
AND         A.특수채권계좌번호 = B.특수채권계좌번호
;


//}

//{ #최초거래점  #최초거래 #최초계좌번호 #최초점 #최초취급계좌번호 #최초취급점

--1. 거래내역상의 최초거래점(실행번호,거래번호의 최초값),수신계좌기본의 신규점번호(종통)
--   여신거래내역상의 최초거래(신규약정, 대출실행)점을 가져오는 방법임
--   아래 2번 방법과 결과적으로 동일한 값이 나와야 할것 같긴 한데 확인은 못해본 상태
--   부도관련테이블(SOR_DAD_전출입최초계좌기본)의 정확한 요건을 알수 없음  그냥 믿고 쓰는 수밖에
 SELECT     A.INTG_ACNO         AS 계좌번호
           ,B.거래점번호        AS 최초점번호
 INTO       #TEMP최초거래점
 FROM       TB_SOR_DAD_MVT_FST_ACN_BC A    --SOR_DAD_전출입최초계좌기본 (차세대이전내역과 차세대전환시점까지만 존재함)
           ,(SELECT  A.TR_BRNO     AS 거래점번호  --최초거래점번호
                    ,A.CLN_ACNO    AS 계좌번호
             FROM    TB_SOR_LOA_TR_TR A   --SOR_LOA_거래내역
                   ,(SELECT   MIN(A.CLN_TR_NO)   AS 여신거래번호
                             ,A.CLN_ACNO         AS 여신계좌번호
                             ,A.CLN_EXE_NO       AS 여신실행번호
                     FROM     TB_SOR_LOA_TR_TR A   --SOR_LOA_거래내역
                            ,(SELECT    MIN(CLN_EXE_NO)  AS 여신실행번호
                                       ,CLN_ACNO         AS 여신계좌번호
                              FROM      TB_SOR_LOA_TR_TR    --SOR_LOA_거래내역
                              WHERE     TR_STCD = '1'       --거래상태코드: 정상
                              AND       CLN_TR_KDCD IN ('100','200') --여신거래종류코드 : 신규약정 ,대출실행
                              GROUP BY  여신계좌번호
                             ) B
                     WHERE    A.TR_STCD     = '1'       --거래상태코드: 정상
                     AND      A.CLN_TR_KDCD IN ('100','200') --여신거래종류코드 : 신규약정 ,대출실행
                     AND      A.CLN_EXE_NO  = B.여신실행번호
                     AND      A.CLN_ACNO    = B.여신계좌번호
                     GROUP BY 여신계좌번호
                             ,여신실행번호
                    ) B
             WHERE  A.TR_STCD      = '1'       --거래상태코드: 정상
             AND    A.CLN_TR_KDCD  IN ('100','200') --여신거래종류코드 : 신규약정 ,대출실행
             AND    A.CLN_TR_NO    = B.여신거래번호
             AND    A.CLN_ACNO     = B.여신계좌번호
             AND    A.CLN_EXE_NO   = B.여신실행번호
             ) B
    WHERE    A.FST_INTG_ACNO = B.계좌번호

    UNION ALL

    SELECT   A.계좌번호
            ,CASE WHEN B.전출점번호  IS NOT NULL  THEN B.전출점번호
                  ELSE A.거래점번호  END  AS 최초점번호
    FROM    (SELECT  A.TR_BRNO     AS 거래점번호  --최초거래점번호
                    ,A.CLN_ACNO    AS 계좌번호
             FROM    TB_SOR_LOA_TR_TR A   --SOR_LOA_거래내역
                   ,(SELECT   MIN(A.CLN_TR_NO)   AS 여신거래번호
                             ,A.CLN_ACNO         AS 여신계좌번호
                             ,A.CLN_EXE_NO       AS 여신실행번호
                     FROM     TB_SOR_LOA_TR_TR A   --SOR_LOA_거래내역
                            ,(SELECT    MIN(CLN_EXE_NO)  AS 여신실행번호
                                       ,CLN_ACNO         AS 여신계좌번호
                              FROM      TB_SOR_LOA_TR_TR    --SOR_LOA_거래내역
                              WHERE     TR_STCD = '1'       --거래상태코드: 정상
                              AND       CLN_TR_KDCD IN ('100','200') --여신거래종류코드 : 신규약정 ,대출실행
                              AND       CLN_ACNO    NOT IN (SELECT  INTG_ACNO  FROM TB_SOR_DAD_MVT_FST_ACN_BC)
                              GROUP BY  여신계좌번호
                             ) B
                     WHERE    A.TR_STCD     = '1'       --거래상태코드: 정상
                     AND      A.CLN_TR_KDCD IN ('100','200') --여신거래종류코드 : 신규약정 ,대출실행
                     AND      A.CLN_EXE_NO  = B.여신실행번호
                     AND      A.CLN_ACNO    = B.여신계좌번호
                     GROUP BY 여신계좌번호
                             ,여신실행번호
                    ) B
             WHERE  A.TR_STCD      = '1'       --거래상태코드: 정상
             AND    A.CLN_TR_KDCD  IN ('100','200') --여신거래종류코드 : 신규약정 ,대출실행
             AND    A.CLN_TR_NO    = B.여신거래번호
             AND    A.CLN_ACNO     = B.여신계좌번호
             AND    A.CLN_EXE_NO   = B.여신실행번호
             ) A
           ,(SELECT   DISTINCT  CLN_ACNO  AS 계좌번호
                     ,MVT_BRNO            AS 전출점번호
             FROM     TB_SOR_WOL_SPRC_BC
             WHERE    MVT_BRNO IS NOT NULL
             ) B
    WHERE    A.계좌번호 *= B.계좌번호

    UNION ALL
    --종통
    SELECT   ACNO      AS 계좌번호
            ,NW_BRNO   AS 최초점번호  --신규점번호
    FROM     TB_SOR_DEP_DPAC_BC
    WHERE    LN_BS_ACSB_CD  IN (SELECT RLT_ACSB_CD
                                FROM   DWZOWN.OT_DWA_DD_ACSB_BC   -- DWA_일계정과목기본
                                WHERE  ACSB_CD     = '13000801'   -- 원화대출금
                                AND    FSC_SNCD IN ('K','C')      -- 회계기준코드       = 'K' (K-GAAP)
                                AND    STD_DT      = '20140930')   -- 기준일자 = '20140930'
;

--2. 이수관내역(TB_SOR_LOA_MVN_MVT_HT)에 차세대 이전거래도 전환이 잘되어있다(안지원왈)에 따라
--   이수관내역을 가지고 최초거래점과 첫계좌번호를 가져오는 방식
--   아래 1번 방법과 결과적으로 동일한 값이 나와야 할것 같긴 한데 확인은 못해본 상태

LEFT OUTER JOIN   -- 일반여신
            (
               SELECT   A.전출점번호
                       ,A.최종계좌번호
                       ,CASE WHEN A.전출계좌번호 IS NULL THEN A.최종계좌번호 ELSE A.전출계좌번호 END AS 전출계좌번호
                       ,A.전출일자
               FROM
               (
                    SELECT   MVT_BRNO   AS 전출점번호
                        ,MVN_BRNO   AS 전입점번호
                        ,MVT_DT     AS 전출일자
                        ,MVN_DT     AS 전입일자
                        ,CLN_ACNO   AS 여신계좌번호
                        ,CLN_EXE_NO AS 여신실행번호
                        ,LN_RMD     AS 대출잔액
                        ,MVT_ACNO   AS 전출계좌번호
                        ,MVN_ACNO   AS 전입계좌번호
                        ,CASE WHEN TRIM(LST_ACNO) IS NULL OR LST_ACNO = ''  THEN CLN_ACNO ELSE LST_ACNO END   AS 최종계좌번호
                        ,ROW_NUMBER() OVER(PARTITION BY CLN_ACNO ORDER BY MVT_DT ASC ,SNO  ASC) AS 순서
                    FROM     TB_SOR_LOA_MVN_MVT_HT
                    WHERE    1=1
                    AND      CASE WHEN TRIM(LST_ACNO) IS NULL OR LST_ACNO = ''  THEN CLN_ACNO ELSE LST_ACNO END IN ( SELECT  계좌번호 FROM #대상계좌_중복제거)
               )     A
               WHERE       1=1
               AND         A.순서 = 1
            )  B
            ON    A.계좌번호  = B.최종계좌번호

LEFT OUTER JOIN   -- 종통
            (
               SELECT     A.전출점번호
                         ,A.계좌번호 AS 최종계좌번호
                         ,A.계좌번호 AS 전출계좌번호  -- 종통은 차세대이전 전출입건에 대한 전출계좌구할수 없음
                         ,A.전출일자
               FROM
               (
                 SELECT    A.ACNO                AS 계좌번호
                          ,B.MVT_MVN_AMT         AS 전출입금액
                          ,A.ENR_BRNO            AS 전출점번호
                          ,B.ENR_BRNO            AS 전입점번호
                          ,A.ENR_DT              AS 전출일자
                          ,B.ENR_DT              AS 전입일자
                          ,ROW_NUMBER() OVER(PARTITION BY A.ACNO ORDER BY A.MVT_MVN_SNO ASC) AS 순서
                 FROM      TB_SOR_DEP_MVT_MVN_TR   A
                 JOIN      TB_SOR_DEP_MVT_MVN_TR   B
                           ON  A.ACNO  =  B.ACNO
                           AND A.MVT_MVN_SNO + 1 = B.MVT_MVN_SNO
                           AND B.MVT_MVN_DSCD = '3'       -- 전입
                           AND ( B.RLS_DT   IS NULL  OR  B.RLS_DT = ''  )
                 WHERE     ( A.RLS_DT   IS NULL  OR  A.RLS_DT = ''  )
                 AND       A.MVT_MVN_DSCD  = '1'  -- 전출
                 AND       A.ENR_BRNO  NOT IN ('0018','0805','0542','0090')   -- 전출점이 일반영업점인것
                 AND       A.ACNO    IN ( SELECT  계좌번호 FROM #대상계좌_중복제거)

               )   A
               WHERE  순서 = 1
            )   C
            ON    A.계좌번호  = C.최종계좌번호

//}

//{ #주택금융공사 #유동화계획코드 #매각처리일자 #주공
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
              ELSE 'KHFCMB2014M-20' END         AS 유동화계획코드
             ,H.SLN_PCS_DT                      AS 매각처리일자

FROM          TT_SOR_LOA_MM_ACN_BC  B        --  SOR_LOA_계좌기본
JOIN          TT_SOR_LOA_MM_EXE_BC  C        --  SOR_LOA_실행기본
              ON   B.CLN_ACNO     =   C.CLN_ACNO
              AND  C.CLN_ACN_STCD =   '1'      -- 여신계좌상태코드  (1:정상)
              AND  C.STD_YM       =   '201409'
JOIN          TB_SOR_LOA_KHFC_LN_DL   H      --  SOR_LOA_한국주택금융공사대출상세
              ON   C.CLN_ACNO    =  H.CLN_ACNO
              AND  C.CLN_EXE_NO  =  H.CLN_EXE_NO
WHERE         1=1
AND           B.PDCD IN ('20081107100001',
                         '20081112301011',
                         '20081112301021',
                         '20081112401011',
                         '20081112401021'
                         )
AND           B.CLN_ACN_STCD = '1'  -- 여신계좌상태코드  (1:정상)
AND           B.STD_YM =  '201409'

//}

//{  #고객소재지 #고객주소

SELECT
           ,CC.ADR_                          AS 지역구분

JOIN        DWZOWN.OM_DWA_INTG_CUST_BC  B   --DWA_통합고객기본
            ON    A.CUST_NO  =  B.CUST_NO


LEFT OUTER JOIN   -- 업체본사의 소재지
            (
              SELECT   DISTINCT
                       A.ZIP
                      ,CASE WHEN TRIM(A.MPSD_NM)  IN ('울산광역시','서울특별시','부산광역시','인천광역시','광주광역시','대구광역시','대전광역시')
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

//{ #점소재지 #점우편

-- 취급점 소재지
SELECT      T.계좌번호
           ,TRIM(DD.MPSD_NM) || ' ' || TRIM(DD.CCG_NM) || ' ' || TRIM(DD.EMD_NM)  AS  취급점소재

FROM        #TEMP                      T

JOIN        TB_SOR_LOA_ACN_BC          A
            ON   T.계좌번호  =  A.CLN_ACNO

JOIN        DWZOWN.OT_DWA_DD_BR_BC           D  --DWA_일점기본
            ON    A.ACN_ADM_BRNO    =   D.BRNO
            AND   D.STD_DT          =   P_기준일자

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

--ORDER BY    T.순번

-- 취급점 소재지 2
           ,SUM(A.LN_RMD)                     AS 대출잔액
           ,J.ARCD||'.'||ISNULL(TRIM(X1.CMN_CD_NM),' ')  AS 영업점지역구분

INTO        #모집단_잔액   -- DROP TABLE #모집단_잔액

FROM        OT_DWA_INTG_CLN_BC A

JOIN        DWZOWN.OT_DWA_DD_BR_BC        J  --DWA_일점기본
            ON   A.BRNO        = J.BRNO
            AND  A.STD_DT      = J.STD_DT
            
            
//}

//{ #대출과목 #대출과목명 #대출세목 #대출세목명 #대출용도코드 #대출용도코드명 #대출과세목 #여신계층목록기본

LEFT OUTER JOIN
       (
              SELECT   DISTINCT
                         LN_SBCD
                        ,LN_TXIM_CD
                        ,LN_USCD
                        ,LN_SBJ_NM      AS  대출과목명
                        ,LN_TXIM_CD_NM   AS  대출세목코드명
                        ,LN_USCD_NM      AS  대출용도코드명
                FROM    OT_DWA_CLN_HRC_CTL_BC A
                WHERE   STD_DT =  '20140930'
         ) L
         ON     B.LN_SBCD      =   L.LN_SBCD      --대출과목코드
         AND    B.LN_TXIM_CD  =   L.LN_TXIM_CD   --대출세목코드
         AND    B.LN_USCD      =   L.LN_USCD      --대출용도코드

//}

//{ #외화한도  #수출 #외환한도기본
-- 한도원장과 수출원장 join 방법
SELECT    A.FRXC_LMT_ACNO                                       AS 외환한도계좌번호
         ,A.CUST_NO                                             AS 고객번호
         ,CASE WHEN N.ENTP_SCL_DSCD IN ('10','11','14') THEN '대기업'
               WHEN N.ENTP_SCL_DSCD IN ('20','21','24') THEN '중소기업'
               WHEN N.ENTP_SCL_DSCD IN ('32','33','35') THEN '개인사업자'
               WHEN N.ENTP_SCL_DSCD IN ('30','31','34') THEN '개인'
               WHEN N.ENTP_SCL_DSCD IN ('40','41','42','43','44') THEN '공공단체'
          END                                                   AS 기업규모구분
         ,B.REF_NO                                              AS REF_NO
         ,A.INDV_LMT_LN_DSCD                                    AS 개별한도대출구분코드  --(1:건별거래대출,2:한도거래대출)
         ,B.CLN_APRV_NO                                         AS 여신승인번호
-- SOR_FEC_여신한도기본 의 여신승인번호는 최종승인번호고 각 건의 승인번호는 SOR_FEC_여신한도상세의 승인번호를 사용해야 한다
         ,A.AGR_DT                                              AS 한도약정일
         ,A.AGR_EXPI_DT                                         AS 한도약정만기일자
         ,A.CNCN_DT                                             AS 한도해지일


FROM      DWZOWN.TB_SOR_FEC_CLN_LMT_BC  A           -- SOR_FEC_여신한도기본

JOIN      DWZOWN.TB_SOR_FEC_CLN_LMT_DL  B           -- SOR_FEC_여신한도상세
          ON     A.FRXC_LMT_ACNO = B.FRXC_LMT_ACNO
          AND    B.TR_DT         <=  '20141031'
          AND    B.FRXC_CLN_TR_CD  = '22'           -- 외환여신거래코드(22:실행)
          AND    B.FRXC_LDGR_STCD  NOT IN ('4','5') -- 외환원장상태코드(4:정정,5:취소)

JOIN      DWZOWN.TB_SOR_EXP_EXP_BC       C          -- SOR_EXP_수출기본
          ON     B.REF_NO    =  C.REF_NO

-- 한도원장과 여신승인원장을 JOIN
SELECT    A.FRXC_LMT_ACNO                                       AS 외환한도계좌번호
         ,A.CUST_NO                                             AS 고객번호
         ,B.REF_NO                                              AS REF_NO
         ,A.INDV_LMT_LN_DSCD                                    AS 개별한도대출구분코드  --(1:건별거래대출,2:한도거래대출)
         ,B.CLN_APRV_NO                                         AS 여신승인번호
-- SOR_FEC_여신한도기본 의 여신승인번호는 최종승인번호고 각 건의 승인번호는 SOR_FEC_여신한도상세의 승인번호를 사용해야 한다
         ,A.AGR_DT                                              AS 한도약정일
         ,A.AGR_EXPI_DT                                         AS 한도약정만기일자
         ,A.CNCN_DT                                             AS 한도해지일
         ,B.FRXC_CLN_TR_CD                                      AS 외환여신거래코드
         ,C.LST_XCDC_DSCD ||'('||TRIM(D.XCDC_DSCD_NM)||')'      AS 여신전결구분

FROM      DWZOWN.TB_SOR_FEC_CLN_LMT_BC  A           -- SOR_FEC_여신한도기본

JOIN      DWZOWN.TB_SOR_FEC_CLN_LMT_DL  B           -- SOR_FEC_여신한도상세
          ON     A.FRXC_LMT_ACNO = B.FRXC_LMT_ACNO
          AND    B.TR_DT         <=  '20141031'
          AND    B.FRXC_CLN_TR_CD  IN  ('10','30','50','70')  -- 외환여신거래코드(10:약정,30:기한연장,50:기한단축, 70:조건변경)
          AND    B.FRXC_LDGR_STCD  NOT IN ('4','5') -- 외환원장상태코드(4:정정,5:취소)

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APRV_BC   C     -- SOR_CLI_여신승인기본
            ON   B.CLN_APRV_NO  =  C.CLN_APRV_NO

LEFT OUTER JOIN
            TB_SOR_CLI_XCDC_DSCD_BC  D   --SOR_CLI_전결구분코드기본
            ON   C.LST_XCDC_DSCD  = D.CLN_XCDC_DSCD  --여신전결구분코드

ORDER BY    1,7

//}

//{ #보증서담보

-- 현재원장이용
SELECT    A.CLN_APC_NO             AS 여신신청번호
         ,A.ACN_DCMT_NO            AS 계좌번호
         ,B.MRT_NO                 AS 담보번호
         ,C.WRGR_NO                AS 보증서번호
         ,C.PBLC_ISTT_NM           AS 발행기관명
         ,C.EVL_AMT                AS 평가금액
INTO       #보증서담보
FROM      DWZOWN.TB_SOR_CLM_CLN_LNK_TR   A                -- SOR_CLM_여신연결내역
         ,DWZOWN.TB_SOR_CLM_STUP_BC      B                -- SOR_CLM_설정기본
         ,DWZOWN.TB_SOR_CLM_WRGR_MRT_BC  C                -- SOR_CLM_보증서담보기본
WHERE    1=1
AND      A.CLN_APC_NO IN ( SELECT CLN_APC_NO FROM #모집단)
AND      A.CLN_LNK_STCD = '02'                            -- 여신연결상태코드(02:정상등록)
AND      A.ACN_DCMT_NO  > ' '                             -- 계좌식별번호
AND      B.MRT_TPCD     = '5'                             -- 담보유형코드(5:보증서)
AND      C.MRT_STCD     = '02'                            -- 담보상태코드(02:정상등록)
AND      A.STUP_NO      = B.STUP_NO                       -- 설정번호
AND      B.MRT_NO       = C.MRT_NO                        -- 담보번호
;

-- 월별테이블 이용
SELECT      T.기준일자
           ,A.CLN_APC_NO             AS 여신신청번호
           ,A.ACN_DCMT_NO            AS 계좌번호
           ,B.MRT_NO                 AS 담보번호
           ,B.ENR_DT                 AS 등록일자
           ,C.MRT_CD                 AS 담보코드
           ,C.WRGR_NO                AS 보증서번호
           ,C.GRN_RT                 AS 보증비율
           ,C.PBLC_ISTT_NM           AS 발행기관명
           ,C.EVL_AMT                AS 평가금액
           ,ROW_NUMBER() OVER(PARTITION BY T.기준일자,A.ACN_DCMT_NO ORDER BY B.ENR_DT DESC,C.GRN_RT ASC) AS 설정순서
  --한계좌가 신보, 기보 둘다를 가지고 있는 경우도 있고(20121231년도 1건) 기보나 신보를 담보로 여러개 붙어있는 경우가 있음
  --최근설정한건을 우선시하고 설정일자가 동일할경우 보증비율이 낮은걸로 하나를 취하기로 함 -- 이병복과 협의
  --보증비율이 낮은걸 취하는 이유는 100%, 95% 이면 전액보증이라고 볼수없으므로 낮은 보증비율을 취하기로함

INTO        #보증서담보 -- DROP TABLE  #보증서담보

FROM        #모집단_기업여신    T

JOIN        DWZOWN.TT_SOR_CLM_MM_CLN_LNK_TR   A                    -- SOR_CLM_월여신연결내역
            ON   LEFT(T.기준일자,6)  =  A.STD_YM
            AND  T.통합계좌번호      =  A.ACN_DCMT_NO
            AND  A.CLN_LNK_STCD      = '02'                        -- 여신연결상태코드(02:정상등록)
            AND  A.ACN_DCMT_NO       > ' '                         -- 계좌식별번호

JOIN        DWZOWN.TT_SOR_CLM_MM_STUP_BC      B                   -- SOR_CLM_설정기본
            ON   A.STD_YM       = B.STD_YM
            AND  A.STUP_NO      = B.STUP_NO                       -- 설정번호
            AND  B.MRT_TPCD     = '5'                             -- 담보유형코드(5:보증서)
            AND  B.STUP_STCD    IN ('02','03')                    --설정상태코드(02:정상등록,03:해지예정)

JOIN        DWZOWN.TT_SOR_CLM_MM_WRGR_MRT_BC  C                   -- SOR_CLM_보증서담보기본
            ON   B.STD_YM       = C.STD_YM
            AND  B.MRT_NO       = C.MRT_NO                        -- 담보번호
            AND  C.MRT_STCD     = '02'                            -- 담보상태코드(02:정상등록)
            AND  C.MRT_CD       IN  ('501','502','503','517','504','505','506')   -- 신용보증기금보증서 및 기술신용보증서

WHERE       1=1
;

JOIN         #보증서담보        B
             ON     A.기준일자        =    B.기준일자
             AND    A.통합계좌번호    =    B.계좌번호
             AND    B.설정순서        =    1

//}

//{ #경영13
--경영13과 동일모집단
--여신정책실(20141103)_대출금차주수계좌수.SQL
//}

//{ #일반 #수산 #정책 #연안선박 #온렌딩 #여신사업부  #대출금구분  #센터이관
           ,CASE WHEN   A.FRPP_KDCD IN ('2')  AND  A.PRD_BRND_CD =  '5025' AND A.LN_SBCD IN ('369','370')  THEN '4. 온렌딩'
--                 WHEN A.FRPP_KDCD   IN ('2')  AND  A.PDCD  IN  ( '20387500100001','20387500200001')        THEN '5. 연안선박'
                 WHEN   A.FRPP_KDCD IN ('2')                                                               THEN '3. 정책'
                 WHEN  (A.BS_ACSB_CD IN ('17005211',                        --기타금융시설자금대출
                                         '17002811')) THEN                  --기타금융운전자금대출
                        CASE WHEN A.PRD_BRND_CD IN ('1085',                 --사랑해대출
                                                    '1026',                 --서울시경영안정자금대출
                                                    '1029',                 --정부지방자치단체협약대출
                                                    '1116',                 --중소기업진흥공단대출
                                                    '1132',                 --경기도지자체중소기업육성자금대출
                                                    '1140',                 --소상공인지원자금대출
                                                    '1150',                 --소상공인전환대출
                                                    '1028',                 --추가 2016.08.18
                                                    '1155') THEN '3. 정책'  --추가 2016.08.18
                             ELSE                                '2. 수산'
                        END
                 WHEN A.BS_ACSB_CD  IN ('17010111','17010211')   THEN  '2. 수산'  -- 수산해양일반운전자금대출, 수산해양일반시설자금대출
                 WHEN A.PDCD        IN ('20001100603001','20803100603001','20001100604001') THEN '2. 수산' --농신보PLUS대출 201807신규반영
                 WHEN A.LN_MKTG_DSCD IS NOT NULL                 THEN  '6. 해투부'
                 ELSE '1. 일반'
            END                                      AS   대출금구분

-- 분류방법 또다른 하나 참고
               ,CASE WHEN A.FRPP_KDCD    = '2'  AND A.PRD_BRND_CD ='5025'  AND A.LN_SBCD IN ('369','370')  THEN '온렌딩대출'
                     WHEN A.FRPP_KDCD    = '2'                THEN '4.정책'
                     WHEN A.BS_ACSB_CD   = '14000711'         THEN '6.은행간대여금'
                     WHEN A.LN_MKTG_DSCD IS NOT NULL          THEN '3.해투'  --대출마케팅구분코드
                     WHEN B.ACSB_NM      LIKE '%기타%'        THEN '5.수산'
                     WHEN A.BRNO         IN ('0018','0178','0204','0304','0404','0542','0602','0804','0805','0909')    THEN '2.이관'
                     ELSE '1.고객'
                     END                    AS 구분

-- 이관채권 분류(UP_DWZ_여신_N0051_고객대출현황_자금별 중 일부)
                  WHEN J.LST_MVN_BRNO IN ('0018','0178','0204','0304','0404','0542','0602','0804','0805','0909')  OR  -- 여신관리팀, 여신관리센터
                       ( J.LST_MVN_BRNO = '0090'  AND  A.LN_MKTG_DSCD IS NULL)                                        -- 여신관리부(투자금융관리)
                                                            -- 해투부여신이 아닌여신중에 0090으로 넘어가는 여신만 여신사업부에서는 관심있음
                        THEN '2.이관'

//}

//{ #모계정 #세부계정
  AND    A.ACSB_CD  IN  (    SELECT   RLT_ACSB_CD
                                         FROM     DWZOWN.OT_DWA_DD_ACSB_BC            -- (DWA_일계정과목기본)
                                         WHERE    STD_DT  = '20141202'
                                         AND      FSC_SNCD IN ('K','C')
                                         AND      ACSB_CD in ('13001508')                -- 외화예수금계정
                                    )

//}

//{ #신금리 #여신금리 #승인기본
--신금리시스템 데이터는 여신신청번호가 키 이므로 계좌번호를 연결하기 위해서 여신승인기본과 join  하면 편리하다.
--승인내역중 최종승인내역등을 구하려면 참조프로그램인 ""여신사업부(20141118)_금융중개지원대출실적자료.SQL""
--를 참조할것.

SELECT    A.CLN_APC_NO
         ,A.APCL_DSCD
         ,A.TOT_STD_IRT
         ,A.TOT_ADD_IRT
         ,C.ACN_DCMT_NO        AS 계좌번호
         ,C.CUST_NO            AS 고객번호
         ,C.CLN_APRV_NO        AS 여신승인번호
         ,C.APRV_DT            AS 승인일자
         ,C.CLN_APC_NO         AS 여신신청번호
         ,C.CLN_APRV_LDGR_STCD AS 승인원장상태코드
         ,C.NFFC_UNN_DSCD      AS 중앙회조합구분
INTO      #TEMP_금리승인_1    -- DROP TABLE #TEMP_금리승인_1
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

--        여신승인기본은 승인번호가 키 이지만 원장상태코드(10:승인,20:약정,21:실행완료)만 조건걸어주면 여신신청번호가 유니크 하다
JOIN      TB_SOR_CLI_CLN_APRV_BC      C         --  SOR_CLI_여신승인기본
          ON   A.CLN_APC_NO  =  C.CLN_APC_NO
          AND  C.CLN_APRV_LDGR_STCD IN ('10','20','21')   --여신승인원장상태코드(10:승인,20:약정,21:실행완료)
          AND  C.NFFC_UNN_DSCD       = '1'                --중앙회조합구분코드(1:중앙회)
;

//}

//{ #자금용도 #개인여신

-- CASE 1 : 신규시 자금용도
LEFT OUTER JOIN
           (
             SELECT   DISTINCT
                      A.CLN_ACNO       AS 계좌번호          --계좌의 자금용도를 찾아온다.
                     ,A.CUST_NO        AS 고객번호
                     ,A.FND_USCD      AS 자금용도코드
                     ,C.CMN_CD_NM      AS 자금용도
             FROM     TB_SOR_PLI_CLN_APC_BC  A             --SOR_PLI_여신신청기본
                     ,TB_SOR_PLI_SYS_JUD_RSLT_TR  B        --SOR_PLI_시스템심사결과내역
                     ,(
                        SELECT    CMN_CD
                                 ,CMN_CD_NM
                        FROM      OM_DWA_CMN_CD_BC
                        WHERE     TPCD_NO_EN_NM = 'FND_USCD'
                        AND       CMN_CD_US_YN = 'Y'
                       ) C
             WHERE    A.CLN_APC_PGRS_STCD  IN ('03','04')  --여신신청진행상태코드(03:결재완료, 04:실행완료)
             AND      A.CLN_APC_DSCD       = '01'          --여신신청구분코드(01:신규)
             AND      A.NFFC_UNN_DSCD      = '1'           --중앙회조합구분코드
             AND      A.CLN_APC_NO         = B.CLN_APC_NO
             AND      A.CUST_NO            = B.CUST_NO
             AND      A.FND_USCD           *= C.CMN_CD
             AND      A.FND_USCD           IS NOT NULL
            ) C
            ON     A.INTG_ACNO  =  C.계좌번호

-- CASE 2: 가장 최근 자금용도코드가 들어온 신청건에 따른 자금용도
SELECT      DISTINCT
            TA.CLN_ACNO
           ,TA.FND_USCD
INTO        #자금용도    -- DROP TABLE #자금용도
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC     TA
           ,(SELECT   CLN_ACNO                                                  --여신계좌번호
                     ,MAX(CLN_APC_NO) AS CLN_APC_NO                             --여신신청번호
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC
             WHERE    FND_USCD IS NOT NULL                    -- 자금용도코드가 들어 있는 가장최근 신청건
             GROUP BY CLN_ACNO
            )                                TB
WHERE       TA.CLN_APC_NO = TB.CLN_APC_NO
;

SELECT
           ,CASE ISNULL(D.FND_USCD, '10') WHEN '01'  THEN '12'    --구자금용도코드-신자금용도코드 매핑
                                          WHEN '02'  THEN '16'
                                          WHEN '03'  THEN '21'
                                          WHEN '04'  THEN '23'
                                          WHEN '05'  THEN '10'
                                          WHEN '06'  THEN '19'
                                          WHEN '07'  THEN '22'
                                          WHEN '08'  THEN '10'
                                          WHEN '09'  THEN '10'
                                          ELSE ISNULL(D.FND_USCD, '10')  END    AS 자금용도코드변환

           ,CASE WHEN 자금용도코드변환  = '10'                      THEN  'C. 기타'
                 WHEN 자금용도코드변환  IN  ('11','12','13','14')   THEN  '1. 주택구입'
                 WHEN 자금용도코드변환  = '15'   THEN  '2. 전세자금반환용'
                 WHEN 자금용도코드변환  = '16'   THEN  '3. 주택임차(전월세)'
                 WHEN 자금용도코드변환  = '17'   THEN  '4. 주택신축 및 개량'
                 WHEN 자금용도코드변환  = '18'   THEN  '5. 생계자금'
                 WHEN 자금용도코드변환  = '19'   THEN  '6. 내구소비재 구입자금'
                 WHEN 자금용도코드변환  = '20'   THEN  '7. 학자금'
                 WHEN 자금용도코드변환  = '21'   THEN  '8. 사업자금'
                 WHEN 자금용도코드변환  = '22'   THEN  '9. 투자자금'
                 WHEN 자금용도코드변환  = '23'   THEN  'A. 기차입금 상환자금'
                 WHEN 자금용도코드변환  = '24'   THEN  'B. 공과금 및 세금납부'
                 ELSE 'C. 기타'
            END                     AS  자금용도코드_보고서용

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A       --DWA_통합여신기본

LEFT OUTER JOIN
            #자금용도   D
            ON       A.INTG_ACNO =  D.CLN_ACNO


//}

//{  #매출액
SELECT   A.*
INTO     #매출액  -- DROP TABLE #매출액
FROM    (SELECT   A.KIS_BZNS_CD        AS 업체코드
                ,A.SOA_MM             AS 결산월
                ,A.BRN                AS 사업자등록번호
                ,ISNULL(B.SOA_DT, '00000000')  AS 결산일자
                ,SUM(CASE WHEN B.KIS_REPT_CD = '12' AND B.KIS_FNST_HDN_CD_NM = '1000'  THEN B.KIS_FNST_AMT ELSE 0 END)  AS 매출액  -- 단위는 1000원
                ,ROW_NUMBER() OVER(PARTITION BY  A.BRN ORDER BY B.SOA_DT  DESC) AS 결산순서
        FROM     TB_SOR_CCR_KIS_BZNS_BC   A   --SOR_CCR_KIS업체개요기본
                ,TB_SOR_CCR_KIS_FNST_TR   B   --SOR_CCR_KIS재무제표내역
        WHERE    A.KIS_BZNS_CD        *= B.KIS_BZNS_CD
        AND      B.KIS_FNST_SOA_DSCD   = 'K'            --한국신용평가재무제표결산구분코드(K:결산)
        AND      B.KIS_REPT_CD         = '12'           --한국신용평가보고서코드(11:BS)
        AND      B.KIS_FNST_HDN_CD_NM  = '1000'         --한국신용평가재무제표항목코드명(5000:총자산)
        AND      ISNULL(B.SOA_DT, '00000000') <= '20141231'
        AND      A.BRN     IN (SELECT DISTINCT 실명번호  FROM #TEMP_기본여신)
        GROUP BY A.KIS_BZNS_CD
                ,A.SOA_MM
                ,A.BRN
                ,B.SOA_DT
        ) A
WHERE    A.결산순서 = 1
;



-- KIS 데이터말고 신용평가서상의 매출액
SELECT      A.*
           ,B.결산일자
           ,B.재무제표금액

FROM        #모집단     A

LEFT OUTER JOIN
            (             -- 승인시 최근2개년간 영업활동후현금흐름 연속음수 기업만 발췌
             SELECT      A.신용평가번호
             --           ,B.RNNO
             --           ,B.HIS_SNO
                        ,C.SOA_DT    AS  결산일자
                        ,C.FNST_AMT  AS  재무제표금액
             --           ,C.CMPS_RT   AS  구성비율
             --           ,C.INDC_RT   AS  증감비율
             --           ,D.CRDT_EVL_MODL_DSCD       AS 신용평가모형구분코드
             --           ,E.CRDT_EVL_INDS_CLSF_CD     AS 산업분류코드
                        ,ROW_NUMBER() OVER(PARTITION BY  A.신용평가번호 ORDER BY 결산일자  DESC) AS 결산순서
             FROM
                         ( SELECT  DISTINCT 신용평가번호 FROM  #모집단  ) A

             JOIN        TB_SOR_CCR_EVL_FNFR_CTL_TR    B           -- SOR_CCR_평가재무목록내역
                         ON   A.신용평가번호   = B.CRDT_EVL_NO

             JOIN        TB_SOR_CCR_FNST_HT            C           -- SOR_CCR_재무제표이력
                         ON   B.RNNO     =   C.RNNO
                         AND  B.HIS_SNO  =   C.HIS_SNO
                         AND  B.SOA_DT   =   C.SOA_DT
                         AND  C.FNST_REPT_CD = '12'                -- 12.1000  매출액
                         AND  C.FNST_HDCD = '1000'
            )   B
            ON   A.신용평가번호  = B.신용평가번호
            AND  B.결산순서   =  1
ORDER BY    1;

//}

//{  #이익기여도 #EL반영후손익 #종수 #수입이자 #업무원가 #수입수수료 #지급이자 #지급수수료
--고객의 이익기여도 평가값으로 종수데이터 EL반영후손익을 사용할 경우 사용

--  #TEMP_기본여신 에 종통이 있으면 종통은 대출계좌만 해야 하므로 아래 조건을 추가해야 함
--  =====================================================
--  AND         LEFT(A.계정과목코드,1) = '1'
--  =====================================================

SELECT A.고객번호,SUM(A.월중예상손실금액) AS 월중예상손실금액 ,SUM(A.EL반영후손익) AS EL반영후손익
INTO   #이익기여도        --  DROP TABLE #이익기여도
FROM   XOT_BPAT계좌수익성MASTER   A
WHERE  작업기준년월 BETWEEN '201401' AND '201412'
AND    A.고객번호  IN ( SELECT DISTINCT 고객번호 FROM #TEMP_기본여신)
GROUP BY A.고객번호
;

SELECT      CASE WHEN  A.작업기준년월 BETWEEN '201401' AND '201412'  THEN '20141231'
                 WHEN  A.작업기준년월 BETWEEN '201501' AND '201503'  THEN '20150331'
                 ELSE  '99999999'
            END  기준일자
           ,A.계좌번호
           ,SUM(A.수입이자) AS 수입이자
           ,SUM(A.지급이자) AS 지급이자
           ,SUM(A.지급보증료 + A.자점수수료 + A.NET수수료 + A.외환매매익 + A.중도상환수수료 + A.공제수익 + A.신탁보수 + A.기타사업수익)  AS 지급수수료
           ,SUM(A.지급수수료 + A.공제비용 + A.기타사업비용)  AS 수입수수료
           ,SUM(A.업무원가반영전손익)   AS 업무원가반영전손익
           ,SUM(A.업무원가반영후손익)   AS 업무원가번영후손익
INTO        #종수        --  DROP TABLE #종수
FROM        XOT_BPAT계좌수익성MASTER   A
WHERE       A.작업기준년월 BETWEEN '201401' AND '201503'
AND         A.계좌번호  IN ( SELECT DISTINCT 통합계좌번호 FROM #TEMP)
--  AND         LEFT(A.계정과목코드,1) = '1'           -- 종통의 경우 대출계정 발생분만 가지고 처리..
GROUP BY    기준일자,A.계좌번호
;
//}

//{  #CRS등급매핑  #CRS등급 #기업신용평가등급
--통합여신 및 평가정보(SOR_CCR_평가정보내역) 의 CRS등급을 사용하려면 매핑작업이 필요하다,
--과거등급체계와 현재등급체계가 혼재되어 있어 현재등급체계로 일원화시기키 위함
--1. 기본적매핑
               ,CASE WHEN A.ENTP_CRGR_JUD_DT < '20080728' AND A.BR_DSCD = '1'  --중앙회
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
                     WHEN A.ENTP_CRGR_JUD_DT < '20080728' AND A.BR_DSCD = '2'  --조합
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
                           AND A.BR_DSCD = '1'  --중앙회
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
                                                    WHEN '8'   THEN '7A'   -- 8     7A(7B) --7B없음
                                                    WHEN '9'   THEN '8'    -- 9     8
                                                    WHEN '10A' THEN '9'    -- 10A   9
                                                    WHEN '10B' THEN '10'   -- 10B   10
                          END
                     WHEN (A.ENTP_CRGR_JUD_DT BETWEEN '20080728' AND '20120812'  OR
                           ISDATE(A.ENTP_CRGR_JUD_DT) = 0)
                           AND A.BR_DSCD = '2'  --조합
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
                     ELSE A.ENTP_CREV_GD --20120813 이후
                END                                    AS 기업신용평가등급

-- CRS 등급은 15등급체계이자만 'A','B' 등의 문자등을 제외하고 10등급으로 분류를 원하는 경우사용
--2. 기본적매핑한것을 10등급으로 출력하는 경우
                  ,CASE WHEN 기업신용평가등급  IN  ('1','01','1A','1B')  THEN  '01'
                        WHEN 기업신용평가등급  IN  ('2','02','2A','2B')  THEN  '02'
                        WHEN 기업신용평가등급  IN  ('3','03','3-','3+','3A','3B')  THEN  '03'
                        WHEN 기업신용평가등급  IN  ('4','04','4-','4+','4A','4B')  THEN  '04'
                        WHEN 기업신용평가등급  IN  ('5','05','5+','5-','5A','5B')  THEN  '05'
                        WHEN 기업신용평가등급  IN  ('6','06','6+','6-','6A','6B')  THEN  '06'
                        WHEN 기업신용평가등급  IN  ('7','07','7+','7-','7A','7B')  THEN  '07'
                        WHEN 기업신용평가등급  IN  ('8','08','8A','8B')  THEN  '08'
                        WHEN 기업신용평가등급  IN  ('9','09','9A','9B')  THEN  '09'
                        WHEN 기업신용평가등급  =    '10'                 THEN  '10'
                        WHEN 기업신용평가등급  IS NULL OR  기업신용평가등급 IN  ('0','11','')         THEN  '99'
                        ELSE 기업신용평가등급
                   END                        AS  기업신용평가등급2


//}

//{  #소호 #CRS등급 #SOHO  #모형구분34포함

-- 1.  소호모형까지 포함하여 최근 crs등급 구하기
LEFT OUTER JOIN
            (
            -- 통합여신은 모형구분 34(SOHO 모형)는 제외한 최근 신용평가등급이 들어 있고
            -- 승인번호를 이용하여 평가내역을 가져오면 평가내역이 비어있는 경우가 다수 발생함
            -- 현업요건이 모형구분 34를 포함한 평가등급을 원하므로 통합여신에 CRS 등급 세팅하는 부분을 도용하여
            -- 모형구분 34를 포함시키는 형태로 쿼리작성함
            -- 이 쿼리는 약간의 문제를 포함하고 있슴

                   SELECT   TA.NFFC_UNN_DSCD        AS NFFC_UNN_DSCD
                           ,CASE WHEN TRIM(TA.RPST_RNNO) IS NOT NULL AND
                                      TRIM(TA.RPST_RNNO) <> ''       THEN
                                      TRIM(TA.RPST_RNNO)
                                 ELSE
                                      TRIM(TA.RNNO)
                            END                     AS RNNO
                           ,TA.LST_ADJ_GD           AS ENTP_CREV_GD
                           ,TA.CMPL_DT              AS ENTP_CRGR_JUD_DT
                           ,TA.CRDT_EVL_MODL_DSCD   AS 기업신용평가모형구분코드  -- 모형구분 추가 : 20120823 장상진
                           ,TC.ENTP_OPPB_DSCD       AS ENTP_OPPB_DSCD      -- 기업공개구분코드
                           ,TD.CUST_NO              AS CUST_NO
                           ,TA.ENTP_SCL_DTL_DSCD    AS ENTP_SCL_DTL_DSCD   -- 기업규모상세구분코드 : 2014.01.24 안지원
                           ,TA.EVL_AVL_DT           AS EVL_AVL_DT          -- 평가유효일자 : 2014.01.24 안지원
                   FROM     DWZOWN.TB_SOR_CCR_EVL_INF_TR       TA  --SOR_CCR_평가정보내역
                           ,(SELECT   NFFC_UNN_DSCD                        -- 중앙회조합구분코드
                                     ,CASE WHEN TRIM(RPST_RNNO) IS NOT NULL AND
                                                TRIM(RPST_RNNO) <> ''       THEN
                                                TRIM(RPST_RNNO)
                                           ELSE
                                                TRIM(RNNO)
                                      END              AS RNNO
                                     ,MAX(CRDT_EVL_NO) AS CRDT_EVL_NO      -- 최종 신용평가번호
                             FROM     DWZOWN.TB_SOR_CCR_EVL_INF_TR   --SOR_CCR_평가정보내역
                             WHERE    CRDT_EVL_PGRS_STCD  = '2'            -- 신용평가진행상태코드'2'평가완료
                             AND      CRDT_EVL_OMT_DSCD   = '02'           -- '01'생략대상,'02'생략비대상: 이 요건 필수
                             AND      CMPL_DT            <= '20141231'
            --               AND      CRDT_EVL_MODL_DSCD <> '34'           -- 모형구분 34(CSS등급)
                             AND      BRNO               <> '0288'         -- 조합자금부 취급여신 제외
                             GROUP BY NFFC_UNN_DSCD,RNNO)      TB
                           ,DWZOWN.TB_SOR_CCR_EVL_BZNS_OTL_TR  TC  --SOR_CCR_평가업체개요내역
                           ,DWZOWN.TB_SOR_CUS_MAS_BC           TD  --SOR_CUS_고객기본
                   WHERE    TA.NFFC_UNN_DSCD      = TB.NFFC_UNN_DSCD
                   AND      TA.BRNO              <> '0288'                 -- 조합자금부 취급여신 제외
                   AND      TA.CRDT_EVL_OMT_DSCD  = '02'                   -- '01'생략대상,'02'생략비대상(신용평가생략구분코드): 이 요건 필수
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

                   AND     TA.NFFC_UNN_DSCD  =  '1'                -- 중앙회  이것없으면 실명번호별로 중복난다.
            )      T
            ON     A.RNNO   =  T.RNNO


-- 2.  기준시점이 다른 여러계좌의 각 시점별  crs등급(소호모형까지 포함)구하기, 통합여신은 soho모형은 포함하지 않는다
SELECT      A.NFFC_UNN_DSCD                        -- 중앙회조합구분코드
           ,CASE WHEN TRIM(A.RPST_RNNO) IS NOT NULL AND
                      TRIM(A.RPST_RNNO) <> ''       THEN
                      TRIM(A.RPST_RNNO)
                 ELSE
                      TRIM(A.RNNO)
            END                AS RNNO
           ,A.CMPL_DT          AS CMPL_DT
           ,MAX(A.CRDT_EVL_NO) AS CRDT_EVL_NO      -- 최종 신용평가번호
           ,ROW_NUMBER() OVER (PARTITION BY A.NFFC_UNN_DSCD,RNNO ORDER BY CMPL_DT ASC) AS SEQ
INTO        #평가히스토리  -- DROP TABLE   #평가히스토리
FROM        DWZOWN.TB_SOR_CCR_EVL_INF_TR  A      --SOR_CCR_평가정보내역
WHERE       A.CRDT_EVL_PGRS_STCD  = '2'            -- 신용평가진행상태코드'2'평가완료
AND         A.CRDT_EVL_OMT_DSCD   = '02'           -- '01'생략대상,'02'생략비대상: 이 요건 필수
--               AND      CRDT_EVL_MODL_DSCD <> '34'           -- 모형구분 34(CSS등급)
AND         A.BRNO               <> '0288'         -- 조합자금부 취급여신 제외
AND         A.NFFC_UNN_DSCD       =  '1'           -- 중앙회  이것없으면 실명번호별로 중복난다.
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
                                                WHEN '8'   THEN '7A'   -- 8     7A(7B) --7B없음
                                                WHEN '9'   THEN '8'    -- 9     8
                                                WHEN '10A' THEN '9'    -- 10A   9
                                                WHEN '10B' THEN '10'   -- 10B   10
                      END
                 ELSE B.LST_ADJ_GD --20120813 이후
            END                                    AS 기업신용평가등급

INTO        #평가정보  -- DROP TABLE #평가정보

FROM        (
             SELECT      A.NFFC_UNN_DSCD
                        ,A.RNNO
                        ,A.SEQ
                        ,A.CMPL_DT                                     AS 평가적용시작일
                        ,CASE WHEN B.CMPL_DT IS NULL THEN '99999999'
                              ELSE DATEFORMAT(DATE(B.CMPL_DT)-1,'YYYYMMDD')
                         END                                           AS 평가적용종료일
                        ,A.CRDT_EVL_NO
--             INTO        #평가히스토리_구간  -- DROP TABLE #평가히스토리_구간
             FROM        #평가히스토리   A
             LEFT OUTER JOIN
                         #평가히스토리   B
                         ON   A.NFFC_UNN_DSCD  = B.NFFC_UNN_DSCD
                         AND  A.RNNO           = B.RNNO
                         AND  A.SEQ + 1        = B.SEQ
            )      A

JOIN        DWZOWN.TB_SOR_CCR_EVL_INF_TR  B
            ON  A.CRDT_EVL_NO  = B.CRDT_EVL_NO
;

SELECT
           ,CASE WHEN BB.ENTP_CRGR_JUD_DT < '20080728' AND A.BR_DSCD = '1'  --중앙회
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
                 WHEN BB.ENTP_CRGR_JUD_DT < '20080728' AND A.BR_DSCD = '2'  --조합
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
                       AND A.BR_DSCD = '1'  --중앙회
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
                                                WHEN '8'   THEN '7A'   -- 8     7A(7B) --7B없음
                                                WHEN '9'   THEN '8'    -- 9     8
                                                WHEN '10A' THEN '9'    -- 10A   9
                                                WHEN '10B' THEN '10'   -- 10B   10
                      END
                 WHEN (BB.ENTP_CRGR_JUD_DT BETWEEN '20080728' AND '20120812'  OR
                       ISDATE(BB.ENTP_CRGR_JUD_DT) = 0)
                       AND A.BR_DSCD = '2'  --조합
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
                 ELSE BB.ENTP_CREV_GD --20120813 이후
            END                                    AS 기업신용평가등급

FROM        #최초계좌정보            A

LEFT OUTER JOIN
            #평가정보     BB
            ON   A.RNNO      =   BB.RNNO
            AND  A.STD_DT   BETWEEN  BB.평가적용시작일 AND  BB.평가적용종료일

-- 3.  기존의 crs등급가져오는 부분에 약간의 문제가 있어 이를 보완한 로직, 완전한 테스트를 하지 못했다
-- 대표실명번호(RPST_RNNO)를 우선이용하도록한 위 쿼리는 공공자금이 개인명의로 대출이 나가고 평가정보는 사업자번호로 들어있는 경우가
-- 많아서 이를 해결하기 위한 조처이나
-- 공공자금중 사업자명의로 대출이 나간경우 평가정보의 대표실명번호(RPST_RNNO) 와 죠인하면 죠인이 안되는 경우가 있음
-- 아래와 같이 모집단생성후에 update 문장으로 평가등급을 추가로 가져오는 방법을 이용함

UPDATE      #원화대출금   A
SET         A.기업신용평가등급 = B.ENTP_CREV_GD
FROM        (
              SELECT      TA.NFFC_UNN_DSCD        AS NFFC_UNN_DSCD
                         ,TA.RNNO                 AS RNNO
                         ,TA.RPST_RNNO            AS RPST_RNNO
                         ,TB.실명번호             AS 실명번호
                         ,TA.LST_ADJ_GD           AS ENTP_CREV_GD
                         ,TA.CMPL_DT              AS ENTP_CRGR_JUD_DT
                         ,TA.CRDT_EVL_MODL_DSCD   AS 기업신용평가모형구분코드  -- 모형구분 추가 : 20120823 장상진
                         ,TC.ENTP_OPPB_DSCD       AS ENTP_OPPB_DSCD      -- 기업공개구분코드
                         ,TD.CUST_NO              AS CUST_NO
                         ,TA.ENTP_SCL_DTL_DSCD    AS ENTP_SCL_DTL_DSCD   -- 기업규모상세구분코드 : 2014.01.24 안지원
                         ,TA.EVL_AVL_DT           AS EVL_AVL_DT          -- 평가유효일자 : 2014.01.24 안지원
              FROM        DWZOWN.TB_SOR_CCR_EVL_INF_TR       TA            --SOR_CCR_평가정보내역
                         ,(SELECT   A.NFFC_UNN_DSCD                        -- 중앙회조합구분코드
                                   ,A.RNNO
                                   ,A.RPST_RNNO
                                   ,B.실명번호
                                   ,MAX(A.CRDT_EVL_NO) AS CRDT_EVL_NO      -- 최종 신용평가번호
                           FROM     DWZOWN.TB_SOR_CCR_EVL_INF_TR   A       -- SOR_CCR_평가정보내역
                           JOIN     (SELECT  DISTINCT 실명번호 FROM #원화대출금)   B
                                  ON  CASE WHEN LENGTH(TRIM(B.실명번호)) < 13 THEN A.RNNO ELSE A.RPST_RNNO END = B.실명번호

                           WHERE    A.CRDT_EVL_PGRS_STCD  = '2'            -- 신용평가진행상태코드'2'평가완료
                           AND      A.CRDT_EVL_OMT_DSCD   = '02'           -- '01'생략대상,'02'생략비대상: 이 요건 필수
                           AND      A.CMPL_DT            <= '20160331'
--                         AND      A.CRDT_EVL_MODL_DSCD <> '34'             -- 모형구분 34(CSS등급)
                           AND      A.BRNO               <> '0288'         -- 조합자금부 취급여신 제외
                           GROUP BY A.NFFC_UNN_DSCD                        -- 중앙회조합구분코드
                                   ,A.RNNO
                                   ,A.RPST_RNNO
                                   ,B.실명번호
                          )      TB
                         ,DWZOWN.TB_SOR_CCR_EVL_BZNS_OTL_TR  TC  --SOR_CCR_평가업체개요내역
                         ,DWZOWN.TB_SOR_CUS_MAS_BC           TD  --SOR_CUS_고객기본
              WHERE       TA.NFFC_UNN_DSCD      = TB.NFFC_UNN_DSCD
              AND         TA.BRNO              <> '0288'                 -- 조합자금부 취급여신 제외
              AND         TA.CRDT_EVL_OMT_DSCD  = '02'                   -- '01'생략대상,'02'생략비대상(신용평가생략구분코드): 이 요건 필수
              AND         TA.CMPL_DT            <= '20160331'
              AND         TA.RNNO                = TB.RNNO
              AND         TA.CRDT_EVL_NO   = TB.CRDT_EVL_NO
              AND         TA.RNNO          = TC.RNNO
              AND         TA.CRDT_EVL_NO   = TC.CRDT_EVL_NO
              AND         TB.실명번호     *= TD.CUST_RNNO
              AND         TA.NFFC_UNN_DSCD  =  '1'                -- 중앙회  이것없으면 실명번호별로 중복난다.
            )   B
WHERE       1=1
AND         A.실명번호  = B.실명번호
;

-- CASE 4
SELECT      CASE WHEN  T.ENTP_CREV_GD IS NOT NULL THEN T.ENTP_CREV_GD           ELSE TT.ENTP_CREV_GD        END AS 기업신용평가등급_보충
           ,CASE WHEN  T.ENTP_CREV_GD IS NOT NULL THEN T.CRDT_EVL_MODL_DSCD     ELSE TT.CRDT_EVL_MODL_DSCD  END AS 기업신용평가모형_보충

LEFT OUTER JOIN
            (
            -- 일번적으로 SOR_CCR_평가정보내역에 RPST_RNNO 를 우선기준으로 평가정보를 가져와서 계좌원장의 차주와 JOIN 하여 평가등급을 구하지만
            -- 가끔은 RPST_RNNO에는 엉뚱한 실명번호가 있고 RNNO로 JOIN 해야 제대로 JOIN이 되는 경우가 있으므로
            -- 평가정보가 비어나오는 부분에 한해서 이 로직으로 보충한다

                   SELECT   TA.NFFC_UNN_DSCD        AS NFFC_UNN_DSCD
                           ,TRIM(TA.RNNO)           AS RNNO
                           ,TA.LST_ADJ_GD           AS ENTP_CREV_GD
                           ,TA.CMPL_DT              AS ENTP_CRGR_JUD_DT
                           ,TA.CRDT_EVL_MODL_DSCD   AS CRDT_EVL_MODL_DSCD  -- 모형구분 추가 : 20120823 장상진
                           ,TC.ENTP_OPPB_DSCD       AS ENTP_OPPB_DSCD      -- 기업공개구분코드
                           ,TD.CUST_NO              AS CUST_NO
                           ,TA.ENTP_SCL_DTL_DSCD    AS ENTP_SCL_DTL_DSCD   -- 기업규모상세구분코드 : 2014.01.24 안지원
                           ,TA.EVL_AVL_DT           AS EVL_AVL_DT          -- 평가유효일자 : 2014.01.24 안지원
                   FROM     DWZOWN.TB_SOR_CCR_EVL_INF_TR       TA  --SOR_CCR_평가정보내역
                           ,(SELECT   NFFC_UNN_DSCD                        -- 중앙회조합구분코드
                                     ,TRIM(TA.RNNO)    AS RNNO
                                     ,MAX(CRDT_EVL_NO) AS CRDT_EVL_NO      -- 최종 신용평가번호
                             FROM     DWZOWN.TB_SOR_CCR_EVL_INF_TR   --SOR_CCR_평가정보내역
                             WHERE    CRDT_EVL_PGRS_STCD  = '2'            -- 신용평가진행상태코드'2'평가완료
                             AND      CRDT_EVL_OMT_DSCD   = '02'           -- '01'생략대상,'02'생략비대상: 이 요건 필수
                             AND      CMPL_DT            <= '20160630'
            --               AND      CRDT_EVL_MODL_DSCD <> '34'           -- 모형구분 34(CSS등급)
                             AND      BRNO               <> '0288'         -- 조합자금부 취급여신 제외
                             GROUP BY NFFC_UNN_DSCD,RNNO)      TB
                           ,DWZOWN.TB_SOR_CCR_EVL_BZNS_OTL_TR  TC  --SOR_CCR_평가업체개요내역
                           ,DWZOWN.TB_SOR_CUS_MAS_BC           TD  --SOR_CUS_고객기본
                   WHERE    TA.NFFC_UNN_DSCD      = TB.NFFC_UNN_DSCD
                   AND      TA.BRNO              <> '0288'                 -- 조합자금부 취급여신 제외
                   AND      TA.CRDT_EVL_OMT_DSCD  = '02'                   -- '01'생략대상,'02'생략비대상(신용평가생략구분코드): 이 요건 필수
                   AND      TA.CMPL_DT           <= '20160630'
                   AND      TRIM(TA.RNNO)        = TB.RNNO
                   AND      TA.CRDT_EVL_NO       = TB.CRDT_EVL_NO
                   AND      TA.RNNO              = TC.RNNO
                   AND      TA.CRDT_EVL_NO       = TC.CRDT_EVL_NO
                   AND      TRIM(TA.RNNO)       *= TD.CUST_RNNO
                   AND      TA.NFFC_UNN_DSCD  =  '1'                -- 중앙회  이것없으면 실명번호별로 중복난다.
            )      TT
            ON     A.RNNO   =  TT.RNNO


//}

//{  #담보  #소재지  #담보소재지 #주택투기지역 #토지투기지역 #투기과열지구
--CASE1
               SELECT DISTINCT
                      C.ACN_DCMT_NO AS 계좌번호
                     ,CASE WHEN B.CCG_NM LIKE '%구미%'  THEN  '1. 구미'
                           WHEN B.CCG_NM LIKE '%평택%'  THEN  '2. 평택'
                           ELSE '3. 기타'
                       END   AS 담보물소재지구분
               FROM   TB_SOR_CLM_REST_MRT_BC B  -- SOR_CLM_부동산담보기본
                     ,TB_SOR_CLM_CLN_LNK_TR  C  -- 여신연결내역
                     ,TB_SOR_CLM_STUP_BC     D  -- SOR_CLM_설정내역
               WHERE  C.CLN_LNK_STCD = '02'     -- 여신연결상태코드 : 정상
               AND    C.STUP_NO      = D.STUP_NO
               AND    B.MRT_NO       = D.MRT_NO
               AND    (
                         B.CCG_NM IS NOT NULL AND (  B.CCG_NM LIKE '%구미%'  OR  B.CCG_NM LIKE '%평택%' )
                       )
--CASE2

      SELECT
           ,TRIM(T9.MPSD_NM) || ' ' || TRIM(T9.CCG_NM) || ' ' || TRIM(T9.EMD_NM) || ' ' || TRIM(T9.LINM) AS 담보소재지


      LEFT OUTER JOIN
                (
                   SELECT   A.여신계좌번호
                           ,A.MPSD_CD
                           ,A.CCG_CD
                           ,A.EMD_CD
                           ,A.LINM_CD
                           ,A.MPSD_NM          --광역시도명
                           ,A.CCG_NM           --시군구명
                           ,A.EMD_NM           --읍면동명
                           ,A.LINM             --리명
                           ,A.THG_SIT_DTL_ADR
                           ,ISNULL(B.MIN_SPCT_ARA_TPCD, '00')  AS SPCT_ARA_TPCD
                   FROM    (SELECT   B.CLN_APC_NO   AS 여신신청번호
                                    ,A.MRT_NO       AS 담보번호
                                    ,A.STUP_NO      AS 설정번호
                                    ,B.ACN_DCMT_NO  AS 여신계좌번호
                                    ,C.MPSD_CD
                                    ,C.CCG_CD
                                    ,C.EMD_CD
                                    ,C.LINM_CD
                                    ,C.MPSD_NM          --광역시도명
                                    ,C.CCG_NM           --시군구명
                                    ,C.EMD_NM           --읍면동명
                                    ,C.LINM             --리명
                                    ,C.THG_SIT_DTL_ADR  --물건소재지상세주소
                                    ,RANK() OVER (PARTITION BY B.ACN_DCMT_NO ORDER BY B.CLN_APC_NO, A.STUP_NO, A.MRT_NO) AS 대표_담보
                            FROM     TB_SOR_CLM_STUP_BC     A   --SOR_CLM_설정기본
                                    ,TB_SOR_CLM_CLN_LNK_TR  B   --SOR_CLM_여신연결내역
                                    ,TB_SOR_CLM_REST_MRT_BC C   --SOR_CLM_부동산담보기본
                            WHERE    A.NFFC_UNN_DSCD = '1'           --중앙회조합구분코드
                            AND      A.STUP_DT       <= P_기준일자
                            AND      A.STUP_STCD     = '02'            --설정상태코드(02:정상등록)
                            AND      A.STUP_NO       = B.STUP_NO        --설정번호
                            AND      B.ENR_DT        <= P_기준일자
                            AND      B.CLN_LNK_STCD  IN ('02','03')  --여신연결상태코드(02:정상,03:해지예정)
                            AND      A.MRT_NO        = C.MRT_NO
                            AND      C.MPSD_CD       IS NOT NULL
                            ) A
                          ,(SELECT   MPSD_CD
                                    ,CCG_CD
                                    ,EMD_CD
                                    ,LINM_CD
                                    ,MIN(SPCT_ARA_TPCD)  AS MIN_SPCT_ARA_TPCD  --MIN한 이유는 계정계에서 데이타 반영이 잘못되어 중복발생시 보수적으로 적용하기 위함
                            FROM     TB_SOR_CLM_SPCT_ARA_BC  --SOR_CLM_특수지역기본
                            WHERE    US_YN = 'Y'
                            AND      SPCT_ARA_TPCD IN ('01','02','03') --(01.주택투기지역 02.토지투기지역 03.투기과열지구)
                            GROUP BY MPSD_CD
                                    ,CCG_CD
                                    ,EMD_CD
                                    ,LINM_CD
                            ) B
                   WHERE    A.대표_담보 = 1
                   AND      A.MPSD_CD   *= B.MPSD_CD
                   AND      A.CCG_CD    *= B.CCG_CD
                   AND      A.EMD_CD    *= B.EMD_CD
                   AND      A.LINM_CD   *= B.LINM_CD
                )                                           T9
                ON   A.INTG_ACNO  = T9.여신계좌번호

-- CASE3 유효담보금액 가장 큰것한게
SELECT      C.STD_DT             AS 기준일자
           ,C.INTG_ACNO          AS 통합계좌번호
           ,C.MRT_CD             AS 담보코드
           ,C.MRT_NO             AS 담보번호
           ,MAX(C.APSL_AMT)      AS 감정금액
           ,MAX(C.ACWR_AVL_MRAM) AS 현실가치유효담보금액
           ,MAX(C.LQWR_AVL_MRAM) AS 청산가치유효담보금액
           ,MAX(C.PRRN_AMT)      AS 선순위금액
           ,MAX(C.ACF_RT)        AS 경락율
INTO        #담보물건  -- DROP TABLE #담보물건           
FROM        TB_SOR_CLM_MRT_APRT_EOM_TZ C -- SOR_CLM_채무자별담보배분월말집계
JOIN        (
             SELECT   STD_DT           AS  기준일자
                     ,INTG_ACNO        AS  통합계좌번호
                     ,MRT_NO           AS  담보번호
                     ,MRT_CD           AS  담보코드
                     ,MAX(STUP_NO)     AS  설정번호
             FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ --SOR_CLM_채무자별담보배분월말집계
             WHERE   1=1
             AND     MRT_APRT_TPCD  = '01' --담보배분유형코드
             AND     MRT_NO <> '999999999999'
             AND     STUP_NO <> '999999999999'
             ---------------------------------------------------------------------------------
             AND     STD_DT     =  '20180731'     -- 9월말 자료만 필요하므로
             AND     MRT_CD NOT IN ('601','602')  -- 인보증(601), 순수신용(602) 제외
             AND     NFM_YN     = 'N'             -- 견질담보여부
             AND     INTG_ACNO  IN (SELECT  통합계좌번호  FROM  #모집단)
             ---------------------------------------------------------------------------------
             GROUP BY 기준일자, 통합계좌번호, 담보번호, 담보코드
            ) D
            ON    C.STD_DT    = D.기준일자
            AND   C.INTG_ACNO = D.통합계좌번호 --AND C.INTG_ACNO = '101008338879'
            AND   C.MRT_NO    = D.담보번호
            AND   C.STUP_NO   = D.설정번호
            AND   C.MRT_CD    = D.담보코드
WHERE       1=1
AND         C.MRT_APRT_TPCD   = '01'
GROUP BY    C.STD_DT, C.INTG_ACNO, C.MRT_CD, C.MRT_NO
;

LEFT OUTER JOIN
            (
             SELECT      A.통합계좌번호
                        ,TRIM(B.MPSD_NM) || ' ' || TRIM(B.CCG_NM) || ' ' || TRIM(B.EMD_NM) || ' ' || TRIM(B.LINM) AS 담보소재지                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      
             FROM        (           
                          SELECT      A.기준일자
                                     ,A.통합계좌번호
                                     ,A.담보코드
                                     ,A.담보번호
                                     ,ROW_NUMBER(*) OVER(PARTITION BY  A.통합계좌번호 ORDER BY A.현실가치유효담보금액 DESC) AS RNUM
                          FROM        #담보물건   A
                         )   A
             JOIN        TB_SOR_CLM_REST_MRT_BC B  -- SOR_CLM_부동산담보기본       
                         ON   A.담보번호  = B.MRT_NO      
             WHERE       A.RNUM = 1
            )  C
            ON A.통합계좌번호  = C.통합계좌번호 

//}

//{  #ASS등급 #개인신용평가등급  #고객별ASS등급  #DAD
--ASS등급은 신청단에서 계좌별로 등급을 구할수 있다 통합여신에는 계좌별로 등급이 들어가 있다
--계좌별로 등급이 필요한 경우에는 통합여신을 사용하면 되나 고객별로 등급을 원하는 경우에는 부도정보에 있는
--TB_SOR_DAD_ISD_CRGR_TR(DAD_내부신용등급내역)의 ASS 등급을 사용할 수 있다

--1.통합여신에서 ASS 등급 가져오는 방법
--계좌별로 최종등급을 가져온다

             SELECT  TBB.CLN_ACNO, TBB.CLN_APC_NO, TBB.CUST_NO, TBB.HSGR_GRN_DSCD
                  --,CASE WHEN TRIM(TBA.FSR_ASS_GD) > '00' THEN
                  --           TRIM(TBA.FSR_ASS_GD)   --어업인ASS등급
                  --      ELSE TRIM(TBA.ASS_CRDT_GD)  --ASS신용등급
                  -- END  AS ASS_CRDT_GD
                    ,TRIM(TBA.ASS_CRDT_GD) AS ASS_CRDT_GD
                    ,TBA.DWUP_STD_DT                  --작성기준일자
             FROM    TB_SOR_PLI_SYS_JUD_RSLT_TR  TBA              --SOR_PLI_시스템심사결과내역
                    ,(--여신신청구분코드'01'신규,'07'상품특화대출(신규),'08'본부승인특화대출(신규),'09'본부승인(신규),'51'(채무인수), '02'(대환),'04'(불건전채권대환)
                      --'21'(증액)은 일단 대상에서 제외
                      --계좌번호, 고객번호별 발췌 : TB_PLI_SYS_JUD_RSLT_TR 에 한계좌,한신청번호에 고객번호 2개 있음
                      SELECT   TA.CLN_ACNO, TA.CLN_APC_NO, TB.CUST_NO, TB.HSGR_GRN_DSCD  --여기까지는 중복없음
                      FROM     (--
                                SELECT   A.CLN_ACNO
                                        ,MAX(B.CLN_APC_NO) AS CLN_APC_NO
                                FROM     TB_SOR_PLI_CLN_APC_BC       A   --SOR_PLI_여신신청기본
                                        ,TB_SOR_PLI_SYS_JUD_RSLT_TR  B   --SOR_PLI_시스템심사결과내역
                                WHERE    ((A.CLN_APC_PGRS_STCD = '04' AND A.CLN_APC_DSCD IN ('01','07','08','09', '02','04')) OR  --20120820
                                          (A.CLN_APC_PGRS_STCD = '13' AND A.CLN_APC_DSCD = '51'))  --채무인수
                                --20121017 : B.CSS_MODL_DSCD IS NULL 조건 필수
                                AND      (B.CSS_MODL_DSCD IS NULL OR B.CSS_MODL_DSCD IN ('31','32','34'))    -- CSS모형구분코드 30(CRS모형)제외 20120824 장상진
                                AND      A.CLN_APC_NO        = B.CLN_APC_NO
                                AND      A.CUST_NO = B.CUST_NO  --20121017 : 추가
                                --AND      B.DWUP_STD_DT <= '20120827'  --TEST 20120827일부터 수정용. 20120827 ~ 20121016까지 UPDATE 필요 함
                                --AND     (B.APC_ASSC > 0 OR B.FSR_APC_ASSC > 0) : 조건제외할것 -> TOBE에서는 적용하지 않음(계정계-신상문K답변)
                                GROUP BY A.CLN_ACNO
                               )                         TA
                              ,TB_SOR_PLI_CLN_APC_BC     TB   --SOR_PLI_여신신청기본
                      WHERE    1=1
                      --AND      TA.CLN_ACNO          = TB.CLN_ACNO  --20121017 : 계좌번호 JOIN 필요 없음. 아래 신청번호만 JOIN 할 것(신상문)
                      AND      TA.CLN_APC_NO        = TB.CLN_APC_NO
                      AND      ((TB.CLN_APC_PGRS_STCD = '04' AND TB.CLN_APC_DSCD IN ('01','07','08','09', '02','04')) OR  --20120820
                                (TB.CLN_APC_PGRS_STCD = '13' AND TB.CLN_APC_DSCD = '51'))  --채무인수
                     )                           TBB
             WHERE    TBA.CLN_APC_NO        = TBB.CLN_APC_NO
             AND      TBA.CUST_NO           = TBB.CUST_NO


--2.DAD_내부신용등급내역  에서 ASS 등급 가져오는 방법
-- 고객별 최종신청번호에 해당하는 등급을 가져옴
       SELECT  V_기준일자
              ,C.CUST_RNNO                                       /* 실명번호             */
              ,B.NFFC_UNN_DSCD                                   /* 점구분코드           */
              ,'00000000'                                        /* 신용평가일자         */
              ,' '                                               /* 신용평가모형구분코드 */
              ,'0'                                               /* 최종조정등급         */
              ,'0'                                               /* 기업신용평가등급     */
              ,'00000000'                                        /* 기업신용평가유효일자 */
              ,MAX(CASE WHEN A.DWUP_STD_DT IS NULL THEN A.DWUP_STD_DT
                        ELSE B.APC_DT1
                   END)  AS CLN_ASS_EVL_DT                        /* 여신ASS평가일자      */
              --,CASE WHEN cast(FSR_ASS_GD as int) > 0 THEN FSR_ASS_GD   /*  2012.02.09 이규정, 이수정 수정 요청함.  */
              --      ELSE ASS_CRDT_GD                                   /*  NEXTRO 이후 ASS신용등급 산출된 고객은 FSR_ASS_GD(어업인ASS등급)이  */
              -- END CLN_ASS_CRDT_GD                                     /*  '00'으로 들어오면서  FSR_ASS_GD 으로 반영됨  */
              , A.ASS_CRDT_GD AS CLN_ASS_CRDT_GD                    --20130628 : 어업인등급여부에 관계없이 ASS_CRDT_GD를 적용한다.
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
       FROM    TB_SOR_PLI_SYS_JUD_RSLT_TR A  --SOR_PLI_시스템심사결과내역
              ,(SELECT CUST_NO
                      ,NFFC_UNN_DSCD
                      ,MAX(APC_DT)     AS APC_DT1
                      ,MAX(CLN_APC_NO) AS CLN_APC_NO1
                FROM   TB_SOR_PLI_CLN_APC_BC A  --SOR_PLI_여신신청기본
                WHERE  APC_DT <= V_기준일자
                AND    CLN_APC_PGRS_STCD ='04'
                GROUP  BY CUST_NO, NFFC_UNN_DSCD
               ) B
               ,TB_SOR_CUS_MAS_BC C
       WHERE    A.CLN_APC_NO = B.CLN_APC_NO1
       AND      A.CUST_NO = B.CUST_NO
       AND      A.CUST_NO = C.CUST_NO
       AND      ISNULL(A.CSS_MODL_DSCD,'00') NOT IN ('30','31','32')  -- 얘네는 개인인데 기업심사 타는 애들일 거에요
       GROUP BY B.NFFC_UNN_DSCD
               ,C.CUST_RNNO
               ,CLN_ASS_CRDT_GD

//}

//{  #ROW_NUMBER #RANK #PARTITION
JOIN              (
                        SELECT A.기준일자
                              ,A.고객번호
                              ,A.점번호
                              ,A.점명
                              ,ROW_NUMBER() OVER (PARTITION BY A.고객번호 ORDER BY 대출잔액 DESC) AS SEQ
                        FROM   #고객별점별대출잔액  A
                  )     B
                  ON    A.기준일자  = B.기준일자
                  AND   A.고객번호  = B.고객번호
                  AND   B.SEQ       = 1

//}

//{  #표준산업분류 #표준산업분류코드 #대분류

-- CASE 1.
JOIN        -- 산업분류코드 I55(숙박업) 인 고객
            (
               SELECT   A.CUST_NO
                       ,A.STDD_INDS_CLCD
                       ,B.STDD_INDS_LCCD
                       ,B.STDD_INDS_MCCD
               FROM     #TEMP_고객산업별분류코드        A
                       ,DWZOWN.TB_SOR_CMI_STDD_INDS_BC  B  --CMI_표준산업기본
               WHERE    A.STDD_INDS_CLCD = B.STDD_INDS_CLCD
               AND      B.STDD_INDS_LCCD = 'I'
               AND      B.STDD_INDS_MCCD = '55'
            ) Z2
            ON    A.CUST_NO   = Z2.CUST_NO

-- CASE 2.   대분류코드 출력
SELECT
           ,A.표준산업분류코드
           ,C.STDD_INDS_LCCD    AS  표준산업대분류코드
........
LEFT OUTER JOIN
            DWZOWN.TB_SOR_CMI_STDD_INDS_BC  C  --CMI_표준산업기본
            ON  A.표준산업분류코드  =  C.STDD_INDS_CLCD
;

-- CASE 3.  대분류코드(명) 출력
SELECT      TRIM(A.STDD_INDS_LCCD)||'.'||
            LEFT(TRIM(B.STDD_INDS_CLSF_NM),CHARINDEX('(',B.STDD_INDS_CLSF_NM)-1) AS 대분류명
           ,A.STDD_INDS_CLCD                                                     AS 세분류코드
INTO        #TEMP_표준산업분류
FROM        (SELECT   STDD_INDS_CLCD                          -- 세분류코드
                     ,STDD_INDS_LCCD                          -- 대분류코드
                     ,STDD_INDS_MCCD                          -- 중분류코드
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_표준산업기본)
             WHERE    STDD_INDS_CLSF_DSCD = '4'               -- 표준산업분류구분코드(4:세분류)
            ) A
           ,(SELECT   STDD_INDS_CLCD                          -- 표준산업분류코드
                     ,STDD_INDS_CLSF_NM                       -- 표준산업분류명
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_표준산업기본)
             WHERE    STDD_INDS_CLSF_DSCD = '1'               -- 표준산업분류구분코드(1:대분류)
            ) B
WHERE       A.STDD_INDS_LCCD *= B.STDD_INDS_CLCD              -- 대분류코드
;


SELECT      ................
           ,B.대분류명              AS   업종

FROM        #개인사업자  A
LEFT OUTER JOIN
            #TEMP_표준산업분류  B  --CMI_표준산업기본
            ON  LEFT(A.표준산업분류코드,4) = B.세분류코드

-- CASE 4.  단순히 산업분류코드 세분류명 출력
SELECT
           ,ISNULL(A.STDD_INDS_CLCD, '')     AS 업종코드
           ,TRIM(ISNULL(Z2.STDD_INDS_CLSF_NM, ''))    AS 업종명

LEFT OUTER JOIN
            DWZOWN.TB_SOR_CMI_STDD_INDS_BC      Z2    -- (SOR_CMI_표준산업기본)
            ON  A.STDD_INDS_CLCD = Z2.STDD_INDS_CLCD


-- CASE 5 20170701 부로 산업분류코드가 바뀜에 따라 구 분류코드를 사용하고 싶은경우 임시테이블에 로딩해서 사용하는 방법

SELECT  '20170701'  AS  STD_DT       -- 신 산업분류코드는 기준일자를 현시점으로 세팅
       ,*
INTO    #OT_SOR_CMI_STDD_INDS_BC  -- DROP TABLE #OT_SOR_CMI_STDD_INDS_BC
FROM    TB_SOR_CMI_STDD_INDS_BC   -- SOR_CMI_표준산업기본
;

--SELECT * FROM  #OT_SOR_CMI_STDD_INDS_BC

LOAD TABLE #OT_SOR_CMI_STDD_INDS_BC (
        STD_DT DEFAULT '20170630',              -- 구 산업분류코드는 기준일자를 20170630 로 세팅
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

SELECT      A.STD_DT                  AS 기준일자
           ,A.INTG_ACNO               AS 계좌번호
           ,A.STDD_INDS_CLCD          AS 산업분류코드
           ,C.대분류코드
           ,C.대분류명

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A       --DWA_통합여신기본
LEFT OUTER JOIN
            (
              SELECT   A.STD_DT                                                             AS 기준일자
                      ,A.STDD_INDS_LCCD                                                     AS 대분류코드
                      ,TRIM(A.STDD_INDS_LCCD)||'.'||
                       LEFT(TRIM(B.STDD_INDS_CLSF_NM),CHARINDEX('(',B.STDD_INDS_CLSF_NM)-1) AS 대분류명
                      ,A.STDD_INDS_CLCD                                                     AS 세분류코드
              
              FROM     (SELECT   STD_DT
                                ,STDD_INDS_CLCD                          -- 세분류코드
                                ,STDD_INDS_LCCD                          -- 대분류코드
                                ,STDD_INDS_MCCD                          -- 중분류코드
                        FROM     #OT_SOR_CMI_STDD_INDS_BC                -- 임시테이블(표준산업기본)
                        WHERE    STDD_INDS_CLSF_DSCD = '4'               -- 표준산업분류구분코드(4:세분류)
                       ) A
              JOIN    (SELECT   STD_DT
                                ,STDD_INDS_CLCD                          -- 표준산업분류코드
                                ,STDD_INDS_CLSF_NM                       -- 표준산업분류명
                        FROM     #OT_SOR_CMI_STDD_INDS_BC                -- 임시테이블(표준산업기본)
                        WHERE    STDD_INDS_CLSF_DSCD = '1'               -- 표준산업분류구분코드(1:대분류)
                       ) B
                       ON    A.STDD_INDS_LCCD  = B.STDD_INDS_CLCD              -- 대분류코드
                       AND   A.STD_DT          = B.STD_DT
            ) C
            ON    LEFT(A.STDD_INDS_CLCD, 4) = C.세분류코드
            AND   CASE WHEN A.STD_DT >= '20170701' THEN '20170701' ELSE '20170630' END  = C.기준일자
                -- 20170701 10차 표준산업분류코드 개정

-- CASE 6 대분류, 중분류, 소분류 출력
SELECT      TRIM(A.STDD_INDS_LCCD)||'.'|| LEFT(TRIM(B.STDD_INDS_CLSF_NM),CHARINDEX('(',B.STDD_INDS_CLSF_NM)-1) AS 대분류명
           ,TRIM(A.STDD_INDS_MCCD)||'.'|| TRIM(C.STDD_INDS_CLSF_NM) AS 중분류명
           ,TRIM(A.STDD_INDS_SCCD)||'.'|| TRIM(D.STDD_INDS_CLSF_NM) AS 소분류명
           ,A.STDD_INDS_CLCD                                        AS 세분류코드
INTO        #TEMP_표준산업분류  -- DROP TABLE #TEMP_표준산업분류
FROM        (SELECT   STDD_INDS_CLCD                          -- 세분류코드
                     ,STDD_INDS_LCCD                          -- 대분류코드
                     ,STDD_INDS_MCCD                          -- 중분류코드
                     ,STDD_INDS_SCCD                          -- 소분류코드
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_표준산업기본)
             WHERE    STDD_INDS_CLSF_DSCD = '4'               -- 표준산업분류구분코드(4:세분류)
            ) A
LEFT OUTER JOIN
            (SELECT   STDD_INDS_CLCD                          -- 표준산업분류코드
                     ,STDD_INDS_CLSF_NM                       -- 표준산업분류명
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_표준산업기본)
             WHERE    STDD_INDS_CLSF_DSCD = '1'               -- 표준산업분류구분코드(1:대분류)
            ) B
            ON        A.STDD_INDS_LCCD = B.STDD_INDS_CLCD              -- 대분류코드
LEFT OUTER JOIN
            (SELECT   STDD_INDS_CLCD                          -- 표준산업분류코드
                     ,STDD_INDS_CLSF_NM                       -- 표준산업분류명
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_표준산업기본)
             WHERE    STDD_INDS_CLSF_DSCD = '2'               -- 표준산업분류구분코드(2:중분류)
            ) C
            ON        LEFT(TRIM(A.STDD_INDS_CLCD),2) = TRIM(C.STDD_INDS_CLCD)
LEFT OUTER JOIN
            (SELECT   STDD_INDS_CLCD                          -- 표준산업분류코드
                     ,STDD_INDS_CLSF_NM                       -- 표준산업분류명
             FROM     DWZOWN.TB_SOR_CMI_STDD_INDS_BC          -- (SOR_CMI_표준산업기본)
             WHERE    STDD_INDS_CLSF_DSCD = '3'               -- 표준산업분류구분코드(3:소분류)
            ) D
            ON        LEFT(TRIM(A.STDD_INDS_CLCD),3) = TRIM(D.STDD_INDS_CLCD)
;

//}

//{  #설립일 #창립일 #창업기업지원
--SOR_CCR_업체개요내역 또는 고객원장의 설립일보다 KIS데이터의 설립일이 더 잘 들어있음
--고객원장 >> KIS데이터 >> 자체평가정보 순으로 원장스캔해서 설립일자 가져오기
-- 고객별로 설립일 여러개 나올수 있으니 확인후 설립일자는 MIN OR MAX 해서 사용해야 한다.

SELECT      A.고객번호
           ,MIN(
                 CASE WHEN ISDATE(B.ESTB_DT)  = 1  THEN B.ESTB_DT
                      WHEN ISDATE(C.ESTB_DT)  = 1  THEN C.ESTB_DT
                      WHEN ISDATE(D.설립일자) = 1  THEN D.설립일자
                      WHEN ISDATE(E.설립일자) = 1  THEN E.설립일자
                      WHEN ISDATE(F.설립일자) = 1  THEN F.설립일자
                 END
              )  AS 설립일자
--         ,CONVERT(CHAR(8), DATEADD(YY, 7, 설립일자), 112)   AS 창업7년후

INTO        #TEMP_설립일  -- DROP TABLE #TEMP_설립일

FROM        #기업자금  A

JOIN        DWZOWN.OM_DWA_INTG_CUST_BC  B   --DWA_통합고객기본
            ON    A.고객번호  =  B.CUST_NO

LEFT OUTER JOIN
            DWZOWN.OM_DWA_INTG_CUST_BC  C   --DWA_통합고객기본
            ON    A.개인사업자번호 = C.CUST_RNNO

LEFT OUTER JOIN
            (SELECT   BRN            AS 사업자등록번호
                     ,MIN(ESTB_DT)   AS 설립일자
             FROM     TB_SOR_CCR_KIS_BZNS_BC  --SOR_CCR_KIS업체개요기본
             WHERE    ESTB_DT > '00000000'
             GROUP BY BRN
            ) D
            ON   A.실명번호  =  D.사업자등록번호

LEFT OUTER JOIN
            (SELECT   BRN            AS 사업자등록번호
                     ,MIN(ESTB_DT)   AS 설립일자
             FROM     TB_SOR_CCR_KIS_BZNS_BC  --SOR_CCR_KIS업체개요기본
             WHERE    ESTB_DT > '00000000'
             GROUP BY BRN
            ) E
            ON   A.개인사업자번호  = E.사업자등록번호

LEFT OUTER JOIN
            (SELECT   CASE WHEN B.RPST_RNNO  IS NOT NULL  OR B.RPST_RNNO > ' '  THEN B.RPST_RNNO
                           ELSE A.RNNO END    AS 실명번호
                     ,MIN(A.ESTB_DT)               AS 설립일자
             FROM     TB_SOR_CCR_EVL_BZNS_OTL_TR A        --SOR_CCR_평가업체개요내역
                     ,TB_SOR_CCR_EVL_INF_BC      B        --SOR_CCR_평가정보기본
             WHERE    A.RNNO          = B.RNNO
             AND      A.CRDT_EVL_NO   = B.CRDT_EVL_NO
             AND      B.NFFC_UNN_DSCD = '1'      --중앙회조합구분코드(1:중앙회, 2:조합)
             AND      B.CRDT_EVL_PGRS_STCD ='2'  --신용평가진행상태코드(1:진행중, 2:평가완료)
             AND      A.ESTB_DT > '00000000'
             GROUP BY 실명번호
            ) F
            ON   A.실명번호 =  F.실명번호

WHERE       1=1
GROUP BY    A.고객번호
;


//}

//{  #B2401 #금감원보고서

--PROCEDURE DWZPRC.UP_DWZ_경영_N0058_금감원업무보고서  의 일부분

    /************************************************************************
    --① 자금범위를 설정한다.
    ************************************************************************/
    SELECT    STD_DT          AS 기준일자
             ,'은행계정'      AS 구분1
             ,CASE WHEN ACSB_CD  IN ('15011211','15011011')
                     OR ACSB_CD5   ='14004308'                        THEN '기타채권'
                   WHEN ACSB_CD2  = '93000101'                        THEN '확정지급보증'
                   ELSE                                                    '대출채권'
                   END        AS 구분2
             ,CASE WHEN ACSB_CD4  = '13000801'                         THEN '원화대출금'
                   WHEN ACSB_CD4 IN ('13001108','13001308','13001408') THEN '외화대출금'             --내국수입유산스계정,역외외화대출금계정  포함
                   WHEN ACSB_CD4  = '13001601'                         THEN '지급보증대출금'
                   WHEN ACSB_CD4 IN ('13001508','13001001')            THEN '매입외환'               --매입어음(CP매입) 포함
                   WHEN ACSB_CD4  = '13001701'                         THEN '신용카드'
                   WHEN ACSB_CD4  = '13001901'                         THEN '사모사채'
                   ELSE '0'
                   END        AS 구분3
             ,CASE WHEN ACSB_CD5 = '14002401'  THEN '기업'
                   WHEN ACSB_CD5 = '14002501'  THEN '가계'
                   WHEN ACSB_CD5 = '14002601'  THEN '공공'
                   ELSE '0'
                   END        AS 자금구분
             ,ACSB_CD10       AS 계정코드
    INTO     #TEMP_자금범위                 -- DROP TABLE #TEMP_자금범위
    FROM     DWZOWN.OT_DWA_DD_ACSB_TR       --DWA_일계정과목내역
    WHERE    STD_DT     = P_기준일자
    AND      FSC_SNCD  IN ('K', 'C')
    AND     (ACSB_CD4  IN ('13000801'     --원화대출금
                          ,'13001108'     --외화대출
                          ,'13001308'     --(내국수입유산스계정)
                          ,'13001408'     --(역외외화대출금계정)
                          ,'13001601'     --지급보증대지급금
                          ,'13001508'     --매입외환
                          ,'13001001'     --(매입어음(CP매입))
                          ,'13001701'     --신용카드채권
                          ,'13001901')    --사모사채
          OR ACSB_CD2   = '93000101'      --은행계정확정지급보증
          OR ACSB_CD   IN ('15011211'     --기타채권(여신성가지급금)
                          ,'15011011')    --기타채권(신용카드가지급금)
          OR ACSB_CD5   ='14004308'       --기타채권(외화가지급금)
             )
    AND      ACSB_CD  <> '14000711' ;      --은행간대여금제외




    /************************************************************************
    --② 대출금액 및 건전성 금액을 구분별로 작성한다.
    ************************************************************************/
    SELECT   A.*
            ,B.정상
            ,B.요주의
            ,B.고정
            ,B.회수의문
            ,B.추정손실
    INTO     #TEMP_기본여신         -- DROP TABLE #TEMP_기본여신
    FROM    (SELECT   A.STD_DT          AS 기준일자
                     ,B.구분1
                     ,B.구분2
                     ,B.구분3
                     ,B.자금구분
                     ,CASE WHEN B.자금구분 = '가계' THEN
                                CASE WHEN A.STD_DT < '20120101'  THEN
                                     CASE WHEN (A.BS_ACSB_CD IN ('15005811','15006211','15006311','16006011','16006111')
                                          AND A.MRT_CD IN ('101','102','103','104','105','170','109','111')) OR
                                              A.BS_ACSB_CD = '14000611'  THEN '주택담보'
                                          WHEN  A.MRT_CD < '100' OR A.MRT_CD IN ('601','602') THEN '신용'
                                          ELSE  '기타'  END
                                     WHEN A.STD_DT >= '20120101'  THEN
                                     CASE WHEN (A.BS_ACSB_CD  IN ('15005811','15006211','15006311','16006011','16006111')
                                          AND A.MRT_CD  IN ('101','102','103','104','105','170','109','420','421','422','423','512','521')) OR
                                              A.BS_ACSB_CD = '14000611'  THEN '주택담보'
                                          WHEN  A.MRT_CD < '100' OR A.MRT_CD IN ('601','602') THEN '신용'
                                          ELSE  '기타'  END
                                     END
                           WHEN B.구분3 = '신용카드'  THEN
                                CASE WHEN A.FRPP_KDCD =  '6' AND F.PREN_DSCD = '1'            THEN '가계'
                                     WHEN A.FRPP_KDCD <> '6' AND A.CUST_DSCD IN ('01','07')   THEN '가계'
                                     ELSE '기업' END
                           WHEN B.자금구분 = '공공'      THEN  '공공'
                           WHEN B.구분2    = '기타채권'  THEN '0'
                           ELSE CASE WHEN A.CUST_DSCD  NOT IN ('01','07')   AND A.RNNO < '9999999999'
                                      AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014년부터 88도 기업으로 포함시킨다.
                                     THEN CASE WHEN ISNULL(E.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '대기업'  ELSE '중소기업'  END
                                     ELSE '중소기업' /*개인사업자*/  END
                           END   AS 기업구분
                     ,CASE WHEN 기업구분 = '중소기업'  THEN
                                CASE WHEN A.CUST_DSCD  NOT IN ('01','07')   AND A.RNNO < '9999999999'
                                      AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014년부터 88도 기업으로 포함시킨다.
                                     THEN '' ELSE '개인사업자'  END
                           END          AS 개인사업자여부
                     ,A.RNNO            AS 실명번호
                     ,A.INTG_ACNO       AS 계좌번호
                     ,CASE WHEN B.구분3 = '신용카드' AND A.BS_ACSB_CD  NOT IN ('15009111','15009011')  THEN A.AVL_CRD_NO  --신용카드채권은 유효카드번호사용(단, 카드론(15009111)은 통합계좌번호 사용)
                            ELSE A.INTG_ACNO     END  AS 건전성계좌번호
                     ,A.BS_ACSB_CD      AS 계정코드
                     ,A.STDD_INDS_CLCD  AS 산업분류코드
                     ,SUM(A.LN_RMD)     AS 잔액
                     ,SUM(CASE WHEN A.CRCD <> 'KRW'  THEN A.OVD_AMT * C.DLN_STD_EXRT
                                    ELSE A.OVD_AMT
                               END)     AS 연체금액
                     ,SUM(CASE WHEN A.PCPL_OVD_MCNT >= 3 THEN
                                    CASE WHEN A.CRCD <> 'KRW'  THEN A.OVD_AMT * C.DLN_STD_EXRT
                                         ELSE A.OVD_AMT END
                               ELSE 0
                               END)     AS 삼개월연체금액
                     ,SUM(CASE WHEN ISDATE(A.FSS_OVD_ST_DT ) = 1  THEN
                                    CASE WHEN A.CRCD <> 'KRW'  THEN A.OVD_AMT * C.DLN_STD_EXRT
                                         ELSE A.OVD_AMT END
                               ELSE 0
                               END)     AS 금감원연체금액
                     ,D.ARCD            AS 지역코드
             FROM     DWZOWN.OT_DWA_INTG_CLN_BC     A       --DWA_통합여신기본
                     ,#TEMP_자금범위                B
                     ,DWZOWN.OT_DWA_EXRT_BC         C       --DWA_환율기본
                     ,DWZOWN.OT_DWA_DD_BR_BC        D       --DWA_일점기본
                     ,DWZOWN.OT_DWA_ENTP_SCL_BC     E       --DWA_기업규모기본
                     ,DWZOWN.TB_SOR_CLT_CRD_BC      F       --SOR_CLT_카드기본
             WHERE    A.STD_DT       = P_기준일자
             AND      A.BR_DSCD      = '1'
             AND      A.CLN_ACN_STCD = '1'    --활동
             AND      A.STD_DT       = B.기준일자
             AND      A.BS_ACSB_CD   = B.계정코드
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
             GROUP BY 기준일자
                     ,B.구분1
                     ,B.구분2
                     ,B.구분3
                     ,B.자금구분
                     ,기업구분
                     ,개인사업자여부
                     ,실명번호
                     ,계좌번호
                     ,건전성계좌번호
                     ,계정코드
                     ,산업분류코드
                     ,지역코드
             ) A
           ,(SELECT   A.STD_DT        AS 기준일자
                     ,A.BS_ACSB_CD    AS 계정코드
                     ,A.INTG_ACNO     AS 계좌번호
                     ,SUM(CASE WHEN A.ACN_SDNS_GDCD = '1' THEN A.ACN_RMD  ELSE 0 END)   AS 정상
                     ,SUM(CASE WHEN A.ACN_SDNS_GDCD = '2' THEN A.ACN_RMD  ELSE 0 END)   AS 요주의
                     ,SUM(CASE WHEN A.ACN_SDNS_GDCD = '3' THEN A.ACN_RMD  ELSE 0 END)   AS 고정
                     ,SUM(CASE WHEN A.ACN_SDNS_GDCD = '4' THEN A.ACN_RMD  ELSE 0 END)   AS 회수의문
                     ,SUM(CASE WHEN A.ACN_SDNS_GDCD = '5' THEN A.ACN_RMD  ELSE 0 END)   AS 추정손실
             FROM     DWZOWN.TB_SOR_LCF_SDNS_ACN_MN_DL  A   --SOR_LCF_건전성계좌월별중앙회상세
                     ,#TEMP_자금범위                    B
             WHERE    A.STD_DT       = P_기준일자
             AND      A.BR_DSCD      = '1'
             AND      A.CLN_ACN_STCD = '1'    --활동
             AND      A.STD_DT       = B.기준일자
             AND      A.BS_ACSB_CD   = B.계정코드
             GROUP BY 기준일자
                     ,계정코드
                     ,계좌번호
             ) B
    WHERE    A.기준일자        = B.기준일자
    AND      A.계정코드       *= B.계정코드
    AND      A.건전성계좌번호 *= B.계좌번호;




SELECT      구분1, 구분2, 구분3, 자금구분,기업구분, SUM(잔액)
FROM        #TEMP_기본여신
GROUP BY    구분1, 구분2, 구분3, 자금구분, 기업구분
ORDER BY    1,2,3,4



//}

//{  #무역외사유거래내역 #무역외거래
-- 무역외사유거래내역에서 사유코드를 가져오는 방법
-- 본거래외에 원장변경등 동일REF에 여러건의 거래가 있을경우 유효한 무역외코드를 가져오는 방법
    ,(
        SELECT  A.REF_NO,A.INTD_RSCD,A.NE_INTD_RSCD
        FROM    DWZOWN.TB_SOR_INX_INTD_RSN_TR_TR    A
        JOIN    (  -- 무역외사유코드가 들어오는 최종거래내역을 가져온다
                  SELECT   AA.REF_NO, MAX(AA.RSN_SNO) AS MAX_RSN_SNO
                  FROM     DWZOWN.TB_SOR_INX_INTD_RSN_TR_TR   AA
                  WHERE    AA.FRXC_LDGR_STCD = '1'   -- 정상
                  AND      (
                            AA.INTD_RSCD IS NOT NULL  OR
                            AA.NE_INTD_RSCD IS NOT NULL
                           )
                  GROUP BY AA.REF_NO
                 )     B
                 ON    A.REF_NO  = B.REF_NO
                 AND   A.RSN_SNO = B.MAX_RSN_SNO
        WHERE    A.FRXC_LDGR_STCD = '1'   -- 정상
     )        D

//}

//{  #최초실행금리 #실행금리 #일계좌금리집계 #계좌금리
LEFT OUTER JOIN
            (
             SELECT    A.STD_DT
                      ,A.CLN_ACNO
                      ,A.CLN_EXE_NO
                      ,A.CLN_APL_IRRT_DSCD                --여신적용이율구분코드
                      ,A.APL_ADD_IRT                      --적용가산금리
                      ,A.STD_IRT                          --기준금리
                      ,A.APL_IRRT                         --적용이율
                      ,A.ADD_IRT                          --가산금리
                      ,A.APL_ST_DT                        --적용시작일자
                      ,A.APL_END_DT                       --적용종료일자
                      ,ROW_NUMBER() OVER(PARTITION BY A.CLN_ACNO ORDER BY A.APL_ST_DT ASC,A.CLN_EXE_NO ASC) AS 최초실행금리
-- 상식적으로 계좌의 최초금리는 실행번호 1번이라고 생각하지만 실제로 데이터를 보면 다른 실행번호가
-- 금리적용시작일자가 빠른경우가 있어서 계좌번호별로 금리적용시작일자가 가장빠른건을 구해서 해당 금리를 이용한다
             FROM      DWZOWN.TB_SOR_LOA_DDY_ACN_IRT_TZ   A
                      ,(
                            SELECT   CLN_ACNO, CLN_EXE_NO , MAX(STD_DT)  AS 최종기준일
                            FROM     DWZOWN.TB_SOR_LOA_DDY_ACN_IRT_TZ
                            WHERE    CLN_APL_IRRT_DSCD = '1'          --여신적용이율구분코드(1:대출이율,9.연체이율)
                            GROUP BY CLN_ACNO, CLN_EXE_NO
                       )   B
                      
             WHERE     1=1
               AND     A.STD_DT            =  B.최종기준일
               AND     A.CLN_ACNO          =  B.CLN_ACNO
               AND     A.CLN_EXE_NO        =  B.CLN_EXE_NO
               AND     A.CLN_APL_IRRT_DSCD = '1'          --여신적용이율구분코드(1:대출이율,9.연체이율)
            )   D
            ON  C.INTG_ACNO   =  D.CLN_ACNO
            AND D.최초실행금리 = 1
//}

//{  #우편번호 #시군구 #주소
-- 주소를 광역시는 시명만 도는 시/군 까지는 출력하게 하는 방법
LEFT OUTER JOIN
            (
              SELECT   DISTINCT
                       A.ZIP
                      ,CASE WHEN TRIM(A.MPSD_NM)  IN ('울산광역시','서울특별시','부산광역시','인천광역시','광주광역시','대구광역시','대전광역시')
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

//{  #신규시등급  #ASS등급 #신규ASS #신규시점
LEFT OUTER JOIN
            (

            SELECT      T.전출계좌번호       AS   계좌번호
                       ,E.CSS_MODL_DSCD      AS   CSS모형구분코드
                       ,TRIM(E.ASS_CRDT_GD)  AS   ASS등급
                       ,ROW_NUMBER() OVER(PARTITION BY B.CLN_ACNO ORDER BY B.APC_DT ASC) AS 순서
                         -- 한계좌가 신청구분코드(01:신규) 로 여러건 나오는경우 있음 그중에 최초꺼라 가져옴

            FROM        #대상계좌_최초점            T
            JOIN        TB_SOR_LOA_ACN_BC          A
                        ON   T.전출계좌번호  =  A.CLN_ACNO

            JOIN        TB_SOR_PLI_CLN_APC_BC      B  -- SOR_PLI_여신신청기본
                        ON   A.CLN_ACNO        = B.CLN_ACNO
                        AND  B.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- 여신신청구분코드(01:신규,02:대환)

            JOIN        TB_SOR_PLI_SYS_JUD_RSLT_TR      E     -- SOR_PLI_시스템심사결과내역
                        ON   B.CLN_APC_NO        = E.CLN_APC_NO
                        AND  B.CUST_NO           = E.CUST_NO

            )           D
            ON       A.전출계좌번호  = D.계좌번호
            AND      D.순서          = 1      -- 종통의 경우 같은 계좌번호로 여러건 나오는 경우 있음

//}

//{  #기업신용평가등급  #CRS등급 #신규시등급 #신규시점

--CRS등급
UPDATE      #대상계좌  A
SET         A.기업신용평가등급     = B.기업신용평가등급
           ,A.신용평가모형구분코드 = B.신용평가모형구분코드
FROM        (
              SELECT      T.통합계좌번호
                         ,D.LST_ADJ_GD          AS 기업신용평가등급
                         ,D.CRDT_EVL_MODL_DSCD  AS 신용평가모형구분코드

              FROM        #대상계좌   T

              JOIN        TB_SOR_LOA_ACN_BC          A
                          ON   T.통합계좌번호  =  A.CLN_ACNO

              JOIN        TB_SOR_CLI_CLN_APC_BC      B    -- SOR_CLI_여신신청기본
                          ON  A.CLN_ACNO        = B.ACN_DCMT_NO
                          AND B.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- 여신신청구분코드(01:신규,02:대환)
                          AND B.NFFC_UNN_DSCD   = '1'     -- 중앙회
                          AND B.APC_LDGR_STCD   = '10'    -- 신청원장상태코드(01:작성중,02:결재중,10:완료,99:취소)
                          AND B.CLN_APC_CMPL_DSCD IN ('20','21') -- 여신신청완료구분코드
                                                                 -- 09:부결, 10:승인 18:승인후미취급, 20:약정, 21:실행,17:철회
              JOIN        TB_SOR_CLI_CLN_APC_RPST_BC C  -- SOR_CLI_여신신청대표기본
                          ON  B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO

              JOIN        TB_SOR_CCR_EVL_INF_TR      D     -- SOR_CCR_평가정보내역
                          ON   C.CRDT_EVL_NO =    D.CRDT_EVL_NO

            )    B
WHERE       A.통합계좌번호  = B.통합계좌번호
;

//}

//{  #담보명  #담보코드명  #담보유형코드

-- CASE 1  담보코드, 담보코드명
SELECT      A.MRT_CD           AS  담보코드
             ,Z1.MRT_CD_NM       AS  담보코드명
            ,A.MRT_CD  || '.' ||  TRIM(Z1.MRT_CD_NM)  AS 담보코드명2

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A  --DWA_통합여신기본

LEFT OUTER JOIN
            DWZOWN.TB_SOR_CLM_MRT_CD_BC  Z1  --CLM_담보코드기본
            ON    A.MRT_CD = Z1.MRT_CD

-- CASE 2  담보유형코드
SELECT      ,A.MRT_CD                     AS  담보코드
           ,F.MRT_TPCD                   AS  담보유형코드
FROM        OT_DWA_INTG_CLN_BC   A
LEFT OUTER JOIN
            TB_SOR_CLM_MRT_CD_BC       F             -- (SOR_CLM_담보코드기본)
            ON     A.MRT_CD    = F.MRT_CD

//-------------------------------------------------------------------
,CASE WHEN   A.담보유형코드 = '6'  THEN   '1 신용'
      WHEN   A.담보유형코드 = '5'  THEN   '2 보증'
      ELSE    '3 담보'
 END    AS   담보구분
//-------------------------------------------------------------------


//}

//{  #나이  #만나이  #성별
-- CASE 1
SELECT

            CASE WHEN  SUBSTR(A.RNNO,7,1) IN ('0','9') THEN '18'  --1800년대 남성,여성
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('1','2') THEN '19'  --1900년대 남성,여성
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('3','4') THEN '20'  --2000년대 남성,여성
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('5','6') THEN '19'  --1900년대 외국인남성,여성
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('7','8') THEN '20'  --2000년대 외국인남성,여성
            END  ||    SUBSTR(A.RNNO,1,6)      AS    생년월일

           ,CASE WHEN  SUBSTR(A.RNNO,7,1) IN ('1','3','5','7','9')   THEN  '1.남성'
                 WHEN  SUBSTR(A.RNNO,7,1) IN ('2','4','6','8','0')   THEN  '2.여성'
                 ELSE  '3.기타'
            END                  AS   성별구분

           ,CONVERT(INT,LEFT(A.STD_DT,4)) - CONVERT(INT,LEFT(생년월일,4)) + CASE WHEN CONVERT(INT,RIGHT(생년월일,4)) > CONVERT(INT,RIGHT(A.STD_DT,4)) THEN -1 ELSE 0 END  AS 만나이

           ,CASE WHEN A.만나이 <  20                     THEN '1.20세 미만'
                 WHEN A.만나이 >= 20  AND A.만나이 < 30  THEN '2.20세이상 ~ 30세미만'
                 WHEN A.만나이 >= 30  AND A.만나이 < 40  THEN '3.30세이상 ~ 40세미만'
                 WHEN A.만나이 >= 40  AND A.만나이 < 50  THEN '4.40세이상 ~ 50세미만'
                 WHEN A.만나이 >= 50  AND A.만나이 < 60  THEN '5.50세이상 ~ 60세미만'
                 WHEN A.만나이 >= 60                     THEN '6.60세 이상'
                 END  AS 나이구분

//}

//{  #기업자금신규기준모집단 #기업자금 #기업자금모집단 #신규여신

SELECT      A.STD_DT              AS   기준일자
           ,A.INTG_ACNO           AS   통합계좌번호
           ,A.CUST_NO             AS   고객번호

           ,CASE WHEN C.ACSB_CD5 = '14002401' THEN --기업
             CASE WHEN A.CUST_DSCD NOT IN ('01','07')   AND A.RNNO < '9999999999'
                    AND SUBSTR(A.RNNO,4,2) BETWEEN '81' AND (CASE WHEN A.STD_DT <= '20131231' THEN '87' ELSE '88' END)  --2014년부터 88도 기업으로 포함시킨다.
                  THEN CASE WHEN ISNULL(D.ENTP_SCL_DTL_DSCD, '00') = '01'  THEN  '1.대기업'  ELSE '2.중소기업'  END
             ELSE '3.개인사업자'
             END
            END                               AS 기업구분

           ,CASE WHEN LEFT(CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN FST_LN_DT ELSE AGR_DT END,6) = LEFT(A.STD_DT,6)
                   THEN  1
                   ELSE  0
            END                                 AS 당월신규여부
           ,CASE WHEN A.FST_LN_DT  IS NOT NULL AND A.FST_LN_DT > '19000000' THEN LN_EXE_AMT ELSE AGR_AMT END  AS 신규대상금액

           ,A.LN_RMD              AS  대출잔액

INTO        #TEMP_신규  -- DROP TABLE #TEMP_신규

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A       --DWA_통합여신기본

JOIN        (
                SELECT   STD_DT
                        ,ACSB_CD
                        ,ACSB_NM
                        ,ACSB_CD4  --원화대출금
                        ,ACSB_NM4
                        ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                        ,ACSB_NM5
                FROM     OT_DWA_DD_ACSB_TR
                WHERE    FSC_SNCD IN ('K','C')
--              AND      ACSB_CD4 = '13000801'        --원화대출금
                AND      ACSB_CD5 IN ('14002401')     --기업자금대출금
            )           C
            ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS계정과목코드
            AND      A.STD_DT       =   C.STD_DT

LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_기업규모기본
            ON     A.RNNO      = D.RNNO
            AND    A.STD_DT    = D.STD_DT

JOIN        OM_DWA_INTG_CUST_BC          T     -- DWA_통합고객기본
            ON     A.CUST_NO    =  T.CUST_NO

JOIN        OT_DWA_DD_BR_BC               F       --DWA_일점기본
            ON         A.BRNO    =   F.BRNO
            AND        A.STD_DT  =   F.STD_DT

WHERE       1=1
AND         A.STD_DT   IN  (
                              SELECT   MAX(STD_DT)  AS 기준일자
                              FROM     DWZOWN.OT_DWA_INTG_CLN_BC A
                              WHERE    1=1
                              AND      STD_DT BETWEEN '20130101'  AND  '20141231'
                              GROUP BY LEFT(STD_DT,6)
                           )
AND         A.CLN_ACN_STCD <>  '3'                     -- 취소건제외
AND         A.BR_DSCD  =  '1'                          -- 중앙회
AND         당월신규여부 =  1
;
//}

//{  #신규시점 #신용등급 #CRS등급 #ASS등급

-- 신규시점 신용등급


-- CRS등급
SELECT      T.순번
           ,A.CLN_ACNO
           ,E.LST_ADJ_GD   AS   CRDT_CD

INTO        #신규신용등급 --  DROP TABLE #신규신용등급

FROM        #대상계좌                  T
JOIN        TB_SOR_LOA_ACN_BC          A
            ON   T.계좌번호  =  A.CLN_ACNO

JOIN        TB_SOR_CLI_CLN_APC_BC      B  -- SOR_CLI_여신신청기본
            ON   A.CLN_ACNO        = B.ACN_DCMT_NO
            AND  B.CLN_APC_DSCD    = '01'    -- 여신신청구분코드(01:신규)

JOIN        TB_SOR_CLI_CLN_APC_RPST_BC C  -- SOR_CLI_여신신청대표기본
            ON   B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO

JOIN        TB_SOR_CCR_EVL_BZNS_OTL_TR D  -- SOR_CCR_평가업체개요내역
            ON   C.CRDT_EVL_NO     = D.CRDT_EVL_NO

JOIN        TB_SOR_CCR_EVL_INF_TR      E     -- SOR_CCR_평가정보내역
            ON   C.CRDT_EVL_NO =    E.CRDT_EVL_NO

UNION  ALL

-- ASS 등급
SELECT      T.순번
           ,A.CLN_ACNO
           ,TRIM(E.ASS_CRDT_GD) AS  CRDT_GD

FROM        #대상계좌                  T
JOIN        TB_SOR_LOA_ACN_BC          A
            ON   T.계좌번호  =  A.CLN_ACNO

JOIN        TB_SOR_PLI_CLN_APC_BC      B  -- SOR_PLI_여신신청기본
            ON   A.CLN_ACNO        = B.CLN_ACNO
            AND  B.CLN_APC_DSCD    = '01'    -- 여신신청구분코드(01:신규)

JOIN        TB_SOR_PLI_SYS_JUD_RSLT_TR      E     -- SOR_PLI_시스템심사결과내역
            ON   B.CLN_APC_NO        = E.CLN_APC_NO
            AND  B.CUST_NO           = E.CUST_NO
;

//}

//{  #건전성변경내역 #건전성 #자산건전성

SELECT  INTG_ACNO 계좌번호,
b.ACN_SDNS_GDCD 계좌건전성등급코드 ,
b. APMN_NDS_RSVG_AMT 충당금요구적립금액 ,
a.ACN_SDNS_GDCD 변경후계좌건전성등급코드 ,
a. APMN_NDS_RSVG_AMT 변경후충당금요구적립금액

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
and   a.SDNS_EPRC_CD ='3'   -- 건전성예외처리코드

//}

//{  #고객주소 #평가정보주소  #평가정보

-- 고객의 주소를 가져오되...사업장주소는 평가정보의 주소를 우선하도록 처리
SELECT      T.계좌번호

           ,B.OOH_ZADR    자택우편번호주소
           ,B.OOH_BZADR   자택우편번호외주소

           ,B.WKPL_ZADR   직장우편번호주소
           ,B.WKPL_BZADR  직장우편번호외주소

           ,B.BZPL_ZADR   사업장우편번호주소
           ,B.BZPL_BZADR  사업장우편번호외주소

INTO        #고객주소  -- DROP TABLE #고객주소

FROM        #TEMP                  T

JOIN        TB_SOR_LOA_ACN_BC          A
            ON   T.계좌번호  =  A.CLN_ACNO

JOIN        OM_DWA_INTG_CUST_BC  B  --DWA_통합고객기본
            ON   A.CUST_NO = B.CUST_NO
;

-- 평가정보에 있는 사업체 주소를 우선적용
UPDATE      #고객주소   A

SET         A.사업장우편번호주소     =  B.사업장우편번호주소
           ,A.사업장우편번호외주소   =  B.사업장우편번호외주소

FROM        (
               SELECT      A.CLN_ACNO               AS  계좌번호
                          ,CC.ADR_                  AS  사업장우편번호주소
                          ,TRIM(D.HDFC_DTL_ADR)     AS  사업장우편번호외주소

               FROM        #TEMP                      T
               JOIN        TB_SOR_LOA_ACN_BC          A
                           ON   T.계좌번호  =  A.CLN_ACNO

               JOIN        TB_SOR_CLI_CLN_APC_BC      B  -- SOR_CLI_여신신청기본
                           ON   A.CLN_ACNO        = B.ACN_DCMT_NO
                           AND  B.CLN_APC_DSCD    = '01'    -- 여신신청구분코드(01:신규)

               JOIN        TB_SOR_CLI_CLN_APC_RPST_BC C  -- SOR_CLI_여신신청대표기본
                           ON   B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO

               JOIN        TB_SOR_CCR_EVL_BZNS_OTL_TR D  -- SOR_CCR_평가업체개요내역
                           ON   C.CRDT_EVL_NO     = D.CRDT_EVL_NO

               LEFT OUTER JOIN   -- 업체본사의 소재지
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
AND         A.계좌번호  = B.계좌번호
--  ORDER BY 1
;


//}

//{  #CB등급 #신규시점 #연소득 #시스템심사

-- CASE1 : 신규시점 고객의 CB등급과 연소득
           ,TRIM(E.CB_CRDT_GD) AS  CB등급
           ,F.FRYR_ICM_AMT     AS  연소득
           ,CASE WHEN TRIM(E.CB_CRDT_GD) IN ('007','008','009','010')  THEN  'O' ELSE 'X' END AS 저신용여부
           ,CASE WHEN F.FRYR_ICM_AMT <= 20000                          THEN  'O' ELSE 'X' END AS 저소득여부

INTO        #TEMP      -- DROP TABLE #TEMP

FROM        #대상계좌   T

JOIN        TB_SOR_LOA_ACN_BC          A
            ON   T.INTG_ACNO  =  A.CLN_ACNO

JOIN        TB_SOR_PLI_CLN_APC_BC      B  -- SOR_PLI_여신신청기본
            ON   A.CLN_ACNO        = B.CLN_ACNO
            AND  B.CLN_APC_DSCD    = '01'    -- 여신신청구분코드(01:신규)

JOIN        TB_SOR_PLI_SYS_JUD_RSLT_TR      E     -- SOR_PLI_시스템심사결과내역
            ON   B.CLN_APC_NO        = E.CLN_APC_NO
            AND  B.CUST_NO           = E.CUST_NO

JOIN        TB_SOR_PLI_APC_POT_CUST_TR      F     --SOR_PLI_신청시점고객내역
            ON   B.CLN_APC_NO        = F.CLN_APC_NO
            AND  B.CUST_NO           = F.CUST_NO


-- CASE2 : 기준일자 시점의 db등급  (통합여신방법)
           --계좌별로 기준시점현재 최종등급을 가져온다. 계좌별이므로 고객별로는 다를수 있다
           --동일고객이면 한개의 등급값을 원하면 OT_ECRT여신고객정보 테이블을 이용해야 한다.
           ,(-- 크레딧뷰로신용등급 SET : 계좌번호의 MAX(여신신청번호) 최종 여신신청번호 내역을 SET, 20120813 : RANK()로 변경
             -- 여신계좌번호, 여신승인번호, 여신신청번호, 고객번호, 크레딧뷰로신용등급
             SELECT   TA.CLN_ACNO, TA.CLN_APRV_NO, TA.CLN_APC_NO, TA.CUST_NO, TB.CB_CRDT_GD --크레딧뷰로신용등급
             FROM     (--SOR_PLI_여신신청기본 의 계좌번호별 MAX(CLN_APC_NO)
                       SELECT   TA.*   --여신계좌번호, 여신승인번호, 여신신청번호 MAX, 고객번호
                       FROM     (SELECT  CLN_ACNO, CLN_APRV_NO, CLN_APC_NO, CUST_NO
                                        ,RANK() OVER (PARTITION BY CLN_ACNO ORDER BY CLN_APC_NO DESC) AS SEQ
                                 FROM    DWZOWN.TB_SOR_PLI_CLN_APC_BC  --SOR_PLI_여신신청기본
                                 WHERE   CLN_ACNO  IS NOT NULL) TA
                       WHERE    TA.SEQ = 1)             TA   --SOR_PLI_여신신청기본
                     ,DWZOWN.TB_SOR_PLI_SYS_JUD_RSLT_TR TB   --SOR_PLI_시스템심사결과내역
             WHERE    TA.CLN_APC_NO   = TB.CLN_APC_NO
             AND      TA.CUST_NO      = TB.CUST_NO
            )                                          T23  --SOR_PLI_시스템심사결과내역


   /*--------------------------------------------------------------------------------*/
   /* 20120828 : CB(크레딧뷰로신용등급 UPDATE 처리(20120828기준일부터 적용)          */
   /* T23.CB_CRDT_GD AS 크레딧뷰로신용등급(SOR_PLI_시스템심사결과내역.크레딧뷰로신용등급) */
   /* 개별소스에서 SOR_PLI_시스템심사결과내역의 CB등급을 SET : 개인사업자 등급 없음  */
   /* SOR_PLI_여신신청기본은 계좌단위, SOR_PLI_시스템심사결과내역은 고객번호단위     */
   /* TB_SOR_PLI_EOM_CB_SCR_TR(SOR_PLI_월말크레딧뷰로점수내역) 개인사업자 등급 있음  */
   /* 단, 월말 기준만 있으므로 최종 정보로 UPDATE 한다                               */
   /* SOR_PLI_월말크레딧뷰로점수내역 은 실명번호단위임. 중조구분 없음                */
   /* 20121019 : 05,06소스 신용카드는 신용카드쪽 CB등급을 써야 하는데(DWF_CSM_올인원BSS결과기본.CB등급(한국신용정보신용등급)) */
   /* 20120828 ~ 20121018일자까지 SOR_PLI_월말크레딧뷰로점수내역 의 CB등급으로 UPDATE 되었음(차주실명번호=카드실명번호 인 경우*/
   /* 신용카드를 제외한 차주에 대해서 적용되도록 변경                                */
   /*--------------------------------------------------------------------------------*/
   UPDATE   OT_DWA_INTG_CLN_BC T1                               --DWA_통합여신기본
   SET      T1.CB_CRDT_GD      = T2.CRDT_GD
   FROM     TB_SOR_PLI_EOM_CB_SCR_TR  T2  --SOR_PLI_월말크레딧뷰로점수내역
   WHERE    T1.STD_DT          = v_작업기준일자
   AND      T1.CB_CRDT_GD      IS NULL       --개인사업자등 SOR_PLI_시스템심사결과내역 에서 빠진 정보를 SET
   AND      T1.RNNO            = T2.RNNO
   AND      T2.STD_DT          = (SELECT MAX(STD_DT) FROM TB_SOR_PLI_EOM_CB_SCR_TR WHERE STD_DT <= v_작업기준일자)
   AND      T2.CRDT_GD         <> '000'
   AND      T1.CLN_TSK_DSCD NOT IN ('30','50','17','18')
   --17,18구매카드는 신용등급정보 모두 NULL이므로 UPDATE 되지 않도록 한다.
   --차주실명번호=카드실명번호 인 경우 한신정등급은 동일해서 문제는 없을 것 같다.
   ;

-- CASE 3 통합여신의 CB등급은 계좌별이므로 동일고객의 여러종류의 등급이 나올수 있다.
UPDATE      #가계자금1  T1
SET         T1.CB등급      =  CONVERT(INT,ISNULL(T2.크레딧뷰로신용등급,'0'))
FROM        OT_ECRT여신고객정보      T2
WHERE       LEFT(T1.기준일자,6)  = T2.기준년월
AND         T1.고객번호          = T2.고객번호
AND         T2.점구분코드        = '1'


CB등급(크레딧뷰로등급)

-- 고객별등급 가져오기
고객별 기준시점 CB등급은 전월말기준 TB_DWF_CSM_AIO_BSS_RSLT_BC(DWF_CSM_올인원BSS결과기본) 의 CB등급을 가져오되
(CASE 3가 가장 현실적임) 당월분은 TB_SOR_PLI_SYS_JUD_RSLT_TR(SOR_PLI_시스템심사결과내역) 를 고객별로 뒤져서
보충하는 형식이 되어야 하겠다.
DWF_CSM_올인원BSS결과기본 테이블은 DAD_내부신용등급내역을 만들때 참조하는 테이블로 해당데이터는 TB_ECRT내부신용등급,
OT_ECRT여신고객정보 등으로 전파 사용되고 있다.

-- 계좌별등급 가져오기
통합여신이 기본적으로 계좌별로 최종신청건에 붙어있는 CB등급을 가지고 있으므로 통합여신을 사용하면된다.
통합여신의 내부소스를 보면 TB_SOR_PLI_SYS_JUD_RSLT_TR(SOR_PLI_시스템심사결과내역) 에서 데이터를 가져오고
SOR_PLI_월말크레딧뷰로점수내역 데이터로 빈데이터를 보충하는 형식으로 되어 있다.

-- 참고테이블

-- 계좌별 (아래 테이블에 있는 cb등급은 온라인에서 발생, 동일함(박강국))
TB_SOR_PLI_SYS_JUD_RSLT_TR TB   --SOR_PLI_시스템심사결과내역
TB_SOR_PLI_AIO_ASS_APC_BC --SOR_PLI_올인원여신ASS신청기본
TB_SOR_PLI_AIO_ASS_ASSC_TR  --SOR_PLI_올인원여신ASS평점내역

-- 고객별
TB_SOR_PLI_EOM_CB_SCR_TR    --SOR_PLI_월말크레딧뷰로점수내역, bss에서 쓰기 위해서 고객별 CB등급을 구해놓은 것 (전월말까지만 있음, 월요에 몇일이 지난후에야 들어옴)

-- 올인원이 붙은 테이블은 201208 ~ 201710 까지만 데이터 있으므로 201710이후는 신테이블(CLT_소매모형BSS결과기본 ) 를 사용해야하며
-- 201208전에는 또 다른테이블을 참조해야 한다

//}

//{  #연체일수

-- 20140801 이전에 이자연체가 걸려있어도 연체일수는 20140801이후부터 계산함
-- 대상계좌의 실행건중에 한건이라도 이자연체가 걸려있으면 그날은 연체일수에 포함
SELECT      A.INTG_ACNO                  AS   통합계좌번호
           ,A.CUST_NO                    AS   고객번호
           ,A.CUST_NM                    AS   고객명
           ,A.BSS_CRDT_GD                AS   BSS등급
           ,COUNT(DISTINCT B.STD_DT)     AS   연체일수

FROM        #대상계좌    A

JOIN        DWZOWN.OT_DWA_INTG_CLN_BC   B   --DWA_통합여신기본
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

//{  #연기시점등급 #연기시점 #종통

-- 미완성 참고만..
-- 종통연기시점의 신용등급 구하기
-- 위 작업후 종통들은 차세대이전 신규신청(여신신청구분코드 01~09)건들 찾을수 없는건들이 많다
-- 종통의 경우 기준일시점의 최근연장시 등급이 필요하다는 요청이 오면 아래 쿼리를 이용해서
-- 등급을 update  할 필요가 있어서 만들었으나 이번 자료에는 적용하지 않았다
SELECT      T.기준일자
           ,T.통합계좌번호
           ,B.CLN_APC_DSCD  AS  여신신청구분코드
           ,B.AGR_EXPI_DT   AS  약정만기일자
           ,B.ENR_DT        AS  등록일자
           ,C.CLN_APRV_NO   AS  여신승인번호
           ,E.ASS_CRDT_GD

--INTO        #TEMP         -- DROP TABLE #TEMP
FROM        #대상계좌   T

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
                          AND    A.CLN_ACNO IN ( SELECT  통합계좌번호
                                                 FROM    #대상계좌
                                                 WHERE   기준일자 = '20150731'
                                                 AND     장표종류코드 = '4'
                                               )
                          AND    A.CLN_APC_DSCD    IN ('11','12','13')    -- 여신신청구분코드(11~ 13 연장)
                          AND    A.TR_STCD          = '1'
                          AND    A.AGR_EXPI_DT  > '20150731'
                       )  B
                       ON  A.CLN_ACNO     = B.CLN_ACNO
                       AND A.AGR_TR_SNO   = B.AGR_TR_SNO
                       AND B.SEQ          = 1
            )   B
            ON   T.통합계좌번호 = B.CLN_ACNO

JOIN        TB_SOR_CLI_CLN_APRV_BC   C --SOR_CLI_여신승인기본
            ON  B.CLN_APRV_NO   =  C.CLN_APRV_NO

JOIN        TB_SOR_PLI_SYS_JUD_RSLT_TR      E     -- SOR_PLI_시스템심사결과내역
            ON   C.CLN_APC_NO        = E.CLN_APC_NO
            AND  C.CUST_NO           = E.CUST_NO


WHERE       1=1
AND         T.기준일자 = '20150731'

//}

//{  #복제  #채번기본

SELECT      A.TCB사
           ,CASE WHEN B.SNO  = 1  THEN
                 CASE WHEN A.기술신용등급  IN ('A','A+','A-')  THEN 'A'
                      WHEN A.기술신용등급  IN ('AA','AA+','AA-')  THEN 'AA'
                      WHEN A.기술신용등급  IN ('AAA','AAA+','AAA-')  THEN 'AAA'
                      WHEN A.기술신용등급  IN ('B','B+','B-')  THEN 'B'
                      WHEN A.기술신용등급  IN ('BB','BB+','BB-')  THEN 'BB'
                      WHEN A.기술신용등급  IN ('BBB','BBB+','BBB-')  THEN 'BBB'
                      WHEN A.기술신용등급  IN ('C','C+','C-')  THEN 'C'
                      WHEN A.기술신용등급  IN ('CC','CC+','CC-')  THEN 'CC'
                      WHEN A.기술신용등급  IN ('CCC','CCC+','CCC-')  THEN 'CCC'
                      WHEN A.기술신용등급  IN ('D','D+','D-')  THEN 'D'
                      WHEN A.기술신용등급  IN ('DD','DD+','DD-')  THEN 'DD'
                      WHEN A.기술신용등급  IN ('DDD','DDD+','DDD-')  THEN 'DDD'
                      ELSE 'KKK'
                 END
                 ELSE 'Z.소계'
            END                  AS 기술신용등급

           ,COUNT(CASE WHEN 상품구분 = '기보'       THEN   통합계좌번호 ELSE NULL END)  AS 기보_건수
           ,SUM  (CASE WHEN 상품구분 = '기보'       THEN   대출잔액     ELSE NULL END)  AS 기보_잔액

           ,COUNT(CASE WHEN 상품구분 = '온렌딩대출' THEN   통합계좌번호 ELSE NULL END)  AS 온렝딩_건수
           ,SUM  (CASE WHEN 상품구분 = '온렌딩대출' THEN   대출잔액     ELSE NULL END)  AS 온렌딩_잔액

           ,COUNT(CASE WHEN 상품구분 = '신보' THEN   통합계좌번호 ELSE NULL END)        AS 신보_건수
           ,SUM  (CASE WHEN 상품구분 = '신보' THEN   대출잔액     ELSE NULL END)        AS 신보_잔액

           ,COUNT(CASE WHEN 상품구분 = '일반' THEN   통합계좌번호 ELSE NULL END)        AS 일반_건수
           ,SUM  (CASE WHEN 상품구분 = '일반' THEN   대출잔액     ELSE NULL END)        AS 일반_잔액

FROM        #모집단   A
CROSS JOIN  (
             SELECT   SNO  FROM  OM_DWA_GVNO_BC  WHERE SNO BETWEEN 1 AND 2
            )    B         -- DWA_채번기본

WHERE       1=1
AND         A.기준일자 =  '20150731'
GROUP BY    A.TCB사
           ,기술신용등

//}

//{  #취급시점금리  #금리 #신규시점금리


-- 취급시점금리 일반여신등
UPDATE      #모집단   A
SET         취급시점금리  =  B.적용이율

FROM        (
              SELECT      A.기준일자
                         ,A.통합계좌번호
                         ,A.여신실행번호
                         ,ISNULL(B.APL_IRRT,0)  AS 적용이율

              FROM        #모집단     A

              JOIN        OM_DWA_DT_BC  T     --  DWA_일자기본
                          ON   A.최초대출일자 =  T.STD_DT

              JOIN        OT_DWA_INTG_CLN_BC  B     -- DWA_통합여신기본
                          ON   A.통합계좌번호   = B.INTG_ACNO
                          AND  A.여신실행번호   = B.CLN_EXE_NO
                          AND  T.EOTM_DT        = B.STD_DT
                      --- '330000615843' 계좌한건 빠진다..

            )    B

WHERE       1=1
AND         A.기준일자      = B.기준일자
AND         A.통합계좌번호  = B.통합계좌번호
AND         A.여신실행번호  = B.여신실행번호
;

-- 취급시점금리 종통
UPDATE      #모집단   A
SET         취급시점금리  =  B.적용이율

FROM        (
              SELECT      A.기준일자
                         ,A.통합계좌번호
                         ,A.여신실행번호
                         ,ISNULL(B.APL_IRRT,0)  AS 적용이율

              FROM        #모집단     A

              JOIN        OM_DWA_DT_BC  T     --  DWA_일자기본
                          ON   A.약정일자 =  T.STD_DT

              JOIN        OT_DWA_INTG_CLN_BC  B     -- DWA_통합여신기본
                          ON   A.통합계좌번호   = B.INTG_ACNO
                          AND  T.EOTM_DT        = B.STD_DT
                      --- '330000615843' 계좌한건 빠진다..

              WHERE       A.장표종류코드 = '4'       -- 종통의 경우

            )    B

WHERE       1=1
AND         A.기준일자      = B.기준일자
AND         A.통합계좌번호  = B.통합계좌번호
AND         A.장표종류코드 = '4'       -- 종통의 경우
;


//}

//{  #TCB   #TCB모집단

-- 프로시져 UP_DWZ_여신_N0255_TCB대출현황 에서 나오는 내역과 다른점은
-- 프로시져에서는 통합여신과 EQUAL 조인을 하게 되어 있으므로
-- 기준날짜에 통합여신에 없는계좌(해지된지 1년이 지난계좌 또는 기준일자 이후에 신규발생한 계좌)
-- 는 출력안됨
--
-- 고로 어느시점에 전체 tcb대출은 "2. 계좌원장에서 추출한 모집단" 에서 취급일(실행일 또는 약정일)
-- 이 기준시점 이전인것만 대상으로 하는 것이 옮음
--
-- 1.프로시져내에서 사용하고 있는 모집단  *취소건에 대한 조건문이 없어서 2. 으로 뽑은 모집단과 차이가 나는 시점도 있을듯..
--              SELECT
--                     A.*, B.TCH_EVL_ISN_NO,B.TCH_EVL_TCH_CRDT_GD
--                    ,J.BR_NM
--                    ,C.TCH_EVL_EVSH_DSCD      AS 기술평가평가서구분코드
--                    ,C.TCH_EVL_EVSH_ISN_DT    AS 기술평가평가서발급일자
--                    ,C.TCH_EVL_EVL_RQST_DT    AS 기술평가평가의뢰일자
--                    ,C.TCH_EVL_GD_AVL_DT      AS 기술평가등급유효일자
--                    ,C.TCH_EVL_TCH_CRDT_GD    AS 기술평가기술신용등급
--                    ,C.TCH_EVL_TCH_GD         AS 기술평가기술등급
--                    ,C.TCH_EVL_CRDT_GD        AS 기술평가신용등급
--              FROM   OT_DWA_INTG_CLN_BC      A
--                    ,TB_SOR_LOA_ACN_BSC_DL   B  --LOA_계좌기본상세
--                    ,TB_SOR_CLI_TCH_EVL_RSLT_BC  C   -- SOR_CLI_기술평가결과기본
--                    ,TB_SOR_CMI_BR_BC         J  -- 일점기본
--              WHERE  A.STD_DT  = '20150831'
--              AND    A.BR_DSCD = '1'
--              AND    A.INTG_ACNO = B.CLN_ACNO
--              AND    A.BRNO      = J.BRNO
--              //===============================================================
--              AND    B.TCH_EVL_ISN_NO <> ''           -- 기술평가발급번호가 있는것
--              //===============================================================
--              AND    B.TCH_EVL_ISN_NO  *= C.TCH_EVL_ISN_NO
--              AND    CASE WHEN A.FST_LN_DT IS NOT NULL AND A.FST_LN_DT > '19000000'  THEN A.FST_LN_DT ELSE A.AGR_DT END  > '20140701'
--                      -- TCB시행일 2014.07.01 이전에 신규된계좌는 제외
--                      -- (이후에 연장하면서 TCB를 이용한 케이스 이므로 대부분의 보고서에서 제외하고 나가고 있음)



--  1  시계열원장에서 추출한 TCB대출
--  CASE2는 CURRENT원장을 이용하면 신규시점에는 TCB대출이 아니다가 재약정하면서 TCB평가서번호가 들어가는 경우가 있어서
--          해당시점별로 자료를 발췌하는것보다 크게 나온다..
SELECT      A.STD_YM                          AS  기준년월
           ,A.CUST_NO                         AS  고객번호
           ,T.CUST_NM                         AS  고객명
           ,A.CLN_ACNO                        AS  통합계좌번호
           ,T4.STDD_INDS_CLCD                 AS  업종코드
           ,T4.대분류명                       AS  업종명
           ,T4.ESTB_DT                        AS  설립일자

           ,ISNULL(C.CLN_EXE_NO,0)            AS  여신실행번호
           ,A.CLN_TSK_DSCD                    AS  여신업무구분코드 --(20:종통)
           ,A.AGR_DT                          AS  약정일자
           ,A.AGR_EXPI_DT                     AS  약정만기일자
           ,A.AGR_AMT                         AS  약정금액
           ,A.CLN_ACN_STCD                    AS  여신계좌상태코드
           ,A.ACN_ADM_BRNO                    AS  계좌관리점번호
           ,CASE WHEN SUBSTR(A.PDCD, 6, 4) ='5025'  AND A.LN_SBCD IN ('369','370')  THEN '온렌딩대출'  --온랜딩은 여신정책실 자료발췌용 요건으로
                 WHEN A.MNMG_MRT_CD IN ('504', '505') THEN '기보'
                 WHEN A.MNMG_MRT_CD IN ('501', '502', '503', '517', '535') THEN '신보'
                 ELSE '일반'
            END                               AS  상품구분

           ,A.MNMG_MRT_CD                     AS  담보코드
           ,C.BS_ACSB_CD                      AS  BS계정과목코드
           ,C.CLN_ACN_STCD                    AS  여신실행상태코드
           ,C.LN_DT                           AS  대출일자
           ,C.EXPI_DT                         AS  만기일자
           ,C.CRCD                            AS  통화코드
           ,C.LN_EXE_AMT                      AS  대출실행금액
           ,C.LN_RMD                          AS  대출잔액
           ,SUBSTR(B.TCH_EVL_ISN_NO,1,3)      AS  TCB사
           ,D.TCH_EVL_EVSH_ISN_DT             AS  기술평가평가서발급일자
           ,D.TCH_EVL_TCH_GD                  AS  기술등급

INTO        #TEMP        -- DROP TABLE #TEMP

FROM        TT_SOR_LOA_MM_ACN_BC        A     -- SOR_LOA_월계좌기본

JOIN        TT_SOR_LOA_MM_ACN_BSC_DL    B     -- SOR_LOA_월계좌기본상세
            ON   A.CLN_ACNO   = B.CLN_ACNO
            AND  A.STD_YM     = B.STD_YM
            AND  B.TCH_EVL_ISN_NO  <>  ''   -- 기술평가발급번호

LEFT OUTER JOIN
            TT_SOR_LOA_MM_EXE_BC     C     -- SOR_LOA_월실행기본
            ON   A.CLN_ACNO  =  C.CLN_ACNO
            AND  A.STD_YM    =  C.STD_YM
            AND  C.CLN_ACN_STCD <> '3'        --취소제외

JOIN        TB_SOR_CLI_TCH_EVL_RSLT_BC  D   -- SOR_CLI_기술평가결과기본
            ON   B.TCH_EVL_ISN_NO  = D.TCH_EVL_ISN_NO

JOIN        DWZOWN.OM_DWA_INTG_CUST_BC   T   -- DWA_통합고객기본
            ON   A.CUST_NO   =  T.CUST_NO

JOIN        #TEMP_업종코드        T4
            ON   A.CUST_NO    = T4.CUST_NO

WHERE       A.STD_YM   IN  ('201406','201412','201506','201512','201606','201612','201706','201708')
AND         A.NFFC_UNN_DSCD  =  '1'    -- 중앙회조합구분코드 1:중앙회
AND         A.CLN_ACN_STCD    <> '3'   -- 취소계좌제외
AND         A.AGR_DT >= '20140701'         -- 고정값
            -- 신규(실행이나 약정) 이외에 기간연장시 tcb 평가서를 등록한 경우가 있는데 이런 계좌는 취급일이 20140701 이전일수 밖에없다
            -- 현업에서 이런계좌는 기관보고시에도 제외한다고 하니 걸러내고 작업한다.
            -- 20140701 이전신규일은 제외하고 작업할지 현업에게 당분간은 물어보고 작업해야 함
;


-- 2. 계좌원장에서 추출한 모집단
SELECT      A.CLN_ACNO                        AS  계좌번호
           ,ISNULL(C.CLN_EXE_NO,0)            AS  여신실행번호
           ,A.CLN_TSK_DSCD                    AS  여신업무구분코드 --(20:종통)
           ,A.AGR_DT                          AS  약정일자
           ,A.AGR_EXPI_DT                     AS  약정만기일자
           ,A.AGR_AMT                         AS  약정금액
           ,A.CLN_ACN_STCD                    AS  여신계좌상태코드
           ,A.ACN_ADM_BRNO                    AS  계좌관리점번호
           ,A.MNMG_MRT_CD                     AS  담보코드
           ,C.BS_ACSB_CD                      AS  BS계정과목코드
           ,C.CLN_ACN_STCD                    AS  여신실행상태코드
           ,C.LN_DT                           AS  대출일자
           ,C.EXPI_DT                         AS  만기일자
           ,C.CRCD                            AS  통화코드
           ,C.LN_EXE_AMT                      AS  대출실행금액
           ,C.LN_RMD                          AS  대출잔액
           ,SUBSTR(B.TCH_EVL_ISN_NO,1,3)      AS  TCB사

INTO        #TCB대출

FROM        TB_SOR_LOA_ACN_BC         A

JOIN        TB_SOR_LOA_ACN_BSC_DL     B       --SOR_LOA_계좌기본상세
            ON   A.CLN_ACNO   = B.CLN_ACNO

LEFT OUTER JOIN
            TB_SOR_LOA_EXE_BC         C       --SOR_LOA_실행기본
            ON   A.CLN_ACNO  =  C.CLN_ACNO
            AND  C.CLN_ACN_STCD <> '3'        --취소제외

JOIN        TB_SOR_CLI_TCH_EVL_RSLT_BC  D   -- SOR_CLI_기술평가결과기본
            ON   B.TCH_EVL_ISN_NO  = D.TCH_EVL_ISN_NO

WHERE       A.NFFC_UNN_DSCD  =  '1'    -- 중앙회조합구분코드 1:중앙회
AND         A.CLN_ACN_STCD    <> '3'   -- 취소계좌제외
AND         B.TCH_EVL_ISN_NO  <>  ''   -- 기술평가발급번호
AND         CASE WHEN C.LN_DT IS NOT NULL AND C.LN_DT > '19000000' THEN C.LN_DT ELSE A.AGR_DT END >= '20140701'
            -- 신규(실행이나 약정) 이외에 기간연장시 tcb 평가서를 등록한 경우가 있는데 이런 계좌는 취급일이 20140701 이전일수 밖에없다
            -- 현업에서 이런계좌는 기관보고시에도 제외한다고 하니 걸러내고 작업한다.
            -- 20140701 이전신규일은 제외하고 작업할지 현업에게 당분간은 물어보고 작업해야 함
ORDER BY    1,2
;

--3. 프로시져 결과물로 TCB모집단 만들기

SELECT      통합계좌번호
           ,여신실행번호
           ,출처
           ,관계형성구분
           ,기술평가기술신용등급
           ,고객명
           ,고객번호
           ,업종명
           ,매출액
           ,설립일자
           ,신용등급
           ,기술등급
           ,기업신용평가등급_최종승인번호
           ,약정일자
           ,약정금액
           ,최초대출일자
           ,대출실행금액
           ,대출잔액
           ,적용이율
           ,발급일자
INTO        #TEMP            -- DROP TABLE #TEMP
FROM        DWZPRC.UP_DWZ_여신_N0255_TCB대출현황(1,'','20150831','20150831')
;

SELECT   COUNT(*) FROM #TEMP;          -- 119



//-- TCB 신규대출 계좌만 추린다
SELECT      A.고객번호
           ,A.통합계좌번호
           ,A.여신실행번호
           ,A.기술등급
           ,A.출처                            AS TCB사
           ,A.관계형성구분                    AS 관계형성구분
           ,A.기업신용평가등급_최종승인번호   AS 기업신용평가등급
           ,A.기술평가기술신용등급            AS 기술신용등급

INTO        #대상계좌     -- DROP TABLE #대상계좌
FROM        #TEMP       A
WHERE        CASE WHEN A.최초대출일자 IS NOT NULL AND A.최초대출일자 > '19000000'  THEN A.최초대출일자 ELSE A.약정일자 END  > '20140701'
;
SELECT   COUNT(*) FROM #대상계좌;          -- 113


//}

//{  #여신신청  #여신신청월별   #월별여신신청  #담보설정  #월별담보설정


-- 담보설정내역 년도별 임시테이블 생성
CREATE TABLE  #여신신청
(
  기준일자            CHAR(8),
  여신신청번호        CHAR(14),
  담보번호            CHAR(12),
  설정번호            CHAR(12),
  여신계좌번호        CHAR(20),
  광역시도코드        CHAR(2),
  시군구코드          CHAR(3),
  읍면동코드          CHAR(3),
  리명코드            CHAR(2),
  광역시도명          CHAR(100),
  시군구명            CHAR(100),
  읍면동명            CHAR(100),
  리명                CHAR(3),
  물건소재지상세주소  CHAR(200),
  순서                INT
)
;

BEGIN   --  TRUNCATE TABLE #여신신청;


  DECLARE   V_BASEDAY    CHAR(8);
  DECLARE   V_BASEMON    CHAR(6);

--SET       V_BASEDAY  = '20111231';
--SET       V_BASEDAY  = '20121231';
--SET       V_BASEDAY  = '20131231';
--SET       V_BASEDAY  = '20141231';
  SET       V_BASEDAY  = '20150731';

  SELECT    LEFT(V_BASEDAY,6)  INTO   V_BASEMON;

  INSERT INTO #여신신청
  SELECT      V_BASEDAY      AS 기준일자
             ,B.CLN_APC_NO   AS 여신신청번호
             ,A.MRT_NO       AS 담보번호
             ,A.STUP_NO      AS 설정번호
             ,B.ACN_DCMT_NO  AS 여신계좌번호
             ,C.MPSD_CD
             ,C.CCG_CD
             ,C.EMD_CD
             ,C.LINM_CD
             ,C.MPSD_NM          --광역시도명
             ,C.CCG_NM           --시군구명
             ,C.EMD_NM           --읍면동명
             ,C.LINM             --리명
             ,C.THG_SIT_DTL_ADR  --물건소재지상세주소
             ,RANK() OVER (PARTITION BY B.ACN_DCMT_NO ORDER BY B.CLN_APC_NO, A.STUP_NO, A.MRT_NO) AS 대표_담보
  FROM        TT_SOR_CLM_MM_STUP_BC     A   --SOR_CLM_월설정기본
             ,TT_SOR_CLM_MM_CLN_LNK_TR  B   --SOR_CLM_월여신연결내역
             ,TT_SOR_CLM_MM_REST_MRT_BC C   --SOR_CLM_월부동산담보기본
  WHERE       A.NFFC_UNN_DSCD = '1'           --중앙회조합구분코드
  AND         A.STUP_STCD     = '02'            --설정상태코드(02:정상등록)
  AND         A.STUP_NO       = B.STUP_NO        --설정번호
  AND         B.CLN_LNK_STCD  IN ('02','03')  --여신연결상태코드(02:정상,03:해지예정)
  AND         A.MRT_NO        = C.MRT_NO
  AND         C.MPSD_CD       IS NOT NULL
  AND         A.STD_YM         = V_BASEMON
  AND         B.STD_YM         = V_BASEMON
  AND         C.STD_YM         = V_BASEMON
  ;

END
;

//}

//{  #현실가치유효담보금액 #유효담보 #감정금액

-- 1번쿼리  ( 계좌별 감정금액 및 현실가치유효담보금액을 구하는 쿼리인데 틀린것 같음)
LEFT OUTER JOIN
            (
             SELECT    C.STD_DT             AS 기준일자
                      ,C.INTG_ACNO          AS 통합계좌번호
                      --,D.MRT_NO             AS 담보번호
                      ,SUM(C.APSL_AMT)      AS 감정금액
                      ,SUM(C.ACWR_AVL_MRAM) AS 현실가치유효담보금액
             FROM      TB_SOR_CLM_MRT_APRT_EOM_TZ C
             JOIN      (
                        SELECT   STD_DT           AS  기준일자
                                ,INTG_ACNO        AS  통합계좌번호
                                ,MRT_NO           AS  담보번호
                                ,MRT_CD           AS  담보코드
                                ,MAX(STUP_NO)     AS  설정번호
                        FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ --SOR_CLM_채무자별담보배분월말집계
                        WHERE   1=1
                        AND     STD_DT = '20150831'
                        AND     MRT_APRT_TPCD  = '01' --담보배분유형코드
                        AND     MRT_NO <> '999999999999'
                        AND     STUP_NO <> '999999999999'
                        GROUP BY 기준일자, 통합계좌번호, 담보번호, 담보코드
                       ) D
                       ON    C.STD_DT    = D.기준일자
                       AND   C.INTG_ACNO = D.통합계좌번호 --AND C.INTG_ACNO = '101008338879'
                       AND   C.MRT_NO    = D.담보번호
                       AND   C.STUP_NO   = D.설정번호
                       AND   C.MRT_CD    = D.담보코드
             WHERE     1=1
             AND       C.MRT_APRT_TPCD   = '01'
             GROUP BY  C.STD_DT, C.INTG_ACNO       --, C.MRT_CD
            ) B
            ON    A.STD_DT     =  B.기준일자
            AND   A.INTG_ACNO  =  B.통합계좌번호


-- 2번쿼리
LEFT OUTER JOIN
            (
               SELECT    A.기준일자
                        ,A.통합계좌번호
                        ,SUM(A.감정금액)             AS 감정금액
                        ,SUM(A.현실가치유효담보금액) AS 현실가치유효담보금액
               FROM
               (      -- 계좌별 담보별 SUB
                 SELECT    C.STD_DT             AS 기준일자
                          ,C.INTG_ACNO          AS 통합계좌번호
                          ,C.MRT_CD             AS 담보코드
                          ,C.MRT_NO             AS 담보번호
                          ,MAX(C.APSL_AMT)      AS 감정금액
                          ,MAX(C.ACWR_AVL_MRAM) AS 현실가치유효담보금액
                          ,MAX(C.LQWR_AVL_MRAM) AS 청산가치유효담보금액
                          ,MAX(C.PRRN_AMT)      AS 선순위금액
                          ,MAX(C.ACF_RT)        AS 경락율

                 FROM      TB_SOR_CLM_MRT_APRT_EOM_TZ C -- SOR_CLM_채무자별담보배분월말집계
                 JOIN      (
                            SELECT   STD_DT           AS  기준일자
                                    ,INTG_ACNO        AS  통합계좌번호
                                    ,MRT_NO           AS  담보번호
                                    ,MRT_CD           AS  담보코드
                                    ,MAX(STUP_NO)     AS  설정번호
                            FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ --SOR_CLM_채무자별담보배분월말집계
                            WHERE   1=1
                            AND     MRT_APRT_TPCD  = '01' --담보배분유형코드
                            AND     MRT_NO <> '999999999999'
                            AND     STUP_NO <> '999999999999'
                            ---------------------------------------------------------------------------------
                            AND     STD_DT     =  '20150930'     -- 9월말 자료만 필요하므로
                            AND     MRT_CD NOT IN ('601','602')  -- 인보증(601), 순수신용(602) 제외
                            AND     NFM_YN     = 'N'             -- 견질담보여부
                            ---------------------------------------------------------------------------------
                            GROUP BY 기준일자, 통합계좌번호, 담보번호, 담보코드
                           ) D
                           ON    C.STD_DT    = D.기준일자
                           AND   C.INTG_ACNO = D.통합계좌번호 --AND C.INTG_ACNO = '101008338879'
                           AND   C.MRT_NO    = D.담보번호
                           AND   C.STUP_NO   = D.설정번호
                           AND   C.MRT_CD    = D.담보코드
                 WHERE     1=1
                 AND       C.MRT_APRT_TPCD   = '01'
                 GROUP BY  C.STD_DT, C.INTG_ACNO, C.MRT_CD, C.MRT_NO
               )     A
               GROUP BY  A.기준일자
                        ,A.통합계좌번호
            ) B
            ON    A.STD_DT     =  B.기준일자
            AND   A.INTG_ACNO  =  B.통합계좌번호


--          SOR_CLM_채무자별담보배분월말집계 테이블에서 최종설정번호에 해당하는 레코드를 추출하면
--          실행번호별로 여러건 나온다. 아래 쿼리로 DISTINCT 값을 COUNT 해보면 2건이상 나오는것이 한건도 없으므로
--          각 실행번호별로 감정금액,현실가치유효담보금액,청산가치유효담보금액,선순위금액,경락율 값은
--          동일하게 들어가 있음을 알수있다
--          고로 바깥쿼리에서 MAX 값을 취해서 가져와도 무방하다.
--          1번 쿼리는 계좌별로 감정금액등을 구하는 쿼리인데 SUM을 시켜버리면 실행번호별로 금액이 중복될수있다
--          2번 쿼리를 이용해서 담보별로 감정금액등을 구한뒤에 SUM을 시켜야 할것이다.
--
--           SELECT    C.STD_DT, C.INTG_ACNO, C.MRT_CD, C.MRT_NO
--                    ,COUNT(DISTINCT C.APSL_AMT)
--                    ,COUNT(DISTINCT C.ACWR_AVL_MRAM)
--                    ,COUNT(DISTINCT C.LQWR_AVL_MRAM)
--                    ,COUNT(DISTINCT C.PRRN_AMT)
--                    ,COUNT(DISTINCT C.ACF_RT)
--           FROM      TB_SOR_CLM_MRT_APRT_EOM_TZ C -- SOR_CLM_채무자별담보배분월말집계
--           JOIN      (
--                      SELECT   STD_DT           AS  기준일자
--                              ,INTG_ACNO        AS  통합계좌번호
--                              ,MRT_NO           AS  담보번호
--                              ,MRT_CD           AS  담보코드
--                              ,MAX(STUP_NO)     AS  설정번호
--                      FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ --SOR_CLM_채무자별담보배분월말집계
--                      WHERE   1=1
--                      AND     STD_DT = '20150630'
--                      AND     MRT_APRT_TPCD  = '01' --담보배분유형코드
--                      AND     MRT_NO <> '999999999999'
--                      AND     STUP_NO <> '999999999999'
--                      GROUP BY 기준일자, 통합계좌번호, 담보번호, 담보코드
--                     ) D
--                     ON    C.STD_DT    = D.기준일자
--                     AND   C.INTG_ACNO = D.통합계좌번호 --AND C.INTG_ACNO = '101008338879'
--                     AND   C.MRT_NO    = D.담보번호
--                     AND   C.STUP_NO   = D.설정번호
--                     AND   C.MRT_CD    = D.담보코드
--           WHERE     1=1
--           AND       C.MRT_APRT_TPCD   = '01'
--           GROUP BY  C.STD_DT, C.INTG_ACNO, C.MRT_CD, C.MRT_NO
--           HAVING    COUNT(DISTINCT C.APSL_AMT) > 1 OR COUNT(DISTINCT C.ACWR_AVL_MRAM) > 1 OR COUNT(DISTINCT C.LQWR_AVL_MRAM) > 1 OR
--                     COUNT(DISTINCT C.PRRN_AMT) > 1 OR COUNT(DISTINCT C.ACF_RT) > 1
--

//}

//{  #조합환전 #조합송금 #상호금융부

SELECT      '1.환전'      AS 업무구분
           ,A.TR_BRNO     AS 거래점번호
           ,A.RNNO        AS 실명번호
           ,A.TR_DT       AS 거래일

INTO        #TEMP            -- DROP TABLE #TEMP
FROM        TB_SOR_INX_EFM_BC    A
WHERE       1=1
AND         A.TR_DT  BETWEEN '20130101' AND '20150630'    -- 거래일자
AND         A.FRXC_LDGR_STCD NOT IN ('4','5','6','7','8') -- 정정취소제외
AND         A.NFFC_UNN_DSCD ='2'
AND         A.REF_NO LIKE 'EJ%'

UNION ALL

SELECT      '2.송금'     AS  업무구분
           ,SUBSTRING(A.REF_NO,3,4)   AS  거래점번호
           ,RMPR_RNNO                 AS  실명번호
           ,A.TR_DT 거래일

FROM        DWZOWN.TB_SOR_INX_OWMN_BC   A  -- SOR_INX_당발송금기본
WHERE       1=1
AND         A.NFFC_UNN_DSCD =  '2'          --  중앙회조합구분코드 (2:조합)
AND         A.TR_DT  BETWEEN '20130101' AND '20150630'    -- 거래일자
AND         A.FRXC_LDGR_STCD   IN  ('7','8','9')   -- 외신전문승인완료건 (7: 퇴결,8:퇴결지급, 9:종결)
              -- 8 퇴결지급 은 종결되었던 건이 수신자은행에서 정상지급이 되지 못하고 돌아오는 경우
              --   송금인에게 다시 돌려주는건으로 일단 종결되었던 송금건은 맞으므로 대상에 포함함.
;


//}

//{  #연대보증인  #보증인 #보증인담보

-- 월별테이블 이용예
SELECT      T.기준일자
           ,A.ACN_DCMT_NO      AS 계좌번호
           ,B.DBR_RLT_DSCD     AS 채무자관계
           ,C.GRNR_CUST_NO     AS 보증인
           ,B.MRT_NO           AS 담보번호
           ,B.ENR_DT           AS 등록일자
           ,ROW_NUMBER() OVER(PARTITION BY T.기준일자,A.ACN_DCMT_NO ORDER BY B.ENR_DT DESC) AS 보증순서

INTO        #보증인 -- DROP TABLE  #보증인

FROM        #모집단_기업여신    T

JOIN        TT_SOR_CLM_MM_CLN_LNK_TR          A          --SOR_CLM_월여신연결내역
            ON   LEFT(T.기준일자,6)  =  A.STD_YM
            AND  T.통합계좌번호      =  A.ACN_DCMT_NO
            AND  A.CLN_LNK_STCD      = '02'             --여신연결상태코드(02:정상,03:해지예정)
            AND  A.ACN_DCMT_NO       > ' '              -- 계좌식별번호

JOIN        TT_SOR_CLM_MM_STUP_BC             B         --SOR_CLM_월설정기본
            ON   A.STD_YM            =  B.STD_YM
            AND  A.STUP_NO           = B.STUP_NO        --설정번호
            AND  B.MRT_TPCD          = '6'              -- 담보유형코드(6:보증인)
            AND  B.STUP_STCD        IN ('02','03')      --설정상태코드(02:정상등록,03:해지예정)


JOIN        TT_SOR_CLM_MM_GRNR_MRT_BC          C         --SOR_CLM_월보증인담보기본
            ON   B.STD_YM           =   C.STD_YM
            AND  B.MRT_NO           =   C.MRT_NO
            AND  C.MRT_STCD         =   '02'             --담보상태코드(02:정상등록)

WHERE       1=1
;



LEFT OUTER JOIN
             #보증인            C
             ON    A.기준일자         =    C.기준일자
             AND   A.통합계좌번호     =    C.계좌번호
             AND   C.보증순서         =    1


-- case2 연대보증인의 나이등 구하기, 연대보증인이 여러명일경우 대표 보증인 한명 구하기.

SELECT      DISTINCT
            A.기준일자
           ,A.통합계좌번호
           ,A.실명번호
           ,A.여신신청번호
           ,E.GRNR_CUST_NO     AS  보증인고객번호
           ,F.CUST_NM          AS  보증인고객명
           ,F.DTH_DT           AS  사망일자
           ,CASE WHEN  SUBSTR(F.CUST_RNNO,7,1) IN ('0','9') THEN '18'  --1800년대 남성,여성
                 WHEN  SUBSTR(F.CUST_RNNO,7,1) IN ('1','2') THEN '19'  --1900년대 남성,여성
                 WHEN  SUBSTR(F.CUST_RNNO,7,1) IN ('3','4') THEN '20'  --2000년대 남성,여성
                 WHEN  SUBSTR(F.CUST_RNNO,7,1) IN ('5','6') THEN '19'  --1900년대 외국인남성,여성
                 WHEN  SUBSTR(F.CUST_RNNO,7,1) IN ('7','8') THEN '20'  --2000년대 외국인남성,여성
            END  ||    SUBSTR(F.CUST_RNNO,1,6)   AS   생년월일

           ,CONVERT(INT,LEFT(A.기준일자,4)) - CONVERT(INT,LEFT(생년월일,4)) + CASE WHEN CONVERT(INT,RIGHT(생년월일,4)) > CONVERT(INT,RIGHT(A.기준일자,4)) THEN -1 ELSE 0 END   AS   만나이

           ,CASE WHEN 만나이 <  30                   THEN '1.29세이하'
                 WHEN 만나이 >= 30  AND 만나이 < 40  THEN '2.30세이상 ~ 39세이하'
                 WHEN 만나이 >= 40  AND 만나이 < 50  THEN '3.40세이상 ~ 49세이하'
                 WHEN 만나이 >= 50  AND 만나이 < 60  THEN '4.50세이상 ~ 59세이하'
                 WHEN 만나이 >= 60  AND 만나이 < 70  THEN '5.60세이상 ~ 69세이하'
                 WHEN 만나이 >= 70                     THEN '6.70세 이상'
            END              AS  나이구분

--           ,ROW_NUMBER() OVER(PARTITION BY A.통합계좌번호 ORDER BY D.STUP_AMT DESC) AS 대표보증인
           ,ROW_NUMBER() OVER(PARTITION BY A.통합계좌번호 ORDER BY 만나이 DESC) AS 대표보증인

INTO        #TEMP_연대보증         -- DROP TABLE #TEMP_연대보증

FROM        ( SELECT  DISTINCT 기준일자,통합계좌번호,실명번호,여신신청번호  FROM  #연체채권)     A

JOIN        DWZOWN.TB_SOR_CLM_CLN_LNK_TR   C  -- SOR_CLM_여신연결내역
            ON   A.여신신청번호      = C.CLN_APC_NO
--            AND  C.CLN_LNK_STCD      = '02'    -- 여신연결상태코드(02:정상등록) 현재상태에서 연결상태가 끊어진것은 제외하고 출력

JOIN        DWZOWN.TB_SOR_CLM_STUP_BC       D  -- SOR_CLM_설정기본
            ON   C.STUP_NO   =  D.STUP_NO

JOIN        DWZOWN.TB_SOR_CLM_GRNR_MRT_BC        E        --SOR_CLM_보증인담보기본
            ON   D.MRT_NO           =   E.MRT_NO
--            AND  C.MRT_STCD         =   '02'            --담보상태코드(02:정상등록)

JOIN        DWZOWN.OM_DWA_INTG_CUST_BC   F
            ON    E.GRNR_CUST_NO   =  F.CUST_NO          -- 보증인고객번호
;
//}

//{  #지점장 #책임자


-- 1. 통합여신에서 쓰는 권유자,책임자,지점장 구하는 쿼리,..좀 이상한듯
--    현재시점에서 가장 기여도가 높은건을 가져오는것이 취지인데..
           ,( -- 기여도비율이 가장 높은 권유자 추출
             SELECT   TA.CLN_ACNO                                --
                     ,TA.CLN_EXE_NO                              --
                     ,MAX(CASE WHEN TA.LN_HDL_PTCP_DSCD = '01' THEN TA.USR_NO END) AS USR_NO1        -- 권유자
                     ,MAX(CASE WHEN TA.LN_HDL_PTCP_DSCD = '02' THEN TA.USR_NO END) AS USR_NO2        -- 취급책임자
                     ,MAX(CASE WHEN TA.LN_HDL_PTCP_DSCD = '03' THEN TA.USR_NO END) AS USR_NO3        -- 취급지점장
             FROM     DWZOWN.TB_SOR_LOA_HDL_PTCP_DL  TA
                     ,(SELECT   CLN_ACNO                         --
                               ,CLN_EXE_NO                       --
                               ,SNO                              --일련번호
                               ,LN_HDL_PTCP_DSCD
                               ,MAX(CNDG_RT) AS CNDG_RT          --기여도비율
                       FROM     DWZOWN.TB_SOR_LOA_HDL_PTCP_DL
                       WHERE    LN_HDL_PTCP_DSCD IN ('01','02','03')         --대출취급관계좌구분코드('01':권유자)
                       GROUP BY CLN_ACNO                         --
                               ,CLN_EXE_NO                       --
                               ,SNO
                               ,LN_HDL_PTCP_DSCD)    TB
             WHERE    1=1
             AND      TA.CLN_ACNO         = TB.CLN_ACNO                --
             AND      TA.CLN_EXE_NO       = TB.CLN_EXE_NO              --
             AND      TA.SNO              = TB.SNO                     --일련번호
             AND      TA.LN_HDL_PTCP_DSCD = TB.LN_HDL_PTCP_DSCD        --일련번호
             GROUP BY TA.CLN_ACNO, TA.CLN_EXE_NO
            )                                          T7  --SOR_LOA_취급관계자상세(권유자)

--2. 최초 지점장번호를 알고자하는 경우
-- 개별 실행건의 완제여부와 상관없이 최초취급시 지점정을 가져오는 쿼리
SELECT      TA.CLN_ACNO        AS   통합계좌번호
           ,TA.CLN_EXE_NO      AS   여신실행번호
           ,TA.USR_NO          AS   거래점장사용자번호
           ,C1.사번            AS   거래점장사용자명
           ,ROW_NUMBER() OVER(PARTITION BY TA.CLN_ACNO ORDER BY TA.CLN_EXE_NO ASC) AS 순서
INTO        #TEMP  -- DROP TABLE #TEMP
FROM        DWZOWN.TB_SOR_LOA_HDL_PTCP_DL  TA
JOIN        (
             SELECT   CLN_ACNO                         --
                     ,CLN_EXE_NO                       --
                     ,SNO                              --일련번호
                     ,LN_HDL_PTCP_DSCD
                     ,MAX(CNDG_RT) AS CNDG_RT          --기여도비율
             FROM     DWZOWN.TB_SOR_LOA_HDL_PTCP_DL
             WHERE    LN_HDL_PTCP_DSCD = '03'    -- 지점장
             GROUP BY CLN_ACNO                         --
                     ,CLN_EXE_NO                       --
                     ,SNO
                     ,LN_HDL_PTCP_DSCD
            )    TB
            ON     TA.CLN_ACNO         = TB.CLN_ACNO
            AND    TA.CLN_EXE_NO       = TB.CLN_EXE_NO              --
            AND    TA.LN_HDL_PTCP_DSCD = TB.LN_HDL_PTCP_DSCD        --일련번호
            AND    TA.CNDG_RT          = TB.CNDG_RT

JOIN        TB_MDWT인사  C1
            ON    TA.USR_NO  =  C1.사번
            AND   C1.작성기준일     =  '20170630'

WHERE       1=1
;

--3. 최초 지점장 및 책임자 번호를 알고자하는 경우
--  최초 책임자와 지점장 구하기 위한 임시테이블 생성
--  현재로써는 이 로직이 가장 정확한듯..
SELECT      TA.CLN_ACNO          AS   통합계좌번호
           ,TA.CLN_EXE_NO        AS   여신실행번호
           ,TA.LN_HDL_PTCP_DSCD  AS   대출취급관계자구분코드
           ,TA.CNDG_RT           AS   기여율
           ,TA.USR_NO            AS   사용자번호
           ,C1.성명              AS   사용자성명
           ,ROW_NUMBER() OVER(PARTITION BY TA.CLN_ACNO,TA.LN_HDL_PTCP_DSCD ORDER BY TA.CNDG_RT DESC) AS 기여순서
INTO        #TEMP    -- DROP TABLE #TEMP
FROM        DWZOWN.TB_SOR_LOA_HDL_PTCP_DL  TA
JOIN        TB_MDWT인사  C1
            ON    TA.USR_NO  =  C1.사번
            AND   C1.작성기준일     =  '20170731'
WHERE       1=1
AND         TA.CLN_EXE_NO IN (0,1)  -- 실행번호가 가장빠른것 종통이면 0 일것이고 실행가능한 여신이면 1일 것이다
;



LEFT OUTER JOIN
            #TEMP    D1
            ON    A.INTG_ACNO   =  D1.통합계좌번호
            AND   D1.대출취급관계자구분코드  =  '02'  -- 책임자
            AND   D1.기여순서 = 1

LEFT OUTER JOIN
            #TEMP    D2
            ON    A.INTG_ACNO   =  D2.통합계좌번호
            AND   D2.대출취급관계자구분코드  =  '03'  -- 지점장
            AND   D2.기여순서 = 1
//}

//{ #점우편번호 #신우편번호 #점테이블

SELECT A.BRNO 점번호
     , CASE WHEN A.UNN_ABV_NM = '수협은행' THEN NULL ELSE  A.UNN_ABV_NM END 조합명
     , A.BR_NM 지점명
     , A.GRCD 지로코드
     , ISNULL(A.TL_ARCD, A.TL_ARCD || '-' || A.TL_TONO || '-' || A.TL_SNO) 전화
     , ISNULL(A.FAX_TL_ARCD, A.FAX_TL_ARCD || '-' || A.FAX_TL_TONO || '-' || A.FAX_TL_SNO) 팩스
     , SUBSTR(A.ZIP,1,3) || '-' || SUBSTR(A.ZIP,4,3) 우편번호
     , D.ZIP         AS 새우편번호
  FROM TB_SOR_CMI_BR_BC        A
      ,TB_SOR_CMI_RD_NM_ADR_BC D
 WHERE A.BRNO < '1000'
   AND A.BR_DSCD = '2' --
   AND A.BR_STCD = '01' -- 정상영업점
   AND A.BR_KDCD = '20' -- 영업점
   AND SUBSTR(A.ZIP_SNO, 1, 12) = D.RD_NM_CD
   AND SUBSTR(A.ZIP_SNO, 13, 3) = D.EMD_CD
   AND (  ( (D.BLD_MNNO || CASE WHEN D.BLD_SBNO = '0' THEN NULL ELSE  '-' || D.BLD_SBNO END) = SUBSTR(A.BZADR,1,LOCATE(A.BZADR,'(')-1) ) OR
          ( (D.BLD_MNNO || CASE WHEN D.BLD_SBNO = '0' THEN NULL ELSE  '-' || D.BLD_SBNO END) = SUBSTR(A.BZADR,1,LOCATE(A.BZADR,',')-1) ) OR
          ( (D.BLD_MNNO || CASE WHEN D.BLD_SBNO = '0' THEN NULL ELSE  '-' || D.BLD_SBNO END) = A.BZADR                                 )
       )
 ORDER BY BRNO;


0684  죽변수협   원남지점 0076843 054   054   767-863 767863  4793033250070200012200000


DBA.DESC_TABLE DWZOWN,TB_SOR_CMI_RD_NM_ADR_BC

SELECT ZIP_SNO,BZADR,SUBSTR(BZADR,1,LOCATE(BZADR,'(')-1)
FROM  TB_SOR_CMI_BR_BC
WHERE  BRNO = '0684'
-- 479303325007002

SELECT D.RD_NM_CD,D.EMD_CD,BLD_MNNO,BLD_SBNO,D.BLD_MNNO || CASE WHEN D.BLD_SBNO = '0' THEN NULL ELSE  '-' || D.BLD_SBNO END
FROM   TB_SOR_CMI_RD_NM_ADR_BC D
WHERE  UNQ_BLD_ADM_SNO = '4793033250070200012200000'


//}

//{ #최초실행 #첫실행

JOIN
            (
             SELECT  A.CLN_ACNO
                    ,A.CLN_ACN_STCD
                    ,A.AGR_DT
                    ,B.CLN_EXE_NO
                    ,B.LN_DT
                    ,ROW_NUMBER() OVER(PARTITION BY B.CLN_ACNO ORDER BY B.LN_DT ASC) AS 실행순서
             FROM    TB_SOR_LOA_ACN_BC  A        --  SOR_LOA_계좌기본
             LEFT OUTER JOIN
                     TB_SOR_LOA_EXE_BC  B
                     ON  A.CLN_ACNO   = B.CLN_ACNO
                     AND B.CLN_ACN_STCD <> '3'
             WHERE   1=1
             AND     A.CLN_ACNO IN ( SELECT 계좌번호 FROM #대상계좌 )
            )    B
            ON    A.계좌번호  =  B.CLN_ACNO
            AND   B.실행순서  =  1

//}

//{ #약정신규 #연장 #연장신규
-- 통합여신 종통의 경우 과거 약정건에 대한 연장일이 통합여신에 들어오는
-- 경우가 있어서 약정일 보다 연장일이 더 빠른것들이 있으므로 조심해야 한다

AND         (
                  LEFT(A.AGR_DT,6)      = LEFT(A.STD_DT,6)  OR     -- 약정신규 또는
                  (
                     A.AGR_DT              < A.PSTP_ENR_DT     AND
                     LEFT(A.PSTP_ENR_DT,6) = LEFT(A.STD_DT,6)            -- 연장
                   )
            )

//}

//{ #심사부 #본부승인 #전결구분

-- CASE 1
-- 신청원장에서 본부심사와 영업점전결여신 구분하
CREATE  TABLE  #TEMP_본부승인      --  DROP TABLE  #TEMP_본부승인
(
            기준일자             CHAR(8)
           ,계좌번호             CHAR(20)
           ,점명                 CHAR(100)
           ,심사구분             CHAR(10)
           ,승인일자             CHAR(8)
           ,승인번호             CHAR(14)
           ,담당심사역사용자번호 CHAR(10)
           ,여신신청구분코드     CHAR(2)
           ,여신전결구분         CHAR(100)
           ,신청점               CHAR(5)
);


--#TEMP_본부승인
--심사부(0627) 승인건 발췌
--각 계좌의 최종신청건에 대한 승인점이 심사부인것들만 대상
--가계여신은 모두 심사부 여신으로 봄
BEGIN
DECLARE     V_BASEDAY   CHAR(8);

SET         V_BASEDAY = '20151031';

--기업여신
SELECT      A.ACN_DCMT_NO         AS 계좌번호
           --,B.APRV_BRNO           AS 승인점번호
           ,TRIM(D.BR_NM)         AS 승인점
           ,'기업심사'            AS 심사구분
           ,B.HDQ_APRV_DT         AS 승인일자
           ,A.CLN_APRV_NO         AS 승인번호
           ,B.RSBL_XMRL_USR_NO    AS 담당심사역사용자번호
           ,A.CLN_APC_DSCD        AS 신청구분
           ,B.CSLT_BRNO           AS 신청점
INTO        #TEMP
FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
           ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
           ,(SELECT   A.ACN_DCMT_NO         AS 계좌번호
                     ,MAX(B.HDQ_APRV_DT)    AS 승인일자
             FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
                     ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
             WHERE    A.ACN_DCMT_NO       IS NOT NULL
             AND      A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
             AND      A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
             AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
             AND      B.APCL_DSCD         = '2'               -- 승인여신구분코드(1:영업점승인,2:본부승인)
             AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
             AND      B.HDQ_APRV_DT       BETWEEN '20120101' AND V_BASEDAY   -- 승인일자
             GROUP BY A.ACN_DCMT_NO
            ) C
           ,OT_DWA_DD_BR_BC D  --DWA_일점기본
WHERE       A.ACN_DCMT_NO       IS NOT NULL
AND         A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
AND         B.APCL_DSCD         = '2'               -- 승인여신구분코드(1:영업점승인,2:본부승인)
AND         A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
AND         B.HDQ_APRV_DT       BETWEEN '20120101' AND V_BASEDAY   -- 승인일자
AND         A.ACN_DCMT_NO       = C.계좌번호
AND         B.HDQ_APRV_DT       = C.승인일자
AND         B.APRV_BRNO         *= D.BRNO
AND         D.STD_DT            = V_BASEDAY
AND         B.APRV_BRNO         =  '0627'           -- 심사부승인
AND         D.BRNO              <> 'XXXX'

UNION ALL

--개인여신의 경우 모두 심사부승인
SELECT      A.CLN_ACNO         AS 계좌번호
           ,'심사부'           AS 승인점번호
           ,'개인심사'         AS 심사구분
           ,A.CLN_APRV_DT      AS 승인일자
           ,A.CLN_APRV_NO        AS 승인번호
           ,A.RSBL_XMRL_USR_NO   AS 담당심사역사용자번호
           ,A.CLN_APC_DSCD       AS 신청구분
           ,A.ADM_BRNO           AS 신청점
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
           ,(SELECT   A.CLN_ACNO         AS 계좌번호
                     ,MAX(A.CLN_APRV_DT) AS 승인일자
             FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
             WHERE    A.CLN_ACNO          IS NOT NULL
             AND      A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
             AND      A.CSS_XCDC_DSCD     = '22'              -- CSS전결구분코드(11:지소장-조합,21:점장-중앙회,22:부서장(중앙회))
             AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
             AND      A.CLN_APRV_DT       BETWEEN '20120101' AND V_BASEDAY   -- 승인일자
             GROUP BY A.CLN_ACNO
            ) B
WHERE       A.CLN_ACNO          IS NOT NULL
AND         A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
AND         A.CSS_XCDC_DSCD     = '22'              -- CSS전결구분코드(11:지소장-조합,21:점장-중앙회,22:부서장(중앙회))
AND         A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
AND         A.CLN_APRV_DT       BETWEEN '20120101' AND V_BASEDAY   -- 승인일자
AND         A.CLN_ACNO          = B.계좌번호
AND         A.CLN_APRV_DT       = B.승인일자
;

INSERT INTO #TEMP_본부승인
SELECT      V_BASEDAY
           ,A.계좌번호
           ,A.승인점
           ,A.심사구분
           ,A.승인일자
           ,A.승인번호
           ,A.담당심사역사용자번호
           ,A.신청구분
           ,C.LST_XCDC_DSCD ||'('||TRIM(D.XCDC_DSCD_NM)||')'  AS 여신전결구분
           ,A.신청점

FROM        #TEMP A

JOIN        (
             SELECT   A.계좌번호
                     ,A.승인일자
                     ,MAX(A.승인번호)   AS 최종승인번호
             FROM     #TEMP A
                     ,(SELECT   계좌번호
                               ,MAX(승인일자)   AS 최종승인일자
                       FROM     #TEMP
                       GROUP BY 계좌번호
                       ) B
             WHERE    A.계좌번호 = B.계좌번호
             AND      A.승인일자 = B.최종승인일자
             GROUP BY A.계좌번호
                     ,A.승인일자
            ) B
            ON   A.계좌번호    = B.계좌번호
            AND  A.승인일자    = B.승인일자
            AND  A.승인번호    = B.최종승인번호

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APRV_BC   C     -- SOR_CLI_여신승인기본
            ON   A.승인번호  =  C.CLN_APRV_NO

LEFT OUTER JOIN
            TB_SOR_CLI_XCDC_DSCD_BC  D   --SOR_CLI_전결구분코드기본
            ON   C.LST_XCDC_DSCD  = D.CLN_XCDC_DSCD  --여신전결구분코드
;

END;



-- CASE 2   심사부 승인 여신신청건을 모두 가져오는 방법
--
  SELECT      A.ACN_DCMT_NO         AS 계좌번호
             ,B.CSLT_BRNO           AS 품의점번호
             ,E.BR_NM               AS 품의점명
             ,A.CLN_APC_DSCD        AS 여신신청구분코드
             ,B.CUST_NO             AS 고객번호
             ,C.CUST_NM             AS 고객명
             ,B.HDQ_APRV_DT         AS 승인일자
             ,D.APRV_AMT            AS 승인금액
             ,D.APRV_WNA            AS 승인원화금액
             ,B.CRDT_EVL_NO         AS 신용평가번호
             ,B.CRDT_EVL_MODL_DSCD  AS 신용평가모형구분코드
             ,B.STDD_INDS_CLCD      AS 표준산업분류코드
             ,B.RSBL_XMRL_USR_NO    AS 담당심사역사용자번호
             ,A.MNMG_MRT_CD         AS 주담보코드
  INTO        #TEMP      -- DROP TABLE #TEMP
  FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- SOR_CLI_여신신청기본
             ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- SOR_CLI_여신신청대표기본
             ,DWZOWN.OM_DWA_INTG_CUST_BC         C -- DWA_통합고객기본
             ,DWZOWN.TB_SOR_CLI_CLN_APRV_BC      D -- SOR_CLI_여신승인기본
             ,DWZOWN.OT_DWA_DD_BR_BC             E -- DWA_일점기본
  WHERE       A.ACN_DCMT_NO       IS NOT NULL
  AND         A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
  AND         A.CLN_APC_DSCD      BETWEEN  '01'   AND '21'   -- 신규, 연장, 증액
  AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
  AND         A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
  AND         B.APCL_DSCD         = '2'               -- 승인여신구분코드(1:영업점승인,2:본부승인)
  AND         A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
  AND         B.HDQ_APRV_DT       BETWEEN '20120101' AND '20151030'
  AND         B.APRV_BRNO         =  '0627'           -- 심사부승인
  AND         B.CUST_NO          *=  C.CUST_NO
  AND         A.CLN_APRV_NO      *=  D.CLN_APRV_NO
  AND         B.CSLT_BRNO        *= E.BRNO
  AND         E.STD_DT            = '20151031'

  ;



-- CASE 3   약정시점에 해당하는 승인번호로 승인정보를 가져오는 방법
--
LEFT OUTER JOIN         -- 최초약정거래정보
            (
             SELECT      TA.CLN_ACNO                     AS  여신계좌번호
                        ,TA.AGR_EXPI_DT                  AS  약정만기일자
                        ,TA.AGR_DT                       AS  약정일자
                        ,TA.AGR_AMT                      AS  약정금액
                        ,TA.TR_BF_ADD_IRT                AS  거래전가산금리
                        ,TA.ADD_IRT                      AS  가산금리
                        ,TC.CRDT_EVL_GD                  AS  신용평가등급
                        ,TD.XCDC_ATR_DSCD                AS  전결속성구분코드  --'01' 본부전결, '02' 영업점전결
                        ,TE.ASS_CRDT_GD                  AS  ASS신용등급

             FROM       DWZOWN.TB_SOR_LOA_AGR_HT       TA
             JOIN        (
                           SELECT   CLN_ACNO
                                   ,MAX(AGR_TR_SNO) AS AGR_TR_SNO    --약정거래일련번호(최종기한연장의 약정거래일련번호)
                           FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                           WHERE    CLN_APC_DSCD IN ('01','02','04','07','08','09') --여신신청구분코드 <10 는 신규건
                           AND      TR_STCD       =  '1'             --거래상태코드(1:정상)
                           AND      ENR_DT       <=  '20160630'
                           GROUP BY CLN_ACNO
                         )            TB
                         ON    TA.CLN_ACNO   = TB.CLN_ACNO
                         AND   TA.AGR_TR_SNO = TB.AGR_TR_SNO

             LEFT OUTER JOIN
                         TB_SOR_CLI_CLN_APRV_BC     TC     -- SOR_CLI_여신승인기본
                         ON   TA.CLN_APRV_NO  =  TC.CLN_APRV_NO

             LEFT OUTER JOIN
                         TB_SOR_CLI_XCDC_DSCD_BC  TD   --SOR_CLI_전결구분코드기본
                         ON   TC.LST_XCDC_DSCD  = TD.CLN_XCDC_DSCD  --여신전결구분코드

             LEFT OUTER JOIN
                          TB_SOR_PLI_SYS_JUD_RSLT_TR TE          --SOR_PLI_시스템심사결과내역
                          ON   TC.CUST_NO        = TE.CUST_NO
                          AND  TC.CLN_APC_NO     = TE.CLN_APC_NO

             WHERE       1=1
             AND         TA.CLN_ACNO  IN ( SELECT DISTINCT 통합계좌번호 FROM #원화대출금_계좌별 )
            )     D
            ON            A.통합계좌번호  = D.여신계좌번호
            AND           A.실행순서      = 1
            AND           A.약정일자      = D.약정일자     -- 신규약정건을 가져오는 것이므로 약정일자가 당연히 같을것이지만 확인을 위해서 필요

//}

//{  #PLAN  #QUERYPLAN #쿼리플랜 #플랜 #NESTED  #DB1


-- CASE 1 : 쿼리플랜 생성법
SET TEMPORARY OPTION QUERY_PLAN_AS_HTML = 'ON';

-- Query_Plan_As_HTML_Directory 는 dba만 바꿀수있음
-- SET TEMPORARY OPTION Query_Plan_As_HTML_Directory  = '/sybaseiq/IQPLN';

SELECT COUNT(*)
         FROM     OT_DWA_INTG_DPS_BC         A    -- DWA_통합수신기본
         LEFT OUTER
         JOIN     OM_DWA_INTG_CUST_BC        B    -- DWA_통합고객기본
                                             ON     A.CUST_NO       = B.CUST_NO

         LEFT OUTER
         JOIN     OT_DWA_DD_BR_BC            C    -- DWA_일점기본
                                              ON     A.ADM_BRNO      = C.BRNO        -- 점번호   = 점번호      (JOIN조건)
                                              AND    C.BR_DSCD       = '2'           -- 점구분코드 = '2' (조합)
                                              AND    C.FSC_DSCD      = '3'           -- 상호
                                              AND    C.BR_KDCD       < '40'          -- 10:본부부서, 20:영업점, 30:관리점
                                              AND    C.STD_DT        = '20151130'    -- 기준일자 = P_기준일자

CROSS   JOIN     ( SELECT SNO FROM OM_DWA_GVNO_BC WHERE SNO <= 2 )           Z    -- DWA_채번기본

         WHERE    1 = 1
           AND    A.STD_DT        IN (SELECT DISTINCT EOTM_DT
                                      FROM   OM_DWA_DT_BC
                                      WHERE  STD_DT  BETWEEN '20120101' AND '20121231'
                                     )
           AND    A.DPS_ACN_STCD   = '01'      -- 수신계좌상태코드
           AND    A.DP_BS_ACSB_CD IN (SELECT RLT_ACSB_CD
                                      FROM   OT_DWA_DD_ACSB_BC             -- DWA_일계정과목기본
                                      WHERE  ACSB_CD     = '23000303'      -- 계정코드 = '23000303'(요구불예탁금계정)
                                        AND  FSC_SNCD   IN ('K','C')       -- 회계기준코드  = 'K' (K-GAAP), C(:공통)
                                        AND  STD_DT      = '20151130'      -- 기준일자 = P_기준일자
                                     )
;

SET TEMPORARY OPTION QUERY_PLAN_AS_HTML = 'OFF';

-- CASE2 : DB1에서만 에러발생

엔지니어에게 문의해 본 결과 프로시저 실행 전,
혹은 sql문으로 수행되면 sql 수행전에 아래 구문을
수행하고 난 후에 수행해 보라고 합니다.

set temporary option Join_Preference = '-3'

위 메시지는 쿼리가 수행될 때 Plan이 잘못 설정되어
nested-loop push down join 으로 join 되는 것을 방지하는 구문이라고 합니다.


//}

//{  #소매  #비소매


--CASE1 : 신용리스크테이블을 읽어서 사용한다.
--        TB_SOR_DAD_RSK_CLN_TR(SOR_DAD_신용위험여신계좌내역) 는 하루늦게야 데이터가 들어오므로 신용리스크 테이블을 직접이용하는것이 좋다

           ,CASE WHEN  V.RTSL_NRTSL_DSCD   = '01'  THEN '1. 비소매'
                 WHEN  V.RTSL_NRTSL_DSCD   = '02'  THEN '2. 소매'
                 ELSE  '9. UNKNOWN'
            END                                    AS 소매비소매구분   -- 차주당 5억이상 비소매기준

LEFT OUTER JOIN
/*            TB_CDR_RSK_CLN_TR    V                        -- CDR_신용위험여신계좌내역, RTSL_NRTSL_DSCD  소매비소매구분코드
            ON      A.INTG_ACNO   =  V.INTG_ACNO
            AND     A.CLN_EXE_NO  =  V.INTG_EXE_NO
            AND     V.DWUP_STD_DT =  P_기준일자
*/
            (
                SELECT   DISTINCT
                         DWUP_STD_DT
                        ,INTG_ACNO
                        ,INTG_EXE_NO
                        ,RTSL_NRTSL_DSCD
                FROM     DWROWN.TB_CDR_RSK_CLN_TR  	--CDR_신용위험여신계좌내역 RTSL_NRTSL_DSCD  소매비소매구분코드
                WHERE    DWUP_STD_DT = (
                                     SELECT   MAX(DWUP_STD_DT)
                                     FROM     DWROWN.TB_CDR_RSK_CLN_TR
                                     WHERE    DWUP_STD_DT <= P_기준일자
                                   )
            )       V
            ON      A.INTG_ACNO   =  V.INTG_ACNO
            AND     A.CLN_EXE_NO  =  V.INTG_EXE_NO



-- csae 2
/***********************************************************************************/
--소매/비소매구분  시작
--성과평가시 사용하는 구분(고객지원부)  BY장상진
--구소매비소매구분 : 차주별 10억이상여신 비소매여신으로 보는 기준
--소매비소매구분코드 : 차주별 5억이상여신 비소매여신으로 보는 기준
/***********************************************************************************/
--임시테이블 생성 ( #TEMP_여신계좌종합 )
--월별
IF EXISTS (SELECT TOP 1 기준년월  FROM OT_ECRT여신계좌정보  WHERE 점구분코드 = '1' AND 기준년월 = LEFT(P_기준일자, 6))  THEN

    SELECT   A.기준년월
            ,A.차주번호
            ,A.통합계좌번호
            ,A.여신실행번호
            ,A.구소매비소매구분
            ,A.소매비소매구분코드
            ,CASE WHEN (B.차주구분코드 = '07' OR B.신용평가모형구분코드  = '51') AND
                        A.대출세목코드 NOT IN ('1076','1091')                              THEN 'Y'
             ELSE 'N' END                    AS 교회대출여부
            ,B.고객구분코드
            ,B.차주구분코드
            ,B.BIS차주구분코드
            ,B.신BIS차주구분
            ,B.고객명
            ,B.신용평가모형구분코드 모형구분코드
            ,B.최종조정등급
            ,ISNULL(C.주거용부동산담보액,0) 주택담보
            ,'00'  AS 표준소매비소매구분코드
    INTO     #TEMP_여신계좌종합
    FROM     OT_ECRT여신계좌정보 A,
             (
                     SELECT   STD_DT
                             ,ACSB_CD
                             ,ACSB_NM
                             ,ACSB_CD4  --원화대출금
                             ,ACSB_NM4
                             ,ACSB_CD5  --기업자금대출금(14002401), 가계자금대출금(14002501), 공공및기타(14002601)
                             ,ACSB_NM5
                             ,ACSB_CD6
                             ,ACSB_NM6
                     FROM     OT_DWA_DD_ACSB_TR
                     WHERE    1=1
                     AND      FSC_SNCD IN ('K','C')
                     AND      ACSB_CD4 IN ('13000801','13001901')       --원화대출금,사모사채
                     AND      STD_DT   = P_기준일자
             )       K,
             OT_ECRT여신고객정보 B,
            (SELECT  SUBSTR(STD_DT,1,6)                      AS 기준년월
                    ,INTG_ACNO                               AS 통합계좌번호
                    ,CLN_EXE_NO                              AS 여신실행번호
                    ,BS_ACSB_CD                              AS BS계정과목코드
                    ,FRXC_TSK_DSCD                           AS 외환업무구분코드
                    ,SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) AS 주거용부동산담보액
             FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ  A   -- SOR_CLM_채무자별담보배분월말집계
             WHERE   STD_DT             = P_기준일자
               AND   NFFC_UNN_DSCD      = '1'    -- 중앙회조합구분코드
               AND   MRT_APRT_TPCD      = '01' -- 담보배분유형코드
               AND   LQWR_APRT_MRAM     > 0    -- 청산가치배분담보금액 > 0
               AND   MRT_CD             IN ('101','102','103','104','105','109','111','170')
             GROUP   BY SUBSTR(STD_DT,1,6),INTG_ACNO,CLN_EXE_NO,BS_ACSB_CD,FRXC_TSK_DSCD
             HAVING  SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) > 0
             ) C
    WHERE   A.기준년월           = LEFT(P_기준일자, 6)
      AND   A.점구분코드         = '1'
      AND   A.장표종류코드      IN ('1','2','3','4','5','6','7')
      AND   A.BS계정과목코드     = K.ACSB_CD
      AND   A.기준년월          *= B.기준년월
      AND   A.점구분코드        *= B.점구분코드
      AND   A.실명번호          *= B.고객실명번호
      AND   A.기준년월          *= C.기준년월
      AND   A.통합계좌번호      *= C.통합계좌번호
      AND   A.여신실행번호      *= C.여신실행번호
      AND   A.BS계정과목코드    *= C.BS계정과목코드
      AND   A.외환업무구분코드  *= C.외환업무구분코드
    ;


    SELECT  기준년월
           ,차주번호
           ,고객구분코드
           ,차주구분코드
           ,신BIS차주구분
           ,CASE WHEN 신BIS차주구분 IN ('72','73','80','90') THEN
                 CASE WHEN 주거용제외여신금액 > 1000000000    THEN '01' -- 10억초과
                      WHEN 고객구분코드 IN ('01','03','07')   THEN '02' -- 01:내국인주민번호, 03:개인사업자, 07:외국인주민번호
                      WHEN 차주구분코드 IN ('02','03','07')        THEN '02' -- 02:중소외감, 03:중소비외감
                      ELSE '01'
                 END
            ELSE '01'
            END                           AS 표준소매비소매구분코드
    INTO    #TEMP
    FROM   (
            SELECT  A.기준년월
                   ,A.점구분코드
                   ,A.차주번호
                   ,A.고객구분코드
                   ,A.차주구분코드
                   ,A.신BIS차주구분
                   ,SUM(ISNULL(B.원화약정금액,0))                      AS 원화약정금액
                   ,SUM(A.여신잔액)                                    AS 잔액
                   ,SUM(ISNULL(A.주거용부동산담보액,0))                AS 주거용부동산담보액 -- A.주택유효담보금액 컬럼은 IRB용으로만 사용하고 SA는 표준담보배분결과사용.
                   ,SUM(CASE WHEN ISNULL(B.원화약정금액,0) > A.여신잔액 THEN ISNULL(B.원화약정금액,0)
                       ELSE A.여신잔액 END)                           AS 한도기준여신금액
                   ,SUM(CASE WHEN ISNULL(B.원화약정금액,0) > A.여신잔액 THEN ISNULL(B.원화약정금액,0)
                       ELSE A.여신잔액 END - ISNULL(A.주거용부동산담보액,0)) AS 주거용제외여신금액
            FROM   (SELECT  A.기준년월
                           ,A.점구분코드
                           ,A.차주번호
                           ,B.고객구분코드
                           ,B.차주구분코드
                           ,B.신BIS차주구분
                           ,CASE WHEN A.카드회원번호     > '0' THEN A.카드회원번호
                                  WHEN A.외환한도계좌번호 > '0' THEN A.외환한도계좌번호
                           ELSE A.통합계좌번호 END         AS 통합계좌번호
                           ,SUM(A.대출잔액)                 AS 여신잔액
                           ,SUM(C.주거용부동산담보액)       AS 주거용부동산담보액
                    FROM    OT_ECRT여신계좌정보 A,
                            OT_ECRT여신고객정보 B,
                           (SELECT  SUBSTR(STD_DT,1,6)                      AS 기준년월
                                   ,INTG_ACNO                              AS 통합계좌번호
                                   ,CLN_EXE_NO                               AS 여신실행번호
                                   ,BS_ACSB_CD                               AS BS계정과목코드
                                   ,FRXC_TSK_DSCD                          AS 외환업무구분코드
                                   ,SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) AS 주거용부동산담보액
                            FROM    TB_SOR_CLM_MRT_APRT_EOM_TZ   A   -- SOR_CLM_채무자별담보배분월말집계
                            WHERE   STD_DT             = P_기준일자
                              AND   NFFC_UNN_DSCD     = '1'    -- 중앙회조합구분코드
                              AND   MRT_APRT_TPCD     = '01' -- 담보배분유형코드
                              AND   LQWR_APRT_MRAM     > 0    -- 청산가치배분담보금액 > 0
                              AND   MRT_CD             IN ('101','102','103','104','105','109','111','170')
                            GROUP   BY SUBSTR(STD_DT,1,6),INTG_ACNO,CLN_EXE_NO,BS_ACSB_CD,FRXC_TSK_DSCD
                            HAVING  SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) > 0
                            ) C
                    WHERE   A.기준년월           = LEFT(P_기준일자, 6)
                      AND   A.점구분코드         = '1'
                      AND   B.신BIS차주구분 IN ('72','73','80','90')
                      AND   A.기준년월           = B.기준년월
                      AND   A.점구분코드         = B.점구분코드
                      AND   A.실명번호           = B.고객실명번호
                      AND   A.기준년월          *= C.기준년월
                      AND   A.통합계좌번호      *= C.통합계좌번호
                      AND   A.여신실행번호      *= C.여신실행번호
                      AND   A.BS계정과목코드    *= C.BS계정과목코드
                      AND   A.외환업무구분코드  *= C.외환업무구분코드
                    GROUP   BY A.기준년월
                           ,A.점구분코드
                           ,A.차주번호
                           ,B.고객구분코드
                           ,B.차주구분코드
                           ,B.신BIS차주구분
                           ,CASE WHEN A.카드회원번호     > '0' THEN A.카드회원번호
                                 WHEN A.외환한도계좌번호 > '0' THEN A.외환한도계좌번호
                           ELSE A.통합계좌번호 END
                    ) A
                 , (-- 한도대출만 발췌
                    SELECT  기준년월
                           ,통합계좌번호
                           ,점구분코드
                           ,장표종류코드
                           ,여신업무구분코드
                           ,ISNULL(통화코드,'KRW')         통화
                           ,개별한도대출구분코드
                           ,약정금액
                           ,CASE WHEN ISNULL(통화코드,'KRW') = 'KRW' THEN 약정금액
                            ELSE CASE WHEN SUM(외화잔액) > 0 THEN 약정금액 * (SUM(대출잔액)/SUM(외화잔액))
                                 ELSE 약정금액 * (SUM(미사용한도금액)/SUM(외화미사용한도금액))
                                 END
                            END                         원화약정금액
                    FROM    OT_ECRT여신계좌정보
                    WHERE   기준년월             = LEFT(P_기준일자, 6)
                      AND   점구분코드           = '1'
                      AND   개별한도대출구분코드 > '1'
                      AND  (장표종류코드     IN ('1','3','4','5') OR
                            여신업무구분코드 IN ('14','42') OR                             -- 외화대출, 무역금융
                            BS계정과목코드   IN ('96003511','95001918')                    -- 신용카드,외환한도계좌
                           )
                            -- 시설설자금대출 제외
                      AND   BS계정과목코드 NOT IN ('17004411','16006711','17002511'
                                                  ,'17002711','17004911','15007118'
                                                  ,'16007418','16007518')
                      AND   대출세목코드 NOT IN ('1053','1064')                            -- 집단주택자금대출,토지분양자금대출
                    GROUP   BY 기준년월
                           ,통합계좌번호
                           ,점구분코드
                           ,장표종류코드
                           ,여신업무구분코드
                           ,ISNULL(통화코드,'KRW')
                           ,개별한도대출구분코드
                           ,약정금액
                   ) B
            WHERE  A.기준년월     *= B.기준년월
              AND  A.통합계좌번호 *= B.통합계좌번호
            GROUP  BY A.기준년월
                   ,A.점구분코드
                   ,A.차주번호
                   ,A.고객구분코드
                   ,A.차주구분코드
                   ,A.신BIS차주구분
            ) S;

      UPDATE   #TEMP_여신계좌종합
      SET      구소매비소매구분 = '00'
      ;

      UPDATE   #TEMP_여신계좌종합
      SET      구소매비소매구분 = CASE WHEN B.표준소매비소매구분코드='02' THEN '02'
                                       WHEN A.소매비소매구분코드='02'     THEN '02'
                                   ELSE '01' END
      FROM     #TEMP_여신계좌종합   A,
               #TEMP B
      WHERE    A.기준년월 *= B.기준년월
        AND    A.차주번호 *= B.차주번호
      ;


ELSE

    --일별
    SELECT   A.기준일자
            ,A.차주번호
            ,A.통합계좌번호
            ,A.여신실행번호
            ,A.구소매비소매구분
            ,A.소매비소매구분코드
            ,CASE WHEN (B.차주구분코드 = '07' OR B.신용평가모형구분코드  = '51') AND
                        A.대출세목코드 NOT IN ('1076','1091')                              THEN 'Y'
             ELSE 'N' END                    AS 교회대출여부
            ,B.고객구분코드
            ,B.차주구분코드
            ,B.BIS차주구분코드
            ,B.신BIS차주구분
            ,B.고객명
            ,B.신용평가모형구분코드 모형구분코드
            ,B.최종조정등급
            ,ISNULL(C.주거용부동산담보액,0) 주택담보
            ,'00'  AS 표준소매비소매구분코드
    INTO     #TEMP_여신계좌종합
    FROM     OT_ECRT여신계좌정보일별 A,
             (
                     SELECT   STD_DT
                             ,ACSB_CD
                             ,ACSB_NM
                             ,ACSB_CD4  --원화대출금
                             ,ACSB_NM4
                             ,ACSB_CD5  --기업자금대출금(14002401), 가계자금대출금(14002501), 공공및기타(14002601)
                             ,ACSB_NM5
                             ,ACSB_CD6
                             ,ACSB_NM6
                     FROM     OT_DWA_DD_ACSB_TR
                     WHERE    1=1
                     AND      FSC_SNCD IN ('K','C')
                     AND      ACSB_CD4 IN ('13000801','13001901')       --원화대출금,사모사채
                     AND      STD_DT   = P_기준일자
             )       K        ,
             OT_ECRT여신고객정보일별 B,
            (SELECT  STD_DT                                  AS 기준일자
                    ,INTG_ACNO                               AS 통합계좌번호
                    ,CLN_EXE_NO                              AS 여신실행번호
                    ,BS_ACSB_CD                              AS BS계정과목코드
                    ,FRXC_TSK_DSCD                           AS 외환업무구분코드
                    ,SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) AS 주거용부동산담보액
             FROM    TB_SOR_CLM_PDBT_MRT_APRT_TZ  A  --SOR_CLM_채무자별담보배분집계

             WHERE   STD_DT             = P_기준일자
               AND   NFFC_UNN_DSCD      = '1'    -- 중앙회조합구분코드
               AND   MRT_APRT_TPCD      = '01' -- 담보배분유형코드
               AND   LQWR_APRT_MRAM     > 0    -- 청산가치배분담보금액 > 0
               AND   MRT_CD             IN ('101','102','103','104','105','109','111','170')
             GROUP   BY STD_DT,INTG_ACNO,CLN_EXE_NO,BS_ACSB_CD,FRXC_TSK_DSCD
             HAVING  SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) > 0
             ) C
    WHERE   A.기준일자           = P_기준일자
      AND   A.점구분코드         = '1'
      AND   A.장표종류코드      IN ('1','2','3','4','5','6','7')
      AND   A.BS계정과목코드     = K.ACSB_CD
      AND   A.기준일자          *= B.작성기준일
      AND   A.점구분코드        *= B.점구분코드
      AND   A.실명번호          *= B.고객실명번호
      AND   A.기준일자          *= C.기준일자
      AND   A.통합계좌번호      *= C.통합계좌번호
      AND   A.여신실행번호      *= C.여신실행번호
      AND   A.BS계정과목코드    *= C.BS계정과목코드
      AND   A.외환업무구분코드  *= C.외환업무구분코드
    ;


    SELECT  기준일자
           ,차주번호
           ,고객구분코드
           ,차주구분코드
           ,신BIS차주구분
           ,CASE WHEN 신BIS차주구분 IN ('72','73','80','90') THEN
                 CASE WHEN 주거용제외여신금액 > 1000000000    THEN '01' -- 10억초과
                      WHEN 고객구분코드 IN ('01','03','07')   THEN '02' -- 01:내국인주민번호, 03:개인사업자, 07:외국인주민번호
                      WHEN 차주구분코드 IN ('02','03','07')   THEN '02' -- 02:중소외감, 03:중소비외감
                      ELSE '01'
                 END
            ELSE '01'
            END                           AS 표준소매비소매구분코드
    INTO    #TEMP
    FROM   (
            SELECT  A.기준일자
                   ,A.점구분코드
                   ,A.차주번호
                   ,A.고객구분코드
                   ,A.차주구분코드
                   ,A.신BIS차주구분
                   ,SUM(ISNULL(B.원화약정금액,0))                      AS 원화약정금액
                   ,SUM(A.여신잔액)                                    AS 잔액
                   ,SUM(ISNULL(A.주거용부동산담보액,0))                AS 주거용부동산담보액 -- A.주택유효담보금액 컬럼은 IRB용으로만 사용하고 SA는 표준담보배분결과사용.
                   ,SUM(CASE WHEN ISNULL(B.원화약정금액,0) > A.여신잔액 THEN ISNULL(B.원화약정금액,0)
                       ELSE A.여신잔액 END)                           AS 한도기준여신금액
                   ,SUM(CASE WHEN ISNULL(B.원화약정금액,0) > A.여신잔액 THEN ISNULL(B.원화약정금액,0)
                       ELSE A.여신잔액 END - ISNULL(A.주거용부동산담보액,0)) AS 주거용제외여신금액
            FROM   (SELECT  A.기준일자
                           ,A.점구분코드
                           ,A.차주번호
                           ,B.고객구분코드
                           ,B.차주구분코드
                           ,B.신BIS차주구분
                           ,CASE WHEN A.카드회원번호     > '0' THEN A.카드회원번호
                                  WHEN A.외환한도계좌번호 > '0' THEN A.외환한도계좌번호
                           ELSE A.통합계좌번호 END         AS 통합계좌번호
                           ,SUM(A.대출잔액)                 AS 여신잔액
                           ,SUM(C.주거용부동산담보액)       AS 주거용부동산담보액
                    FROM    OT_ECRT여신계좌정보일별 A,
                            OT_ECRT여신고객정보일별 B,
                           (SELECT  STD_DT                                 AS 기준일자
                                   ,INTG_ACNO                              AS 통합계좌번호
                                   ,CLN_EXE_NO                               AS 여신실행번호
                                   ,BS_ACSB_CD                               AS BS계정과목코드
                                   ,FRXC_TSK_DSCD                          AS 외환업무구분코드
                                   ,SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) AS 주거용부동산담보액
                            FROM    TB_SOR_CLM_PDBT_MRT_APRT_TZ   --SOR_CLM_채무자별담보배분집계
                            WHERE   STD_DT             = P_기준일자
                              AND   NFFC_UNN_DSCD     = '1'    -- 중앙회조합구분코드
                              AND   MRT_APRT_TPCD     = '01' -- 담보배분유형코드
                              AND   LQWR_APRT_MRAM     > 0    -- 청산가치배분담보금액 > 0
                              AND   MRT_CD             IN ('101','102','103','104','105','109','111','170')
                            GROUP   BY STD_DT,INTG_ACNO,CLN_EXE_NO,BS_ACSB_CD,FRXC_TSK_DSCD
                            HAVING  SUM(LQWR_APRT_MRAM - LQWR_APRT_SRP_AMT) > 0
                            ) C
                    WHERE   A.기준일자           = P_기준일자
                      AND   A.점구분코드         = '1'
                      AND   B.신BIS차주구분 IN ('72','73','80','90')
                      AND   A.기준일자           = B.작성기준일
                      AND   A.점구분코드         = B.점구분코드
                      AND   A.실명번호           = B.고객실명번호
                      AND   A.기준일자          *= C.기준일자
                      AND   A.통합계좌번호      *= C.통합계좌번호
                      AND   A.여신실행번호      *= C.여신실행번호
                      AND   A.BS계정과목코드    *= C.BS계정과목코드
                      AND   A.외환업무구분코드  *= C.외환업무구분코드
                    GROUP   BY A.기준일자
                           ,A.점구분코드
                           ,A.차주번호
                           ,B.고객구분코드
                           ,B.차주구분코드
                           ,B.신BIS차주구분
                           ,CASE WHEN A.카드회원번호     > '0' THEN A.카드회원번호
                                 WHEN A.외환한도계좌번호 > '0' THEN A.외환한도계좌번호
                           ELSE A.통합계좌번호 END
                    ) A
                 , (-- 한도대출만 발췌
                    SELECT  기준일자
                           ,통합계좌번호
                           ,점구분코드
                           ,장표종류코드
                           ,여신업무구분코드
                           ,ISNULL(통화코드,'KRW')         통화
                           ,개별한도대출구분코드
                           ,약정금액
                           ,CASE WHEN ISNULL(통화코드,'KRW') = 'KRW' THEN 약정금액
                            ELSE CASE WHEN SUM(외화잔액) > 0 THEN 약정금액 * (SUM(대출잔액)/SUM(외화잔액))
                                 ELSE 약정금액 * (SUM(미사용한도금액)/SUM(외화미사용한도금액))
                                 END
                            END                         원화약정금액
                    FROM    OT_ECRT여신계좌정보일별
                    WHERE   기준일자             = P_기준일자
                      AND   점구분코드           = '1'
                      AND   개별한도대출구분코드 > '1'
                      AND  (장표종류코드     IN ('1','3','4','5') OR
                            여신업무구분코드 IN ('14','42') OR                             -- 외화대출, 무역금융
                            BS계정과목코드   IN ('96003511','95001918')                    -- 신용카드,외환한도계좌
                           )
                            -- 시설설자금대출 제외
                      AND   BS계정과목코드 NOT IN ('17004411','16006711','17002511'
                                                  ,'17002711','17004911','15007118'
                                                  ,'16007418','16007518')
                      AND   대출세목코드 NOT IN ('1053','1064')                            -- 집단주택자금대출,토지분양자금대출
                    GROUP   BY 기준일자
                           ,통합계좌번호
                           ,점구분코드
                           ,장표종류코드
                           ,여신업무구분코드
                           ,ISNULL(통화코드,'KRW')
                           ,개별한도대출구분코드
                           ,약정금액
                   ) B
            WHERE  A.기준일자     *= B.기준일자
              AND  A.통합계좌번호 *= B.통합계좌번호
            GROUP  BY A.기준일자
                   ,A.점구분코드
                   ,A.차주번호
                   ,A.고객구분코드
                   ,A.차주구분코드
                   ,A.신BIS차주구분
            ) S;

      UPDATE   #TEMP_여신계좌종합
      SET      구소매비소매구분 = '00'
      ;

      UPDATE   #TEMP_여신계좌종합
      SET      구소매비소매구분 = CASE WHEN B.표준소매비소매구분코드='02' THEN '02'
                                       WHEN A.소매비소매구분코드='02'     THEN '02'
                                   ELSE '01' END
      FROM     #TEMP_여신계좌종합   A,
               #TEMP B
      WHERE    A.기준일자 *= B.기준일자
        AND    A.차주번호 *= B.차주번호
      ;

END IF;


-- 사용시


SELECT      A.INTG_ACNO                  AS    통합계좌번호
 ...
 ...
           ,CASE WHEN  V.구소매비소매 = '02'  THEN '1. 소매' ELSE  '2. 비소매' END AS 소매비소매구분_10억기준  -- 차주당 10억이상 비소매기준
           ,CASE WHEN  V.소매비소매   = '02'  THEN '1. 소매' ELSE  '2. 비소매' END AS 소매비소매구분_5억기준    -- 차주당 5억이상 비소매기준

FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A  --DWA_통합여신기본
 ...
 ...
LEFT OUTER JOIN
            (
                SELECT   DISTINCT A.통합계좌번호,A.구소매비소매구분 AS 구소매비소매, A.소매비소매구분코드  AS  소매비소매
                FROM     #TEMP_여신계좌종합   A
                WHERE    A.구소매비소매구분 <>  '01'  OR A.소매비소매구분코드 <>  '01'    -- 구기준또는 신기준으로 소매여신인거만 (데이터 최소화, 꼭필요한 조건문아님)
            ) V
            ON   A.INTG_ACNO  =  V.통합계좌번호



//}

//{  #MESSAGE #메세지
MESSAGE p_변수 TYPE ACTION TO CLIENT;
//}

//{  #매각  #양도
여신과목코드 081

//========================================================================================
//
//                       양도계좌 모집단 생성
//
//=========================================================================================

SELECT      A.CLN_ACNO       AS  계좌번호
           ,A.ACN_ADM_BRNO   AS  계좌관리점번호
           ,B.CLN_EXE_NO     AS  실행번호
           ,C.SLN_PCS_DT     AS  매각처리일자
           ,C.SLN_AMT        AS  매각금액

INTO        #양도             -- DROP TABLE #양도

FROM        TB_SOR_LOA_ACN_BC       A   -- SOR_LOA_계좌기본

JOIN        TB_SOR_LOA_EXE_BC       B   -- SOR_LOA_실행기본
            ON   A.CLN_ACNO      =  B.CLN_ACNO
            AND  B.CLN_ACN_STCD  =  '1'

JOIN        TB_SOR_LOA_KHFC_LN_DL   C   --LOA_한국주택금융공사대출상세
            ON  B.CLN_ACNO    = C.CLN_ACNO
            AND B.CLN_EXE_NO  = C.CLN_EXE_NO

WHERE       1=1
AND         A.AGR_DT      BETWEEN P_시작일  AND P_종료일
AND         A.LN_SBCD     =  '081'      -- 대출과목코드(081:양도계좌)
AND         A.PDCD NOT IN ('20011113701011','20012113701011','20051105304011','20051105304021',
                           '20051108202001','20051113701011','20055000800001','20055101704001',
                           '20056105303011','20056105303021','20056113701011','20056113701021',
                           '20052105304011','20053105304011','20122103303001','20122103307001',
                           '20125103303001','20125103307001')                                    -- 중도금대출 제외
AND         A.MNMG_MRT_CD      IN  ('101','102','103','104','105','109','170')
;


//}

//{  #인터넷 #스마트폰 #가입유무

SELECT

           ,CASE WHEN D.실명번호 IS NOT NULL AND D.고객상태   < '2' THEN 'O' ELSE 'X' END 인터넷뱅킹가입유무
           ,CASE WHEN E.실명번호 IS NOT NULL AND E.모바일상태 < '9' THEN 'O' ELSE 'X' END 스마트폰뱅킹가입유무

LEFT OUTER JOIN
            (-- 인터넷뱅킹 가입정보
             SELECT   RMN_NO     AS 실명번호
                     ,CUST_STCD  AS 고객상태
             FROM     TB_PB_CUST_INF       -- PB_고객정보
             WHERE    TSK_DC_CD = '3'    -- 3:인터넷뱅킹
            )    D
            ON   A.RNNO  = D.실명번호

LEFT OUTER JOIN
            (-- 모바일뱅킹 가입정보
             SELECT   RMN_NO    AS 실명번호
                     ,MBL_STCD  AS 모바일상태
             FROM     TB_PB_MBL_CUST_INF  -- PB_모바일고객정보
             WHERE    MBL_DC_CD = '3'    -- 3:스마트폰
            ) E
            ON   A.RNNO  = E.실명번호
//}

//{  #DTI
-- UP_DWZ_여신_N0254_주택담보대출프로모션 일부
           ,ISNULL(T10.DTI_RT,0)         AS DTI비율

LEFT OUTER JOIN
            (
              SELECT    A.CLN_ACNO
                       ,D.DTI_RT
              FROM      DWZOWN.TB_SOR_PLI_CLN_APC_BC       A --PLI_여신신청기본
                       ,(SELECT   A.CLN_ACNO        AS 여신계좌번호
                                 ,MAX(A.CLN_APC_NO) AS 여신신청번호_MAX
                         FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          --PLI_여신신청기본
                         WHERE    A.CLN_APC_PGRS_STCD = '04'              --여신신청진행상태코드:04(실행완료)
                         AND      A.CLN_ACNO          > '0'               --여신계좌번호
                         AND      A.CLN_APC_DSCD NOT IN ('11','12','13')  --여신신청구분코드:연기제외
                         AND      A.CLN_APRV_DT       <= P_기준일자
                         GROUP BY A.CLN_ACNO
                        ) B
                       ,DWZOWN.TB_SOR_PLI_HMRT_APC_TR      D              --PLI_주택담보신청내역
              WHERE     A.CLN_APC_NO    = B.여신신청번호_MAX
              AND       A.CLN_APC_NO    = D.CLN_APC_NO
            )     T10
            ON    A.통합계좌번호    =  T10.CLN_ACNO


//}

//{  #LTV
-- UP_DWZ_여신_N0254_주택담보대출프로모션
           ,CASE WHEN T7.CLN_ACNO IS NULL  THEN ISNULL(T8.신규시LTV, 0)
                 ELSE CASE WHEN A.개별한도대출구분코드 = '1' THEN ISNULL(T7.RMD_STD_RT, 0)
                           ELSE ISNULL(T7.LMT_STD_RT, 0)  END
            END                        AS 주택담보대출비율


LEFT OUTER JOIN
            ( -- 여신계좌번호별 MAX(여신실행번호)의 데이타 추출
               SELECT   TA.*
               FROM    (
                        SELECT  STD_YM                                                     --기준년월
                               ,CLN_ACNO                                                   --여신계좌번호
                               ,RMD_STD_RT
                               ,LMT_STD_RT
                               ,RANK() OVER(PARTITION BY STD_YM, CLN_ACNO ORDER BY STD_YM, CLN_ACNO, CLN_EXE_NO DESC) AS CLN_EXE_NO  --여신실행번호
                        FROM    DWZOWN.TB_SOR_CLM_LTV_PSST_TZ
                        WHERE   STD_YM  = (SELECT   MAX(STD_YM)
                                           FROM     DWZOWN.TB_SOR_CLM_LTV_PSST_TZ
                                           WHERE    STD_YM <= LEFT('20160314', 6))
                       ) TA
               WHERE    TA.CLN_EXE_NO = 1
            )                                                T7                      --SOR_CLM_주택담보대출비율현황집계
            ON   A.통합계좌번호  =  T7.CLN_ACNO

LEFT OUTER JOIN
            (
               SELECT   A.계좌번호                                   --신규시
                       ,CASE WHEN A.LTV비율  IS NULL  THEN 0
                             ELSE A.LTV비율 * 100
                             END  AS 신규시LTV
               FROM    (SELECT   A.CLN_ACNO              AS 계좌번호
                                ,A.CLN_APC_NO            AS 여신신청번호
                                ,B.LTV                   AS LTV비율
                        FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC   A          --SOR_PLI_여신신청기본 --> 개인심사
                                ,DWZOWN.TB_SOR_PLI_LTV_CALC_TR  B          --SOR_PLI_주택담보대출비율산출내역
                        WHERE    A.CLN_APC_DSCD      < '10'     --신규
                        AND      A.CLN_ACNO          IS NOT NULL
                        AND      A.CLN_APC_PGRS_STCD IN ('03','04','13')     --여신신청진행상태코드(04:실행완료 ,13:약정완료)
                        AND      A.NFFC_UNN_DSCD     = '1'               --중앙회조합구분코드
                        AND      A.CLN_APC_NO        *= B.CLN_APC_NO
                        ) A
                      ,(SELECT   A.CLN_ACNO              AS 계좌번호
                                ,MAX(A.CLN_APC_NO)       AS 여신신청번호
                        FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC   A          --SOR_PLI_여신신청기본 --> 개인심사
                                ,DWZOWN.TB_SOR_PLI_LTV_CALC_TR  B          --SOR_PLI_주택담보대출비율산출내역
                        WHERE    A.CLN_APC_DSCD      < '10'       --신규
                        AND      A.APC_DT            <= '20160314'
                        AND      A.CLN_ACNO          IS NOT NULL
                        AND      A.CLN_APC_PGRS_STCD IN ('03','04','13')     --여신신청진행상태코드(04:실행완료 ,13:약정완료)
                        AND      A.NFFC_UNN_DSCD     = '1'                   --중앙회조합구분코드
                        AND      A.CLN_APC_NO        *= B.CLN_APC_NO
                        GROUP BY 계좌번호
                        ) B
               WHERE    A.계좌번호     = B.계좌번호
               AND      A.여신신청번호 = B.여신신청번호
            )                                               T8                    --SOR_PLI_주택담보대출비율산출내역
            ON    A.통합계좌번호  =  T8.계좌번호


//}

//{  #일계좌잔액  #잔액보정


CREATE TABLE #보정
(
    순번          INT,
    통합계좌번호  CHAR(35),
    점번호        CHAR(4),
    계정과목코드  CHAR(8),
    가감액        NUMERIC(20,2)
);


LOAD   TABLE  #보정
(
    순번          '|',
    통합계좌번호  '|',
    점번호        '|',
    계정과목코드  '|',
    가감액        '\x0a'
)   FROM '/nasdat/edw/in/etc/보정금액.dat'
QUOTES OFF
ESCAPES OFF
--SKIP 1   -- 타이틀 제외
--BLOCK FACTOR 3000
FORMAT ASCII
;

UPDATE      OT_DWA_DD_ACN_RMD_TZ   A
SET         A.FC_RMD = A.FC_RMD + B.가감액

--SELECT      A.*, B.순번,B.가감액
--FROM        OT_DWA_DD_ACN_RMD_TZ   A


UPDATE      OT_DWA_DD_ACN_RMD_TZ   A
SET         A.FC_RMD   =  A.FC_RMD + B.가감액

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
                         ,B.순번
                         ,B.가감액

              FROM        OT_DWA_DD_ACN_RMD_TZ   A

              JOIN        #보정         B
                          ON     A.INTG_ACNO       = B.통합계좌번호
                          AND    A.ACCT_PCS_BRNO   = B.점번호
                          AND    A.ACSB_CD         = B.계정과목코드
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

//{ #테이블SIZE
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

//{ #SOR_FEC_외환거래내역  #외환거래내역  #송금 #환전
-- 송금및 환전원장을 TB_SOR_FEC_FRXC_TR_TR(SOR_FEC_외환거래내역) 와 죠인할때 본거래만 죠인되어 건수가 증폭되게 않게 조심해야함
-- 송금과 환전은 거래내역에서 REF 별로 첫거래가 본거래라고 보면 된다
--  첫거래를 본거래로 보는건 옳으나 인터넷거래, ATM거래등등 다양한 채널에서 들어오므로 요건에 따라 걸러내야 한다

-- 1.환전 : INP_SCRN_ID 로 외국통화 본거래와 부수거래(원장변경등) 를 구분하는 방법, 확인은 안해봤지만 TR_SNO   =  1 로 가져와도 될것 같다
--     - 5351SC00(외통매입),5352SC00(외통매도),5353SC00(외통동시매입매도) 또는 비어있으면 본거래, 나머지값은 원장변경등 본거래가 아니라고 보면됨

SELECT      A.REF_NO                   AS  REF번호
           ,A.TR_BRNO                  AS  점번호
           ,A.CRCD                     AS  통화코드
           ,A.EFM_AMT                  AS  환전금액

INTO        #TEMP  -- DROP TABLE #TEMP

FROM        DWZOWN.TB_SOR_INX_EFM_BC A              -- SOR_INX_환전기본
JOIN        DWZOWN.TB_SOR_FEC_FRXC_TR_TR   H          --SOR_FEC_외환거래내역
            ON     A.REF_NO = H.REF_NO
            --AND         H.TR_SNO   =  1                                  -- 신규거래는 거래일련번호가 1인것으로 (박강국) -- CASE  1
            AND    (  H.INP_SCRN_ID IS NULL OR H.INP_SCRN_ID = '' OR H.INP_SCRN_ID IN ('5351SC00','5352SC00','5353SC00')   )  -- CASE 2

WHERE       1=1
AND         A.TR_DT BETWEEN '20160101' AND '20160331'
AND         A.EFM_DSCD IN ('FS','FB')  -- 매도,매입
AND         A.NFFC_UNN_DSCD  = '1'     -- 1:중앙회
AND         A.FRXC_LDGR_STCD = '1'



-- 2.당발송금 : TR_SNO   =  1  인건을 가져오면 됨 (비대면거래 인터넷송금등도 같이 들어옴)
--     - 단말거래와 글로벌구매카드송금건만 가져오고 싶으면 아래처럼 구현
--            H.TR_SNO   =  1                                  -- 신규거래는 거래일련번호가 1인것으로 (박강국)
--       AND  (     H.INP_SCRN_ID = '5401SC00'
--               OR H.CHNL_TPCD   = 'SIBT'                     -- 글로벌구매카드송금도 포함
--            )

SELECT      A.REF_NO                               AS REF번호
           ,A.TR_BRNO                              AS 점번호
           ,A.CRCD                                 AS 통화코드
           ,A.OWMN_AMT                             AS 당발송금금액

INTO        #TEMP  -- DROP TABLE #TEMP

FROM        DWZOWN.TB_SOR_INX_OWMN_BC      A          -- SOR_INX_당발송금기본

JOIN        DWZOWN.TB_SOR_FEC_FRXC_TR_TR   H          --SOR_FEC_외환거래내역
            ON    A.REF_NO = H.REF_NO
            AND   H.TR_SNO   =  1                                  -- 신규거래는 거래일련번호가 1인것으로 (박강국)
            --AND (     H.INP_SCRN_ID = '5401SC00'
            --       OR H.CHNL_TPCD   = 'SIBT'                     -- 글로벌구매카드송금도 포함
            --    )
WHERE       1=1
AND         A.TR_DT BETWEEN '20160101' AND '20160331'
AND         A.FRXC_LDGR_STCD   IN ('1','9')      -- 외환원장상태코드(1:정상,3:전출,4:정정,5:취소,6:해지,9:종결,7:퇴결,8:퇴결지급,2:변경)




-- 3.타발송금 : TSK_PGM_NM      = 'INXO413102'    -- 미지급건 (미결제건 및 접수거래는 제외시키기 위함 ,참고로  미결제건: INXO413302)

SELECT      A.REF_NO                               AS REF번호
           ,A.RCV_BRNO                             AS 점번호
           ,A.CRCD                                 AS 통화코드
           ,A.INMY_AMT                             AS 타발송금금액

INTO        #TEMP  -- DROP TABLE #TEMP

FROM        DWZOWN.TB_SOR_INX_INMY_BC          A           -- SOR_INX_타발송금기본

JOIN        DWZOWN.TB_SOR_FEC_FRXC_TR_TR       H           --SOR_FEC_외환거래내역
            ON    A.REF_NO = H.REF_NO
            AND   H.TSK_PGM_NM      = 'INXO413102'          -- 미지급건 (미결제건 및 접수거래는 제외시키기 위함 , 미결제건: INXO413302)
            AND   H.FRXC_LDGR_STCD  = '1'

WHERE       1=1
AND         A.DFRY_DT BETWEEN '20160101' AND '20160331'
AND         A.FRXC_LDGR_STCD  = '9'                        --외환원장상태코드 9:종결
AND         A.RMT_KDCD IN ('1','3')                        --송금종류코드 AS IS : a.구분 in (1,3)
AND         A.HNB_DSCD = '1'                               --국내외구분코드=국내 AS IS : a.국내외구분  = 0

//}

//{ #무역외코드 #무역외사유코드 #외환거래내역
-- 송금및 환전은 무역외사유코드가 외환거래내역에 있으면 원장변경등으로 무역외사유코드가 바뀌므로 최종건을 가져와야 한다

SELECT

FROM        DWZOWN.TB_SOR_INX_OWMN_BC A               -- SOR_INX_당발송금기본

LEFT OUTER JOIN
            (
               SELECT  A.REF_NO,A.TR_DT,A.INTD_RSCD,A.NE_INTD_RSCD
               FROM    DWZOWN.TB_SOR_INX_INTD_RSN_TR_TR    A
               JOIN    (
                         SELECT   AA.REF_NO, MAX(AA.RSN_SNO) AS MAX_RSN_SNO
                         FROM     DWZOWN.TB_SOR_INX_INTD_RSN_TR_TR   AA
                         WHERE    AA.FRXC_LDGR_STCD = '1'   -- 정상
                         AND      (
                                   AA.INTD_RSCD IS NOT NULL  OR
                                   AA.NE_INTD_RSCD IS NOT NULL
                                  )
                         GROUP BY AA.REF_NO
                        )     B
                        ON    A.REF_NO  = B.REF_NO
                        AND   A.RSN_SNO = B.MAX_RSN_SNO
               WHERE    A.FRXC_LDGR_STCD = '1'   -- 정상
            )        D
            ON       A.REF_NO   = D.REF_NO


WHERE       1=1

AND         (                 -- 무역외거래요건
              (
                     D.TR_DT <= '20150331'
                AND  ( D.INTD_RSCD IS NULL OR D.INTD_RSCD NOT IN ('011','012','013','014','015','016','017','019') )
              )     OR
              (      D.TR_DT >= '20150401'
                AND  ( D.NE_INTD_RSCD IS NULL OR LEFT(D.NE_INTD_RSCD,1) NOT IN ('1','2') )
              )
            )

//}


//{  #거래상세종류코드

select CLN_TR_DTL_KDCD      as  여신거래상세종류코드
      ,CLN_TR_DTL_KD_CD_NM  as  여신거래상세종류코드명
      ,CLN_TR_KDCD          as   여신거래종류코드
from TB_SOR_LOA_TR_DTL_KDCD_BC  a      --  SOR_LOA_거래상세종류코드기본
 where  A.CLN_TR_DTL_KDCD IN ('3001','3002','3003','3004','3101','3102','3103','3201','3202','3301','3302','3601')


//}

//{   #최초약정일
-- 대출원장 + 외환한도원장 + 신용카드회원원장 (GPC 계좌원장, KPS계좌원장) 포함한 최조약정일

SELECT      A.*
INTO        #계좌약정  -- DROP TABLE #계좌약정
FROM
            (
             SELECT      A.순번
                        ,A.고객번호
                        ,B.계좌번호
                        ,B.점번호
                        ,B.약정일자
                        ,ROW_NUMBER() OVER(PARTITION BY B.고객번호 ORDER BY B.약정일자 ASC) AS 순서
             FROM        #대상고객    A
             LEFT OUTER JOIN
                         ( -- 대출
                           SELECT      A.순번                     AS   순번
                                      ,A.고객번호                 AS   고객번호
                                      ,B.CLN_ACNO                 AS   계좌번호
                                      ,B.ACN_ADM_BRNO             AS   점번호
                                      ,B.AGR_DT                   AS   약정일자
                           FROM        #대상고객    A
                           JOIN        TB_SOR_LOA_ACN_BC  B        --  SOR_LOA_계좌기본
                                       ON   A.고객번호     = B.CUST_NO
                                       AND  B.CLN_ACN_STCD <> '3'  -- 취소건은 제외

                           UNION ALL
                           -- 외환  (통합여신의 약정일과 다름)
                           SELECT      A.순번                     AS   순번
                                      ,A.고객번호                 AS   고객번호
                                      ,B.FRXC_LMT_ACNO            AS   계좌번호
                                      ,B.ENR_BRNO                 AS   점번호
                                      ,B.AGR_DT                   AS   약정일자

                           FROM        #대상고객    A
                           JOIN        TB_SOR_FEC_CLN_LMT_BC  B        --  SOR_FEC_여신한도기본
                                       ON   A.고객번호     = B.CUST_NO
                                       AND  B.FRXC_LDGR_STCD NOT IN ('4','5') -- 정정,취소건은 제외

                           UNION ALL
                           -- 신용카드
                           SELECT      A.순번                     AS   순번
                                      ,A.고객번호                 AS   고객번호
                                      ,B.CRD_MBR_NO               AS   계좌번호
                                      ,B.CRD_MBR_ADM_BRNO         AS   점번호
                                      ,B.MBR_NW_DT                AS   약정일자

                           FROM        #대상고객    A
                           JOIN        TB_SOR_CLT_MBR_BC    B          -- SOR_CLT_회원기본
                                       ON   A.고객번호     = B.CUST_NO

                           UNION ALL
                           -- GPC
                           SELECT      A.순번                     AS   순번
                                      ,A.고객번호                 AS   고객번호
                                      ,B.카드번호                 AS   계좌번호
                                      ,B.관리점번호               AS   점번호
                                      ,SUBSTR(B.신규일시,1,8)     AS   약정일자

                           FROM        #대상고객    A
                           JOIN        TB_SOR_CUS_MAS_BC    AA          --SOR_CUS_고객기본
                                       ON   A.고객번호    = AA.CUST_NO
                           JOIN        TB_CCCMGPC카드정보   B
                                       ON   AA.CUST_RNNO  = B.실명번호

                           UNION ALL
                           -- KPS
                           SELECT      A.순번                     AS   순번
                                      ,A.고객번호                 AS   고객번호
                                      ,B.카드번호                 AS   계좌번호
                                      ,B.신규점번호               AS   점번호
                                      ,SUBSTR(B.신규일시,1,8)     AS   약정일자

                           FROM        #대상고객    A
                           JOIN        TB_SOR_CUS_MAS_BC    AA          --SOR_CUS_고객기본
                                       ON   A.고객번호    = AA.CUST_NO
                           JOIN        TB_CCCMKPS카드정보   B
                                       ON   AA.CUST_RNNO     = B.실명번호

                         )       B
                         ON      A.순번  =  B.순번
            )       A

WHERE       1=1
AND         순서  = 1
;

//}

//{  #신규시 감정가 #감정평가기관 #담보인정비율 #신규시 부동산담보


-- CASE 1  신규신청에 붙어있는 부동산담보(가계여신)
SELECT   A.순번
        ,A.계좌번호

        ,C.MRT_RCG_RT     담보인정비율
        ,D.MRT_NO         담보번호
        ,D.APSL_NO        감정번호

        ,F.APSL_SMTL_AMT  감정합계금액
        ,CASE WHEN E.EVL_MTH_DSCD IN('03','04') THEN TRIM(Y.ADM_HDCD_NM) || '('  || TRIM(ISNULL(Y.ADM_HDCD,'')) || ')'
              ELSE '자체감정'
         END    감정평가기관

--        ,H.MRT_NO         담보번호_
--        ,H.MRT_EVL_AMT    담보평가금액
--        ,H.MRT_RCG_RT     담보인정비율_

        ,TRIM(E.MPSD_NM) || ' ' || TRIM(E.CCG_NM) || ' ' || TRIM(E.EMD_NM) || ' ' || TRIM(E.LINM) || ' ' ||  TRIM(E.THG_SIT_DTL_ADR) AS   물건소재지

FROM     #대상계좌          A

JOIN     TB_SOR_PLI_CLN_APC_BC      B   -- SOR_PLI_여신신청기본
         ON  A.계좌번호        = B.CLN_ACNO
         AND B.CLN_APC_DSCD    = '01'    -- 여신신청구분코드(01:신규)

JOIN     DWZOWN.TB_SOR_CLM_CLN_LNK_TR   C  -- SOR_CLM_여신연결내역
         ON   B.CLN_APC_NO  = C.CLN_APC_NO
         AND  C.CLN_LNK_STCD      = '02'    -- 여신연결상태코드(02:정상등록) 현재상태에서 연결상태가 끊어진것은 제외하고 출력

JOIN     TB_SOR_CLM_STUP_BC       D  -- SOR_CLM_설정기본
         ON   C.STUP_NO   =  D.STUP_NO

JOIN     TB_SOR_CLM_REST_MRT_BC     E   --SOR_CLM_부동산담보기본
         ON   D.MRT_NO  = E.MRT_NO

LEFT OUTER JOIN
         TB_SOR_CLM_APSL_BC   F   -- SOR_CLM_감정기본
         ON   D.APSL_NO  = F.APSL_NO

LEFT OUTER JOIN
         TB_SOR_CLM_MRT_CMN_CD_BC   Y   -- SOR_CLM_담보공통코드기본
         ON     E.NFFC_UNN_DSCD =  Y.NFFC_UNN_DSCD
         AND    E.APSL_EVL_ORCD =  Y.ADM_HDCD
         AND    Y.ADM_TGT_CD    = '100001'

-- 평가금액과 담보인정비율은 아래와 같이 SOR_PLI_신청시점담보내역를 이용하면 간단히 구할수있다
--LEFT OUTER JOIN
--         TB_SOR_PLI_APC_POT_MRT_TR  H   -- SOR_PLI_신청시점담보내역
--         ON  B.CLN_APC_NO = H.CLN_APC_NO
--         AND H.MRT_TPCD  = '1'   -- 부동산

WHERE    1=1
ORDER BY 1,2
;


-- CASE 2 감정기관 분류방법, 시계열테이블을 이용한 부동산담보가져오기
SELECT      A.STD_YM           AS 기준년월
           ,A.MRT_NO           AS 담보번호
           ,B.ACN_DCMT_NO      AS 여신계좌번호
           ,C.JUD_SMTL_AMT     AS 심사합계금액
           ,C.EVL_MTH_DSCD     AS 평가방법구분코드
           ,CASE D.EVL_RSRC_DSCD  WHEN '01' THEN  '1'    -- 'KB시세_국민은행'
                                  WHEN '02' THEN  '2'    -- 'TECH시세_한국감정원'
                                  WHEN '09' THEN  '3'    -- '외부감정평가기관'
                                  ELSE '7'       -- '기타'
            END                AS 주택평가기관

           ,ROW_NUMBER() OVER (PARTITION BY LEFT(A.STD_YM,4), B.ACN_DCMT_NO ORDER BY A.STUP_AMT DESC) AS 대표_담보

INTO        #감정기관  -- DROP TABLE #감정기관

FROM        TT_SOR_CLM_MM_STUP_BC     A    --SOR_CLM_월설정기본

JOIN        TT_SOR_CLM_MM_CLN_LNK_TR  B    --SOR_CLM_월여신연결내역
            ON   A.STD_YM   =  B.STD_YM
            AND  A.STUP_NO  =  B.STUP_NO       --설정번호
            AND  B.ACN_DCMT_NO   IN (SELECT DISTINCT 통합계좌번호  FROM #가계대출)
            AND  B.CLN_LNK_STCD  IN ('02','03')     --여신연결상태코드(02:정상,03:해지예정)
            AND  B.NFFC_UNN_DSCD = '1'

JOIN        TT_SOR_CLM_MM_REST_MRT_BC  C        --SOR_CLM_월부동산담보기본
            ON    A.STD_YM        = C.STD_YM
            AND   A.MRT_NO        = C.MRT_NO
            AND   C.MRT_STCD      = '02'

JOIN        TB_SOR_CLM_BLD_MRT_APSL_DL      D   -- SOR_CLM_건물담보감정상세
            ON    C.APSL_NO       = D.APSL_NO

WHERE       A.STD_YM        IN (  SELECT     LEFT(MAX(STD_DT),6)
                                   FROM      OT_DWA_INTG_CLN_DT_BC
                                   WHERE     1=1
                                   AND       STD_DT  BETWEEN '20120101' AND '20160831'
                                   GROUP BY  LEFT(STD_DT,6)
                                )
AND         A.NFFC_UNN_DSCD = '1'             --중앙회조합구분코드
AND         A.STUP_STCD     = '02'            --설정상태코드(02:정상등록)
;


-- CASE 2-1 여신연결테이블을 시계열테이블와 현재테이블을 합쳐서 사용할때
SELECT      DISTINCT
            A.STD_YM  AS 기준년월
           ,A.MRT_NO           AS 담보번호
           ,B.ACN_DCMT_NO      AS 여신계좌번호
           ,C.JUD_SMTL_AMT     AS 심사합계금액
           ,C.EVL_MTH_DSCD     AS 평가방법구분코드
           --,RANK() OVER (PARTITION BY A.STD_YM, B.ACN_DCMT_NO ORDER BY C.JUD_SMTL_AMT  DESC, B.CLN_APC_NO, A.STUP_NO, A.MRT_NO) AS 대표_담보
FROM        TT_SOR_CLM_MM_STUP_BC     A    --SOR_CLM_월설정기본
           ,(SELECT   STD_YM
                     ,STUP_NO
                     ,CLN_APC_NO
                     ,ACN_DCMT_NO
             FROM     #TEMP_여신연결
             UNION ALL
             SELECT   STD_YM
                     ,STUP_NO
                     ,CLN_APC_NO
                     ,ACN_DCMT_NO
             FROM     TT_SOR_CLM_MM_CLN_LNK_TR       --SOR_CLM_월여신연결내역
             WHERE    STD_YM        IN ('201212','201312','201408')
             AND      CLN_LNK_STCD  IN ('02','03')     --여신연결상태코드(02:정상,03:해지예정)
             AND      NFFC_UNN_DSCD = '1'
            )   B   --SOR_CLM_여신연결내역
           ,TT_SOR_CLM_MM_REST_MRT_BC  C    --SOR_CLM_월부동산담보기본
WHERE       A.STD_YM        IN ('201112','201212','201312','201408')
AND         A.NFFC_UNN_DSCD = '1'             --중앙회조합구분코드
AND         A.STUP_STCD     = '02'            --설정상태코드(02:정상등록)
AND         A.STD_YM        = B.STD_YM
AND         A.STUP_NO       = B.STUP_NO       --설정번호
AND         A.STD_YM        = C.STD_YM
AND         A.MRT_NO        = C.MRT_NO
AND         B.ACN_DCMT_NO   IN (SELECT DISTINCT 계좌번호  FROM #TEMP_기본여신)


-- CASE 3  담보인정비율 및 적용담보인정비율 구하기
-- 담보인정비율은 규정상 비율이고 실제로 적용된 담보인정비율은 적용담보인정비율 사용함
-- 하나의 담보안에 주택과 상가가 함께 있는 경우는 전체감정가 대비 각각 주택감정평가금액, 상가감정평가금액의 비율로 주택적용담보인정비율과 상가적용담보인정비율을 합산
-- 하나의 계좌에 담보가 여러건이면 아래와 같이 구한 적용담보인정비율중 MAX 값으로 하던지 ..정해서 사용해야 한다.

SELECT      A.통합계좌번호
           ,B.MRT_NO             AS   담보번호

           ,CASE WHEN B.EVL_AMT = 0 THEN 0 ELSE (B.HS_APSL_EVL_AMT / B.EVL_AMT)  * B.MRT_RCG_RT END
           +CASE WHEN B.EVL_AMT = 0 THEN 0 ELSE (B.DTWN_APSL_EVL_AMT / B.EVL_AMT) * B.DTWN_MRT_RCG_RT END AS 담보인정비율

           ,CASE WHEN B.EVL_AMT = 0 THEN 0 ELSE (B.HS_APSL_EVL_AMT / B.EVL_AMT)  * B.APL_MRT_RCG_RT END
           +CASE WHEN B.EVL_AMT = 0 THEN 0 ELSE (B.DTWN_APSL_EVL_AMT / B.EVL_AMT) * B.DTWN_APL_MRT_RCG_RT END AS 적용담보인정비율

           ,ROW_NUMBER() OVER(PARTITION BY A.통합계좌번호, B.MRT_NO ORDER BY B.ENR_DT DESC, B.CLN_APC_NO DESC) AS 번호 --나중에 번호 1인 신청번호와만 조인하면 된다

INTO        #TEMP_담보인정비율  -- DROP TABLE #TEMP_담보인정비율

FROM        (
            SELECT        DISTINCT
                          A.통합계좌번호
                         ,B.ACN_DCMT_NO
                         ,B.CLN_APC_NO
                         ,B.ENR_DT
            FROM          #모집단     A

            JOIN          TT_SOR_CLM_MM_CLN_LNK_TR  B  -- SOR_CLM_월여신연결내역
                          ON   A.통합계좌번호    =  B.ACN_DCMT_NO
                          AND  B.STD_YM          =  '201606'

            JOIN          TT_SOR_CLM_MM_STUP_BC   C  --SOR_CLM_월설정기본
                          ON   B.STUP_NO         =  C.STUP_NO
                          AND  C.MRT_TPCD        = '1'
                          AND  C.STD_YM          = '201606'
            ) A

JOIN        TB_SOR_CLM_MRT_ENNR_CALC_TR B --SOR_CLM_담보여력산출내역
            ON    A.CLN_APC_NO     = B.CLN_APC_NO

ORDER BY    A.통합계좌번호
           ,B.MRT_NO
;


-- CASE 4  신규신청건의 여신신청번호로 부동산담보 가져오기, 감정금액을 'CLM_건물담보감정상세' 에서 가져오는것과 'SOR_CLM_감정기본' 에서 가져오는 차이점
--         감사실(20171012)_기업자금대출신규내역_이민주 프로그램내에서 발췌
SELECT      A.통합계좌번호
           ,A.여신신청번호
           ,E.MRT_CD         AS  담보코드
           ,Z1.MRT_CD_NM     AS  담보코드명
           ,E.OWNR_CUST_NO   AS  소유자고객번호
           ,F.CUST_NM        AS  소유자성명
           ,TRIM(E.MPSD_NM) || ' ' || TRIM(E.CCG_NM) || ' ' || TRIM(E.EMD_NM) || ' ' || TRIM(E.LINM) || ' ' ||  TRIM(E.THG_SIT_DTL_ADR) AS   물건소재지
           ,D.STUP_DT        AS  설정일자     -- 근저당설정일이 따로 있는항목이 아니라 설정기본의 설정일이 근저당설정일임 (김희선)
--           ,F.APSL_AMT       AS  감정금액
           ,D1.APSL_SMTL_AMT AS  감정합계금액  -- 부동산담보원장보다 감정원장이 많은값이 있어서 이거 이용함
                                               -- 설정에 연결되어 있으므로 설정시점의 감정가로 보면 되고, 설정과 관련없이 별도로 감정이 이루어 지면 부동산원장에 최종값이 바뀔수 있다
                                               -- 그러므로 최종감정가는 부동산담보원장에 값을 이용하고 설정시점의 감정가를 이용하려면 감정원장을 이용하는 것이 옳다
           ,E.TROW_RGS_DT    AS  소유권이전등기일자

INTO        #기업대출_담보물    -- DROP TABLE  #기업대출_담보물

FROM        #기업대출_신규신청번호  A

JOIN        DWZOWN.TB_SOR_CLM_CLN_LNK_TR   C  -- SOR_CLM_여신연결내역
            ON   A.여신신청번호      = C.CLN_APC_NO
            AND  C.CLN_LNK_STCD      = '02'    -- 여신연결상태코드(02:정상등록) 현재상태에서 연결상태가 끊어진것은 제외하고 출력

JOIN        DWZOWN.TB_SOR_CLM_STUP_BC       D  -- SOR_CLM_설정기본
            ON   C.STUP_NO   =  D.STUP_NO

LEFT OUTER JOIN
            TB_SOR_CLM_APSL_BC     D1   --SOR_CLM_감정기본
            ON  D.APSL_NO  = D1.APSL_NO

JOIN        DWZOWN.TB_SOR_CLM_REST_MRT_BC     E   --SOR_CLM_부동산담보기본
            ON   D.MRT_NO  = E.MRT_NO
//=========================================================================================
            AND  E.MRT_CD  IN  ('101','102','103','104','105','111','170')   -- 주거및 주거용오피스텔
            AND  ( E.NFM_YN      IS NULL  OR   E.NFM_YN   = 'N')         -- 견질담보 아닐것
            AND  ( E.AFCP_MRT_YN IS NULL  OR   E.AFCP_MRT_YN  = 'N')     -- 후취담보 아닐것
//=========================================================================================
--LEFT OUTER JOIN
--            DWZOWN.TB_SOR_CLM_BLD_MRT_APSL_DL   F -- CLM_건물담보감정상세
--            ON   D.APSL_NO  = F.APSL_NO

JOIN        OM_DWA_INTG_CUST_BC    F     --DWA_통합고객기본
            ON   E.OWNR_CUST_NO     =  F.CUST_NO

LEFT OUTER JOIN
            DWZOWN.TB_SOR_CLM_MRT_CD_BC  Z1  --CLM_담보코드기본
            ON   E.MRT_CD = Z1.MRT_CD
;



//}

//{   #적격대출
SELECT      STD_YM    AS  기준년월
           ,CLN_ACNO  AS  계좌번호
           ,AGR_AMT   AS  약정금액
           ,LN_SBCD 대출과목코드

INTO        #SH적격대출           -- DROP TABLE #SH적격대출
FROM        TT_SOR_LOA_MM_ACN_BC  A        --  SOR_LOA_계좌기본
WHERE       1=1
AND         A.STD_YM  IN  ('201312','201412','201512','201605')
AND         SUBSTR(A.PDCD, 6, 4)    =     '1123'        -- 적격대출
AND         LEFT(AGR_DT,4) =  LEFT(STD_YM,4)            -- 당해년도 신규약정분
AND         A.CLN_ACN_STCD  <> '3'                      --  취소건제외
;

--- 참고
SELECT      DISTINCT
            SBJ_NFFC_UNN_DSCD
           ,LN_SBCD
           ,LN_TXIM_CD
           ,LN_USCD
           ,LN_SBJ_NM      AS  대출과목명
           ,LN_TXIM_CD_NM   AS  대출세목코드명
           ,LN_USCD_NM      AS  대출용도코드명
FROM        OT_DWA_CLN_HRC_CTL_BC A
WHERE       STD_DT =  '20160531'
AND         LN_SBCD IN ('056','081')
;
//}

//{  #상환계획  #상환예정 #분할상환

SELECT
--            A.INTG_ACNO     AS 계좌번호
--           ,SUM(A.LN_RMD)   AS 대출잔액
            SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201607'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS 분할상환예정원금_201607
           ,SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201608'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS 분할상환예정원금_201608
           ,SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201609'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS 분할상환예정원금_201609
           ,SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201610'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS 분할상환예정원금_201610
           ,SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201611'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS 분할상환예정원금_201611
           ,SUM(CASE WHEN LEFT(C.PCS_PARN_DT,6) = '201612'  THEN C.PCS_PARN_PCPL ELSE 0 END) AS 분할상환예정원금_201612

FROM        OT_DWA_INTG_CLN_BC            A       -- DWA_통합여신기본
JOIN        TB_SOR_LOA_EXE_RDM_PLAN_TR    C       -- LOA_실행상환계획내역
            ON    A.INTG_ACNO      = C.CLN_ACNO
            AND   A.CLN_EXE_NO     = C.CLN_EXE_NO
            AND   C.EXE_RDM_PLAN_DSCD = '1'        -- 실행상환계획구분코드(1:상환계획  2:실행계획)
WHERE       1=1
AND         A.STD_DT       =  '20160619'
AND         A.CLN_ACN_STCD = '1'                           -- 정상
AND         A.BR_DSCD      =  '1'                          -- 중앙회
AND         A.INDV_LMT_LN_DSCD  <>   '2'                   -- 한도대출제외
AND         A.CLN_RDM_MHCD   IN ('2','3','4')              -- 여신상환방법코드(2:원금균등,3:원리금균등,4:원금불균등)
AND         A.BRNO NOT IN ('0018','0178','0204','0304','0404','0542','0602','0804','0805','0909')     -- 센터이관분 제외
AND         CASE WHEN   A.FRPP_KDCD IN ('2')  AND  A.PRD_BRND_CD =  '5025' AND A.LN_SBCD IN ('369','370')  THEN '4. 온렌딩'
--                 WHEN A.FRPP_KDCD   IN ('2')  AND  A.PDCD  IN  ( '20387500100001','20387500200001')        THEN '5. 연안선박'
                 WHEN   A.FRPP_KDCD IN ('2')                                                               THEN '3. 정책'
                 WHEN  (A.BS_ACSB_CD IN ('17005211',                        --기타금융시설자금대출
                                         '17002811')) THEN                  --기타금융운전자금대출
                        CASE WHEN A.PRD_BRND_CD IN ('1085',                 --사랑해대출
                                                    '1026',                 --서울시경영안정자금대출
                                                    '1029',                 --정부지방자치단체협약대출
                                                    '1116',                 --중소기업진흥공단대출
                                                    '1132',                 --경기도지자체중소기업육성자금대출
                                                    '1140',                 --소상공인지원자금대출
                                                    '1150') THEN '3. 정책'     --소상공인전환대출
                             ELSE                                '2. 수산'
                        END
                 WHEN A.BS_ACSB_CD  IN ('17010111','17010211')   THEN  '2. 수산'  -- 수산해양일반운전자금대출, 수산해양일반시설자금대출
                 WHEN A.LN_MKTG_DSCD IS NOT NULL                 THEN  '6. 해투부'
                 ELSE '1. 일반'
            END        IN   ('1. 일반','4. 온렌딩')                          -- 일반대출(온렌딩포함)
--GROUP BY    A.INTG_ACNO
;
//}

//{  #통합여신일자 #전일자 #익일자  #전영업일자  #익영업일자
SELECT      STD_DT
           ,(
              SELECT MIN(B.STD_DT)
              FROM   OT_DWA_INTG_CLN_DT_BC    B    --   DWA_통합여신일자기본
              WHERE  1=1
              AND    B.STD_DT  > A.STD_DT
            )                                      AS 익영업일자
           ,(
              SELECT A.STD_DT
              FROM   (
                       SELECT B.STD_DT,
                              RANK() OVER(ORDER BY B.STD_DT DESC) AS 영업일순서
                       FROM   OT_DWA_INTG_CLN_DT_BC   B    --   DWA_통합여신일자기본
                       WHERE  1=1
                       AND    B.STD_DT >= DATEFORMAT(DATEADD(MM, -2, A.STD_DT), 'YYYYMMDD')
                       AND    B.STD_DT < A.STD_DT
                     ) A
              WHERE  A.영업일순서 = 1
            )                                     AS 전영업일자
INTO        #통합여신일자정보     -- DROP TABLE #통합여신일자정보
FROM        OT_DWA_INTG_CLN_DT_BC   A    --   DWA_통합여신일자기본
WHERE       1=1
AND         A.STD_DT   BETWEEN  '20151201' AND '20160620'     -- 대상승인일자를 충분히 포함할수있도록
;

-- 통합여신일자기본으로 월말자만 가져오기
AND         A.STD_DT  IN  (
                           SELECT    MAX(STD_DT)
                           FROM      OT_DWA_INTG_CLN_DT_BC
                           WHERE     1=1
                           AND       STD_DT  BETWEEN '20111201' AND '20161130'
                           GROUP BY  LEFT(STD_DT,6)
                          )
-- 통합여신일자기본으로  분기말만 가져오기
 SELECT    MAX(STD_DT)
                           FROM      OT_DWA_INTG_CLN_DT_BC
                           WHERE     1=1
                           AND       STD_DT  BETWEEN '20100101' AND '20161231'
                           AND       SUBSTR(STD_DT,5,2) IN ('03','06','09','12')
                           GROUP BY  LEFT(STD_DT,6)
ORDER BY 1


//}

//{  #원장변경  #실행만기  #실행만기일 #실행만기일변경 #원장변경이력


--원장변경에서 실행건별로 만기일을 변경해주는경우 차세대 이전부터 변경이력이 잘못 쌓이고 있어서 올해 초에 수정을 했는데
--단기외화 한도대출의 변경전 변경후 값은 TB_LOA_LDGR_CHG_HIS_DL 에는 제대로 쌓이고 있어서 TB_LOA_LDGR_CHG_HIS_DL 테이블을 조인해야 할거 같습니다.
--변경일자와 함께 뽑으시는거면 계좌기본, 원장변경이력, 원장변경이력상세를 같이 조인해야 할거 같습니다.
--원장변경이력에서 잘 못 쌓이고 있었던 값이 입력항목내용1 이 변경전 값으로 쌓이고 있었어서 빠지진 않을거 같습니다.  -- 윤형식

SELECT      A.*
           ,B.LDGR_CHG_SNO       AS  원장변경일련번호
           ,B.CHG_DT             AS  변경일자
--           ,B.INP_HDN_CTS1       AS  입력내용
           ,C.CHB_LTR_HDN_CTS    AS  변경전문자항목내용
           ,C.CHA_LTR_HDN_CTS    AS  변경후문자항목내용
--           ,C.CHG_LDGR_HDN_NM    AS  변경원장항목명
--           ,C.CHG_LDGR_TBL_NM    AS  변경원장테이블명

INTO        #변경내역   -- DROP TABLE #변경내역
FROM        #모집단   A

JOIN        TB_SOR_LOA_LDGR_CHG_HT     B    --SOR_LOA_원장변경이력
            ON   A.계좌번호  = B.CLN_ACNO
            AND  A.실행번호  = B.CLN_EXE_NO
            AND  B.CLN_TR_DTL_KDCD  = '5072'     --  여신거래상세종류코드
--            AND  B.CLN_TR_DTL_KDCD  = '5005'     --  여신거래상세종류코드(기한이익상실등록 및 해제)
--            AND  B.CLN_TR_DTL_KDCD  = '5055'     --  여신거래상세종류코드( 주담보코드 변경)

JOIN        TB_SOR_LOA_LDGR_CHG_HIS_DL    C   --SOR_LOA_원장변경이력상세
            ON   B.CLN_ACNO   = C.CLN_ACNO
            AND  B.CLN_EXE_NO = C.CLN_EXE_NO
            AND  B.LDGR_CHG_SNO =  C.LDGR_CHG_SNO
--ORDER BY   3,4,20;


//}

//{  #성명주석 #엑셀 #부분주석 #주석처리
=LEFT(C7,1) & REPT("*",LEN(C7)-2) & RIGHT(TRIM(C7),1)
//}

//{  #상환구분  #상환방법
--CASE 1
           ,--일시상환/분할상환
            CASE WHEN A.CLN_RDM_MHCD = '1'                 THEN '①만기일시'  --여신상환방법코드
                 WHEN ISDATE(A.DFR_EXPI_DT) = 1  THEN --'거치식'
                      CASE WHEN A.DFR_EXPI_DT < A.STD_DT   THEN '③원금상환중' ELSE '②거치기간중'  END
                 ELSE '④비거치식'  END  AS 상환구분

-- CASE 2
           ,CASE WHEN A.CLN_RDM_MHCD = '1'       THEN '1. 일시상환'  --여신상환방법코드
                 WHEN ISDATE(A.DFR_EXPI_DT) = 0  THEN '3. 비거치식 분할상환'
                 ELSE '2. 거치식 분할상환'
            END                             AS 상환방법구분

//}

//{  #인덱스 #INDEX

-- 계좌를 찾는 속도를 빠르게 하기 위해서 INDEX 를 생성하는 방법

SELECT      DISTINCT 통합계좌번호
INTO        #원화대출금_계좌별  -- DROP TABLE #원화대출금_계좌별
FROM        #원화대출금
;

COMMIT;

CREATE HG INDEX C1_HG ON #원화대출금_계좌별(통합계좌번호);

SELECT      ......
WHERE       1=1
AND         INTG_ACNO  IN ( SELECT DISTINCT 통합계좌번호 FROM #원화대출금_계좌별 )


//}

//{ #월별  #매월

SELECT       NUMBER(*) 순번,기준일자
INTO         #TEMP_일자 -- DROP TABLE #TEMP_일자  SELECT * FROM #TEMP_일자
FROM
            (
             SELECT  MAX(STD_DT)  기준일자
             FROM    OT_DWA_INTG_CLN_BC
             WHERE   1=1
             AND     STD_DT  BETWEEN  '20080131' AND '20151031'
             --AND     STD_DT = '20120131'
             GROUP BY LEFT(STD_DT,6)
            )  A
ORDER BY     기준일자
;

SELECT      A.기준일자
           ,A1.기준일자        AS    M1
           ,A2.기준일자        AS    M2
           ,A3.기준일자        AS    M3
           ,A4.기준일자        AS    M4
           ,A5.기준일자        AS    M5
           ,A6.기준일자        AS    M6
           ,A7.기준일자        AS    M7
           ,A8.기준일자        AS    M8
           ,A9.기준일자        AS    M9
           ,A10.기준일자       AS    M10
           ,A11.기준일자       AS    M11
           ,A12.기준일자       AS    M12
           ,A13.기준일자       AS    M13
           ,A14.기준일자       AS    M14

INTO        #TEMP_일자매트릭스 --DROP TABLE #TEMP_일자매트릭스  SELECT * FROM #TEMP_일자매트릭스
FROM        #TEMP_일자  A

LEFT OUTER JOIN
            #TEMP_일자  A1
            ON    A.순번 + 1 = A1.순번

LEFT OUTER JOIN
            #TEMP_일자  A2
            ON    A.순번 + 2 = A2.순번

LEFT OUTER JOIN
            #TEMP_일자  A3
            ON    A.순번 + 3 = A3.순번

LEFT OUTER JOIN
            #TEMP_일자  A4
            ON    A.순번 + 4 = A4.순번

LEFT OUTER JOIN
            #TEMP_일자  A5
            ON    A.순번 + 5 = A5.순번

LEFT OUTER JOIN
            #TEMP_일자  A6
            ON    A.순번 + 6 = A6.순번

LEFT OUTER JOIN
            #TEMP_일자  A7
            ON    A.순번 + 7 = A7.순번

LEFT OUTER JOIN
            #TEMP_일자  A8
            ON    A.순번 + 8 = A8.순번

LEFT OUTER JOIN
            #TEMP_일자  A9
            ON    A.순번 + 9 = A9.순번

LEFT OUTER JOIN
            #TEMP_일자  A10
            ON    A.순번 + 10 = A10.순번

LEFT OUTER JOIN
            #TEMP_일자  A11
            ON    A.순번 + 11 = A11.순번

LEFT OUTER JOIN
            #TEMP_일자  A12
            ON    A.순번 + 12 = A12.순번

LEFT OUTER JOIN
            #TEMP_일자  A13
            ON    A.순번 + 13 = A13.순번

LEFT OUTER JOIN
            #TEMP_일자  A14
            ON    A.순번 + 14 = A14.순번

ORDER BY    1
;

SELECT       A.STD_DT
            ,A.구분3
            ,SUM(CASE WHEN B.기준일자 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 해당월연체잔액
            ,SUM(CASE WHEN B.M1 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+1'
            ,SUM(CASE WHEN B.M2 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+2'
            ,SUM(CASE WHEN B.M3 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+3'
            ,SUM(CASE WHEN B.M4 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+4'
            ,SUM(CASE WHEN B.M5 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+5'
            ,SUM(CASE WHEN B.M6 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+6'
            ,SUM(CASE WHEN B.M7 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+7'
            ,SUM(CASE WHEN B.M8 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+8'
            ,SUM(CASE WHEN B.M9 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M9'
            ,SUM(CASE WHEN B.M10 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+10'
            ,SUM(CASE WHEN B.M11 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+11'
            ,SUM(CASE WHEN B.M12 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+12'
            ,SUM(CASE WHEN B.M13 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+13'
            ,SUM(CASE WHEN B.M14 = C.기준일자 THEN C.금감원연체금액 ELSE 0 END) AS 'M+14'
FROM        #TEMP_신규여신                 A
           ,#TEMP_일자매트릭스  B
           ,#TEMP_연체금액      C
WHERE        A.STD_DT         =  B.기준일자
AND          A.INTG_ACNO     *=  C.통합계좌번호
GROUP BY     A.STD_DT
            ,A.구분3
ORDER BY     2,1
;
//}

//{ #담보연결 #전체담보 #담보 #부동산담보 #당행상품담보 #보증서담보 #채권담보 #유가증권담보 #보증인담보  #모든담보

-- CASE 1
             --부동산
             SELECT   DISTINCT A.MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO -- 대출계좌번호
             FROM     TT_SOR_CLM_MM_REST_MRT_BC   A --SOR_CLM_월부동산담보기본
                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_월설정기본

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_월여신연결내역

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'
             UNION ALL
             --예금담보
             SELECT   DISTINCT A.MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO
              FROM    TT_SOR_CLM_MM_TBK_PRD_MRT_BC   A --SOR_CLM_월당행상품담보기본

                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_월설정기본

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_월여신연결내역

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'
             UNION ALL
             --보증서
             SELECT   DISTINCT A.MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO -- 대출계좌번호
             FROM     TT_SOR_CLM_MM_WRGR_MRT_BC A --SOR_CLM_월보증서담보기본

                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_월설정기본

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_월여신연결내역

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'
             UNION ALL
             --채권담보원장
             SELECT   DISTINCT A.MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO -- 대출계좌번호
             FROM     TT_SOR_CLM_MM_BND_MRT_BC    A --SOR_CLM_월채권담보기본

                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_월설정기본

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_월여신연결내역

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'
             UNION ALL
              --유가증권
             SELECT   DISTINCT A.MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO -- 대출계좌번호
             FROM     TT_SOR_CLM_MM_MKSC_MRT_BC A --SOR_CLM_월유가증권담보기본

                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_월설정기본

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_월여신연결내역

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'
             UNION ALL
              --보증인
             SELECT   DISTINCT '601' AS MRT_CD
                     ,C.ACN_DCMT_NO  AS ACN_DCMT_NO -- 대출계좌번호
             FROM     TT_SOR_CLM_MM_GRNR_MRT_BC   A --SOR_CLM_월보증인담보기본

                     ,TT_SOR_CLM_MM_STUP_BC       B --SOR_CLM_월설정기본

                     ,TT_SOR_CLM_MM_CLN_LNK_TR    C --SOR_CLM_월여신연결내역

             WHERE    A.STD_YM        = '201609'
             AND      B.STD_YM        = '201609'
             AND      C.STD_YM        = '201609'
             AND      A.MRT_NO        =  B.MRT_NO
             AND      B.STUP_NO       =  C.STUP_NO
             AND      B.STUP_STCD     = '02'
             AND      C.CLN_LNK_STCD IN ('02','03')
             AND      A.MRT_STCD      = '02'


-- CASE 2

SELECT      A.ACN_DCMT_NO        AS 계좌번호
           ,A.STUP_NO            AS 설정번호
           ,B.MRT_TPCD           AS 담보유형코드
           ,B.MRT_NO             AS 담보번호
           ,B.APSL_NO            AS 감정번호
           ,B.STUP_DT            AS 설정일자
           ,B.STUP_AMT           AS 설정금액

INTO        #여신연결    -- DROP TABLE #여신연결
FROM        DWZOWN.TT_SOR_CLM_MM_CLN_LNK_TR  A --SOR_CLM_월여신연결내역
JOIN        DWZOWN.TT_SOR_CLM_MM_STUP_BC     B --SOR_CLM_월설정기본
            ON    A.STUP_NO  = B.STUP_NO
            AND   B.NFFC_UNN_DSCD = '1'
            AND   B.STUP_STCD     = '02'       --설정상태코드:02(정상)

WHERE       A.STD_YM        = '201612'      --기준년월        VVV
AND         A.STD_YM        = B.STD_YM        --조인
AND         A.NFFC_UNN_DSCD = '1'             --중앙회조합구분코드:2(조합)
AND         A.CLN_LNK_STCD  = '02'            --여신연결상태코드:02(정상)
AND         A.ACN_DCMT_NO   IN  (  SELECT 통합계좌번호  FROM #원화대출금 )
;



SELECT      AA.OWNR_CUST_NO            AS  제공자고객번호
           ,D.CUST_NM                  AS  제공자고객명
           ,D.MBTL_DSCD || D.MBTL_TONO  || D.MBTL_SNO  AS 휴대전화번호
           ,AA.MRT_CD                  AS   담보코드
           ,B.MRT_CD_NM                AS   담보코드명
           ,A.계좌번호
           ,A.설정번호
           ,A.담보번호
           ,A.감정번호
           ,A.설정일자
           ,A.설정금액
           ,A.담보유형코드
INTO        #담보연결  -- DROP TABLE #담보연결
FROM        #여신연결    A
JOIN        (
             SELECT  MRT_NO
                   , OWNR_CUST_NO
                   , MRT_CD
              FROM TB_SOR_CLM_REST_MRT_BC      -- CLM_부동산담보기본
              WHERE  MRT_STCD      = '02'
              UNION ALL
              SELECT  MRT_NO
                    , OWNR_CUST_NO
                    , MRT_CD
              FROM TB_SOR_CLM_TBK_PRD_MRT_BC   -- CLM_당행상품담보기본
              WHERE  MRT_STCD      = '02'
              UNION ALL
              SELECT   MRT_NO
                    , OWNR_CUST_NO
                    , MRT_CD
              FROM TB_SOR_CLM_BND_MRT_BC       -- CLM_채권담보기본
              WHERE  MRT_STCD      = '02'
              //----------------------보증인은 제외----------------------------------
--              UNION ALL
--              SELECT  MRT_NO
--                    , GRNR_CUST_NO    AS OWNR_CUST_NO
--                    , '601'
--              FROM TB_SOR_CLM_GRNR_MRT_BC      -- CLM_보증인담보기본
--              WHERE  MRT_STCD      = '02'
             //--------------------------------------------------------------------
              UNION ALL
              SELECT   MRT_NO
                    , OWNR_CUST_NO
                    , MRT_CD
              FROM TB_SOR_CLM_WRGR_MRT_BC      -- CLM_보증서담보기본
              WHERE  MRT_STCD      = '02'
              UNION ALL
              SELECT   MRT_NO
                    , OWNR_CUST_NO
                    , MRT_CD
              FROM TB_SOR_CLM_MKSC_MRT_BC       -- CLM_유가증권담보기본
              WHERE  MRT_STCD      = '02'
            ) AA
            ON     A.담보번호       = AA.MRT_NO

JOIN        TB_SOR_CLM_MRT_CD_BC B               -- CLM_담보코드기본
            ON     AA.MRT_CD       = B.MRT_CD

JOIN        OM_DWA_INTG_CUST_BC      D            -- DWA_통합고객기본
            ON     AA.OWNR_CUST_NO = D.CUST_NO
;

//}

//{  #반기평잔   #평잔

SELECT      BEOM_DT                                       --  전월말일자
           ,CASE WHEN RIGHT(P_기준일자,4) > '0731'  THEN LEFT(P_기준일자,4) || '0701' ELSE LEFT(P_기준일자,4) ||'0101' END
INTO        V_전월말일
           ,V_적수산출시작일
FROM        OM_DWA_DT_BC        --  DWA_일자기본
WHERE       STD_DT =  P_기준일자
;

SELECT      A.INTG_ACNO
           ,SUM(A.MNDR_WN_ACMN) /  (DAYS(DATE(V_적수산출시작일), DATE(V_전월말일)) + 1)  AS 반기평잔
INTO        #반기평잔        -- DROP TABLE #반기평잔
FROM        OT_DWA_MM_ACN_RMD_TZ   A
JOIN        TB_SOR_LOA_ACN_BSC_DL   B       --SOR_LOA_계좌기본상세
            ON   A.INTG_ACNO  = B.CLN_ACNO
            //===============================================================
            AND  B.TCH_EVL_ISN_NO <> ''   -- 기술평가발급번호가 있는것
            //===============================================================
JOIN        TB_SOR_CMI_BR_BC         J      --일점기본
            ON   A.ACCT_PCS_BRNO  =  J.BRNO
            AND  J.BR_DSCD        = '1'      -- 중앙회

WHERE       1=1
AND         A.STD_YM  BETWEEN  LEFT(V_적수산출시작일,6)  AND  LEFT(V_전월말일,6)
GROUP BY    A.INTG_ACNO
;

//}

//{  #연장시점 #약정시점 #연장시등급 #약정시등급


LEFT OUTER JOIN         -- 최근연장거래정보
                        -- 연장일자가 차세대 이전인경우 등급및 전결권 구할수 없음
            (
             SELECT       TA.CLN_ACNO                     AS  여신계좌번호
                         ,TA.ENR_DT                       AS  연장일자
                         ,TA.AGR_AMT                      AS  연장금액
                         ,TA.TR_BF_ADD_IRT                AS  거래전가산금리
                         ,TA.ADD_IRT                      AS  가산금리
                         ,TC.CRDT_EVL_GD                  AS  신용평가등급
                         ,TD.XCDC_ATR_DSCD                AS  전결속성구분코드
                         ,TE.ASS_CRDT_GD                  AS  ASS신용등급
             FROM         DWZOWN.TB_SOR_LOA_AGR_HT       TA
             JOIN         (
                            SELECT   CLN_ACNO
                                    ,MAX(AGR_TR_SNO) AS AGR_TR_SNO    --약정거래일련번호(최종기한연장의 약정거래일련번호)
                            FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                            WHERE    CLN_APC_DSCD IN ('11','12','13') --여신신청구분코드(11:기한연장,12:기한연장및증액,13:기한연장및조건변경)
                            AND      TR_STCD       =  '1'             --거래상태코드(1:정상)
                            AND      ENR_DT       <=  '20160630'
                            GROUP BY CLN_ACNO
                          )            TB
                          ON    TA.CLN_ACNO   = TB.CLN_ACNO
                          AND   TA.AGR_TR_SNO = TB.AGR_TR_SNO

             LEFT OUTER JOIN
                          TB_SOR_CLI_CLN_APRV_BC     TC     -- SOR_CLI_여신승인기본
                          ON   TA.CLN_APRV_NO  =  TC.CLN_APRV_NO

             LEFT OUTER JOIN
                          TB_SOR_CLI_XCDC_DSCD_BC  TD   --SOR_CLI_전결구분코드기본
                          ON   TC.LST_XCDC_DSCD  = TD.CLN_XCDC_DSCD  --여신전결구분코드

             LEFT OUTER JOIN
                          TB_SOR_PLI_SYS_JUD_RSLT_TR TE          --SOR_PLI_시스템심사결과내역
                          ON   TC.CUST_NO        = TE.CUST_NO
                          AND  TC.CLN_APC_NO     = TE.CLN_APC_NO

             WHERE        1=1
             AND          TA.CLN_ACNO  IN ( SELECT DISTINCT 통합계좌번호 FROM #원화대출금_계좌별 )
            )      C
            ON            A.통합계좌번호  = C.여신계좌번호
            AND           A.실행순서      = 1
            AND           A.약정일자      <  C.연장일자           -- 종통의 경우 재약정해도 계좌번호 안바뀌므로 연장일자가 약정일자보다 빠르게 나오는 경우도있음

LEFT OUTER JOIN         -- 최초약정거래정보
            (
             SELECT      TA.CLN_ACNO                     AS  여신계좌번호
                        ,TA.AGR_EXPI_DT                  AS  약정만기일자
                        ,TA.AGR_DT                       AS  약정일자
                        ,TA.AGR_AMT                      AS  약정금액
                        ,TA.TR_BF_ADD_IRT                AS  거래전가산금리
                        ,TA.ADD_IRT                      AS  가산금리
                        ,TC.CRDT_EVL_GD                  AS  신용평가등급
                        ,TD.XCDC_ATR_DSCD                AS  전결속성구분코드  --'01' 본부전결, '02' 영업점전결
                        ,TE.ASS_CRDT_GD                  AS  ASS신용등급

             FROM        DWZOWN.TB_SOR_LOA_AGR_HT       TA
             JOIN        (
                           SELECT   CLN_ACNO
                                   ,MAX(AGR_TR_SNO) AS AGR_TR_SNO    --약정거래일련번호(최종기한연장의 약정거래일련번호)
                           FROM     DWZOWN.TB_SOR_LOA_AGR_HT
                           WHERE    CLN_APC_DSCD IN ('01','02','04','07','08','09') --여신신청구분코드 <10 는 신규건
                           AND      TR_STCD       =  '1'             --거래상태코드(1:정상)
                           AND      ENR_DT       <=  '20160630'
                           GROUP BY CLN_ACNO
                         )            TB
                         ON    TA.CLN_ACNO   = TB.CLN_ACNO
                         AND   TA.AGR_TR_SNO = TB.AGR_TR_SNO

             LEFT OUTER JOIN
                         TB_SOR_CLI_CLN_APRV_BC     TC     -- SOR_CLI_여신승인기본
                         ON   TA.CLN_APRV_NO  =  TC.CLN_APRV_NO

             LEFT OUTER JOIN
                         TB_SOR_CLI_XCDC_DSCD_BC  TD   --SOR_CLI_전결구분코드기본
                         ON   TC.LST_XCDC_DSCD  = TD.CLN_XCDC_DSCD  --여신전결구분코드

             LEFT OUTER JOIN
                          TB_SOR_PLI_SYS_JUD_RSLT_TR TE          --SOR_PLI_시스템심사결과내역
                          ON   TC.CUST_NO        = TE.CUST_NO
                          AND  TC.CLN_APC_NO     = TE.CLN_APC_NO

             WHERE       1=1
             AND         TA.CLN_ACNO  IN ( SELECT DISTINCT 통합계좌번호 FROM #원화대출금_계좌별 )
            )     D
            ON            A.통합계좌번호  = D.여신계좌번호
            AND           A.실행순서      = 1
            AND           A.약정일자      = D.약정일자     -- 신규약정건을 가져오는 것이므로 약정일자가 당연히 같을것이지만 확인을 위해서 필요


//}

//{  #외환약정액  #외환약정금액

SELECT      A.STD_DT
           ,A.CUST_NO
           ,A.INTG_ACNO
           ,A.CLN_EXE_NO
           ,A.FRXC_TSK_DSCD
           ,MAX(CASE WHEN A.CRCD <> 'KRW'  THEN A.AGR_AMT * B.DLN_STD_EXRT ELSE A.AGR_AMT END)     AS 약정금액

INTO        #TEMP2  -- DROP TABLE #TEMP2
FROM        DWZOWN.OT_DWA_INTG_CLN_BC     A       --

JOIN        DWZOWN.OT_DWA_EXRT_BC         B       --DWA_환율기본
            ON   A.CRCD       =  B.CRCD
            AND  A.STD_DT     =  B.STD_DT
            AND  B.EXRT_TO    = 1

JOIN        #고정이하여신    C
            ON   A.INTG_ACNO   =   C.INTG_ACNO

WHERE       1=1
AND         A.STD_DT  =  '20161206'
AND         A.BR_DSCD      = '1'     --점구분코드
AND         A.AGR_DT       >=  '20120101'
AND         A.CLN_ACN_STCD =  '1'              -- 계좌상태 정상
AND         A.FRXC_TSK_DSCD IN ('11','12','21','22','23','41','42') -- 외환업무구분코드(11:수출기본,12:외화수표매입,21:수입개설,22:수입BL접수,23:수입LG발급,41:내국개설,42:내국매입)

GROUP BY    A.STD_DT
           ,A.CUST_NO
           ,A.INTG_ACNO
           ,A.CLN_EXE_NO
           ,A.FRXC_TSK_DSCD
;

SELECT      A.STD_DT
           ,A.CUST_NO
           ,A.INTG_ACNO
           ,SUM(A.약정금액)        AS   약정금액
INTO        #TEMP3        -- DROP TABLE #TEMP3
FROM        #TEMP2  A
GROUP BY    A.STD_DT
           ,A.CUST_NO
           ,A.INTG_ACNO
;
//}

//{  #부도일자  #원금부도일자 #이자부도일자

LEFT OUTER JOIN
            (
                 SELECT   INTG_ACNO, MAX(PCPL_DSH_DT) MAX_PCPL_DSH_DT ,MAX(INT_DSH_DT) MAX_INT_DSH_DT  -- MAX를 사용하긴 했으나 계좌별로 동일값만 있는듯.
                 FROM     TB_SOR_DAD_CLN_DSH_INF_TR             --SOR_DAD_여신부도정보내역
                 WHERE    1=1
                 AND      DWUP_STD_DT = '20161206'
                 AND      INTG_ACNO IN ( SELECT DISTINCT INTG_ACNO  FROM #고정이하여신)
                 GROUP BY INTG_ACNO
                 /*   DISTINCT 해봤을때 한계좌당 여러건이 나오지 않는지 확인
                 SELECT INTG_ACNO, COUNT(*)
                 FROM
                 (
                  SELECT   DISTINCT INTG_ACNO, PCPL_DSH_DT,INT_DSH_DT
                                  FROM     TB_SOR_DAD_CLN_DSH_INF_TR              --SOR_DAD_여신부도정보내역
                                  WHERE    1=1
                                  AND      DWUP_STD_DT = '20161205'
                                  AND      INTG_ACNO IN ( SELECT DISTINCT INTG_ACNO  FROM #고정이하여신)
                 ) A
                 GROUP BY INTG_ACNO
                 HAVING COUNT(*) > 1
                 */
            )     D
            ON   A.INTG_ACNO  =  D.INTG_ACNO
//}

//{  #담보연계


SELECT      NUMBER(*)                AS   순번
           ,A.CLN_ACNO               AS   대상계좌번호  -- 112일때는 자계좌, 113일때는 모계좌가 들어간다
           ,A.CLN_ACN_LNK_KDCD       AS   여신계좌연결종류코드
           ,A.ENR_DT                 AS   등록일자
           ,CASE WHEN  A.CLN_ACN_LNK_KDCD = '112'  THEN   A.LNK_CLN_FCNO ELSE  A.CLN_ACNO     END   AS 모계좌
           ,CASE WHEN  A.CLN_ACN_LNK_KDCD = '112'  THEN   A.CLN_ACNO     ELSE  A.LNK_CLN_FCNO END   AS 자계좌
INTO        #대상계좌    -- DROP TABLE #대상계좌
FROM        TB_SOR_LOA_ACN_LNK_BC A      -- SOR_LOA_계좌연결기본
-----------------------------------------------------------------------------------------------
WHERE       A.CLN_ACN_LNK_KDCD  IN ('112','113')
-----------------------------------------------------------------------------------------------
--ORDER BY    3,4
;


//}

//{  #누적   #CROSS  #크로스

SELECT      A.CLN_ACNO               AS   대상계좌번호  -- 112일때는 자계좌, 113일때는 모계좌가 들어간다
           ,A.CLN_ACN_LNK_KDCD       AS   여신계좌연결종류코드
           ,A.ENR_DT                 AS   등록일자
           ,CASE WHEN  A.CLN_ACN_LNK_KDCD = '112'  THEN   A.LNK_CLN_FCNO ELSE  A.CLN_ACNO     END   AS 모계좌
           ,CASE WHEN  A.CLN_ACN_LNK_KDCD = '112'  THEN   A.CLN_ACNO     ELSE  A.LNK_CLN_FCNO END   AS 자계좌
INTO        #담보연계    -- DROP TABLE #담보연계
FROM        TB_SOR_LOA_ACN_LNK_BC A      -- SOR_LOA_계좌연결기본
WHERE       A.CLN_ACN_LNK_KDCD  IN ('112','113')
;

--  SELECT COUNT(*) FROM #담보연계  --  1303

SELECT      STD_DT
INTO        #기준일자  -- DROP TABLE #기준일자
FROM        OM_DWA_DT_BC
WHERE       STD_DT  IN ('20111231',
                        '20120331','20120630','20120930','20121231',
                        '20130331','20130630','20130930','20131231',
                        '20140331','20140630','20140930','20141231',
                        '20150331','20150630','20150930','20151231',
                        '20160331','20160630','20160930','20161130'
                       );


SELECT      A.STD_DT          AS   기준일자
           ,B.대상계좌번호    AS   계좌번호
           ,B.등록일자

INTO        #담보연계_기준일자별       -- DROP TABLE #담보연계_기준일자별
FROM        #기준일자   A
CROSS JOIN  #담보연계   B

WHERE       1=1
AND         A.STD_DT  >=  B.등록일자
;


//}

//{  #월평잔 #계좌잔액집계 #기중평잔

--  죽은계좌포함해서 평잔구하기
SELECT      A.INTG_ACNO                AS   통합계좌번호
           ,SUM(A.WN_RMD)              AS   원화잔액
           ,SUM(A.MNDR_WN_AVBL)        AS   월중원화평잔
           ,SUM(A.IMT_WN_AVBL)         AS   기중원화평잔
INTO        #계좌평잔    -- DROP TABLE #계좌평잔
FROM        DWZOWN.OT_DWA_MM_ACN_RMD_TZ        A
WHERE       A.STD_YM   ='201611'
AND         A.INTG_CNTT_TSK_DSCD <> '01'    -- 수신은 제외 (종통의 경우 동일계좌가 수신 여신으로 중복된다)
AND         A.INTG_ACNO IN ( SELECT  DISTINCT 통합계좌번호 FROM  #TEMP_기본여신)
GROUP BY    A.INTG_ACNO
;

//}

//{   #B2410 #N0058  #금감원보고서 #신용  #가계신용

AND         CASE WHEN A.STD_DT  < '20120101'  THEN
              CASE WHEN (A.BS_ACSB_CD IN ('15005811','15006211','15006311','16006011','16006111') AND A.MRT_CD IN ('101','102','103','104','105','170','109','111')) OR
                         A.BS_ACSB_CD = '14000611'  THEN '주택담보'
                   WHEN  A.MRT_CD < '100' OR A.MRT_CD IN ('601','602') THEN '신용'
                   ELSE  '기타'  END
              WHEN A.STD_DT  >= '20120101'  THEN
              CASE WHEN (A.BS_ACSB_CD IN ('15005811','15006211','15006311','16006011','16006111') AND A.MRT_CD IN ('101','102','103','104','105','170','109','420','421','422','423','512','521')) OR
                         A.BS_ACSB_CD = '14000611'  THEN '주택담보'
                   WHEN  A.MRT_CD < '100' OR A.MRT_CD IN ('601','602') THEN '신용'
                   ELSE  '기타'  END
            END   = '신용'                    --  b2410 (UP_DWZ_경영_N0058_금감원업무보고서) 의 '가계신용'과 동일요건

//}

//{   #원장변경 #변경전 #변경후

--SELECT      A.CLN_ACNO
--           ,A.CLN_EXE_NO
--           ,B.CHB_LTR_HDN_CTS      AS  변경전문자항목내용
--           ,B.CHA_LTR_HDN_CTS      AS  변경후문자항목내용

--  한국은행 차입자금종류코드가 1050(원장변경화면) 에서 02~04[c2자금] 중 하나로 변경한 이력이 있는 계좌
SELECT      DISTINCT   A.CLN_ACNO

INTO        #대상계좌                --  DROP TABLE #대상계좌

FROM        TB_SOR_LOA_LDGR_CHG_HT       A    --  SOR_LOA_원장변경이력
JOIN        TB_SOR_LOA_LDGR_CHG_HIS_DL   B    --  SOR_LOA_원장변경이력상세
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

//{  #외환한도담보  #한도담보 #외환한도

   -- 현재시점의 무보보증담보내역 추출
SELECT      DISTINCT
            A.CLN_APC_NO             AS 여신신청번호
           ,A.ACN_DCMT_NO            AS 계좌번호
           ,B.MRT_NO                 AS 담보번호
           ,B.MRT_TPCD               AS 담보유형코드
           ,C.WRGR_NO                AS 보증서번호
           ,C.PBLC_ISTT_NM           AS 발행기관명
           ,C.EVL_AMT                AS 평가금액
INTO         #보증서담보 -- DROP TABLE #보증서담보
FROM        DWZOWN.TB_SOR_CLM_CLN_LNK_TR   A                -- SOR_CLM_여신연결내역
           ,DWZOWN.TB_SOR_CLM_STUP_BC      B                -- SOR_CLM_설정기본
           ,DWZOWN.TB_SOR_CLM_WRGR_MRT_BC  C                -- SOR_CLM_보증서담보기본
WHERE       1=1
AND         A.CLN_LNK_STCD = '02'                            -- 여신연결상태코드(02:정상등록)
AND         A.ACN_DCMT_NO  > ' '                             -- 계좌식별번호
AND         B.MRT_TPCD     = '5'                             -- 담보유형코드(5:보증서)
AND         C.MRT_STCD     = '02'                            -- 담보상태코드(02:정상등록)
AND         A.STUP_NO      = B.STUP_NO                       -- 설정번호
AND         B.MRT_NO       = C.MRT_NO                        -- 담보번호
//=======================================================================================
AND         A.CLN_TSK_DSCD  =  '49'                          -- 여신업무구분코드 49:외환한도
AND         C.PBLC_ISTT_NM = '한국무역보험공사'              -- 무보보증
//=======================================================================================
;

SELECT      DISTINCT
            A.CLN_APC_NO             AS 여신신청번호
           ,A.ACN_DCMT_NO            AS 계좌번호
           ,B.MRT_NO                 AS 담보번호
           ,B.MRT_TPCD               AS 담보유형코드
INTO        #외환한도담보     -- DROP TABLE #외환한도담보
FROM        DWZOWN.TB_SOR_CLM_CLN_LNK_TR   A                -- SOR_CLM_여신연결내역
           ,DWZOWN.TB_SOR_CLM_STUP_BC      B                -- SOR_CLM_설정기본
WHERE       1=1
AND         A.CLN_LNK_STCD = '02'                            -- 여신연결상태코드(02:정상등록)
AND         A.ACN_DCMT_NO  > ' '                             -- 계좌식별번호
AND         A.STUP_NO      = B.STUP_NO                       -- 설정번호
//==============================================================================================
AND         A.CLN_TSK_DSCD  =  '49'                          -- 여신업무구분코드 49:외환한도
//==============================================================================================
;

--CASE3 외환한도상세의 마지막 한도승인건을 가져오는 방법
JOIN
            (
                SELECT  A.FRXC_LMT_ACNO,ISNULL(B.CLN_APRV_NO,A.CLN_APRV_NO) AS CLN_APRV_NO
                FROM    DWZOWN.TB_SOR_FEC_CLN_LMT_BC  A           -- SOR_FEC_여신한도기본
                LEFT OUTER JOIN
                        (
                         SELECT    A.FRXC_LMT_ACNO, A.CLN_APRV_NO
                         FROM      DWZOWN.TB_SOR_FEC_CLN_LMT_DL  A
                         JOIN      (
                                    SELECT A.FRXC_LMT_ACNO,MAX(A.SNO) AS MAX_SNO
                                    FROM   DWZOWN.TB_SOR_FEC_CLN_LMT_DL  A           -- SOR_FEC_여신한도상세
                                    WHERE  1=1
                                    AND    A.FRXC_CLN_TR_CD =  '22'                  -- 외환여신거래코드(22:실행)
                                    AND    A.FRXC_LDGR_STCD  NOT IN ('4','5') -- 외환원장상태코드(4:정정,5:취소)
                                    GROUP BY A.FRXC_LMT_ACNO
                                   )    B
                                   ON      A.FRXC_LMT_ACNO = B.FRXC_LMT_ACNO
                                   AND     A.SNO           = B.MAX_SNO
                        )   B
                        ON  A.FRXC_LMT_ACNO  = B.FRXC_LMT_ACNO
            )    B
            ON     A.외환한도계좌번호  = B.FRXC_LMT_ACNO

LEFT OUTER JOIN
            DWZOWN.TB_SOR_CLI_CLN_APRV_BC  C          -- SOR_CLI_여신승인기본
            ON     B.CLN_APRV_NO   =  C.CLN_APRV_NO

//}

//{  #외화총계정 #외화BS  #외화잔액

SELECT
--        A.BRNO                   AS 점번호
--       ,B.BR_NM                  AS 점명
        A.ACSB_CD              AS 계정과목코드
       ,A.CRCD                   AS 통화코드
       ,SUM(A.TD_FC_RMD)       AS 당일외화잔액
       ,SUM(A.TD_WN_RMD)       AS당일원화잔액
  FROM  OT_DWA_FC_FLST_BC      A                --   DWA_외화총계정기본 */
       ,OT_DWA_DD_BR_BC        B                --   DWA_일점기본
 WHERE  A.FSC_DT  =   '20111231'
   AND  A.FSC_SNCD = 'K'              /* 회계기준코드 : 'K'(GAAP)      */
   AND  A.BRNO <> 'XXXX'              /* 점번호 : 'XXXX' 제외          */
   AND  A.SMTL_ACCT_YN = 'N'          /* 합계계정여부 : 'N' (합계점제외) */
   AND  A.ACSB_CD     IN  ('14001818','14001918','14002018','96000418','96001018')
   AND  B.STD_DT  = '20111231'
   AND  A.BRNO    = B.BRNO         /* 점번호             */
   AND  B.BR_STCD  <> '09'           --점상태코드=<>'폐쇄'
   AND  B.BR_KDCD  < '40'           --10:본부부서, 20:영업점, 30:관리점
   AND  B.BRNO NOT IN ('XXXX','0022','0023','0025','0234')  --제외점번호
 GROUP BY
--         A.BRNO
--        ,B.BR_NM
           A.ACSB_CD
          ,A.CRCD
 ORDER BY 1

 //}

 //{  #외화별단예금  #별단예금
--  수신팀 이영진으로 부터 받은 쿼리의 일부분,오라클 쿼리임

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
                                )   * D.DLN_STD_EXRT  AS   DFRY_PSB_RMD    -- 지급가능금액(원금)
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
             -- 등록정상인건만
             AND C.TR_STCD              = '1'
             -- 전출전입제외
             AND C.ASP_TR_KDCD   NOT IN ( '3', '4' )
             AND B.ASP_TXIM_KDCD = '51'
             and A.lst_mvn_brno IS NOT NULL
             AND NVL ( C.ASP_DP_DFRY_DSCD, '1' ) != '2'
             and a.fsc_dscd in ( '1' )
             AND A.UNN_CD NOT IN ( '037' )
 //}

//{   #신청담보  #최종신청  #최근신청  #신청담보
-- 어떤 기준일자에서 가장 최근신청건에 붙어 있는 담보와 담보의 유효담보가액을 가져오는 방법

-- CASE1    기업심사
SELECT      A.통합계좌번호
           ,A.고객번호
           ,A.대출잔액
           ,B.여신신청번호
           ,C.MRT_NO            AS  담보번호
           ,C.AVL_WRT_MRAM      AS  유효가치담보금액
           ,ROW_NUMBER() OVER(PARTITION BY C.CLN_APC_NO,C.MRT_NO ORDER BY STUP_NO DESC) AS 최근설정건  -- 설정번호에 따라 유효가치담보금액이 달라질수있다

JOIN        (
             SELECT      A.ACN_DCMT_NO            AS  계좌번호
                        ,MAX(A.CLN_APC_NO)        AS  여신신청번호  -- 최종승인일에 여러건의 여신신청건이 있을수 있으므로 최종신청건으로
             FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
             JOIN        DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
                         ON  A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
             JOIN        (
                           SELECT   A.ACN_DCMT_NO         AS 계좌번호
                                   ,MAX(B.HDQ_APRV_DT)    AS 승인일자
                           FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
                                   ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
                           WHERE    A.ACN_DCMT_NO       IN  ( SELECT DISTINCT 통합계좌번호 FROM #기업대출 WHERE 기업구분   = '3.개인사업자' )
                           AND      A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
                           AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
                           AND      A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
                           AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
                           AND      B.HDQ_APRV_DT       <= '20161231'   -- 승인일자
                           GROUP BY A.ACN_DCMT_NO
                          )   C
                          ON     A.ACN_DCMT_NO       = C.계좌번호
                          AND    B.HDQ_APRV_DT       = C.승인일자
             WHERE       1=1
             AND         A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
             AND         A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
             AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
             GROUP BY    A.ACN_DCMT_NO
            )  B
            ON     A.통합계좌번호   =  B.계좌번호

JOIN        TT_SOR_CLM_MM_APC_MRT_EVL_TR   C   --  SOR_CLM_월신청담보평가내역
            ON     B.여신신청번호  = C.CLN_APC_NO
            AND    C.STD_YM        = '201612'
;


-- CASE2
SELECT      A.통합계좌번호
           ,A.고객번호
           ,A.대출잔액
           ,B.여신신청번호
           ,C.MRT_NO            AS  담보번호
           ,C.AVL_WRT_MRAM      AS  유효가치담보금액
           ,ROW_NUMBER() OVER(PARTITION BY C.CLN_APC_NO,C.MRT_NO ORDER BY C.STUP_NO DESC) AS 최근설정건  -- 설정번호에 따라 유효가치담보금액이 달라질수있다

JOIN        (
             SELECT      A.CLN_ACNO         AS 계좌번호
                        ,MAX(A.CLN_APC_NO)  AS 여신신청번호  -- 최종승인일에 여러건의 여신신청건이 있을수 있으므로 최종신청건으로
             FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
                        ,(SELECT   A.CLN_ACNO         AS 계좌번호
                                  ,MAX(A.CLN_APRV_DT) AS 승인일자
                          FROM     DWZOWN.TB_SOR_PLI_CLN_APC_BC A          -- (SOR_PLI_여신신청기본) --> 개인심사
                          WHERE    A.CLN_ACNO          IS NOT NULL
                          AND      A.CLN_APC_PGRS_STCD IN ( '03','04','13')  --여신신청진행상태코드(03:결재완료,04:실행완료,13:약정완료)
                          AND      A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
                          AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
                          AND      A.CLN_APRV_DT       <= '20161231'
                          GROUP BY A.CLN_ACNO
                         ) B
             WHERE       A.CLN_ACNO          IS NOT NULL
             AND         A.JUD_APRV_DCD_RLCD = '01'              -- 심사승인결재결과코드(01:승인/찬성)
             AND         A.CSS_XCDC_DSCD     = '22'              -- CSS전결구분코드(11:지소장-조합,21:점장-중앙회,22:부서장(중앙회))
             AND         A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
             AND         A.CLN_APRV_DT       <= '20161231'
             AND         A.CLN_ACNO          = B.계좌번호
             AND         A.CLN_APRV_DT       = B.승인일자
             GROUP BY    A.CLN_ACNO
            )   B
            ON     A.통합계좌번호   =  B.계좌번호

JOIN        TT_SOR_CLM_MM_APC_MRT_EVL_TR   C   --  SOR_CLM_월신청담보평가내역
            ON     B.여신신청번호  = C.CLN_APC_NO
            AND    C.STD_YM        = '201612'

--개인의 경우 SOR_PLI_시스템심사결과내역 로 대출한도금액을 담보대출한도 와 신용대출한도로 분리 해낼수 있다
--TB_SOR_PLI_SYS_JUD_RSLT_TR (SOR_PLI_시스템심사결과내역)
--
--CRLN_SMTL_AMT  (신용한도합계금액) ==> 차주신용한도합계금액:신용한도
--RL_MRT_AMT (실담보금액)  => 신청담보가용액: 담보한도(실담보금액)
--LN_LMT_AMT (대출한도금액) => 총대출가능한도
--
--일반적으로
--CSS담보구분이 3 (일부담보대)일 경우..
--
--LN_LMT_AMT = RL_MRT_AMT + CRLN_SMTL_AMT
--대출한도금액 = 실담보금액 + 신용한도합계금액

//}

//{  #신용평가서   #평가정보

SELECT                 ,CC.ADR_                         AS  본사소재
..............
LEFT OUTER JOIN  -- 업체명, 표준산업분류코드, 본사소재, 사업자번호, 기업신용평가등급 항목은 신용평가서상의 정보을 원함
            (    -- 계정계 신용평가서상의 정보는 신규여신신청시점의 평가정보로 인지함
                    -- 금융중개지원대출 시설자금대출 요건 ** FROM 조신형
                    -- 업무적으로는  신규만 가져오므로 1건만 나오는게 당연하지만
                    -- 구조적으로 계좌번호별로 다수건이 존재할수 있으므로 확인후 작업필요
                    -- SELECT CLN_ACNO, COUNT(*) FROM #TEMP GROUP BY #TEMP HAVING COUNT(*) > 1
                    -- 계좌별 다수건이 존재하는 계좌는 조신형과장에게 문의 할것
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
                            ,TB_SOR_CLI_CLN_APC_BC      B  -- SOR_CLI_여신신청기본
                            ,TB_SOR_CLI_CLN_APC_RPST_BC C  -- SOR_CLI_여신신청대표기본
                            ,TB_SOR_CCR_EVL_BZNS_OTL_TR D  -- SOR_CCR_평가업체개요내역
                    WHERE    A.CLN_ACNO        = B.ACN_DCMT_NO
                    AND      B.CLN_APC_RPST_NO = C.CLN_APC_RPST_NO
                    AND      C.CRDT_EVL_NO     = D.CRDT_EVL_NO
                    AND      B.CLN_APC_DSCD    = '01'    -- 여신신청구분코드(01:신규)
                    AND      A.CLN_TSK_DSCD    = '11'
                    --AND      SUBSTR(D.CRDT_EVL_INDS_CLSF_CD,1,2) NOT IN ('55','56','45','46','47','68','69')  -- 제외업종
                    -- 설비투자자금 요건으로는 필요한 조건이지만
                    -- 주어진 계좌에 산업분류코드를 채워주기만 하면되는 터라 일단 조건 제외하여 작업: 김충규
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


LEFT OUTER JOIN   -- 업체본사의 소재지
            (
              SELECT   DISTINCT
                       A.ZIP
                      ,CASE WHEN TRIM(A.MPSD_NM)  IN ('울산광역시','서울특별시','부산광역시','인천광역시','광주광역시','대구광역시','대전광역시')
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

//{일부담보대담보금액 모집단 생성
-- case1 기업대출
SELECT      A.통합계좌번호
           ,A.담보코드
           ,A.대출잔액
           ,B.여신신청번호
           ,C.MRT_NO            AS  담보번호
           ,C.AVL_WRT_MRAM      AS  유효가치담보금액
           ,ROW_NUMBER() OVER(PARTITION BY C.CLN_APC_NO,C.MRT_NO ORDER BY STUP_NO DESC) AS 최근설정건  -- 어떤설정건이냐에 따라 유효가치담보금액이 달라질수있다

INTO        #일부담보대담보금액    -- DROP TABLE   #일부담보대담보금액
FROM        (
             SELECT      A.통합계좌번호
                        ,A.담보코드
                        ,SUM(A.잔액)     AS   대출잔액
             FROM        #기업대출   A
             WHERE       1=1
             AND         A.기업구분 = '3.개인사업자'           -- 개인사업자
             AND         LEFT(A.표준산업분류코드,4) = '6811'   -- 부동산임대업자
             AND         A.담보코드 BETWEEN '001' AND '199'    -- 담보코드 부동산대상
             GROUP BY    A.통합계좌번호
                        ,A.담보코드
            )            A

JOIN        (
             SELECT      A.ACN_DCMT_NO            AS  계좌번호
                        ,MAX(A.CLN_APC_NO)        AS  여신신청번호
             FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
             JOIN        DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
                         ON  A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
             JOIN        (
                           SELECT   A.ACN_DCMT_NO         AS 계좌번호
                                   ,MAX(B.HDQ_APRV_DT)    AS 승인일자
                           FROM     DWZOWN.TB_SOR_CLI_CLN_APC_BC       A -- (SOR_CLI_여신신청기본) -- 기업심사
                                   ,DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
                           WHERE    A.ACN_DCMT_NO       IN  ( SELECT DISTINCT 통합계좌번호 FROM #기업대출 WHERE 기업구분   = '3.개인사업자' AND LEFT(표준산업분류코드,4) = '6811')
                           AND      A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
                           AND      A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
                           AND      A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
                           AND      A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호
                           AND      B.HDQ_APRV_DT       <= '20161231'   -- 승인일자
                           GROUP BY A.ACN_DCMT_NO
                          )   C
                          ON     A.ACN_DCMT_NO       = C.계좌번호
                          AND    B.HDQ_APRV_DT       = C.승인일자
             WHERE       1=1
             AND         A.APC_LDGR_STCD     = '10'              -- 신청원장상태코드(10:완료)
             AND         A.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드
             AND         A.CLN_APC_CMPL_DSCD IN ('20','21')      -- 여신신청완료구분코드(20:약정,21:실행)
             //-------------------------------------------------------------------------------------------------
             AND         A.APC_MRT_DSCD     = '03'               --신청담보구분코드(03:일부담보대)
                                                                 --기준일시점 최종신청건이 일부담보대 인 계좌만 대상으로 한다.
             //-------------------------------------------------------------------------------------------------
             GROUP BY    A.ACN_DCMT_NO
            )  B
            ON     A.통합계좌번호   =  B.계좌번호

JOIN        TT_SOR_CLM_MM_APC_MRT_EVL_TR   C   --  SOR_CLM_월신청담보평가내역
            ON     B.여신신청번호  = C.CLN_APC_NO
            AND    C.STD_YM        = '201612'
;

-- case 2 가계대출

CSS_MRT_DSCD  CSS담보구분코드
01  담보대
02  담보/보증부신용대
03  일부담보대  <=====
04  보증부신용대
05  무보증신용대

TB_SOR_PLI_APC_POT_MRT_TR SOR_PLI_신청시점담보내역  AVL_MRT_AMT 유효담보금액

유효담보가액

안녕하세요~ 차장님...오전에 문의주셨던 내용입니다..

TB_SOR_PLI_SYS_JUD_RSLT_TR (SOR_PLI_시스템심사결과내역)

CRLN_SMTL_AMT  (신용한도합계금액) ==> 차주신용한도합계금액:신용한도
RL_MRT_AMT (실담보금액)  => 신청담보가용액: 담보한도(실담보금액)
LN_LMT_AMT (대출한도금액) => 총대출가능한도

일반적으로
CSS담보구분이 3 (일부담보대)일 경우..

LN_LMT_AMT = RL_MRT_AMT + CRLN_SMTL_AMT

대출한도금액 = 실담보금액 + 신용한도합계금액

//}


//{ #전액상환  #계좌별완제 #완제
SELECT      A.MIN_STD_DT                   AS  STD_DT
           ,A.INTG_ACNO
           ,A.CLN_EXE_NO
           ,A.AGR_DT
           ,A.LN_EXE_AMT
           ,MAX(B.TR_DT)                   AS  중도상환일자
           ,SUM(B.TR_PCPL)                 AS  원금상환금액

INTO        #중도상환계좌     -- DROP TABLE #중도상환계좌

FROM        #TEMP                     A

JOIN        DWZOWN.TB_SOR_LOA_TR_TR     B       --  LOA_거래내역
            ON     A.INTG_ACNO  = B.CLN_ACNO
            AND    A.CLN_EXE_NO  = B.CLN_EXE_NO
            AND    B.TR_DT  BETWEEN  A.AGR_DT AND
                                CASE WHEN CONVERT(CHAR(8), DATEADD(MM, 2, A.AGR_DT), 112) > '20170131' THEN  '20170131'
                                     ELSE CONVERT(CHAR(8), DATEADD(MM, 2, A.AGR_DT), 112)
                                END -- 약정일로 부터 2개월이내 상환된내역,최대 20170131까지만 대상으로 함
            AND    B.TR_STCD    = '1'           --거래상태코드:1(정상)
            AND    B.TR_PCPL > 0                --거래원금
            AND    B.CLN_TR_KDCD ='300'         --여신거래종류코드:300(대출상환)

GROUP BY    A.MIN_STD_DT
           ,A.INTG_ACNO
           ,A.CLN_EXE_NO
           ,A.AGR_DT
           ,A.LN_EXE_AMT

HAVING      A.LN_EXE_AMT  - 원금상환금액 <= 0   -- 실행금액이 전부 상환된것
;

//}

//{  #인터넷뱅킹  #모바일뱅킹 #SH딩동 #인터넷 #모바일  #딩동

LEFT OUTER JOIN
            (-- 인터넷뱅킹 가입정보
             SELECT   RMN_NO     AS 실명번호
                     ,CUST_STCD  AS 고객상태
             FROM     TB_PB_CUST_INF       -- PB_고객정보
             WHERE    TSK_DC_CD = '3'    -- 3:인터넷뱅킹
            )    D
            ON   A.RNNO  = D.실명번호

LEFT OUTER JOIN
            (-- 모바일뱅킹 가입정보
             SELECT   RMN_NO    AS 실명번호
                     ,MBL_STCD  AS 모바일상태
             FROM     TB_PB_MBL_CUST_INF  -- PB_모바일고객정보
             WHERE    MBL_DC_CD = '3'    -- 3:스마트폰
            ) E
            ON   A.RNNO  = E.실명번호

LEFT OUTER JOIN
            TB_DWF_UMS_푸시고객기본    F
            ON   A.CUST_NO   = F.고객번호
            AND  F.푸시가입여부 = 'Y'

//}

//{  #대환 #여신신청구분코드 #신규대환

-- CASE1 신청원장에 들어간 대환정보로 구하기
SELECT      DISTINCT
            A.STD_DT                     AS  기준일자
           ,A.BRNO                       AS  점번호
           ,A.CUST_NO                    AS  고객번호
           ,A.INTG_ACNO                  AS  통합계좌번호
           ,CASE WHEN   D.CLN_APC_DSCD IS NOT NULL  THEN
                        CASE WHEN D.CLN_APC_DSCD = '02'  THEN   '02.대환' ELSE '01.신규'  END
                 ELSE   CASE WHEN E.CLN_APC_DSCD = '02'  THEN   '02.대환' ELSE '01.신규'  END
            END           AS 신규대환구분
--           ,D.CLN_APC_DSCD               AS  여신신청구분코드1
--           ,E.CLN_APC_DSCD               AS  여신신청구분코드2
           ,A.AGR_DT                     AS  약정일자
           ,A.AGR_AMT                    AS  약정금액
           ,A.LN_SBCD                    AS  대출과목코드
           ,A.PDCD                       AS  상품코드
           ,ISNULL(TRIM(Z3.PRD_KR_NM),' ')         AS 상품코드명

           ,CASE WHEN   LEFT(A.AGR_DT,6) = LEFT(A.STD_DT,6)   THEN  'O' ELSE 'X' END AS 신규약정여부

INTO        #모집단           -- DROP TABLE #모집단

FROM        DWZOWN.OT_DWA_INTG_CLN_BC A   -- DWA_통합여신기본

LEFT OUTER JOIN
            TB_SOR_PLI_CLN_APC_BC      D  -- SOR_PLI_여신신청기본
            ON   A.INTG_ACNO        = D.CLN_ACNO
            AND  D.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- 여신신청구분코드(01:신규,02:대환)
            AND  D.NFFC_UNN_DSCD     = '1'               -- 중앙회조합구분코드

LEFT OUTER JOIN
            TB_SOR_CLI_CLN_APC_BC      E    -- SOR_CLI_여신신청기본
            ON  A.INTG_ACNO        = E.ACN_DCMT_NO
            AND E.CLN_APC_DSCD    BETWEEN '01' AND '09'    -- 여신신청구분코드(01:신규,02:대환)
            AND E.NFFC_UNN_DSCD   = '1'     -- 중앙회
            AND E.APC_LDGR_STCD   = '10'    -- 신청원장상태코드(01:작성중,02:결재중,10:완료,99:취소)
            AND E.CLN_APC_CMPL_DSCD IN ('20','21') -- 여신신청완료구분코드

-- CASE2 계좌연결기본에 들어간 연결정보로 대환계좌구하기
-- 대환계좌여부 UPDATE
UPDATE      #기업자금  A
SET         A.대환계좌여부  = 'Y'
FROM        (
             -- 하나의 계좌가 여러계좌로 대환되는경우 있음
             -- 여러개의 계좌가 하나의 계좌로 대환되는경우 있음
             -- 대환전계좌라 하더라도 대환후에 해지상태로 반드시 변하는건 아닌것 같음
             -- 시차를 두고 동일한 대환후계좌가 나올수있음
             -- 동일한 대환건이라도 CLN_ACN_LNK_KDCD(여신계좌연결종류코드)  가 121,122 로 각각 중복해서 나타나는 경우도 있고
             -- 한번만 나타나는 경우도 있음
             SELECT      DISTINCT A.대환후계좌,A.거래일자
             FROM
                         (
                          SELECT   A.CLN_ACN_LNK_KDCD
                                  ,A.ENR_DT                 AS  거래일자
                                  ,CASE WHEN A.CLN_ACN_LNK_KDCD = '121' THEN A.LNK_CLN_FCNO ELSE  A.CLN_ACNO      END  AS  대환전계좌
                                  ,CASE WHEN A.CLN_ACN_LNK_KDCD = '121' THEN A.CLN_ACNO     ELSE  A.LNK_CLN_FCNO  END  AS  대환후계좌
                          FROM     TB_SOR_LOA_ACN_LNK_BC A      -- SOR_LOA_계좌연결기본
                          WHERE    A.CLN_ACN_LNK_KDCD  IN ('121','122')  -- 121 대환연결(대환전계좌), 122 대환연결(대환후계좌)
                         )   A
            )   D
WHERE       1=1
AND         A.통합계좌번호      = D.대환후계좌
AND         A.기준일자         >= D.거래일자
;
//}

//{  #IF  #IF문 #ELSE

//--------------------------------------------------------------------------------------
IF  P_구분 = 1  THEN
//--------------------------------------------------------------------------------------
......
//-------------------------------------------------------------------------------
ELSEIF    P_구분 = 2   THEN
//-------------------------------------------------------------------------------
.......
//-------------------------------------------------------------------------------
END IF;
//-------------------------------------------------------------------------------
//}

//{  #자체평가 #외부평가 #감정기관 #담보평가  #부동산담보  #감정기관 #감정평가기관

--1. 평가방법구분코드 (자체감정,외부감정 분류 방법)
-- 감정번호는(APSL_NO)가 설정기본에도 있고 부동산담보기본에도 있다, 이둘은 값이 서로 다를수 있다.
-- 설정기본의 감정번호는 설정시점에 최종감정번호라고 보면되고 부동산담보기본의 감정번호는 그냐말로 그시점의 최종감정번호라고 보면된다
-- 자체감정이냐 외부감정이냐를 구분하는                     ,C.EVL_MTH_DSCD   AS  평가방법구분코드_부동산원장
                       ,D.EVL_MTH_DSCD   AS  평가방법구분코드_감정원장
                       ,D.APSL_MTH_DSCD  AS  감정방법구분코드_감정원장

JOIN        (  -- EQUAL JOIN한다. 부동산 담보평가방법 구분이 가능한건만 본자료의 모집단으로 한다
              SELECT    A.STD_YM
                       ,A.ACN_DCMT_NO
                       ,COUNT(DISTINCT CASE WHEN C.EVL_MTH_DSCD IN ('01','02')       THEN C.MRT_NO  ELSE NULL END)  AS 자체평가담보건수
                       -- 01번에 KB아파트 시세로 평가한거 포함된
                       ,COUNT(DISTINCT CASE WHEN C.EVL_MTH_DSCD IN ('03','04','05')  THEN C.MRT_NO  ELSE NULL END)  AS 외부평가담보건수
               FROM     TT_SOR_CLM_MM_CLN_LNK_TR  A   --SOR_CLM_월여신연결내역
                       ,TT_SOR_CLM_MM_STUP_BC     B   --SOR_CLM_월설정기본
                       ,TT_SOR_CLM_MM_REST_MRT_BC C   --SOR_CLM_월부동산담보기본

              WHERE     1=1
              AND       A.STD_YM  BETWEEN '201301'  AND  '201706'
--              AND       A.STD_YM  IN  ('201312','201412','201512','201612','201706')
              AND       A.STD_YM         = B.STD_YM
              AND       A.STUP_NO        = B.STUP_NO
              AND       B.STD_YM         = C.STD_YM
              AND       B.MRT_NO         = C.MRT_NO
              AND       A.NFFC_UNN_DSCD  = '1'
             //=================================================================================
              AND       C.EVL_MTH_DSCD  IN ('01','02','03','04','05') -- 부동산 담보평가방법 구분이 가능한건만 본자료의 모집단으로 한다, 소수지만 값이 없는경우도있음
              AND       A.CLN_LNK_STCD  IN ('02','03')     -- 여신연결상태코드(02:정상,03:해지예정,04:해지)
              AND       B.STUP_STCD     IN ('02','03')     -- 설정상태코드(정상)(02:정상,03:해지예정,04:해지)
              AND       C.MRT_STCD      IN ('02')          -- 담보상태(02:정상등록,04:담보해지)
--              AND       ( C.NFM_YN      IS NULL  OR   C.NFM_YN   = 'N')         -- 견질담보 아닐것,1차자료에는 포함안된 조건문
--              AND       ( C.AFCP_MRT_YN IS NULL  OR   C.AFCP_MRT_YN  = 'N')     -- 후취담보 아닐것,1차자료에는 포함안된 조건문
              //=================================================================================
              AND       A.ENR_DT        >= '20100101'
              GROUP BY  A.STD_YM
                       ,A.ACN_DCMT_NO
            )            G
            ON   LEFT(A.STD_DT,6) = G.STD_YM
            AND  A.INTG_ACNO      = G.ACN_DCMT_NO

--2. 평가방법구분코드와 감정기관 구하기
--    여신정책실(20170830)_신규취급주담대현황_최운열의원_임영일.sql 중 일부
SELECT      A.STD_YM           AS 기준년월
           ,A.MRT_NO           AS 담보번호
           ,B.ACN_DCMT_NO      AS 여신계좌번호
           ,C.JUD_SMTL_AMT     AS 심사합계금액
           ,C.EVL_MTH_DSCD     AS 평가방법구분코드
           ,CASE D.EVL_RSRC_DSCD  WHEN '01' THEN  '1'    -- 'KB시세_국민은행'
                                  WHEN '02' THEN  '2'    -- 'TECH시세_한국감정원'
                                  WHEN '09' THEN  '3'    -- '외부감정평가기관'
                                  ELSE '7'       -- '기타'
            END                AS 주택평가기관

           ,ROW_NUMBER() OVER (PARTITION BY LEFT(A.STD_YM,4), B.ACN_DCMT_NO ORDER BY A.STUP_AMT DESC) AS 대표_담보

INTO        #감정기관  -- DROP TABLE #감정기관

FROM        TT_SOR_CLM_MM_STUP_BC     A    --SOR_CLM_월설정기본

JOIN        TT_SOR_CLM_MM_CLN_LNK_TR  B    --SOR_CLM_월여신연결내역
            ON   A.STD_YM   =  B.STD_YM
            AND  A.STUP_NO  =  B.STUP_NO       --설정번호
            AND  B.ACN_DCMT_NO   IN (SELECT DISTINCT 통합계좌번호  FROM #가계대출)
            AND  B.CLN_LNK_STCD  IN ('02','03')     --여신연결상태코드(02:정상,03:해지예정)
            AND  B.NFFC_UNN_DSCD = '1'

JOIN        TT_SOR_CLM_MM_REST_MRT_BC  C        --SOR_CLM_월부동산담보기본
            ON    A.STD_YM        = C.STD_YM
            AND   A.MRT_NO        = C.MRT_NO
            AND   C.MRT_STCD      = '02'

JOIN        TB_SOR_CLM_BLD_MRT_APSL_DL      D   -- SOR_CLM_건물담보감정상세
            ON    C.APSL_NO       = D.APSL_NO

WHERE       A.STD_YM        IN (  SELECT     LEFT(MAX(STD_DT),6)
                                   FROM      OT_DWA_INTG_CLN_DT_BC
                                   WHERE     1=1
                                   AND       STD_DT  BETWEEN '20160101' AND '20170630'
                                   GROUP BY  LEFT(STD_DT,6)
                                )
AND         A.NFFC_UNN_DSCD = '1'             --중앙회조합구분코드
AND         A.STUP_STCD     = '02'            --설정상태코드(02:정상등록)
;
//}

//{  #원화약정 #원화대출약정 #미사용한도

SELECT      CASE WHEN K.ACSB_CD5  IN ('95001111','14002501','14002601')                               THEN '1. 원화가계대출약정'
                 WHEN K.ACSB_CD5  IN ('96003411','14002401','96000211') OR A.BS_ACSB_CD = '95000211'  THEN '2. 원화기업대출약정'
                 WHEN K.ACSB_CD5  IN ('96003511')                                                     THEN '3. 원화신용카드약정'
                 ELSE A.BS_ACSB_CD || '(' || TRIM(ACSB_NM) || ')'
            END   구분
           ,SUM(NUS_LMT_AMT)  AS 잔액
FROM        TB_SOR_LOC_DDY_NUSE_LMT_TR   A -- SOR_LOC_일별미사용한도내역

JOIN        (
                  SELECT   STD_DT
                          ,ACSB_CD
                          ,ACSB_NM
                          ,ACSB_CD4  --원화대출금
                          ,ACSB_NM4
                          ,ACSB_CD5  --기업자금대출금(14002401), 가계자금대출금(14002501), 공공및기타(14002601)
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
GROUP BY    구분
ORDER BY     1
;
//}


//{  #조합원구분 #조합원

SELECT      A.순번
           ,A.고객번호
           ,B.UNN_CD ||'.'||ISNULL(TRIM(X1.CMN_CD_NM),' ')    AS  조합코드
           ,B.UNNR_DSCD ||'.'||ISNULL(TRIM(X2.CMN_CD_NM),' ') AS  조합원구분

FROM        #대상고객   A

LEFT OUTER JOIN
            TB_SOR_CUS_UNN_BC   B
            ON   A.고객번호   = B.CUST_NO

 LEFT OUTER JOIN
            OM_DWA_CMN_CD_BC       X1                  -- DWA_공통코드기본
            ON    B.UNN_CD  = X1.CMN_CD                -- 공통코드
            AND   X1.TPCD_NO_EN_NM = 'UNN_CD'          -- 유형코드번호영문명

 LEFT OUTER JOIN
            OM_DWA_CMN_CD_BC       X2                  -- DWA_공통코드기본
            ON    B.UNNR_DSCD  = X2.CMN_CD             -- 공통코드
            AND   X2.TPCD_NO_EN_NM = 'UNNR_DSCD'       -- 유형코드번호영문명
;
//}

//{  #임직원 #신용  #신용회계

SELECT      A.통합계좌번호

           ,CASE WHEN C2.사번 IS NOT NULL THEN '신용임직원' ELSE NULL END   AS 신용임직원여부

INTO        #권유자등  -- DROP TABLE #권유자등
FROM

LEFT OUTER JOIN  -- 차주가 신용직원인지 확인한다
            TB_MDWT인사  C2
            ON    A.실명번호  =  C2.주민번호
            AND   C2.작성기준일  = ( SELECT STD_DT FROM  OM_DWA_DT_BC  WHERE STD_DT_YN = 'Y' )
            AND   재직여부 체크할것
            AND   C2.회계코드명 = '신용회계'
//}

//{  #UP_DWZ_여신_N0093_담보별대출현황  #담보구분

-- UP_DWZ_여신_N0093_담보별대출현황 에서 사용하는 신용/담보/보증 담보구분 방법
    INSERT INTO #TEMP_건전성정보
    SELECT   '.'                      AS 들여쓰기
            ,실명번호
            ,계정코드
            ,고객구분코드
            ,CASE WHEN 담보유형코드 = '5' THEN 'B'
                  WHEN 담보유형코드 = '6' THEN 'C'
                  ELSE 'A'
             END                    AS 코드
            ,CASE WHEN 담보유형코드 = '5' THEN '보증'
                  WHEN 담보유형코드 = '6' THEN '신용'
                  ELSE '담보'
             END                    AS 코드명
            ,MAX(기업신용평가등급)  AS 신용평가등급
            ,SUM(계좌잔액)          AS 대출잔액
            ,ISNULL(기업구분, '0')  AS 기업구분코드
            ,ISNULL(상위계정, '0')  AS 상위계정코드
    FROM     #TEMP_건전성계좌일별 A  --SELECT * FROM #TEMP_건전성정보 WHERE 코드 = 'C'
--SELECT * FROM #TEMP_건전성계좌일별 WHERE 계좌번호 = '101000135468'
    GROUP BY 계정코드
            ,실명번호
            ,고객구분코드
            ,코드
            ,코드명
            ,기업구분코드
            ,상위계정코드
    ;

--  여신정책실(20170926)_원화대출금담보별현황_임영일.SQL
-- 주담보코드로 분류한 예
           ,CASE WHEN F.MRT_TPCD   = '5'              THEN 'A. 보증'
                 WHEN F.MRT_TPCD   = '6'              THEN
                      CASE WHEN F.MRT_CD  IN ('602','603')  THEN  'B.1 순수신용'
                           WHEN F.MRT_CD  IN ('601')        THEN  'B.2 인적보증'
                           ELSE 'B.9 UNKOWN'
                      END
                 WHEN F.MRT_TPCD  = '1'  THEN
                      CASE WHEN  F.REST_CLCD = '1'   THEN
                                 CASE WHEN F.MRT_CD  IN ('101')   THEN 'C.1.1 아파트'
                                      ELSE                             'C.1.2 기타'
                                 END
                           ELSE                                  'C.2 일반부동산'
                      END
                 WHEN F.MRT_TPCD  IN  ('2','3','4')  THEN   'C.3 기타동산'
                 ELSE 'Z. UNKNOWN'
            END                          AS  담보구분


//}

//{  #MCI  #MCG
SELECT      T.계좌번호
--           ,C.HSGR_GRN_DSCD  AS  주택보증보증구분코드
           ,B.담보번호
           ,B.담보코드
           ,CASE WHEN B.보증서구분코드 = '11' THEN '11.주택신용보증서'
                 WHEN B.보증서구분코드 = '51' THEN '51.MCI보증보험'
            END           AS 보증서구분
           ,C.HSGR_GRN_DSCD     AS  주택보증구분코드
--           ,CASE WHEN C.HSGR_GRN_DSCD IS NOT NULL THEN 'MCG' ELSE 'MCI' END AS MCI구분
INTO        #TEMP_보증서기본   --DROP TABLE #TEMP_보증서기본
FROM        (SELECT   DISTINCT 계좌번호  FROM #모집단_잔액 )      T
JOIN        (
             SELECT   DISTINCT        -- 동일담보에 여러건의 설정이 존재하므로 하나만 가져오기 위함
                      A.ACN_DCMT_NO AS 통합계좌번호
                     ,C.MRT_NO      AS 담보번호
                     ,C.MRT_CD      AS 담보코드
                     ,D.WRGR_DSCD   AS 보증서구분코드
                     ,C.WRGR_NO     AS 보증서번호
                     --,C.GRN_RT      AS 보증비율
                     --,D.GRMN        AS 보증금
                     --,SUBSTRING(D.WRGR_ISN_DT,1,4)   AS  보증서발급년도
                     --,D.GRMN                         AS  가입금액
                     --,D.GRN_FEE                      AS  보증료
             FROM     DWZOWN.TB_SOR_CLM_CLN_LNK_TR   A --SOR_CLM_여신연결내역
                     ,DWZOWN.TB_SOR_CLM_STUP_BC      B --SOR_CLM_설정기본
                     ,DWZOWN.TB_SOR_CLM_WRGR_MRT_BC  C --SOR_CLM_보증서담보기본
                     ,DWZOWN.TB_SOR_LOE_INTG_WRGR_BC D --SOR_LOE_통합보증서기본
             WHERE    A.CLN_LNK_STCD IN ('02','03','04')       --여신연결상태코드:02(정상)
             AND      A.STUP_NO       = B.STUP_NO              --설정번호
             AND      B.MRT_NO        = C.MRT_NO               -- 담보번호
             AND      C.WRGR_NO       = D.WRGR_NO
             AND      D.WRGR_DSCD    IN ('51','11')      -- 보증서구분코드(51:MCI보증보험), 11:주택신용보증서)
             AND      D.WRGR_STCD    IN ('04','05','09') -- MCI-04, MCG-05 AND 09만 유효
            )     B
            ON   T.계좌번호  =   B.통합계좌번호
LEFT OUTER JOIN
            TB_SOR_LOE_HFG_WRGR_BC  C -- SOR_LOE_주택금융보증보증서기본
            ON   B.보증서번호  =  C.WRGR_NO
            AND  C.HSGR_GRN_DSCD  IN ('08')   --주택보증보증구분코드 08:협약보증
WHERE       1=1
//----------MCI보증보험은 전부, 주택신용보증서는 주택보증구분코드 08인경우만 대상--------------------
AND         (          --
             B.보증서구분코드 = '51'  OR
             ( B.보증서구분코드 = '11'  AND C.WRGR_NO IS NOT NULL)
            )
//--------------------------------------------------------------------------------------------
;

//}

//{  #신청승인  #신청거절
-- CASE1 가계여신
SELECT      A.CLN_APC_NO
           ,A.CLN_APC_DSCD
           ,A.CLN_APC_PGRS_STCD
           ,A.APC_DT
           ,A.CLN_APC_AMT
           ,A.PDCD
           ,A.ADM_BRNO
           ,A.CUST_NO
           ,C.JB_CD

INTO        #TEMP_신청   --DROP TABLE #TEMP_신청
FROM        DWZOWN.TB_SOR_PLI_CLN_APC_BC   A            --SOR_PLI_여신신청기본 --> 개인심사

JOIN        DWZOWN.TB_SOR_CMI_BR_BC        B            --SOR_CMI_점기본
            ON      A.ADM_BRNO     = B.BRNO

JOIN        DWZOWN.OM_DWA_INTG_CUST_BC    C     --DWA_통합고객기본
            ON      A.CUST_NO      =  C.CUST_NO

WHERE       A.CLN_APC_DSCD      < '10'       --신규
--AND         A.CSS_MRT_DSCD      = '05'    -- 05:무보증신용대
--AND         A.CLN_APC_PGRS_STCD IN ('03','04','13')     --여신신청진행상태코드(03:결재완료, 04:실행완료 ,13:약정완료)
AND         A.NFFC_UNN_DSCD     = '1'                   --중앙회조합구분코드
AND         A.APC_DT      BETWEEN '20130101' AND '20170630'
;

-- 1. 신청
SELECT      CASE WHEN LEFT(A.JB_CD,2) =  '10'  THEN '10. 급여소득자'
                 WHEN LEFT(A.JB_CD,2) =  '20'  THEN '20. 전문직'
                 WHEN LEFT(A.JB_CD,2) =  '30'  THEN '30. 자영업자'
                 WHEN LEFT(A.JB_CD,2) =  '31'  THEN '31. 개인사업자'
                 WHEN LEFT(A.JB_CD,2) =  '40'  THEN '40. 농림어업인'
                 WHEN LEFT(A.JB_CD,2) =  '50'  THEN '50. 성직자'
                 WHEN LEFT(A.JB_CD,2) =  '60'  THEN '60. 주부(가사전담자)'
                 WHEN LEFT(A.JB_CD,2) =  '61'  THEN '61. 학생'
                 WHEN LEFT(A.JB_CD,2) =  '62'  THEN '62. 군인'
                 WHEN LEFT(A.JB_CD,2) =  '90'  THEN '90. 무직'
                 ELSE                               '99. UNKNOWN'
            END               AS  구분

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2013'  THEN A.CLN_APC_NO ELSE NULL END) AS 건수_2013
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2013'  THEN A.CLN_APC_AMT ELSE NULL END)           AS 금액_2013

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2014'  THEN A.CLN_APC_NO ELSE NULL END) AS 건수_2014
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2014'  THEN A.CLN_APC_AMT ELSE NULL END)           AS 금액_2014

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2015'  THEN A.CLN_APC_NO ELSE NULL END) AS 건수_2015
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2015'  THEN A.CLN_APC_AMT ELSE NULL END)           AS 금액_2015

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2016'  THEN A.CLN_APC_NO ELSE NULL END) AS 건수_2016
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2016'  THEN A.CLN_APC_AMT ELSE NULL END)           AS 금액_2016

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2017'  THEN A.CLN_APC_NO ELSE NULL END) AS 건수_2017
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2017'  THEN A.CLN_APC_AMT ELSE NULL END)           AS 금액_2017

FROM        #TEMP_신청 A

GROUP BY    구분
ORDER BY    1
;

-- 2. 신청 & 승인
SELECT      CASE WHEN LEFT(A.JB_CD,2) =  '10'  THEN '10. 급여소득자'
                 WHEN LEFT(A.JB_CD,2) =  '20'  THEN '20. 전문직'
                 WHEN LEFT(A.JB_CD,2) =  '30'  THEN '30. 자영업자'
                 WHEN LEFT(A.JB_CD,2) =  '31'  THEN '31. 개인사업자'
                 WHEN LEFT(A.JB_CD,2) =  '40'  THEN '40. 농림어업인'
                 WHEN LEFT(A.JB_CD,2) =  '50'  THEN '50. 성직자'
                 WHEN LEFT(A.JB_CD,2) =  '60'  THEN '60. 주부(가사전담자)'
                 WHEN LEFT(A.JB_CD,2) =  '61'  THEN '61. 학생'
                 WHEN LEFT(A.JB_CD,2) =  '62'  THEN '62. 군인'
                 WHEN LEFT(A.JB_CD,2) =  '90'  THEN '90. 무직'
                 ELSE                               '99. UNKNOWN'
            END               AS  구분

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2013'  THEN A.CLN_APC_NO ELSE NULL END) AS 건수_2013
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2013'  THEN A.CLN_APC_AMT ELSE NULL END)           AS 금액_2013

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2014'  THEN A.CLN_APC_NO ELSE NULL END) AS 건수_2014
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2014'  THEN A.CLN_APC_AMT ELSE NULL END)           AS 금액_2014

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2015'  THEN A.CLN_APC_NO ELSE NULL END) AS 건수_2015
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2015'  THEN A.CLN_APC_AMT ELSE NULL END)           AS 금액_2015

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2016'  THEN A.CLN_APC_NO ELSE NULL END) AS 건수_2016
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2016'  THEN A.CLN_APC_AMT ELSE NULL END)           AS 금액_2016

           ,COUNT(DISTINCT CASE WHEN  LEFT(A.APC_DT,4) =  '2017'  THEN A.CLN_APC_NO ELSE NULL END) AS 건수_2017
           ,SUM(CASE WHEN  LEFT(A.APC_DT,4) =  '2017'  THEN A.CLN_APC_AMT ELSE NULL END)           AS 금액_2017

FROM        #TEMP_신청  A

WHERE       1=1
AND         A.CLN_APC_PGRS_STCD NOT IN ('01','02','05','07')

GROUP BY    구분
ORDER BY    1
;
/*
01  작성중
02  결재중
03  결재완료
13  약정완료
04  실행완료
05  신청취소
06  승인요청완료
07  본부승인결재중
09  약정해지
*/

-- CASE2 기업여신

SELECT      LEFT(B.CSLT_DT,4)  AS  신청년도
           ,CASE WHEN   F.MRT_TPCD = '6'  THEN   '1.신용'
                 WHEN   F.MRT_TPCD = '5'  THEN   '2.보증'
                 ELSE    '3.담보'
            END    AS   담보구분

           ,CASE WHEN  A.CLN_APC_DSCD      < '10'  THEN '1. 신규'
                 ELSE '2. 연장'
            END             AS 신규연장구분
           ,COUNT( A.CLN_APC_NO)  AS  여신신청건수

FROM        DWZOWN.TB_SOR_CLI_CLN_APC_BC   A            --SOR_CLI_여신신청기본

JOIN        DWZOWN.TB_SOR_CLI_CLN_APC_RPST_BC  B -- (SOR_CLI_여신신청대표기본)
            ON     A.CLN_APC_RPST_NO   = B.CLN_APC_RPST_NO -- 여신신청대표번호

JOIN        TB_SOR_LOA_ACN_BC       D
            ON     A.ACN_DCMT_NO  = D.CLN_ACNO

LEFT OUTER JOIN
            TB_SOR_CLM_MRT_CD_BC       F             -- (SOR_CLM_담보코드기본)
            ON     D.MNMG_MRT_CD    = F.MRT_CD

WHERE       ( A.CLN_APC_DSCD      < '10'  OR  A.CLN_APC_DSCD  IN  ('11','12','13') )    --신규  OR 연장
//----------------------------------------------------------------------------------
AND         A.CLN_APC_CMPL_DSCD NOT IN ('09','17')  -- 여신신청완료구분코드,승인된건만
//----------------------------------------------------------------------------------
AND         A.NFFC_UNN_DSCD     = '1'                   --중앙회조합구분코드
AND         B.CSLT_DT     BETWEEN '20150101' AND '20170630'
GROUP BY    신청년도
           ,담보구분
           ,신규연장구분
ORDER BY    1,2,3
;
*CLN_APC_CMPL_DSCD(여신신청완료구분코드)
*09 부결
*10 승인
*18 승인후미취급
*20 약정
*21 실행
*17 철회

//}

//{  #연체계좌  #금감원연체   #연체가산금리  #가산금리 #규정

-- 연체리스트 (금감원연체대상 년말기준 연체계좌리스트)
SELECT      A.STD_DT                     AS  기준일자
           ,A.CUST_NO                    AS  고객번호
           ,A.INTG_ACNO                  AS  통합계좌번호
           ,A.CLN_EXE_NO                 AS  여신실행번호    -- 추가
           ,A.MRT_CD                     AS  담보코드
           ,A.AGR_DT                     AS  약정일자
           ,AA.AGR_EXPI_DT               AS  약정만기일
           ,C.ACSB_NM5                   AS  자금구분
           ,A.LN_RMD                     AS  잔액
           ,A.OVD_OCC_DT                 AS  연체발생일자
           ,A.OVD_DCNT                   AS  연체일수
           ,A.FSS_OVD_ST_DT              AS  금감원연체시작일

INTO        #원화대출금_연체   -- DROP TABLE #원화대출금_연체

FROM        OT_DWA_INTG_CLN_BC   A

JOIN        DWZOWN.TT_SOR_LOA_MM_ACN_BC    AA            --SOR_LOA_월계좌기본
            ON     LEFT(A.STD_DT,6)  = AA.STD_YM
            AND    A.INTG_ACNO       = AA.CLN_ACNO

JOIN        (
              SELECT   STD_DT
                      ,ACSB_CD
                      ,ACSB_NM
                      ,ACSB_CD4  --원화대출금
                      ,ACSB_NM4
                      ,ACSB_CD5  --기업자금대출금(14002401), 가계자금대출금(14002501), 공공및기타(14002601)
                      ,ACSB_NM5
                      ,ACSB_CD6  --기업운전자금대출금(15002001), 기업시설자금대출금(15002101)
                      ,ACSB_NM6
              FROM     OT_DWA_DD_ACSB_TR
              WHERE    1=1
              AND      FSC_SNCD      IN ('K','C')
              AND      ACSB_CD4 IN ('13000801')       --원화대출금
            )          C
            ON    A.BS_ACSB_CD  =  C.ACSB_CD
            AND   A.STD_DT      =  C.STD_DT

LEFT OUTER JOIN
            DWZOWN.OT_DWA_ENTP_SCL_BC   D   --DWA_기업규모기본
            ON     A.RNNO      = D.RNNO
            AND    A.STD_DT    = D.STD_DT

WHERE       1=1
AND         A.STD_DT        IN ('20131231','20141231','20151231','20161231','20170630')
AND         A.BR_DSCD       = '1'   --중앙회
AND         A.CLN_ACN_STCD  = '1'           --여신계좌상태코드:1 정상
//=====================================================================================
AND         A.FSS_OVD_ST_DT IS NOT NULL AND  A.FSS_OVD_ST_DT > '19000000'   -- 금감원연체기준
//=====================================================================================
;

/*
제44조(연체이자율의 적용) ① 연체이자율은 연체대출금, 지급보증 대지급금 등에 대해서 적용한다.

② 연체이자율은 해당 여신에 대한 최종이자수입일에 적용한 여신금리에 다음의 연체기간별 가산금리를 더하여 적용한다.

1. 연체기간별 가산금리

가. 연체일수 1개월 이하 : 연 6.0%

나. 연체일수 1개월 초과 3개월 이하 : 연 7.0%

다. 연체일수 3개월 초과 : 연 8.0%

 2. 연체기간별 가산금리 운용

 가. 연체기간별 가산금리는 연체발생일로부터 연체이자 수입일까지 제1호에 따라 연체일수 구간별로 구분하여 적용한다.

나. 연체대출금에 대해서 연체이자를 부분 납입한 경우에는 정리일수 기준으로 납입기일이 변경 적용

③ 제2항에 불구하고 연체이자율은 제33조(여신금리의 약정)제3항의 최고금리를 초과할 수 없다.

④ 제1항부터 제3항까지에 불구하고 예적금담보대출의 경우에는 연체이자율 적용을 배제하고 약정이율을 적용한다.
*/


//}

//{  #올인원   #CSS  #등급
소매모형관련 여신 및 카드 DW 테이블 매핑 (201711월데이터 부터 들어간다., 201208 ~ 201710 까지는 ASIS 테이블 이용)

여신
PLI_올인원여신ASS신청기본(TB_PLI_AIO_ASS_APC_BC)  ->   CSS_소매여신ASS신청기본(TB_CSS_RM_ASS_RSLT_BC)
PLI_올인원여신ASS결과기본(TB_PLI_AIO_ASS_RSLT_BC)  ->  CSS_소매여신ASS모형결과기본(TB_CSS_RM_CLN_ASS_MR_BC)
PLI_올인원여신ASS결과기본(TB_PLI_AIO_ASS_RSLT_BC)  ->  CSS_소매여신ASS전략결과기본(TB_CSS_RM_CLN_ASS_SR_BC)
PLI_올인원여신ASS평점내역(TB_PLI_AIO_ASS_ASSC_TR)  ->  CSS_소매여신ASS평점내역(TB_CSS_RM_ASS_ASSC_TR)
PLI_올인원여신ASS필터링내역(TB_PLI_AIO_ASS_FLTR_TR)  ->   CSS_소매여신ASS필터링내역(TB_CSS_RM_ASS_FLTR_TR)
CSS_올인원BSS결과기본(TB_CSS_AIO_BSS_RSLT_BC) ->  CSS_소매모형BSS결과기본(TB_CSS_RM_BSS_RSLT_BC)
CSS_올인원BSS결과기본(TB_CSS_AIO_BSS_RSLT_BC) ->  CSS_소매모형BSS결과기본(TB_CSS_RM_BSS_RSLT_BC)
CSS_올인원BSS평점상세(TB_CSS_AIO_BSS_ASSC_DL)  ->  CSS_소매모형BSS평점내역(TB_CSS_RM_BSS_ASSC_TR)

카드
CLT_올인원카드ASS신청기본(TB_CLT_AIO_ASS_APC_BC)  ->  CLT_소매모형카드ASS신청기본(TB_CLT_RM_ASS_APC_BC)
CLT_올인원카드ASS결과기본(TB_CLT_AIO_ASS_RSLT_BC) ->  CLT_소매모형카드ASS모형결과기본(TB_CLT_RM_ASS_RSLT_BC)
CLT_올인원카드ASS결과기본(TB_CLT_AIO_ASS_RSLT_BC)  ->  CLT_소매모형카드ASS전략결과기본(TB_CLT_RM_ASS_STGY_BC)
CSM_올인원BSS결과기본(TB_CSM_AIO_BSS_RSLT_BC)  ->  CLT_소매모형BSS결과기본(TB_CLT_RM_BSS_RSLT_BC)

//}


//{   #채무인수

SELECT      A.CLN_ACNO       AS  계좌번호
           ,MAX(A.ENR_DT)    AS  등록일자

INTO        #채무인수  -- DROP TABLE #채무인수

FROM        TB_SOR_LOA_AGR_HT   A  -- SOR_LOA_약정이력

WHERE       1=1
AND         A.CLN_APC_DSCD  = '51'  --  여신신청구분코드(51: 채무인수)
AND         A.CLN_ACNO  IN ( SELECT 여신계좌번호 FROM #TEMP )
GROUP BY    A.CLN_ACNO
;

//}

//{ 연체횟수

SELECT      CLN_ACNO                   AS 계좌번호
           ,COUNT(DISTINCT OVD_OCC_DT) AS 연체횟수

INTO        #연체   -- DROP TABLE #연체
FROM        OT_DWA_LOA_OVD_TR   A  -- DWA_여신연체내역

WHERE       1=1
AND         A.CLN_ACNO  IN ( SELECT 여신계좌번호 FROM #TEMP )
GROUP BY    A.CLN_ACNO
;
-- SELECT COUNT(*) FROM #연체  -- 86

//}

//{   #IFRS  #충당금

LEFT OUTER JOIN
            (
             SELECT    A.통합계좌번호
                      ,A.계정과목코드
                      ,SUM(A.대출채권충당금)  AS 대출채권충당금
                      ,SUM(A.미수이자충당금)  AS 미수이자충당금
                      ,SUM(A.가지급금충당금)  AS 가지급금충당금
             FROM      DIM_IFRS계좌별충당금   A
             WHERE     1=1
             AND       A.기준일자  = '20161231'
             AND       A.통합계좌번호  IN ( SELECT DISTINCT 계좌번호 FROM #대상계좌 )
             GROUP BY  A.통합계좌번호,A.계정과목코드
            )     C
            ON     A.계좌번호      = C.통합계좌번호
            AND    A.계정과목코드  = C.계정과목코드

//}

//{  #평가정보  #제무정보  #최종평가 #최후평가 #최근평가

SELECT      A.RNNO
           ,A.SMPR_RNNO
           ,A.CMPL_DT
           ,A.CRDT_EVL_NO
INTO        #고객별최후평가  -- DROP TABLE #고객별최후평가
FROM        (
             SELECT   A.*
                     ,ROW_NUMBER() OVER(PARTITION BY A.SMPR_RNNO ORDER BY CMPL_DT DESC,CRDT_EVL_NO DESC) AS 순서1
                     ,ROW_NUMBER() OVER(PARTITION BY A.RNNO ORDER BY CMPL_DT DESC,CRDT_EVL_NO DESC) AS 순서2
                            -- 여신쪽로직을 참조하면 순서1만 있으면 되지만 계좌원장과 죠인할때는 RNNO칼럼을 쓰는데
                            -- 중복되는 경우가 있어 하나를 선택하기 위하여 순서2를 새로 만들어 넣음
             FROM     TB_SOR_CCR_EVL_INF_BC A /* CCR_평가정보기본 */
             WHERE    1=1
             AND      CRDT_EVL_PGRS_STCD = '2'
             AND      NFFC_UNN_DSCD = '1'
             AND      CRDT_EVL_MODL_DSCD != '34'
             AND      BRNO <>'0288'
             --AND  RNNO ='2048634391'
            )  A
WHERE       1=1
AND         A.순서1 = 1
AND         A.순서2 = 1
;

SELECT      *
INTO        #결산일별일련번호  -- DROP TABLE #결산일별일련번호
FROM
            (
             SELECT A.RNNO
                   ,A.CRDT_EVL_NO
                   ,A.SOA_DT
                   ,A.HIS_SNO
                   ,ROW_NUMBER() OVER(PARTITION BY A.RNNO,A.CRDT_EVL_NO,A.SOA_DT ORDER BY A.HIS_SNO DESC) AS 순서
             FROM   TB_SOR_CCR_EVL_FNFR_CTL_TR A  -- SOR_CCR_평가재무목록내역
             JOIN   (
                      SELECT   RNNO
                              ,CRDT_EVL_NO
                              ,MAX(SOA_DT) AS MAX_SOA_DT
                      FROM     TB_SOR_CCR_EVL_FNFR_CTL_TR -- SOR_CCR_평가재무목록내역
                      WHERE    LEFT(SOA_DT,4) IN ('2014','2015','2016','2017')
                      GROUP BY RNNO, CRDT_EVL_NO,LEFT(SOA_DT,4)
                    )   B
                    ON      A.RNNO         =  B.RNNO
                    AND     A.CRDT_EVL_NO  =  B.CRDT_EVL_NO
                    AND     A.SOA_DT       =  B.MAX_SOA_DT
            )  A
WHERE  순서  = 1
;

-- 평가정보에 FSC_SNCD ='K' 인경우에만 해당테이블 쓰고 FSC_SNCD ='I' 인 경우는 IFRS테이블을 쓰야하나
-- 현재 DW에 테이블이 없는것이 있어서 불가능함
SELECT      A.RNNO
           ,A.SMPR_RNNO
           ,A.CMPL_DT
           ,A.CRDT_EVL_NO
           ,A1.SOA_DT
           ,MAX(CASE WHEN B.FNST_REPT_CD =  '11' AND B.FNST_HDCD = '5000'  THEN FNST_AMT  ELSE NULL END) AS 총자산
           ,MAX(CASE WHEN B.FNST_REPT_CD =  '12' AND B.FNST_HDCD = '1000'  THEN FNST_AMT  ELSE NULL END) AS 매출액
           ,MAX(CASE WHEN B.FNST_REPT_CD =  '12' AND B.FNST_HDCD = '5000'  THEN FNST_AMT  ELSE NULL END) AS 영업이익
           ,MAX(CASE WHEN B.FNST_REPT_CD =  '12' AND B.FNST_HDCD = '9000'  THEN FNST_AMT  ELSE NULL END) AS 당기순이익

FROM        #고객별최후평가   A

JOIN        #결산일별일련번호  A1
            ON  A.RNNO           = A1.RNNO
            AND A.CRDT_EVL_NO    = A1.CRDT_EVL_NO

LEFT OUTER JOIN
            TB_SOR_CCR_FNST_HT  B  --  SOR_CCR_재무제표이력
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
           ,MAX(CASE WHEN B.FNST_REPT_CD =  '19' AND B.FNST_HDCD = '4060'  THEN CALC_FNST_RT  ELSE NULL END) AS 부채비율

FROM        #고객별최후평가   A

JOIN        #결산일별일련번호  A1
            ON  A.RNNO           = A1.RNNO
            AND A.CRDT_EVL_NO    = A1.CRDT_EVL_NO
LEFT OUTER JOIN
            TB_SOR_CCR_FNFR_RT_HT  B -- SOR_CCR_재무비율이력
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

//{ #복지포인트
-- 전일자 기분 복지포인트
SELECT CUST_NO      AS 고객번호
      ,PNT_TPCD     AS 포인트유형코드
      ,TOT_CMTT_PNT AS 총발생포인트
      ,TOT_US_PNT   AS 총사용포인트
      ,TOT_EXT_PNT  AS 총소멸포인트
      ,TOT_RMN_PNT  AS 총잔여포인트
FROM   TB_SOR_PNT_PNT_TZ
WHERE  CUST_NO = 101093721
  AND  PNT_TPCD = 'SW0001'
//}

//{  #파일추출 #TEMPORARY
--6
SET TEMPORARY OPTION Temp_Extract_Name1 = '/nasdat/edw/out/etc/DWZOWN_TB_SOR_CCR_FNFR_RT_TR.dat';
SET TEMPORARY OPTION Temp_Extract_Column_Delimiter = '|';
SET TEMPORARY OPTION Temp_Extract_NULL_As_Zero = 'ON';
SET TEMPORARY OPTION Temp_Extract_NULL_As_Empty = 'ON';
SELECT
			 RNNO	실명번호
			,FNST_SOA_DSCD	재무제표결산구분코드
			,SOA_DT	결산일자
			,FNST_REPT_CD	재무제표보고서코드
			,FNST_HDCD	재무제표항목코드
			,CALC_FNST_RT	산출재무제표비율
			,ACTL_FNST_RT	실제재무제표비율
FROM   TB_SOR_CCR_FNFR_RT_TR    -- SOR_CCR_재무비율내역
WHERE  LEFT(SOA_DT,4) IN  ('2010','2011','2012','2013','2014')
;
SET TEMPORARY OPTION Temp_Extract_Name1 = '';


//}

//{  #B2401  #여검자금범위 

SELECT      '개인'        AS 개인기업구분
           ,A.통합계좌번호   AS 계좌번호
           ,SUM(A.지급보증약정배분금액  + A.대출잔액배분금액)  AS 금액
INTO        #TEMP_신용카드  -- DROP TABLE #TEMP_신용카드
FROM        TB_DWF_LAQ_건전성계좌월별상세  A
WHERE       A.기준일자       = V_전분기말일자
AND         A.점구분코드      = '1'
AND         A.BS계정과목코드  IN (SELECT   ACSB_CD
                              FROM     OT_DWA_DD_ACSB_TR
                              WHERE    STD_DT = V_전분기말일자
                              AND      FSC_SNCD IN ('K','C')
                              AND      ACSB_CD4 = '13001701')
AND         A.장표종류코드 <> '6'
GROUP BY    A.통합계좌번호

UNION ALL

SELECT      CASE WHEN B.PREN_DSCD = '1'     THEN '개인'
                 ELSE '기업'
               END   AS 개인기업구분
           ,A.통합계좌번호
           ,SUM(A.지급보증약정배분금액  + A.대출잔액배분금액) AS 금액
FROM        TB_DWF_LAQ_건전성계좌월별상세  A
           ,TB_SOR_CLT_CRD_BC  B --  SOR_CLT_카드기본
WHERE       A.기준일자       = V_전분기말일자
AND         A.점구분코드      = '1'
AND         A.BS계정과목코드  IN (SELECT   ACSB_CD
                              FROM     OT_DWA_DD_ACSB_TR
                              WHERE    STD_DT = V_전분기말일자
                              AND      FSC_SNCD IN ('K','C')
                              AND      ACSB_CD4 = '13001701')
AND         A.장표종류코드 = '6'
AND         A.통합계좌번호 *= B.CRD_NO
--AND         B.PREN_DSCD = '1'
GROUP BY    개인기업구분
           ,A.통합계좌번호
;

    
-- 건전성테이블와 통합여신을 이용하여 모집단 테이블을 생성
-- 이 임시테이블은 계좌번호,계정코드,건전성분류코드 가 주키역활
SELECT      A.기준일자                AS  STD_DT
           ,A.고객번호                AS  CUST_NO   --여신성가지금의 경우 지점실명을 넣어준다
           ,C.CUST_RNNO               AS  RNNO
           ,C.CUST_NM                 AS  CUST_NM
           ,A.장표종류코드            AS  FRPP_KDCD
           ,A.통합계좌번호            AS  INTG_ACNO
           ,A.점번호                  AS  BRNO
           ,ISNULL(A.개별한도대출구분코드, '2')    AS INDV_LMT_LN_DSCD   --운용구분          --1:건별거래대출, 2:한도거래대출
           //-----------------------------------------------------------------
           ,MAX(A.약정일자)           AS  AGR_DT
           //-----------------------------------------------------------------
           ,MAX(ROUND(ISNULL(A.승인금액,0) * 0.000001,0))  AS AGR_AMT      --약정금액
           ,MAX(ROUND(ISNULL(A.승인금액,0) * 0.000001,0))  AS APRV_AMT     --약정금액
           ,SUM(ROUND(( A.지급보증약정배분금액 + A.대출잔액배분금액) * 0.000001,0))   AS LN_RMD       --대출잔액
           ,SUM(A.지급보증약정배분금액  + A.대출잔액배분금액)                         AS LN_RMD_WON   --대출잔액_원단위잔액
           ,SUM(ROUND((A.지급보증충당금 + A.대출채권충당금) * 0.000001,0))            AS APMN_NDS_RSVG_AMT   --충당금요구적립금액
           ,A.계좌건전성등급코드       AS  ACN_SDNS_GDCD                                    --계좌건전성등급코드
           //--------------------------------------------------
           ,A.고객건전성등급코드       AS  CUST_SDNS_GDCD
           //--------------------------------------------------
           ,A.기업신용평가등급         AS  ENTP_CREV_GD
           ,A.BS계정과목코드           AS  BS_ACSB_CD
           ,A.외환업무구분코드         AS  FRXC_TSK_DSCD
           ,CASE WHEN A.장표종류코드  = '7'  AND  A.외환업무구분코드  IN ('12',             --외화수표
                                                                   '21','22','23',   --수입
                                                                   '11',             --수출
                                                                   '41','42')  THEN  'Y'
                 ELSE 'N'
            END                  AS 외환여부

INTO        #TEMP0    -- DROP TABLE #TEMP0

FROM        TB_DWF_LAQ_건전성계좌월별상세 A
           ,OM_DWA_INTG_CUST_BC       C
WHERE       A.기준일자       = V_전분기말일자
AND         A.점구분코드     = '1'

AND         ( A.장표종류코드  IN ('1','2','4')  OR
              (A.장표종류코드  = '7'  AND  A.여신업무구분코드  IN ('14','42') ) OR  -- 외화대출, 무역금융
              (A.장표종류코드  = '8' AND A.BS계정과목코드  IN ('15011411','15011811','15011811','15013411','13000511')) OR
                                       -- 과거 소스에 따라 대상계정을 넣어둠 실제로는 데이터 존재하지 않음
                                       -- 15011811(기타가지급금),15011411(수입제세가지급금),13000511(원화출자전환채권),15013411(기타미수금)
                                       -- 201712까지의 건전성데이터에는 15011811(기타가지급금),15013411(기타미수금),13000511(원화출자전환채권) 계정내역이 존재했으나
                                       -- 이후데이터(IFRS데이터)에서는 해당 데이터 없음

              (A.장표종류코드  = '7'  AND  A.외환업무구분코드  IN ('12',             --외화수표
                                                                   '21','22','23',   --수입
                                                                   '11',             --수출
                                                                   '41','42'))  OR    --내국매입
              //----------------------------------------------------------------------------------------------------
              -- ,3,4,5,A 모집단에는 카드 포함안되어 있음
              (A.통합계좌번호  IN (SELECT  계좌번호 FROM  #TEMP_신용카드 WHERE 개인기업구분 = '기업' ))
              --(A.통합계좌번호  IN (SELECT  계좌번호 FROM  #TEMP_신용카드))  -- bs와 대사할땐
              //----------------------------------------------------------------------------------------------------
            )
AND         A.BS계정과목코드  NOT IN (SELECT  RLT_ACSB_CD                   -- 가계자금대출은 제외
                                      FROM    DWZOWN.OT_DWA_DD_ACSB_BC
                                      WHERE   STD_DT        = V_전분기말일자
                                      AND     ACSB_CD       = '14002501'
                                      AND     ACSB_HRC_INF <> RLT_ACSB_HRC_INF
                                      AND     ACCT_STCD     = '1'
                                      AND     RLT_ACCT_STCD = '1')
AND         A.BS계정과목코드  NOT IN ('14000611','96003611','10690011','15009011','15009111','0')
AND         RIGHT(TRIM(A.BS계정과목코드), 1) <> '6'
AND         A.통합계좌번호  NOT IN (SELECT   INTG_ACNO
                                    FROM     OT_DWA_INTG_CLN_BC
                                    WHERE    STD_DT = V_전분기말일자
                                    AND      RIGHT(BS_ACSB_CD, 1) = '9'
                                    AND      BR_DSCD = '1'
                                    AND      FRPP_KDCD  IN ('1','2','4')
                                    AND      LN_USCD  IN ('31','32'))
AND         A.BS계정과목코드  NOT IN (SELECT  RLT_ACSB_CD
                                      FROM    DWZOWN.OT_DWA_DD_ACSB_BC
                                      WHERE   STD_DT        = V_전분기말일자
                                      AND     LEFT(RLT_ACSB_CD, 1) = '9'
                                      AND     RLT_ACSB_CD  NOT IN (SELECT  RLT_ACSB_CD
                                                                   FROM    DWZOWN.OT_DWA_DD_ACSB_BC
                                                                   WHERE   STD_DT  = V_전분기말일자
                                                                   AND     ACSB_CD = '93000101'
                                                                   AND     ACCT_STCD     = '1'
                                                                   )
                                      AND     ACSB_HRC_INF  <> RLT_ACSB_HRC_INF
                                      AND     ACCT_STCD     = '1'
                                      AND     RLT_ACCT_STCD = '1')
AND         A.고객번호     =  C.CUST_NO
GROUP BY    A.기준일자
           ,A.고객번호
           ,C.CUST_RNNO
           ,C.CUST_NM
           ,A.장표종류코드
           ,A.통합계좌번호
           ,A.점번호
           ,INDV_LMT_LN_DSCD
           ,A.계좌건전성등급코드
           ,A.고객건전성등급코드
           ,A.기업신용평가등급
           ,A.BS계정과목코드
           ,A.외환업무구분코드
           ,외환여부

UNION ALL

SELECT      AA.STD_DT                                        AS STD_DT
           ,CASE WHEN AA.CUST_NO = 0  THEN C.CUST_NO ELSE AA.CUST_NO END  AS CUST_NO
           ,CASE WHEN AA.RNNO IS NULL THEN C.BRN     ELSE AA.RNNO    END  AS RNNO
           ,CASE WHEN AA.CUST_NO = 0  THEN '여신성가지급금' ELSE AA.CUST_NM END  AS  CUST_NM
           ,AA.FRPP_KDCD                                     AS FRPP_KDCD
           ,AA.INTG_ACNO                                     AS INTG_ACNO
           ,AA.BRNO                                          AS BRNO
           ,ISNULL(AA.INDV_LMT_LN_DSCD, '2')                 AS INDV_LMT_LN_DSCD   --운용구분          --1:건별거래대출, 2:한도거래대출
           //-----------------------------------------------------------------
           ,MAX(A.약정일자)                                  AS AGR_DT
           //-----------------------------------------------------------------
           ,0                                                AS AGR_AMT     --약정금액
           ,0                                                AS APRV_AMT    --약정금액
           ,SUM(ROUND(A.가지급금배분금액 * 0.000001,0))      AS LN_RMD
           ,SUM(A.가지급금배분금액)                          AS LN_RMD_WON
           ,SUM(ROUND(A.가지급금충당금 * 0.000001,0))        AS APMN_NDS_RSVG_AMT   --충당금요구적립금액
           ,A.계좌건전성등급코드                             AS ACN_SDNS_GDCD
           //--------------------------------------------------
           ,A.고객건전성등급코드                             AS  CUST_SDNS_GDCD
           //--------------------------------------------------
           ,AA.ENTP_CREV_GD                                  AS ENTP_CREV_GD
           ,AA.BS_ACSB_CD                                    AS BS_ACSB_CD
           ,AA.FRXC_TSK_DSCD                                 AS FRXC_TSK_DSCD
           ,'N'                                              AS 외환여부

FROM        TB_DWF_LAQ_건전성계좌월별상세   A
JOIN        (
             SELECT      A.STD_DT                 AS  STD_DT
                        ,A.CUST_NO                AS  CUST_NO
                        ,C.CUST_RNNO              AS  RNNO
                        ,C.CUST_NM                AS  CUST_NM
                        ,A.INTG_ACNO              AS  INTG_ACNO
                        ,A.INDV_LMT_LN_DSCD       AS  INDV_LMT_LN_DSCD
                        ,A.FRXC_TSK_DSCD          AS  FRXC_TSK_DSCD
                        ,A.ENTP_CREV_GD           AS  ENTP_CREV_GD
--                        ,MAX(ROUND(A.AGR_AMT * B.DLN_STD_EXRT * 0.000001,0))       AS AGR_AMT     --승인금액
                        ,SUM(ROUND(A.LN_EXE_AMT * B.DLN_STD_EXRT * 0.000001,0))    AS AGR_AMT     --승인금액
                        -- 약정금액은 잔액보다 작은것도 있고 이상해서 대출실행금액으로 약정금액을 대신한다.
                        ,SUM(ROUND(A.LN_EXE_AMT * B.DLN_STD_EXRT * 0.000001,0))    AS LN_EXE_AMT   --대출실행금액
                        ,SUM(ROUND(A.LN_RMD * 0.000001,0))       AS LN_RMD       --대출잔액
                        ,SUM(A.LN_RMD)                           AS LN_RMD_WON   --대출잔액_원단위잔액
                        ,A.FRPP_KDCD           AS  FRPP_KDCD
                        ,A.BRNO                AS  BRNO
                        ,A.BS_ACSB_CD          AS  BS_ACSB_CD

             FROM        OT_DWA_INTG_CLN_BC        A
                        ,OT_DWA_EXRT_BC            B
                        ,OM_DWA_INTG_CUST_BC       C
             WHERE       A.STD_DT          = V_전분기말일자
             AND         A.BR_DSCD         = '1'
             AND         A.CLN_ACN_STCD    = '1'    -- 상태코드 정상
             AND         A.BS_ACSB_CD     IN ('15011011','15011211')  -- 15011211 여신성가지급금, 15011011 신용카드가지급금
             AND         A.CRCD             = B.CRCD
             AND         B.STD_DT           = V_전분기말일자
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
            ON   CASE WHEN A.BS계정과목코드 IN ('15011011','15011211') THEN A.통합계좌번호 ELSE A.연결여신금융기관계좌번호 END  =   AA.INTG_ACNO

LEFT OUTER JOIN
            OM_DWA_INTG_CUST_BC       B
            ON   AA.CUST_NO         = B.CUST_NO

LEFT OUTER JOIN
            (SELECT   A.BRNO
                     ,A.BR_NM
                     ,A.BRN
                     ,B.CUST_NO
                     ,B.CUST_NM
             FROM     OT_DWA_DD_BR_BC   A  --DWA_일점기본
                     ,TB_SOR_CUS_MAS_BC B  --SOR_CUS_고객기본
             WHERE    A.STD_DT = V_전분기말일자
             AND      A.BRNO <> 'XXXX'
             AND      A.BRN  *= B.CUST_RNNO
            ) C
            ON   AA.BRNO            = C.BRNO

WHERE       A.기준일자       = V_전분기말일자
AND         A.점구분코드     = '1'
//------------------------------------------ 가지금금
AND         A.가지급금배분금액 > 0
//----------------------------------------------------
GROUP BY    AA.STD_DT
           ,CUST_NO
           ,RNNO
           ,CUST_NM
           ,AA.FRPP_KDCD
           ,AA.INTG_ACNO
           ,AA.BRNO
           ,ISNULL(AA.INDV_LMT_LN_DSCD, '2')
           ,A.계좌건전성등급코드
           ,A.고객건전성등급코드
           ,AA.ENTP_CREV_GD
           ,AA.BS_ACSB_CD
           ,AA.FRXC_TSK_DSCD

//-------기타가지급금(15011811), 기타미수금(15013411)
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
           ,0                        AS  AGR_AMT     --승인금액
           ,0                        AS  APRV_AMT     --승인금액
           ,SUM(ROUND(A.LN_RMD * 0.000001,0))       AS LN_RMD       --대출잔액
           ,SUM(A.LN_RMD)                           AS LN_RMD_WON   --대출잔액_원단위잔액
           ,0                        AS APMN_NDS_RSVG_AMT   --충당금요구적립금액
           ,'1'                      AS ACN_SDNS_GDCD   --충당금요구적립금액                        
           ,'1'                      AS CUST_SDNS_GDCD
           ,'0'                      AS ENTP_CREV_GD
           ,A.BS_ACSB_CD             AS BS_ACSB_CD
           ,A.FRXC_TSK_DSCD          AS  FRXC_TSK_DSCD
           ,'N'                      AS  외환여부

FROM        OT_DWA_INTG_CLN_BC        A
           ,OT_DWA_EXRT_BC            B
           ,OM_DWA_INTG_CUST_BC       C
WHERE       A.STD_DT          = V_전분기말일자
AND         A.BR_DSCD         = '1'
AND         A.CLN_ACN_STCD    = '1'    -- 상태코드 정상
AND         A.BS_ACSB_CD     IN ('15011811','15013411')  -- 기타가지급금(15011811), 기타미수금(15013411)
AND         A.CRCD             = B.CRCD
AND         B.STD_DT           = V_전분기말일자
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



SELECT      CASE  WHEN ACSB_CD5 IN ('14002401')  THEN  '1. F1'     -- 기업자금대출금
                  WHEN ACSB_CD4 IN ('13001108','13001308','13001408')  THEN  '1. F1'  -- 외화대출금
                  WHEN ACSB_CD4 IN ('13001601')  THEN  '1. F1'  -- 지급보증대지급금
                  WHEN ACSB_CD4 IN ('13001508','13001001') THEN '1. F1'  -- 매입외환
                  WHEN ACSB_CD4 IN ('13001901') THEN  '1. F1'  -- 사모사채
                  WHEN ACSB_CD2 IN ('93000101') THEN  '1. F1'  -- 확정지급보증
                  WHEN ACSB_CD4 IN ('13001701') THEN  '1. F1'  -- 신용카드채권(기업)
                  WHEN ACSB_CD5 IN ('14002601')  THEN  '2. F3'  -- 공공및기타자금대출금
                  WHEN ACSB_CD6 IN ('15011011','15011211')  THEN  '2. F3'  -- 기타채권
                  WHEN ACSB_CD  IN ('15011811','15013411')  THEN  '3. G'  -- 기타여신성채권
                  WHEN ACSB_CD  IN ('15011811','15013411')  THEN  '3. G'  -- 기타여신성채권
            END   AS  검정구분      
           ,CASE  WHEN ACSB_CD5 IN ('14002401')  THEN  '1.기업자금대출금'
                  WHEN ACSB_CD5 IN ('14002601')  THEN  '2.공공및기타자금대출금'
                  WHEN ACSB_CD4 IN ('13001108','13001308','13001408')  THEN '3.외화대출금(내국수입유산스,역외외화대출금포함)'
                  WHEN ACSB_CD4 IN ('13001601') THEN '4.지급보증대지급금'
                  WHEN ACSB_CD4 IN ('13001508','13001001') THEN '5.매입외환(매입어음계정포함)'
                  WHEN ACSB_CD4 IN ('13001701') THEN '6.신용카드채권(기업)'
                  WHEN ACSB_CD4 IN ('13001901') THEN '7.사모사채'
                  WHEN ACSB_CD2 IN ('93000101') THEN '8.확정지급보증'
                  WHEN ACSB_CD4 IN ('13001701') THEN  '1. F1'  -- 신용카드채권(기업)
                  WHEN ACSB_CD6 IN ('15011011','15011211')   THEN '8.기타채권'
                  WHEN ACSB_CD  IN ('15011811','15013411')   THEN '9.기타여신성채권(미수및가지급금)'
            END   AS  계정구분
           ,SUM(LN_RMD_WON)  AS 여신잔액
FROM        #TEMP0   A
JOIN        (
                   SELECT   STD_DT
                           ,ACSB_CD
                           ,ACSB_NM
                           ,ACSB_CD2
                           ,ACSB_NM2
                           ,ACSB_CD4  --원화대출금
                           ,ACSB_NM4
                           ,ACSB_CD5  --기업자금대출금, 가계자금대출금, 공공및기타
                           ,ACSB_NM5
                           ,ACSB_CD6  --기업자금대출금, 가계자금대출금, 공공및기타
                           ,ACSB_NM6
                   FROM     OT_DWA_DD_ACSB_TR
                   WHERE    FSC_SNCD IN ('K','C')
                   AND      (
                              ACSB_CD5 IN ('14002401') OR    --기업자금대출금
                              ACSB_CD5 IN ('14002601') OR    --공공및기타대출금
                              ACSB_CD4 IN ('13001108','13001308','13001408') OR    --외화대출금,내국수입유산스,역외외화대출금
                              ACSB_CD4 IN ('13001601') OR    --지급보증대지급금
                              ACSB_CD4 IN ('13001701') OR    --신용카드채권
                              ACSB_CD4 IN ('13001508','13001001') OR    --매입외환,매입어음계정
                              ACSB_CD4 IN ('13001901') OR    --사모사채
                              ACSB_CD2 IN ('93000101') OR   --확정지급보증
                              ACSB_CD6 IN ('15011011','15011211') OR     --신용카드가지급금(15011011),여신성가지급금(15011211)
                              ACSB_CD  IN ('15011811','15013411')      --기타미수금(15013411), 기타가지급금(15011811)
                            )
                   AND      STD_DT = '20180331'
            )           C
            ON       A.BS_ACSB_CD   =   C.ACSB_CD                   -- BS계정과목코드
GROUP BY    검정구분,계정구분

UNION ALL

SELECT      '3. G'  AS 검정구분
            ,'9.기타여신성채권(콜론등)'  AS 계정구분
           ,SUM(A.TD_RMD)   AS 여신잔액
FROM        OT_DWA_DD_GLM_FLST_BC  A      --DWA_일총계정기본
           ,OT_DWA_DD_BR_BC        B      --DWA_일점기본
WHERE       A.FSC_DT   = '20180331'
AND         A.ACSB_CD  IN ( '13000901'      --콜론
                           ,'14003801'      --RP
                           ,'14000711')     --은행간대여금
AND         A.FSC_DSCD = '1'              --회계구분코드(1:신용)
AND         A.JONT_CD  = '11'             --합동코드(11:신용사업)
AND         A.FSC_SNCD IN ('K','C')       --회계기준코드(K:GAAP, C:공통)
AND         A.BRNO     = B.BRNO
AND         A.FSC_DT   = B.STD_DT
AND         B.STD_DT   = '20180331'
AND         B.BR_DSCD  = '1'               --중앙회
AND         B.FSC_DSCD = '1'              --신용
AND         B.BR_KDCD  < '40'              --10:본부부서, 20:영업점, 30:관리점

UNION ALL
SELECT     '4. I'    AS  검정구분
           ,'B. 기타건전성분류자산'  AS 계정구분
           ,8795859000000 + 57889000000 + 2698000000 + 2768000000 + 000000  AS 여신잔액

ORDER BY 1,2
;
//}


//{  #개인사업자 #NICE  #CB등급
-- 29189818 일짜현재 계정계 테이블 통내용...
CREATE TABLE #TEMP_CB등급 -- DROP TABLE #TEMP_CB등급
(
  여신신청대표번호   CHAR(14),
  NICE_CB등급        CHAR(4)
);

LOAD TABLE #TEMP_CB등급
(
여신신청대표번호    ',',
NICE_CB등급         '\x0a'      
)
FROM '/nasdat/edw/temp/이한나/워크아웃대상.csv'
     
QUOTES OFF
ESCAPES OFF
--BLOCK FACTOR 3000
FORMAT ASCII;
commit;

//}


//{  #EXECUTE  #UPDATE

-- 잔액 UPDATE(현할차반영)
BEGIN
EXECUTE IMMEDIATE
'
UPDATE      #기업자금   A
SET         A.잔액 =  A.잔액 - ISNULL(O.현할차금액, 0)
FROM        (
              SELECT   A.기준일자
                      ,A.통합계좌번호
                      ,SUM(A.현재가치할인차금)    AS 현할차금액
              FROM     DWZOWN.TB_DWF_LAQ_건전성계좌월별상세 A 
              WHERE    A.기준일자  = ''20180630''
              AND      A.통합계좌번호  IN ( SELECT 통합계좌번호 FROM  #기업자금 )
              GROUP BY A.기준일자,A.통합계좌번호
            ) O
WHERE       A.통합계좌번호   =   O.통합계좌번호
AND         A.기준일자       =   O.기준일자
;
'
;
END;

//}

