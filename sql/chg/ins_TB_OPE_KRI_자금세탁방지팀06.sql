/*
  프로그램명 : ins_TB_OPE_KRI_자금세탁방지팀06
  타켓테이블 : TB_OPE_KRI_자금세탁방지팀06
  KRI 지표명 : 지점의 고액자산가 고객건수
  협      조 : 최은영대리
  최조작성자 : 최상원
  KRI 지표명 :
     - 자금세탁방지팀-06 지점의 고액자산가 고객 건수(고위험)
       A: 전월 말 기준 고액자산가 고객 수 고위험 영업점/지점의 지표 총계
          기준월 말 기준 당행 등록 고액자산가 고객 수 고위험 영업점/지점들의 지표 총계 확인
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

    DELETE OPEOWN.TB_OPE_KRI_자금세탁방지팀06
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_자금세탁방지팀06
    SELECT   P_BASEDAY  AS 기준일자
            ,A.ENR_BRNO 
            ,D.BR_NM
            ,TRIM(CD_CTS) AS 고객번호
            
    FROM     TB_SOR_CUS_KYC_RSK_BC  A  -- SOR_CUS_KYC위험우선적용기본
    
    LEFT OUTER JOIN
             TB_SOR_CMI_BR_BC D    -- SOR_CMI_점기본
             ON   A.ENR_BRNO = D.BRNO
             AND  D.BR_DSCD  = '1'
                 
    WHERE    1=1
    AND      A.KYC_RSK_PFRD_APL_DSCD = '04' -- 고객알기제도위험우선적용구분코드
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_자금세탁방지팀06',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
