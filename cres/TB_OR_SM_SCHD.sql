CREATE TABLE OPEOWN.TB_OR_SM_SCHD
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    SNRO_SC             NUMBER(6) NOT NULL,
    SNRO_EVL_TIT        VARCHAR2(200),
    EFCT_ST_DT          CHAR(8),
    EFCT_ED_DT          CHAR(8),
    LSS_WVAL_RTO        NUMBER(6,3),
    KRI_WVAL_RTO        NUMBER(6,3),
    RCSA_WVAL_RTO       NUMBER(6,3),
    CTEV_WVAL_RTO       NUMBER(6,3),
    CLC_RQR_DTM         VARCHAR2(14),
    LS_CLC_DTM          VARCHAR2(14),
    SNRO_EVL_PRG_STSC   CHAR(2),
    SNRO_RSN            VARCHAR2(2000),
    FIR_INP_DTM         DATE,
    FIR_INPMN_ENO       VARCHAR2(10),
    LSCHG_DTM           DATE,
    LS_WKR_ENO          VARCHAR2(10)
)
TABLESPACE TS_OPE_DT001_08K
STORAGE
(
    INITIAL 4M
    NEXT 4M
);

ALTER TABLE OPEOWN.TB_OR_SM_SCHD
ADD CONSTRAINT PK_OR_SM_SCHD PRIMARY KEY (GRP_ORG_C,SNRO_SC);

GRANT DELETE ON OPEOWN.TB_OR_SM_SCHD TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_SM_SCHD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_SM_SCHD TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_SM_SCHD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_SM_SCHD TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.CLC_RQR_DTM IS '계산요청일시';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.CTEV_WVAL_RTO IS '통제평가가중치비율';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.EFCT_ED_DT IS '수행종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.EFCT_ST_DT IS '수행시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.KRI_WVAL_RTO IS 'KRI가중치비율';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.LSS_WVAL_RTO IS '손실가중치비율';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.LS_CLC_DTM IS '최종계산일시';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.RCSA_WVAL_RTO IS 'RCSA가중치비율';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.SNRO_EVL_PRG_STSC IS '시나리오평가진행상태코드';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.SNRO_EVL_TIT IS '시나리오평가제목';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.SNRO_RSN IS '등록변경사유내용';
COMMENT ON COLUMN OPEOWN.TB_OR_SM_SCHD.SNRO_SC IS '시나리오회차';
COMMENT ON TABLE OPEOWN.TB_OR_SM_SCHD IS '시나리오_평가일정관리기본';

