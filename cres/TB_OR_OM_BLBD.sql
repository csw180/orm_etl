CREATE TABLE OPEOWN.TB_OR_OM_BLBD
(
    GRP_ORG_C       CHAR(2) NOT NULL,
    BLBD_DSC        CHAR(1) NOT NULL,
    BLBD_SQNO       NUMBER(10) NOT NULL,
    BLBD_TINM       VARCHAR2(255),
    BLBD_CNTN       VARCHAR2(4000),
    BLBD_INQ_CN     NUMBER(7),
    BBRD_RGMN_ENO   VARCHAR2(10),
    BLBD_RG_BRC     VARCHAR2(20),
    BBRD_RG_DT      CHAR(8),
    BLTN_ST_DT      CHAR(8),
    BLTN_ED_DT      CHAR(8),
    PUP_YN          CHAR(1),
    PRY_BLTN_YN     CHAR(1),
    FIR_INP_DTM     DATE,
    FIR_INPMN_ENO   VARCHAR2(10),
    LSCHG_DTM       DATE,
    LS_WKR_ENO      VARCHAR2(10)
)
TABLESPACE TS_OPE_DT001_08K
STORAGE
(
    INITIAL 4M
    NEXT 4M
);

ALTER TABLE OPEOWN.TB_OR_OM_BLBD
ADD CONSTRAINT PK_OR_OM_BLBD PRIMARY KEY (GRP_ORG_C,BLBD_DSC,BLBD_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_OM_BLBD TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_OM_BLBD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_BLBD TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_OM_BLBD TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_OM_BLBD TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BBRD_RGMN_ENO IS '게시물등록자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BBRD_RG_DT IS '게시물등록일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_CNTN IS '게시판내용';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_DSC IS '게시판구분코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_INQ_CN IS '게시판조회건수';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_RG_BRC IS '게시판등록사무소코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_SQNO IS '게시판일련번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLBD_TINM IS '게시판제목명';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLTN_ED_DT IS '게시종료일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.BLTN_ST_DT IS '게시시작일자';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.FIR_INPMN_ENO IS '최초입력자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.FIR_INP_DTM IS '최초입력일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.GRP_ORG_C IS '그룹기관코드';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.LSCHG_DTM IS '최종변경일시';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.LS_WKR_ENO IS '최종작업자개인번호';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.PRY_BLTN_YN IS '우선게시여부';
COMMENT ON COLUMN OPEOWN.TB_OR_OM_BLBD.PUP_YN IS '팝업여부';
COMMENT ON TABLE OPEOWN.TB_OR_OM_BLBD IS '공통_게시판기본';

