/*
  프로그램명 : ins_TB_OPE_KRI_외환지원팀09
  타켓테이블 : TB_OPE_KRI_외환지원팀09
  KRI 지표명 : 미지급외환 미정리 건수(단기)
  협      조 : 고찬식차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 외환지원팀-09 미지급외환 미정리 건수(단기)
       A: 당월 말 미지급 외환 중 취결당일로 부터 7일 초과 건수
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

    DELETE OPEOWN.TB_OPE_KRI_외환지원팀09
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_외환지원팀09

    SELECT   P_BASEDAY
            ,SUBSTR(A.REF_NO,3,4)
            ,CM.BR_NM
            ,A.REF_NO
            ,A.TR_DT               -- 외환취결일
            ,A.ARN_DT              -- 정리일자
            ,A.CRCD                -- 통화
            ,A.FCA                 --외환취결금액
            ,CASE WHEN A.ARN_CMPL_YN = 'Y' THEN
                       TO_DATE(ARN_DT,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD')
                  ELSE TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD')
             END                  -- 경과일자
            ,A.ARN_CMPL_YN        -- 정리완료여부
            ,TR.TLR_NO            -- 조작자번호

    FROM     TB_SOR_FEC_NDFY_NSTL_TR A   -- SOR_FEC_미지급미결제내역

    JOIN     TB_SOR_CMI_BR_BC CM         -- SOR_CMI_점기본
             ON   SUBSTR(A.REF_NO,3,4)  = CM.BRNO

    LEFT OUTER JOIN
             TB_SOR_FEC_FRXC_TR_TR TR   -- SOR_FEC_외환거래내역
             ON  A.REF_NO  = TR.REF_NO
             AND TR.TR_SNO = 1

    WHERE    1=1
    AND      A.NDFY_NSTL_DSCD  = '1' -- 미지급미결제구분코드
    AND      A.TR_STCD = '1'         -- 거래상태코드
    AND      (
               -- 미정리건
               (       A.ARN_CMPL_YN = 'N'    -- 정리완료여부
                   AND TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD') > 7
               )      OR

               -- 정리완료건
               (       A.ARN_CMPL_YN = 'Y'    -- 정리완료여부
                   AND TO_DATE(ARN_DT,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD') > 7
                   AND ARN_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
               )
             )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_외환지원팀09',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
