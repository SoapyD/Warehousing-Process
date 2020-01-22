INSERT INTO TEMP_problem_task_combined
SELECT
	tsk.recid,
	tsk.[number],
	'heat' AS [system],
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
	[dbo].[HEATSM_task] tsk
	LEFT JOIN dbo.heatsm_problem prb ON (prb.recid = tsk.parentlink)	
WHERE
	parentlinkCategory = 'problem'