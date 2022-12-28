/*
  프로그램명 : ins_TB_OPE_KRI_외환지원팀10
  타켓테이블 : TB_OPE_KRI_외환지원팀10
  KRI 지표명 : 미정리 타발송금 건수
  협      조 : 고찬식차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 외환지원팀-10 미정리 타발송금 건수
       A: 당월 말 현재 미지급된 타발송금 중 영업점/지점 접수일로부터 5영업일 초과 경과한 건수
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

    DELETE OPEOWN.TB_OPE_KRI_외환지원팀10
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_외환지원팀10

    SELECT   P_BASEDAY
            ,SUBSTR(A.REF_NO,3,4)        -- 점번호
            ,CM.BR_NM                    -- 점명
            ,A.REF_NO                    -- 고유번호
            ,B.LDGR_ENR_DT               -- 타발내도일
            ,A.TR_DT                     -- 접수일
            ,A.ARN_DT                    -- 정리일자
            ,A.CRCD                      -- 통화
            ,A.FCA                       -- 외환취결금액
            ,CASE WHEN A.ARN_CMPL_YN = 'Y' THEN
                       TO_DATE(ARN_DT,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD')
                  ELSE TO_DATE(P_BASEDAY,'YYYYMMDD') - TO_DATE(A.TR_DT,'YYYYMMDD')
             END                  -- 경과일자
            ,A.ARN_CMPL_YN        -- 정리완료여부
            ,TR.TLR_NO            -- 조작자번호

    FROM     TB_SOR_FEC_NDFY_NSTL_TR A   -- SOR_FEC_미지급미결제내역

    JOIN     TB_SOR_INX_INMY_TLG_BC   B   -- SOR_INX_타발송금전문기본
             ON    A.REF_NO = B.REF_NO

    JOIN     TB_SOR_CMI_BR_BC CM         -- SOR_CMI_점기본
             ON   SUBSTR(A.REF_NO,3,4)  = CM.BRNO

    LEFT OUTER JOIN
             TB_SOR_FEC_FRXC_TR_TR TR   -- SOR_FEC_외환거래내역
             ON  A.REF_NO  = TR.REF_NO
             AND TR.TR_SNO = 1
             and TR.FRXC_LDGR_STCD = '1'
             and TR.ENR_CNCL_DSCD = '1'
             and TR.TSK_PGM_NM = 'INXO413102'

    JOIN     OM_DWA_DT_BC    D
             ON   CASE WHEN A.ARN_CMPL_YN = 'N' THEN P_BASEDAY ELSE A.ARN_DT END = D.STD_DT

    WHERE    1=1
    AND      A.NDFY_NSTL_DSCD  = '1'  -- 미지급미결제구분코드
    AND      A.TR_STCD = '1'
    AND      A.SBCD in ('510','532','575')
    AND      D.D5_BF_SLS_DT > A.TR_DT
    AND      (
                A.ARN_CMPL_YN = 'N'   OR     -- 미정리건이거나
                (A.ARN_CMPL_YN = 'Y'  AND A.ARN_DT BETWEEN P_SOTM_DT AND P_EOTM_DT)  -- 정리되었더라도 당월에 정리된건
             )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_외환지원팀10',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
