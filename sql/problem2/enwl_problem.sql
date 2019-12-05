INSERT INTO TEMP_problem_combined
SELECT
	prb.recid as recid,
	prb.number AS number,
	'enwl' AS system, --[system],
	'Electricity North West' AS company, --prb.company,
	NULL AS location, --ISNULL(e.[location],NULL) AS location,
	NULL AS customer, --ISNULL(e.name,NULL) AS customer,
	prb.[subject],
	prb.[priority],
	prb.[status],
	NULL AS [source],
    prb.[category],
    NULL AS subcategory, --prb.[subcategory],
    CASE WHEN prb.ownerteam = 'Service Desk' THEN 'ENWL Service Desk' ELSE prb.ownerteam END as ownerteam,
	prb.[owner],
	--NULL AS [owneremail],
	prb.[source] AS problemsource,
	prb.[createdby],
	prb.[createddatetime],
	prb.[closedby],
	prb.[closeddatetime],
	prb.[lastmodby],
	prb.[lastmoddatetime],
	NULL as duedate,
	NULL as worknotes, --prb.recentnote AS [worknotes],
	NULL AS businessunit
FROM
	[dbo].[enwl_problem] prb
	--LEFT JOIN [dbo].[enwl_employee] e ON (e.recid = prb.profilelink)