/*
  프로그램명 : ins_TB_OPE_KRI_외환기획팀01
  타켓테이블 : TB_OPE_KRI_외환기획팀01
  KRI 지표명 : 외국환 장기 미달환 건수
  협      조 : 고찬식차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 외환기획팀-01 외국환 장기 미달환 건수
       A: 전월말 기준 당발 2개월 이상 미달건수
       B: 전월말 기준 타발 2개월 이상 미정리 건수
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

    DELETE OPEOWN.TB_OPE_KRI_외환기획팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_외환기획팀01

    SELECT   P_BASEDAY
            ,SUBSTR(RC.REF_NO,3,4) as "점번호"
            ,CM.BR_NM              as "점명"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN RC.REF_NO   END as "당발송금고유번호"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN RC.PCS_DT   END as "당발송금일자"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN RC.CRCD     END as "당발송금통화코드"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN RC.DFRY_AMT END as "당발송금액"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN TR.TLR_NO   END as "당발직원번호"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'OC' THEN TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(RC.PCS_DT,'YYYYMMDD') END as "당발경과일수"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN RC.REF_NO   END as "타발송금고유번호"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN RC.PCS_DT   END as "타발송금일자"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN RC.CRCD     END as "타발송금통화코드"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN RC.DFRY_AMT END as "타발송금액"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN TR.TLR_NO   END as "타발직원번호"
            ,CASE WHEN RC.FRNW_TSK_DSCD = 'IC' THEN TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(RC.PCS_DT,'YYYYMMDD') end as "타발경과일수"

    FROM     TB_SOR_FEC_RCNC_PNG_TR  RC     -- SOR_FEC_대사미달환내역

    LEFT OUTER JOIN
             TB_SOR_FEC_FRXC_TR_TR   TR     -- SOR_FEC_외환거래내역
             ON   RC.REF_NO = TR.REF_NO
             AND  TR.TR_SNO = 1

    JOIN     TB_SOR_CMI_BR_BC        CM     --  SOR_CMI_점기본
             ON   SUBSTR(RC.REF_NO,3,4)  =  CM.BRNO
             AND  CM.BR_DSCD = '1'         -- 1.중앙회, 2.조합
             
    AND      RC.PCS_DT <= TO_CHAR(ADD_MONTHS(TO_DATE(P_BASEDAY,'YYYYMMDD'),-2), 'YYYYMMDD')
    AND      RC.DFRY_AMT <>  0
    AND      RC.FRNW_TSK_DSCD in ('OC','IC')   -- 외신업무구분코드

    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_외환기획팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

