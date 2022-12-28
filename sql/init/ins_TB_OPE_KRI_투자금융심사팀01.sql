/*
  프로그램명 : ins_TB_OPE_KRI_투자금융심사팀01
  타켓테이블 : TB_OPE_KRI_투자금융심사팀01
  KRI 지표명 : 조기경보 주의등급 이상 분류 차주 수
  협      조 : 선민국차장
  최조작성자 : 최상원
  KRI 지표명 :
     - 투자금융심사팀-01: 조기경보 주의등급 이상 분류 차주 수
       A: 전월말 기준 조기경보 등급이 '주의' 이상인 차주의 수
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

    DELETE OPEOWN.TB_OPE_KRI_투자금융심사팀01
    WHERE  STD_DT = P_BASEDAY;

    DBMS_OUTPUT.PUT_LINE(SQL%ROWCOUNT || ' rows deleted');

    INSERT INTO OPEOWN.TB_OPE_KRI_투자금융심사팀01
    SELECT   P_BASEDAY            -- 기준일자
            ,ADM_BRNO
            ,BR_NM
            ,CUST_NO
            ,SYS_ERLR_JDGM_GDCD
            ,TGT_ABST_DT
    FROM     (
               SELECT   A.ADM_BRNO
                       ,J1.BR_NM             -- 점명
                       ,A.CUST_NO            -- 고객번호
                       ,A.SYS_ERLR_JDGM_GDCD -- 시스템조기경보판정등급코드(01:정상,02:요관찰,03:주의)
                       ,A.TGT_ABST_DT        -- 대상추출일자
               --       ,A.ERLR_JDGM_RSN      -- 조기경보판정사유
               --        ,A.DEL_YN
               --        ,A.EVL_AVL_DT
                       ,ROW_NUMBER() OVER ( PARTITION BY A.CUST_NO ORDER BY A.TGT_ABST_DT DESC) AS 순서
               FROM     TB_SOR_EWL_NEW_TGT_BC  A --  SOR_EWL_신조기경보대상기본
               JOIN     TB_SOR_CMI_BR_BC     J1
                        ON   A.ADM_BRNO  =  J1.BRNO
               WHERE    1=1
               AND      A.TGT_ABST_DT  BETWEEN P_SOTM_DT AND P_EOTM_DT
               AND      A.EVL_AVL_DT   > P_BASEDAY  -- 평가유효일자가 지나지 않은것
               AND      A.DEL_YN = 'N'
             )  A
    WHERE    1=1
    AND      A.순서 = 1
    AND      A.SYS_ERLR_JDGM_GDCD >= '03'   -- 03:주의 등급이상
    ;

    P_LD_CN := SQL%ROWCOUNT;

    DBMS_OUTPUT.PUT_LINE(P_LD_CN || ' rows inserted');

    COMMIT;

    SP_INS_ETLLOG('TB_OPE_KRI_투자금융심사팀01',P_BASEDAY,P_LD_CN,'KRI_ETL');
  END IF;

END
;
/
EXIT