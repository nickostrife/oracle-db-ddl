SELECT A.BASE_DT ,
A.BII_BR_CD BR_CD ,
B.KFM_BI_MBR_CD MBR_CD ,
B.KFM_BI_BR_CD BI_BR_CD ,
A.AGREE_NO ANT_AGREE_NO ,
CASE
	WHEN A.BII_BR_CD LIKE '7%'
	OR A.BII_BR_CD = '989'
	THEN 'S'
	ELSE 'K'
END JENIS_USAHA ,
'' ANT_OFFICE_CD ,
B.KFM_SCOMMENT ,
NVL(CD_AAK.RESERVE1, A.PRD_CATG ) PRD_CATG ,
'' ANT_JENIS_AKAD_SY ,
A.CURR_CD CURR_CD ,
'' ANT_JANGKA_WAKTU,
A.INT_RT INT_RT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.IDR_PMON_OS_BAL
	ELSE 0
END IDR_PMON_OS_BAL ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.MON_DR_TX_AMT*IDR_XRT
	ELSE 0
END IDR_MON_DR_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.MON_CR_TX_AMT*IDR_XRT
	ELSE 0
END IDR_MON_CR_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN (IDR_OS_BAL - IDR_PMON_OS_BAL - (A.MON_DR_TX_AMT - A.MON_CR_TX_AMT) * IDR_XRT)
	ELSE 0
END IDR_MON_OT_TX_AMT ,
A.IDR_OS_BAL,
:v_job_bs_dt ORG_PRC_DT
FROM FM_BAS_MMMSTD A,
SUM_STSIBRCHAD B ,
(SELECT CD_VAL, RESERVE1 FROM RDMDEV.RDM_MNT_CMNCD WHERE CD_KEY = 'AAAK1'
) CD_AAK
WHERE B.BR_CD         = A.BII_BR_CD
AND A.BASE_YM         = SUBSTR(:v_job_bs_dt,0,6)
AND B.BASE_DT         = :v_job_bs_dt
AND A.OVRS_FG         = '1'
AND A.ASSET_LBLT_IDCT = 'A'
AND A.FM_GL_ACCTN_TP  = 'OIA'
AND A.IDR_PMON_OS_BAL > 0
AND A.IDR_OS_BAL      > 0
AND A.PRD_CATG        =CD_AAK.CD_VAL(+)
UNION ALL
SELECT A.BASE_DT ,
A.BII_BR_CD BR_CD ,
B.KFM_BI_MBR_CD MBR_CD ,
B.KFM_BI_BR_CD BI_BR_CD ,
A.BII_BR_CD
|| A.ACCT_NO
|| A.CURR_CD ANT_AGREE_NO ,
CASE
	WHEN A.BII_BR_CD LIKE '7%'
	OR A.BII_BR_CD = '989'
	THEN 'S'
	ELSE 'K'
END JENIS_USAHA ,
'' ANT_OFFICE_CD ,
B.KFM_SCOMMENT ,
NVL(CD_AAK.RESERVE1, A.PRD_CATG ) PRD_CATG ,
'' ANT_JENIS_AKAD_SY ,
A.CURR_CD CURR_CD ,
'' ANT_JANGKA_WAKTU,
A.INT_RT INT_RT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN ABS(A.IDR_PMON_OS_BAL)
	ELSE 0
END IDR_PMON_OS_BAL ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.MON_DR_TX_AMT*IDR_XRT
	ELSE 0
END IDR_MON_DR_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.MON_CR_TX_AMT*IDR_XRT
	ELSE 0
END IDR_MON_CR_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN ABS(A.IDR_OS_BAL) - ABS(A.IDR_PMON_OS_BAL) - ( (A.MON_DR_TX_AMT - A.MON_CR_TX_AMT) * IDR_XRT)
	ELSE 0
END IDR_MON_OT_TX_AMT ,
ABS(A.IDR_OS_BAL),
:v_job_bs_dt ORG_PRC_DT
FROM FM_BAS_DEPMSTD A,
SUM_STSIBRCHAD B,
SUM_STSIBRCHAD D,
(SELECT CD_VAL, RESERVE1 FROM RDMDEV.RDM_MNT_CMNCD WHERE CD_KEY = 'AAAK1'
) CD_AAK
WHERE B.BR_CD           = A.BII_BR_CD
AND A.BASE_YM           = SUBSTR(:v_job_bs_dt,0,6)
AND A.BASE_DT           = :v_job_bs_dt
AND B.BASE_DT           = :v_job_bs_dt
AND A.OVRS_FG           = '1'
AND A.ASSET_LBLT_IDCT   = 'A'
AND NVL(A.IDR_OS_BAL,0) < 0
AND A.ACCT_NO LIKE '299999%'
AND D.BASE_DT(+)   = :v_job_bs_dt
AND D.BR_CD(+)     = SUBSTR(A.ACCT_NO,7,3)
AND D.KFM_BR_TP(+) = '2'
AND A.PRD_CATG     =CD_AAK.CD_VAL(+)
UNION ALL
SELECT A.BASE_DT ,
A.BII_BR_CD BR_CD ,
B.KFM_BI_MBR_CD MBR_CD ,
B.KFM_BI_BR_CD BI_BR_CD ,
A.AGREE_ID ANT_AGREE_NO ,
CASE
	WHEN A.BII_BR_CD LIKE '7%'
	OR A.BII_BR_CD = '989'
	THEN 'S'
	ELSE 'K'
END JENIS_USAHA ,
'' ANT_OFFICE_CD ,
B.KFM_SCOMMENT ,
NVL(CD_AAK.RESERVE1, A.PRD_CATG ) PRD_CATG ,
'' ANT_JENIS_AKAD_SY ,
A.CURR_CD ,
'' ANT_JANGKA_WAKTU,
A.INT_RT INT_RT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN ABS(NVL(A.IDR_PMON_OS_BAL,0))
	ELSE 0
END IDR_PMON_OS_BAL ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.IDR_MON_DR_TX_AMT
	ELSE 0
END IDR_MON_DR_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.IDR_MON_CR_TX_AMT
	ELSE 0
END IDR_MON_CR_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.IDR_MON_OT_TX_AMT
	ELSE 0
END IDR_MON_OT_TX_AMT ,
ABS(A.IDR_OS_BAL) IDR_OS_BAL,
:v_job_bs_dt ORG_PRC_DT
FROM FM_NOA_INTOFFCMSTD A,
/* LBU FRM 19 */
SUM_STSIBRCHAD B,
FM_MNT_COA C,
(SELECT CD_VAL, RESERVE1 FROM RDMDEV.RDM_MNT_CMNCD WHERE CD_KEY = 'AAAK1'
) CD_AAK
WHERE A.base_dt      = :v_job_bs_dt
AND A.BASE_DT        = B.BASE_DT
AND B.BR_CD          = A.BII_BR_CD
AND A.COA_CD         = C.COA_CD
AND B.KFM_BI_MBR_CD IN ('113', '136', '239')
AND A.CONF_YN        = '1'
AND A.OS_BAL         < 0
AND A.OFF_CD         = '999'
AND (A.COA_CD LIKE '1122%'
OR A.COA_CD LIKE '2440%')
AND C.COA_TP                            = 'LBU'
AND DECODE(A.CURR_CD,'IDR','IDR','FCY') = C.CURR_CD
AND A.PRD_CATG                          =CD_AAK.CD_VAL(+)
UNION ALL
SELECT A.BASE_DT ,
A.BII_BR_CD BR_CD ,
B.KFM_BI_MBR_CD MBR_CD ,
B.KFM_BI_BR_CD BI_BR_CD ,
A.AGREE_ID ANT_AGREE_NO ,
CASE
	WHEN A.BII_BR_CD LIKE '7%'
	OR A.BII_BR_CD = '989'
	THEN 'S'
	ELSE 'K'
END JENIS_USAHA ,
'' OFF_CD ,
B.KFM_SCOMMENT ,
NVL(CD_AAK.RESERVE1, A.PRD_CATG ) PRD_CATG ,
'' ANT_JENIS_AKAD_SY ,
A.CURR_CD CURR_CD ,
'' ANT_JANGKA_WAKTU,
A.INT_RT INT_RT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN ABS(NVL(A.IDR_PMON_OS_BAL,0))
	ELSE 0
END IDR_PMON_OS_BAL ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.IDR_MON_DR_TX_AMT
	ELSE 0
END IDR_MON_DR_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.IDR_MON_CR_TX_AMT
	ELSE 0
END IDR_MON_CR_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.IDR_MON_OT_TX_AMT
	ELSE 0
END IDR_MON_OT_TX_AMT ,
ABS(NVL(IDR_OS_BAL,0)),
:v_job_bs_dt ORG_PRC_DT
FROM FM_NOA_INTOFFCMSTD A,
SUM_STSIBRCHAD B
/* LBU FRM 20 */
,
(SELECT CD_VAL, RESERVE1 FROM RDMDEV.RDM_MNT_CMNCD WHERE CD_KEY = 'AAAK1'
) CD_AAK
WHERE B.BR_CD = A.BII_BR_CD
AND A.BASE_YM = SUBSTR(:v_job_bs_dt,0,6)
AND A.BASE_DT = :v_job_bs_dt
AND B.BASE_DT = :v_job_bs_dt
AND (A.COA_CD LIKE '1122%'
OR A.COA_CD LIKE '2440%')
AND A.OFF_CD <> '999'
AND A.CONF_YN = 1
AND
CASE
	WHEN A.COA_CD LIKE '2440%'
	THEN A.IDR_OS_BAL
	ELSE -1
END          < 0
AND A.PRD_CATG =CD_AAK.CD_VAL(+)
UNION ALL
--sqdouble
SELECT :v_job_bs_dt BASE_DT ,
A.BR_CD BR_CD ,
B.KFM_BI_MBR_CD MBR_CD ,
B.KFM_BI_BR_CD BI_BR_CD ,
A.BR_CD
|| A.COA_CD
|| A.CURR_CD ANT_AGREE_NO ,
CASE
	WHEN A.BR_CD LIKE '7%'
	OR A.BR_CD = '989'
	THEN 'S'
	ELSE 'K'
END JENIS_USAHA ,
'' KFM_OFF_CD ,
B.KFM_SCOMMENT ,
'' PRD_CATG ---,TRIM(PRD_CATG)
,
'' ANT_JENIS_AKAD_SY ,
A.CURR_CD ,
'' ANT_JANGKA_WAKTU,
0 INT_RT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN PM_MST.YTD_MAP_XBAL
	ELSE 0
END IDR_PMON_OS_BAL ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN (A.nor_db_amt + A.bak_db_amt + NVL(DECODE(dt.mon_yn,'Y', pd_mst.mon_dr_tx_amt,0),0) ) * A.XRT
	ELSE 0
END IDR_DB_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN (A.nor_cr_amt + A.bak_cr_amt + NVL(DECODE(dt.mon_yn,'Y', pd_mst.mon_cr_tx_amt,0),0) ) * A.XRT
	ELSE 0
END IDR_CR_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.ytd_curt_xbal - (NVL(pm_mst.ytd_curt_Xbal,0) + (A.tx_db_amt * A.xrt - A.tx_cr_amt * A.xrt) )
	ELSE 0
END IDR_OT_TX_AMT ,
NVL(A.YTD_MAP_XBAL, 0) IDR_OS_BAL,
:v_job_bs_dt ORG_PRC_DT
FROM FDM_OBJ_LGMSTM A ---FM_BAS_APPSLMSTD A,         /* LBU FRM 19*/
,
SUM_STSIBRCHAD B ,
(SELECT BASE_DT,
	BR_CD
	|| COA_CD
	|| CURR_CD AGREE_ID ,
	TX_CR_AMT MON_CR_TX_AMT,
	TX_DB_AMT MON_DR_TX_AMT,
	YTD_CURT_XBAL,
	YTD_MAP_XBAL
FROM FDM_OBJ_LGMSTD
WHERE BASE_DT = :v_job_bs_dt
) PM_MST ,
(SELECT BASE_DT,
	BR_CD
	|| COA_CD
	|| CURR_CD AGREE_ID ,
	TX_CR_AMT MON_CR_TX_AMT,
	TX_DB_AMT MON_DR_TX_AMT
FROM FDM_OBJ_LGMSTD
WHERE BASE_DT =
	(SELECT distinct BFR_BZ_DT FROM EDW_BZDTMNG WHERE BZ_DT = :v_job_bs_dt
	) ---:v_job_bs_dt
) PD_MST ,
(SELECT DECODE(SUBSTR(:v_job_bs_dt,1,6), SUBSTR(:v_job_bs_dt,1,6), 'Y','N' ) MON_YN,
	DECODE(SUBSTR(:v_job_bs_dt,1,4), SUBSTR(:v_job_bs_dt,1,4), 'Y','N' ) YEAR_YN
FROM dual
) DT
WHERE A.YTD_MAP_XBAL <> 0
AND A.BASE_YM         = SUBSTR(:v_job_bs_dt,0,6)
---AND A.ADJ_CL     = '1'  -- bye
--AND A.COA_TP     = 'LBU'
AND SUBSTR(A.MAP_ID, 0, 5) = '01.18' --AND A.POS_FRM_NO = 'FA-19-00' -- Position Form Numbera
--AND A.TAR_FMTR_FG= '0'  -- Target
AND A.BASE_YM IS NOT NULL
--AND A.ZBAL_FG IS NULL
AND :v_job_bs_dt     = B.BASE_DT
AND A.BR_CD = B.BR_CD
AND A.BR_CD
|| A.COA_CD
|| A.CURR_CD = pm_mst.AGREE_ID(+)
AND A.BR_CD
|| A.COA_CD
|| A.CURR_CD = pd_mst.AGREE_ID(+)
UNION ALL
SELECT :v_job_bs_dt BASE_DT ,
A.BR_CD BR_CD ,
B.KFM_BI_MBR_CD MBR_CD ,
B.KFM_BI_BR_CD BI_BR_CD ,
A.BR_CD
|| A.COA_CD
|| A.CURR_CD ANT_AGREE_NO ,
CASE
	WHEN A.BR_CD LIKE '7%'
	OR A.BR_CD = '989'
	THEN 'S'
	ELSE 'K'
END JENIS_USAHA ,
'' KFM_OFF_CD ,
B.KFM_SCOMMENT ,
'' PRD_CATG ---,A.PRD_CATG                  PRD_CATG
,
'' ANT_JENIS_AKAD_SY ,
A.CURR_CD CURR_CD ,
'' ANT_JANGKA_WAKTU,
0 INT_RT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN PM_MST.YTD_MAP_XBAL
	ELSE 0
END IDR_PMON_OS_BAL ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN (A.nor_db_amt + A.bak_db_amt + NVL(DECODE(dt.mon_yn,'Y', pd_mst.mon_dr_tx_amt,0),0) ) * A.XRT
	ELSE 0
END IDR_DB_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN (A.nor_cr_amt + A.bak_cr_amt + NVL(DECODE(dt.mon_yn,'Y', pd_mst.mon_cr_tx_amt,0),0) ) * A.XRT
	ELSE 0
END IDR_CR_TX_AMT ,
CASE
	WHEN NVL(B.KFM_SCOMMENT,'XX') <> 'ID'
	THEN A.ytd_curt_xbal - (NVL(pm_mst.ytd_curt_xbal,0) + (A.tx_db_amt * A.xrt - A.tx_cr_amt * A.xrt) )
	ELSE 0
END IDR_OT_TX_AMT ,
NVL(A.YTD_MAP_XBAL, 0) IDR_OS_BAL,
:v_job_bs_dt ORG_PRC_DT
FROM FDM_OBJ_LGMSTM A ---FM_BAS_APPSLMSTD A        /* LBU FRM 20*/
,
SUM_STSIBRCHAD B ,
SUM_STSIBRCHAD D ,
(SELECT BASE_DT,
	BR_CD
	|| COA_CD
	|| CURR_CD AGREE_ID ,
	TX_CR_AMT MON_CR_TX_AMT,
	TX_DB_AMT MON_DR_TX_AMT,
	YTD_CURT_XBAL,
	YTD_MAP_XBAL
FROM FDM_OBJ_LGMSTD
WHERE BASE_DT = :v_job_bs_dt
) PM_MST ,
(SELECT BASE_DT,
	BR_CD
	|| COA_CD
	|| CURR_CD AGREE_ID ,
	TX_CR_AMT MON_CR_TX_AMT,
	TX_DB_AMT MON_DR_TX_AMT
FROM FDM_OBJ_LGMSTD
WHERE BASE_DT =
	(SELECT BFR_BZ_DT FROM EDW_BZDTMNG WHERE BZ_DT = :v_job_bs_dt
	) ---:v_job_bs_dt
) PD_MST ,
(SELECT DECODE(SUBSTR(:v_job_bs_dt,1,6), SUBSTR(:v_job_bs_dt,1,6), 'Y','N' ) MON_YN,
	DECODE(SUBSTR(:v_job_bs_dt,1,4), SUBSTR(:v_job_bs_dt,1,4), 'Y','N' ) YEAR_YN
FROM dual
) DT
WHERE B.BR_CD = A.BR_CD
AND A.BASE_YM = SUBSTR(:v_job_bs_dt,0,6)
---AND A.BASE_DT         =     :v_job_bs_dt
AND B.BASE_DT = :v_job_bs_dt
--AND ASSET_LBLT_IDCT = 'A' bye
AND A.COA_CD LIKE '2440%' ---AND AGREE_NO LIKE '2440%'
AND A.BR_CD = D.BR_CD
--AND ADJ_CL = '1'   bye
AND A.BR_CD      = '999'
AND YTD_CURT_BAL < 0
AND D.BR_CD(+)   = A.BR_CD
AND D.BASE_DT(+) = :v_job_bs_dt
AND A.BR_CD
|| A.COA_CD
|| A.CURR_CD = pm_mst.AGREE_ID(+)
AND A.BR_CD
|| A.COA_CD
|| A.CURR_CD     = pd_mst.AGREE_ID(+)
AND D.KFM_BR_TP(+) = '2';
