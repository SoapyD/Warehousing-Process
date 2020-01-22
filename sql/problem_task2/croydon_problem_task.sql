INSERT INTO TEMP_problem_task_combined
SELECT
	tsk.sys_id,
	tsk.[number],
	tsk.[system],
	tsk.[subject],
	tsk.[priority],
	tsk.[status],
	tsk.[ownerteam],
	tsk.[owner],
	tsk.[createdby],
	tsk.[createddatetime],
	tsk.[closedby],
	tsk.[closeddatetime],
	tsk.[lastmodby],
	tsk.[lastmoddatetime],
    PRB.number
FROM
	[dbo].[croydon_problem_task] TSK
	LEFT JOIN [dbo].[croydon_problem] PRB on (PRB.sys_id = tsk.problem_id)