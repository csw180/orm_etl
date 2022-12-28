/*
  프로그램명 : ins_TB_OPE_KRI_외환지원팀02
  타켓테이블 : TB_OPE_KRI_외환지원팀02
  KRI 지표명 : 전월중 동일수취인에게 2회이상 합계액 1만불초과 송금건수
  협      조 : 고찬식차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 외환지원팀-02 전월중 동일수취인에게 2회이상 합계액 1만불초과 송금건수
       A: 전월 중 동일수취인에게 2회이상 합계액 1만불초과 송금건수
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

    DELETE OPEOWN.TB_OPE_KRI_외환지원팀02
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_외환지원팀02
    SELECT   P_BASEDAY
            ,SUBSTR(A.REF_NO,3,4)
            ,CM.BR_NM as "점명"
            ,A.ADRE_EN_NM as "수취인명"
            ,A.ADRE_FRNW_ACNO as "수취인계좌번호"
            ,A.REF_NO as "고유번호"
            ,A.TR_DT as "취결일"
            ,A.CRCD as "통화코드"
            ,A.OWMN_AMT as "송금액"

    FROM     TB_SOR_INX_OWMN_BC A    -- SOR_INX_당발송금기본

    JOIN     TB_SOR_CMI_BR_BC   CM   -- SOR_CMI_점기본
             ON  SUBSTR(A.REF_NO,3,4) = CM.BRNO

    WHERE    1=1
    AND      A.TR_DT BETWEEN P_SOTM_DT AND  P_EOTM_DT
    AND      A.FRXC_LDGR_STCD IN ('1','2','9')
    AND      A.ADRE_FRNW_ACNO IS NOT NULL
    AND      (
              A.ADRE_FRNW_ACNO IN (
                    SELECT   ADRE_FRNW_ACNO
                    FROM     TB_SOR_INX_OWMN_BC  -- SOR_INX_당발송금기본
                    WHERE    TR_DT BETWEEN P_SOTM_DT AND  P_EOTM_DT
                    AND      FRXC_LDGR_STCD IN ('1','2','9')
                    AND      ADRE_FRNW_ACNO IS NOT NULL
                    GROUP BY ADRE_FRNW_ACNO
                    HAVING   COUNT(*) > 1 AND SUM(TUSA_TNSL_AMT) > 10000
                 )  OR
              A.ADRE_EN_NM IN (
                    SELECT   ADRE_EN_NM
                    FROM     TB_SOR_INX_OWMN_BC  -- SOR_INX_당발송금기본
                    WHERE    TR_DT BETWEEN P_SOTM_DT AND  P_EOTM_DT
                    AND      FRXC_LDGR_STCD IN ('1','2','9')
                    AND      ADRE_FRNW_ACNO IS NULL
                    GROUP BY ADRE_EN_NM
                    HAVING   COUNT(*) > 1 AND SUM(TUSA_TNSL_AMT) > 10000
                 )
             )
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_외환지원팀02',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT

