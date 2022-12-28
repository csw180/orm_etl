/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀08
  타켓테이블 : TB_OPE_KRI_여신지원팀08
  KRI 지표명 : 예금 질권 설정 및 해제 건 중 최근 1개월내 고객정보 변경건수
  협      조 : 김희선과장
  최조작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-08 예금 질권 설정 및 해제 건 중 최근 1개월내 고객정보 변경건수
       A: 예금질권 설정 혹은 해제 건중 최근 1개월 이내에 고객정보변경된 건수
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀08
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀08

    SELECT   P_BASEDAY
            ,A.STUP_RGT_BRNO AS 점번호
            ,J1.BR_NM        AS 점명
            ,A.MRT_NO        AS 담보번호
--            ,A.MRT_TPCD      AS 담보유형코드
            ,B.MRT_CD        AS 담보유형상세
            ,B.DPS_ACNO      AS 예금계좌번호
            ,B.OWNR_CUST_NO  AS 예금주고객번호
            ,A.DBR_CUST_NO   AS 차주고객번호
            ,A.STUP_STCD     AS 담보설정상태코드
            ,A.STUP_DT       AS 질권설정일자
            ,CASE WHEN A.STUP_STCD ='04' THEN A.LST_CHG_DT ELSE NULL END AS 질권해지일자
            ,NVL(C.MBTL_NO_CHG_YN,'N') 휴대전화번호변경여부
            ,C.MBTL_NO_CHG_DTTM
            ,NVL(C.RCV_DEN_YN,'N') 전화통화거부등록여부
            ,C.RCV_DEN_ENR_DTTM
            ,C.ENR_USR_NO

    FROM     TB_SOR_CLM_STUP_BC A         -- SOR_CLM_설정기본

    JOIN     TB_SOR_CLM_TBK_PRD_MRT_BC B  -- SOR_CLM_당행상품담보기본
             ON   A.MRT_NO    = B.MRT_NO
             AND  B.MRT_CD IN ( '401','402','403','404','405','406',
                                '410','411','412','413','414','415',
                                '427','429','430','431','432','433',
                                '434','435','436','437','438','439',
                                '440','441','442')
    JOIN     (
              SELECT   CUST_NO                      AS 고객번호
                      ,TO_CHAR(ENR_DTTM,'YYYYMMDD') AS 변경등록일시
                      ,ENR_USR_NO
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0001' THEN 'Y' ELSE NULL END  MBTL_NO_CHG_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD = '0001' THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS MBTL_NO_CHG_DTTM
                      ,CASE WHEN A.CUST_INF_CHG_DSCD IN ('0039') THEN 'Y' ELSE NULL END  RCV_DEN_YN
                      ,CASE WHEN A.CUST_INF_CHG_DSCD IN ('0039') THEN TO_CHAR(A.ENR_DTTM,'YYYYMMDD') ELSE NULL END AS RCV_DEN_ENR_DTTM
                      ,ROW_NUMBER() OVER (PARTITION BY CUST_NO ORDER BY ENR_DTTM DESC) AS 순서
              FROM     TB_SOR_CUS_CHG_TR A   --고객정보변경이력
              WHERE    1 = 1
              AND      (
                        (A.CUST_INF_CHG_DSCD = '0001' AND A.CHNL_TPCD LIKE 'E%' AND A.CHB_DAT_CTS != '   ' ) OR  --휴대전화번호
                        (A.CUST_INF_CHG_DSCD = '0039' AND A.CHA_DAT_CTS NOT IN ('  ','00  ')  )                  --전화수신거부유형코드
                       )
              AND      TO_CHAR(A.ENR_DTTM,'YYYYMMDD') BETWEEN P_SOTM_DT AND P_EOTM_DT
             ) C
             ON   B.OWNR_CUST_NO = C.고객번호
             AND  C.순서 = 1

    JOIN     TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_점기본
             ON   A.STUP_RGT_BRNO  =  J1.BRNO

    WHERE    1=1
    AND      A.STUP_STCD IN ('02','03','04')
    AND      A.LST_CHG_DT BETWEEN P_SOTM_DT AND P_EOTM_DT
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀08',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT













-- 여신지원팀-08 : 예금 질권 설정 및 해제 건 중 최근 1개월내 고객정보 변경건수
