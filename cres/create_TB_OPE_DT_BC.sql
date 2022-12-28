DROP TABLE OPEOWN.TB_OPE_DT_BC;

CREATE TABLE OPEOWN.TB_OPE_DT_BC
(
    STD_DT                                  VARCHAR2(8) DEFAULT 'N'  NOT NULL,
    INFS_CHG_DTTM                           DATE NOT NULL,
    HDY_YN                                  VARCHAR2(1) DEFAULT 'N'  NOT NULL,
    NXT_SLS_DT                              VARCHAR2(8),
    BF_SLS_DT                               VARCHAR2(8),
    D2_BF_SLS_DT                            VARCHAR2(8),
    D3_BF_SLS_DT                            VARCHAR2(8),
    D4_BF_SLS_DT                            VARCHAR2(8),
    D5_BF_SLS_DT                            VARCHAR2(8),
    D6_BF_SLS_DT                            VARCHAR2(8),
    D7_BF_SLS_DT                            VARCHAR2(8),
    D8_BF_SLS_DT                            VARCHAR2(8),
    D9_BF_SLS_DT                            VARCHAR2(8),
    D10_BF_SLS_DT                           VARCHAR2(8),
    D11_BF_SLS_DT                           VARCHAR2(8),
    D12_BF_SLS_DT                           VARCHAR2(8),
    D13_BF_SLS_DT                           VARCHAR2(8),
    D14_BF_SLS_DT                           VARCHAR2(8),
    D15_BF_SLS_DT                           VARCHAR2(8),
    D16_BF_SLS_DT                           VARCHAR2(8),
    D17_BF_SLS_DT                           VARCHAR2(8),
    D18_BF_SLS_DT                           VARCHAR2(8),
    D19_BF_SLS_DT                           VARCHAR2(8),
    D20_BF_SLS_DT                           VARCHAR2(8),
    D21_BF_SLS_DT                           VARCHAR2(8),
    D22_BF_SLS_DT                           VARCHAR2(8),
    D23_BF_SLS_DT                           VARCHAR2(8),
    D24_BF_SLS_DT                           VARCHAR2(8),
    D25_BF_SLS_DT                           VARCHAR2(8),
    D26_BF_SLS_DT                           VARCHAR2(8),
    D27_BF_SLS_DT                           VARCHAR2(8),
    D28_BF_SLS_DT                           VARCHAR2(8),
    D29_BF_SLS_DT                           VARCHAR2(8),
    D30_BF_SLS_DT                           VARCHAR2(8),
    NXT_DT                                  VARCHAR2(8),
    BF_DT                                   VARCHAR2(8),
    D2_BF_DT                                VARCHAR2(8),
    D3_BF_DT                                VARCHAR2(8),
    D4_BF_DT                                VARCHAR2(8),
    D5_BF_DT                                VARCHAR2(8),
    D6_BF_DT                                VARCHAR2(8),
    D7_BF_DT                                VARCHAR2(8),
    D8_BF_DT                                VARCHAR2(8),
    D9_BF_DT                                VARCHAR2(8),
    D10_BF_DT                               VARCHAR2(8),
    D11_BF_DT                               VARCHAR2(8),
    D12_BF_DT                               VARCHAR2(8),
    D13_BF_DT                               VARCHAR2(8),
    D14_BF_DT                               VARCHAR2(8),
    D15_BF_DT                               VARCHAR2(8),
    D16_BF_DT                               VARCHAR2(8),
    D17_BF_DT                               VARCHAR2(8),
    D18_BF_DT                               VARCHAR2(8),
    D19_BF_DT                               VARCHAR2(8),
    D20_BF_DT                               VARCHAR2(8),
    D21_BF_DT                               VARCHAR2(8),
    D22_BF_DT                               VARCHAR2(8),
    D23_BF_DT                               VARCHAR2(8),
    D24_BF_DT                               VARCHAR2(8),
    D25_BF_DT                               VARCHAR2(8),
    D26_BF_DT                               VARCHAR2(8),
    D27_BF_DT                               VARCHAR2(8),
    D28_BF_DT                               VARCHAR2(8),
    D29_BF_DT                               VARCHAR2(8),
    D30_BF_DT                               VARCHAR2(8),
    TMM_SLS_DCNT                            NUMBER(10) DEFAULT 0  NOT NULL,
    EOTM_SLS_DT                             VARCHAR2(8),
    BEOM_SLS_DT                             VARCHAR2(8),
    BF2_EOM_SLS_DT                          VARCHAR2(8),
    STD_EOQ_SLS_DT                          VARCHAR2(8),
    BF_EOQ_SLS_DT                           VARCHAR2(8),
    BF2_EOQ_SLS_DT                          VARCHAR2(8),
    STD_EHY_SLS_DT                          VARCHAR2(8),
    THY_LST_SLS_DT                          VARCHAR2(8),
    PVY_LST_SLS_DT                          VARCHAR2(8),
    BF_PVY_LST_SLS_DT                       VARCHAR2(8),
    TMM_DCNT                                NUMBER(10) DEFAULT 0  NOT NULL,
    MNDR_DCNT                               NUMBER(10) DEFAULT 0  NOT NULL,
    IMT_DCNT                                NUMBER(10) DEFAULT 0  NOT NULL,
    EOTM_DT                                 VARCHAR2(8),
    BEOM_DT                                 VARCHAR2(8),
    BF2_EOM_DT                              VARCHAR2(8),
    STD_EOQ_DT                              VARCHAR2(8),
    BF_EOQ_DT                               VARCHAR2(8),
    BF2_EOQ_DT                              VARCHAR2(8),
    STD_EHY_DT                              VARCHAR2(8),
    STD_DT_YN                               VARCHAR2(1) DEFAULT 'N'  NOT NULL,
    HVF_YN                                  VARCHAR2(1) DEFAULT 'N'  NOT NULL
) NOLOGGING;

CREATE UNIQUE INDEX OPEOWN.PK_TB_OPE_DT_BC ON OPEOWN.TB_OPE_DT_BC (STD_DT);

ALTER TABLE OPEOWN.TB_OPE_DT_BC
    ADD CONSTRAINT PK_TB_OPE_DT_BC PRIMARY KEY (STD_DT)
 USING INDEX ;

COMMENT ON TABLE OPEOWN.TB_OPE_DT_BC IS 'OPE_일자기본';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.STD_DT                                   IS '기준일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.INFS_CHG_DTTM                            IS '정보계변경일시';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.HDY_YN                                   IS '휴일여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.NXT_SLS_DT                               IS '익영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BF_SLS_DT                                IS '전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D2_BF_SLS_DT                             IS '2일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D3_BF_SLS_DT                             IS '3일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D4_BF_SLS_DT                             IS '4일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D5_BF_SLS_DT                             IS '5일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D6_BF_SLS_DT                             IS '6일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D7_BF_SLS_DT                             IS '7일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D8_BF_SLS_DT                             IS '8일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D9_BF_SLS_DT                             IS '9일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D10_BF_SLS_DT                            IS '10일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D11_BF_SLS_DT                            IS '11일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D12_BF_SLS_DT                            IS '12일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D13_BF_SLS_DT                            IS '13일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D14_BF_SLS_DT                            IS '14일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D15_BF_SLS_DT                            IS '15일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D16_BF_SLS_DT                            IS '16일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D17_BF_SLS_DT                            IS '17일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D18_BF_SLS_DT                            IS '18일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D19_BF_SLS_DT                            IS '19일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D20_BF_SLS_DT                            IS '20일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D21_BF_SLS_DT                            IS '21일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D22_BF_SLS_DT                            IS '22일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D23_BF_SLS_DT                            IS '23일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D24_BF_SLS_DT                            IS '24일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D25_BF_SLS_DT                            IS '25일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D26_BF_SLS_DT                            IS '26일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D27_BF_SLS_DT                            IS '27일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D28_BF_SLS_DT                            IS '28일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D29_BF_SLS_DT                            IS '29일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D30_BF_SLS_DT                            IS '30일전영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.NXT_DT                                   IS '익일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BF_DT                                    IS '전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D2_BF_DT                                 IS '2일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D3_BF_DT                                 IS '3일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D4_BF_DT                                 IS '4일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D5_BF_DT                                 IS '5일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D6_BF_DT                                 IS '6일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D7_BF_DT                                 IS '7일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D8_BF_DT                                 IS '8일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D9_BF_DT                                 IS '9일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D10_BF_DT                                IS '10일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D11_BF_DT                                IS '11일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D12_BF_DT                                IS '12일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D13_BF_DT                                IS '13일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D14_BF_DT                                IS '14일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D15_BF_DT                                IS '15일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D16_BF_DT                                IS '16일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D17_BF_DT                                IS '17일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D18_BF_DT                                IS '18일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D19_BF_DT                                IS '19일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D20_BF_DT                                IS '20일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D21_BF_DT                                IS '21일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D22_BF_DT                                IS '22일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D23_BF_DT                                IS '23일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D24_BF_DT                                IS '24일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D25_BF_DT                                IS '25일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D26_BF_DT                                IS '26일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D27_BF_DT                                IS '27일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D28_BF_DT                                IS '28일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D29_BF_DT                                IS '29일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.D30_BF_DT                                IS '30일전일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.TMM_SLS_DCNT                             IS '당월영업일수';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.EOTM_SLS_DT                              IS '당월말영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BEOM_SLS_DT                              IS '전월말영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BF2_EOM_SLS_DT                           IS '전전월말영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.STD_EOQ_SLS_DT                           IS '기준분기말영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BF_EOQ_SLS_DT                            IS '전분기말영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BF2_EOQ_SLS_DT                           IS '전전분기말영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.STD_EHY_SLS_DT                           IS '기준반기말영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.THY_LST_SLS_DT                           IS '당년최종영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.PVY_LST_SLS_DT                           IS '전년최종영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BF_PVY_LST_SLS_DT                        IS '전전년최종영업일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.TMM_DCNT                                 IS '당월일수';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.MNDR_DCNT                                IS '월중일수';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.IMT_DCNT                                 IS '기중일수';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.EOTM_DT                                  IS '당월말일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BEOM_DT                                  IS '전월말일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BF2_EOM_DT                               IS '전전월말일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.STD_EOQ_DT                               IS '기준분기말일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BF_EOQ_DT                                IS '전분기말일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.BF2_EOQ_DT                               IS '전전분기말일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.STD_EHY_DT                               IS '기준반기말일자';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.STD_DT_YN                                IS '기준일자여부';
COMMENT ON COLUMN OPEOWN.TB_OPE_DT_BC.HVF_YN                                   IS '휴무여부';

GRANT SELECT ON TB_OPE_DT_BC TO RL_OPE_ALL;
GRANT DELETE ON TB_OPE_DT_BC TO RL_OPE_ALL;
GRANT UPDATE ON TB_OPE_DT_BC TO RL_OPE_ALL;
GRANT INSERT ON TB_OPE_DT_BC TO RL_OPE_ALL;
GRANT SELECT ON TB_OPE_DT_BC TO RL_OPE_SEL;

EXIT
