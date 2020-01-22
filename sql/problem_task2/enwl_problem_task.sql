INSERT INTO TEMP_problem_task_combined
SELECT --top 10
	tsk.recid,
	tsk.[number],
	'enwl' AS [system],
	tsk.[subject],
	tsk.[priority],
	tsk.[status],
	tsk.[ownerteam],
	tsk.[owner],
	tsk.[createdby],
	tsk.[createddatetime],
	tsk.[resolvedby] AS closedby,
	tsk.[resolveddatetime] AS closeddatetime,
	tsk.[lastmodby],
	tsk.[lastmoddatetime],
    prb.number AS [problemnumber]
FROM
	[dbo].[enwl_task] tsk
	LEFT JOIN dbo.enwl_problem prb ON (prb.recid = tsk.parentlink)
WHERE
	[parentlinkcategory] = 'problem'