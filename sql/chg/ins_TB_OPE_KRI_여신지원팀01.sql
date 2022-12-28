/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀01
  타켓테이블 : TB_OPE_KRI_여신지원팀01
  KRI 지표명 : 한도내 개별 여신 보유 차주 중 요주의 이하 차주 수
  협      조 : 김은주차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-01  한도내 개별 여신 보유 차주 중 요주의 이하 차주 수
       A: 한도내 개별여신 보유 차주 중 신용평가표상 신용등급이 ccc+이하이며,
          신용등급이 한도약정일 시점 대비 하락한 건수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀01
    SELECT   A.기준일자
            ,A1.대표점
            ,J.BR_NM
            ,A.통합계좌번호
            ,A.고객번호
            ,A.승인금액
            --,a.대출실행금액
            --,a.원장잔액
            ,sum(A.계좌잔액)  AS 잔액
            --,a.미사용한도금액
            ,A.약정일자
            --,a.승인일자
            ,A.기업신용평가등급
            ,A.평가유효일자
            --,max(A.계좌건전성등급코드)
    FROM     TB_DWF_LAQ_건전성계좌일별상세   A
    --FROM     TB_DWF_LAQ_건전성계좌월별상세   A

    JOIN     (   -- 계좌별로 여러종류의 건전성등급이 나올수 있어 최악의 등급을 계좌등급으로 본다.
                 -- 동일계좌번호가 디지털독도지점와 다른점에 동시에 출현하는경우 디지털독도지점 제외한 다른점을 대표점으로 한다.
              SELECT   A.통합계좌번호, MAX(A.계좌건전성등급코드 ) MAX_GD
                      ,NVL(MAX(CASE WHEN A.점번호  = '0865' THEN NULL ELSE A.점번호 END),'0865') AS 대표점
              FROM     TB_DWF_LAQ_건전성계좌일별상세  A
              --FROM     TB_DWF_LAQ_건전성계좌월별상세   A
              WHERE    1=1
              AND      A.기준일자  =  P_BASEDAY
              GROUP BY A.통합계좌번호
              HAVING   MAX(A.계좌건전성등급코드) >= '2'  -- 요주의이하
             )    A1
             ON   A.통합계좌번호  = A1.통합계좌번호

    JOIN     TB_SOR_CMI_BR_BC   J
             ON A1.대표점  = J.BRNO

    WHERE    1=1
    AND      A.기준일자  =  P_BASEDAY
    AND      A.개별한도대출구분코드  =  '2'  -- 한도

    GROUP BY A.기준일자
            ,A1.대표점
            ,J.BR_NM
            ,A.통합계좌번호
            ,A.고객번호
            ,A.승인금액
            ,A.약정일자
            ,A.기업신용평가등급
            ,A.평가유효일자
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
