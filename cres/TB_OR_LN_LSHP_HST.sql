DROP TABLE OPEOWN.TB_OR_LN_LSHP_HST;
CREATE TABLE OPEOWN.TB_OR_LN_LSHP_HST
(
    GRP_ORG_C           CHAR(2) NOT NULL,
    LSHP_AMNNO          NUMBER(9) NOT NULL,
    LSHP_SQNO           NUMBER(7) NOT NULL,
    COMN_LSHP_AMNNO     NUMBER(9),
    OCU_RGN_C           CHAR(6),
    HPN_OCU_NATCD       CHAR(2),
    OCU_BRC             VARCHAR2(20),
    OCU_BRNM            VARCHAR2(40),
    RPRR_ENO            VARCHAR2(10),
    TMP_RG_BRC          CHAR(6),
    RPT_BRC             VARCHAR2(20),
    BND_AMN_BRC         VARCHAR2(20),
    BND_AMN_BRNM        VARCHAR2(40),
    LSS_TINM            VARCHAR2(500),
    OCU_DEPT_DTL_CNTN   CLOB,
    AMN_DEPT_DTL_CNTN   VARCHAR2(4000),
    OPRK_AMN_DTL_CNTN   VARCHAR2(4000),
    OCU_DT              CHAR(8),
    DSCV_DT             CHAR(8),
    HUR_AMNNO           VARCHAR2(100),
    LSHP_FORM_C         CHAR(2),
    LSHP_STSC           CHAR(2),
    AMN_BRC             VARCHAR2(20),
    OPRK_HAM_XPC_AM     NUMBER(18,3),
    LSS_CST_AM          NUMBER(18,3),
    OPRK_ISR_WDR_AM     NUMBER(18,3),
    LWS_CST_AM          NUMBER(18,3),
    LWS_WDR_AM          NUMBER(18,3),
    ETC_CST_AM          NUMBER(18,3),
    OPRK_ETC_WDR_AM     NUMBER(18,3),
    TTLS_AM             NUMBER(18,3),
    TOT_WDR_AM          NUMBER(17,2),
    GULS_AM             NUMBER(17,2),
    MKRK_YN             CHAR(1),
    CRRK_YN             CHAR(1),
    RWA_YN              CHAR(1),
    STRK_YN             CHAR(1),
    FMRK_YN             CHAR(1),
    LGRK_YN             CHAR(1),
    EXC_YN              CHAR(1),
    LSOC_CHAN_CNTN      VARCHAR2(50),
    LSHP_REL_WRSNM      VARCHAR2(50),
    ISR_RQS_YN          CHAR(1),
    DCZ_SQNO            NUMBER(7),
    TRF_BRK_SQNO        NUMBER(9),
    LWS_YN              CHAR(1),
    LWSJDG_DSC          CHAR(1),
    LWS_TMNT_YN         CHAR(1),
    LWS_RZT_C           CHAR(1),
    LWS_LG_AM           NUMBER(18,3),
    LWS_HP_NO           VARCHAR2(20),
    LWS_CURT_NM         VARCHAR2(50),
    RWA_UNQ_NO          VARCHAR2(20),
    ILG_BND_REL_YN      CHAR(1),
    VLD_ST_DT           CHAR(8),
    VLD_ED_DT           CHAR(8),
    VLD_YN              CHAR(1),
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
)
LOB (OCU_DEPT_DTL_CNTN) STORE AS SECUREFILE 
(
    STORAGE
    (
        INITIAL 4M
        NEXT 4M
    )
    CHUNK 8192
    PCTVERSION 0
);

ALTER TABLE OPEOWN.TB_OR_LN_LSHP_HST
ADD CONSTRAINT PK_OR_LN_LSHP_HST PRIMARY KEY (GRP_ORG_C,LSHP_AMNNO,LSHP_SQNO);

GRANT DELETE ON OPEOWN.TB_OR_LN_LSHP_HST TO RL_OPE_ALL;
GRANT INSERT ON OPEOWN.TB_OR_LN_LSHP_HST TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_LN_LSHP_HST TO RL_OPE_ALL;
GRANT UPDATE ON OPEOWN.TB_OR_LN_LSHP_HST TO RL_OPE_ALL;
GRANT SELECT ON OPEOWN.TB_OR_LN_LSHP_HST TO RL_OPE_SEL;

COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.AMN_BRC IS '�����繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.AMN_DEPT_DTL_CNTN IS '�����μ��󼼳���';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.BND_AMN_BRC IS 'ä�ǰ����繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.BND_AMN_BRNM IS '�繫�Ҹ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.COMN_LSHP_AMNNO IS '����սǻ�ǰ�����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.CRRK_YN IS '�ſ븮��ũ����';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.DCZ_SQNO IS '�����Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.DSCV_DT IS '�߰�����';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.ETC_CST_AM IS '��Ÿ���ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.EXC_YN IS '������󿩺�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.FIR_INPMN_ENO IS '�����Է��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.FIR_INP_DTM IS '�����Է��Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.FMRK_YN IS '���Ǹ���ũ����';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.GRP_ORG_C IS '�׷����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.GULS_AM IS '���սǱݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.HPN_OCU_NATCD IS '��ǹ߻������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.HUR_AMNNO IS '�λ������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.ILG_BND_REL_YN IS '�ν�ä�ǰ��ÿ���';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.ISR_RQS_YN IS '����û������';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LGRK_YN IS '��������ũ����';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LSCHG_DTM IS '���������Ͻ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LSHP_AMNNO IS '�սǻ�ǰ�����ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LSHP_FORM_C IS '�սǻ�������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LSHP_REL_WRSNM IS '�սǻ�ǰ��û�ǰ��';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LSHP_SQNO IS '�սǻ���Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LSHP_STSC IS '�սǻ�ǻ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LSOC_CHAN_CNTN IS '�սǹ߻�ä�γ���';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LSS_CST_AM IS '�սǺ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LSS_TINM IS '�ս������';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LS_WKR_ENO IS '�����۾��ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LWSJDG_DSC IS '�Ҽ۽ɱޱ����ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LWS_CST_AM IS '�Ҽۺ��ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LWS_CURT_NM IS '�Ҽ۰��ҹ���';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LWS_HP_NO IS '�Ҽۻ�ǹ�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LWS_LG_AM IS '�Ҽ۰���';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LWS_RZT_C IS '�Ҽ۰���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LWS_TMNT_YN IS '�Ҽ����Ῡ��';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LWS_WDR_AM IS '�Ҽ�ȸ���ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.LWS_YN IS '�Ҽۿ���';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.MKRK_YN IS '���帮��ũ����';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.OCU_BRC IS '�߻��繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.OCU_BRNM IS '�繫�Ҹ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.OCU_DEPT_DTL_CNTN IS '�߻��μ��󼼳���';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.OCU_DT IS '�߻�����';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.OCU_RGN_C IS '�߻������ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.OPRK_AMN_DTL_CNTN IS '�����ũ�����ڻ󼼳���';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.OPRK_ETC_WDR_AM IS '�����ũ��Ÿȸ���ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.OPRK_HAM_XPC_AM IS '�����ũ���ؿ���ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.OPRK_ISR_WDR_AM IS '�����ũ����ȸ���ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.RPRR_ENO IS '�����ڰ��ι�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.RPT_BRC IS '�����繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.RWA_UNQ_NO IS 'RWA������ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.RWA_YN IS '���谡���ڻ꿩��';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.STRK_YN IS '��������ũ����';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.TMP_RG_BRC IS '�ӽõ�ϻ繫���ڵ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.TOT_WDR_AM IS '��ȸ���ݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.TRF_BRK_SQNO IS '�̰��Ϸù�ȣ';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.TTLS_AM IS '�ѼսǱݾ�';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.VLD_ED_DT IS '��ȿ��������';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.VLD_ST_DT IS '��ȿ��������';
COMMENT ON COLUMN OPEOWN.TB_OR_LN_LSHP_HST.VLD_YN IS '��ȿ����';
COMMENT ON TABLE OPEOWN.TB_OR_LN_LSHP_HST IS '�սǻ��_�սǻ���̷�';
