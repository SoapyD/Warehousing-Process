INSERT INTO TEMP_problem_combined
SELECT
	prb.recid as recid,
	prb.number AS number,
	[system],
	prb.company,
	ISNULL(e.[location],NULL) AS location,
	ISNULL(e.name,NULL) AS customer,
	prb.[subject],
	prb.[priority],
	prb.[status],
	NULL AS [source],
    prb.[category],
    prb.[subcategory],
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
	LEFT(prb.recentnote,500) AS [worknotes],
	NULL AS businessunit
FROM
	[dbo].[heatsm_problem] prb
	LEFT JOIN [dbo].[heatsm_employee] e ON (e.recid = prb.profilelink)