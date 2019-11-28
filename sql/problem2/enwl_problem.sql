SELECT
	prb.recid as recid,
	prb.number AS number,
	'ENWL' AS system, --[system],
	'Electricity North West' AS company, --prb.company,
	NULL AS location, --ISNULL(e.[location],NULL) AS location,
	NULL AS customer, --ISNULL(e.name,NULL) AS customer,
	prb.[subject],
	prb.[priority],
	prb.[status],
	NULL AS [source],
    prb.[category],
    NULL AS subcategory, --prb.[subcategory],
	prb.[ownerteam],
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