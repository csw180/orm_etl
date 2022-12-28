/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀18
  타켓테이블 : TB_OPE_KRI_여신지원팀18
  KRI 지표명 : 기업및 공공여신 대체 실행 건수
  협      조 : 최현정차장
  최초작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-18 : 기업및 공공여신 대체 실행 건수
       A: 전월 실행된 기업,공공여신중 해당기준일 거래내역에 신규중 대체로 이루어진 점별 여신실행건수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀18
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀18
    SELECT   P_BASEDAY                          AS 기준일자
            ,A.TR_BRNO                          AS   점번호
            ,J.BR_NM                            AS   점명
            ,A.CLN_ACNO                         AS   계좌번호
            ,A.CUST_NO                          AS   고객번호
            ,A.CUST_DSCD                        AS   고객구분코드
            ,A.PDCD                             AS   상품코드
            ,PD.PRD_KR_NM                       AS   상품명
            ,A.CRCD                             AS   통화코드
            ,A.APRV_AMT                         AS   여신승인금액
            ,A.CLN_EXE_NO                       AS   여신실행번호
            ,A.TR_PCPL                          AS   여신실행금액
            ,A.TR_DT                            AS   거래일자
            ,A.RCFM_DT                          AS   기산일
            ,DECODE(C.LKG_FCNO,NULL,'N','Y')    AS   연동입금여부
            ,C.LKG_FCNO                         AS   입금계좌번호
            ,A.TR_USR_NO                        AS   조작자직원번호
            ,A.CLN_TR_DTL_KDCD                  AS   여신거래상세종류코드
            ,A.TR_STCD                          AS   거래상태코드
    FROM     (
                SELECT
                         A.CLN_ACNO                    -- 여신계좌번호
                        ,A.APRV_AMT
                        ,A.CUST_NO
                        ,A.PDCD
                        ,A.CRCD
                        ,CASE WHEN A.LN_SBCD IN ('021','022','450','452') THEN '2'  --대출과목코드('021','022','450','452':공공여신)
                              ELSE  '1'                                             --그외 기업여신
                         END        CUST_DSCD
                        ,B.CLN_EXE_NO                  -- 여신실행번호
                        ,B.CLN_TR_NO                   -- 여신거래번호
                        ,B.CLN_TR_DTL_KDCD             -- 여신거래상세종류코드
                        ,B.TR_STCD                     -- 거래상태코드
                        ,B.TR_USR_NO                   -- 거래사용자번호
                        ,B.CHNL_TPCD                   -- 채널유형코드
                        ,B.TR_DT                       -- 거래일자
                        ,B.RCFM_DT                     -- 기산일자
                        ,B.TR_BRNO                     -- 거래점번호
                        ,B.TR_PCPL                     -- 거래원금
                FROM     TB_SOR_LOA_ACN_BC    A   -- SOR_LOA_계좌기본
                JOIN     TB_SOR_LOA_TR_TR     B   -- SOR_LOA_거래내역
                         ON     A.CLN_ACNO    =  B.CLN_ACNO
                         AND    B.TR_DT   BETWEEN  P_SOTM_DT AND   P_EOTM_DT
                         AND    B.CLN_TR_KDCD  IN  ('200','201')  -- 여신거래종류코드 200(대출실행), 201(대출실행취소)
                         AND    B.TR_STCD   =  '1'  -- 거래상태코드 1:'정상' ,2:'정정', 3:취소', 4:'원거래정정', 5:'원거래취소'
                WHERE    1=1
                AND      A.PREN_CLN_DSCD  IN ('2','3')  --  개인기업여신구분코드(2:기업여신,3:소기업여신)
                AND      A.NFFC_UNN_DSCD  =  '1'        --  중앙회조합구분코드(1:중앙회)
             )    A

    JOIN     TB_SOR_CMI_BR_BC     J
             ON   A.TR_BRNO      =   J.BRNO

    LEFT OUTER JOIN
             (
                  SELECT   A.CLN_ACNO                 -- 여신계좌번호
                          ,A.CLN_EXE_NO               -- 여신실행번호
                          ,A.CLN_TR_NO                -- 여신거래번호
                          ,A.LKG_FCNO                 -- 연동금융기관계좌번호
                          ,B.CUST_NO   AS  DEP_CUST_NO       -- 수신고객번호
                  FROM     TB_SOR_LOA_TR_BYCS_LKG_DL    A    --  SOR_LOA_거래건별연동상세
                  JOIN     TB_SOR_DEP_DPAC_BC           B    --  SOR_DEP_수신계좌기본
                           ON  (
                                  A.LKG_FCNO =  B.ACNO OR
                                  A.LKG_FCNO =  B.OD_ACNO OR
                                  A.LKG_FCNO =  B.CSMD_ACNO
                               )
                  WHERE    1=1
                  AND      A.CLN_LKG_TR_KDCD  IN  ('11','12')  --  여신연동거래종류코드(11:수신입금연동, 12:수신입금연동취소)
             )   C
             ON   A.CLN_ACNO     =  C.CLN_ACNO
             AND  A.CLN_EXE_NO   =  C.CLN_EXE_NO
             AND  A.CLN_TR_NO    =  C.CLN_TR_NO

    LEFT OUTER JOIN
             TB_SOR_PDF_PRD_BC    PD        --  SOR_PDF_상품기본
             ON     A.PDCD  =   PD.PDCD
             AND    PD.APL_STCD  =  '10'

    WHERE    1=1
    AND      (
               C.DEP_CUST_NO IS NULL   OR         -- 연동입금되지 않았거나
               A.CUST_NO  <>   C.DEP_CUST_NO      -- 차주계좌로 연동입금 되지 않은건(은행 모출납계정에서 이체된 경우등)
             )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀18',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT