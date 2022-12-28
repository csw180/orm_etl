/*
  프로그램명 : ins_TB_OPE_KRI_여신지원팀19
  타켓테이블 : TB_OPE_KRI_여신지원팀19
  KRI 지표명 : 고객정보 변경 후 예금담보대출 취급 건수
  협      조 : 김희선과장
  최초작성자 : 최상원
  KRI 지표명 :
     - 여신지원팀-19 고객정보 변경 후 예금담보대출 취급 건수
       A: 전월 중 예금담보대출 1천만원 이상 취급건 중 7영업일 이내에 핸드폰번호 변경이 있었던 건수
       B: 전월 중 예금담보대출 1천만원 이상 취급건 중 7영업일 이내에 전화수신거부 등록이 있었던 건
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

    DELETE OPEOWN.TB_OPE_KRI_여신지원팀19
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_여신지원팀19

    SELECT   P_BASEDAY
            ,A.STUP_RGT_BRNO AS 점번호
            ,J1.BR_NM        AS 점명
            ,A.MRT_NO        AS 담보번호
            ,A.MRT_TPCD      AS 담보유형코드
            ,B.MRT_CD        AS 담보유형상세
            ,D.PDCD          AS 상품코드
            ,B.DPS_ACNO      AS 예금계좌번호
            ,C.ACN_DCMT_NO   AS 대출계좌번호
            ,B.OWNR_CUST_NO  AS 예금주고객번호
            ,A.DBR_CUST_NO   AS 차주고객번호
            ,A.STUP_STCD     AS 담보설정상태코드
            ,A.STUP_DT       AS 질권설정일자
            ,CASE WHEN A.STUP_STCD ='04' THEN A.LST_CHG_DT ELSE NULL END 질권해지일자
            ,NVL(E.MBTL_NO_CHG_YN,'N')  휴대전화번호변경여부
            ,DECODE(E.MBTL_NO_CHG_YN,'Y',변경등록일시,NULL)  휴대전화번호변경등록일시
            ,NVL(E.RCV_DEN_YN,'N') 전화통화거부등록여부
            ,DECODE(E.RCV_DEN_YN,'Y',변경등록일시,NULL)  전화통화거부변경등록일시
            ,E.ENR_USR_NO  AS  등록사용자번호

    FROM     TB_SOR_CLM_STUP_BC A         -- SOR_CLM_설정기본

    JOIN     TB_SOR_CLM_TBK_PRD_MRT_BC B  -- SOR_CLM_당행상품담보기본
             ON   A.MRT_NO    = B.MRT_NO

    JOIN     TB_SOR_CLM_CLN_LNK_TR C      -- SOR_CLM_여신연결내역
             ON   A.STUP_NO     = C.STUP_NO
             AND  C.CLN_LNK_STCD IN ('02','03','04')
             AND  C.ENR_DT BETWEEN P_SOTM_DT AND P_EOTM_DT

    JOIN     TB_SOR_LOA_ACN_BC D          --  SOR_LOA_계좌기본
             ON   C.ACN_DCMT_NO = D.CLN_ACNO   -- 여신계좌번호
             AND  D.PDCD IN ('20051100001001','20051100002001','20051100003011','20051100003021',
                             '20804100001001','20804100002001','20804100003011','20804100003021',
                             '20001100001001','20001100002001','20001100003011','20001100003021',
                             '20003100001001','20007100001001','20013100001001','20021100001001',
                             '20803100001001','20803100002001','20803100003011','20803100003021',
                             '20051101000001','20001101000001','20051001100001','20804000300001'
                            )    --상품코드

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
                        (A.CUST_INF_CHG_DSCD = '0039' AND A.CHA_DAT_CTS NOT IN ('  ','00  ')  )                   --전화수신거부유형코드
                       )
              AND      TO_CHAR(A.ENR_DTTM,'YYYYMMDD') BETWEEN P_SOTM_DT AND P_EOTM_DT
             ) E
             ON   B.OWNR_CUST_NO = E.고객번호
             -- AND  E.순서 = 1

    JOIN     TB_SOR_CMI_BR_BC  J1     -- SOR_CMI_점기본
             ON   A.STUP_RGT_BRNO  =  J1.BRNO

    JOIN     OM_DWA_DT_BC DD  -- DWA_일자기본
             ON   A.STUP_DT  =  DD.STD_DT

    WHERE    1=1
    AND      E.변경등록일시 BETWEEN DD.D7_BF_SLS_DT AND A.STUP_DT  -- 질권설정일(계좌취급일)로 부터 과거7영업일사이에 고객정보변경일이 존재
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_여신지원팀19',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT
