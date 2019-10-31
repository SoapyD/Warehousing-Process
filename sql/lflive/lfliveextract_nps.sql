
IF OBJECT_ID(N'TEMP_nps') IS NOT NULL
    drop table TEMP_nps

SELECT
    sur.recid,
	'session' As type,
	sur.id,
	sur.rescuesessionid,
	sur.submittedat,
	CASE WHEN sur.comments = '' THEN NULL ELSE sur.comments END AS comments,
	spb.techname as technicianname,

	CASE
		WHEN fsa_ci.incidentnumber IS NOT NULL THEN fsa_ci.incidentnumber
		WHEN he_ci.incidentnumber IS NOT NULL THEN he_ci.incidentnumber
		WHEN mhclg_ci.incidentnumber IS NOT NULL THEN mhclg_ci.incidentnumber
		WHEN croy_ci.incidentnumber IS NOT NULL THEN croy_ci.incidentnumber
		WHEN enwl_ci.incidentnumber IS NOT NULL THEN enwl_ci.incidentnumber
		WHEN ISNULL(CONVERT(NVARCHAR,ci.incidentnumber), ISNULL(CONVERT(NVARCHAR,spb.cfield4),NULL)) IS NOT NULL THEN LEFT(ISNULL(CONVERT(NVARCHAR,ci.incidentnumber), ISNULL(CONVERT(NVARCHAR,spb.cfield4),NULL)),20)
		ELSE sur.incidentnumber
	END as incidentnumber,
	CASE
		WHEN spb.fsa_session = 1 THEN 'fsa'
		WHEN spb.he_session = 1 THEN 'he'
		WHEN spb.mhclg_session = 1 THEN 'mhclg'
		WHEN spb.croydon_session = 1 THEN 'croydon'
		WHEN spb.enwl_session = 1 THEN 'enwl'
	ELSE 'heat'
	END as system,

	nps,

	CASE 
		WHEN sur.nps IS NULL THEN NULL
		WHEN sur.nps between 0 and 6 then 'detractor'
		WHEN sur.nps between 7 and 8 then 'passive'
		WHEN sur.nps between 9 and 10 then 'promotor'
	END as npstype,

	--ROW_NUMBER() OVER (PARTITION BY sur.[rescuesessionid], sur.databasename ORDER BY sur.[submittedat] DESC) AS duplicate_check,
	sur.databasename

INTO
	TEMP_nps
FROM
	LFLIVEEXTRACT_completedsurvey sur

	LEFT JOIN [LFLIVEEXTRACT_sessionincident] ci ON (ci.sessionid = sur.rescuesessionid AND ci.databasename = sur.databasename)

	LEFT JOIN [LFLIVEEXTRACT_fsa_sessionincident] fsa_ci ON (fsa_ci.sessionid = sur.rescuesessionid AND fsa_ci.databasename = sur.databasename)

	LEFT JOIN [LFLIVEEXTRACT_he_sessionincident] he_ci ON (he_ci.sessionid = sur.rescuesessionid AND he_ci.databasename = sur.databasename)

	LEFT JOIN [LFLIVEEXTRACT_mhclg_sessionincident] mhclg_ci ON (mhclg_ci.sessionid = sur.rescuesessionid AND mhclg_ci.databasename = sur.databasename)

	LEFT JOIN [LFLIVEEXTRACT_croydon_sessionincident] croy_ci ON (croy_ci.sessionid = sur.rescuesessionid AND croy_ci.databasename = sur.databasename)

	LEFT JOIN [LFLIVEEXTRACT_enwl_sessionincident] enwl_ci ON (enwl_ci.sessionid = sur.rescuesessionid AND enwl_ci.databasename = sur.databasename)

	LEFT JOIN [LFLIVEEXTRACT_sessionpostback] spb ON (spb.sessionid = sur.rescuesessionid AND spb.databasename = sur.databasename)

	WHERE
		[rescuesessionid] <> 0

UNION ALL

SELECT
    sur.recid,
	'incident' As surveytype,
	sur.id,
	NULL AS rescuesessionid,
	sur.submittedat,
	sur.comments,
	NULL as technician,

	sur.incidentnumber,
	'heat' as system,

	nps,

	CASE 
		WHEN sur.nps IS NULL THEN NULL
		WHEN sur.nps between 0 and 6 then 'detractor'
		WHEN sur.nps between 7 and 8 then 'passive'
		WHEN sur.nps between 9 and 10 then 'promotor'
	END as npstype,

	--ROW_NUMBER() OVER (PARTITION BY sur.[incidentnumber], sur.databasename ORDER BY sur.[submittedat] DESC) AS duplicate_check,
	sur.databasename

FROM
	LFLIVEEXTRACT_completedsurvey sur

WHERE
	sur.incidentnumber <> ''