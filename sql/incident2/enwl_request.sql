INSERT INTO TEMP_incident_combined
SELECT 
    req.recid,
    req.number,
    req.system,
    req.company AS company,
    e.businessunit AS businessunit,
    CASE WHEN req.isvip = 'False' THEN 0 ELSE 1 END as isvip,
    e.location AS location,
    e.name AS customer,
    req.subject,
    NULL AS symptom,
    NULL AS priority,
    req.status,
    req.source,
    req.service,
    NULL AS category,
    NULL AS subcategory,
    NULL AS fcr,
    CASE WHEN req.ownerteam = 'Service Desk' THEN 'ENWL Service Desk' ELSE req.ownerteam END as ownerteam,
    REPLACE(req.owner,'.',' ') as owner,  
    NULL AS causecode,
    req.createdby,
    req.createddatetime,
    NULL as resolvingteam,
    CASE
        WHEN ISNULL(req.resolvedby,'') = '' THEN tsk.owner
        WHEN ISNULL(req.resolvedby,'') = 'InternalServices' THEN tsk.owner
        ELSE REPLACE(req.resolvedby,'.',' ') 
    END as resolvedby,

    req.resolveddatetime,
    req.closedby,
    req.closeddatetime,
    req.lastmodby,
    req.lastmoddatetime,
    CASE
        WHEN ISNULL(res.breachpassed,0) = 1 THEN 4
        WHEN ISNULL(res.l3passed,0) = 1 THEN 3
        WHEN ISNULL(res.l2passed,0) = 1 THEN 2
        WHEN ISNULL(res.l1passed,0) = 1 THEN 1
        ELSE 0 
    END AS breachstatus,
    res.L1DateTime,
    res.L1Passed,
    res.L2DateTime,
    res.L2Passed,
    res.L3DateTime,
    res.L3Passed,
    res.BreachDateTime,
    CASE WHEN res.BreachPassed = 0 THEN 0 ELSE 1 END as breachpassed,
    res.targetclockduration,
    res.totalrunningduration,

    CASE WHEN resp.BreachPassed = 0 THEN 0 ELSE 1 END  AS response_breachpassed,
    resp.targetclockduration AS response_targetclockduration,
    resp.totalrunningduration AS response_totalrunningduration,

    'Service Request' as typeofincident,
    NULL AS reopencount,
    NULL AS remoteresolution,
    NULL AS resolution,
    NULL AS technicalresolution,  
    NULL AS numberofusersaffected,
    NULL AS repeatissue,  
    NULL AS breachreason,
    NULL AS cancellationreason,      
    NULL AS prioritychangecount,              
    NULL AS problem_id,
    NULL AS parentincident_id
FROM
    dbo.enwl_servicereq req

    LEFT JOIN dbo.enwl_employee e ON (e.recid = req.profilelink)

    
    LEFT JOIN (
    
        SELECT
        parentlink,
        owner,
        ROW_NUMBER() OVER (PARTITION BY parentlink ORDER BY COUNT(*) DESC) as pos

        FROM
        dbo.enwl_task TSK

        WHERE
            status <> 'Cancelled' AND owner <> ''        

        group by
        parentlink,
        owner

    ) tsk ON (tsk.parentlink = req.recid)
    /**/

    LEFT JOIN dbo.enwl_frs_data_escalation_watch res ON (res.recid = req.resolutionesclink)
    LEFT JOIN dbo.enwl_frs_data_escalation_watch resp ON (resp.recid = req.responseesclink)

WHERE
    ISNULL(tsk.pos,-1) IN (1,-1)