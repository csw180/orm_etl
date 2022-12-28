/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀09
  타켓테이블 : TB_OPE_KRI_여신지원팀09
  KRI 지표명 : 예금신규 2영업일 이내에 담보 제공된 예금계좌건수
  협      조 : 김희선과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-09 예금신규 2영업일 이내에 담보 제공된 예금계좌건수
       A: 전월 중 예금가입일을 포함하여 신규 2영업일 이내에 담보제공된 예금계좌건수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀09
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀09

    SELECT   P_BASEDAY
            ,A.STUP_RGT_BRNO AS 점번호
            ,J1.BR_NM        AS 점명
            ,A.MRT_NO        AS 담보번호
    --        ,A.MRT_TPCD      AS 담보유형코드
            ,B.MRT_CD        AS 담보코드
            ,B.OWNR_CUST_NO  AS 예금주번호
            ,A.DBR_CUST_NO   AS 차주번호
            ,B.DPS_ACNO      AS 예금계좌번호
            ,B.ENR_DT        AS 담보등록일자
            ,B.NW_DT         AS 예금신규일
            ,B.HDLG_USR_NO   AS 조작자직원번호

    FROM     TB_SOR_CLM_STUP_BC A         -- SOR_CLM_설정기본

    JOIN     TB_SOR_CLM_TBK_PRD_MRT_BC B  -- SOR_CLM_당행상품담보기본
             ON  A.MRT_NO    = B.MRT_NO
             AND B.ENR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
             AND B.MRT_CD IN ( '401','402','403','404','405','406','410',
                               '411','412','413','414','415','427','429',
                               '430','431','432','433','434','435','436',
                               '437','438','439','440','441','442'
                              )

    JOIN     TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_점기본
             ON   A.STUP_RGT_BRNO  =  J1.BRNO

    JOIN     OM_DWA_DT_BC D  -- DWA_일자기본
             ON   B.ENR_DT  =  D.STD_DT

    WHERE    1=1
    AND      A.STUP_STCD IN ('02','04')
    AND      D.D2_BF_SLS_DT <= B.NW_DT   -- 담보등록일로 2영업일이내 예금계좌신규일이 존재
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀09',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT