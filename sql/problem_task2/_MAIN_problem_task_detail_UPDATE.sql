


UPDATE DETAIL_problem_task
SET
    recid = T2.recid,
    number = T2.number,
    system = T2.system,
    subject = T2.subject,
    priority = T2.priority,
    status = T2.status,
    ownerteam = T2.ownerteam,
    owner_Format = T2.owner_Format,
    createdby_Format = T2.createdby_Format,
    createddatetime = T2.createddatetime,
    createddate_Format = T2.createddate_Format,
    resolvedby_Format = T2.resolvedby_Format,
    resolveddatetime = T2.resolveddatetime,
    resolveddate_Format = T2.resolveddate_Format,
    lastmodby_Format = T2.lastmodby_Format,
    lastmoddatetime = T2.lastmoddatetime,
    lastmoddate_Format = T2.lastmoddate_Format,
    parentproblem_id = T2.parentproblem_id

FROM   
	DETAIL_problem_task T1
    JOIN 
    (

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

    ) T2
    ON (T1.recid = T2.recid AND T1.system = T2.system)