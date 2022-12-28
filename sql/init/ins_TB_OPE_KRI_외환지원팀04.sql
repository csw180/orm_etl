/*
  프로그램명 : ins_TB_OPE_KRI_외환지원팀04
  타켓테이블 : TB_OPE_KRI_외환지원팀04
  KRI 지표명 : 외환 미지금, 미결제 장기 미정리 건수(장기)
  협      조 : 고찬식차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 외환지원팀-04 외환 미지금, 미결제 장기 미정리 건수(장기)
       A: 전월 말 외환미지금, 외환 미결제, 미수이자 및 채권관련 장기(1개월경과) 미결제 건수
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
  FROM   DWZOWN.OM_DWA_DT_BC
  WHERE   STD_DT = '&1';
  
  IF P_EOTM_DT = P_BASEDAY  THEN

    DELETE OPEOWN.TB_OPE_KRI_외환지원팀04
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_외환지원팀04

    SELECT   P_BASEDAY
            ,SUBSTR(A.REF_NO,3,4) as "점번호"
            ,CM.BR_NM             as "점명"
            ,A.TR_DT              as "외환취결일"
            ,ARN_DT               as "정리일자"
            ,CRCD                 as "통화"
            ,FCA                  as "외환취결금액"
            ,A.REF_NO             as "고유번호"
            ,CASE WHEN A.ARN_CMPL_YN = 'Y' THEN TO_DATE(ARN_DT,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD')
                  ELSE TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD')
             END    -- 경과일자
            ,TR.TLR_NO            as "조작자번호"
            ,A.ARN_CMPL_YN        as "정리완료여부"

    FROM     TB_SOR_FEC_NDFY_NSTL_TR A   -- SOR_FEC_미지급미결제내역

    JOIN     TB_SOR_CMI_BR_BC CM         -- SOR_CMI_점기본
             ON   SUBSTR(A.REF_NO,3,4)  = CM.BRNO

    LEFT OUTER JOIN
             TB_SOR_FEC_FRXC_TR_TR TR   -- SOR_FEC_외환거래내역
             ON  A.REF_NO  = TR.REF_NO
             AND TR.TR_SNO = 1

    WHERE    1=1
    AND      A.TR_STCD = '1'
    AND      (
               -- 미정리건은 기준일자까지 1개월경과건 포함
               (     A.ARN_CMPL_YN = 'N'     -- 정리완료여부
                 AND TO_CHAR(ADD_MONTHS(TO_DATE(P_BASEDAY,'YYYYMMDD'),-1),'YYYYMMDD')  >  A.TR_DT
               )     OR

               -- 정리건은 정리일자까지 1개월경과, 정리일자가 금월인건만 포함
               (     A.ARN_CMPL_YN = 'Y'     -- 정리완료여부
                 AND TO_CHAR(ADD_MONTHS(TO_DATE(ARN_DT,'YYYYMMDD'),-1),'YYYYMMDD')  >  A.TR_DT
                 AND ARN_DT  BETWEEN  P_SOTM_DT  AND P_EOTM_DT
               )
             )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_외환지원팀04',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT




