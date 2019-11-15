INSERT INTO TEMP_incident_combined
SELECT 
    req.recid,
    req.number,
    req.system,
    e.company AS company,
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
    req.ownerteam,
    REPLACE(req.owner,'.',' ') as owner,
    --owneremail,    
    NULL AS causecode,
    req.createdby,
    req.createddatetime,
    NULL as resolvingteam,
    --resolvedby,
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
        WHEN ISNULL(req.breachpassed,0) = 1 THEN 4
        WHEN ISNULL(req.l3passed,0) = 1 THEN 3
        WHEN ISNULL(req.l2passed,0) = 1 THEN 2
        WHEN ISNULL(req.l1passed,0) = 1 THEN 1
        ELSE 0 
    END AS breachstatus,
    req.L1DateTime,
    req.L1Passed,
    req.L2DateTime,
    req.L2Passed,
    req.L3DateTime,
    req.L3Passed,
    req.BreachDateTime,
    req.BreachPassed as breachpassed,
    req.targetclockduration,
    req.totalrunningduration,

    req.response_breached  AS response_breachpassed,
    req.response_targetclockduration,
    req.response_totalrunningduration,

    'Service Request' as typeofincident,
    NULL AS reopencount,
    NULL AS remoteresolution,
    NULL AS resolution,
    NULL AS technicalresolution,  
    NULL AS numberofusersaffected,
    NULL AS repeatissue,          
    NULL AS problem_id,
    NULL AS parentincident_id
FROM
    dbo.heatsm_servicereq req

    LEFT JOIN dbo.heatsm_employee e ON (e.recid = req.profilelink)

    LEFT JOIN (
    
        SELECT
        parentlink,
        owner,
        ROW_NUMBER() OVER (PARTITION BY parentlink ORDER BY COUNT(*) DESC) as pos

        FROM
        dbo.heatsm_task TSK

        WHERE
            status <> 'Cancelled' AND owner <> ''        

        group by
        parentlink,
        owner

    ) tsk ON (tsk.parentlink = req.recid)

WHERE
    ISNULL(tsk.pos,-1) IN (1,-1)