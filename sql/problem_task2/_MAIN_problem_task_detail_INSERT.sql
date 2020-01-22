

INSERT DETAIL_problem_task
SELECT
		NULLIF(tsk.[recid],'') AS [recid]
		,NULLIF(tsk.[number],'') AS [number]
		,NULLIF(tsk.[system],'') AS [system]
		,NULLIF(tsk.[subject],'') AS [subject]
		,NULLIF(tsk.[priority],'') AS [priority]
		,NULLIF(tsk.[status],'') AS [status]
		,NULLIF(tsk.[ownerteam],'') AS [ownerteam]
		,replace(LEFT(tsk.[owner],len(tsk.[owner])-charindex('@',reverse(tsk.[owner]))),'.',' ') AS [owner_Format]
		,replace(LEFT(tsk.[createdby],len(tsk.[createdby])-charindex('@',reverse(tsk.[createdby]))),'.',' ') AS [createdby_Format]
		,NULLIF(tsk.[createddatetime],'') AS [createddatetime]
		,CONVERT(DATE,tsk.[createddatetime]) AS [createddate_Format]
		,replace(LEFT(NULLIF(tsk.[resolvedby],''),len(tsk.[resolvedby])-charindex('@',reverse(tsk.[resolvedby]))),'.',' ') AS [resolvedby_Format]
		,NULLIF(tsk.[resolveddatetime],'') AS [resolveddatetime]
		,CONVERT(DATE,tsk.[resolveddatetime]) AS [resolveddate_Format]

		,replace(LEFT(NULLIF(tsk.[lastmodby],''),len(tsk.[lastmodby])-charindex('@',reverse(tsk.[lastmodby]))),'.',' ') AS [lastmodby_Format]
		,NULLIF(tsk.[lastmoddatetime],'') AS [lastmoddatetime]
		,CONVERT(DATE,tsk.[lastmoddatetime]) AS [lastmoddate_Format]
		,ISNULL(prb.id,NULL) AS parentproblem_id

FROM	
	[dbo].[TEMP_problem_task_combined] tsk
    LEFT JOIN DETAIL_problem prb ON (prb.system = tsk.system AND prb.number = tsk.parentproblem_id)


WHERE NOT EXISTS
	(
		SELECT 
			recid, 
			system 
		FROM 
			DETAIL_problem_task d 

		WHERE 
			d.recid = tsk.recid AND d.system = tsk.system
	)

ORDER BY
	tsk.[createddatetime]
;