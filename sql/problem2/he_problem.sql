INSERT INTO TEMP_problem_combined
SELECT
	prb.sys_id AS recid,
	prb.[number],
	prb.[system],
	prb.company,
	NULL AS [location],
	users.name AS customer,
	prb.[subject],
	prb.[priority],
	prb.[status],
	prb.[source],
    prb.[category],
    prb.[subcategory],
	prb.[ownerteam],
	prb.[owner],
	--[owneremail],
	prb.problemsource AS problemsource,
	prb.[createdby],
	prb.[createddatetime],
	prb.[closedby],
	prb.[closeddatetime],
	prb.[lastmodby],
	prb.[lastmoddatetime],
	prb.duedate,
	LEFT(prb.worknotes,500) AS worknotes,
	NULL AS businessunit
FROM
	[dbo].[he_problem] prb
	LEFT JOIN [dbo].[HE_sys_user] users ON (users.sys_id = prb.customer_id)